Return-Path: <SRS0=VRSS=UC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5136C04AB5
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 22:32:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3104025010
	for <kvmarm@archiver.kernel.org>; Mon,  3 Jun 2019 22:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3104025010
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA2340217;
	Mon,  3 Jun 2019 18:32:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kiMtV66Ph9pf; Mon,  3 Jun 2019 18:32:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811384A4CA;
	Mon,  3 Jun 2019 18:32:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3C54A3B4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 18:32:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ql5NOmBlEETP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jun 2019 18:32:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8D6F4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jun 2019 18:32:40 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 495A5C05D3F4;
 Mon,  3 Jun 2019 22:32:38 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3928964027;
 Mon,  3 Jun 2019 22:32:37 +0000 (UTC)
Date: Mon, 3 Jun 2019 16:32:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 24/29] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Message-ID: <20190603163227.4d00476a@x1.home>
In-Reply-To: <20190526161004.25232-25-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-25-eric.auger@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.32]); Mon, 03 Jun 2019 22:32:38 +0000 (UTC)
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
 iommu@lists.linux-foundation.org, yi.l.liu@intel.com, vincent.stehle@arm.com,
 robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sun, 26 May 2019 18:09:59 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> This patch adds the VFIO_IOMMU_BIND/UNBIND_MSI ioctl which aim
> to pass/withdraw the guest MSI binding to/from the host.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v6 -> v7:
> - removed the dev arg
> 
> v3 -> v4:
> - add UNBIND
> - unwind on BIND error
> 
> v2 -> v3:
> - adapt to new proto of bind_guest_msi
> - directly use vfio_iommu_for_each_dev
> 
> v1 -> v2:
> - s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
> ---
>  drivers/vfio/vfio_iommu_type1.c | 64 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       | 29 +++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6fda4fbc9bfa..18142cb078a3 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1832,6 +1832,42 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
>  	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
>  }
>  
> +static int
> +vfio_bind_msi(struct vfio_iommu *iommu,
> +	      dma_addr_t giova, phys_addr_t gpa, size_t size)
> +{
> +	struct vfio_domain *d;
> +	int ret = 0;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		ret = iommu_bind_guest_msi(d->domain, giova, gpa, size);
> +		if (ret)
> +			goto unwind;
> +	}
> +	goto unlock;
> +unwind:
> +	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
> +		iommu_unbind_guest_msi(d->domain, giova);
> +	}
> +unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static void
> +vfio_unbind_msi(struct vfio_iommu *iommu, dma_addr_t giova)
> +{
> +	struct vfio_domain *d;
> +
> +	mutex_lock(&iommu->lock);
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		iommu_unbind_guest_msi(d->domain, giova);
> +	}
> +	mutex_unlock(&iommu->lock);
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -1936,6 +1972,34 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  					    &ustruct);
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> +	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
> +		struct vfio_iommu_type1_bind_msi ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_bind_msi,
> +				    size);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		return vfio_bind_msi(iommu, ustruct.iova, ustruct.gpa,
> +				     ustruct.size);
> +	} else if (cmd == VFIO_IOMMU_UNBIND_MSI) {
> +		struct vfio_iommu_type1_unbind_msi ustruct;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_unbind_msi,
> +				    iova);
> +
> +		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (ustruct.argsz < minsz || ustruct.flags)
> +			return -EINVAL;
> +
> +		vfio_unbind_msi(iommu, ustruct.iova);
> +		return 0;
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 055aa9b9745a..2774a1ab37ae 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -798,6 +798,35 @@ struct vfio_iommu_type1_cache_invalidate {
>  };
>  #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
>  
> +/**
> + * VFIO_IOMMU_BIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 25,
> + *			struct vfio_iommu_type1_bind_msi)
> + *
> + * Pass a stage 1 MSI doorbell mapping to the host so that this
> + * latter can build a nested stage2 mapping
> + */
> +struct vfio_iommu_type1_bind_msi {
> +	__u32   argsz;
> +	__u32   flags;
> +	__u64	iova;
> +	__u64	gpa;
> +	__u64	size;
> +};
> +#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 25)
> +
> +/**
> + * VFIO_IOMMU_UNBIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 26,
> + *			struct vfio_iommu_type1_unbind_msi)
> + *
> + * Unregister an MSI mapping
> + */
> +struct vfio_iommu_type1_unbind_msi {
> +	__u32   argsz;
> +	__u32   flags;
> +	__u64	iova;
> +};
> +#define VFIO_IOMMU_UNBIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 26)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

And another pair of ioctls.  Maybe think about how we can reduce the
ioctl bloat of this series.  I don't want to impose an awkward
interface for the sake of fewer ioctls, but I also don't want us
casually burning through ioctls.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
