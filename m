From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 11/37] KVM: arm64: Improve debug register save/restore flow
Date: Sun, 3 Dec 2017 14:49:58 +0100
Message-ID: <20171203134958.b5zfdv2mbu6lr6gj@hawk.localdomain>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-12-christoffer.dall@linaro.org>
 <20171107144857.hmgwxshk6eiorm4i@kamzik.brq.redhat.com>
 <20171201175203.GD6615@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1413449D20
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 08:47:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dlZw8gZixorg for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Dec 2017 08:46:59 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30A0540795
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 08:46:59 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171201175203.GD6615@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 01, 2017 at 06:52:03PM +0100, Christoffer Dall wrote:
> On Tue, Nov 07, 2017 at 03:48:57PM +0100, Andrew Jones wrote:
> > On Thu, Oct 12, 2017 at 12:41:15PM +0200, Christoffer Dall wrote:
> > > Instead of having multiple calls from the world switch path to the debug
> > > logic, each figuring out if the dirty bit is set and if we should
> > > save/restore the debug registes, let's just provide two hooks to the
> > > debug save/restore functionality, one for switching to the guest
> > > context, and one for switching to the host context, and we get the
> > > benefit of only having to evaluate the dirty flag once on each path,
> > > plus we give the compiler some more room to inline some of this
> > > functionality.
> > > 
> > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_hyp.h | 10 ++-----
> > >  arch/arm64/kvm/hyp/debug-sr.c    | 56 +++++++++++++++++++++++++++-------------
> > >  arch/arm64/kvm/hyp/switch.c      |  6 ++---
> > >  3 files changed, 42 insertions(+), 30 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > > index 08d3bb6..a0e5a70 100644
> > > --- a/arch/arm64/include/asm/kvm_hyp.h
> > > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > > @@ -139,14 +139,8 @@ void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
> > >  void __sysreg32_save_state(struct kvm_vcpu *vcpu);
> > >  void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
> > >  
> > > -void __debug_save_state(struct kvm_vcpu *vcpu,
> > > -			struct kvm_guest_debug_arch *dbg,
> > > -			struct kvm_cpu_context *ctxt);
> > > -void __debug_restore_state(struct kvm_vcpu *vcpu,
> > > -			   struct kvm_guest_debug_arch *dbg,
> > > -			   struct kvm_cpu_context *ctxt);
> > > -void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
> > > -void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
> > > +void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
> > > +void __debug_switch_to_host(struct kvm_vcpu *vcpu);
> > >  
> > >  void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
> > >  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
> > > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > > index a2291b6..b4cd8e0 100644
> > > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > > @@ -116,16 +116,13 @@ static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
> > >  	write_sysreg_s(pmscr_el1, PMSCR_EL1);
> > >  }
> > >  
> > > -void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
> > > -				   struct kvm_guest_debug_arch *dbg,
> > > -				   struct kvm_cpu_context *ctxt)
> > > +static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
> > > +					  struct kvm_guest_debug_arch *dbg,
> > > +					  struct kvm_cpu_context *ctxt)
> > >  {
> > >  	u64 aa64dfr0;
> > >  	int brps, wrps;
> > >  
> > > -	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
> > > -		return;
> > > -
> > >  	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
> > >  	brps = (aa64dfr0 >> 12) & 0xf;
> > >  	wrps = (aa64dfr0 >> 20) & 0xf;
> > > @@ -138,16 +135,13 @@ void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
> > >  	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
> > >  }
> > >  
> > > -void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
> > > -				      struct kvm_guest_debug_arch *dbg,
> > > -				      struct kvm_cpu_context *ctxt)
> > > +static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
> > > +					     struct kvm_guest_debug_arch *dbg,
> > > +					     struct kvm_cpu_context *ctxt)
> > >  {
> > >  	u64 aa64dfr0;
> > >  	int brps, wrps;
> > >  
> > > -	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
> > > -		return;
> > > -
> > >  	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
> > >  
> > >  	brps = (aa64dfr0 >> 12) & 0xf;
> > > @@ -161,24 +155,50 @@ void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
> > >  	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
> > >  }
> > >  
> > > -void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
> > > +void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> > >  {
> > > -	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
> > > -			   kern_hyp_va(vcpu->arch.host_cpu_context));
> > > +	struct kvm_cpu_context *__host_ctxt;
> > > +	struct kvm_cpu_context *__guest_ctxt;
> > > +	struct kvm_guest_debug_arch *__host_dbg;
> > > +	struct kvm_guest_debug_arch *__guest_dbg;
> > 
> > I caught in your reply to Marc that the __ prefix here is for hyp mode
> > accessible code and data, but do we also need to use it for stack data?
> > No big deal, but it's not very pretty.
> > 
> 
> sure.
> 
> > >  
> > >  	/* Non-VHE: Disable and flush SPE data generation
> > >  	 * VHE: The vcpu can run. but it can't hide. */
> > >  	if (!has_vhe())
> > >  		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
> > > +
> > > +	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
> > > +		return;
> > > +
> > > +	__host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > > +	__guest_ctxt = &vcpu->arch.ctxt;
> > > +	__host_dbg = &vcpu->arch.host_debug_state.regs;
> > > +	__guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> > > +
> > > +	__debug_save_state(vcpu, __host_dbg, __host_ctxt);
> > > +	__debug_restore_state(vcpu, __guest_dbg, __guest_ctxt);
> > >  }
> > >  
> > > -void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
> > > +void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
> > >  {
> > > +	struct kvm_cpu_context *__host_ctxt;
> > > +	struct kvm_cpu_context *__guest_ctxt;
> > > +	struct kvm_guest_debug_arch *__host_dbg;
> > > +	struct kvm_guest_debug_arch *__guest_dbg;
> > > +
> > >  	if (!has_vhe())
> > >  		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> > >  
> > > -	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
> > > -			      kern_hyp_va(vcpu->arch.host_cpu_context));
> > > +	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
> > > +		return;
> > > +
> > > +	__host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > > +	__guest_ctxt = &vcpu->arch.ctxt;
> > > +	__host_dbg = &vcpu->arch.host_debug_state.regs;
> > > +	__guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> > > +
> > > +	__debug_save_state(vcpu, __guest_dbg, __guest_ctxt);
> > > +	__debug_restore_state(vcpu, __host_dbg, __host_ctxt);
> > >  
> > >  	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
> > >  }
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > index ef05c59..e270cba 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -271,7 +271,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > >  	guest_ctxt = &vcpu->arch.ctxt;
> > >  
> > >  	__sysreg_save_host_state(host_ctxt);
> > > -	__debug_cond_save_host_state(vcpu);
> > >  
> > >  	__activate_traps(vcpu);
> > >  	__activate_vm(vcpu);
> > > @@ -285,7 +284,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > >  	 */
> > >  	__sysreg32_restore_state(vcpu);
> > >  	__sysreg_restore_guest_state(guest_ctxt);
> > > -	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
> > > +	__debug_switch_to_guest(vcpu);
> > >  
> > >  	/* Jump in the fire! */
> > >  again:
> > > @@ -353,12 +352,11 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> > >  
> > >  	__sysreg_restore_host_state(host_ctxt);
> > >  
> > > -	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
> > >  	/*
> > >  	 * This must come after restoring the host sysregs, since a non-VHE
> > >  	 * system may enable SPE here and make use of the TTBRs.
> > >  	 */
> > > -	__debug_cond_restore_host_state(vcpu);
> > > +	__debug_switch_to_host(vcpu);
> > >  
> > >  	return exit_code;
> > >  }
> > > -- 
> > > 2.9.0
> > >
> > 
> > This looks like a nice cleanup, but can you please add a note to the
> > commit message about why we don't need to use the
> > 
> >  save-host-state
> >  activate-traps-and-vm
> >  restore-guest-state
> > 
> > and the reverse, patterns for the debug registers? 
> 
> I think the current commit message motivates the change fine.
>

The motivation is obvious, the justification for an additional change
is not. How does it justify changing the sequence

 save-debug-host-state
 activate-debug-traps 		/* and other stuff in between */
 restore-debug-guest-state

to
 
 activate-debug-traps		/* and other stuff in between */
 save-debug-host-state
 restore-debug-guest-state

Thanks,
drew
