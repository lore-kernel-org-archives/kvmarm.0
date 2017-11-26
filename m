From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 04/37] KVM: arm/arm64: Get rid of vcpu->arch.irq_lines
Date: Sun, 26 Nov 2017 17:04:23 +0100
Message-ID: <20171126160423.GJ28855@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-5-christoffer.dall@linaro.org>
 <9315cfbb-fe23-6443-01be-ac376c457a14@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9315cfbb-fe23-6443-01be-ac376c457a14@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 14, 2017 at 12:17:44PM +0000, Julien Thierry wrote:
> Hi Christoffer,
> 
> On 12/10/17 11:41, Christoffer Dall wrote:
> >We currently have a separate read-modify-write of the HCR_EL2 on entry
> >to the guest for the sole purpose of setting the VF and VI bits, if set.
> >Since this is most rarely the case (only when using userspace IRQ chip
> >and interrupts are in flight), let's get rid of this operation and
> >instead modify the bits in the vcpu->arch.hcr[_el2] directly when
> >needed.
> >
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm/include/asm/kvm_emulate.h   |  9 ++-------
> >  arch/arm/include/asm/kvm_host.h      |  3 ---
> >  arch/arm/kvm/emulate.c               |  2 +-
> >  arch/arm/kvm/hyp/switch.c            |  2 +-
> >  arch/arm64/include/asm/kvm_emulate.h |  9 ++-------
> >  arch/arm64/include/asm/kvm_host.h    |  3 ---
> >  arch/arm64/kvm/hyp/switch.c          |  6 ------
> >  arch/arm64/kvm/inject_fault.c        |  2 +-
> >  virt/kvm/arm/arm.c                   | 11 ++++++-----
> >  virt/kvm/arm/mmu.c                   |  6 +++---
> >  10 files changed, 16 insertions(+), 37 deletions(-)
> >
> >diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> >index 98089ff..34663a8 100644
> >--- a/arch/arm/include/asm/kvm_emulate.h
> >+++ b/arch/arm/include/asm/kvm_emulate.h
> >@@ -62,14 +62,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.hcr = HCR_GUEST_MASK;
> >  }
> >-static inline unsigned long vcpu_get_hcr(const struct kvm_vcpu *vcpu)
> >+static inline unsigned long *vcpu_hcr(const struct kvm_vcpu *vcpu)
> >  {
> >-	return vcpu->arch.hcr;
> >-}
> >-
> >-static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
> >-{
> >-	vcpu->arch.hcr = hcr;
> >+	return (unsigned long *)&vcpu->arch.hcr;
> >  }
> >  static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
> >diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >index 4a879f6..1100170 100644
> >--- a/arch/arm/include/asm/kvm_host.h
> >+++ b/arch/arm/include/asm/kvm_host.h
> >@@ -153,9 +153,6 @@ struct kvm_vcpu_arch {
> >  	/* HYP trapping configuration */
> >  	u32 hcr;
> >-	/* Interrupt related fields */
> >-	u32 irq_lines;		/* IRQ and FIQ levels */
> >-
> >  	/* Exception Information */
> >  	struct kvm_vcpu_fault_info fault;
> >diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
> >index 0064b86..4286a89 100644
> >--- a/arch/arm/kvm/emulate.c
> >+++ b/arch/arm/kvm/emulate.c
> >@@ -313,5 +313,5 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
> >   */
> >  void kvm_inject_vabt(struct kvm_vcpu *vcpu)
> >  {
> >-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VA);
> >+	*vcpu_hcr(vcpu) |= HCR_VA;
> >  }
> >diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
> >index 330c9ce..c3b9799 100644
> >--- a/arch/arm/kvm/hyp/switch.c
> >+++ b/arch/arm/kvm/hyp/switch.c
> >@@ -43,7 +43,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
> >  		isb();
> >  	}
> >-	write_sysreg(vcpu->arch.hcr | vcpu->arch.irq_lines, HCR);
> >+	write_sysreg(vcpu->arch.hcr, HCR);
> >  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
> >  	write_sysreg(HSTR_T(15), HSTR);
> >  	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
> >diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> >index e5df3fc..1fbfe96 100644
> >--- a/arch/arm64/include/asm/kvm_emulate.h
> >+++ b/arch/arm64/include/asm/kvm_emulate.h
> >@@ -51,14 +51,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.hcr_el2 &= ~HCR_RW;
> >  }
> >-static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
> >+static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> >  {
> >-	return vcpu->arch.hcr_el2;
> >-}
> >-
> >-static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
> >-{
> >-	vcpu->arch.hcr_el2 = hcr;
> >+	return (unsigned long *)&vcpu->arch.hcr_el2;
> >  }
> >  static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
> >diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >index 806ccef..27305e7 100644
> >--- a/arch/arm64/include/asm/kvm_host.h
> >+++ b/arch/arm64/include/asm/kvm_host.h
> >@@ -266,9 +266,6 @@ struct kvm_vcpu_arch {
> >  	/* IO related fields */
> >  	struct kvm_decode mmio_decode;
> >-	/* Interrupt related fields */
> >-	u64 irq_lines;		/* IRQ and FIQ levels */
> >-
> >  	/* Cache some mmu pages needed inside spinlock regions */
> >  	struct kvm_mmu_memory_cache mmu_page_cache;
> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >index bcf1a79..7703d63 100644
> >--- a/arch/arm64/kvm/hyp/switch.c
> >+++ b/arch/arm64/kvm/hyp/switch.c
> >@@ -168,12 +168,6 @@ static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
> >  static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
> >  {
> >-	u64 val;
> >-
> >-	val = read_sysreg(hcr_el2);
> >-	val |= vcpu->arch.irq_lines;
> >-	write_sysreg(val, hcr_el2);
> >-
> >  	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> >  		__vgic_v3_restore_state(vcpu);
> >  	else
> >diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> >index da6a8cf..45c7026 100644
> >--- a/arch/arm64/kvm/inject_fault.c
> >+++ b/arch/arm64/kvm/inject_fault.c
> >@@ -241,5 +241,5 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_inject_vabt(struct kvm_vcpu *vcpu)
> >  {
> >-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
> >+	*vcpu_hcr(vcpu) |= HCR_VSE;
> >  }
> >diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> >index 7f9296a..6e9513e 100644
> >--- a/virt/kvm/arm/arm.c
> >+++ b/virt/kvm/arm/arm.c
> >@@ -411,7 +411,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >   */
> >  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
> >  {
> >-	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
> >+	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
> 
> Hmmm, I might be nitpicking here, but in my mind bool should be used
> only to contain true (1) or false (0) values.
> Here the non-false values are never 1.
> 
> Not sure if the definition of _Bool guaranties to be able to contain
> other values than 1 and 0, although I agree it is unlikely it will
> be less than a byte which works in your case.

As you found out, this is fine as long as we use _Bool.  If we had used
an integer type, it would be bad practice indeed.

> 
> Other than that:
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> 
Thanks for the review!
-Christoffer
