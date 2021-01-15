Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387EEC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 22:42:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7E7D23A6C
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 22:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7E7D23A6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0907F4B1EA;
	Fri, 15 Jan 2021 17:42:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cu0N9XkBe6RY; Fri, 15 Jan 2021 17:42:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB5B24B1BF;
	Fri, 15 Jan 2021 17:42:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6E54B1BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 17:42:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sYt15KmgYipG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 17:42:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB984B16B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 17:42:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610750570;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EB7kXdoaDpBllJxSevGo6kiwu0Drr9UL6vk+q3d3RfU=;
 b=A8AGXK775UiJVqKHpD2/mOMMfVsvkAX1uNIL5br7DoewEF7xg7We5hJP85SwxratYkuDUc
 TgHOkNYOC9qDPOWxQUTrzS6kk8igeqPPtI94ZZ42TqrlLoA4pfuV6nAayqdiatz6Ak9WHA
 6rR5pNkZEexrJzC10rFkeccX25XvN1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-ZUP2g_LEO8uQpZeiFfHExg-1; Fri, 15 Jan 2021 17:42:46 -0500
X-MC-Unique: ZUP2g_LEO8uQpZeiFfHExg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEA5F806666;
 Fri, 15 Jan 2021 22:42:42 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 02A635D9C6;
 Fri, 15 Jan 2021 22:42:40 +0000 (UTC)
Date: Fri, 15 Jan 2021 15:42:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 1/6] vfio/iommu_type1: Make an explicit "promote" semantic
Message-ID: <20210115154240.0d3ee455@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-2-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On Thu, 7 Jan 2021 12:43:56 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> When we want to promote the pinned_page_dirty_scope of vfio_iommu,
> we call the "update" function to visit all vfio_group, but when we
> want to downgrade this, we can set the flag as false directly.

I agree that the transition can only go in one direction, but it's
still conditional on the scope of all groups involved.  We are
"updating" the iommu state based on the change of a group.  Renaming
this to "promote" seems like a matter of personal preference.

> So we'd better make an explicit "promote" semantic to the "update"
> function. BTW, if vfio_iommu already has been promoted, then return
> early.

Currently it's the caller that avoids using this function when the
iommu scope is already correct.  In fact the changes induces a
redundant test in the pin_pages code path, we're changing a group from
non-pinned-page-scope to pinned-page-scope, therefore the iommu scope
cannot initially be scope limited.  In the attach_group call path,
we're moving that test from the caller, so at best we've introduced an
additional function call.

The function as it exists today is also more versatile whereas the
"promote" version here forces it to a single task with no appreciable
difference in complexity or code.  This seems like a frivolous change.
Thanks,

Alex

> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..334a8240e1da 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -148,7 +148,7 @@ static int put_pfn(unsigned long pfn, int prot);
>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  					       struct iommu_group *iommu_group);
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
> +static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>  /*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
> @@ -714,7 +714,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
>  	if (!group->pinned_page_dirty_scope) {
>  		group->pinned_page_dirty_scope = true;
> -		update_pinned_page_dirty_scope(iommu);
> +		promote_pinned_page_dirty_scope(iommu);
>  	}
>  
>  	goto pin_done;
> @@ -1622,27 +1622,26 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  	return group;
>  }
>  
> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> +static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>  {
>  	struct vfio_domain *domain;
>  	struct vfio_group *group;
>  
> +	if (iommu->pinned_page_dirty_scope)
> +		return;
> +
>  	list_for_each_entry(domain, &iommu->domain_list, next) {
>  		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> +			if (!group->pinned_page_dirty_scope)
>  				return;
> -			}
>  		}
>  	}
>  
>  	if (iommu->external_domain) {
>  		domain = iommu->external_domain;
>  		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope) {
> -				iommu->pinned_page_dirty_scope = false;
> +			if (!group->pinned_page_dirty_scope)
>  				return;
> -			}
>  		}
>  	}
>  
> @@ -2057,8 +2056,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			 * addition of a dirty tracking group.
>  			 */
>  			group->pinned_page_dirty_scope = true;
> -			if (!iommu->pinned_page_dirty_scope)
> -				update_pinned_page_dirty_scope(iommu);
> +			promote_pinned_page_dirty_scope(iommu);
>  			mutex_unlock(&iommu->lock);
>  
>  			return 0;
> @@ -2341,7 +2339,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_domain *domain;
>  	struct vfio_group *group;
> -	bool update_dirty_scope = false;
> +	bool promote_dirty_scope = false;
>  	LIST_HEAD(iova_copy);
>  
>  	mutex_lock(&iommu->lock);
> @@ -2349,7 +2347,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	if (iommu->external_domain) {
>  		group = find_iommu_group(iommu->external_domain, iommu_group);
>  		if (group) {
> -			update_dirty_scope = !group->pinned_page_dirty_scope;
> +			promote_dirty_scope = !group->pinned_page_dirty_scope;
>  			list_del(&group->next);
>  			kfree(group);
>  
> @@ -2379,7 +2377,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  			continue;
>  
>  		vfio_iommu_detach_group(domain, group);
> -		update_dirty_scope = !group->pinned_page_dirty_scope;
> +		promote_dirty_scope = !group->pinned_page_dirty_scope;
>  		list_del(&group->next);
>  		kfree(group);
>  		/*
> @@ -2415,8 +2413,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	 * Removal of a group without dirty tracking may allow the iommu scope
>  	 * to be promoted.
>  	 */
> -	if (update_dirty_scope)
> -		update_pinned_page_dirty_scope(iommu);
> +	if (promote_dirty_scope)
> +		promote_pinned_page_dirty_scope(iommu);
>  	mutex_unlock(&iommu->lock);
>  }
>  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
