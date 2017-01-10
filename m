From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC 4/8] KVM: arm/arm64: Initialize the emulated EL1 physical
 timer
Date: Tue, 10 Jan 2017 20:34:40 +0100
Message-ID: <20170110193440.GN4348@cbox>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
 <1482772326-29110-5-git-send-email-jintack@cs.columbia.edu>
 <20170109120235.GD4348@cbox>
 <CAHyh4xgq_me42Jv+=6P=NhcyxpjJ4R6zgWGY2HibEc6e09Af2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5074C40295
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:33:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZnF+DhV-Rmwf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jan 2017 14:33:00 -0500 (EST)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 581A340284
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 14:32:59 -0500 (EST)
Received: by mail-lf0-f42.google.com with SMTP id k86so122580488lfi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jan 2017 11:34:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAHyh4xgq_me42Jv+=6P=NhcyxpjJ4R6zgWGY2HibEc6e09Af2g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 10, 2017 at 12:03:00PM -0500, Jintack Lim wrote:
> On Mon, Jan 9, 2017 at 7:02 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Mon, Dec 26, 2016 at 12:12:02PM -0500, Jintack Lim wrote:
> >> Initialize the emulated EL1 physical timer with the default irq number.
> >>
> >> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> >> ---
> >>  arch/arm/kvm/reset.c         |  9 ++++++++-
> >>  arch/arm64/kvm/reset.c       |  9 ++++++++-
> >>  include/kvm/arm_arch_timer.h |  3 ++-
> >>  virt/kvm/arm/arch_timer.c    | 12 ++++++++++--
> >>  4 files changed, 28 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
> >> index 4b5e802..1da8b2d 100644
> >> --- a/arch/arm/kvm/reset.c
> >> +++ b/arch/arm/kvm/reset.c
> >> @@ -37,6 +37,11 @@
> >>       .usr_regs.ARM_cpsr = SVC_MODE | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
> >>  };
> >>
> >> +static const struct kvm_irq_level cortexa_ptimer_irq = {
> >> +     { .irq = 30 },
> >> +     .level = 1,
> >> +};
> >> +
> >>  static const struct kvm_irq_level cortexa_vtimer_irq = {
> >>       { .irq = 27 },
> >>       .level = 1,
> >> @@ -58,6 +63,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>  {
> >>       struct kvm_regs *reset_regs;
> >>       const struct kvm_irq_level *cpu_vtimer_irq;
> >> +     const struct kvm_irq_level *cpu_ptimer_irq;
> >>
> >>       switch (vcpu->arch.target) {
> >>       case KVM_ARM_TARGET_CORTEX_A7:
> >> @@ -65,6 +71,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>               reset_regs = &cortexa_regs_reset;
> >>               vcpu->arch.midr = read_cpuid_id();
> >>               cpu_vtimer_irq = &cortexa_vtimer_irq;
> >> +             cpu_ptimer_irq = &cortexa_ptimer_irq;
> >>               break;
> >>       default:
> >>               return -ENODEV;
> >> @@ -77,5 +84,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>       kvm_reset_coprocs(vcpu);
> >>
> >>       /* Reset arch_timer context */
> >> -     return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> >> +     return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
> >>  }
> >> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> >> index 5bc4608..74322c2 100644
> >> --- a/arch/arm64/kvm/reset.c
> >> +++ b/arch/arm64/kvm/reset.c
> >> @@ -46,6 +46,11 @@
> >>                       COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
> >>  };
> >>
> >> +static const struct kvm_irq_level default_ptimer_irq = {
> >> +     .irq    = 30,
> >> +     .level  = 1,
> >> +};
> >> +
> >>  static const struct kvm_irq_level default_vtimer_irq = {
> >>       .irq    = 27,
> >>       .level  = 1,
> >> @@ -110,6 +115,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
> >>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>  {
> >>       const struct kvm_irq_level *cpu_vtimer_irq;
> >> +     const struct kvm_irq_level *cpu_ptimer_irq;
> >>       const struct kvm_regs *cpu_reset;
> >>
> >>       switch (vcpu->arch.target) {
> >> @@ -123,6 +129,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>               }
> >>
> >>               cpu_vtimer_irq = &default_vtimer_irq;
> >> +             cpu_ptimer_irq = &default_ptimer_irq;
> >>               break;
> >>       }
> >>
> >> @@ -136,5 +143,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >>       kvm_pmu_vcpu_reset(vcpu);
> >>
> >>       /* Reset timer */
> >> -     return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
> >> +     return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
> >>  }
> >> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> >> index d21652a..04ed9c1 100644
> >> --- a/include/kvm/arm_arch_timer.h
> >> +++ b/include/kvm/arm_arch_timer.h
> >> @@ -61,7 +61,8 @@ struct arch_timer_cpu {
> >>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
> >>  void kvm_timer_init(struct kvm *kvm);
> >>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >> -                      const struct kvm_irq_level *irq);
> >> +                      const struct kvm_irq_level *virt_irq,
> >> +                      const struct kvm_irq_level *phys_irq);
> >>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> >>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
> >>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 3bd6063..ed80864 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -339,9 +339,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
> >>  }
> >>
> >>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >> -                      const struct kvm_irq_level *irq)
> >> +                      const struct kvm_irq_level *virt_irq,
> >> +                      const struct kvm_irq_level *phys_irq)
> >>  {
> >>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> >> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >>
> >>       /*
> >>        * The vcpu timer irq number cannot be determined in
> >> @@ -349,7 +351,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>        * kvm_vcpu_set_target(). To handle this, we determine
> >>        * vcpu timer irq number when the vcpu is reset.
> >>        */
> >> -     vtimer->irq.irq = irq->irq;
> >> +     vtimer->irq.irq = virt_irq->irq;
> >> +     ptimer->irq.irq = phys_irq->irq;
> >>
> >>       /*
> >>        * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
> >> @@ -358,6 +361,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>        * the ARMv7 architecture.
> >>        */
> >>       vtimer->cnt_ctl = 0;
> >> +     ptimer->cnt_ctl = 0;
> >>       kvm_timer_update_state(vcpu);
> >>
> >>       return 0;
> >> @@ -477,11 +481,15 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
> >>  int kvm_timer_enable(struct kvm_vcpu *vcpu)
> >>  {
> >>       struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> >> +     struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> >>       struct irq_desc *desc;
> >>       struct irq_data *data;
> >>       int phys_irq;
> >>       int ret;
> >>
> >> +     /* Always enable emulated the EL1 physical timer */
> >
> > Dubious comment the way it stands.
> >
> > Does the rest of the code really support one timer being enabled while
> > another one not so?
> 
> No. The code never check if the physical timer is enabled. I think
> it's not necessary to set enable bit for this emulated physical timer.
> We, however, may need to set/check this enable bit later if we decide
> to give the EL1 physical timer to the guest instead of emulating it.
> 

It hink the semantics of the enable bit before your patches is more "is
the arch timer code at all enabled and working", so maybe you want to
preserve that and move the enabled bit out of the per-timer and per-vcpu
state?

Thanks,
-Christoffer
