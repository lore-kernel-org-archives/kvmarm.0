From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Tue, 6 Sep 2016 18:59:14 +0200
Message-ID: <20160906165914.GI23592@cbox>
References: <1473093097-30932-1-git-send-email-punit.agrawal@arm.com>
 <1473093097-30932-7-git-send-email-punit.agrawal@arm.com>
 <20160906102113.GE30513@cbox>
 <87inu9hw38.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87inu9hw38.fsf@e105922-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 06, 2016 at 04:44:11PM +0100, Punit Agrawal wrote:
> Christoffer Dall <christoffer.dall@linaro.org> writes:
> 
> > On Mon, Sep 05, 2016 at 05:31:36PM +0100, Punit Agrawal wrote:
> >> The ARMv8 architecture allows trapping of TLB maintenane instructions
> >> from EL0/EL1 to higher exception levels. On encountering a trappable TLB
> >> instruction in a guest, an exception is taken to EL2.
> >> 
> >> Add functionality to handle emulating the TLB instructions.
> >> 
> >> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_asm.h |  1 +
> >>  arch/arm64/kvm/hyp/tlb.c         | 69 ++++++++++++++++++++++++++++++++++
> >>  arch/arm64/kvm/sys_regs.c        | 81 ++++++++++++++++++++++++++++++++++++++++
> >>  arch/arm64/kvm/trace.h           | 16 ++++++++
> >>  4 files changed, 167 insertions(+)
> >> 
> >> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> >> index 7561f63..1ac1cc3 100644
> >> --- a/arch/arm64/include/asm/kvm_asm.h
> >> +++ b/arch/arm64/include/asm/kvm_asm.h
> >> @@ -49,6 +49,7 @@ extern char __kvm_hyp_vector[];
> >>  extern void __kvm_flush_vm_context(void);
> >>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
> >>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
> >> +extern void __kvm_emulate_tlb_invalidate(struct kvm *kvm, u32 sysreg, u64 regval);
> >>  
> >>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >>  
> >> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> >> index 4cda100..1210f58 100644
> >> --- a/arch/arm64/kvm/hyp/tlb.c
> >> +++ b/arch/arm64/kvm/hyp/tlb.c
> >> @@ -78,3 +78,72 @@ static void __hyp_text __tlb_flush_vm_context(void)
> >>  }
> >>  
> >>  __alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
> >> +
> >> +/* Intentionally empty functions */
> >> +static void __hyp_text __switch_to_hyp_role_nvhe(void) { }
> >> +static void __hyp_text __switch_to_host_role_nvhe(void) { }
> >> +
> >> +static void __hyp_text __switch_to_hyp_role_vhe(void)
> >> +{
> >> +	u64 hcr = read_sysreg(hcr_el2);
> >> +
> >> +	hcr &= ~HCR_TGE;
> >> +	write_sysreg(hcr, hcr_el2);
> >
> > why do we need to clear TGE for the TLB maintenance instructions to
> > work?
> >
> > Perhaps this is worth explaining in a comment.
> 
> I've added the following comment before clearing TGE bit.
> 
> "When VHE is enabled and HCR_EL2.TGE=1, EL1&0 TLB operations
> apply to EL2&0 translation regime. As we prepare to emulate
> guest TLB operation clear HCR_TGE to target TLB operations
> to EL1&0 (guest)."
> 

Ah, right, obvious when I read this comment.

Thanks,
-Christoffer
