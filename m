From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for a
	platform device
Date: Mon, 5 Oct 2015 11:42:38 +0200
Message-ID: <CAN9JPjF+gYJaxm1kO5c4Swps4TDKrHxJ3v-NP2D_YzEghkn1DA@mail.gmail.com>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
	<1443814099.26107.124.camel@redhat.com>
	<20151002202844.GD32011@cbox>
	<CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

In this patch series we want to wrap an already available kernel
interface to expose a device property to userspace, in order to keep
the code lighter on the userspace. We need those properties in VFIO as
VFIO grants the possibility to develop userspace drivers.

The sysfs doesn't seems to be ready for this kind of usage. We can
only find raw data that require heavy parsing. Here we retrieve
directly usable data and it can be extended later according to new
needs (as it is already done with ACPI).

This interface has been developed for VFIO and is currently bound to
it, though there is no special dependencies with it. We could make it
more generic, but I can only think of VFIO to use it.

On Sat, Oct 3, 2015 at 12:53 AM, Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 2 October 2015 at 21:28, Christoffer Dall
> <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> We discussed this for the purposes of ARM during SFO15 last week, and
>> basically arrived at the conclusion that the resonable thing to do is to
>> rely on sysfs device tree parsing in userspace.  We don't have a great
>> solution for ACPI yet, but we also don't know of any ACPI-only devices
>> that want platform device passthrough yet.
>
> I wasn't hugely happy with that approach though:
>  * it's DT specific and just won't work on ACPI platforms; implementing
>    features with a "needs DT" dependency seems like it will come back to
>    bite us later
>  * I don't really want to build in a lot of infrastructure into
>    QEMU to either build the DTC compiler into it or else introduce
>    a runtime dependency on the dtc binary, if this is just going
>    to be a stopgap solution until somebody says "has to work on
>    ACPI" and we need to do it some other way
>
> On the other hand I don't exactly have a better approach to suggest
> (except "don't do device passthrough for platform devices, insist
> on a real bus like PCI"...)
>
> thanks
> -- PMM
