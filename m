Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7D7C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:24:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE298239EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 23:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE298239EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 133844B18C;
	Fri, 15 Jan 2021 18:24:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n6SqEnX1MTGW; Fri, 15 Jan 2021 18:24:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E92DD4B19C;
	Fri, 15 Jan 2021 18:24:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F61F4B18C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:24:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E3yUvkHR529w for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 18:24:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 910FC4B134
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 18:24:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610753049;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Hi1wWTTxsSrh2eZC6d26sBLUQWgqiaGuZmJlj3AaGNk=;
 b=dHg6MsaJOSBv9I+8I1bGWt8NdeC/VHQTWk7wvLOEa9kEeDSau4rj61DqamjfX7wBp0Tur6
 5AcZ/e4QmUvH/5KDFGbWZJJyzzOTwlxLaVVPZ3GyDoip/qCi+z8o8O5ITHaYPaNsgG0Mtn
 hKne0mdKfR27r4O55zB9cqGdvqe+3Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-uCbG_PrpNRm72u80Zfo6-w-1; Fri, 15 Jan 2021 18:24:05 -0500
X-MC-Unique: uCbG_PrpNRm72u80Zfo6-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D174802B40;
 Fri, 15 Jan 2021 23:24:02 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CFC505D763;
 Fri, 15 Jan 2021 23:24:00 +0000 (UTC)
Date: Fri, 15 Jan 2021 16:23:59 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 2/6] vfio/iommu_type1: Ignore external domain when
 promote pinned_scope
Message-ID: <20210115162359.749e8d0d@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-3-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-3-zhukeqian1@huawei.com>
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

On Thu, 7 Jan 2021 12:43:57 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> The pinned_scope of external domain's groups are always true, that's
> to say we can safely ignore external domain when promote pinned_scope
> status of vfio_iommu.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 334a8240e1da..110ada24ee91 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1637,14 +1637,7 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>  		}
>  	}
>  
> -	if (iommu->external_domain) {
> -		domain = iommu->external_domain;
> -		list_for_each_entry(group, &domain->group_list, next) {
> -			if (!group->pinned_page_dirty_scope)
> -				return;
> -		}
> -	}
> -
> +	/* The external domain always passes check */
>  	iommu->pinned_page_dirty_scope = true;
>  }
>  
> @@ -2347,7 +2340,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	if (iommu->external_domain) {
>  		group = find_iommu_group(iommu->external_domain, iommu_group);
>  		if (group) {
> -			promote_dirty_scope = !group->pinned_page_dirty_scope;


With this, vfio_group.pinned_page_dirty_scope is effectively a dead
field on the struct for groups on the external_domain group list and
handled specially.  That's not great.

If you actually want to make more than a trivial improvement to scope
tracking, what about making a counter on our struct vfio_iommu for all
the non-pinned-page (ie. all-dma) scope groups attached to the
container.  Groups on the external domain would still set their group
dirty scope to pinned pages, groups making use of an iommu domain would
have an all-dma scope initially and increment that counter when
attached.  Groups that still have an all-dma scope on detach would
decrement the counter.  If a group changes from all-dma to pinned-page
scope, the counter is also decremented.  We'd never need to search
across group lists.  Thanks,

Alex

>  			list_del(&group->next);
>  			kfree(group);
>  
> @@ -2360,7 +2352,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  				kfree(iommu->external_domain);
>  				iommu->external_domain = NULL;
>  			}
> -			goto detach_group_done;
> +			mutex_unlock(&iommu->lock);
> +			return;
>  		}
>  	}
>  
> @@ -2408,7 +2401,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	else
>  		vfio_iommu_iova_free(&iova_copy);
>  
> -detach_group_done:
>  	/*
>  	 * Removal of a group without dirty tracking may allow the iommu scope
>  	 * to be promoted.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
