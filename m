Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF434389106
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785729875; cv=none; b=B6RqGZbPWbYQ2JuaKLx8hTFUWE/fl9MEpXio04nRRAQIlDfuOkLcRNSSzsOewRYAkvwDuzlGFlCcrXQdvGVOD9lXfgpk90DO0BzNcUfSlNHP96aZacqURX4BgO4aWH7gXHy+558huEMphTvPgU0QyLByKuCC3tmvb4JW68NFrsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785729875; c=relaxed/simple;
	bh=dCoIJ8u5Nc8PubI7ykKqHN1Qg+lyi5hVleww2xao4xU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kYGKlSLrrwIePhB1r/bx0nq9sHQA35PMcPGTo0bRdnRiwwj/ngGNFpr5GPnBhiqCK3VLZehpSIJcZ2bOdP23K8EW1yNSm2Lf+j1HwS/1W3mOi16Rr5x5eRtvDKosoK0ZgZq6SHAaM4Ah04qPWXznSJT0iUeay3FVvLAa9BPp+Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FxNhkzZJ; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FxNhkzZJ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9mE9bDxid/FOYfdNaXqsmABxipYaalsmmbddDnuwAss=;
	b=FxNhkzZJnTU37Fp8VY/9g6xevYxYnwL1NxlKW5fQhNdtBhETzDoZAokXo+g3GhfhbPj3nUuKR
	PBwq8aS/SYefkyZ6wU/ft9ojVmlWbXSNY4qc7tZeho4g3epd7osCUHCdJBJ6RL5PRnpdfE+xQT+
	Ms/q5SKcGdG6nXmBsH8t8bY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hD2r12Ht7zRhR0;
	Mon,  3 Aug 2026 11:54:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id F196440561;
	Mon,  3 Aug 2026 12:04:25 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 3 Aug 2026 12:04:25 +0800
Message-ID: <45d76d0d-48e9-46a6-b1f9-691f840eba46@huawei.com>
Date: Mon, 3 Aug 2026 12:04:24 +0800
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
 <8e36e2c8-587f-4228-ab13-d6783927a281@huawei.com>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <8e36e2c8-587f-4228-ab13-d6783927a281@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 8/3/2026 9:33 AM, Tian Zheng wrote:
>>>>>>> 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
>>>>>>>> -    if (prot & KVM_PGTABLE_PROT_W)
>>>>>>>> +    if (prot & KVM_PGTABLE_PROT_W) {
>>>>>>>>             set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>>>>>>>
>>>>>>>> +        /*
>>>>>>>> +         * No DEVICE filter needed here: relax_perms is only 
>>>>>>>> called
>>>>>>>> +         * on FSC_PERM faults. Device pages always get full RW 
>>>>>>>> from
>>>>>>>> +         * initial mapping and are never write-protected during
>>>>>>>> +         * migration, so they never trigger a permission fault.
>>>>>>>> +         */
>>>>>>>> +        if (pgt->flags & KVM_PGTABLE_S2_DBM)
>>>>>>>> +            set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>>> +    } else {
>>>>>>>> +        /*
>>>>>>>> +         * Clear DBM on W→RO downgrade to prevent hardware from
>>>>>>>> +         * silently upgrading RO+DBM back to W+dirty, which would
>>>>>>>> +         * bypass KVM's write tracking and cause data corruption.
>>>>>>>> +         */
>>>>>>>> +        clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>> This block makes it pretty evident that the DBM bit really *is* the
>>>>>>> write permission bit. I'd much rather we introduce the concept of 
>>>>>>> dirty
>>>>>>> state to the page table library and migrate the abstract write
>>>>>>> permission to the DBM field, even if we don't have FEAT_HAFDBS.
>>>>>>>
>>>>>
>>>>> Ohh, that's an amazing idea!
>>>>
>>>> Thinking about that again...
>>>> If we adopt the encoding with DBM being the write-permission bit, 
>>>> and all
>>>> PTEs have it since the start, how can we have lazy-splitting happening?
>>>>
>>>> Only way I think of is removing both DBM and S2_S2AP_W bit from 
>>>> writable
>>>> PTEs during dirty-track enable, and re-adding them during the first 
>>>> write
>>>> fault. If we don't remove the DBM bit, systems with HDBSS would just 
>>>> dirty
>>>> it by hardware, without causing a fault.
>>>>
>>>> DBM=0 would need to happen only in the first write-protect (only on
>>>> lazy-splitting). All other write-protecting would just clean the 
>>>> S2_S2AP_W
>>>> bit, as everything is already split.
>>>>
>>>> Is that what was intended?
>>>>
>>>> Thanks!
>>>> Leo
>>>>
>>> Hi Leo,
>>>
>>> I think the cleanest way to handle this is to simply avoid setting DBM
>>> on block mappings. If we only set DBM on page-level PTEs, then block
>>> mappings will naturally stay DBM=0 and trigger a write fault on first
>>> access — exactly what we need for lazy splitting.
>>>
>>> When the fault occurs, the block gets split into page-level PTEs, and at
>>> that point we can set DBM=1 on the resulting leaf entries. This way:
>>>
>>> 1. Lazy split works naturally (fault -> split -> set DBM=1)
>>>
>>> 2. No need to clear DBM globally at dirty-track enable
>>>
>>> 3. No special handling for block mappings
>>>
>>> So I think global DBM is still viable — we just need to filter out block
>>> mappings when setting the DBM bit. That way the lazy split path is 
>>> preserved
>>> without extra complexity.
>>
>> Hi Tian,
>>
>> Humm, but would not that be contrary to what Oliver suggested: 
>> changing the
>> encoding from the PTE for all entries?
>>
>> (Like, if the PTE is writable, it has to have DBM set)
>>
>> IIUC what you said, on first faulting of the page in the VM:
>> - If the entry is a page (level-3 leaf) and writable, add DBM
>> - If it's a block entry (leaf but not a level-3), don't add DBM
>>
>> So after we enable dirty-logging:
>> - a level-3 entry would not fault, using HDBSS, and
>> - a block entry would fault, do the splitting, and add DBM to level-3
>>    entries during the split.
>>
>> If I got that correct, that would be clean indeed.
>>
>> But then we would have a different encoding for block entries and page
>> entries. In page entries, DBM could be used to say if the page is 
>> writable,
>> but on block entries one would have to look at the 'dirty-bit'.
>>
>> Would that be ok?
>>
>> Thanks!
>> Leo
>>
> Hi Leo,
> 
> My initial concern was that clearing all DBM bits at the start of
> migration would be too expensive, so I thought distinguishing between
> level-3 entries and block entries would be better.
> 
> However, I ran a quick test on a 400GB VM (4 vCPUs), and the overhead
> turned out to be around 30ns — which I think is acceptable.

Just a quick correction — I misstated the unit in my previous email. The 
overhead for clearing DBM on the 400GB VM (4 vCPUs) was around 32 µs, 
not 30 ns.

> 
> So I think we can go with your approach: simply clear DBM globally in
> kvm_arch_commit_memory_region() when dirty logging starts, before write-
> protecting the memslot.
> 
> ```
> void kvm_arch_commit_memory_region(...)
> {
>      // ...
>      if (log_dirty_pages) {
>          if (change == KVM_MR_DELETE)
>              return;
> 
>          kvm_mmu_clear_dbm_memory_region(kvm, new->id);
>          // ...
>      }
>      // ...
> }
> ```
> 
> Thanks!
> Tian

