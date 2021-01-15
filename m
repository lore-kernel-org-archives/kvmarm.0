Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0444EC43381
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:37:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8790A235DD
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:37:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8790A235DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9F8E4B1DA;
	Fri, 15 Jan 2021 18:37:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cw1gRGgzEvbc; Fri, 15 Jan 2021 18:37:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3C64B1F5;
	Fri, 15 Jan 2021 18:37:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B34C34B1EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:37:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MstX4YUTRJTd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 18:37:45 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4F24B1DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:37:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610753865;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f4lruco0oPKqZQoWQHySstTWv9/IZ9UW7zETLf13+EE=;
 b=TbH1R5N4bqpGjHu3ZvzQiokPzXhbJeuVXgNerX0v3jthXkBSxuHylC5lJarlKOOHOr3uUj
 3dsg4yp4nnrhORLaHeB5yJRakeNVhQoBxfM0hEit9guQDFZWosx8mseGIFb35TfOH4y2pf
 7K3Us+5v2RTkNFIuUaEcfkhqWWfAhmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-Pzajvn_WMai53lejIzHg9Q-1; Fri, 15 Jan 2021 18:37:43 -0500
X-MC-Unique: Pzajvn_WMai53lejIzHg9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87CDCC2A7;
 Fri, 15 Jan 2021 23:37:40 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id DB31E61F49;
 Fri, 15 Jan 2021 23:37:38 +0000 (UTC)
Date: Fri, 15 Jan 2021 16:37:38 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 4/6] vfio/iommu_type1: Drop parameter "pgsize" of
 vfio_dma_bitmap_alloc_all
Message-ID: <20210115163738.112f0c34@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-5-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-5-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Catalin Marinas <catalin.marinas@arm.com>,
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

On Thu, 7 Jan 2021 12:43:59 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> We always use the smallest supported page size of vfio_iommu as
> pgsize. Remove parameter "pgsize" of vfio_dma_bitmap_alloc_all.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b596c482487b..080c05b129ee 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -236,9 +236,10 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  	}
>  }
>  
> -static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>  {
>  	struct rb_node *n;
> +	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>  
>  	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>  		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> @@ -2761,12 +2762,9 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		return -EINVAL;
>  
>  	if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> -		size_t pgsize;
> -
>  		mutex_lock(&iommu->lock);
> -		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>  		if (!iommu->dirty_page_tracking) {
> -			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> +			ret = vfio_dma_bitmap_alloc_all(iommu);
>  			if (!ret)
>  				iommu->dirty_page_tracking = true;
>  		}

This just moves the same calculation from one place to another, what's
the point?  Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
