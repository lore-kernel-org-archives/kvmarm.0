Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9367C48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A7EA611BD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A7EA611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD214A3A3;
	Wed,  9 Jun 2021 06:22:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cqns5xIePwUT; Wed,  9 Jun 2021 06:22:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B31B64A524;
	Wed,  9 Jun 2021 06:21:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022DE406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:59:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QLbW2BkdEhv2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:59:08 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D4104066E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:59:08 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id o8so29057513ljp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4ZFSAFUoZhRjqmcFD1X1AF3Fs3bEfXF1+VtTxZPdYN4=;
 b=LRuc+x3duDo1MSzlf0phtIM80YhY4IBNDC1DzyBLF7rqK1jKodyzRlLlTPkulLdeyT
 R1ujGzq6TZBEzDZj7EMP8hz78Qn3Doarg1GlGhcSDk4qk4HAr9amEN1qGUWYMEcmBlZS
 5XktSkjCHlZp8ysYCRaix3DF2PKeG0X3WANtHL0NJXF8IRwwKGpJwJLD2gbayAxjtqjp
 0wkeDf5sxTc6dzMwsrHqYnPLw49fkiJIk08+qU6zgb9Bp5sLderb+SW+ZPyHLOrE1zfF
 7Jc6ZC3UjHRIfZGJ72w9Ta2LAsl1qKbQI0jl54Po/oIpjNWDZ8E28Q15iE8d0kZPkcsQ
 uF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4ZFSAFUoZhRjqmcFD1X1AF3Fs3bEfXF1+VtTxZPdYN4=;
 b=N/8nyMhsbeY/6jvm+5HHazUu58HznOGUQJnUZBECKd2DvH2KbcbQaQ1bHdZK52GA5x
 gd6TMtIv/OB0ZZmWWTO2fuqMyMwh0uZKqWC9HtoE2F5HnhGsA/H20glgEgULaXi2JSb+
 lTZjo0+FmI1qkuxpkxuC0ReKwZmP/XPdw9TQ9jMCSVnRvl8gYgV02DNAyi/BbPKcyKLG
 nSXDbe+MImSfC4bismznoq/EcVCkU2g+rf/OixZH6Qj3W7s5EU6e+jJ6CD8VppyxjQR2
 nVU4gEA0v5OvoCQufTu3KHazMEgiBGvnbE8Z6Zemi53S5bCu7k2B3jQD5uxDit+GK52B
 VilQ==
X-Gm-Message-State: AOAM5335wkry+htSBrtBN8E8IAmrFEktLOuRwBJwyVvG3+/WhsQHDxeL
 aJP6XH0uwKWEAbcS4gyzQn7oghWTv9LtPLYwM7Jw8Q==
X-Google-Smtp-Source: ABdhPJwq6HY3eatbSUSnOMj0+yapEs130c7m1vNBcOWvVOh2Jo2SyJ6OjBBFtcm8q5oc35OwbWFNUPWOajp2MPykQXA=
X-Received: by 2002:a05:651c:304:: with SMTP id
 a4mr19888649ljp.331.1623189546629; 
 Tue, 08 Jun 2021 14:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
 <20210608214742.1897483-5-oupton@google.com>
In-Reply-To: <20210608214742.1897483-5-oupton@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 8 Jun 2021 16:58:55 -0500
Message-ID: <CAOQ_QsiEwERCbFp3La1ZFtfR=O2-tArCkgPKmbmdDWx3x0rT5A@mail.gmail.com>
Subject: Re: [PATCH 04/10] KVM: arm64: Add userspace control of the guest's
 physical counter
To: kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 09 Jun 2021 06:21:47 -0400
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jun 8, 2021 at 4:48 PM Oliver Upton <oupton@google.com> wrote:
>
> ARMv8.6 adds an extension to the architecture providing hypervisors with
> more extensive controls of the guest's counters. A particularly
> interesting control is CNTPOFF_EL2, a fixed offset subtracted from the
> physical counter value to derive the guest's value. VMMs that live
> migrate their guests may be particularly interested in this feature in
> order to provide a consistent view of the physical counter across live
> migrations.
>
> In the interim, KVM can emulate this behavior by simply enabling traps
> on CNTPCT_EL0 and subtracting an offset.
>
> Add a new field to kvm_system_counter_state allowing a VMM to request an
> offset to the physical counter. If this offset is nonzero, enable traps
> on CNTPCT_EL0. Emulate guest reads to the register in the fast path to
> keep counter reads reasonably performant, avoiding a full exit from the
> guest.
>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/include/asm/sysreg.h         |  1 +
>  arch/arm64/include/uapi/asm/kvm.h       |  9 +++-
>  arch/arm64/kvm/arch_timer.c             | 66 +++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 31 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 16 ++++--
>  6 files changed, 117 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 31107d5e61af..a3abafcea328 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -200,6 +200,7 @@ enum vcpu_sysreg {
>         SP_EL1,
>         SPSR_EL1,
>
> +       CNTPOFF_EL2,
>         CNTVOFF_EL2,
>         CNTV_CVAL_EL0,
>         CNTV_CTL_EL0,
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 65d15700a168..193da426690a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -505,6 +505,7 @@
>  #define SYS_AMEVCNTR0_MEM_STALL                SYS_AMEVCNTR0_EL0(3)
>
>  #define SYS_CNTFRQ_EL0                 sys_reg(3, 3, 14, 0, 0)
> +#define SYS_CNTPCT_EL0                 sys_reg(3, 3, 14, 0, 1)
>
>  #define SYS_CNTP_TVAL_EL0              sys_reg(3, 3, 14, 2, 0)
>  #define SYS_CNTP_CTL_EL0               sys_reg(3, 3, 14, 2, 1)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index d3987089c524..ee709e2f0292 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,8 @@ struct kvm_vcpu_events {
>         __u32 reserved[12];
>  };
>
> +#define KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET   (1ul << 0)
> +
>  /* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
>  struct kvm_system_counter_state {
>         /* indicates what fields are valid in the structure */
> @@ -191,7 +193,12 @@ struct kvm_system_counter_state {
>         __u32 pad;
>         /* guest counter-timer offset, relative to host cntpct_el0 */
>         __u64 cntvoff;
> -       __u64 rsvd[7];
> +       /*
> +        * Guest physical counter-timer offset, relative to host cntpct_el0.
> +        * Valid when KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET is set.
> +        */
> +       __u64 cntpoff;
> +       __u64 rsvd[6];
>  };
>
>  /* If you need to interpret the index values, here is the key: */
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 955a7a183362..a74642d1515f 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -50,6 +50,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>                               struct arch_timer_context *timer,
>                               enum kvm_arch_timer_regs treg);
> +static bool kvm_timer_emulation_required(struct arch_timer_context *ctx);
>
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
> @@ -86,6 +87,8 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>         struct kvm_vcpu *vcpu = ctxt->vcpu;
>
>         switch(arch_timer_ctx_index(ctxt)) {
> +       case TIMER_PTIMER:
> +               return __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
>         case TIMER_VTIMER:
>                 return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>         default:
> @@ -130,6 +133,9 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>         struct kvm_vcpu *vcpu = ctxt->vcpu;
>
>         switch(arch_timer_ctx_index(ctxt)) {
> +       case TIMER_PTIMER:
> +               __vcpu_sys_reg(vcpu, CNTPOFF_EL2) = offset;
> +               break;
>         case TIMER_VTIMER:
>                 __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
>                 break;
> @@ -145,7 +151,7 @@ u64 kvm_phys_timer_read(void)
>
>  static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
>  {
> -       if (has_vhe()) {
> +       if (has_vhe() && !kvm_timer_emulation_required(vcpu_ptimer(vcpu))) {
>                 map->direct_vtimer = vcpu_vtimer(vcpu);
>                 map->direct_ptimer = vcpu_ptimer(vcpu);
>                 map->emul_ptimer = NULL;
> @@ -746,6 +752,30 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> +bool kvm_timer_emulation_required(struct arch_timer_context *ctx)
> +{
> +       int idx = arch_timer_ctx_index(ctx);
> +
> +       switch (idx) {
> +       /*
> +        * hardware doesn't support offsetting of the physical counter/timer.
> +        * If offsetting is requested, enable emulation of the physical
> +        * counter/timer.
> +        */
> +       case TIMER_PTIMER:
> +               return timer_get_offset(ctx);
> +       /*
> +        * Conversely, hardware does support offsetting of the virtual
> +        * counter/timer.
> +        */
> +       case TIMER_VTIMER:
> +               return false;
> +       default:
> +               WARN_ON(1);
> +               return false;
> +       }
> +}
> +
>  /* Make the updates of cntvoff for all vtimer contexts atomic */
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>  {
> @@ -1184,6 +1214,24 @@ void kvm_timer_init_vhe(void)
>         write_sysreg(val, cnthctl_el2);
>  }
>
> +static void kvm_timer_update_traps_vhe(struct kvm_vcpu *vcpu)
> +{
> +       u32 cnthctl_shift = 10;
> +       u64 val;
> +
> +       if (!kvm_timer_emulation_required(vcpu_ptimer(vcpu)))
> +               return;
> +
> +       /*
> +        * We must trap accesses to the physical counter/timer to emulate the
> +        * nonzero offset.
> +        */
> +       val = read_sysreg(cnthctl_el2);
> +       val &= ~(CNTHCTL_EL1PCEN << cnthctl_shift);
> +       val &= ~(CNTHCTL_EL1PCTEN << cnthctl_shift);
> +       write_sysreg(val, cnthctl_el2);
> +}
> +
>  static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
>  {
>         struct kvm_vcpu *vcpu;
> @@ -1260,24 +1308,36 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return -ENXIO;
>  }
>
> +#define KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS       \
> +               (KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +
>  int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
>                                           struct kvm_system_counter_state *state)
>  {
> -       if (state->flags)
> +       if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
>                 return -EINVAL;
>
>         state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
>
> +       if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +               state->cntpoff = timer_get_offset(vcpu_ptimer(vcpu));
> +
>         return 0;
>  }
>
>  int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
>                                           struct kvm_system_counter_state *state)
>  {
> -       if (state->flags)
> +       if (state->flags & ~KVM_SYSTEM_COUNTER_STATE_VALID_FLAG_BITS)
>                 return -EINVAL;
>
>         timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);
>
> +       if (state->flags & KVM_SYSTEM_COUNTER_STATE_PHYS_OFFSET)
> +               timer_set_offset(vcpu_ptimer(vcpu), state->cntpoff);
> +
> +       if (has_vhe())
> +               kvm_timer_update_traps_vhe(vcpu);
> +
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index e4a2f295a394..12ada31e12e2 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -287,6 +287,30 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
>         return true;
>  }
>
> +static inline u64 __hyp_read_cntpct(struct kvm_vcpu *vcpu)
> +{
> +       return read_sysreg(cntpct_el0) - __vcpu_sys_reg(vcpu, CNTPOFF_EL2);

Question for those with much more experience on the ARM side: is there
any decent way to infer the counter bit-width to properly emulate
here? This code is problematic when migrating a narrower guest (i.e.
56-bit counter) to a wider host (say an 8.6 implementation with a
64-bit counter). Otherwise, it would seem that userspace needs to
explicitly request a counter width.

--
Thanks,
Oliver

> +}
> +
> +static inline bool __hyp_handle_counter(struct kvm_vcpu *vcpu)
> +{
> +       u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> +       int rt = kvm_vcpu_sys_get_rt(vcpu);
> +       u64 rv;
> +
> +       switch (sysreg) {
> +       case SYS_CNTPCT_EL0:
> +               rv = __hyp_read_cntpct(vcpu);
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       vcpu_set_reg(vcpu, rt, rv);
> +       __kvm_skip_instr(vcpu);
> +       return true;
> +}
> +
>  static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
>  {
>         u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
> @@ -439,6 +463,13 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>         if (*exit_code != ARM_EXCEPTION_TRAP)
>                 goto exit;
>
> +       /*
> +        * We trap acesses to the physical counter value register (CNTPCT_EL0)
> +        * if userspace has requested a physical counter offset.
> +        */
> +       if (__hyp_handle_counter(vcpu))
> +               goto guest;
> +
>         if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
>             kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
>             handle_tx2_tvm(vcpu))
> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> index 9072e71693ba..1b8e6e47a4ea 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -35,14 +35,24 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
>   */
>  void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -       u64 val;
> +       u64 val, cntpoff;
> +
> +       cntpoff = __vcpu_sys_reg(vcpu, CNTPOFF_EL2);
>
>         /*
>          * Disallow physical timer access for the guest
> -        * Physical counter access is allowed
>          */
>         val = read_sysreg(cnthctl_el2);
>         val &= ~CNTHCTL_EL1PCEN;
> -       val |= CNTHCTL_EL1PCTEN;
> +
> +       /*
> +        * Disallow physical counter access for the guest if offsetting is
> +        * requested.
> +        */
> +       if (cntpoff)
> +               val &= ~CNTHCTL_EL1PCTEN;
> +       else
> +               val |= CNTHCTL_EL1PCTEN;
> +
>         write_sysreg(val, cnthctl_el2);
>  }
> --
> 2.32.0.rc1.229.g3e70b5a671-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
