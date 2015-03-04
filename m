From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH v4 0/5] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Wed, 4 Mar 2015 18:32:56 +0100
Message-ID: <CAN9JPjH7ZvbgCG5gRcnZaFYf=5kuXLvdFS4f3L7KT4hZOjVmZA@mail.gmail.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
	<54F5F37E.2070002@linaro.org>
	<1425405715.5200.217.camel@redhat.com>
	<CAN9JPjEOHozQzQj9fdSww1ueC5yVdoBG=i=JYqDFMwNdosLvKQ@mail.gmail.com>
	<1425485406.5200.233.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425485406.5200.233.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Actually the mapping flags are still cached on the domain, except for
IOMMU_NOEXEC (As it is used at user request).
I don't think the abstraction is ignored, since every abstraction
should implement capable.

The problem here is that IOMMU_NOEXEC can not be cached, but
IOMMU_CAP_NOEXEC has to be. Another solution could be a boolean in
vfio_domain ?

Thanks,
Baptiste

On Wed, Mar 4, 2015 at 5:10 PM, Alex Williamson
<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2015-03-04 at 16:21 +0100, Baptiste Reynal wrote:
>> Thanks for your comments. A v5 is ongoing, with the removal of
>> domain->caps, instead domain->domain->ops->capable(cap) is tested.
>
> Doesn't that defeat the whole purpose of caching a subset of the mapping
> flags on the domain?  I also hope we're not ignoring the abstraction of
> the iommu api by following iommu_ops pointers directly.  Thanks,
>
> Alex
>
>> On Tue, Mar 3, 2015 at 7:01 PM, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>
>> > On Tue, 2015-03-03 at 18:46 +0100, Eric Auger wrote:
>> > > Hi Baptiste,
>> > >
>> > > In "vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag" you still
>> > > kept domain->caps |= IOMMU_CAP_NOEXEC so potentially overwriting 1<<
>> > > IOMMU_CAP_CACHE_COHERENCY I guess.
>> > >
>> > > Sorry I do not have this 4th patch file in my mailbox.
>> > >
>> > > Best Regards
>> > >
>> > > Eric
>> > >
>> > >       if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
>> > >               domain->caps |= (1 << IOMMU_CAP_CACHE_COHERENCY);
>> > >
>> > >       if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
>> > >               domain->caps |= IOMMU_CAP_NOEXEC;
>> >
>> >
>> > Patch 4/5 has problems too, vfio_domains_have_iommu_cap() is called with
>> > IOMMU_CAP_CACHE_COHERENCY, but nobody is shifting that into a bitmap
>> > before doing the comparison.
>> >
>> > TBH, I don't see the point of creating this artificial bitmap out of the
>> > capabilities.  Why can't we keep everything in the domain of actual
>> > flags passed to iommu_ops functions?  It's just silly to test for cached
>> > capability and re-invent the mapping flags on every mapping call and
>> > it's just as easy to generalize a test using the actual flags as to use
>> > the capabilities, perhaps easier.  Thanks,
>> >
>> > Alex
>> >
>> >
>> >
>> > > On 03/02/2015 05:58 PM, Baptiste Reynal wrote:
>> > > > This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM,
>> > so it
>> > > > may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC
>> > flag
>> > > > supported by SMMUs adhering to the ARM SMMU specification so the VFIO
>> > user can
>> > > > specify whether the target memory can be executed by the device behind
>> > the
>> > > > SMMU.
>> > > >
>> > > > Changes from v3:
>> > > >  - Rebased on linux v4.0-rc1
>> > > >  - Use bit shifting for domain->caps
>> > > >  - Baptiste Reynal is the new maintainer of this serie
>> > > > Changes from v2:
>> > > >  - Rebased on latest iommu/next branch by Joerg Roedel
>> > > > Changes from v1:
>> > > >  - Bugfixes and corrected some typos
>> > > >  - Use enum for VFIO IOMMU driver capabilities
>> > > >
>> > > > Antonios Motakis (5):
>> > > >   vfio: implement iommu driver capabilities with an enum
>> > > >   vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
>> > > >   vfio: type1: replace domain wide protection flags with supported
>> > > >     capabilities
>> > > >   vfio: type1: replace vfio_domains_have_iommu_cache with generic
>> > > >     function
>> > > >   vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
>> > > >
>> > > >  drivers/vfio/vfio_iommu_type1.c | 91
>> > +++++++++++++++++++++++++++++------------
>> > > >  include/uapi/linux/vfio.h       | 30 ++++++++------
>> > > >  2 files changed, 81 insertions(+), 40 deletions(-)
>> > > >
>> > >
>> > > _______________________________________________
>> > > iommu mailing list
>> > > iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> > > https://lists.linuxfoundation.org/mailman/listinfo/iommu
>> >
>> >
>> >
>> >
>
>
>
