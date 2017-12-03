From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 20/37] KVM: arm64: Unify non-VHE host/guest sysreg save
 and restore functions
Date: Sun, 3 Dec 2017 20:41:55 +0100
Message-ID: <20171203194155.GG4218@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-21-christoffer.dall@linaro.org>
 <20171108103906.d7jgzzlt4dxpae6k@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108103906.d7jgzzlt4dxpae6k@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 08, 2017 at 11:39:06AM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:24PM +0200, Christoffer Dall wrote:
> > There is no need to have multiple identical functions with different
> > names for saving host and guest state.  When saving and restoring state
> > for the host and guest, the state is the same for both contexts, and
> > that's why we have the kvm_cpu_context structure.  Delete one
> > version and rename the other into simply save/restore.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/include/asm/kvm_hyp.h |  6 ++----
> >  arch/arm64/kvm/hyp/switch.c      | 10 +++++-----
> >  arch/arm64/kvm/hyp/sysreg-sr.c   | 18 ++----------------
> >  3 files changed, 9 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 998152d..3f54c55 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -132,10 +132,8 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
> >  void __timer_enable_traps(struct kvm_vcpu *vcpu);
> >  void __timer_disable_traps(struct kvm_vcpu *vcpu);
> >  
> > -void __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt);
> > -void __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt);
> > -void __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt);
> > -void __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt);
> > +void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
> > +void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
> >  void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
> >  void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
> >  void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 7c4d430..6356bec 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -383,7 +383,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  	host_ctxt->__hyp_running_vcpu = vcpu;
> >  	guest_ctxt = &vcpu->arch.ctxt;
> >  
> > -	__sysreg_save_host_state_nvhe(host_ctxt);
> > +	__sysreg_save_state_nvhe(host_ctxt);
> >  
> >  	__activate_traps(vcpu);
> >  	__activate_vm(vcpu);
> > @@ -396,7 +396,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
> >  	 */
> >  	__sysreg32_restore_state(vcpu);
> > -	__sysreg_restore_guest_state_nvhe(guest_ctxt);
> > +	__sysreg_restore_state_nvhe(guest_ctxt);
> >  	__debug_switch_to_guest(vcpu);
> >  
> >  	/* Jump in the fire! */
> > @@ -407,7 +407,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  	if (fixup_guest_exit(vcpu, &exit_code))
> >  		goto again;
> >  
> > -	__sysreg_save_guest_state_nvhe(guest_ctxt);
> > +	__sysreg_save_state_nvhe(guest_ctxt);
> >  	__sysreg32_save_state(vcpu);
> >  	__timer_disable_traps(vcpu);
> >  	__vgic_save_state(vcpu);
> > @@ -415,7 +415,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  	__deactivate_traps(vcpu);
> >  	__deactivate_vm(vcpu);
> >  
> > -	__sysreg_restore_host_state_nvhe(host_ctxt);
> > +	__sysreg_restore_state_nvhe(host_ctxt);
> >  
> >  	/*
> >  	 * This must come after restoring the host sysregs, since a non-VHE
> > @@ -440,7 +440,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> >  		__timer_disable_traps(vcpu);
> >  		__deactivate_traps(vcpu);
> >  		__deactivate_vm(vcpu);
> > -		__sysreg_restore_host_state_nvhe(__host_ctxt);
> > +		__sysreg_restore_state_nvhe(__host_ctxt);
> >  	}
> >  
> >  	/*
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index d8c42de..f5c1b44 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -70,14 +70,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> >  	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
> >  }
> >  
> > -void __hyp_text __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt)
> > -{
> > -	__sysreg_save_el1_state(ctxt);
> > -	__sysreg_save_common_state(ctxt);
> > -	__sysreg_save_user_state(ctxt);
> > -}
> > -
> > -void __hyp_text __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt)
> > +void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_save_el1_state(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> > @@ -138,14 +131,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> >  	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
> >  }
> >  
> > -void __hyp_text __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt)
> > -{
> > -	__sysreg_restore_el1_state(ctxt);
> > -	__sysreg_restore_common_state(ctxt);
> > -	__sysreg_restore_user_state(ctxt);
> > -}
> > -
> > -void __hyp_text __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt)
> > +void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_restore_el1_state(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> > -- 
> > 2.9.0
> >
> 
> I think this patch could be squashed into the last one without
> complicating the review. Anyway

This series was hard to debug, so I made changes as small as possible to
maintain my sanity when bisecting.

> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
-Christoffer
