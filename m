From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 8/9] KVM: arm/arm64: Avoid work when userspace iqchips
 are not used
Date: Tue, 2 Jan 2018 10:09:12 +0100
Message-ID: <20180102090912.GA30832@cbox>
References: <20171220113606.7030-1-christoffer.dall@linaro.org>
 <20171220113606.7030-9-christoffer.dall@linaro.org>
 <86d130qgaz.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <86d130qgaz.wl-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 27, 2017 at 04:36:04PM +0000, Marc Zyngier wrote:
> On Wed, 20 Dec 2017 11:36:05 +0000,
> Christoffer Dall wrote:
> > 
> > We currently check if the VM has a userspace irqchip in several places
> > along the critical path, and if so, we do some work which is only
> > required for having an irqchip in userspace.  This is unfortunate, as we
> > could avoid doing any work entirely, if we didn't have to support
> > irqchip in userspace.
> > 
> > Realizing the userspace irqchip on ARM is mostly a developer or hobby
> > feature, and is unlikely to be used in servers or other scenarios where
> > performance is a priority, we can use a refcounted static key to only
> > check the irqchip configuration when we have at least one VM that uses
> > an irqchip in userspace.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  2 ++
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  virt/kvm/arm/arch_timer.c         |  6 ++--
> >  virt/kvm/arm/arm.c                | 59 ++++++++++++++++++++++++++++-----------
> >  4 files changed, 50 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index a9f7d3f47134..6394fb99da7f 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -48,6 +48,8 @@
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  
> > +DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> > +
> >  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ea6cb5b24258..e7218cf7df2a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -47,6 +47,8 @@
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  
> > +DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> > +
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> >  int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index d845d67b7062..cfcd0323deab 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -103,7 +103,8 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
> >  	if (kvm_timer_irq_can_fire(vtimer))
> >  		kvm_timer_update_irq(vcpu, true, vtimer);
> >  
> > -	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> > +	if (static_branch_unlikely(&userspace_irqchip_in_use) &&
> > +	    unlikely(!irqchip_in_kernel(vcpu->kvm)))
> >  		kvm_vtimer_update_mask_user(vcpu);
> >  
> >  	return IRQ_HANDLED;
> > @@ -284,7 +285,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> >  	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
> >  				   timer_ctx->irq.level);
> >  
> > -	if (likely(irqchip_in_kernel(vcpu->kvm))) {
> > +	if (!static_branch_unlikely(&userspace_irqchip_in_use) &&
> > +	    likely(irqchip_in_kernel(vcpu->kvm))) {
> >  		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> >  					  timer_ctx->irq.irq,
> >  					  timer_ctx->irq.level,
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 3610e132df8b..0cf0459134ff 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -74,6 +74,8 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
> >  	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
> >  }
> >  
> > +DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> > +
> >  /**
> >   * kvm_arm_get_running_vcpu - get the vcpu running on the current CPU.
> >   * Must be called from non-preemptible context
> > @@ -302,6 +304,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> > +	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
> > +		static_branch_dec(&userspace_irqchip_in_use);
> >  	kvm_arch_vcpu_free(vcpu);
> >  }
> >  
> > @@ -522,14 +526,22 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >  
> >  	vcpu->arch.has_run_once = true;
> >  
> > -	/*
> > -	 * Map the VGIC hardware resources before running a vcpu the first
> > -	 * time on this VM.
> > -	 */
> > -	if (unlikely(irqchip_in_kernel(kvm) && !vgic_ready(kvm))) {
> > -		ret = kvm_vgic_map_resources(kvm);
> > -		if (ret)
> > -			return ret;
> > +	if (likely(irqchip_in_kernel(kvm))) {
> > +		/*
> > +		 * Map the VGIC hardware resources before running a vcpu the
> > +		 * first time on this VM.
> > +		 */
> > +		if (unlikely(!vgic_ready(kvm))) {
> > +			ret = kvm_vgic_map_resources(kvm);
> > +			if (ret)
> > +				return ret;
> > +		}
> > +	} else {
> > +		/*
> > +		 * Tell the rest of the code that there are userspace irqchip
> > +		 * VMs in the wild.
> > +		 */
> > +		static_branch_inc(&userspace_irqchip_in_use);
> >  	}
> >  
> >  	ret = kvm_timer_enable(vcpu);
> > @@ -664,18 +676,29 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		kvm_vgic_flush_hwstate(vcpu);
> >  
> >  		/*
> > -		 * If we have a singal pending, or need to notify a userspace
> > -		 * irqchip about timer or PMU level changes, then we exit (and
> > -		 * update the timer level state in kvm_timer_update_run
> > -		 * below).
> > +		 * Exit if we have a singal pending so that we can deliver the
> 
> nit: s/singal/signal/
> 

dang, one more.

> > +		 * signal to user space.
> >  		 */
> > -		if (signal_pending(current) ||
> > -		    kvm_timer_should_notify_user(vcpu) ||
> > -		    kvm_pmu_should_notify_user(vcpu)) {
> > +		if (signal_pending(current)) {
> >  			ret = -EINTR;
> >  			run->exit_reason = KVM_EXIT_INTR;
> >  		}
> >  
> > +		/*
> > +		 * If we're using a userspace irqchip, then check if we need
> > +		 * to tell a userspace irqchip about timer or PMU level
> > +		 * changes and if so, exit to userspace (the actual level
> > +		 * state gets updated in kvm_timer_update_run and
> > +		 * kvm_pmu_update_run below.
> 
> nit: missing closing parenthesis.
> 
> > +		 */
> > +		if (static_branch_unlikely(&userspace_irqchip_in_use)) {
> > +			if (kvm_timer_should_notify_user(vcpu) ||
> > +			    kvm_pmu_should_notify_user(vcpu)) {
> > +				ret = -EINTR;
> > +				run->exit_reason = KVM_EXIT_INTR;
> > +			}
> > +		}
> > +
> >  		/*
> >  		 * Ensure we set mode to IN_GUEST_MODE after we disable
> >  		 * interrupts and before the final VCPU requests check.
> > @@ -688,7 +711,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		    kvm_request_pending(vcpu)) {
> >  			vcpu->mode = OUTSIDE_GUEST_MODE;
> >  			kvm_pmu_sync_hwstate(vcpu);
> > -			kvm_timer_sync_hwstate(vcpu);
> > +			if (static_branch_unlikely(&userspace_irqchip_in_use))
> > +				kvm_timer_sync_hwstate(vcpu);
> >  			kvm_vgic_sync_hwstate(vcpu);
> >  			local_irq_enable();
> >  			preempt_enable();
> > @@ -732,7 +756,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		 * we don't want vtimer interrupts to race with syncing the
> >  		 * timer virtual interrupt state.
> >  		 */
> > -		kvm_timer_sync_hwstate(vcpu);
> > +		if (static_branch_unlikely(&userspace_irqchip_in_use))
> > +			kvm_timer_sync_hwstate(vcpu);
> >  
> >  		/*
> >  		 * We may have taken a host interrupt in HYP mode (ie
> > -- 
> > 2.14.2
> > 
> 
> Other than the trivial nits above:
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Thanks for this.

I've now queued this series and pushed it to kvmarm/next.

-Christoffer
