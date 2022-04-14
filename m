Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90301C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 05:26:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04FF34B1C3;
	Thu, 14 Apr 2022 01:26:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PHlrOh+HlMjf; Thu, 14 Apr 2022 01:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92CFF4B19F;
	Thu, 14 Apr 2022 01:26:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF814B192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:26:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thlXGusURtdv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2022 01:26:41 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 570584B17D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 01:26:41 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id j8so3761114pll.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 22:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9vlVfiZwBDOMVXXKsnbrHV4I5oPCCbywG7emutHTWMM=;
 b=NsVykSlKA6aI9WsiY3gwIh6IyEFpsmT2szT/8roufHu7rJr+BH8zU73QShRKr7c7OL
 Dnj8x7YdEl2SXfqQfyCBUiupVqC3LzuMhtubLFUzOMz/Cc4/8G+qmAVx53jszf46VUlo
 49o8jvOZpxsMPyEc13OQLreXW2DUgHqxecPKWKZ2/6+ncpZ1GL853bKH49TWBBYgK/p6
 W8vNEYlHmGXCDb1CMsfWvJHOyirCIaZ+oLiKEBhEb5PtVt6O5yicc/JSMGlU5ovQyjf7
 LmanSRP0TL1jqWdyYVZ+Yc2NDWLqSSxdKnha6UBDKgZllbnwPzmaIo2lgn7lMlmbsdRH
 UJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9vlVfiZwBDOMVXXKsnbrHV4I5oPCCbywG7emutHTWMM=;
 b=nS+0yBBz/ag7qEqS/IkxymJCM3WSBo2uYV1Bowt+hDTLwxQ9Z5u0quwxBFgyBufUrL
 QwdCIBx17hu9rykWX6ZAnnsjtK+M05EVSLEA9EdgBC3894OADe3W2r4fRf/vEtNnJRcC
 IaYjJz5ThY6vGCGthYZgdPzSbq9xxIU6KuXViiIoS2anCae2oc+JuUlhd6KMrYGVQJ+5
 SAFy0bohFVx7ar5pKTzrFkJ8AjpwB7+hXFW+7KUT0h4AC6r9b509JPv7sFGmFIoCHQMX
 1JuJyXzFolrjKBSlg6nCvaxs/8ngSGNI462ymnvK1i0xtvY0K65BjtZrskqNhC60pL7j
 7nJg==
X-Gm-Message-State: AOAM531skpvneUDYcXNlJrGERgzAXCaIRDsergfxsNVSHkcptrVCCK9v
 R6mqNJmPjflra+5bzVsPxYHyMEM1e3BdyMsNnU55HQ==
X-Google-Smtp-Source: ABdhPJxYbLAZL6pUd8Y1Ic11i0hZvS30omWAysWY4sRB1WveSfEDXUbbVNyRCwKWiaodAl+cwsee2mDNaQfeVQcsy0g=
X-Received: by 2002:a17:902:c215:b0:153:8d90:a108 with SMTP id
 21-20020a170902c21500b001538d90a108mr46002363pll.172.1649914000259; Wed, 13
 Apr 2022 22:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-4-oupton@google.com>
In-Reply-To: <20220409184549.1681189-4-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Apr 2022 22:26:24 -0700
Message-ID: <CAAeT=FxQ5qBMrYZpGbDT7i+bGFCyfoV32ddKeeprj7mEemnbEA@mail.gmail.com>
Subject: Re: [PATCH v5 03/13] KVM: arm64: Track vCPU power state using MP
 state values
To: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will add support for additional power states.
> Store the MP state by value rather than keeping track of it as a
> boolean.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++--
>  arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
>  arch/arm64/kvm/psci.c             | 12 ++++++------
>  3 files changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 490cd7f3a905..f3f93d48e21a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -365,8 +365,8 @@ struct kvm_vcpu_arch {
>                 u32     mdscr_el1;
>         } guest_debug_preserved;
>
> -       /* vcpu power-off state */
> -       bool power_off;
> +       /* vcpu power state */
> +       struct kvm_mp_state mp_state;
>
>         /* Don't run the guest (internal implementation need) */
>         bool pause;
> @@ -842,5 +842,6 @@ static inline void kvm_hyp_reserve(void) { }
>  #endif
>
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> +bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 28c83c6ddbae..29e107457c4d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -434,18 +434,20 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.power_off = true;
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         kvm_vcpu_kick(vcpu);
>  }
>
> +bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> -       if (vcpu->arch.power_off)
> -               mp_state->mp_state = KVM_MP_STATE_STOPPED;
> -       else
> -               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> +       *mp_state = vcpu->arch.mp_state;
>
>         return 0;
>  }
> @@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>
>         switch (mp_state->mp_state) {
>         case KVM_MP_STATE_RUNNABLE:
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state = *mp_state;

Nit: It might be a bit odd that KVM_MP_STATE_STOPPED case only copies
the 'mp_state' field of kvm_mp_state from userspace (that's not a 'copy'
operation though), while KVM_MP_STATE_RUNNABLE case copies entire
kvm_mp_state from user space.
('mp_state' is the only field of kvm_mp_state though)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji

>                 break;
>         case KVM_MP_STATE_STOPPED:
>                 kvm_arm_vcpu_power_off(vcpu);
> @@ -480,7 +482,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>         bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
>         return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -               && !v->arch.power_off && !v->arch.pause);
> +               && !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
>  }
>
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> @@ -597,10 +599,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>
>         rcuwait_wait_event(wait,
> -                          (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
> +                          (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
>                            TASK_INTERRUPTIBLE);
>
> -       if (vcpu->arch.power_off || vcpu->arch.pause) {
> +       if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
>                 /* Awaken to handle a signal, request we sleep again later. */
>                 kvm_make_request(KVM_REQ_SLEEP, vcpu);
>         }
> @@ -1126,7 +1128,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>         if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
>                 kvm_arm_vcpu_power_off(vcpu);
>         else
> -               vcpu->arch.power_off = false;
> +               vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index cdc0609c1135..f2f45a3cbe86 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -76,7 +76,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>          */
>         if (!vcpu)
>                 return PSCI_RET_INVALID_PARAMS;
> -       if (!vcpu->arch.power_off) {
> +       if (!kvm_arm_vcpu_stopped(vcpu)) {
>                 if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>                         return PSCI_RET_ALREADY_ON;
>                 else
> @@ -100,12 +100,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>         kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
>
>         /*
> -        * Make sure the reset request is observed if the change to
> -        * power_off is observed.
> +        * Make sure the reset request is observed if the RUNNABLE mp_state is
> +        * observed.
>          */
>         smp_wmb();
>
> -       vcpu->arch.power_off = false;
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
>         kvm_vcpu_wake_up(vcpu);
>
>         return PSCI_RET_SUCCESS;
> @@ -143,7 +143,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>                 mpidr = kvm_vcpu_get_mpidr_aff(tmp);
>                 if ((mpidr & target_affinity_mask) == target_affinity) {
>                         matching_cpus++;
> -                       if (!tmp->arch.power_off)
> +                       if (!kvm_arm_vcpu_stopped(tmp))
>                                 return PSCI_0_2_AFFINITY_LEVEL_ON;
>                 }
>         }
> @@ -169,7 +169,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
>          * re-initialized.
>          */
>         kvm_for_each_vcpu(i, tmp, vcpu->kvm)
> -               tmp->arch.power_off = true;
> +               tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
>         memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> --
> 2.35.1.1178.g4f1659d476-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
