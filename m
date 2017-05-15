From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 04/10] KVM: arm/arm64: use vcpu request in
 kvm_arm_halt_vcpu
Date: Mon, 15 May 2017 13:14:42 +0200
Message-ID: <20170515111442.GA18755@cbox>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-5-drjones@redhat.com>
 <20170506180809.GA5923@cbox>
 <20170509170251.eernp7sdl6tzchdp@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509170251.eernp7sdl6tzchdp@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 09, 2017 at 07:02:51PM +0200, Andrew Jones wrote:
> On Sat, May 06, 2017 at 08:08:09PM +0200, Christoffer Dall wrote:
> > On Wed, May 03, 2017 at 06:06:29PM +0200, Andrew Jones wrote:
> > > VCPU halting/resuming is partially implemented with VCPU requests.
> > > When kvm_arm_halt_guest() is called all VCPUs get the EXIT request,
> > > telling them to exit guest mode and look at the state of 'pause',
> > > which will be true, telling them to sleep.  As ARM's VCPU RUN
> > > implements the memory barrier pattern described in "Ensuring Requests
> > > Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst, there's
> > > no way for a VCPU halted by kvm_arm_halt_guest() to miss the pause
> > > state change.  However, before this patch, a single VCPU halted with
> > > kvm_arm_halt_vcpu() did not get a request, opening a tiny race window.
> > > This patch adds the request, closing the race window and also allowing
> > > us to remove the final check of pause in VCPU RUN, as the final check
> > > for requests is sufficient.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > 
> > > ---
> > > 
> > > I have two questions about the halting/resuming.
> > > 
> > > Question 1:
> > > 
> > > Do we even need kvm_arm_halt_vcpu()/kvm_arm_resume_vcpu()? It should
> > > only be necessary if one VCPU can activate or inactivate the private
> > > IRQs of another VCPU, right?  That doesn't seem like something that
> > > should be possible, but I'm GIC-illiterate...
> > 
> > True, it shouldn't be possible.  I wonder if we were thinking of
> > userspace access to the CPU-specific data, but we already ensure that no
> > VCPUs are running at that time, so I don't think it should be necessary.
> > 
> > > 
> > > Question 2:
> > > 
> > > It's not clear to me if we have another problem with halting/resuming
> > > or not.  If it's possible for VCPU1 and VCPU2 to race in
> > > vgic_mmio_write_s/cactive(), then the following scenario could occur,
> > > leading to VCPU3 being in guest mode when it should not be.  Does the
> > > hardware prohibit more than one VCPU entering trap handlers that lead
> > > to these functions at the same time?  If not, then I guess pause needs
> > > to be a counter instead of a boolean.
> > > 
> > >  VCPU1                 VCPU2                  VCPU3
> > >  -----                 -----                  -----
> > >                        VCPU3->pause = true;
> > >                        halt(VCPU3);
> > >                                               if (pause)
> > >                                                 sleep();
> > >  VCPU3->pause = true;
> > >  halt(VCPU3);
> > >                        VCPU3->pause = false;
> > >                        resume(VCPU3);
> > >                                               ...wake up...
> > >                                               if (!pause)
> > >                                                 Enter guest mode. Bad!
> > >  VCPU3->pause = false;
> > >  resume(VCPU3);
> > > 
> > > (Yes, the "Bad!" is there to both identify something we don't want
> > >  occurring and to make fun of Trump's tweeting style.)
> > 
> > I think it's bad, and it might be even worse, because it could lead to a
> > CPU looping forever in the host kernel, since there's no guarantee to
> > exit from the VM in the other VCPU thread.
> > 
> > But I think simply taking the kvm->lock mutex to serialize the mmio
> > active change operations should be sufficient.
> > 
> > If we agree on this I can send a patch with your reported by that fixes
> > that issue, which gets rid of kvm_arm_halt_vcpu and requires you to
> > modify your first patch to clear the KVM_REQ_VCPU_EXIT flag for each
> > vcpu in kvm_arm_halt_guest instead and you can fold the remaining change
> > from this patch into a patch that completely gets rid of the pause flag.
> 
> Yup, seems reasonable to me to lock the kvm mutex on a stop the guest type
> action.
> 
> > 
> > See untested patch draft at the end of this mail.
> > 
> > Thanks,
> > -Christoffer
> > 
> > > ---
> > >  arch/arm/kvm/arm.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > > index 47f6c7fdca96..9174ed13135a 100644
> > > --- a/arch/arm/kvm/arm.c
> > > +++ b/arch/arm/kvm/arm.c
> > > @@ -545,6 +545,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
> > >  void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
> > >  {
> > >  	vcpu->arch.pause = true;
> > > +	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
> > >  	kvm_vcpu_kick(vcpu);
> > >  }
> > >  
> > > @@ -664,7 +665,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > >  
> > >  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> > >  		    kvm_request_pending(vcpu) ||
> > > -		    vcpu->arch.power_off || vcpu->arch.pause) {
> > > +		    vcpu->arch.power_off) {
> > >  			vcpu->mode = OUTSIDE_GUEST_MODE;
> > >  			local_irq_enable();
> > >  			kvm_pmu_sync_hwstate(vcpu);
> > > -- 
> > > 2.9.3
> > > 
> > 
> > 
> > Untested draft patch:
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index d488b88..b77a3af 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -234,8 +234,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >  struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> > -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
> > -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
> >  
> >  int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> >  unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 578df18..7a38d5a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -334,8 +334,6 @@ struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
> >  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> > -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu);
> > -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu);
> >  
> >  u64 __kvm_call_hyp(void *hypfn, ...);
> >  #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 7941699..932788a 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -542,27 +542,15 @@ void kvm_arm_halt_guest(struct kvm *kvm)
> >  	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
> >  }
> >  
> > -void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
> > -{
> > -	vcpu->arch.pause = true;
> > -	kvm_vcpu_kick(vcpu);
> > -}
> > -
> > -void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
> > -{
> > -	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> > -
> > -	vcpu->arch.pause = false;
> > -	swake_up(wq);
> > -}
> > -
> >  void kvm_arm_resume_guest(struct kvm *kvm)
> >  {
> >  	int i;
> >  	struct kvm_vcpu *vcpu;
> >  
> > -	kvm_for_each_vcpu(i, vcpu, kvm)
> > -		kvm_arm_resume_vcpu(vcpu);
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		vcpu->arch.pause = false;
> > +		swake_up(kvm_arch_vcpu_wq(vcpu));
> > +	}
> >  }
> >  
> >  static void vcpu_sleep(struct kvm_vcpu *vcpu)
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index 2a5db13..c143add 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -231,23 +231,21 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> >   * be migrated while we don't hold the IRQ locks and we don't want to be
> >   * chasing moving targets.
> >   *
> > - * For private interrupts, we only have to make sure the single and only VCPU
> > - * that can potentially queue the IRQ is stopped.
> > + * For private interrupts we don't have to do anything because userspace
> > + * accesses to the VGIC state already require all VCPUs to be stopped, and
> > + * only the VCPU itself can modify its private interrupts active state, which
> > + * guarantees that the VCPU is not running.
> >   */
> >  static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> >  {
> > -	if (intid < VGIC_NR_PRIVATE_IRQS)
> > -		kvm_arm_halt_vcpu(vcpu);
> > -	else
> > +	if (intid > VGIC_NR_PRIVATE_IRQS)
> >  		kvm_arm_halt_guest(vcpu->kvm);
> >  }
> >  
> >  /* See vgic_change_active_prepare */
> >  static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> >  {
> > -	if (intid < VGIC_NR_PRIVATE_IRQS)
> > -		kvm_arm_resume_vcpu(vcpu);
> > -	else
> > +	if (intid > VGIC_NR_PRIVATE_IRQS)
> >  		kvm_arm_resume_guest(vcpu->kvm);
> >  }
> >  
> > @@ -258,6 +256,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >  	int i;
> >  
> > +	mutex_lock(&vcpu->kvm->lock);
> >  	vgic_change_active_prepare(vcpu, intid);
> >  	for_each_set_bit(i, &val, len * 8) {
> >  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> > @@ -265,6 +264,7 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >  		vgic_put_irq(vcpu->kvm, irq);
> >  	}
> >  	vgic_change_active_finish(vcpu, intid);
> > +	mutex_unlock(&vcpu->kvm->lock);
> >  }
> >  
> >  void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> > @@ -274,6 +274,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> >  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >  	int i;
> >  
> > +	mutex_lock(&vcpu->kvm->lock);
> >  	vgic_change_active_prepare(vcpu, intid);
> >  	for_each_set_bit(i, &val, len * 8) {
> >  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> > @@ -281,6 +282,7 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> >  		vgic_put_irq(vcpu->kvm, irq);
> >  	}
> >  	vgic_change_active_finish(vcpu, intid);
> > +	mutex_unlock(&vcpu->kvm->lock);
> >  }
> >  
> >  unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
> 
> Looks good to me. How about adding kvm->lock to the locking order comment
> at the top of virt/kvm/arm/vgic/vgic.c too. With that, you can add my R-b
> on the posting.
> 
> I'll rebase this series on your posting.
> 

FYI, this patch is now in kvmarm/queue.

-Christoffer

> Thanks,
> drew
