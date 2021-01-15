Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF67C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 18:01:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB2E723603
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 18:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB2E723603
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3EE4A4A4;
	Fri, 15 Jan 2021 13:01:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ljsNEODf0-tb; Fri, 15 Jan 2021 13:01:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26FB4B173;
	Fri, 15 Jan 2021 13:01:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60BAF4B133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 13:01:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQkkSxHrlAYq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 13:01:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 404714B0B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 13:01:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610733712;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Gq10Kr5xse22ieR9b4aF/0j+yRbARGW5WK7gbGTTvCI=;
 b=Rffeyu0QF33Fu92yoYDsCDIi0o8ZCnL8iyKebBOKZhnqpf8nMYy+xbIT+X3PRhaZ1aEKT2
 EzaEiN3z49Y+xPTy675nWhWvnM6apOceRdtgBqV4psYhnYny31sV1dMPOMANu5+4R+mryw
 VYfu0wMKyzs07qFsAgZFmtnbCs3p1Zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-gAhkavzzP3CD-QHWbBOljQ-1; Fri, 15 Jan 2021 13:01:50 -0500
X-MC-Unique: gAhkavzzP3CD-QHWbBOljQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11F6107ACF8;
 Fri, 15 Jan 2021 18:01:47 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 90E4460BF3;
 Fri, 15 Jan 2021 18:01:45 +0000 (UTC)
Date: Fri, 15 Jan 2021 11:01:44 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v2 1/2] vfio/iommu_type1: Populate full dirty when
 detach non-pinned group
Message-ID: <20210115110144.61e3c843@omen.home.shazbot.org>
In-Reply-To: <20210115092643.728-2-zhukeqian1@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
 <20210115092643.728-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, 15 Jan 2021 17:26:42 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> If a group with non-pinned-page dirty scope is detached with dirty
> logging enabled, we should fully populate the dirty bitmaps at the
> time it's removed since we don't know the extent of its previous DMA,
> nor will the group be present to trigger the full bitmap when the user
> retrieves the dirty bitmap.
> 
> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..4e82b9a3440f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -236,6 +236,19 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  	}
>  }
>  
> +static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n;
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		if (dma->iommu_mapped)
> +			bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
> +	}
> +}
> +
>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>  {
>  	struct rb_node *n;
> @@ -2415,8 +2428,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	 * Removal of a group without dirty tracking may allow the iommu scope
>  	 * to be promoted.
>  	 */
> -	if (update_dirty_scope)
> +	if (update_dirty_scope) {
>  		update_pinned_page_dirty_scope(iommu);
> +		if (iommu->dirty_page_tracking)
> +			vfio_iommu_populate_bitmap_full(iommu);
> +	}
>  	mutex_unlock(&iommu->lock);
>  }
>  

This doesn't do the right thing.  This marks the bitmap dirty if:

 * The detached group dirty scope was not limited to pinned pages

 AND

 * Dirty tracking is enabled

 AND

 * The vfio_dma is *currently* (ie. after the detach) iommu_mapped

We need to mark the bitmap dirty based on whether the vfio_dma *was*
iommu_mapped by the group that is now detached.  Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
