From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 09/37] KVM: arm64: Move debug dirty flag calculation out
 of world switch
Date: Sat, 25 Nov 2017 11:09:28 +0300
Message-ID: <20171125080928.r7pdskl7tfv4epu4@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-10-christoffer.dall@linaro.org>
 <20171107140919.p6act55ubmzlv66b@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107140919.p6act55ubmzlv66b@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 03:09:19PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:13PM +0200, Christoffer Dall wrote:
> > There is no need to figure out inside the world-switch if we should
> > save/restore the debug registers or not, we can might as well do that in
> > the higher level debug setup code, making it easier to optimize down the
> > line.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/debug.c        | 9 +++++++++
> >  arch/arm64/kvm/hyp/debug-sr.c | 6 ------
> >  2 files changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index dbadfaf..62550de19 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -193,6 +193,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  	if (trap_debug)
> >  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> >  
> > +	/*
> > +	 * If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
> > +	 * a full save/restore cycle.
> 
> The commit message implies testing KVM_ARM64_DEBUG_DIRTY, but it only
> tests KDE and MDE.
> 
> > +	 */
> > +	if ((vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_KDE) ||
> > +	    (vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_MDE))
> 
> nit: could also write as
> 
>  if (vcpu_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 
Another nit: two empty lines at the end of this chunk.

> > +		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
> > +
> 
> It looks like there's only one flag for debug_flags - this dirty flag,
> which I guess is also used to trigger trapping. So maybe this could be a
> second flag of a "lazy state" field, as I suggested earlier?
> 
> > +
> >  	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> >  	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
> >  }
> > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > index f5154ed..0fc0758 100644
> > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > @@ -172,12 +172,6 @@ void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
> >  
> >  void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
> >  {
> > -	/* If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
> > -	 * a full save/restore cycle. */
> > -	if ((vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE) ||
> > -	    (vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_MDE))
> > -		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
> > -
> >  	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
> >  			   kern_hyp_va(vcpu->arch.host_cpu_context));
> >  	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
> > -- 
> > 2.9.0
> >
> 
> Also, while grepping, I noticed __debug_cond_restore_host_state() unsets
> KVM_ARM64_DEBUG_DIRTY on that condition that it's set. A micro
> optimization could be to do it unconditionally, removing the branch.
> 
> Thanks,
> drew
