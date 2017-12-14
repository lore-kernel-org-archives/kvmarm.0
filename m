From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 15/36] KVM: arm64: Move userspace system registers
 into separate function
Date: Thu, 14 Dec 2017 13:53:02 +0100
Message-ID: <20171214125302.GU910@cbox>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-16-christoffer.dall@linaro.org>
 <a965d4ae-2bbf-5f57-61c4-aee38ae74991@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a965d4ae-2bbf-5f57-61c4-aee38ae74991@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 11, 2017 at 10:14:23AM +0000, Marc Zyngier wrote:
> On 07/12/17 17:06, Christoffer Dall wrote:
> > There's a semantic difference between the EL1 registers that control
> > operation of a kernel running in EL1 and EL1 registers that only control
> > userspace execution in EL0.  Since we can defer saving/restoring the
> > latter, move them into their own function.
> > 
> > We also take this chance to rename the function saving/restoring the
> > remaining system register to make it clear this function deals with
> > the EL1 system registers.
> > 
> > No functional change.
> > 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > 
> > Notes:
> >     Changes since v1:
> >      - Added comment about sp_el0 to common save sysreg save/restore functions
> > 
> >  arch/arm64/kvm/hyp/sysreg-sr.c | 44 +++++++++++++++++++++++++++++++-----------
> >  1 file changed, 33 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index 68a7d164e5e1..bbfb4d01af88 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -33,15 +33,24 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
> >   */
> >  
> >  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> > +{
> > +	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
> > +
> > +	/*
> > +	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
> > +	 * therefore be saved/restored on every entry/exit to/from the guest.
> > +	 */
> > +	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
> > +}
> > +
> > +static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
> >  {
> >  	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
> 
> What is the rational for keeping ACTLR_EL1 as part of the user state?
> 

The rationale was that I missed the note you pointed me to below, and
therefore I figured that ACTLR_EL1 couldn't affect the host kernel,
because it runs in EL2, but could affect host userspace, which is
incorrect.  So I was basically just being overlay cautious.

> >  	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
> >  	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
> > -	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
> > -	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
> >  }
> >  
> > -static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
> > +static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> >  {
> >  	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
> >  	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
> > @@ -70,31 +79,42 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
> >  }
> >  
> >  static hyp_alternate_select(__sysreg_call_save_host_state,
> > -			    __sysreg_save_state, __sysreg_do_nothing,
> > +			    __sysreg_save_el1_state, __sysreg_do_nothing,
> >  			    ARM64_HAS_VIRT_HOST_EXTN);
> >  
> >  void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_call_save_host_state()(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> > +	__sysreg_save_user_state(ctxt);
> >  }
> >  
> >  void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
> >  {
> > -	__sysreg_save_state(ctxt);
> > +	__sysreg_save_el1_state(ctxt);
> >  	__sysreg_save_common_state(ctxt);
> > +	__sysreg_save_user_state(ctxt);
> >  }
> >  
> >  static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
> >  {
> > -	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
> > -	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
> > -	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
> >  	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
> > +
> > +	/*
> > +	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
> > +	 * therefore be saved/restored on every entry/exit to/from the guest.
> > +	 */
> >  	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
> >  }
> >  
> > -static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
> > +static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
> > +{
> > +	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
> 
> Same here.
> 
> > +	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  	tpidr_el0);
> > +	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], 	tpidrro_el0);
> > +}
> > +
> > +static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> >  {
> >  	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
> >  	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
> > @@ -123,19 +143,21 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
> >  }
> >  
> >  static hyp_alternate_select(__sysreg_call_restore_host_state,
> > -			    __sysreg_restore_state, __sysreg_do_nothing,
> > +			    __sysreg_restore_el1_state, __sysreg_do_nothing,
> >  			    ARM64_HAS_VIRT_HOST_EXTN);
> >  
> >  void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
> >  {
> >  	__sysreg_call_restore_host_state()(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> > +	__sysreg_restore_user_state(ctxt);
> >  }
> >  
> >  void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
> >  {
> > -	__sysreg_restore_state(ctxt);
> > +	__sysreg_restore_el1_state(ctxt);
> >  	__sysreg_restore_common_state(ctxt);
> > +	__sysreg_restore_user_state(ctxt);
> >  }
> >  
> >  static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
> > 
> 
> I think we should move ACTLR_EL1 to the EL1 state, allowing it to be
> lazily switched. See the note in D10.2.1 that recommends a VHE enabled
> system to have ACTLR_EL1 as a guest-only register.

Thanks for this pointer.  I will adjust the code as you suggest.

-Christoffer
