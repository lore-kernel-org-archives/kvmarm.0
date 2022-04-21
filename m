Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36BE8C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 03:12:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA114AC78;
	Wed, 20 Apr 2022 23:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1ayEsDsNdATd; Wed, 20 Apr 2022 23:12:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DCE74B19D;
	Wed, 20 Apr 2022 23:12:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35EE44AC78
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 23:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QzOzpYs6aIpc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 23:12:48 -0400 (EDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com
 [209.85.167.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3AF349F00
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 23:12:48 -0400 (EDT)
Received: by mail-oi1-f179.google.com with SMTP id r85so4271442oie.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 20:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ur8Rp6LR7EKn+oM0NaRNGPNLFVesLk5YgMH7cS6pmw4=;
 b=apVOq7YC7ZvtyDDlGTDKmTGqxgLxU2D/zy2h1mE03NJ+zZ7AcepgiUF3Qi+pEUnSQ7
 sBLAvxtf9UMFbJzso8YyO3Ba2qutdgRV3VL5sbCu6+vNF9wY/jFufATm5JbGk4c3WtvA
 G2oHOqO7+JJpYNfc7h+j005ZA2jJzGclHUoG4jX+LmLdhukRVJWPeoLbWpssIDcOSkH3
 dlWCgneF4eiAxNMOYGysoo3uKQ1kCvmVmQcxLgE4hRaJh3kveKKo4q28/UCHsnC2m8Kt
 CLbvyf/qX3/aSmYxlJ3glMCAi1kQiJQvHpC/+PeYYJbf+TDLpUtykedtSXliZDoV92JX
 9vYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ur8Rp6LR7EKn+oM0NaRNGPNLFVesLk5YgMH7cS6pmw4=;
 b=BZa5C9Vtempo4gjGNQz46mbFoOarlz+r040Jr9DlHHylLtfrw1AVOC5jbgNC26VZ3q
 D4Br8l2jKO22nrjddTxncFzYf7FEcXt12NR9Uc5nW5vvxSSFTJMUO4/2h+saqwFVOmR0
 HNpQMqyvXaN2UKF/ozMYnUcWiE9ux/Q3U8fenAKgj8QsELC2JwFXc/d1BhLtMswHaYVg
 r0Fvo8lAEXrXsdySmz01EF2Prj2Io8zVHVaCLMjCH1Qfa7RNW/5Z5aNGgb4p4ApKCZHN
 wNAN3DioX4xhVWbgP7HIlHQUtqSnSB7iP335o6RVaadf+a52atAz2+GWy6iqv63AVpWr
 cAmA==
X-Gm-Message-State: AOAM532/s5Umeb7daRENiO8W64r1kN4wIDtm2tHC61SzkjToIXeQf00d
 bxrbCm4a6/Atg18gr+D8GyIQdRaSuPA2THbBO40bFg==
X-Google-Smtp-Source: ABdhPJwqjrpCUVuMWs9RkIi8RK+6zSCTT/wXHa9OH991C5Ml8zVdGzE9HwMgdOJHCHvUJcb5/4Brw3IjvFP2KtpuBeo=
X-Received: by 2002:aca:b405:0:b0:322:ed83:59a1 with SMTP id
 d5-20020acab405000000b00322ed8359a1mr2321406oif.16.1650510767707; Wed, 20 Apr
 2022 20:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-8-oupton@google.com>
In-Reply-To: <20220409184549.1681189-8-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 20 Apr 2022 20:12:31 -0700
Message-ID: <CAAeT=FzURZmYfsLJnWMXufBiaZ6Wypan+xK4WxOSM=p=kEnYxA@mail.gmail.com>
Subject: Re: [PATCH v5 07/13] KVM: arm64: Add support for userspace to suspend
 a vCPU
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
> Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
> is in a suspended state. In the suspended state the vCPU will block
> until a wakeup event (pending interrupt) is recognized.
>
> Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
> userspace that KVM has recognized one such wakeup event. It is the
> responsibility of userspace to then make the vCPU runnable, or leave it
> suspended until the next wakeup event.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++--
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              | 49 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  4 files changed, 87 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d13fa6600467..d104e34ad703 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1476,14 +1476,43 @@ Possible values are:
>                                   [s390]
>     KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
>                                   [s390]
> +   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
> +                                 for a wakeup event [arm64]
>     ==========================    ===============================================
>
>  On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
>  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
>  these architectures.
>
> -For arm64/riscv:
> -^^^^^^^^^^^^^^^^
> +For arm64:
> +^^^^^^^^^^
> +
> +If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
> +architectural execution of a WFI instruction.
> +
> +If a wakeup event is recognized, KVM will exit to userspace with a
> +KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
> +userspace wants to honor the wakeup, it must set the vCPU's MP state to
> +KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
> +event in subsequent calls to KVM_RUN.
> +
> +.. warning::
> +
> +     If userspace intends to keep the vCPU in a SUSPENDED state, it is
> +     strongly recommended that userspace take action to suppress the
> +     wakeup event (such as masking an interrupt). Otherwise, subsequent
> +     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
> +     event and inadvertently waste CPU cycles.
> +
> +     Additionally, if userspace takes action to suppress a wakeup event,
> +     it is strongly recommended that it also restores the vCPU to its
> +     original state when the vCPU is made RUNNABLE again. For example,
> +     if userspace masked a pending interrupt to suppress the wakeup,
> +     the interrupt should be unmasked before returning control to the
> +     guest.
> +
> +For riscv:
> +^^^^^^^^^^
>
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> @@ -5985,6 +6014,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
>    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>    #define KVM_SYSTEM_EVENT_RESET          2
>    #define KVM_SYSTEM_EVENT_CRASH          3
> +  #define KVM_SYSTEM_EVENT_WAKEUP         4
>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -6009,6 +6039,9 @@ Valid values for 'type' are:
>     has requested a crash condition maintenance. Userspace can choose
>     to ignore the request, or to gather VM memory core dump and/or
>     reset/shutdown of the VM.
> + - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
> +   KVM has recognized a wakeup event. Userspace may honor this event by
> +   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
>
>  Valid flags are:
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f3f93d48e21a..46027b9b80ca 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
>  #define KVM_REQ_RELOAD_PMU     KVM_ARCH_REQ(5)
> +#define KVM_REQ_SUSPEND                KVM_ARCH_REQ(6)
>
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index efe54aba5cce..e9641b86d375 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
>         return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
>  }
>
> +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +       kvm_vcpu_kick(vcpu);

> +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +       kvm_vcpu_kick(vcpu);

Considering the patch 8 will remove the call to kvm_vcpu_kick()
(BTW, I wonder why you wanted to make that change in the patch-8
instead of the patch-7), it looks like we could use the mp_state
KVM_MP_STATE_SUSPENDED instead of using KVM_REQ_SUSPEND.
What is the reason why you prefer to introduce KVM_REQ_SUSPEND
rather than simply using KVM_MP_STATE_SUSPENDED ?

Thanks,
Reiji





> +}
> +
> +static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> @@ -464,6 +476,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>         case KVM_MP_STATE_STOPPED:
>                 kvm_arm_vcpu_power_off(vcpu);
>                 break;
> +       case KVM_MP_STATE_SUSPENDED:
> +               kvm_arm_vcpu_suspend(vcpu);
> +               break;
>         default:
>                 ret = -EINVAL;
>         }
> @@ -648,6 +663,37 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
>         preempt_enable();
>  }
>
> +static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_arm_vcpu_suspended(vcpu))
> +               return 1;
> +
> +       kvm_vcpu_wfi(vcpu);
> +
> +       /*
> +        * The suspend state is sticky; we do not leave it until userspace
> +        * explicitly marks the vCPU as runnable. Request that we suspend again
> +        * later.
> +        */
> +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> +
> +       /*
> +        * Check to make sure the vCPU is actually runnable. If so, exit to
> +        * userspace informing it of the wakeup condition.
> +        */
> +       if (kvm_arch_vcpu_runnable(vcpu)) {
> +               kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP, 0);
> +               return 0;
> +       }
> +
> +       /*
> +        * Otherwise, we were unblocked to process a different event, such as a
> +        * pending signal. Return 1 and allow kvm_arch_vcpu_ioctl_run() to
> +        * process the event.
> +        */
> +       return 1;
> +}
> +
>  /**
>   * check_vcpu_requests - check and handle pending vCPU requests
>   * @vcpu:      the VCPU pointer
> @@ -686,6 +732,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
>                         kvm_pmu_handle_pmcr(vcpu,
>                                             __vcpu_sys_reg(vcpu, PMCR_EL0));
> +
> +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> +                       return kvm_vcpu_suspend(vcpu);
>         }
>
>         return 1;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 91a6fe4e02c0..64e5f9d83a7a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -444,6 +444,7 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
> +#define KVM_SYSTEM_EVENT_WAKEUP         4
>                         __u32 type;
>                         __u64 flags;
>                 } system_event;
> @@ -640,6 +641,7 @@ struct kvm_vapic_addr {
>  #define KVM_MP_STATE_OPERATING         7
>  #define KVM_MP_STATE_LOAD              8
>  #define KVM_MP_STATE_AP_RESET_HOLD     9
> +#define KVM_MP_STATE_SUSPENDED         10
>
>  struct kvm_mp_state {
>         __u32 mp_state;
> --
> 2.35.1.1178.g4f1659d476-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
