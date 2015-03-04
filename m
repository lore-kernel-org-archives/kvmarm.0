From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v4 0/5] vfio: type1: support for ARM SMMUS with
 VFIO_IOMMU_TYPE1
Date: Wed, 04 Mar 2015 09:10:06 -0700
Message-ID: <1425485406.5200.233.camel@redhat.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
 <54F5F37E.2070002@linaro.org> <1425405715.5200.217.camel@redhat.com>
 <CAN9JPjEOHozQzQj9fdSww1ueC5yVdoBG=i=JYqDFMwNdosLvKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 459A447B4F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:04:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wzoUKGztl2bj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:04:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73EE047B39
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:04:35 -0500 (EST)
In-Reply-To: <CAN9JPjEOHozQzQj9fdSww1ueC5yVdoBG=i=JYqDFMwNdosLvKQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-03-04 at 16:21 +0100, Baptiste Reynal wrote:
> Thanks for your comments. A v5 is ongoing, with the removal of
> domain->caps, instead domain->domain->ops->capable(cap) is tested.

Doesn't that defeat the whole purpose of caching a subset of the mapping
flags on the domain?  I also hope we're not ignoring the abstraction of
the iommu api by following iommu_ops pointers directly.  Thanks,

Alex

> On Tue, Mar 3, 2015 at 7:01 PM, Alex Williamson <alex.williamson@redhat.com>
> wrote:
> 
> > On Tue, 2015-03-03 at 18:46 +0100, Eric Auger wrote:
> > > Hi Baptiste,
> > >
> > > In "vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag" you still
> > > kept domain->caps |= IOMMU_CAP_NOEXEC so potentially overwriting 1<<
> > > IOMMU_CAP_CACHE_COHERENCY I guess.
> > >
> > > Sorry I do not have this 4th patch file in my mailbox.
> > >
> > > Best Regards
> > >
> > > Eric
> > >
> > >       if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > >               domain->caps |= (1 << IOMMU_CAP_CACHE_COHERENCY);
> > >
> > >       if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
> > >               domain->caps |= IOMMU_CAP_NOEXEC;
> >
> >
> > Patch 4/5 has problems too, vfio_domains_have_iommu_cap() is called with
> > IOMMU_CAP_CACHE_COHERENCY, but nobody is shifting that into a bitmap
> > before doing the comparison.
> >
> > TBH, I don't see the point of creating this artificial bitmap out of the
> > capabilities.  Why can't we keep everything in the domain of actual
> > flags passed to iommu_ops functions?  It's just silly to test for cached
> > capability and re-invent the mapping flags on every mapping call and
> > it's just as easy to generalize a test using the actual flags as to use
> > the capabilities, perhaps easier.  Thanks,
> >
> > Alex
> >
> >
> >
> > > On 03/02/2015 05:58 PM, Baptiste Reynal wrote:
> > > > This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM,
> > so it
> > > > may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC
> > flag
> > > > supported by SMMUs adhering to the ARM SMMU specification so the VFIO
> > user can
> > > > specify whether the target memory can be executed by the device behind
> > the
> > > > SMMU.
> > > >
> > > > Changes from v3:
> > > >  - Rebased on linux v4.0-rc1
> > > >  - Use bit shifting for domain->caps
> > > >  - Baptiste Reynal is the new maintainer of this serie
> > > > Changes from v2:
> > > >  - Rebased on latest iommu/next branch by Joerg Roedel
> > > > Changes from v1:
> > > >  - Bugfixes and corrected some typos
> > > >  - Use enum for VFIO IOMMU driver capabilities
> > > >
> > > > Antonios Motakis (5):
> > > >   vfio: implement iommu driver capabilities with an enum
> > > >   vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
> > > >   vfio: type1: replace domain wide protection flags with supported
> > > >     capabilities
> > > >   vfio: type1: replace vfio_domains_have_iommu_cache with generic
> > > >     function
> > > >   vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
> > > >
> > > >  drivers/vfio/vfio_iommu_type1.c | 91
> > +++++++++++++++++++++++++++++------------
> > > >  include/uapi/linux/vfio.h       | 30 ++++++++------
> > > >  2 files changed, 81 insertions(+), 40 deletions(-)
> > > >
> > >
> > > _______________________________________________
> > > iommu mailing list
> > > iommu@lists.linux-foundation.org
> > > https://lists.linuxfoundation.org/mailman/listinfo/iommu
> >
> >
> >
> >
