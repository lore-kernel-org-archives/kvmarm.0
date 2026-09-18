Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D67F4E73A1
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731835; cv=none; b=KYC0I387Wre0K4Z5A3txC/E/vpuxb4rWDLGnelx4Q5/objG7TZIuv2SgwRBe00RXQJFnAqUgm6/h7RQmXzgSbOgwF6K/hW9qNyktSqtnY0VLM4W3HvaC0vRAu9VPuD+sXPI0Olj0di+0NUUeBBaAQLtCoE34k7XO2bO8/ZzbpI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731835; c=relaxed/simple;
	bh=Us8cofqcFXbDtFaXelWJxwYr3mK/i18OI7D5yUMNU3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZKFWASH7jRPd26ZyzLzdeT3ukCIR/dfFD5HdGhV2GhUU9ZqQraTf6UIbIL5NYNSSzjYtEhjqO8OXu66NpMTcT9/98ldMSx7Me6AdnqFo/WApptRP7PJ9OwMc4BH+zZ61ULDAqY4dMom/xn6UuK2G5kKPeYGteot8sAj6YRhyDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Jcy4kvb6; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Jcy4kvb6"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X/nASaHEAycknDEMuta+KNUeT5Wrc8KXViYcggb/2yo=;
	b=Jcy4kvb63Kd+VZhYjHZYKpY67W9Xd6KABsG992lmGW2zrTseGfuQ52OHyGQEZzxrRbyUkrB/K
	cdndwnyhcyC+iQamuToJ/tTBJGjQP/hyJ2Cwo5YWJVQoed/M0sk2HT9b4g3ILxC3M/PrMXDv08n
	/vVJpGvLLRziSwq9yAu9jxY=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hmVpy5S4nz1K96s;
	Fri, 18 Sep 2026 19:32:42 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id DCA5B40572;
	Fri, 18 Sep 2026 19:43:42 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 19:43:42 +0800
Message-ID: <d039151a-d114-47fd-988d-df80751f1c97@huawei.com>
Date: Fri, 18 Sep 2026 19:43:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
To: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Tian Zheng <zhengtian10@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org>
 <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org>
 <aqp73SxO78o7LJTs@LeoBrasDK> <86fqz95qwe.wl-maz@kernel.org>
 <aqqY1QiB0ZBAQkwc@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <aqqY1QiB0ZBAQkwc@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/16/2026 9:25 PM, Leonardo Bras wrote:
> On Wed, Sep 16, 2026 at 01:20:33PM +0100, Marc Zyngier wrote:
>> On Wed, 16 Sep 2026 12:22:05 +0100,
>> Leonardo Bras <leo.bras@arm.com> wrote:
>>>
>>> On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
>>>> On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
>>>>>> Yes, the HW should ignore it. But we have also
>>>>>> seen quite a few broken designs in this area...
>>>>>>
>>>>>
>>>>> I lack experience on what bad thing could happen. So I will expand on what
>>>>> I belive to understand up to here:
>>>>>
>>>>> - The PTE is in memory, so the DBM bit can be set regardless of being RES0
>>>>> - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
>>>>> - For HW pagetable walking, maybe some faulty implementation may rely on
>>>>>    bit51 being RES0, and fault otherwise.
>>>>>
>>>>> If that's the case, then we would have to actually support both encodings,
>>>>> and only enable the new one if HAFDBS is available in the system.
>>>>>
>>>>> I just wonder how high are the chances to have such a broken design,
>>>>> or other broken designs did not come to my mind, and if we have to start
>>>>> with that multiple-encoding option.
>>>>
>>>> FWIW, the host stage-1 already uses the DBM bit unconditionally,
>>>> treating it as a software bit on implementations without HAFDBS.
>>>> Although given the quality of any garden variety Arm MMU I understand
>>>> where Marc is coming from.
>>>>
>>>> I don't think the HAFDBS enablement is complicated enough to be done in
>>>> a separate series without any meaningful users, nor would I really be
>>>> interested in taking it without, say, HDBSS.
>>>>
>>>> Can you please work with Tian to get a combined series out for this?
>>>>
>>>
>>> Hi Oliver, thanks for reviewing!
>>>
>>> Sure, one of the reasons I sent like this is so Tian could use it as a base
>>> for his next version.
>>>
>>>
>>>>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>>>> index 17123f0b6dab..eb8dfffc32c7 100644
>>>>>>> --- a/arch/arm64/kvm/nested.c
>>>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>>>> @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>>>>>>>   	}
>>>>>>>   
>>>>>>>   	addr_bottom += contiguous_bit_shift(desc, wi, level);
>>>>>>>   
>>>>>>>   	/* Calculate and return the result */
>>>>>>>   	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
>>>>>>>   		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
>>>>>>>   	out->output = paddr;
>>>>>>>   	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
>>>>>>>   	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>>>>>> -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>>>>>> +	/* Takes care of both RO/RW and RO/WC/WD encodings */
>>>>>>> +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
>>>>>>> +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
>>>>>>
>>>>>> Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
>>>>>> if it did, you are now actively corrupting memory by turning a RO
>>>>>> mapping with a spurious DBM bit set into a writable mapping.
>>>>>> VTCR_EL2.HD exists for a reason.
>>>>>>
>>>>>> Do you see why your blanket approach of equating DBM with writable is
>>>>>> plain wrong?
>>>>>
>>>>> Sorry, not really... please help me understand it.
>>>>>
>>>>> When you say a spurious DBM bit, what does it mean?
>>>>
>>>> You've implemented the exact sort of bug that was alluded to above. In
>>>> this case it's a software page table walker consuming DBM regardless of
>>>> the value of VTCR_EL2.HD.
>>>>
>>>
>>> So you mean that DBM being treated as "writable" could _only_ happen if we
>>> have VTCR_EL2.HD=1? I was previously under the impression that it could be
>>> used regardless of HD value.
>>
>> Then you have failed to understand the architecture. When
>> VTCR_EL2.HD==0, DBM can be treated as RES0, RES0, or RES0.
>>
>> R_XZFQH and R_BRFGY are pretty clear that DBM can only be evaluated
>> when dirty hw update is enabled, and I_MHJZP tells you what it means
>> for S2 to have this enabled.
> 
> Right, I_MHJZP says that if VTCR_EL2.HD is 1, then dirty state hardware
> management is enabled.
> 
> Then, R_XZFQH and R_BRFGY say that if (DBM+S2AP) bit combination is the
> given and the dirty state hardware management is enabled then a block
> descriptor is WC/WD.
> 
> R_XZFQH header, as an example:
> For each translation stage using Direct permissions, if all of the
> following apply, then a Block descriptor or Page descriptor is described
> as writable-clean[...]
> 
> It says:
> "if all apply, the block is WC",
> it does not say
> "only if all apply, the block is WC".
> so it forces one way, but not the other.
> 
> So I previously understood that we could also use the encoding for WC/WD in
> software, to avoid having 2 distinct encodings, when VTCR_EL2.HD=0.
> 
> If that's not possible, as you mentioned, then yes, I failed to get that
> part. I also see that you mention it being RES0 when VTCR_EL2.HD==0, but I
> honestly could not find reference to that. :(
> 
> What I could find on Arm ARM M.cc was Table D8-53, which states for
> bit 51 that it's DBM if indirect permissions are disabled, or PIINDEX[1]
> if they are enabled. There is also no such information in D8.5.2 about this
> res0 behavior.
> 
> So I am possibly missing the proper place to look for that information.
> Could you please share that with me so I can improve and maybe avoid being
> a inconvenience in the future?
> 
> Thanks!
> Leo
> 

Hi Leo, Marc,

On the NV side, KVM itself already limits the L1-visible
ID_AA64MMFR1_EL1.HAFDBS to AF-only in limit_nv_id_reg(), so bit 51 has
no architectural meaning to L1, and an L1 using it as software metadata
would have its read-only pages misread as writable by the union read in
walk_nested_s2_pgd() — the memory corruption Marc described. Since NV
has no HAFDBS emulation today, I'd suggest we simply revert this hunk
for now and keep reading writability from S2AP[1] alone:

```
out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
```

It seems we can address the NV side later, once nested HAFDBS is
actually supported.

That's what I did when picking the series up for HDBSS v5: patch 1 drops
the nested.c hunk.

Thanks,
Tian
