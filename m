Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEF7C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 06:44:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE5749F20;
	Thu, 24 Mar 2022 02:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jaUtaAjGMKu8; Thu, 24 Mar 2022 02:44:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26F249F49;
	Thu, 24 Mar 2022 02:44:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2E0D49F17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 02:44:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3IQHJh+UniWc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 02:44:36 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62A5149F0E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 02:44:36 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id b8so3893050pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 23:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=g92GNbyRw2zP4NyiWEWVoR29xzKSW1YDOFU5CW6awjI=;
 b=W4GNbRWFeYIGRK4Kd7v0BV7d/8+EzcVQiKjbyIzkj5P3MuR5r+MRKX9NhxplmdKQDG
 h8WJzXqIT4A+HtJuFsxwdcEqw4e4OmMkge71MMjZX6cAHKOeJxIUAA7PoZ0oQwcy3gr2
 fIkcPWrt7XSykEo1w+cXHy0g0PolVivZf8uxR1KBcRa/C2rOiNZZ4GvnwKQEquHpSZ/U
 0T4yNv6LDdymEHb+hx3KavSwMNsBgEzA5sTHbpRFeV64zSfbMVyJjvAc9+bl5w8S8h//
 9JF1hrq2ZNjq885slruDknDbG7C3hZD3JrbAuC1iCofwjLsqVdOqqEniNERfVGXM+FgQ
 ib1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=g92GNbyRw2zP4NyiWEWVoR29xzKSW1YDOFU5CW6awjI=;
 b=MFsPzKuGfMpRUs3XDyKzR/l0WJqB6QHdK79okWgxfCYQH9lyeEE977zhuUb6XdowiV
 TafmJgk8YDoHy6KudqgIXQfwtmfs7bDJe3mSZSvsI/W8jUFpWnbEvVLeG3iBLoKDfHDV
 6nHEEJe4M5nunYpjHGJoHVFLX8HouEf9NOquSQ2FSApsGVhPYPiEE/RVICp+9vxnYmyz
 Ry33CrMTYdBAIoX67ATplNouDBriHZzD0yUyK9gigT33PgAaAIvq8fOgLwOg34Jp1xHS
 i+7RxVllIOG5UdBa0QZRJZmO5AK2PPCN2uetftMaeCIsrKsuDNSgTwa0T5+qhVUSCeDw
 R0Eg==
X-Gm-Message-State: AOAM5330cZkFR/oSFpDwsJ81/QOuJnMn83+lqGDs5koKtMb2CR2TtHMd
 llqHoHuEBtwzMlqU542hiKT+FXNPDvvzeHAdPrGlTw==
X-Google-Smtp-Source: ABdhPJxNinvVGW4deP+GBGN8X1rgQnrl5ZgxEDZnW3lw1JKkzdIl06MSnl7IU0ErWLwb3H3bXRi167e2wOA/hFXCuCk=
X-Received: by 2002:a17:902:c9c2:b0:154:68e7:7c5a with SMTP id
 q2-20020a170902c9c200b0015468e77c5amr4185987pld.122.1648104275145; Wed, 23
 Mar 2022 23:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-10-oupton@google.com>
 <CAAeT=FyGUZMy-TUZuHu+bZtUY9NfjBQ79JKBX0xK4kEqFTO1OQ@mail.gmail.com>
 <YjlxkE2h6K9cTOTP@google.com>
In-Reply-To: <YjlxkE2h6K9cTOTP@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Mar 2022 23:44:19 -0700
Message-ID: <CAAeT=FwMCOy_0kVU+ZJw+J5QUnJQ6BhBxvDYMf0axz-Xyjo4LQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] KVM: arm64: Add support for userspace to suspend
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

On Mon, Mar 21, 2022 at 11:49 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Mar 21, 2022 at 11:19:33PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
> > > is in a suspended state. In the suspended state the vCPU will block
> > > until a wakeup event (pending interrupt) is recognized.
> > >
> > > Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
> > > userspace that KVM has recognized one such wakeup event. It is the
> > > responsibility of userspace to then make the vCPU runnable, or leave it
> > > suspended until the next wakeup event.
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst    | 37 +++++++++++++++++++++++++++++--
> > >  arch/arm64/include/asm/kvm_host.h |  1 +
> > >  arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++++++
> > >  include/uapi/linux/kvm.h          |  2 ++
> > >  4 files changed, 73 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 5625c08b4a0e..426bcdc1216d 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -1482,14 +1482,43 @@ Possible values are:
> > >                                   [s390]
> > >     KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
> > >                                   [s390]
> > > +   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
> > > +                                 for a wakeup event [arm64]
> > >     ==========================    ===============================================
> > >
> > >  On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
> > >  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
> > >  these architectures.
> > >
> > > -For arm64/riscv:
> > > -^^^^^^^^^^^^^^^^
> > > +For arm64:
> > > +^^^^^^^^^^
> > > +
> > > +If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will emulate the
> > > +architectural execution of a WFI instruction.
> > > +
> > > +If a wakeup event is recognized, KVM will exit to userspace with a
> > > +KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
> > > +userspace wants to honor the wakeup, it must set the vCPU's MP state to
> > > +KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
> > > +event in subsequent calls to KVM_RUN.
> > > +
> > > +.. warning::
> > > +
> > > +     If userspace intends to keep the vCPU in a SUSPENDED state, it is
> > > +     strongly recommended that userspace take action to suppress the
> > > +     wakeup event (such as masking an interrupt). Otherwise, subsequent
> > > +     calls to KVM_RUN will immediately exit with a KVM_SYSTEM_EVENT_WAKEUP
> > > +     event and inadvertently waste CPU cycles.
> > > +
> > > +     Additionally, if userspace takes action to suppress a wakeup event,
> > > +     it is strongly recommended that it also restore the vCPU to its
> >
> > Nit: s/restore/restores/ ?
> >
> >
> > > +     original state when the vCPU is made RUNNABLE again. For example,
> > > +     if userspace masked a pending interrupt to suppress the wakeup,
> > > +     the interrupt should be unmasked before returning control to the
> > > +     guest.
> > > +
> > > +For riscv:
> > > +^^^^^^^^^^
> > >
> > >  The only states that are valid are KVM_MP_STATE_STOPPED and
> > >  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> > > @@ -5914,6 +5943,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
> > >    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> > >    #define KVM_SYSTEM_EVENT_RESET          2
> > >    #define KVM_SYSTEM_EVENT_CRASH          3
> > > +  #define KVM_SYSTEM_EVENT_WAKEUP         4
> > >                         __u32 type;
> > >                         __u64 flags;
> > >                 } system_event;
> > > @@ -5938,6 +5968,9 @@ Valid values for 'type' are:
> > >     has requested a crash condition maintenance. Userspace can choose
> > >     to ignore the request, or to gather VM memory core dump and/or
> > >     reset/shutdown of the VM.
> > > + - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
> >
> > Nit: Shouldn't 'the guest' be 'the vcpu' ?
> >
> > > +   has recognized a wakeup event. Userspace may honor this event by marking
> > > +   the exiting vCPU as runnable, or deny it and call KVM_RUN again.
> > >
> > >  Valid flags are:
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index da58eb96d2a8..899f2c0b4c7b 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -46,6 +46,7 @@
> > >  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
> > >  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
> > >  #define KVM_REQ_RELOAD_PMU     KVM_ARCH_REQ(5)
> > > +#define KVM_REQ_SUSPEND                KVM_ARCH_REQ(6)
> > >
> > >  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> > >                                      KVM_DIRTY_LOG_INITIALLY_SET)
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 8eed0556ccaa..b94efa05d869 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -444,6 +444,18 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> > >         return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
> > >  }
> > >
> > > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > > +{
> > > +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> > > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > > +       kvm_vcpu_kick(vcpu);
> > > +}
> > > +
> > > +static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> > > +{
> > > +       return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
> > > +}
> > > +
> > >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> > >                                     struct kvm_mp_state *mp_state)
> > >  {
> > > @@ -464,6 +476,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> > >         case KVM_MP_STATE_STOPPED:
> > >                 kvm_arm_vcpu_power_off(vcpu);
> > >                 break;
> > > +       case KVM_MP_STATE_SUSPENDED:
> > > +               kvm_arm_vcpu_suspend(vcpu);
> > > +               break;
> > >         default:
> > >                 ret = -EINVAL;
> > >         }
> > > @@ -648,6 +663,23 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
> > >         preempt_enable();
> > >  }
> > >
> > > +static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > > +{
> > > +       if (!kvm_arm_vcpu_suspended(vcpu))
> > > +               return 1;
> > > +
> > > +       kvm_vcpu_wfi(vcpu);
> > > +
> > > +       /*
> > > +        * The suspend state is sticky; we do not leave it until userspace
> > > +        * explicitly marks the vCPU as runnable. Request that we suspend again
> > > +        * later.
> > > +        */
> > > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > > +       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP, 0);
> > > +       return 0;
> > > +}
> > > +
> > >  /**
> > >   * check_vcpu_requests - check and handle pending vCPU requests
> > >   * @vcpu:      the VCPU pointer
> > > @@ -686,6 +718,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > >                 if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> > >                         kvm_pmu_handle_pmcr(vcpu,
> > >                                             __vcpu_sys_reg(vcpu, PMCR_EL0));
> > > +
> > > +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > > +                       return kvm_vcpu_suspend(vcpu);
> >
> > It appears that one of the cases that kvm_vcpu_suspend() returns
> > is when a pending signal is detected, and the exit reason will be
> > KVM_EXIT_SYSTEM_EVENT in this case.  On the other hand, when a
> > pending signal is detected earlier in xfer_to_guest_mode_handle_work(),
> > KVM_RUN returns -EINTR even if the vCPU is in KVM_MP_STATE_SUSPENDED
> > state. Shouldn't those behaviors be consistent ? (Perhaps -EINTR?)
>
> Great catch!
>
> I should probably check that the vCPU is actually runnable with
> kvm_arch_vcpu_runnable() before setting up a system event exit. That is
> after all what the documentation of this whole API says it does, right?
> :)
>
> If the vCPU thread were poked for any other reason this should return 1
> and let the kvm_vcpu_exit_request()/xfer_to_guest_mode_handle_work()
> pairing clean up anything else.

Yes, that sounds good.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
