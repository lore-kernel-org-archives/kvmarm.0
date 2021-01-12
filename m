Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25085C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 21:21:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E70B2311F
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 21:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E70B2311F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD204B1F8;
	Tue, 12 Jan 2021 16:21:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BEI4p2PMzdpH; Tue, 12 Jan 2021 16:21:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 108C44B227;
	Tue, 12 Jan 2021 16:21:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E93C84B222
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 16:21:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZhvI0Zyqu2P for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 16:21:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C6C4B1EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 16:21:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610486469;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XLFSIDj1yb2peaSE/tJnoIhEfZLTdfvc3qPuS09xnb4=;
 b=aOA6mbXx8q22kdfZubzGFTER47drgElw8/KWqedpi/UgCb76Rdcn8EISnapG+8e8pEFdxH
 GduGKhN9O+cLEvTkbXmbb/K1OOzM36NwH+AsJ2Yabns+MWeAcQvcaTkAhZ0HKWjUcstCYa
 pOqZsjNgLScEXtWQIMstjjYL2VxOPaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-Zwx1QS4kPn2XRswLQlixLA-1; Tue, 12 Jan 2021 16:21:05 -0500
X-MC-Unique: Zwx1QS4kPn2XRswLQlixLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A3B107ACF7;
 Tue, 12 Jan 2021 21:21:01 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3D0D29CA0;
 Tue, 12 Jan 2021 21:20:59 +0000 (UTC)
Date: Tue, 12 Jan 2021 14:20:59 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 1/5] vfio/iommu_type1: Fixes vfio_dma_populate_bitmap to
 avoid dirty lose
Message-ID: <20210112142059.074c1b0f@omen.home.shazbot.org>
In-Reply-To: <20210107092901.19712-2-zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
 <20210107092901.19712-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On Thu, 7 Jan 2021 17:28:57 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> Defer checking whether vfio_dma is of fully-dirty in update_user_bitmap
> is easy to lose dirty log. For example, after promoting pinned_scope of
> vfio_iommu, vfio_dma is not considered as fully-dirty, then we may lose
> dirty log that occurs before vfio_iommu is promoted.
>
> The key point is that pinned-dirty is not a real dirty tracking way, it
> can't continuously track dirty pages, but just restrict dirty scope. It
> is essentially the same as fully-dirty. Fully-dirty is of full-scope and
> pinned-dirty is of pinned-scope.
> 
> So we must mark pinned-dirty or fully-dirty after we start dirty tracking
> or clear dirty bitmap, to ensure that dirty log is marked right away.

I was initially convinced by these first three patches, but upon
further review, I think the premise is wrong.  AIUI, the concern across
these patches is that our dirty bitmap is only populated with pages
dirtied by pinning and we only take into account the pinned page dirty
scope at the time the bitmap is retrieved by the user.  You suppose
this presents a gap where if a vendor driver has not yet identified
with a page pinning scope that the entire bitmap should be considered
dirty regardless of whether that driver later pins pages prior to the
user retrieving the dirty bitmap.

I don't think this is how we intended the cooperation between the iommu
driver and vendor driver to work.  By pinning pages a vendor driver is
not declaring that only their future dirty page scope is limited to
pinned pages, instead they're declaring themselves as a participant in
dirty page tracking and take responsibility for pinning any necessary
pages.  For example we might extend VFIO_IOMMU_DIRTY_PAGES_FLAG_START
to trigger a blocking notification to groups to not only begin dirty
tracking, but also to synchronously register their current device DMA
footprint.  This patch would require a vendor driver to possibly perform
a gratuitous page pinning in order to set the scope prior to dirty
logging being enabled, or else the initial bitmap will be fully dirty.

Therefore, I don't see that this series is necessary or correct.  Kirti,
does this match your thinking?

Thinking about these semantics, it seems there might still be an issue
if a group with non-pinned-page dirty scope is detached with dirty
logging enabled.  It seems this should in fact fully populate the dirty
bitmaps at the time it's removed since we don't know the extent of its
previous DMA, nor will the group be present to trigger the full bitmap
when the user retrieves the dirty bitmap.  Creating fully populated
bitmaps at the time tracking is enabled negates our ability to take
advantage of later enlightenment though.  Thanks,

Alex

> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bceda5e8baaa..b0a26e8e0adf 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -224,7 +224,7 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>  	dma->bitmap = NULL;
>  }
>  
> -static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
> +static void vfio_dma_populate_bitmap_pinned(struct vfio_dma *dma, size_t pgsize)
>  {
>  	struct rb_node *p;
>  	unsigned long pgshift = __ffs(pgsize);
> @@ -236,6 +236,25 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  	}
>  }
>  
> +static void vfio_dma_populate_bitmap_full(struct vfio_dma *dma, size_t pgsize)
> +{
> +	unsigned long pgshift = __ffs(pgsize);
> +	unsigned long nbits = dma->size >> pgshift;
> +
> +	bitmap_set(dma->bitmap, 0, nbits);
> +}
> +
> +static void vfio_dma_populate_bitmap(struct vfio_iommu *iommu,
> +				     struct vfio_dma *dma)
> +{
> +	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
> +
> +	if (iommu->pinned_page_dirty_scope)
> +		vfio_dma_populate_bitmap_pinned(dma, pgsize);
> +	else if (dma->iommu_mapped)
> +		vfio_dma_populate_bitmap_full(dma, pgsize);
> +}
> +
>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>  {
>  	struct rb_node *n;
> @@ -257,7 +276,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>  			}
>  			return ret;
>  		}
> -		vfio_dma_populate_bitmap(dma, pgsize);
> +		vfio_dma_populate_bitmap(iommu, dma);
>  	}
>  	return 0;
>  }
> @@ -987,13 +1006,6 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  	unsigned long shift = bit_offset % BITS_PER_LONG;
>  	unsigned long leftover;
>  
> -	/*
> -	 * mark all pages dirty if any IOMMU capable device is not able
> -	 * to report dirty pages and all pages are pinned and mapped.
> -	 */
> -	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
> -		bitmap_set(dma->bitmap, 0, nbits);
> -
>  	if (shift) {
>  		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
>  				  nbits + shift);
> @@ -1019,7 +1031,6 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  	struct vfio_dma *dma;
>  	struct rb_node *n;
>  	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> -	size_t pgsize = (size_t)1 << pgshift;
>  	int ret;
>  
>  	/*
> @@ -1055,7 +1066,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  		 * pages which are marked dirty by vfio_dma_rw()
>  		 */
>  		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
> -		vfio_dma_populate_bitmap(dma, pgsize);
> +		vfio_dma_populate_bitmap(iommu, dma);
>  	}
>  	return 0;
>  }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
