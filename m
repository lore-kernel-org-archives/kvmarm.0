From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 08/21] arm64: KVM: Implement debug save/restore
Date: Tue, 01 Dec 2015 13:19:24 +0000
Message-ID: <871tb6b92b.fsf@linaro.org>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-9-git-send-email-marc.zyngier@arm.com> <20151201125639.GP11704@cbox> <565D9B57.2080005@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <565D9B57.2080005@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> On 01/12/15 12:56, Christoffer Dall wrote:
>> On Fri, Nov 27, 2015 at 06:50:02PM +0000, Marc Zyngier wrote:
>>> Implement the debug save restore as a direct translation of
>>> the assembly code version.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm64/kvm/hyp/Makefile   |   1 +
>>>  arch/arm64/kvm/hyp/debug-sr.c | 130 ++++++++++++++++++++++++++++++=
++++++++++++
>>>  arch/arm64/kvm/hyp/hyp.h      |   9 +++
>>>  3 files changed, 140 insertions(+)
>>>  create mode 100644 arch/arm64/kvm/hyp/debug-sr.c
<snip>
>>> +void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu=
)
>>> +{
>>> +	if ((vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE) ||
>>> +	    (vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE))

I've just noticed I'm seeing double here. Did a DBG_MDSCR_MDE can
transliterated here?

>>> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>>> +
>>> +	__debug_save_state(vcpu, &vcpu->arch.host_debug_state,
>>> +			   kern_hyp_va(vcpu->arch.host_cpu_context));
>>
>> doesn't the assmebly code jump across saving this state neither bits=
 are
>> set where this always saves the state?
>
> It doesn't. The save/restore functions are guarded by tests on
> KVM_ARM64_DEBUG_DIRTY, just like we have skip_debug_state on all acti=
ons
> involving the save/restore in the assembly version.
>
>> in any case, I feel some context is lost when this is moved away fro=
m
>> assembly and understanding this patch would be easier if the semanti=
cs
>> of these two _cond functions were documented.
>
> I can migrate the existing comments if you think that helps.
>
> Thanks,
>
> 	M.


--
Alex Benn=C3=A9e
