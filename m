Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722B3C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:34:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF46A222F9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF46A222F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F63B4B2A8;
	Mon, 18 Jan 2021 08:33:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lJEPBqis5ayr; Mon, 18 Jan 2021 08:33:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2AB4B27E;
	Mon, 18 Jan 2021 08:33:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 810104B27E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:33:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLyMPNw8O592 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:33:54 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A37CC4B279
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:33:53 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DKCQ215LFzMLJL;
 Mon, 18 Jan 2021 21:32:26 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 21:33:40 +0800
Subject: Re: [PATCH 1/6] vfio/iommu_type1: Make an explicit "promote" semantic
To: Alex Williamson <alex.williamson@redhat.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-2-zhukeqian1@huawei.com>
 <20210115154240.0d3ee455@omen.home.shazbot.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <0cf47d65-cb91-199e-af7d-048134634298@huawei.com>
Date: Mon, 18 Jan 2021 21:33:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115154240.0d3ee455@omen.home.shazbot.org>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Catalin Marinas <catalin.marinas@arm.com>, Thomas
 Gleixner <tglx@linutronix.de>, Will
 Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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



On 2021/1/16 6:42, Alex Williamson wrote:
> On Thu, 7 Jan 2021 12:43:56 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> When we want to promote the pinned_page_dirty_scope of vfio_iommu,
>> we call the "update" function to visit all vfio_group, but when we
>> want to downgrade this, we can set the flag as false directly.
> 
> I agree that the transition can only go in one direction, but it's
> still conditional on the scope of all groups involved.  We are
> "updating" the iommu state based on the change of a group.  Renaming
> this to "promote" seems like a matter of personal preference.
> 
>> So we'd better make an explicit "promote" semantic to the "update"
>> function. BTW, if vfio_iommu already has been promoted, then return
>> early.
> 
> Currently it's the caller that avoids using this function when the
> iommu scope is already correct.  In fact the changes induces a
> redundant test in the pin_pages code path, we're changing a group from
> non-pinned-page-scope to pinned-page-scope, therefore the iommu scope
> cannot initially be scope limited.  In the attach_group call path,
> we're moving that test from the caller, so at best we've introduced an
> additional function call.
> 
> The function as it exists today is also more versatile whereas the
> "promote" version here forces it to a single task with no appreciable
> difference in complexity or code.  This seems like a frivolous change.
> Thanks,
OK, I will adapt your idea that maintenance a counter of non-pinned groups.
Then we keep the "update" semantic, and the target is the counter ;-).

Thanks,
Keqian

> 
> Alex
> 
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 30 ++++++++++++++----------------
>>  1 file changed, 14 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0b4dedaa9128..334a8240e1da 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -148,7 +148,7 @@ static int put_pfn(unsigned long pfn, int prot);
>>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>>  					       struct iommu_group *iommu_group);
>>  
>> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>> +static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu);
>>  /*
>>   * This code handles mapping and unmapping of user data buffers
>>   * into DMA'ble space using the IOMMU
>> @@ -714,7 +714,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
>>  	if (!group->pinned_page_dirty_scope) {
>>  		group->pinned_page_dirty_scope = true;
>> -		update_pinned_page_dirty_scope(iommu);
>> +		promote_pinned_page_dirty_scope(iommu);
>>  	}
>>  
>>  	goto pin_done;
>> @@ -1622,27 +1622,26 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>>  	return group;
>>  }
>>  
>> -static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>> +static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>>  {
>>  	struct vfio_domain *domain;
>>  	struct vfio_group *group;
>>  
>> +	if (iommu->pinned_page_dirty_scope)
>> +		return;
>> +
>>  	list_for_each_entry(domain, &iommu->domain_list, next) {
>>  		list_for_each_entry(group, &domain->group_list, next) {
>> -			if (!group->pinned_page_dirty_scope) {
>> -				iommu->pinned_page_dirty_scope = false;
>> +			if (!group->pinned_page_dirty_scope)
>>  				return;
>> -			}
>>  		}
>>  	}
>>  
>>  	if (iommu->external_domain) {
>>  		domain = iommu->external_domain;
>>  		list_for_each_entry(group, &domain->group_list, next) {
>> -			if (!group->pinned_page_dirty_scope) {
>> -				iommu->pinned_page_dirty_scope = false;
>> +			if (!group->pinned_page_dirty_scope)
>>  				return;
>> -			}
>>  		}
>>  	}
>>  
>> @@ -2057,8 +2056,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  			 * addition of a dirty tracking group.
>>  			 */
>>  			group->pinned_page_dirty_scope = true;
>> -			if (!iommu->pinned_page_dirty_scope)
>> -				update_pinned_page_dirty_scope(iommu);
>> +			promote_pinned_page_dirty_scope(iommu);
>>  			mutex_unlock(&iommu->lock);
>>  
>>  			return 0;
>> @@ -2341,7 +2339,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  	struct vfio_iommu *iommu = iommu_data;
>>  	struct vfio_domain *domain;
>>  	struct vfio_group *group;
>> -	bool update_dirty_scope = false;
>> +	bool promote_dirty_scope = false;
>>  	LIST_HEAD(iova_copy);
>>  
>>  	mutex_lock(&iommu->lock);
>> @@ -2349,7 +2347,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  	if (iommu->external_domain) {
>>  		group = find_iommu_group(iommu->external_domain, iommu_group);
>>  		if (group) {
>> -			update_dirty_scope = !group->pinned_page_dirty_scope;
>> +			promote_dirty_scope = !group->pinned_page_dirty_scope;
>>  			list_del(&group->next);
>>  			kfree(group);
>>  
>> @@ -2379,7 +2377,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  			continue;
>>  
>>  		vfio_iommu_detach_group(domain, group);
>> -		update_dirty_scope = !group->pinned_page_dirty_scope;
>> +		promote_dirty_scope = !group->pinned_page_dirty_scope;
>>  		list_del(&group->next);
>>  		kfree(group);
>>  		/*
>> @@ -2415,8 +2413,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  	 * Removal of a group without dirty tracking may allow the iommu scope
>>  	 * to be promoted.
>>  	 */
>> -	if (update_dirty_scope)
>> -		update_pinned_page_dirty_scope(iommu);
>> +	if (promote_dirty_scope)
>> +		promote_pinned_page_dirty_scope(iommu);
>>  	mutex_unlock(&iommu->lock);
>>  }
>>  
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
