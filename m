From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
 VFIO_IOMMU_TYPE1
Date: Fri, 06 Mar 2015 07:46:22 -0700
Message-ID: <1425653182.5200.379.camel@redhat.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
 <1425491104.5200.268.camel@redhat.com> <54F893C3.6020006@linaro.org>
 <1425589915.5200.336.camel@redhat.com> <54F96D96.8040207@linaro.org>
 <20150306104148.GC22377@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB9E347E6D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:40:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uhkKsKyl50iW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 09:40:22 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB1F047E6B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 09:40:22 -0500 (EST)
In-Reply-To: <20150306104148.GC22377@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 2015-03-06 at 10:41 +0000, Will Deacon wrote:
> > As a longer term solution, would it make sense to add a user flag at VFIO
> > user API level to turn the IOMMU_CACHE on?
> 
> I think userspace certainly needs a way to figure out if a device is
> coherent or not, otherwise it can't generate the correct device-tree
> properties for something like a KVM guest but the IOMMU_* setting should
> remain in the kernel IMO. Similarly for things like MSI pages, which would
> need to be mapped as device memory on ARM -- that should be exposed as a
> higher level "please map my MSI page here" ioctl as opposed to requiring
> userspace to supply the correct memory attributes.

Userspace already has a way to determine if all the IOMMUs for a
container support cache coherence, as does KVM via the kvm-vfio pseudo
device.  It's inadvisable to allow userspace to control whether
IOMMU_CACHE is used on x86 as emulating cache sync instructions hurts
the overall system performance.  We don't want users to arbitrarily
decide to enable those heavy-weight operations.  Thanks,

Alex
