Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269BDC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:30:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84B5323A5A
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84B5323A5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F0F4B197;
	Fri, 15 Jan 2021 18:30:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f-o1LmBNZuPj; Fri, 15 Jan 2021 18:30:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8F64B1AC;
	Fri, 15 Jan 2021 18:30:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 410344B19C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:30:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pq8PU8FK5Coo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 18:30:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FDC4B197
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:30:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610753448;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ZcqGdAWvT6/fidF7kC53r5O0Fwn58WR7GKMoHqohBAc=;
 b=EvojWscu1PXxVbQ5oqH13ukUaZR4vd6FoubrdS9FdYbf53Asrq20L/no800+3g2iMz/wYl
 E2v3JoZZZ1IY21et1BCmkH9Vw5nrMM6UlxnM5Qt1CIkefLB6txRIpD0X+m3xW1/TwHhCQ0
 YqjTortF8ixsKdc2zNIwWBlSNRBC5DQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-MbQGIl4pMwCRKRrqXq0k5Q-1; Fri, 15 Jan 2021 18:30:46 -0500
X-MC-Unique: MbQGIl4pMwCRKRrqXq0k5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 290C2180A092;
 Fri, 15 Jan 2021 23:30:43 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7E3D66F7EF;
 Fri, 15 Jan 2021 23:30:41 +0000 (UTC)
Date: Fri, 15 Jan 2021 16:30:41 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 3/6] vfio/iommu_type1: Initially set the
 pinned_page_dirty_scope
Message-ID: <20210115163041.704a4e9d@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-4-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-4-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On Thu, 7 Jan 2021 12:43:58 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> For now there are 3 ways to promote the pinned_page_dirty_scope
> status of vfio_iommu:
> 
> 1. Through vfio pin interface.
> 2. Detach a group without pinned_dirty_scope.
> 3. Attach a group with pinned_dirty_scope.
> 
> For point 3, the only chance to promote the pinned_page_dirty_scope
> status is when vfio_iommu is newly created. As we can safely set
> empty vfio_iommu to be at pinned status, then the point 3 can be
> removed to reduce operations.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 110ada24ee91..b596c482487b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2045,11 +2045,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			 * Non-iommu backed group cannot dirty memory directly,
>  			 * it can only use interfaces that provide dirty
>  			 * tracking.
> -			 * The iommu scope can only be promoted with the
> -			 * addition of a dirty tracking group.
>  			 */
>  			group->pinned_page_dirty_scope = true;
> -			promote_pinned_page_dirty_scope(iommu);
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -2436,6 +2433,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	INIT_LIST_HEAD(&iommu->iova_list);
>  	iommu->dma_list = RB_ROOT;
>  	iommu->dma_avail = dma_entry_limit;
> +	iommu->pinned_page_dirty_scope = true;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>  

This would be resolved automatically if we used the counter approach I
mentioned on the previous patch, adding a pinned-page scope group simply
wouldn't increment the iommu counter, which would initially be zero
indicating no "all-dma" groups.  Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
