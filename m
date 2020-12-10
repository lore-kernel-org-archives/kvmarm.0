Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FBFC4361B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 19:17:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 221AE23D9A
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 19:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221AE23D9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A1644B1CD;
	Thu, 10 Dec 2020 14:17:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wi-W6+FrZp47; Thu, 10 Dec 2020 14:17:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 136404B1BA;
	Thu, 10 Dec 2020 14:17:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A63F4B1A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 14:17:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIYqt7CqanfU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 14:16:59 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2E8A4B1A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 14:16:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607627818;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5kmp9gy5nxGFdrl4LVG8Ly3qZOFyWyiuhjDzmpydZu0=;
 b=ckpziQfxpdcKMa6couIMEWdCA3gmujRCVrN6Fx6hMsEIjCporHE48ICAn4mHLcdCDtfwh4
 1cxkFf9o21rw3gJylVLUC5NS5E6cSl9RrdltYe5My4Pq3sACVoDLnd6VwogScSEBGN1o90
 X1y7XvYznCvWyYGc5kCvKDzG93rRl3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-RbUqo1cuMGOk8bK4pmTycw-1; Thu, 10 Dec 2020 14:16:54 -0500
X-MC-Unique: RbUqo1cuMGOk8bK4pmTycw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF75710054FF;
 Thu, 10 Dec 2020 19:16:50 +0000 (UTC)
Received: from omen.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B078B5D6D3;
 Thu, 10 Dec 2020 19:16:47 +0000 (UTC)
Date: Thu, 10 Dec 2020 12:16:46 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 1/7] vfio: iommu_type1: Clear added dirty bit when
 unwind pin
Message-ID: <20201210121646.24fb3cd8@omen.home>
In-Reply-To: <20201210073425.25960-2-zhukeqian1@huawei.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Robin Murphy <robin.murphy@arm.com>
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

On Thu, 10 Dec 2020 15:34:19 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> Currently we do not clear added dirty bit of bitmap when unwind
> pin, so if pin failed at halfway, we set unnecessary dirty bit
> in bitmap. Clearing added dirty bit when unwind pin, userspace
> will see less dirty page, which can save much time to handle them.
> 
> Note that we should distinguish the bits added by pin and the bits
> already set before pin, so introduce bitmap_added to record this.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 67e827638995..f129d24a6ec3 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -637,7 +637,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_group *group;
>  	int i, j, ret;
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>  	unsigned long remote_vaddr;
> +	unsigned long bitmap_offset;
> +	unsigned long *bitmap_added;
> +	dma_addr_t iova;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
>  
> @@ -650,6 +654,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	bitmap_added = bitmap_zalloc(npage, GFP_KERNEL);
> +	if (!bitmap_added) {
> +		ret = -ENOMEM;
> +		goto pin_done;
> +	}


This is allocated regardless of whether dirty tracking is enabled, so
this adds overhead to the common case in order to reduce user overhead
(not correctness) in the rare condition that dirty tracking is enabled,
and the even rarer condition that there's a fault during that case.
This is not a good trade-off.  Thanks,

Alex


> +
>  	/* Fail if notifier list is empty */
>  	if (!iommu->notifier.head) {
>  		ret = -EINVAL;
> @@ -664,7 +674,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>  
>  	for (i = 0; i < npage; i++) {
> -		dma_addr_t iova;
>  		struct vfio_pfn *vpfn;
>  
>  		iova = user_pfn[i] << PAGE_SHIFT;
> @@ -699,14 +708,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		}
>  
>  		if (iommu->dirty_page_tracking) {
> -			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> -
> -			/*
> -			 * Bitmap populated with the smallest supported page
> -			 * size
> -			 */
> -			bitmap_set(dma->bitmap,
> -				   (iova - dma->iova) >> pgshift, 1);
> +			/* Populated with the smallest supported page size */
> +			bitmap_offset = (iova - dma->iova) >> pgshift;
> +			if (!test_and_set_bit(bitmap_offset, dma->bitmap))
> +				set_bit(i, bitmap_added);
>  		}
>  	}
>  	ret = i;
> @@ -722,14 +727,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  pin_unwind:
>  	phys_pfn[i] = 0;
>  	for (j = 0; j < i; j++) {
> -		dma_addr_t iova;
> -
>  		iova = user_pfn[j] << PAGE_SHIFT;
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>  		vfio_unpin_page_external(dma, iova, do_accounting);
>  		phys_pfn[j] = 0;
> +
> +		if (test_bit(j, bitmap_added)) {
> +			bitmap_offset = (iova - dma->iova) >> pgshift;
> +			clear_bit(bitmap_offset, dma->bitmap);
> +		}
>  	}
>  pin_done:
> +	if (bitmap_added)
> +		bitmap_free(bitmap_added);
> +
>  	mutex_unlock(&iommu->lock);
>  	return ret;
>  }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
