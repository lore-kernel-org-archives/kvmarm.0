Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B592F4A1B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762279412; cv=none; b=JyzGzi4lKkj5sbFlXW3Cwq+CpJQk6no8jsLj9/t5tV0+Ta1mkyAVO5xq+k6rMLvTW89ntCyLWX2Tk7/l5BucsLj1pCPV+J5D3pH+7mJUCQD27oOPaqdvEa2vy9CqBtbSx8+ulQ/QfFgQCtM/n3YGNJuR5WSsiYMb27lALQj8Zi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762279412; c=relaxed/simple;
	bh=/KsN1iLQuyjGjPHCrirT2JSqORR5KvIcw5R/cWUp+6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDxg1hYRR7gapVpKJl/lVMGFQHpQearzaxmoTEUxeqGzLe9LDmEKItGrAM5O6L86L93K73RJ0qM8ZTfpAkK4SsjvT0vcUs6Ez3zZp2xOkGkrB9V/uIIgG+tYnWyVFth9RTzl8hwYd94soNvkFr2PmvNntOY06nbkjUTt5Mrprd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A70B1CE0;
	Tue,  4 Nov 2025 10:03:22 -0800 (PST)
Received: from [10.57.71.89] (unknown [10.57.71.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D7923F694;
	Tue,  4 Nov 2025 10:03:28 -0800 (PST)
Message-ID: <fbe0d81a-c4c2-46f5-b809-1b74f9307c98@arm.com>
Date: Tue, 4 Nov 2025 18:03:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, vladimir.murzin@arm.com
References: <20251104125906.1919426-1-tabba@google.com>
 <20251104125906.1919426-6-tabba@google.com>
 <a0b19558-dbcb-4231-b0c4-302cc10652db@arm.com>
 <CA+EHjTwPqm5wkmdGK60sn+S9BizK6LG5bSqWQLigsZVgXoJmUw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTwPqm5wkmdGK60sn+S9BizK6LG5bSqWQLigsZVgXoJmUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/11/2025 17:56, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 4 Nov 2025 at 17:50, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 04/11/2025 12:59, Fuad Tabba wrote:
>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
>>> register accesses. These accesses are trapped to EL2 when the bits are
>>> clear.
>>>
>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
>>> had the polarity inverted. When a guest did not support the ExtTrcBuff
>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
>>> potentially allowing a protected guest to access registers for a feature
>>> it was not given.
>>>
>>> Fix this by inverting the operation.
>>>
>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> index 43bde061b65d..df0c59a29b35 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>>>                val |= MDCR_EL2_TTRF;
>>>
>>>        if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
>>
>> Why are we checkin ExtTrcBuff ? Shouldn't that be TraceBuffer ?
> 
> This is an existing bug that needs to be fixed. Thank for spotting it.
> 
>>> -             val |= MDCR_EL2_E2TB_MASK;
>>> +             val &= ~MDCR_EL2_E2TB_MASK;
>> This looks correct to me.
> 
> I don't thin it's correct. E2TB traps when clear, not set:
> https://developer.arm.com/documentation/ddi0601/2025-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-

I meant your change to val looks correct.

Suzuki

> 
>> Suzuki
>>
>>>
>>>        /* Trap Debug Communications Channel registers */
>>>        if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
>>
>>

