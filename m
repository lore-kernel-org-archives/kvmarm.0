From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3] KVM: arm/arm64: vgic-new: Synchronize changes to
 active state
Date: Fri, 20 May 2016 16:49:08 +0200
Message-ID: <20160520144908.GA26381@cbox>
References: <1463752410-3800-1-git-send-email-christoffer.dall@linaro.org>
 <1463754660-25805-1-git-send-email-christoffer.dall@linaro.org>
 <573F2283.2030909@arm.com> <573F2365.5020605@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B91EE40FA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 10:44:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oDMU+o2l3gx8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2016 10:44:57 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CAE940F90
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 10:44:57 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id n129so86202849wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2016 07:48:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <573F2365.5020605@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 20, 2016 at 03:47:01PM +0100, Marc Zyngier wrote:
> On 20/05/16 15:43, Marc Zyngier wrote:
> > On 20/05/16 15:31, Christoffer Dall wrote:
> >> When modifying the active state of an interrupt via the MMIO interface,
> >> we should ensure that the write has the intended effect.
> >>
> >> If a guest sets an interrupt to active, but that interrupt is already
> >> flushed into a list register on a running VCPU, then that VCPU will
> >> write the active state back into the struct vgic_irq upon returning from
> >> the guest and syncing its state.  This is a non-benign race, because the
> >> guest can observe that an interrupt is not active, and it can have a
> >> reasonable expectations that other VCPUs will not ack any IRQs, and then
> >> set the state to active, and expect it to stay that way.  Currently we
> >> are not honoring this case.
> >>
> >> Thefore, change both the SACTIVE and CACTIVE mmio handlers to stop the
> >> world, change the irq state, potentially queue the irq if we're setting
> >> it to active, and then continue.
> >>
> >> We take this chance to slightly optimize these functions by not stopping
> >> the world when touching private interrupts where there is inherently no
> >> possible race.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> ---
> >> Changes since v1:
> >>  - Dont' stop the world for private IRQs
> >> Changes since v2:
> >>  - Explicitly stop the VCPU that private IRQs target because GICv3
> >>    redistributors allow any VCPU to tamper with the active state of
> >>    interrupts private to another VCPU.
> >>
> >>  arch/arm/include/asm/kvm_host.h   |   2 +
> >>  arch/arm/kvm/arm.c                |   8 ++-
> >>  arch/arm64/include/asm/kvm_host.h |   2 +
> >>  virt/kvm/arm/vgic/vgic-mmio.c     | 105 ++++++++++++++++++++++++--------------
> >>  4 files changed, 77 insertions(+), 40 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> >> index 832be03..987da9f 100644
> >> --- a/arch/arm/include/asm/kvm_host.h
> >> +++ b/arch/arm/include/asm/kvm_host.h
> >> @@ -229,6 +229,8 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >>  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> >>  void kvm_arm_halt_guest(struct kvm *kvm);
> >>  void kvm_arm_resume_guest(struct kvm *kvm);
> >> +void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
> >> +void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
> >>  
> >>  int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >>  unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
> >> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >> index e89329d..5a599c2 100644
> >> --- a/arch/arm/kvm/arm.c
> >> +++ b/arch/arm/kvm/arm.c
> >> @@ -502,7 +502,13 @@ void kvm_arm_halt_guest(struct kvm *kvm)
> >>  	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
> >>  }
> >>  
> >> -static void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
> >> +void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
> >> +{
> >> +	vcpu->arch.pause = true;
> >> +	kvm_vcpu_kick(vcpu);
> >> +}
> >> +
> >> +void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> >>  
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index fa94f91..38746d2 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -329,6 +329,8 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
> >>  void kvm_arm_halt_guest(struct kvm *kvm);
> >>  void kvm_arm_resume_guest(struct kvm *kvm);
> >> +void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
> >> +void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
> >>  
> >>  u64 __kvm_call_hyp(void *hypfn, ...);
> >>  #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> >> index 4ef3571..059595e 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> >> @@ -173,6 +173,66 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> >>  	return value;
> >>  }
> >>  
> >> +static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> >> +				    bool new_active_state)
> >> +{
> >> +	spin_lock(&irq->irq_lock);
> >> +	/*
> >> +	 * If this virtual IRQ was written into a list register, we
> >> +	 * have to make sure the CPU that runs the VCPU thread has
> >> +	 * synced back LR state to the struct vgic_irq.  We can only
> >> +	 * know this for sure, when either this irq is not assigned to
> >> +	 * anyone's AP list anymore, or the VCPU thread is not
> >> +	 * running on any CPUs.
> >> +	 *
> >> +	 * In the opposite case, we know the VCPU thread may be on its
> >> +	 * way back from the guest and still has to sync back this
> >> +	 * IRQ, so we release and re-acquire the spin_lock to let the
> >> +	 * other thread sync back the IRQ.
> >> +	 */
> >> +	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> >> +	       irq->vcpu->cpu != -1) { /* VCPU thread is running */
> >> +		BUG_ON(irq->intid < VGIC_NR_PRIVATE_IRQS);
> >> +		cond_resched_lock(&irq->irq_lock);
> >> +	}
> >> +
> >> +	irq->active = new_active_state;
> >> +	if (new_active_state)
> >> +		vgic_queue_irq_unlock(vcpu->kvm, irq);
> >> +	else
> >> +		spin_unlock(&irq->irq_lock);
> >> +}
> >> +
> >> +/*
> >> + * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
> >> + * is not queued on some running VCPU's LRs, because then the change to the
> >> + * active state can be overwritten when the VCPU's state is synced coming back
> >> + * from the guest.
> >> + *
> >> + * For shared interrupts, we have to stop all the VCPUs because interrupts can
> >> + * be migrated while we don't hold the IRQ locks and we don't want to be
> >> + * chasing moving targets.
> >> + *
> >> + * For private interrupts, we only have to make sure the single and only VCPU
> >> + * that can potentially queue the IRQ is stopped.
> >> + */
> >> +static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> >> +{
> >> +	if (intid < VGIC_NR_PRIVATE_IRQS)
> >> +		kvm_arm_halt_vcpu(vcpu);
> >> +	else
> >> +		kvm_arm_halt_guest(vcpu->kvm);
> >> +}
> >> +
> >> +/* See vgic_change_active_prepare */
> >> +static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> >> +{
> >> +	if (intid < VGIC_NR_PRIVATE_IRQS)
> >> +		kvm_arm_resume_vcpu(vcpu);
> >> +	else
> >> +		kvm_arm_resume_guest(vcpu->kvm);
> >> +}
> >> +
> >>  void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >>  			     gpa_t addr, unsigned int len,
> >>  			     unsigned long val)
> >> @@ -180,32 +240,12 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >>  	int i;
> >>  
> >> -	kvm_arm_halt_guest(vcpu->kvm);
> >> +	vgic_change_active_prepare(vcpu, intid);
> > 
> > You're still only halting the current vcpu, not the one targeted by the
> > interrupt.
> > 
> > Let's not bother with that for the time being. I'm happy to merge v1,
> > and optimize this when this starts bugging us (and this is going to take
> > a while).
> 
> Actually, I now realize that you are right. The MMIO handler is passing
> us the target vcpu, not the the one causing the exit. I'm an idiot.

You are most certainly not.

> 
> So this looks fine to me.
> 

Cool, thanks.

-Christoffer
