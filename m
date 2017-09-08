From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Fri, 8 Sep 2017 13:10:36 +0100
Message-ID: <17a7c202-fd18-a74f-b20d-d6e65af00025@arm.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <1bcd0c1e-c3b5-aac4-bb4f-83ee14b1d1ab@huawei.com>
 <20170908092155.4d90862b@why.wild-wind.fr.eu.org>
 <8331df16-869c-9599-f559-fd284e571d9d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <8331df16-869c-9599-f559-fd284e571d9d@huawei.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: James Morse <james.morse@arm.com>, christoffer.dall@linaro.org, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/09/17 10:05, gengdongjiu wrote:
> Marc,
>    Thanks for reply.
> 
> On 2017/9/8 16:21, Marc Zyngier wrote:
>>> Marc,
>>>
>>> sorry I have another question for the PAN.
>>>
>>> In the non-VHE mode, The host kernel is running in the EL1. Before
>>> host kernel enter guest, host OS will call 'HVC' instruction to do
>>> the world-switch, and the pstate.PAN will be saved into the SPSR_EL2.
>>> When world-switch back to host kernel from EL2, it will call 'eret'
>>> instruction to EL1 host, this 'eret' instruction will restore the
>>> SPSR_EL2 to the PSTATE. so the PSTATE.PAN will be restored.
>>>
>>> For the Non-VHE mode, in the EL2 where mainly have word-switch code,
>>> do you think it needs to reset the PSTATE.PAN? From the spec, it does
>>> not provide SCTLR_EL2.SPAN bit for non-VHE mode, so reset the
>>> PSTATE.PAN does not sure whether it is needed or whether affects the
>>> performance. If you think it is needed for El2 in Non-VHE mode,
>>> moving the reset PSTATE.PAN to the exception entry to EL2 may be
>>> better, such as "el1_sync", because host can also call 'hvc'
>>> instruction without guest running.
>> So let's see if I correctly understand your question:
>>
>> You're worried that we don't set/reset PSTATE.PAN at EL2 in non-VHE?
>> In non-VHE, there is no user-space mapping that is present at the
>> same time as the hypervisor mappings. Actually, we hardly have any
>> mapping other than the HYP text/data and the vcpu/vm structures.
> 
> Not that meaning.
> there are two meanings:
> 
> In short, we should not set PAN for El2 in non-VHE; If you think we should, current code does not cover all scenarios.
> 
> 
> 1. In the current mainline code it sets the PSTATE.PAN at EL2 in non-VHE. As you said,
> in non-VHE, there is no user-space mapping that is present at the same time as the
> hypervisor mappings, so I think it may not need to set both for EL1 and El2 in non-VHE,
> but current code sets it. As you see[1], the code does not check VHE.
> 
> 2. Conversely, in non-VHE, if you think we should set PAN in the EL2,

It is not about what I think. It is about what the architecture gives you.

There cannot be any userspace mapping at EL2 when non-VHE, so there
cannot be any valid PAN setting. I repeat: there is not such thing as
PAN at EL2 when HCR_EL2.E2H==0. This bit *has no effect*. Just read the
documentation (ARM DDI 0487B.a, D4.4.2).

If you're going to change this kind of code, please start by
understanding the architecture.

	M.
-- 
Jazz is not dead. It just smells funny...
