Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A06DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:41:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A824619EE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:41:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A824619EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF58840762;
	Thu, 30 Sep 2021 13:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yAmCLtvDe3a2; Thu, 30 Sep 2021 13:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C064A534;
	Thu, 30 Sep 2021 13:41:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B114A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TPMe145KrwmR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:40:57 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AEAC40762
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:40:57 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id y26so28772075lfa.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WfYS2qC2BUxBFwaeuNq9CBr5/hOzTpoKNHPOYb/kb0U=;
 b=JKOucH0Du6brC9cHP3/TotgojGp8LvQ0DMjfh+4pMkJa8EDUlrn4MCuup217MRnbtM
 UnmffJdlH1fl2YlbuvzNR+9444tEuDfLh+qCZG+WWSdE8WzYDD/VStajkRwRwwb5Tr6B
 VmGZXLRZn0LuEnninqKhQHYwjOa60lkiQWgL7OTVZEW72Mhma+VjGwfDTQZ6ob1NibV6
 TdkjDFFZMyynHJyKSZjOmG8levpV02JLMKZq1dI0EEsV0Dj/yaGxczKT/I3dtlX/g0WN
 e1RdYYuGRdJLlCn1j9YQ4CEhBlxLhGp7TCRplUHrZgs+qRKZEFUqNX5ABhJ2I4zMgLC5
 APmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WfYS2qC2BUxBFwaeuNq9CBr5/hOzTpoKNHPOYb/kb0U=;
 b=J+0n1NbOgWwLQnCOGNF+YFPSWDseRxsObIlf4fmTyY2KCcu1v8CCsUVNDU3HuQmHhR
 gW9EBAQueUXzjEsdxumoZCAmGshSCGAJMGiX3OAyZ/ShSjGPgF0WexHdmp5biguAeraf
 r94y/Iu4Wn+rNGfpvwnBkqT/nSIwIJxpoNymR5j82j7zsvEhZ817iZyGCExO7saY2Ver
 tX8dglpFVeBinXzxl8sXGNg+qeQw7QqddUntaF1hzwKTTnVhgmBOqofasUBvyqKYc0Hx
 8SBJPRCnHXZBYQ817Wh34U9CEcEK3SjOoKQZmbMMCFRtlqHOFQx/jndqkKqlBFl1a0H3
 qnlA==
X-Gm-Message-State: AOAM530xCBUwe+cNZ0t3qW+rS7LfKLrA3V7zyl8LzGOII9kcgRIwvNTK
 oy92dDft+wErEiRvX0LcCf0whlIfWPPOxZMoAVqQBQ==
X-Google-Smtp-Source: ABdhPJzWA0qKlJoVZVk1oBbIoYZxtKHd4J6jrwGqjgUe48P4FMnSxdWiBL7ysJHErdOjAZyPxzB9ODFI8q09GafGkHI=
X-Received: by 2002:a2e:5c88:: with SMTP id q130mr7096148ljb.170.1633023654249; 
 Thu, 30 Sep 2021 10:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org>
In-Reply-To: <877deytfes.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Thu, 30 Sep 2021 10:40:43 -0700
Message-ID: <CAOQ_QsjjhTg5usW3DS1P+Uin4ApjvbHwwpmXyEo0bzHe6RGL5g@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI
 call
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 30, 2021 at 5:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 23 Sep 2021 20:16:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > used to request a system be suspended. This is optional for PSCI v1.0
> > and to date KVM has elected to not implement the call. However, a
> > VMM/operator may wish to provide their guests with the ability to
> > suspend/resume, necessitating this PSCI call.
> >
> > Implement support for SYSTEM_SUSPEND according to the prescribed
> > behavior in the specification. Add a new system event exit type,
> > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
>
> KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> it make really sense to hijack this for something that is more of a
> VM-wide state? I can see that it is tempting to do so as we're using
> the WFI semantics (which are close to HLT's, in a twisted kind of
> way), but I'm also painfully aware that gluing x86 expectations on
> arm64 rarely leads to a palatable result.
>
> > Userspace can set this to request an in-kernel emulation of the suspend.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    |  6 ++++
> >  arch/arm64/include/asm/kvm_host.h |  3 ++
> >  arch/arm64/kvm/arm.c              |  8 +++++
> >  arch/arm64/kvm/psci.c             | 60 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 ++
> >  5 files changed, 79 insertions(+)
>
> This patch needs splitting. PSCI interface in one, mpstate stuff in
> another, userspace management last.
>
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index a6729c8cf063..361a57061b8f 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5656,6 +5656,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
> >    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> >    #define KVM_SYSTEM_EVENT_RESET          2
> >    #define KVM_SYSTEM_EVENT_CRASH          3
> > +  #define KVM_SYSTEM_EVENT_SUSPEND        4
> >                       __u32 type;
> >                       __u64 flags;
> >               } system_event;
> > @@ -5680,6 +5681,11 @@ Valid values for 'type' are:
> >     has requested a crash condition maintenance. Userspace can choose
> >     to ignore the request, or to gather VM memory core dump and/or
> >     reset/shutdown of the VM.
> > + - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested that the VM
> > +   suspends. Userspace is not obliged to honor this, and may call KVM_RUN
> > +   again. Doing so will cause the guest to resume at its requested entry
> > +   point. For ARM64, userspace can request in-kernel suspend emulation
> > +   by setting the vCPU's MP state to KVM_MP_STATE_HALTED.
> >
> >  ::
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 1beda1189a15..441eb6fa7adc 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -137,6 +137,9 @@ struct kvm_arch {
> >
> >       /* Memory Tagging Extension enabled for the guest */
> >       bool mte_enabled;
> > +
> > +     /* PSCI SYSTEM_SUSPEND call enabled for the guest */
> > +     bool suspend_enabled;
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f1a375648e25..d875d3bcf3c5 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -101,6 +101,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               }
> >               mutex_unlock(&kvm->lock);
> >               break;
> > +     case KVM_CAP_ARM_SYSTEM_SUSPEND:
> > +             r = 0;
> > +             kvm->arch.suspend_enabled = true;
>
> I don't really fancy adding another control here. Given that we now
> have the PSCI version being controlled by a firmware pseudo-register,
> I'd rather have that there.
>
> And if we do that, I wonder whether there would be any benefit in
> bumping the PSCI version to 1.1.
>
> > +             break;
> >       default:
> >               r = -EINVAL;
> >               break;
> > @@ -215,6 +219,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_SET_GUEST_DEBUG:
> >       case KVM_CAP_VCPU_ATTRIBUTES:
> >       case KVM_CAP_PTP_KVM:
> > +     case KVM_CAP_ARM_SYSTEM_SUSPEND:
> >               r = 1;
> >               break;
> >       case KVM_CAP_SET_GUEST_DEBUG2:
> > @@ -470,6 +475,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >       int ret = 0;
> >
> >       switch (mp_state->mp_state) {
> > +     case KVM_MP_STATE_HALTED:
> > +             kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +             fallthrough;
> >       case KVM_MP_STATE_RUNNABLE:
> >               vcpu->arch.power_off = false;
> >               break;
>
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index d453666ddb83..cf869f1f8615 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -203,6 +203,46 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
> >       kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
> >  }
> >
> > +static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +     unsigned long entry_addr, context_id;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     unsigned long psci_ret = 0;
> > +     struct kvm_vcpu *tmp;
> > +     int ret = 0;
> > +     int i;
> > +
> > +     /*
> > +      * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
> > +      * calling vCPU) be in an OFF state, as determined by the
> > +      * implementation.
> > +      *
> > +      * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
> > +      */
> > +     mutex_lock(&kvm->lock);
> > +     kvm_for_each_vcpu(i, tmp, kvm) {
> > +             if (tmp != vcpu && !tmp->arch.power_off) {
> > +                     psci_ret = PSCI_RET_DENIED;
> > +                     ret = 1;
> > +                     goto out;
> > +             }
> > +     }
> > +
> > +     entry_addr = smccc_get_arg1(vcpu);
> > +     context_id = smccc_get_arg2(vcpu);
> > +
> > +     kvm_psci_vcpu_request_reset(vcpu, entry_addr, context_id,
> > +                                 kvm_vcpu_is_be(vcpu));
>
> So even if userspace doesn't want to honor the suspend request, the
> CPU ends up resetting? That's not wrong, but maybe a bit surprising.
>
> > +
> > +     memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> > +     vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SUSPEND;
> > +     vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>
> Consider spinning out a helper common to this and kvm_prepare_system_event().
>
> > +out:
> > +     mutex_unlock(&kvm->lock);
> > +     smccc_set_retval(vcpu, psci_ret, 0, 0, 0);
> > +     return ret;
> > +}
> > +
> >  static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> >  {
> >       int i;
> > @@ -223,6 +263,14 @@ static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32
> >       if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
> >               return PSCI_RET_NOT_SUPPORTED;
> >
> > +     switch (fn) {
> > +     case PSCI_1_0_FN_SYSTEM_SUSPEND:
> > +     case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> > +             if (!vcpu->kvm->arch.suspend_enabled)
> > +                     return PSCI_RET_NOT_SUPPORTED;
> > +             break;
> > +     }
> > +
> >       return 0;
> >  }
> >
> > @@ -316,6 +364,10 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
> >       unsigned long val;
> >       int ret = 1;
> >
> > +     val = kvm_psci_check_allowed_function(vcpu, psci_fn);
> > +     if (val)
> > +             goto out;
> > +
> >       switch(psci_fn) {
> >       case PSCI_0_2_FN_PSCI_VERSION:
> >               val = KVM_ARM_PSCI_1_0;
> > @@ -339,6 +391,8 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
> >               case PSCI_0_2_FN_SYSTEM_OFF:
> >               case PSCI_0_2_FN_SYSTEM_RESET:
> >               case PSCI_1_0_FN_PSCI_FEATURES:
> > +             case PSCI_1_0_FN_SYSTEM_SUSPEND:
> > +             case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> >               case ARM_SMCCC_VERSION_FUNC_ID:
> >                       val = 0;
> >                       break;
> > @@ -347,10 +401,16 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
> >                       break;
> >               }
> >               break;
> > +     case PSCI_1_0_FN_SYSTEM_SUSPEND:
> > +             kvm_psci_narrow_to_32bit(vcpu);
> > +             fallthrough;
> > +     case PSCI_1_0_FN64_SYSTEM_SUSPEND:
> > +             return kvm_psci_system_suspend(vcpu);
> >       default:
> >               return kvm_psci_0_2_call(vcpu);
> >       }
> >
> > +out:
> >       smccc_set_retval(vcpu, val, 0, 0, 0);
> >       return ret;
> >  }
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index a067410ebea5..052b0e717b08 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -433,6 +433,7 @@ struct kvm_run {
> >  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> >  #define KVM_SYSTEM_EVENT_RESET          2
> >  #define KVM_SYSTEM_EVENT_CRASH          3
> > +#define KVM_SYSTEM_EVENT_SUSPEND        4
> >                       __u32 type;
> >                       __u64 flags;
> >               } system_event;
> > @@ -1112,6 +1113,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_BINARY_STATS_FD 203
> >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> >  #define KVM_CAP_ARM_MTE 205
> > +#define KVM_CAP_ARM_SYSTEM_SUSPEND 206
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
>
> I think there is an additional feature we need, which is to give
> control back to userspace every time a wake-up condition occurs (I did
> touch on that in [1]). This would give the opportunity to the VMM to
> do whatever it needs to perform.
>
> A typical use case would be to implement wake-up from certain
> interrupts only (mask non-wake-up IRQs on suspend request, return to
> the guest for WFI, wake-up returns to the VMM to restore the previous
> interrupt configuration, resume).
>
> Userspace would be free to clear the suspend state and resume the
> guest, or to reenter WFI.

Yeah, this is definitely needed for the series.

Just to make sure it's clear, what should the default behavior be if
userspace doesn't touch state at all and it calls KVM_RUN again? It
would seem to me that we should resume the guest by default, much like
we would do for the SUSPEND event exit.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
