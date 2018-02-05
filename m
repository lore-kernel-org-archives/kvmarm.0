From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 33/41] KVM: arm64: Configure FPSIMD traps on vcpu
 load/put
Date: Mon, 5 Feb 2018 11:06:21 +0100
Message-ID: <20180205100621.GU21802@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-34-christoffer.dall@linaro.org>
 <a182d82e-73e0-8bfa-1d10-166b73ac1fdf@semihalf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a182d82e-73e0-8bfa-1d10-166b73ac1fdf@semihalf.com>
Sender: kvm-owner@vger.kernel.org
To: Tomasz Nowicki <tn@semihalf.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tomasz,

On Wed, Jan 31, 2018 at 01:17:36PM +0100, Tomasz Nowicki wrote:
> On 12.01.2018 13:07, Christoffer Dall wrote:
> >There is no need to enable/disable traps to FP registers on every switch
> >to/from the VM, because the host kernel does not use this resource
> >without calling vcpu_put.  We can therefore move things around enough
> >that we still always write FPEXC32_EL2 before programming CPTR_EL2 but
> >only program these during vcpu load/put.
> >
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/include/asm/kvm_hyp.h |  6 +++++
> >  arch/arm64/kvm/hyp/switch.c      | 51 +++++++++++++++++++++++++++++-----------
> >  arch/arm64/kvm/hyp/sysreg-sr.c   | 12 ++++++++--
> >  3 files changed, 53 insertions(+), 16 deletions(-)
> >
> >diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> >index 3f54c55f77a1..ffd62e31f134 100644
> >--- a/arch/arm64/include/asm/kvm_hyp.h
> >+++ b/arch/arm64/include/asm/kvm_hyp.h
> >@@ -148,6 +148,12 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
> >  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
> >  bool __fpsimd_enabled(void);
> >+void __activate_traps_nvhe_load(struct kvm_vcpu *vcpu);
> >+void __deactivate_traps_nvhe_put(void);
> >+
> >+void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> >+void deactivate_traps_vhe_put(void);
> >+
> >  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> >  void __noreturn __hyp_do_panic(unsigned long, ...);
> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >index c01bcfc3fb52..d14ab9650f81 100644
> >--- a/arch/arm64/kvm/hyp/switch.c
> >+++ b/arch/arm64/kvm/hyp/switch.c
> >@@ -24,22 +24,25 @@
> >  #include <asm/fpsimd.h>
> >  #include <asm/debug-monitors.h>
> >-static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> >+static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
> >  {
> >  	/*
> >-	 * We are about to set CPTR_EL2.TFP to trap all floating point
> >-	 * register accesses to EL2, however, the ARM ARM clearly states that
> >-	 * traps are only taken to EL2 if the operation would not otherwise
> >-	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> >-	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> >-	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> >-	 * it will cause an exception.
> >+	 * We are about to trap all floating point register accesses to EL2,
> >+	 * however, traps are only taken to EL2 if the operation would not
> >+	 * otherwise trap to EL1.  Therefore, always make sure that for 32-bit
> >+	 * guests, we set FPEXC.EN to prevent traps to EL1, when setting the
> >+	 * TFP bit.  If FP/ASIMD is not implemented, FPEXC is UNDEFINED and
> >+	 * any access to it will cause an exception.
> >  	 */
> >  	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
> >  	    !vcpu->arch.guest_vfp_loaded) {
> >  		write_sysreg(1 << 30, fpexc32_el2);
> >  		isb();
> >  	}
> >+}
> >+
> >+static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> >+{
> >  	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
> >  	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
> >@@ -61,10 +64,12 @@ static void __hyp_text __deactivate_traps_common(void)
> >  	write_sysreg(0, pmuserenr_el0);
> >  }
> >-static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> >+void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
> >  {
> >  	u64 val;
> >+	__activate_traps_fpsimd32(vcpu);
> >+
> >  	val = read_sysreg(cpacr_el1);
> >  	val |= CPACR_EL1_TTA;
> >  	val &= ~CPACR_EL1_ZEN;
> >@@ -73,14 +78,26 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  	else
> >  		val &= ~CPACR_EL1_FPEN;
> >  	write_sysreg(val, cpacr_el1);
> 
> Giving that you move this code to kvm_vcpu_load_sysregs() I am wondering if
> we have to deactivate FPEN trap here. IIUC, we call
> kvm_vcpu_load_sysregs()->activate_traps_vhe_load() and then
> kvm_vcpu_put_sysregs() by design. So vcpu->arch.guest_vfp_loaded should be
> always 0 here since it is zeroed in kvm_vcpu_put_sysregs(). The same for
> nvhe case below.
> 

You're absolutely right, we can enable the trapping unconditionally on
this path.

Thanks,
-Christoffer
