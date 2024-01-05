import moment from 'moment'
import 'moment-timezone'
import { Jobs } from '../worker/jobs'
import {
  VolunteerContactInfo,
  updateVolunteerSentInactive30DayEmail,
  updateVolunteerSentInactive60DayEmail,
  updateVolunteerSentInactive90DayEmail,
} from '../models/Volunteer'
import {
  clearAvailabilityForVolunteer,
  saveCurrentAvailabilityAsHistory,
} from '../models/Availability'
import * as MailService from '../services/MailService'
import { getInactiveVolunteers } from '../models/Volunteer/queries'
import { BLACKOUT_PERIOD_START, BLACKOUT_PERIOD_END } from '../constants'
import { Job } from 'bull'
import { asString } from '../utils/type-utils'
import { log } from '../worker/logger'

type BackfillEmailVolunteersInactiveData = {
  startDate: string
}

export default async function BackfillEmailVolunteerInactive(
  job: Job<BackfillEmailVolunteersInactiveData>
): Promise<void> {
  const start = new Date(asString(job.data.startDate))

  const blackoutPeriodStart = BLACKOUT_PERIOD_START.getTime()
  const blackoutPeriodEnd = BLACKOUT_PERIOD_END.getTime()

  const todaysDate = new Date(start).getTime()
  if (todaysDate >= blackoutPeriodStart && todaysDate <= blackoutPeriodEnd) {
    console.log(
      `Skipping ${Jobs.EmailVolunteerInactive} because today's date, ${new Date(
        todaysDate
      ).toISOString()}, is within the blackout period: ${new Date(
        blackoutPeriodStart
      ).toISOString()} - ${new Date(blackoutPeriodEnd).toISOString()}`
    )
    return
  }

  const thirtyDaysAgoStartOfDay = getStartOfDayFromDaysAgo(start, 30)
  const thirtyDaysAgoEndOfDay = getEndOfDayFromDaysAgo(start, 30)
  const sixtyDaysAgoStartOfDay = getStartOfDayFromDaysAgo(start, 60)
  const sixtyDaysAgoEndOfDay = getEndOfDayFromDaysAgo(start, 60)
  const ninetyDaysAgoStartOfDay = getStartOfDayFromDaysAgo(start, 90)
  const ninetyDaysAgoEndOfDay = getEndOfDayFromDaysAgo(start, 90)

  const volunteers = await getInactiveVolunteers(
    thirtyDaysAgoStartOfDay,
    thirtyDaysAgoEndOfDay,
    sixtyDaysAgoStartOfDay,
    sixtyDaysAgoEndOfDay,
    ninetyDaysAgoStartOfDay,
    ninetyDaysAgoEndOfDay
  )

  if (volunteers) {
    const {
      inactiveThirtyDays,
      inactiveSixtyDays,
      inactiveNinetyDays,
    } = volunteers
    const errors = []
    try {
      await sendEmailToInactiveVolunteers(
        inactiveThirtyDays,
        Jobs.EmailVolunteerInactiveThirtyDays,
        MailService.sendVolunteerInactiveThirtyDays,
        InactiveGroup.inactiveThirtyDays
      )
    } catch (error) {
      if (Array.isArray(error)) errors.push(...error)
    }
    try {
      await sendEmailToInactiveVolunteers(
        inactiveSixtyDays,
        Jobs.EmailVolunteerInactiveSixtyDays,
        MailService.sendVolunteerInactiveSixtyDays,
        InactiveGroup.inactiveSixtyDays
      )
    } catch (error) {
      if (Array.isArray(error)) errors.push(...error)
    }
    try {
      await sendEmailToInactiveVolunteers(
        inactiveNinetyDays,
        Jobs.EmailVolunteerInactiveNinetyDays,
        MailService.sendVolunteerInactiveNinetyDays,
        InactiveGroup.inactiveNinetyDays
      )
    } catch (error) {
      if (Array.isArray(error)) errors.push(...error)
    }
    if (errors.length) {
      throw new Error(`Failed to send inactivity emails: ${errors}`)
    }
  }
}

enum InactiveGroup {
  inactiveThirtyDays = 'inactiveThirtyDays',
  inactiveSixtyDays = 'inactiveSixtyDays',
  inactiveNinetyDays = 'inactiveNinetyDays',
}

async function sendEmailToInactiveVolunteers(
  volunteers: VolunteerContactInfo[],
  currentJob: Jobs,
  mailHandler: Function,
  group: InactiveGroup
) {
  for (const volunteer of volunteers) {
    const { email, firstName, id } = volunteer
    const errors = []
    try {
      const contactInfo = { email, firstName }
      await mailHandler(contactInfo)
      if (group === InactiveGroup.inactiveThirtyDays)
        await updateVolunteerSentInactive30DayEmail(id)
      if (group === InactiveGroup.inactiveSixtyDays)
        await updateVolunteerSentInactive60DayEmail(id)
      if (group === InactiveGroup.inactiveNinetyDays) {
        await updateVolunteerSentInactive90DayEmail(id)
        await saveCurrentAvailabilityAsHistory(id)
        await clearAvailabilityForVolunteer(id)
      }
      log(`Sent ${currentJob} to volunteer ${id}`)
    } catch (error) {
      errors.push(`${currentJob} to volunteer ${id}: ${error}`)
    }
    if (errors.length) {
      throw errors
    }
  }
}

function getStartOfDayFromDaysAgo(start: Date, daysAgo: number): Date {
  return moment(start)
    .utc()
    .subtract(daysAgo, 'days')
    .startOf('day')
    .toDate()
}

function getEndOfDayFromDaysAgo(start: Date, daysAgo: number): Date {
  return moment(start)
    .utc()
    .subtract(daysAgo, 'days')
    .endOf('day')
    .toDate()
}
