From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 21/37] KVM: arm64: Don't save the host ELR_EL2 and
 SPSR_EL2 on VHE systems
Date: Sun, 3 Dec 2017 20:45:50 +0100
Message-ID: <20171203194550.GH4218@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-22-christoffer.dall@linaro.org>
 <20171108170323.q5ikpwgruos3giay@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108170323.q5ikpwgruos3giay@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 08, 2017 at 06:03:23PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:25PM +0200, Christoffer Dall wrote:
> > On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we
> > can return to the host in EL1 in the same state and location where we
> > issued a hypercall to EL2, but these registers don't contain anything
> > important on VHE, because all of the host runs in EL2.  Therefore,
> > exclude them when saving/restoring the host state.
> 
> This commit message implies we start excluding now, but this patch
> actually has no functional change. It just prepares things for
> patch 27/37 "KVM: arm64: Defer saving/restoring system registers to
> vcpu load/put on VHE". Can you please clarify it?
> 

Sure:

  On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we
  can return to the host in EL1 in the same state and location where we
  issued a hypercall to EL2, but these registers don't contain anything
  important on VHE, because all of the host runs in EL2.  Therefore,
  factor out these registers into separate save/restore functions, making
  it easy to exclude them from the VHE world-switch path later on.


Thanks,
-Christoffer

> 
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/sysreg-sr.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index f5c1b44..354ca02 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -66,6 +66,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> >  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
> >  	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
> >  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
> > +}
> > +
> > +static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
> > +{
> >  	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
> >  	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
> >  }
> > @@ -75,6 +79,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
> >  	__sysreg_save_el1_state(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> >  	__sysreg_save_user_state(ctxt);
> > +	__sysreg_save_el2_return_state(ctxt);
> >  }
> >  
> >  void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
> > @@ -88,6 +93,7 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
> >  	__sysreg_save_el1_state(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> >  	__sysreg_save_user_state(ctxt);
> > +	__sysreg_save_el2_return_state(ctxt);
> >  }
> >  
> >  static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
> > @@ -127,6 +133,11 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> >  	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
> >  	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
> >  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
> > +}
> > +
> > +static void __hyp_text
> > +__sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
> > +{
> >  	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
> >  	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
> >  }
> > @@ -136,6 +147,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
> >  	__sysreg_restore_el1_state(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> >  	__sysreg_restore_user_state(ctxt);
> > +	__sysreg_restore_el2_return_state(ctxt);
> >  }
> >  
> >  void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
> > @@ -149,6 +161,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
> >  	__sysreg_restore_el1_state(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> >  	__sysreg_restore_user_state(ctxt);
> > +	__sysreg_restore_el2_return_state(ctxt);
> >  }
> >  
> >  static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
> > -- 
> > 2.9.0
> > 
