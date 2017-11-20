From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH v4 14/20] KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit
Date: Mon, 20 Nov 2017 11:32:28 -0500
Message-ID: <CAHyh4xiOO3uq+SJ8cP_5ezv3q_bd9L_dXsyidoq7cMy5RyZZrA@mail.gmail.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
 <20171020114939.12554-15-christoffer.dall@linaro.org> <CAHyh4xhxCcZ3EKLCkZhhzvbj753J5gTRutM6wA4rkuDDxmn_FA@mail.gmail.com>
 <20171120111540.GE28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120111540.GE28855@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, KVM General <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 20, 2017 at 6:15 AM, Christoffer Dall <cdall@linaro.org> wrote:
> On Thu, Nov 16, 2017 at 03:30:39PM -0500, Jintack Lim wrote:
>> Hi Christoffer,
>>
>> On Fri, Oct 20, 2017 at 7:49 AM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>> > From: Christoffer Dall <cdall@linaro.org>
>> >
>> > We don't need to save and restore the hardware timer state and examine
>> > if it generates interrupts on on every entry/exit to the guest.  The
>> > timer hardware is perfectly capable of telling us when it has expired
>> > by signaling interrupts.
>> >
>> > When taking a vtimer interrupt in the host, we don't want to mess with
>> > the timer configuration, we just want to forward the physical interrupt
>> > to the guest as a virtual interrupt.  We can use the split priority drop
>> > and deactivate feature of the GIC to do this, which leaves an EOI'ed
>> > interrupt active on the physical distributor, making sure we don't keep
>> > taking timer interrupts which would prevent the guest from running.  We
>> > can then forward the physical interrupt to the VM using the HW bit in
>> > the LR of the GIC, like we do already, which lets the guest directly
>> > deactivate both the physical and virtual timer simultaneously, allowing
>> > the timer hardware to exit the VM and generate a new physical interrupt
>> > when the timer output is again asserted later on.
>> >
>> > We do need to capture this state when migrating VCPUs between physical
>> > CPUs, however, which we use the vcpu put/load functions for, which are
>> > called through preempt notifiers whenever the thread is scheduled away
>> > from the CPU or called directly if we return from the ioctl to
>> > userspace.
>> >
>> > One caveat is that we have to save and restore the timer state in both
>> > kvm_timer_vcpu_[put/load] and kvm_timer_[schedule/unschedule], because
>> > we can have the following flows:
>> >
>> >   1. kvm_vcpu_block
>> >   2. kvm_timer_schedule
>> >   3. schedule
>> >   4. kvm_timer_vcpu_put (preempt notifier)
>> >   5. schedule (vcpu thread gets scheduled back)
>> >   6. kvm_timer_vcpu_load (preempt notifier)
>> >   7. kvm_timer_unschedule
>> >
>> > And a version where we don't actually call schedule:
>> >
>> >   1. kvm_vcpu_block
>> >   2. kvm_timer_schedule
>> >   7. kvm_timer_unschedule
>> >
>> > Since kvm_timer_[schedule/unschedule] may not be followed by put/load,
>> > but put/load also may be called independently, we call the timer
>> > save/restore functions from both paths.  Since they rely on the loaded
>> > flag to never save/restore when unnecessary, this doesn't cause any
>> > harm, and we ensure that all invokations of either set of functions work
>> > as intended.
>> >
>> > An added benefit beyond not having to read and write the timer sysregs
>> > on every entry and exit is that we no longer have to actively write the
>> > active state to the physical distributor, because we configured the
>> > irq for the vtimer to only get a priority drop when handling the
>> > interrupt in the GIC driver (we called irq_set_vcpu_affinity()), and
>> > the interrupt stays active after firing on the host.
>> >
>> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
>> > ---
>> >
>> > Notes:
>> >     Changes since v3:
>> >      - Added comments explaining the 'loaded' flag and made other clarifying
>> >        comments.
>> >      - No longer rely on the armed flag to conditionally save/restore state,
>> >        as we already rely on the 'loaded' flag to not repetitively
>> >        save/restore state.
>> >      - Reworded parts of the commit message.
>> >      - Removed renames not belonging to this patch.
>> >      - Added warning in kvm_arch_timer_handler in case we see spurious
>> >        interrupts, for example if the hardware doesn't retire the
>> >        level-triggered timer signal fast enough.
>> >
>> >  include/kvm/arm_arch_timer.h |  16 ++-
>> >  virt/kvm/arm/arch_timer.c    | 237 +++++++++++++++++++++++++++----------------
>> >  virt/kvm/arm/arm.c           |  19 +++-
>> >  3 files changed, 178 insertions(+), 94 deletions(-)
>> >
>> > diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>> > index 184c3ef2df93..c538f707e1c1 100644
>> > --- a/include/kvm/arm_arch_timer.h
>> > +++ b/include/kvm/arm_arch_timer.h
>> > @@ -31,8 +31,15 @@ struct arch_timer_context {
>> >         /* Timer IRQ */
>> >         struct kvm_irq_level            irq;
>> >
>> > -       /* Active IRQ state caching */
>> > -       bool                            active_cleared_last;
>> > +       /*
>> > +        * We have multiple paths which can save/restore the timer state
>> > +        * onto the hardware, so we need some way of keeping track of
>> > +        * where the latest state is.
>> > +        *
>> > +        * loaded == true:  State is loaded on the hardware registers.
>> > +        * loaded == false: State is stored in memory.
>> > +        */
>> > +       bool                    loaded;
>> >
>> >         /* Virtual offset */
>> >         u64                     cntvoff;
>> > @@ -78,10 +85,15 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>> >
>> >  u64 kvm_phys_timer_read(void);
>> >
>> > +void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
>> >  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>> >
>> >  void kvm_timer_init_vhe(void);
>> >
>> >  #define vcpu_vtimer(v) (&(v)->arch.timer_cpu.vtimer)
>> >  #define vcpu_ptimer(v) (&(v)->arch.timer_cpu.ptimer)
>> > +
>> > +void enable_el1_phys_timer_access(void);
>> > +void disable_el1_phys_timer_access(void);
>> > +
>> >  #endif
>> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> > index eac1b3d83a86..ec685c1f3b78 100644
>> > --- a/virt/kvm/arm/arch_timer.c
>> > +++ b/virt/kvm/arm/arch_timer.c
>> > @@ -46,10 +46,9 @@ static const struct kvm_irq_level default_vtimer_irq = {
>> >         .level  = 1,
>> >  };
>> >
>> > -void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>> > -{
>> > -       vcpu_vtimer(vcpu)->active_cleared_last = false;
>> > -}
>> > +static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
>> > +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>> > +                                struct arch_timer_context *timer_ctx);
>> >
>> >  u64 kvm_phys_timer_read(void)
>> >  {
>> > @@ -69,17 +68,45 @@ static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
>> >                 cancel_work_sync(work);
>> >  }
>> >
>> > -static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>> > +static void kvm_vtimer_update_mask_user(struct kvm_vcpu *vcpu)
>> >  {
>> > -       struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
>> > +       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> >
>> >         /*
>> > -        * We disable the timer in the world switch and let it be
>> > -        * handled by kvm_timer_sync_hwstate(). Getting a timer
>> > -        * interrupt at this point is a sure sign of some major
>> > -        * breakage.
>> > +        * When using a userspace irqchip with the architected timers, we must
>> > +        * prevent continuously exiting from the guest, and therefore mask the
>> > +        * physical interrupt by disabling it on the host interrupt controller
>> > +        * when the virtual level is high, such that the guest can make
>> > +        * forward progress.  Once we detect the output level being
>> > +        * de-asserted, we unmask the interrupt again so that we exit from the
>> > +        * guest when the timer fires.
>> >          */
>> > -       pr_warn("Unexpected interrupt %d on vcpu %p\n", irq, vcpu);
>> > +       if (vtimer->irq.level)
>> > +               disable_percpu_irq(host_vtimer_irq);
>> > +       else
>> > +               enable_percpu_irq(host_vtimer_irq, 0);
>> > +}
>> > +
>> > +static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
>> > +{
>> > +       struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
>> > +       struct arch_timer_context *vtimer;
>> > +
>> > +       if (!vcpu) {
>> > +               pr_warn_once("Spurious arch timer IRQ on non-VCPU thread\n");
>> > +               return IRQ_NONE;
>> > +       }
>> > +       vtimer = vcpu_vtimer(vcpu);
>> > +
>> > +       if (!vtimer->irq.level) {
>> > +               vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>> > +               if (kvm_timer_irq_can_fire(vtimer))
>> > +                       kvm_timer_update_irq(vcpu, true, vtimer);
>> > +       }
>> > +
>> > +       if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>> > +               kvm_vtimer_update_mask_user(vcpu);
>> > +
>> >         return IRQ_HANDLED;
>> >  }
>> >
>> > @@ -215,7 +242,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>> >  {
>> >         int ret;
>> >
>> > -       timer_ctx->active_cleared_last = false;
>> >         timer_ctx->irq.level = new_level;
>> >         trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
>> >                                    timer_ctx->irq.level);
>> > @@ -271,10 +297,16 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu,
>> >         soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
>> >  }
>> >
>> > -static void timer_save_state(struct kvm_vcpu *vcpu)
>> > +static void vtimer_save_state(struct kvm_vcpu *vcpu)
>> >  {
>> >         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> >         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> > +       unsigned long flags;
>> > +
>> > +       local_irq_save(flags);
>> > +
>> > +       if (!vtimer->loaded)
>> > +               goto out;
>> >
>> >         if (timer->enabled) {
>> >                 vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>> > @@ -283,6 +315,10 @@ static void timer_save_state(struct kvm_vcpu *vcpu)
>> >
>> >         /* Disable the virtual timer */
>> >         write_sysreg_el0(0, cntv_ctl);
>> > +
>> > +       vtimer->loaded = false;
>> > +out:
>> > +       local_irq_restore(flags);
>> >  }
>> >
>> >  /*
>> > @@ -296,6 +332,8 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>> >         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> >         struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> >
>> > +       vtimer_save_state(vcpu);
>> > +
>> >         /*
>> >          * No need to schedule a background timer if any guest timer has
>> >          * already expired, because kvm_vcpu_block will return before putting
>> > @@ -318,22 +356,34 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>> >         soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
>> >  }
>> >
>> > -static void timer_restore_state(struct kvm_vcpu *vcpu)
>> > +static void vtimer_restore_state(struct kvm_vcpu *vcpu)
>> >  {
>> >         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> >         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> > +       unsigned long flags;
>> > +
>> > +       local_irq_save(flags);
>> > +
>> > +       if (vtimer->loaded)
>> > +               goto out;
>> >
>> >         if (timer->enabled) {
>> >                 write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
>> >                 isb();
>> >                 write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
>> >         }
>> > +
>> > +       vtimer->loaded = true;
>> > +out:
>> > +       local_irq_restore(flags);
>> >  }
>> >
>> >  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>> >  {
>> >         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> >
>> > +       vtimer_restore_state(vcpu);
>> > +
>> >         soft_timer_cancel(&timer->bg_timer, &timer->expired);
>> >  }
>> >
>> > @@ -352,61 +402,45 @@ static void set_cntvoff(u64 cntvoff)
>> >         kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
>> >  }
>> >
>> > -static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
>> > +static void kvm_timer_vcpu_load_vgic(struct kvm_vcpu *vcpu)
>> >  {
>> >         struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> >         bool phys_active;
>> >         int ret;
>> >
>> > -       /*
>> > -       * If we enter the guest with the virtual input level to the VGIC
>> > -       * asserted, then we have already told the VGIC what we need to, and
>> > -       * we don't need to exit from the guest until the guest deactivates
>> > -       * the already injected interrupt, so therefore we should set the
>> > -       * hardware active state to prevent unnecessary exits from the guest.
>> > -       *
>> > -       * Also, if we enter the guest with the virtual timer interrupt active,
>> > -       * then it must be active on the physical distributor, because we set
>> > -       * the HW bit and the guest must be able to deactivate the virtual and
>> > -       * physical interrupt at the same time.
>> > -       *
>> > -       * Conversely, if the virtual input level is deasserted and the virtual
>> > -       * interrupt is not active, then always clear the hardware active state
>> > -       * to ensure that hardware interrupts from the timer triggers a guest
>> > -       * exit.
>> > -       */
>> >         phys_active = vtimer->irq.level ||
>> > -                       kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
>> > -
>> > -       /*
>> > -        * We want to avoid hitting the (re)distributor as much as
>> > -        * possible, as this is a potentially expensive MMIO access
>> > -        * (not to mention locks in the irq layer), and a solution for
>> > -        * this is to cache the "active" state in memory.
>> > -        *
>> > -        * Things to consider: we cannot cache an "active set" state,
>> > -        * because the HW can change this behind our back (it becomes
>> > -        * "clear" in the HW). We must then restrict the caching to
>> > -        * the "clear" state.
>> > -        *
>> > -        * The cache is invalidated on:
>> > -        * - vcpu put, indicating that the HW cannot be trusted to be
>> > -        *   in a sane state on the next vcpu load,
>> > -        * - any change in the interrupt state
>> > -        *
>> > -        * Usage conditions:
>> > -        * - cached value is "active clear"
>> > -        * - value to be programmed is "active clear"
>> > -        */
>> > -       if (vtimer->active_cleared_last && !phys_active)
>> > -               return;
>> > +                     kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
>> >
>> >         ret = irq_set_irqchip_state(host_vtimer_irq,
>> >                                     IRQCHIP_STATE_ACTIVE,
>> >                                     phys_active);
>> >         WARN_ON(ret);
>> > +}
>> >
>> > -       vtimer->active_cleared_last = !phys_active;
>> > +static void kvm_timer_vcpu_load_user(struct kvm_vcpu *vcpu)
>> > +{
>> > +       kvm_vtimer_update_mask_user(vcpu);
>> > +}
>> > +
>> > +void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>> > +{
>> > +       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> > +       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> > +
>> > +       if (unlikely(!timer->enabled))
>> > +               return;
>> > +
>> > +       if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>> > +               kvm_timer_vcpu_load_user(vcpu);
>> > +       else
>> > +               kvm_timer_vcpu_load_vgic(vcpu);
>> > +
>> > +       set_cntvoff(vtimer->cntvoff);
>> > +
>> > +       vtimer_restore_state(vcpu);
>> > +
>> > +       if (has_vhe())
>> > +               disable_el1_phys_timer_access();
>>
>> Same question here :)
>>
>
> Same answer as below.
>
>> >  }
>> >
>> >  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
>> > @@ -426,23 +460,6 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
>> >                ptimer->irq.level != plevel;
>> >  }
>> >
>> > -static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
>> > -{
>> > -       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> > -
>> > -       /*
>> > -        * To prevent continuously exiting from the guest, we mask the
>> > -        * physical interrupt such that the guest can make forward progress.
>> > -        * Once we detect the output level being deasserted, we unmask the
>> > -        * interrupt again so that we exit from the guest when the timer
>> > -        * fires.
>> > -       */
>> > -       if (vtimer->irq.level)
>> > -               disable_percpu_irq(host_vtimer_irq);
>> > -       else
>> > -               enable_percpu_irq(host_vtimer_irq, 0);
>> > -}
>> > -
>> >  /**
>> >   * kvm_timer_flush_hwstate - prepare timers before running the vcpu
>> >   * @vcpu: The vcpu pointer
>> > @@ -455,23 +472,61 @@ static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
>> >  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>> >  {
>> >         struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> > -       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> > +       struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>> >
>> >         if (unlikely(!timer->enabled))
>> >                 return;
>> >
>> > -       kvm_timer_update_state(vcpu);
>> > +       if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
>> > +               kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
>> >
>> >         /* Set the background timer for the physical timer emulation. */
>> >         phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
>> > +}
>> >
>> > -       if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
>> > -               kvm_timer_flush_hwstate_user(vcpu);
>> > -       else
>> > -               kvm_timer_flush_hwstate_vgic(vcpu);
>> > +void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>> > +{
>> > +       struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> >
>> > -       set_cntvoff(vtimer->cntvoff);
>> > -       timer_restore_state(vcpu);
>> > +       if (unlikely(!timer->enabled))
>> > +               return;
>> > +
>> > +       if (has_vhe())
>> > +               enable_el1_phys_timer_access();
>>
>> I wonder why we need to enable the EL1 physical timer access on VHE
>> systems (assuming TGE bit is set at this point)? EL2 can access it
>> regardless of EL1PTEN bit status, and EL0 access is controlled by
>> EL0PTEN.
>
> Yeah, my code is bogus, you already addressed that.  I think I wrote the
> first version of these patches prior to you fixing the physical timer
> trap configuration for VHE systems.
>
>>
>> In any case, since cnthcntl_el2 format is changed when E2H == 1, don't
>> we need to consider this in enable_el1_phys_timer_access() function
>> implementation?
>>
>
> You are indeed right.  Nice catch!

Thanks for the confirmation!

>
> Fix incoming.
>
> -Christoffer
>
