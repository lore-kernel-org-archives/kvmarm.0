From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 12/21] arm64: KVM: Implement fpsimd save/restore
Date: Tue, 17 Nov 2015 11:56:54 +0000
Message-ID: <564B1606.6060409@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>	<1447679519-17888-13-git-send-email-marc.zyngier@arm.com>	<CAPvkgC0wLpRShZkHQ3KcFU0omLoACcgJ0L37f3qPEZfkONy1iQ@mail.gmail.com>	<564B0E8F.9040009@arm.com> <CAPvkgC0FLL0QLzFR=uksWx2_m-Kc9Djbz4z25zDUB41K0go-Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAPvkgC0FLL0QLzFR=uksWx2_m-Kc9Djbz4z25zDUB41K0go-Nw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Steve Capper <steve.capper@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <Mark.Rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 17/11/15 11:49, Steve Capper wrote:
> On 17 November 2015 at 11:25, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 17/11/15 11:13, Steve Capper wrote:
>>> On 16 November 2015 at 13:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> Implement the fpsimd save restore, keeping the lazy part in
>>>> assembler (as returning to C would be overkill).
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/hyp/Makefile |  1 +
>>>>  arch/arm64/kvm/hyp/entry.S  | 32 +++++++++++++++++++++++++++++++-
>>>>  arch/arm64/kvm/hyp/fpsimd.S | 33 +++++++++++++++++++++++++++++++++
>>>>  arch/arm64/kvm/hyp/hyp.h    |  3 +++
>>>>  arch/arm64/kvm/hyp/switch.c |  8 ++++++++
>>>>  5 files changed, 76 insertions(+), 1 deletion(-)
>>>>  create mode 100644 arch/arm64/kvm/hyp/fpsimd.S
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>> index 9c11b0f..56238d0 100644
>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>> @@ -9,3 +9,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
>>>>  obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
>>>>  obj-$(CONFIG_KVM_ARM_HOST) += entry.o
>>>>  obj-$(CONFIG_KVM_ARM_HOST) += switch.o
>>>> +obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
>>>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>>>> index 2c4449a..7552922 100644
>>>> --- a/arch/arm64/kvm/hyp/entry.S
>>>> +++ b/arch/arm64/kvm/hyp/entry.S
>>>> @@ -27,6 +27,7 @@
>>>>
>>>>  #define CPU_GP_REG_OFFSET(x)   (CPU_GP_REGS + x)
>>>>  #define CPU_XREG_OFFSET(x)     CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
>>>> +#define CPU_SYSREG_OFFSET(x)   (CPU_SYSREGS + 8*x)
>>>>
>>>>         .text
>>>>         .pushsection    .hyp.text, "ax"
>>>> @@ -152,4 +153,33 @@ ENTRY(__guest_exit)
>>>>         ret
>>>>  ENDPROC(__guest_exit)
>>>>
>>>> -       /* Insert fault handling here */
>>>> +ENTRY(__fpsimd_guest_restore)
>>>> +       push    x4, lr
>>>> +
>>>> +       mrs     x2, cptr_el2
>>>> +       bic     x2, x2, #CPTR_EL2_TFP
>>>> +       msr     cptr_el2, x2
>>>> +       isb
>>>> +
>>>> +       mrs     x3, tpidr_el2
>>>> +
>>>> +       ldr     x0, [x3, #VCPU_HOST_CONTEXT]
>>>> +       kern_hyp_va x0
>>>> +       add     x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>>>> +       bl      __fpsimd_save_state
>>>> +
>>>> +       add     x2, x3, #VCPU_CONTEXT
>>>> +       add     x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>>>> +       bl      __fpsimd_restore_state
>>>> +
>>>> +       mrs     x1, hcr_el2
>>>> +       tbnz    x1, #HCR_RW_SHIFT, 1f
>>>> +       ldr     x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
>>>> +       msr     fpexc32_el2, x4
>>>> +1:
>>>> +       pop     x4, lr
>>>> +       pop     x2, x3
>>>> +       pop     x0, x1
>>>> +
>>>> +       eret
>>>> +ENDPROC(__fpsimd_guest_restore)
>>>> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
>>>> new file mode 100644
>>>> index 0000000..da3f22c
>>>> --- /dev/null
>>>> +++ b/arch/arm64/kvm/hyp/fpsimd.S
>>>> @@ -0,0 +1,33 @@
>>>> +/*
>>>> + * Copyright (C) 2015 - ARM Ltd
>>>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>> + */
>>>> +
>>>> +#include <linux/linkage.h>
>>>> +
>>>> +#include <asm/fpsimdmacros.h>
>>>> +
>>>> +       .text
>>>> +       .pushsection    .hyp.text, "ax"
>>>> +
>>>> +ENTRY(__fpsimd_save_state)
>>>> +       fpsimd_save     x0, 1
>>>> +       ret
>>>> +ENDPROC(__fpsimd_save_state)
>>>> +
>>>> +ENTRY(__fpsimd_restore_state)
>>>> +       fpsimd_restore  x0, 1
>>>> +       ret
>>>> +ENDPROC(__fpsimd_restore_state)
>>>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>> index bf13238..240fb79 100644
>>>> --- a/arch/arm64/kvm/hyp/hyp.h
>>>> +++ b/arch/arm64/kvm/hyp/hyp.h
>>>> @@ -70,6 +70,9 @@ void __debug_clear_restore_state(struct kvm_vcpu *vcpu,
>>>>                                  struct kvm_guest_debug_arch *dbg,
>>>>                                  struct kvm_cpu_context *ctxt);
>>>>
>>>> +void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>>>> +void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>>>> +
>>>>  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>>>>
>>>>  #endif /* __ARM64_KVM_HYP_H__ */
>>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>>> index a3af81a..06d3e20 100644
>>>> --- a/arch/arm64/kvm/hyp/switch.c
>>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>>> @@ -88,6 +88,7 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>>>>  {
>>>>         struct kvm_cpu_context *host_ctxt;
>>>>         struct kvm_cpu_context *guest_ctxt;
>>>> +       bool fp_enabled;
>>>>         u64 exit_code;
>>>>
>>>>         vcpu = kern_hyp_va(vcpu);
>>>> @@ -117,6 +118,8 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>>>>         exit_code = __guest_enter(vcpu, host_ctxt);
>>>>         /* And we're baaack! */
>>>>
>>>> +       fp_enabled = !!(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
>>>
>>> Should this not be a single logical not?
>>> If CPTR_EL2_TFP is set then the floating point will trap in the guest,
>>> thus floating point hasn't been used by the guest?
>>>
>>> I am chasing some issues when running kvmtool on my system with this
>>> patch set applied.
>>> The above change stops NetworkManager crashing on my host.
>>>
>>> Unfortunately I am still chasing some problems with the guest (illegal
>>> instructions).
>>
>> Yeah, it looks like I screwed up in the base code, and somewhat fixed it
>> in the VHE branch... And as I'm testing the full setup, I didn't spot
>> it, sorry.
>>
>> Can you please give the kvm-arm64/vhe-wsinc branch a spin and let me
>> know if it works for you?
> 
> Thanks Marc,
> kvm-arm64/vhe-wsinc works well on my test system.

Right. So for the record (and my karma), the actual fix is:

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index a2885f5..6241785 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -29,7 +29,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
 	 */
 	val = vcpu->arch.hcr_el2;
-	if (val & HCR_RW) {
+	if (!(val & HCR_RW)) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
@@ -118,7 +118,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	exit_code = __guest_enter(vcpu, host_ctxt);
 	/* And we're baaack! */
 
-	fp_enabled = !!(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
+	fp_enabled = !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
 
 	__sysreg_save_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);

I'll push out both branches again later today, with these fixes (and a
couple more).

Many thanks for testing this Steve.

	M.
-- 
Jazz is not dead. It just smells funny...
