From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Fri, 8 Sep 2017 17:05:12 +0800
Message-ID: <8331df16-869c-9599-f559-fd284e571d9d@huawei.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <1bcd0c1e-c3b5-aac4-bb4f-83ee14b1d1ab@huawei.com>
 <20170908092155.4d90862b@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170908092155.4d90862b@why.wild-wind.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: James Morse <james.morse@arm.com>, christoffer.dall@linaro.org, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Marc,
   Thanks for reply.

On 2017/9/8 16:21, Marc Zyngier wrote:
>> Marc,
>>
>> sorry I have another question for the PAN.
>>
>> In the non-VHE mode, The host kernel is running in the EL1. Before
>> host kernel enter guest, host OS will call 'HVC' instruction to do
>> the world-switch, and the pstate.PAN will be saved into the SPSR_EL2.
>> When world-switch back to host kernel from EL2, it will call 'eret'
>> instruction to EL1 host, this 'eret' instruction will restore the
>> SPSR_EL2 to the PSTATE. so the PSTATE.PAN will be restored.
>>
>> For the Non-VHE mode, in the EL2 where mainly have word-switch code,
>> do you think it needs to reset the PSTATE.PAN? From the spec, it does
>> not provide SCTLR_EL2.SPAN bit for non-VHE mode, so reset the
>> PSTATE.PAN does not sure whether it is needed or whether affects the
>> performance. If you think it is needed for El2 in Non-VHE mode,
>> moving the reset PSTATE.PAN to the exception entry to EL2 may be
>> better, such as "el1_sync", because host can also call 'hvc'
>> instruction without guest running.
> So let's see if I correctly understand your question:
> 
> You're worried that we don't set/reset PSTATE.PAN at EL2 in non-VHE?
> In non-VHE, there is no user-space mapping that is present at the
> same time as the hypervisor mappings. Actually, we hardly have any
> mapping other than the HYP text/data and the vcpu/vm structures.

Not that meaning.
there are two meanings:

In short, we should not set PAN for El2 in non-VHE; If you think we should, current code does not cover all scenarios.


1. In the current mainline code it sets the PSTATE.PAN at EL2 in non-VHE. As you said,
in non-VHE, there is no user-space mapping that is present at the same time as the
hypervisor mappings, so I think it may not need to set both for EL1 and El2 in non-VHE,
but current code sets it. As you see[1], the code does not check VHE.

2. Conversely, in non-VHE, if you think we should set PAN in the EL2,
current code only sets it in the guest_exit path, do not cover all scenarios.
For example, when there is no guest, only have host, host calling 'HVC' instruction enter to El2 to do somethings,
then it will not call the guest_exit, so the PAN will not be set.
In order to handle this case, we should move it to the 'el1_sync'


ENTRY(__guest_exit)
        // x0: return code
        // x1: vcpu
        // x2-x29,lr: vcpu regs
        // vcpu x0-x1 on the stack

        add     x1, x1, #VCPU_CONTEXT

        ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)  	[1]

        // Store the guest regs x2 and x3
        stp     x2, x3,   [x1, #CPU_XREG_OFFSET(2)]

        // Retrieve the guest regs x0-x1 from the stack
        ldp     x2, x3, [sp], #16       // x0, x1


> 
> So how is PAN relevant in this context? What does it even mean?
> If you have a ARMv8.0 behaviour, PAN doesn't even seem to *exist* at
> EL2.
> 
> Or am I completely missing the point here?
