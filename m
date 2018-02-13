From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 17/41] KVM: arm64: Remove noop calls to timer
 save/restore from VHE switch
Date: Tue, 13 Feb 2018 09:53:10 +0100
Message-ID: <20180213085310.GE23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-18-christoffer.dall@linaro.org>
 <20074994-caac-2be0-6eaa-83115c616756@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20074994-caac-2be0-6eaa-83115c616756@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 05:53:43PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> >The VHE switch function calls __timer_enable_traps and
> >__timer_disable_traps which don't do anything on VHE systems.
> >Therefore, simply remove these calls from the VHE switch function and
> >make the functions non-conditional as they are now only called from the
> >non-VHE switch path.
> >
> >Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/kvm/hyp/switch.c |  2 --
> >  virt/kvm/arm/hyp/timer-sr.c | 44 ++++++++++++++++++++++----------------------
> >  2 files changed, 22 insertions(+), 24 deletions(-)
> >
> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >index 9aadef6966bf..6175fcb33ed2 100644
> >--- a/arch/arm64/kvm/hyp/switch.c
> >+++ b/arch/arm64/kvm/hyp/switch.c
> >@@ -354,7 +354,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >  	__activate_vm(vcpu->kvm);
> >  	__vgic_restore_state(vcpu);
> >-	__timer_enable_traps(vcpu);
> >  	/*
> >  	 * We must restore the 32-bit state before the sysregs, thanks
> >@@ -373,7 +372,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >  	__sysreg_save_guest_state(guest_ctxt);
> >  	__sysreg32_save_state(vcpu);
> >-	__timer_disable_traps(vcpu);
> >  	__vgic_save_state(vcpu);
> >  	__deactivate_traps(vcpu);
> >diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> >index f24404b3c8df..77754a62eb0c 100644
> >--- a/virt/kvm/arm/hyp/timer-sr.c
> >+++ b/virt/kvm/arm/hyp/timer-sr.c
> >@@ -27,34 +27,34 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
> >  	write_sysreg(cntvoff, cntvoff_el2);
> >  }
> >+/*
> >+ * Should only be called on non-VHE systems.
> >+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
> >+ */
> >  void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
> 
> Would it be worth to suffix the function with nvhe? So it would be clear
> that it should not be called for VHE system?
> 
> >  {
> >-	/*
> >-	 * We don't need to do this for VHE since the host kernel runs in EL2
> >-	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
> >-	 */
> >-	if (!has_vhe()) {
> >-		u64 val;
> >+	u64 val;
> >-		/* Allow physical timer/counter access for the host */
> >-		val = read_sysreg(cnthctl_el2);
> >-		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> >-		write_sysreg(val, cnthctl_el2);
> >-	}
> >+	/* Allow physical timer/counter access for the host */
> >+	val = read_sysreg(cnthctl_el2);
> >+	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> >+	write_sysreg(val, cnthctl_el2);
> >  }
> >+/*
> >+ * Should only be called on non-VHE systems.
> >+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
> >+ */
> >  void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
> 
> Same here.
> 
I'll have a look.

Thanks,
-Christoffer
