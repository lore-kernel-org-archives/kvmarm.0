From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 8/9] arm/arm64: KVM: Rework the arch timer to use
 level-triggered semantics
Date: Fri, 4 Sep 2015 00:00:01 +0200
Message-ID: <20150903220001.GI5171@cbox>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
 <1440942866-23802-9-git-send-email-christoffer.dall@linaro.org>
 <55E87E1F.7030702@arm.com>
 <20150903172335.GH5171@cbox>
 <55E8836A.6080908@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E8836A.6080908@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 03, 2015 at 06:29:14PM +0100, Marc Zyngier wrote:
> On 03/09/15 18:23, Christoffer Dall wrote:
> > On Thu, Sep 03, 2015 at 06:06:39PM +0100, Marc Zyngier wrote:
> >> On 30/08/15 14:54, Christoffer Dall wrote:
> >>> The arch timer currently uses edge-triggered semantics in the sense that
> >>> the line is never sampled by the vgic and lowering the line from the
> >>> timer to the vgic doesn't have any affect on the pending state of
> >>> virtual interrupts in the vgic.  This means that we do not support a
> >>> guest with the otherwise valid behavior of (1) disable interrupts (2)
> >>> enable the timer (3) disable the timer (4) enable interrupts.  Such a
> >>> guest would validly not expect to see any interrupts on real hardware,
> >>> but will see interrupts on KVM.
> >>>
> >>> This patches fixes this shortcoming through the following series of
> >>> changes.
> >>>
> >>> First, we change the flow of the timer/vgic sync/flush operations.  Now
> >>> the timer is always flushed/synced before the vgic, because the vgic
> >>> samples the state of the timer output.  This has the implication that we
> >>> move the timer operations in to non-preempible sections, but that is
> >>> fine after the previous commit getting rid of hrtimer schedules on every
> >>> entry/exit.
> >>>
> >>> Second, we change the internal behavior of the timer, letting the timer
> >>> keep track of its previous output state, and only lower/raise the line
> >>> to the vgic when the state changes.  Note that in theory this could have
> >>> been accomplished more simply by signalling the vgic every time the
> >>> state *potentially* changed, but we don't want to be hitting the vgic
> >>> more often than necessary.
> >>>
> >>> Third, we get rid of the use of the map->active field in the vgic and
> >>> instead simply set the interrupt as active on the physical distributor
> >>> whenever we signal a mapped interrupt to the guest, and we reset the
> >>> active state when we sync back the HW state from the vgic.
> >>>
> >>> Fourth, and finally, we now initialize the timer PPIs (and all the other
> >>> unused PPIs for now), to be level-triggered, and modify the sync code to
> >>> sample the line state on HW sync and re-inject a new interrupt if it is
> >>> still pending at that time.
> >>>
> >>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>> ---
> >>>  arch/arm/kvm/arm.c           | 11 +++++--
> >>>  include/kvm/arm_arch_timer.h |  2 +-
> >>>  include/kvm/arm_vgic.h       |  3 --
> >>>  virt/kvm/arm/arch_timer.c    | 68 +++++++++++++++++++++++++++++++-------------
> >>>  virt/kvm/arm/vgic.c          | 67 +++++++++++++++----------------------------
> >>>  5 files changed, 81 insertions(+), 70 deletions(-)
> >>>
> >>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> >>> index bdf8871..102a4aa 100644
> >>> --- a/arch/arm/kvm/arm.c
> >>> +++ b/arch/arm/kvm/arm.c
> >>> @@ -561,9 +561,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>  
> >>>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
> >>>  			local_irq_enable();
> >>> +			kvm_timer_sync_hwstate(vcpu);
> >>>  			kvm_vgic_sync_hwstate(vcpu);
> >>>  			preempt_enable();
> >>> -			kvm_timer_sync_hwstate(vcpu);
> >>>  			continue;
> >>>  		}
> >>>  
> >>> @@ -608,12 +608,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >>>  		kvm_guest_exit();
> >>>  		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> >>>  
> >>> +		/*
> >>> +		 * We must sync the timer state before the vgic state so that
> >>> +		 * the vgic can properly sample the updated state of the
> >>> +		 * interrupt line.
> >>> +		 */
> >>> +		kvm_timer_sync_hwstate(vcpu);
> >>> +
> >>>  		kvm_vgic_sync_hwstate(vcpu);
> >>>  
> >>>  		preempt_enable();
> >>>  
> >>> -		kvm_timer_sync_hwstate(vcpu);
> >>> -
> >>>  		ret = handle_exit(vcpu, run, ret);
> >>>  	}
> >>>  
> >>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> >>> index ef14cc1..1800227 100644
> >>> --- a/include/kvm/arm_arch_timer.h
> >>> +++ b/include/kvm/arm_arch_timer.h
> >>> @@ -51,7 +51,7 @@ struct arch_timer_cpu {
> >>>  	bool				armed;
> >>>  
> >>>  	/* Timer IRQ */
> >>> -	const struct kvm_irq_level	*irq;
> >>> +	struct kvm_irq_level		irq;
> >>>  
> >>>  	/* VGIC mapping */
> >>>  	struct irq_phys_map		*map;
> >>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >>> index d901f1a..99011a0 100644
> >>> --- a/include/kvm/arm_vgic.h
> >>> +++ b/include/kvm/arm_vgic.h
> >>> @@ -163,7 +163,6 @@ struct irq_phys_map {
> >>>  	u32			virt_irq;
> >>>  	u32			phys_irq;
> >>>  	u32			irq;
> >>> -	bool			active;
> >>>  };
> >>>  
> >>>  struct irq_phys_map_entry {
> >>> @@ -358,8 +357,6 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> >>>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> >>>  					   int virt_irq, int irq);
> >>>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> >>> -bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
> >>> -void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
> >>>  
> >>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
> >>>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
> >>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >>> index 018f3d6..747302f 100644
> >>> --- a/virt/kvm/arm/arch_timer.c
> >>> +++ b/virt/kvm/arm/arch_timer.c
> >>> @@ -59,18 +59,6 @@ static void timer_disarm(struct arch_timer_cpu *timer)
> >>>  	}
> >>>  }
> >>>  
> >>> -static void kvm_timer_inject_irq(struct kvm_vcpu *vcpu)
> >>> -{
> >>> -	int ret;
> >>> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>> -
> >>> -	kvm_vgic_set_phys_irq_active(timer->map, true);
> >>> -	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> >>> -					 timer->map,
> >>> -					 timer->irq->level);
> >>> -	WARN_ON(ret);
> >>> -}
> >>> -
> >>>  static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
> >>>  {
> >>>  	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
> >>> @@ -116,8 +104,7 @@ static bool kvm_timer_irq_enabled(struct kvm_vcpu *vcpu)
> >>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>>  
> >>>  	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
> >>> -		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE) &&
> >>> -		!kvm_vgic_get_phys_irq_active(timer->map);
> >>> +		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE);
> >>>  }
> >>>  
> >>>  bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >>> @@ -134,6 +121,45 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >>>  	return cval <= now;
> >>>  }
> >>>  
> >>> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	int ret;
> >>> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>> +
> >>> +	BUG_ON(!vgic_initialized(vcpu->kvm));
> >>> +
> >>> +	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> >>> +					 timer->map,
> >>> +					 timer->irq.level);
> >>> +	WARN_ON(ret);
> >>> +}
> >>> +
> >>> +/*
> >>> + * Check if there was a change in the timer state (should we raise or lower
> >>> + * the line level to the GIC).
> >>> + */
> >>> +static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>> +
> >>> +	/*
> >>> +	 * If userspace modified the timer registers via SET_ONE_REG before
> >>> +	 * the vgic was initialized, we mustn't set the timer->irq.level value
> >>> +	 * because the guest would never see the interrupt.  Instead wait
> >>> +	 * until we call this funciton from kvm_timer_flush_hwstate.
> >>> +	 */
> >>> +	if (!vgic_initialized(vcpu->kvm))
> >>> +	    return;
> >>> +
> >>> +	if (kvm_timer_should_fire(vcpu) && !timer->irq.level) {
> >>> +		timer->irq.level = 1;
> >>> +		kvm_timer_update_irq(vcpu);
> >>> +	} else if (!kvm_timer_should_fire(vcpu) && timer->irq.level) {
> >>> +		timer->irq.level = 0;
> >>> +		kvm_timer_update_irq(vcpu);
> >>> +	}
> >>> +}
> >>> +
> >>
> >> It took me ages to parse this, so I rewrote it to match my understanding:
> >>
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 8a0fdfc..a722f0f 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -121,13 +121,14 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
> >>  	return cval <= now;
> >>  }
> >>  
> >> -static void kvm_timer_update_irq(struct kvm_vcpu *vcpu)
> >> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_state)
> >>  {
> >>  	int ret;
> >>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> >>  
> >>  	BUG_ON(!vgic_initialized(vcpu->kvm));
> >>  
> >> +	timer->irq.level = new_state;
> >>  	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> >>  					 timer->map,
> >>  					 timer->irq.level);
> >> @@ -151,13 +152,8 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
> >>  	if (!vgic_initialized(vcpu->kvm))
> >>  	    return;
> >>  
> >> -	if (kvm_timer_should_fire(vcpu) && !timer->irq.level) {
> >> -		timer->irq.level = 1;
> >> -		kvm_timer_update_irq(vcpu);
> >> -	} else if (!kvm_timer_should_fire(vcpu) && timer->irq.level) {
> >> -		timer->irq.level = 0;
> >> -		kvm_timer_update_irq(vcpu);
> >> -	}
> >> +	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
> >> +		kvm_timer_update_irq(vcpu, !timer->irq.level);
> >>  }
> >>  
> >>  /*
> >>
> >> Did I get it right?
> > 
> > almost, you'd have to assign timer->irq.level after you check for it
> > though, right?
> 
> That's why I've added this line in kvm_timer_update_irq()! :-)
> 

duh, /me learns to read diffs all over again.

Yeah, your version is probably easier to read. thanks.

> >>
> >>>  /*
> >>>   * Schedule the background timer before calling kvm_vcpu_block, so that this
> >>>   * thread is removed from its waitqueue and made runnable when there's a timer
> >>> @@ -191,8 +217,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> >>>  	 * If the timer expired while we were not scheduled, now is the time
> >>>  	 * to inject it.
> >>>  	 */
> >>> -	if (kvm_timer_should_fire(vcpu))
> >>> -		kvm_timer_inject_irq(vcpu);
> >>> +	kvm_timer_update_state(vcpu);
> >>>  }
> >>>  
> >>>  /**
> >>> @@ -208,8 +233,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
> >>>  
> >>>  	BUG_ON(timer_is_armed(timer));
> >>>  
> >>> -	if (kvm_timer_should_fire(vcpu))
> >>> -		kvm_timer_inject_irq(vcpu);
> >>> +	/*
> >>> +	 * The guest could have modified the timer registers or the timer
> >>> +	 * could have expired, update the timer state.
> >>> +	 */
> >>> +	kvm_timer_update_state(vcpu);
> >>>  }
> >>>  
> >>>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>> @@ -224,7 +252,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>>  	 * kvm_vcpu_set_target(). To handle this, we determine
> >>>  	 * vcpu timer irq number when the vcpu is reset.
> >>>  	 */
> >>> -	timer->irq = irq;
> >>> +	timer->irq.irq = irq->irq;
> >>>  
> >>>  	/*
> >>>  	 * Tell the VGIC that the virtual interrupt is tied to a
> >>> @@ -269,6 +297,8 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> >>>  	default:
> >>>  		return -1;
> >>>  	}
> >>> +
> >>> +	kvm_timer_update_state(vcpu);
> >>>  	return 0;
> >>>  }
> >>>  
> >>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >>> index 9ed8d53..f4ea950 100644
> >>> --- a/virt/kvm/arm/vgic.c
> >>> +++ b/virt/kvm/arm/vgic.c
> >>> @@ -1422,34 +1422,43 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >>>  /*
> >>>   * Save the physical active state, and reset it to inactive.
> >>>   *
> >>> - * Return 1 if HW interrupt went from active to inactive, and 0 otherwise.
> >>> + * Return true if there's a pending level triggered interrupt line to queue.
> >>>   */
> >>> -static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> >>> +static bool vgic_sync_hwirq(struct kvm_vcpu *vcpu, int lr, struct vgic_lr vlr)
> >>>  {
> >>>  	struct irq_phys_map *map;
> >>> +	bool phys_active;
> >>>  	int ret;
> >>>  
> >>>  	if (!(vlr.state & LR_HW))
> >>>  		return 0;
> >>>  
> >>>  	map = vgic_irq_map_search(vcpu, vlr.irq);
> >>> -	BUG_ON(!map || !map->active);
> >>> +	BUG_ON(!map);
> >>>  
> >>>  	ret = irq_get_irqchip_state(map->irq,
> >>>  				    IRQCHIP_STATE_ACTIVE,
> >>> -				    &map->active);
> >>> +				    &phys_active);
> >>>  
> >>>  	WARN_ON(ret);
> >>>  
> >>> -	if (map->active) {
> >>> +	if (phys_active) {
> >>> +		/*
> >>> +		 * Interrupt still marked as active on the physical
> >>> +		 * distributor, so guest did not EOI it yet.  Reset to
> >>> +		 * non-active so that other VMs can see interrupts from this
> >>> +		 * device.
> >>> +		 */
> >>>  		ret = irq_set_irqchip_state(map->irq,
> >>>  					    IRQCHIP_STATE_ACTIVE,
> >>>  					    false);
> >>>  		WARN_ON(ret);
> >>> -		return 0;
> >>> +		return false;
> >>>  	}
> >>>  
> >>> -	return 1;
> >>> +	/* Mapped edge-triggered interrupts not yet supported. */
> >>> +	WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
> >>
> >> Hmmm. What are we missing?
> >>
> > 
> > I don't know really, my brain ran out of memory, but it's not like we
> > claimed to support this earlier and clearly we didn't work this well
> > enough through.
> 
> We can definitely revisit this later, but I have the feeling that the
> flow is quite similar...
> 
> > 
> >>> +	return process_level_irq(vcpu, lr, vlr);
> >>>  }
> >>>  
> >>>  /* Sync back the VGIC state after a guest run */
> >>> @@ -1474,18 +1483,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
> >>>  			continue;
> >>>  
> >>>  		vlr = vgic_get_lr(vcpu, lr);
> >>> -		if (vgic_sync_hwirq(vcpu, vlr)) {
> >>> -			/*
> >>> -			 * So this is a HW interrupt that the guest
> >>> -			 * EOI-ed. Clean the LR state and allow the
> >>> -			 * interrupt to be sampled again.
> >>> -			 */
> >>> -			vlr.state = 0;
> >>> -			vlr.hwirq = 0;
> >>> -			vgic_set_lr(vcpu, lr, vlr);
> >>> -			vgic_irq_clear_queued(vcpu, vlr.irq);
> >>> -			set_bit(lr, elrsr_ptr);
> >>> -		}
> >>> +		if (vgic_sync_hwirq(vcpu, lr, vlr))
> >>> +			level_pending = true;
> >>>  
> >>>  		if (!test_bit(lr, elrsr_ptr))
> >>>  			continue;
> >>> @@ -1861,30 +1860,6 @@ static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
> >>>  }
> >>>  
> >>>  /**
> >>> - * kvm_vgic_get_phys_irq_active - Return the active state of a mapped IRQ
> >>> - *
> >>> - * Return the logical active state of a mapped interrupt. This doesn't
> >>> - * necessarily reflects the current HW state.
> >>> - */
> >>> -bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map)
> >>> -{
> >>> -	BUG_ON(!map);
> >>> -	return map->active;
> >>> -}
> >>> -
> >>> -/**
> >>> - * kvm_vgic_set_phys_irq_active - Set the active state of a mapped IRQ
> >>> - *
> >>> - * Set the logical active state of a mapped interrupt. This doesn't
> >>> - * immediately affects the HW state.
> >>> - */
> >>> -void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active)
> >>> -{
> >>> -	BUG_ON(!map);
> >>> -	map->active = active;
> >>> -}
> >>> -
> >>> -/**
> >>>   * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
> >>>   * @vcpu: The VCPU pointer
> >>>   * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
> >>> @@ -2112,10 +2087,14 @@ int vgic_init(struct kvm *kvm)
> >>>  			if (i < VGIC_NR_SGIS)
> >>>  				vgic_bitmap_set_irq_val(&dist->irq_enabled,
> >>>  							vcpu->vcpu_id, i, 1);
> >>> -			if (i < VGIC_NR_PRIVATE_IRQS)
> >>> +			if (i < VGIC_NR_SGIS)
> >>>  				vgic_bitmap_set_irq_val(&dist->irq_cfg,
> >>>  							vcpu->vcpu_id, i,
> >>>  							VGIC_CFG_EDGE);
> >>> +			else if (i < VGIC_NR_PRIVATE_IRQS) /* PPIs */
> >>> +				vgic_bitmap_set_irq_val(&dist->irq_cfg,
> >>> +							vcpu->vcpu_id, i,
> >>> +							VGIC_CFG_LEVEL);
> >>>  		}
> >>>  
> >>>  		vgic_enable(vcpu);
> >>>
> >>
> >> My only real objection to this patch is that it puts my brain upside down.
> >> Hopefully that won't last.
> >>
> > Yeah, I tried helping in the commit message, but I couldn't do much
> > beyond that. Splitting up the patch further didn't really work out for
> > me.
> 
> It is indeed quite intricated, and hard to really take apart. Guess
> we'll have to live with it.
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
