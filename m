Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7F30CD9E
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 03:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788751062; cv=none; b=hl+olpYFc66rH2fwuCGQuVmwew0cHJ/lsavyILbEoEJL+ktEgDq0ybQKZByeJgj8rYlejE1HDZOk+HunqgqmS45YMJ5pjJwOysgI46K3d+6tva5lU99CxpzXGxjq/Ti9aUXKnovIXS+YnTwze0q7UWPb4pdLA1ID2hEIlblxVXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788751062; c=relaxed/simple;
	bh=uSHJs5pFphrs4CzT79CmbpJPMsweT6LOt+MPZHOORTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gh7/8wkSktk9x3Jqe5lgBDBI+xjHOdz3VApvaPAM7YkBTtV7TOObZp0gV2VPqVCDeLIhnbznsEKlepJY9nnG6/VcHQLQPKxLaOB0f4PwQXFjHjtL0iY8txVLB+gMi4eDpxyg+d3po9zpuUC5MfUgy0An0kKPmaa4b4BRk4jK91w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pvSKK7WG; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pvSKK7WG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=y9MKPdEmbLXUZP27ofMQANcFt0Naez3iYbSU7GMRGxA=;
	b=pvSKK7WGRKntvmU2SrMopxl9H/oXuixShgcUpmFxhcHvwy44KvE9OWcQ++gJPe+sUrrJsCgLO
	pRWeeLj9N4WQDX6+pqECvGt8jyPJI6YtcpHRd5KS9vJQidYuFfC/rIRbs8HjrKvSHtDWiAgpEAH
	6FXVn8uif7Sg13PqmbEgT1g=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hdX624GNzzcb0W;
	Mon,  7 Sep 2026 11:06:34 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id EF7C640561;
	Mon,  7 Sep 2026 11:17:28 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 11:17:27 +0800
Message-ID: <9bbb0a97-7e3a-4815-9619-fd72129d4878@huawei.com>
Date: Mon, 7 Sep 2026 11:17:27 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
To: Leonardo Bras <leo.bras@arm.com>
CC: Oliver Upton <oupton@kernel.org>, <maz@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>, <yezhenyu2@huawei.com>,
	<yubihong@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>
References: <45d76d0d-48e9-46a6-b1f9-691f840eba46@huawei.com>
 <anBrvILpcSFhW7Wg@LeoBrasDK>
 <95f1ebd4-be04-4684-be68-388f752a1379@huawei.com>
 <anDCno9HdVI5UAls@LeoBrasDK>
 <2070002d-94aa-4a5b-8df1-e8e0f0fd265c@huawei.com>
 <anHIa5PDnF7r9EA4@LeoBrasDK>
 <3808f469-5403-4f2e-85f0-8c6ca13068bd@huawei.com>
 <anmvnclRTPS6an8e@LeoBrasDK> <aoh1vw0ZdWJf6T4q@LeoBrasDK>
 <ad48e628-d036-440e-955d-856c2539e568@huawei.com>
 <apcJ6bClZbX4BCpR@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <apcJ6bClZbX4BCpR@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/2/2026 1:22 AM, Leonardo Bras wrote:
> On Mon, Aug 31, 2026 at 08:36:10PM +0800, Tian Zheng wrote:
>>
>>
>> On 8/21/2026 11:58 PM, Leonardo Bras wrote:
>>> On Mon, Aug 10, 2026 at 12:01:49PM +0100, Leonardo Bras wrote:
>>> [> On Wed, Aug 05, 2026 at 11:41:51AM +0800, Tian Zheng wrote:
>>>>>
>>>>>
>>>>> On 8/4/2026 7:10 PM, Leonardo Bras wrote:
>>>>>> On Tue, Aug 04, 2026 at 12:54:16PM +0800, Tian Zheng wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 8/4/2026 12:32 AM, Leonardo Bras wrote:
>>>>>>>> On Mon, Aug 03, 2026 at 09:57:46PM +0800, Tian Zheng wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 8/3/2026 6:21 PM, Leonardo Bras wrote:
>>>>>>>>>> On Mon, Aug 03, 2026 at 12:04:24PM +0800, Tian Zheng wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 8/3/2026 9:33 AM, Tian Zheng wrote:
>>>>>>>>>>>>>>>>>> 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
>>>>>>>>>>>>>>>>>>> -    if (prot & KVM_PGTABLE_PROT_W)
>>>>>>>>>>>>>>>>>>> +    if (prot & KVM_PGTABLE_PROT_W) {
>>>>>>>>>>>>>>>>>>>                  set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> +        /*
>>>>>>>>>>>>>>>>>>> +         * No DEVICE filter needed here:
>>>>>>>>>>>>>>>>>>> relax_perms is only called
>>>>>>>>>>>>>>>>>>> +         * on FSC_PERM faults. Device pages
>>>>>>>>>>>>>>>>>>> always get full RW from
>>>>>>>>>>>>>>>>>>> +         * initial mapping and are never write-protected during
>>>>>>>>>>>>>>>>>>> +         * migration, so they never trigger a permission fault.
>>>>>>>>>>>>>>>>>>> +         */
>>>>>>>>>>>>>>>>>>> +        if (pgt->flags & KVM_PGTABLE_S2_DBM)
>>>>>>>>>>>>>>>>>>> +            set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>>>>>>>>>>>>>> +    } else {
>>>>>>>>>>>>>>>>>>> +        /*
>>>>>>>>>>>>>>>>>>> +         * Clear DBM on W→RO downgrade to prevent hardware from
>>>>>>>>>>>>>>>>>>> +         * silently upgrading RO+DBM back to W+dirty, which would
>>>>>>>>>>>>>>>>>>> +         * bypass KVM's write tracking and cause data corruption.
>>>>>>>>>>>>>>>>>>> +         */
>>>>>>>>>>>>>>>>>>> +        clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>>>>>>>>>>>>>> +    }
>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>> This block makes it pretty evident that the DBM bit really *is* the
>>>>>>>>>>>>>>>>>> write permission bit. I'd much rather we
>>>>>>>>>>>>>>>>>> introduce the concept of dirty
>>>>>>>>>>>>>>>>>> state to the page table library and migrate the abstract write
>>>>>>>>>>>>>>>>>> permission to the DBM field, even if we don't have FEAT_HAFDBS.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Ohh, that's an amazing idea!
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thinking about that again...
>>>>>>>>>>>>>>> If we adopt the encoding with DBM being the write-permission
>>>>>>>>>>>>>>> bit, and all
>>>>>>>>>>>>>>> PTEs have it since the start, how can we have lazy-splitting happening?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Only way I think of is removing both DBM and S2_S2AP_W bit
>>>>>>>>>>>>>>> from writable
>>>>>>>>>>>>>>> PTEs during dirty-track enable, and re-adding them during
>>>>>>>>>>>>>>> the first write
>>>>>>>>>>>>>>> fault. If we don't remove the DBM bit, systems with HDBSS
>>>>>>>>>>>>>>> would just dirty
>>>>>>>>>>>>>>> it by hardware, without causing a fault.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> DBM=0 would need to happen only in the first write-protect (only on
>>>>>>>>>>>>>>> lazy-splitting). All other write-protecting would just clean
>>>>>>>>>>>>>>> the S2_S2AP_W
>>>>>>>>>>>>>>> bit, as everything is already split.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Is that what was intended?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thanks!
>>>>>>>>>>>>>>> Leo
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hi Leo,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I think the cleanest way to handle this is to simply avoid setting DBM
>>>>>>>>>>>>>> on block mappings. If we only set DBM on page-level PTEs, then block
>>>>>>>>>>>>>> mappings will naturally stay DBM=0 and trigger a write fault on first
>>>>>>>>>>>>>> access — exactly what we need for lazy splitting.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> When the fault occurs, the block gets split into page-level PTEs, and at
>>>>>>>>>>>>>> that point we can set DBM=1 on the resulting leaf entries. This way:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 1. Lazy split works naturally (fault -> split -> set DBM=1)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 2. No need to clear DBM globally at dirty-track enable
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 3. No special handling for block mappings
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So I think global DBM is still viable — we just need to filter out block
>>>>>>>>>>>>>> mappings when setting the DBM bit. That way the lazy split path
>>>>>>>>>>>>>> is preserved
>>>>>>>>>>>>>> without extra complexity.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Hi Tian,
>>>>>>>>>>>>>
>>>>>>>>>>>>> Humm, but would not that be contrary to what Oliver suggested:
>>>>>>>>>>>>> changing the
>>>>>>>>>>>>> encoding from the PTE for all entries?
>>>>>>>>>>>>>
>>>>>>>>>>>>> (Like, if the PTE is writable, it has to have DBM set)
>>>>>>>>>>>>>
>>>>>>>>>>>>> IIUC what you said, on first faulting of the page in the VM:
>>>>>>>>>>>>> - If the entry is a page (level-3 leaf) and writable, add DBM
>>>>>>>>>>>>> - If it's a block entry (leaf but not a level-3), don't add DBM
>>>>>>>>>>>>>
>>>>>>>>>>>>> So after we enable dirty-logging:
>>>>>>>>>>>>> - a level-3 entry would not fault, using HDBSS, and
>>>>>>>>>>>>> - a block entry would fault, do the splitting, and add DBM to level-3
>>>>>>>>>>>>>         entries during the split.
>>>>>>>>>>>>>
>>>>>>>>>>>>> If I got that correct, that would be clean indeed.
>>>>>>>>>>>>>
>>>>>>>>>>>>> But then we would have a different encoding for block entries and page
>>>>>>>>>>>>> entries. In page entries, DBM could be used to say if the page is
>>>>>>>>>>>>> writable,
>>>>>>>>>>>>> but on block entries one would have to look at the 'dirty-bit'.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Would that be ok?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks!
>>>>>>>>>>>>> Leo
>>>>>>>>>>>>>
>>>>>>>>>>>> Hi Leo,
>>>>>>>>>>>>
>>>>>>>>>>>> My initial concern was that clearing all DBM bits at the start of
>>>>>>>>>>>> migration would be too expensive, so I thought distinguishing between
>>>>>>>>>>>> level-3 entries and block entries would be better.
>>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I think we expect it to be expensive, but since we already clean the
>>>>>>>>>> dirty-bit (ro/rw) bit, we can have both happening in the same write :)
>>>>>>>>>>
>>>>>>>>>> (since we only mark the DBM bit when we fault the memory on lazy-splitting,
>>>>>>>>>> we are expecting to have the same amount of writes to pagetable as we have
>>>>>>>>>> before HDBSS, both on faulting and 1st iteration cleaning)
>>>>>>>>>>
>>>>>>>>> Hi, Leo
>>>>>>>>>
>>>>>>>>> Actually, I have thought about this approach too, but if we clear DBM in
>>>>>>>>> kvm_pgtable_stage2_wrprotect(), then during the first round of
>>>>>>>>> migration, we will fault and release RO -> W, and then add DBM.
>>>>>>>>
>>>>>>>> Yeah, that's only for lazy-splitting, though.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> But next time, when we migrate the dirty pages in round two, we will run
>>>>>>>>> kvm_pgtable_stage2_wrprotect() again, which will clear DBM again. And
>>>>>>>>> finally, HDBSS will be useless during migration.
>>>>>>>>
>>>>>>>> Right, on lazy splitting, we have to clean the DBM bit on the
>>>>>>>> write-protect only if it's a block entry (hugepage).
>>>>>>>>
>>>>>>>> Once it faults for the first time, it will lazy-split, and we don't need to
>>>>>>>> clean the DBM bit.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>> However, I ran a quick test on a 400GB VM (4 vCPUs), and the overhead
>>>>>>>>>>>> turned out to be around 30ns — which I think is acceptable.
>>>>>>>>>>>
>>>>>>>>>>> Just a quick correction — I misstated the unit in my previous email. The
>>>>>>>>>>> overhead for clearing DBM on the 400GB VM (4 vCPUs) was around 32 µs, not 30
>>>>>>>>>>> ns.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Oh, that seems more likely :)
>>>>>>>>>>
>>>>>>>>>> Question: is tha above amount of memory initially in Level-1 blocks,
>>>>>>>>>> level-2 blocks or level-3 pages? (aka: were you using explicit/transparent
>>>>>>>>>> hugepages?)
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I'm using transparent hugepages. However, if we were to use level-3 stage-2
>>>>>>>>> pages with -mem-prealloc enabled in QEMU, I believe the time cost would be
>>>>>>>>> extremely high — potentially out of our control.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Yeah, that's the issue.
>>>>>>>> For this not to explode like this, we need to mark as RO only when the
>>>>>>>> entries are blocks AND we are doing lazy splitting.
>>>>>>>>
>>>>>>>> We have:
>>>>>>>> Mode	DBM	Dirty bit
>>>>>>>> RO	0	X
>>>>>>>> WC	1	0
>>>>>>>> WD	1	1
>>>>>>>>
>>>>>>>> On write-protect:
>>>>>>>> - Lazy splitting + block entry (hugepage, level 2-) -> RO
>>>>>>>> - Otherwise					    -> WC
>>>>>>>>
>>>>>>>> On first fault, the block entry will be lazy-splitten, and we can set DBM=1
>>>>>>>> in every new page.
>>>>>>>>
>>>>>>>> That way we guarantee that we are not faulting level-3 pages unecessarily,
>>>>>>>> nor need to go through the whole tree setting DBM=1 or DBM=0 on level-3
>>>>>>>> pages.
>>>>>>>>
>>>>>>>> How does that sound?
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>> Leo
>>>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Hi Leo,
>>>>>>>
>>>>>>> I've also been thinking about this approach: clear
>>>>>>> KVM_PTE_LEAF_ATTR_HI_S2_DBM when kvm_pgtable_stage2_wrprotect() calls
>>>>>>> stage2_update_leaf_attrs(). And we can check whether a page is a block
>>>>>>> page during the page walk, right?
>>>>>>
>>>>>> Hi Tian,
>>>>>> That was what I was thinking :)
>>>>>>
>>>>>>>
>>>>>>> So we can check the page level in the walker callback
>>>>>>> stage2_attr_walker(), filter there, clear DBM for block pages and
>>>>>>> preserve DBM on level-3 pages. Something like this:
>>>>>>>
>>>>>>> ```
>>>>>>> pte &= ~data->attr_clr;      // wrprotect: clears S2AP_W only
>>>>>>> pte |= data->attr_set;
>>>>>>> if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
>>>>>>
>>>>>> Only on lazy splitting, right?
>>>>>>
>>>>>> Or maybe we get the DBM bit on during eager splitting...
>>>>>
>>>>> Hi, Leo
>>>>>
>>>>> No, it works for both. Whether eager or lazy split, wrprotect always runs
>>>>> before split, so the block DBM is cleared first.
>>>>
>>>> Hi Tian,
>>>>
>>>> On eager splitting, why should we ever strip DBM?
>>>>
>>>> Eager splitting means we won't have to fault to do the splitting, so we can
>>>> have HAFDBS/HDBSS handle every fault, including the first one that we use
>>>> for lazy-splitting.
>>>>
>>>>>
>>>>> For eager split: wrprotect clears W (W=1->W=0) and strips DBM from the
>>>>> block. Then the block is split into level-3 pages, but since W=0 and DBM
>>>>> depends on W, DBM stays 0. DBM is only set back to 1 during the first write
>>>>> fault (relax_perms: W=0->W=1, which also sets DBM=1).
>>>>
>>>> I suggest that, on splitting, set all writable level-3 pages with DBM=1.
>>>> If lazy-splitting, that will happen naturally on the first fault's split.
>>>> If eager-splitting that will happen during the split as well.
>>>>
>>>> So total solution looks like:
>>>> - Dirty-logging on, walk the memslot pagetable
>>>>     - On block: mark as read-only
>>>>     - On page: mark as writable-clean
>>>> - On splitting: Mark writable block's new pages as writable-clean
>>>> - On fault: after the split, mark the faulting page as writable-dirty
>>>>
>>>> This should take care of everything, including lazy/eager splitting
>>>> differences, as well as set the groundwork for HDBSS to work properly.
>>>>
>>>> What do you think?
>>>>
>>>
>>> I implemented that down, and will send it soon.
>>> Seeing the code will make it easier to understand the idea :)
>>>
>>> Thanks!
>>> Leo
>>>
>>
>> Hi Leo,
> 
> Hi Tian,
> 
> It was already done here, but I got sidetracked and forgot to send before.
> 
> https://lore.kernel.org/kvmarm/20260901171558.2674031-1-leo.bras@arm.com/
> 
> The relevant parts for the RO/RW -> RO/WC/WD conversion are in patches #1,
> #2 and #3.
> 

Hi, Leo,

Oh, awesome!

The RO/RW -> RO/WC/WD conversion is much clearer now.

Which means when dirty logging is not active, all pages that were
previously RW are now in the WD state. The WC state only appears when
dirty logging is actually enabled.

This makes the state machine much more intuitive, and I think it aligns
well with Oliver's suggestion to decouple permission from dirty state at
the page table level.

>>
>> v5 already implements this, and I'm about to send it out shortly.
>>
> 
> Oh, awesome!
> Please verify it against the patchset above, just in case :)
> 
> Thanks!
> Leo
> 

I'll review the patches in detail and verify v5 against your series.
 From what I've seen so far, performance with HDBSS looks great.

Thanks!
Tian

