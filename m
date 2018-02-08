From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 04/41] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Thu, 8 Feb 2018 14:24:16 +0100
Message-ID: <20180208132416.GP29286@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-5-christoffer.dall@linaro.org>
 <be470bdb-258e-6b4d-b409-e230d2d90888@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <be470bdb-258e-6b4d-b409-e230d2d90888@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,

On Mon, Feb 05, 2018 at 06:04:25PM +0000, Julien Grall wrote:
> On 12/01/18 12:07, Christoffer Dall wrote:
> >VHE actually doesn't rely on clearing the VTTBR when returning to the
> >host kernel, and that is the current key mechanism of hyp_panic to
> >figure out how to attempt to return to a state good enough to print a
> >panic statement.
> >
> >Therefore, we split the hyp_panic function into two functions, a VHE and
> >a non-VHE, keeping the non-VHE version intact, but changing the VHE
> >behavior.
> >
> >The vttbr_el2 check on VHE doesn't really make that much sense, because
> >the only situation where we can get here on VHE is when the hypervisor
> >assembly code actually called into hyp_panic, which only happens when
> >VBAR_EL2 has been set to the KVM exception vectors.  On VHE, we can
> >always safely disable the traps and restore the host registers at this
> >point, so we simply do that unconditionally and call into the panic
> >function directly.
> >
> >Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/kvm/hyp/switch.c | 42 +++++++++++++++++++++++-------------------
> >  1 file changed, 23 insertions(+), 19 deletions(-)
> >
> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >index 6fcb37e220b5..71700ecee308 100644
> >--- a/arch/arm64/kvm/hyp/switch.c
> >+++ b/arch/arm64/kvm/hyp/switch.c
> >@@ -419,10 +419,20 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
> >  static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> >-					     struct kvm_vcpu *vcpu)
> >+					     struct kvm_cpu_context *__host_ctxt)
> >  {
> >+	struct kvm_vcpu *vcpu;
> >  	unsigned long str_va;
> >+	vcpu = __host_ctxt->__hyp_running_vcpu;
> >+
> >+	if (read_sysreg(vttbr_el2)) {
> >+		__timer_disable_traps(vcpu);
> >+		__deactivate_traps(vcpu);
> >+		__deactivate_vm(vcpu);
> >+		__sysreg_restore_host_state(__host_ctxt);
> >+	}
> >+
> >  	/*
> >  	 * Force the panic string to be loaded from the literal pool,
> >  	 * making sure it is a kernel address and not a PC-relative
> >@@ -436,37 +446,31 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> >  		       read_sysreg(hpfar_el2), par, vcpu);
> >  }
> >-static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
> >-					    struct kvm_vcpu *vcpu)
> >+static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
> >+				 struct kvm_cpu_context *host_ctxt)
> >  {
> >+	struct kvm_vcpu *vcpu;
> >+	vcpu = host_ctxt->__hyp_running_vcpu;
> >+
> >+	__deactivate_traps(vcpu);
> >+	__sysreg_restore_host_state(host_ctxt);
> 
> I was about to ask why you keep this function around as it does nothing in
> VHE case. But I see that this will actually restore some values in a later
> patch.
> 
> >+
> >  	panic(__hyp_panic_string,
> >  	      spsr,  elr,
> >  	      read_sysreg_el2(esr),   read_sysreg_el2(far),
> >  	      read_sysreg(hpfar_el2), par, vcpu);
> >  }
> >-static hyp_alternate_select(__hyp_call_panic,
> >-			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
> >-			    ARM64_HAS_VIRT_HOST_EXTN);
> 
> Out of interest, any specific rather to remove hyp_alternate_select and
> "open-code" it?
> 

Not sure I understand your question.

Are you asking why I replace the hyp alternatives with the has_vhe()?
If so, has_vhe() uses a static key and should therefore have the same
performance characteristics, but I find the has_vhe() version below much
more readable.

> >-
> >  void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
> >  {
> >-	struct kvm_vcpu *vcpu = NULL;
> >-
> >  	u64 spsr = read_sysreg_el2(spsr);
> >  	u64 elr = read_sysreg_el2(elr);
> >  	u64 par = read_sysreg(par_el1);
> >-	if (read_sysreg(vttbr_el2)) {
> >-		vcpu = host_ctxt->__hyp_running_vcpu;
> >-		__timer_disable_traps(vcpu);
> >-		__deactivate_traps(vcpu);
> >-		__deactivate_vm(vcpu);
> >-		__sysreg_restore_host_state(host_ctxt);
> >-	}
> >-
> >-	/* Call panic for real */
> >-	__hyp_call_panic()(spsr, elr, par, vcpu);
> >+	if (!has_vhe())
> >+		__hyp_call_panic_nvhe(spsr, elr, par, host_ctxt);
> >+	else
> >+		__hyp_call_panic_vhe(spsr, elr, par, host_ctxt);
> >  	unreachable();
> >  }
> >
> 

Thanks,
-Christoffer
