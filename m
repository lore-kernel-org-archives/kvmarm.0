From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
 VFIO_IOMMU_TYPE1
Date: Thu, 5 Mar 2015 11:16:24 +0100
Message-ID: <CAN9JPjEimOMW4U5-ZkF0kkQ9SLqj7i1gLhJuihLqAazCqN3a_w@mail.gmail.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
 <1425491104.5200.268.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D47047D15
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 05:10:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SN1KEGAmSI1x for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 05:10:20 -0500 (EST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
 [209.85.216.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D40447D13
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 05:10:20 -0500 (EST)
Received: by qcvx3 with SMTP id x3so13994638qcv.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Mar 2015 02:16:25 -0800 (PST)
In-Reply-To: <1425491104.5200.268.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 4, 2015 at 6:45 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Wed, 2015-03-04 at 17:07 +0100, Baptiste Reynal wrote:
>> This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM, so it
>> may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC flag
>> supported by SMMUs adhering to the ARM SMMU specification so the VFIO user can
>> specify whether the target memory can be executed by the device behind the
>> SMMU.
>
> Ok, so the differences between IOMMU_CACHE and IOMMU_NOEXEC are twofold.
> First is that when the IOMMU is IOMMU_CAP_CACHE_COHERENCY we always use
> IOMMU_CACHE for all mappings within the domain.  This is not a user
> provided mapping flag.  Second, if a device is added behind an IOMMU
> that is not IOMMU_CAP_CACHE_COHERENCY capable, this simply means that it
> needs to be managed as a separate domain within the same container.
> vfio_domains_have_iommu_cache() reports true only if all domains within
> the container support, and are therefore using, IOMMU_CACHE.
>
> On the other hand, IOMMU_NOEXEC is a feature, but not a global mapping
> flag for a domain.  There are potentially some mappings with it within a
> domain and some without, just like the IOMMU_READ/IOMMU_WRITE.  It's
> therefore a per-DMA mapping flag as you've implemented in patch 4.
> Second, as a user specified flag, support for it is mandatory.  If a
> device is added behind an IOMMU that does not support NOEXEC and NOEXEC
> mappings are in use, the device must be rejected from addition to the
> container.

Thanks for taking time to explain. That is also my understanding on those flags.

>
> Hopefully that's correct, because I think that's what the code does.
> The problem I have with the code is that I don't think it's acceptable
> to call iommu_ops.capable() directly.  This is breaking an abstraction
> of the IOMMU API.  The obvious problem with that is:
>
> bool iommu_capable(struct bus_type *bus, enum iommu_cap cap)
>
> I assume you're calling the op directly because of bus_type, but that's
> no excuse to misuse the API.  Our choice is either to try to extend the
> API, maybe create:
>
> bool iommu_domain_capable(struct iommu_domain *domain, enum iommu_cap cap)
>
> Or to use the available function by either caching the value when we do
> have a bus_type available to us, or storing or discovering bus_type.  It
> doesn't seem that terrible to cache it on the domain.  Be careful though
> that if a device imposing lack of NOEXEC on a domain is removed, the
> ability to do NOEXEC mappings should be reinstated.  That would be easy
> if we use separate vfio_domains to manage NOEXEC capable vs NOEXEC
> in-capable devices (like we do CACHE vs no-CACHE), but there's some
> additional overhead to do that since it implies a separate iommu_domain.
> Thanks,
>
> Alex
>

I understand the issue on the API here. I will go for extending the
iommu API with iommu_domain_capable, except if you have any reason to
push for the second solution.
