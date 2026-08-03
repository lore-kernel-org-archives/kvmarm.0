Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32732E717B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 01:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785720804; cv=none; b=ijFk42d+xR1AzPmPxElHirv89WwW6Ulhj96C6WYr9fqzQhde05CL3l/6Cdu9Mblr/rkps9/WeCCLta5JZUJw0H0bR3PhnXx82YIC4ubPipeIQsn633ZKzXAYv+B2xrBjWM1LI9xU+psSnPUSy2F8MOLbSplYHXUBBQutZ+7oYgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785720804; c=relaxed/simple;
	bh=7ITN1Zfnj0l7TX4s8QWERbygv5FfJNG4fyGt2cxZJsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d36ss/eOzqZLiVOFC+p1Omo/nuGlsIv4dofSOBkqaC76g0uKrEe9+tvMijXSjCFz+IwlsafKepe/+qWDlTNjYkPB4CL3jo+FlpeA2vFa4InYKJc+DoV8AW6kkOkrYZj+Hn5X1pN7PRnObuWs2h+9t+NcHS3YOu13HoyyvgCb8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=IrrNy1Te; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="IrrNy1Te"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/ElVnH6G4rldSzqvkWtQlDELwbWC65DsBa935CdX90I=;
	b=IrrNy1TeSFzMHgGn9EBDEGTdvrty/p2VhYuJSLdQZGHZKddYXkGof4FikGF8IcK8nEb4wdtKN
	yAcNIeYBNDmxy3DDxVUnkRoGyy7oJ6KcDPxTODucoYwgjRis7JCpNwmElk+qUauaONBCP7zc/TA
	CVeEzIK+gdzX7DfN0Xh0FH0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hCzTR23LSz1prN4;
	Mon,  3 Aug 2026 09:23:39 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E48640575;
	Mon,  3 Aug 2026 09:33:11 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 3 Aug 2026 09:33:02 +0800
Message-ID: <8e36e2c8-587f-4228-ab13-d6783927a281@huawei.com>
Date: Mon, 3 Aug 2026 09:33:02 +0800
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
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
 <aliKo7dTZzKcWHzI@kernel.org>
 <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com>
 <alpIfIOFfrudBzD5@LeoBrasDK> <al4bYajWE-v6wofu@LeoBrasDK>
 <96516762-f004-4c2a-a9c6-6fbad49ad6ae@huawei.com>
 <amoZY8uGLf1PEpjK@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <amoZY8uGLf1PEpjK@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/29/2026 11:16 PM, Leonardo Bras wrote:
> On Wed, Jul 29, 2026 at 04:51:59PM +0800, Tian Zheng wrote:
>>
>>
>> On 7/20/2026 8:58 PM, Leonardo Bras wrote:
>>> On Fri, Jul 17, 2026 at 04:21:32PM +0100, Leonardo Bras wrote:
>>>> On Fri, Jul 17, 2026 at 11:58:06AM +0800, Tian Zheng wrote:
>>>>>
>>>>> On 7/16/2026 3:39 PM, Oliver Upton wrote:
>>>>>> Hi Tian,
>>>>>>
>>>>>> On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
>>>>>>> -	if (prot & KVM_PGTABLE_PROT_W)
>>>>>>> +	if (prot & KVM_PGTABLE_PROT_W) {
>>>>>>>     		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>>>>>>
>>>>>>> +		/*
>>>>>>> +		 * No DEVICE filter needed here: relax_perms is only called
>>>>>>> +		 * on FSC_PERM faults. Device pages always get full RW from
>>>>>>> +		 * initial mapping and are never write-protected during
>>>>>>> +		 * migration, so they never trigger a permission fault.
>>>>>>> +		 */
>>>>>>> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
>>>>>>> +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>> +	} else {
>>>>>>> +		/*
>>>>>>> +		 * Clear DBM on W→RO downgrade to prevent hardware from
>>>>>>> +		 * silently upgrading RO+DBM back to W+dirty, which would
>>>>>>> +		 * bypass KVM's write tracking and cause data corruption.
>>>>>>> +		 */
>>>>>>> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>> +	}
>>>>>>> +
>>>>>> This block makes it pretty evident that the DBM bit really *is* the
>>>>>> write permission bit. I'd much rather we introduce the concept of dirty
>>>>>> state to the page table library and migrate the abstract write
>>>>>> permission to the DBM field, even if we don't have FEAT_HAFDBS.
>>>>>>
>>>>
>>>> Ohh, that's an amazing idea!
>>>
>>> Thinking about that again...
>>> If we adopt the encoding with DBM being the write-permission bit, and all
>>> PTEs have it since the start, how can we have lazy-splitting happening?
>>>
>>> Only way I think of is removing both DBM and S2_S2AP_W bit from writable
>>> PTEs during dirty-track enable, and re-adding them during the first write
>>> fault. If we don't remove the DBM bit, systems with HDBSS would just dirty
>>> it by hardware, without causing a fault.
>>>
>>> DBM=0 would need to happen only in the first write-protect (only on
>>> lazy-splitting). All other write-protecting would just clean the S2_S2AP_W
>>> bit, as everything is already split.
>>>
>>> Is that what was intended?
>>>
>>> Thanks!
>>> Leo
>>>
>> Hi Leo,
>>
>> I think the cleanest way to handle this is to simply avoid setting DBM
>> on block mappings. If we only set DBM on page-level PTEs, then block
>> mappings will naturally stay DBM=0 and trigger a write fault on first
>> access — exactly what we need for lazy splitting.
>>
>> When the fault occurs, the block gets split into page-level PTEs, and at
>> that point we can set DBM=1 on the resulting leaf entries. This way:
>>
>> 1. Lazy split works naturally (fault -> split -> set DBM=1)
>>
>> 2. No need to clear DBM globally at dirty-track enable
>>
>> 3. No special handling for block mappings
>>
>> So I think global DBM is still viable — we just need to filter out block
>> mappings when setting the DBM bit. That way the lazy split path is preserved
>> without extra complexity.
> 
> Hi Tian,
> 
> Humm, but would not that be contrary to what Oliver suggested: changing the
> encoding from the PTE for all entries?
> 
> (Like, if the PTE is writable, it has to have DBM set)
> 
> IIUC what you said, on first faulting of the page in the VM:
> - If the entry is a page (level-3 leaf) and writable, add DBM
> - If it's a block entry (leaf but not a level-3), don't add DBM
> 
> So after we enable dirty-logging:
> - a level-3 entry would not fault, using HDBSS, and
> - a block entry would fault, do the splitting, and add DBM to level-3
>    entries during the split.
> 
> If I got that correct, that would be clean indeed.
> 
> But then we would have a different encoding for block entries and page
> entries. In page entries, DBM could be used to say if the page is writable,
> but on block entries one would have to look at the 'dirty-bit'.
> 
> Would that be ok?
> 
> Thanks!
> Leo
> 
Hi Leo,

My initial concern was that clearing all DBM bits at the start of
migration would be too expensive, so I thought distinguishing between
level-3 entries and block entries would be better.

However, I ran a quick test on a 400GB VM (4 vCPUs), and the overhead
turned out to be around 30ns — which I think is acceptable.

So I think we can go with your approach: simply clear DBM globally in
kvm_arch_commit_memory_region() when dirty logging starts, before write-
protecting the memslot.

```
void kvm_arch_commit_memory_region(...)
{
     // ...
     if (log_dirty_pages) {
         if (change == KVM_MR_DELETE)
             return;

         kvm_mmu_clear_dbm_memory_region(kvm, new->id);
         // ...
     }
     // ...
}
```

Thanks!
Tian
