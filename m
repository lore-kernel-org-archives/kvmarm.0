Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F2DC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 17:22:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9134864F90
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 17:22:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9134864F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA214B1E4;
	Tue,  2 Feb 2021 12:22:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AejObn-S79ND; Tue,  2 Feb 2021 12:22:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C53BD4B229;
	Tue,  2 Feb 2021 12:22:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD42B4B226
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 12:22:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21Q5CzwWXFc0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 12:22:15 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C461A4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 12:22:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612286535;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=v8AW8CWpPRGN6h/TLWk0eq/dJGWHJhavvo25Kj/LjC0=;
 b=c5Dt5ce+iBgYCeZeMBdKBeFRkScDPzhjMCmYJ6+JfL7+smtBFeXbsVBEmKtfdwwF+GJKyS
 zR4GedC3vehye4lfO7bAU8kWC0ZaHaE3KOgg0SmKUsqkG5RPM2M4F9+EhZB4gD7SrokTvC
 TVmqNzR2XP0JLl1MFSFGwZMwQKjTsfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-wJu9rhZPPUuyhHrv_Ue05A-1; Tue, 02 Feb 2021 12:22:11 -0500
X-MC-Unique: wJu9rhZPPUuyhHrv_Ue05A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FBCC193410F;
 Tue,  2 Feb 2021 17:22:08 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B920560862;
 Tue,  2 Feb 2021 17:22:05 +0000 (UTC)
Date: Tue, 2 Feb 2021 10:22:05 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH] vfio/iommu_type1: Mantainance a counter for
 non_pinned_groups
Message-ID: <20210202102205.54737110@omen.home.shazbot.org>
In-Reply-To: <20210125024642.14604-1-zhukeqian1@huawei.com>
References: <20210125024642.14604-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
 Alexios Zavras <alexios.zavras@intel.com>,
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

On Mon, 25 Jan 2021 10:46:42 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> With this counter, we never need to traverse all groups to update
> pinned_scope of vfio_iommu.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 40 +++++----------------------------
>  1 file changed, 5 insertions(+), 35 deletions(-)

Applied to vfio next branch for v5.12.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..bb4bbcc79101 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -73,7 +73,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	bool			dirty_page_tracking;
> -	bool			pinned_page_dirty_scope;
> +	uint64_t		num_non_pinned_groups;
>  };
>  
>  struct vfio_domain {
> @@ -148,7 +148,6 @@ static int put_pfn(unsigned long pfn, int prot);
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  					       struct iommu_group *iommu_group);
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>  /*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
> @@ -714,7 +713,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
>  	if (!group->pinned_page_dirty_scope) {
>  		group->pinned_page_dirty_scope = true;
> -		update_pinned_page_dirty_scope(iommu);
> +		iommu->num_non_pinned_groups--;
>  	}
>  
>  	goto pin_done;
> @@ -991,7 +990,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  	 * mark all pages dirty if any IOMMU capable device is not able
>  	 * to report dirty pages and all pages are pinned and mapped.
>  	 */
> -	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
> +	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
>  		bitmap_set(dma->bitmap, 0, nbits);
>  
>  	if (shift) {
> @@ -1622,33 +1621,6 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  	return group;
>  }
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> -{
> -	struct vfio_domain *domain;
> -	struct vfio_group *group;
> -
> -	list_for_each_entry(domain, &iommu->domain_list, next) {
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> -				return;
> -			}
> -		}
> -	}
> -
> -	if (iommu->external_domain) {
> -		domain = iommu->external_domain;
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> -				return;
> -			}
> -		}
> -	}
> -
> -	iommu->pinned_page_dirty_scope = true;
> -}
> -
>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
>  				  phys_addr_t *base)
>  {
> @@ -2057,8 +2029,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			 * addition of a dirty tracking group.
>  			 */
>  			group->pinned_page_dirty_scope = true;
> -			if (!iommu->pinned_page_dirty_scope)
> -				update_pinned_page_dirty_scope(iommu);
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -2188,7 +2158,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	 * demotes the iommu scope until it declares itself dirty tracking
>  	 * capable via the page pinning interface.
>  	 */
> -	iommu->pinned_page_dirty_scope = false;
> +	iommu->num_non_pinned_groups++;
>  	mutex_unlock(&iommu->lock);
>  	vfio_iommu_resv_free(&group_resv_regions);
>  
> @@ -2416,7 +2386,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	 * to be promoted.
>  	 */
>  	if (update_dirty_scope)
> -		update_pinned_page_dirty_scope(iommu);
> +		iommu->num_non_pinned_groups--;
>  	mutex_unlock(&iommu->lock);
>  }
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
