Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAE53CFF53
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 09:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724365; cv=none; b=vCeK1X+v8fPoblo8RxBQRV28v1ICftjyRzhoZk/PCwJWhjTVQlg+m69TdcnE5sctxjm9xwvfxewoKtv5DK0DHRXPPu6nNqSwkAPyaj3EiC/tQZIjFenj/ouOMdrKNRms4p0ppae3Rce2TdvYH04x5lpJ1HS4YNTWYV0HNscHbIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724365; c=relaxed/simple;
	bh=x30Xff6v9RoHS3rr+aR/zikdov5W8APnTFwkltti0dU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jsoURTDj90jsHRsdui/rqTpqrT269gUmjMR0JB/7M9j/nTSIWRw+tPRvyERB0A9wfEM6Trs5lTelFwICJcsG8wv5Ezw30eewXnRy1ld1Mg5+jG5on5UcUM8IhvCl39zTBh9Wg98wfgsTFfZhPhcsClBzdg3pTPvRaSdPO98/2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=yxGnWENT; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="yxGnWENT"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SYG6Rv7rKoT3HJcrg2i2QELzkrtM2tVPl3fiKJLD4rM=;
	b=yxGnWENTYn0X7FGHufcyGrNC9lHdsm1QQvV0Qk3LMfvm7yNoH4+MkhoRaS19uC7kBn/EE+lsG
	pxXRYwaaapCS2zkfc3DvbFMgxYv4VJf4rySxVWtOQ8/uMiKQHaDXyjrjVM+50X7WczZnRA5UQJC
	7/BsLcMuQfl9/LCfJt8KGcU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hmS372yfJzcb4c;
	Fri, 18 Sep 2026 17:28:03 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 83AB14057F;
	Fri, 18 Sep 2026 17:39:18 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 17:39:17 +0800
Message-ID: <eb629070-a02f-426a-92ee-b2c8f9e2aa9a@huawei.com>
Date: Fri, 18 Sep 2026 17:39:17 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from
 S2AP_W to DBM
To: Leonardo Bras <leo.bras@arm.com>, Oliver Upton <oupton@kernel.org>
CC: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey
 Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org>
 <aql8jY4o8SzjJuFU@LeoBrasDK> <aqnku2TcFzIKhjQl@kernel.org>
 <aqp73SxO78o7LJTs@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <aqp73SxO78o7LJTs@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/16/2026 7:22 PM, Leonardo Bras wrote:
> On Tue, Sep 15, 2026 at 05:37:15PM -0700, Oliver Upton wrote:
>> On Tue, Sep 15, 2026 at 06:12:45PM +0100, Leonardo Bras wrote:
>>>> Yes, the HW should ignore it. But we have also
>>>> seen quite a few broken designs in this area...
>>>>
>>>
>>> I lack experience on what bad thing could happen. So I will expand on what
>>> I belive to understand up to here:
>>>
>>> - The PTE is in memory, so the DBM bit can be set regardless of being RES0
>>> - For SW pagetable walking, I don't think 'bit 51 == 0' is checked
>>> - For HW pagetable walking, maybe some faulty implementation may rely on
>>>    bit51 being RES0, and fault otherwise.
>>>
>>> If that's the case, then we would have to actually support both encodings,
>>> and only enable the new one if HAFDBS is available in the system.
>>>
>>> I just wonder how high are the chances to have such a broken design,
>>> or other broken designs did not come to my mind, and if we have to start
>>> with that multiple-encoding option.
>>
>> FWIW, the host stage-1 already uses the DBM bit unconditionally,
>> treating it as a software bit on implementations without HAFDBS.
>> Although given the quality of any garden variety Arm MMU I understand
>> where Marc is coming from.
>>
>> I don't think the HAFDBS enablement is complicated enough to be done in
>> a separate series without any meaningful users, nor would I really be
>> interested in taking it without, say, HDBSS.
>>
>> Can you please work with Tian to get a combined series out for this?
>>
> 
> Hi Oliver, thanks for reviewing!
> 
> Sure, one of the reasons I sent like this is so Tian could use it as a base
> for his next version.
> 
> 

Hi Oliver, Leo,

Works for us. I plan to send HDBSS v5 maybe next week with this series
merged in. Both dirty-tracking consumers are already built on top of the
DBM approach: dirty ring and dirty bitmap.

Leo, with your blessing, I'd like to pick patches 1-4 into the HDBSS
tree with your Signed-off-by preserved and mine added on top, plus some
bug fixes on top of this RFC series.

For patch 5, I'd like to rework it into a derived hardware dirty mode
that replaces both kvm_set_hafdbs() and our earlier HDBSS enable/disable
hooks, so the whole thing lands as one series.

Performance looks good in both dirty ring and dirty bitmap scenarios so
far.

Thanks,
Tian

>>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>> index 17123f0b6dab..eb8dfffc32c7 100644
>>>>> --- a/arch/arm64/kvm/nested.c
>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>> @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>>>>>   	}
>>>>>   
>>>>>   	addr_bottom += contiguous_bit_shift(desc, wi, level);
>>>>>   
>>>>>   	/* Calculate and return the result */
>>>>>   	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
>>>>>   		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
>>>>>   	out->output = paddr;
>>>>>   	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
>>>>>   	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>>>>> -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>>>> +	/* Takes care of both RO/RW and RO/WC/WD encodings */
>>>>> +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
>>>>> +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
>>>>
>>>> Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
>>>> if it did, you are now actively corrupting memory by turning a RO
>>>> mapping with a spurious DBM bit set into a writable mapping.
>>>> VTCR_EL2.HD exists for a reason.
>>>>
>>>> Do you see why your blanket approach of equating DBM with writable is
>>>> plain wrong?
>>>
>>> Sorry, not really... please help me understand it.
>>>
>>> When you say a spurious DBM bit, what does it mean?
>>
>> You've implemented the exact sort of bug that was alluded to above. In
>> this case it's a software page table walker consuming DBM regardless of
>> the value of VTCR_EL2.HD.
>>
> 
> So you mean that DBM being treated as "writable" could _only_ happen if we
> have VTCR_EL2.HD=1? I was previously under the impression that it could be
> used regardless of HD value.
> 
>> If the guest hypervisor sets VTCR_EL2.HD=0, the expectation is that the
>> shadow stage-2 MMU treats the corresponding bit in the PTE as RES0.
>>
> 
> Okay, I think I can see it now: since the guest hypervisor could use RO/RW,
> and has no decoupled concept of dirty and writable, it could think all
> writable pages are dirty when we run above function.
> 
> So.. would it make sense to have an out->dirty, which we would check based
> on S2AP while out->writable is compared against DBM, and we change the
> logic that uses out->writable to properly match it, maybe based on the
> guest having the feature enabled?
> 
> Thanks for your patience on explaining this!
> Leo
> 

