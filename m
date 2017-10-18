From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 3/5] KVM: arm/arm64: factor out common wfe/wfi emulation
 code
Date: Wed, 18 Oct 2017 14:06:47 +0200
Message-ID: <20171018120647.weaawod545tkhjkq@kamzik.brq.redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-4-drjones@redhat.com>
 <20171014191308.GB1929@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D33049D21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:05:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CITDl0xFqFbR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 08:05:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1334406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:05:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171014191308.GB1929@lvm>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 14, 2017 at 09:13:08PM +0200, Christoffer Dall wrote:
> On Fri, Sep 29, 2017 at 01:30:39PM +0200, Andrew Jones wrote:
> > Before we add more common code to the wfi emulation, let's first
> > factor out everything common.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  2 ++
> >  arch/arm/kvm/handle_exit.c        | 14 +++++---------
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/handle_exit.c      | 14 +++++---------
> >  virt/kvm/arm/arm.c                | 13 +++++++++++++
> >  virt/kvm/arm/psci.c               | 15 +++++++--------
> >  6 files changed, 34 insertions(+), 26 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 85f3c20b9759..964320825372 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -231,6 +231,8 @@ void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  void kvm_arm_vcpu_power_on(struct kvm_vcpu *vcpu);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> > +void kvm_arm_emulate_wfe(struct kvm_vcpu *vcpu);
> > +void kvm_arm_emulate_wfi(struct kvm_vcpu *vcpu);
> >  
> >  int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >  unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> > index cf8bf6bf87c4..e40466577c87 100644
> > --- a/arch/arm/kvm/handle_exit.c
> > +++ b/arch/arm/kvm/handle_exit.c
> > @@ -57,22 +57,18 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >   * @run:	the kvm_run structure pointer
> >   *
> >   * WFE: Yield the CPU and come back to this vcpu when the scheduler
> > - * decides to.
> > - * WFI: Simply call kvm_vcpu_block(), which will halt execution of
> > - * world-switches and schedule other host processes until there is an
> > - * incoming IRQ or FIQ to the VM.
> > + *      decides to.
> > + * WFI: Halt execution of world-switches and schedule other host
> > + *      processes until there is an incoming IRQ or FIQ to the VM.
> 
> s/VM/VCPU/
> 
> >   */
> >  static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >  	if (kvm_vcpu_get_hsr(vcpu) & HSR_WFI_IS_WFE) {
> >  		trace_kvm_wfx(*vcpu_pc(vcpu), true);
> > -		vcpu->stat.wfe_exit_stat++;
> > -		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
> > +		kvm_arm_emulate_wfe(vcpu);
> >  	} else {
> >  		trace_kvm_wfx(*vcpu_pc(vcpu), false);
> > -		vcpu->stat.wfi_exit_stat++;
> > -		kvm_vcpu_block(vcpu);
> > -		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +		kvm_arm_emulate_wfi(vcpu);
> >  	}
> >  
> >  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 25545a87de11..a774f6b30474 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -332,6 +332,8 @@ void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  void kvm_arm_vcpu_power_on(struct kvm_vcpu *vcpu);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> > +void kvm_arm_emulate_wfe(struct kvm_vcpu *vcpu);
> > +void kvm_arm_emulate_wfi(struct kvm_vcpu *vcpu);
> >  
> >  u64 __kvm_call_hyp(void *hypfn, ...);
> >  #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 7debb74843a0..7ba50a296d10 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -74,22 +74,18 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >   * @vcpu:	the vcpu pointer
> >   *
> >   * WFE: Yield the CPU and come back to this vcpu when the scheduler
> > - * decides to.
> > - * WFI: Simply call kvm_vcpu_block(), which will halt execution of
> > - * world-switches and schedule other host processes until there is an
> > - * incoming IRQ or FIQ to the VM.
> > + *      decides to.
> > + * WFI: Halt execution of world-switches and schedule other host
> > + *      processes until there is an incoming IRQ or FIQ to the VM.
> >   */
> >  static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> >  	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
> >  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
> > -		vcpu->stat.wfe_exit_stat++;
> > -		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
> > +		kvm_arm_emulate_wfe(vcpu);
> >  	} else {
> >  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> > -		vcpu->stat.wfi_exit_stat++;
> > -		kvm_vcpu_block(vcpu);
> > -		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +		kvm_arm_emulate_wfi(vcpu);
> >  	}
> >  
> >  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 954e77608d29..220a3dbda76c 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -573,6 +573,19 @@ void kvm_arm_resume_guest(struct kvm *kvm)
> >  	}
> >  }
> >  
> > +void kvm_arm_emulate_wfe(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->stat.wfe_exit_stat++;
> > +	kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
> > +}
> > +
> > +void kvm_arm_emulate_wfi(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->stat.wfi_exit_stat++;
> > +	kvm_vcpu_block(vcpu);
> > +	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > +}
> > +
> >  static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> >  {
> >  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> > index a7bf152f1247..755c415304ea 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -50,20 +50,19 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  	 * This means for KVM the wakeup events are interrupts and
> >  	 * this is consistent with intended use of StateID as described
> >  	 * in section 5.4.1 of PSCI v0.2 specification (ARM DEN 0022A).
> > -	 *
> > -	 * Further, we also treat power-down request to be same as
> > -	 * stand-by request as-per section 5.4.2 clause 3 of PSCI v0.2
> > -	 * specification (ARM DEN 0022A). This means all suspend states
> > -	 * for KVM will preserve the register state.
> >  	 */
> > -	kvm_vcpu_block(vcpu);
> > -	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> > -
> > +	kvm_arm_emulate_wfi(vcpu);
> >  	return PSCI_RET_SUCCESS;
> >  }
> >  
> >  static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
> >  {
> > +	/*
> > +	 * We treat a power-off request the same as a stand-by request,
> > +	 * as-per section 5.4.2 clause 3 of PSCI v0.2* specification
> > +	 * (ARM DEN 0022A). This means all suspend states for KVM will
> > +	 * preserve the register state.
> > +	 */
> 
> I'm not actually convinced that this part of the comment was about
> power-off.  I think what it was trying to say was simply that a suspend
> operation should preverse the register state, and therefore the
> commentary doesn't belong in this function.  I agree that the comment is
> potentially more confusing (I lost the exact version of the document
> referred to in the original comment so can't be sure if there was
> something unclear in the original document or if the comment is just
> vaguely written), than it helps.  Therefore, I think you should either
> (a) keep the comment as it is, (b) rewrite it to make sense, or (c) just
> delete it.

I can't find version A either. I read over C just now to try and think of
a way to improve the comment, but I wasn't overly enlightened, so I'll
probably just opt to remove it.

> 
> >  	kvm_arm_vcpu_power_off(vcpu);
> >  }
> >  
> > -- 
> > 2.13.5
> > 
> 
> Thanks,
> -Christoffer

Thanks,
drew
