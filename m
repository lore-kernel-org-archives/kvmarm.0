Return-Path: <SRS0=Cj27=5A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1CFC10DCE
	for <kvmarm@archiver.kernel.org>; Sun, 15 Mar 2020 18:36:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C432206B1
	for <kvmarm@archiver.kernel.org>; Sun, 15 Mar 2020 18:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nkVLhrBO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C432206B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6A54B08A;
	Sun, 15 Mar 2020 14:36:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sQzQmBTjlUb5; Sun, 15 Mar 2020 14:36:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3052D4B086;
	Sun, 15 Mar 2020 14:36:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FA44A3A5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Mar 2020 14:36:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nk8QVDDfGJza for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Mar 2020 14:36:22 -0400 (EDT)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 558774A32E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Mar 2020 14:36:22 -0400 (EDT)
Received: by mail-il1-f196.google.com with SMTP id a6so14262334ilc.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Mar 2020 11:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fXChW3mXUiE00KW5aGocutMecusvpJwk+O2gV/lHwA8=;
 b=nkVLhrBOTF7MJMKSQU2CtcxnS4qhb+pTwdtMDaIVwob1Fkcan3MUgYiyjnG5p3rt43
 FSDAnocQMPqojqadeHxVG+NSESoTz3s+hbgB8IOIl3M3kZqHZNTIfdq2M4YwQ5bbRIry
 Q0JwrgKiaA7cWBDz0VrP/yJohjsrNAbYmG9/g0xsZ0Ks5RF7E0EN3uaG0L8iiwwZFevV
 ROyH7X/1cwHjXW57j+zVai3rd7c+AhOVbxSA3RK7/g0jVyvpi64M0Oj7Hw6jsHvouXrV
 Zgra2lem1KNqM26qQKyYoTgb+4Ut2WgiU/xLqzlKIrzreLvRj0VxXAZMqUePI+6jbfwP
 IUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fXChW3mXUiE00KW5aGocutMecusvpJwk+O2gV/lHwA8=;
 b=sfwaizPNolI20PDC5hQct37yiHt1ITDNsaQL1DWd9890dc62BfezAVXjC9N1GXgOHN
 e9/pSKGXriW5MNsjRe9c5S6lJL46Rt8ENKz33htag56jm4XN/A/dXVzPUVkT92IUWbTT
 wVenGC1pR5qPUvUF5F5aI936ArPruJB2gszoQhD4/+4nMgQrv4jdE4myPika63lHAe4F
 s2D9SQPtKVmT67JREGaGf0jVR2jM2LHqj9h23d8T8K8RXjUEsMq2z8cIp9zRkA3iW4VT
 zHJ3Z2Xbe9JvcsSGSDt7GQLONSyqjdfK/4mkJbtzV9GxiPu8/JLOqx/XY9TPQ9RP5N0r
 qlVw==
X-Gm-Message-State: ANhLgQ3T7oU/L0Xg4CqpKBfBtQEsu1N9TFBjIOMT2O+oAzlDHVXaTzcr
 9FVX4nCjEmjR8m+m8Xrrys8ngqnFV2JyzJlwRoosOg==
X-Google-Smtp-Source: ADFU+vukShxHgXoP9tQc77dy4aOaSRHcHGy/n6EsJTA+7Ai8xRlgJ05o5M6KnpTrkWkDF+IlKWgCaXNaiIRympmOkA8=
X-Received: by 2002:a92:c60c:: with SMTP id p12mr2391445ilm.307.1584297381614; 
 Sun, 15 Mar 2020 11:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200312003401.29017-1-beata.michalska@linaro.org>
 <20200312003401.29017-3-beata.michalska@linaro.org>
 <20200312102530.a55grtyfrnx2glj4@kamzik.brq.redhat.com>
In-Reply-To: <20200312102530.a55grtyfrnx2glj4@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Sun, 15 Mar 2020 18:36:09 +0000
Message-ID: <CADSWDzso-E5pQwFGss2y7HmmxBphM7DwOUtjLd=2tyjsU8q=AA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] target/arm: kvm: Handle DABT with no valid ISS
To: Andrew Jones <drjones@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, 12 Mar 2020 at 10:25, Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Mar 12, 2020 at 12:34:01AM +0000, Beata Michalska wrote:
> > On ARMv7 & ARMv8 some load/store instructions might trigger a data abort
> > exception with no valid ISS info to be decoded. The lack of decode info
> > makes it at least tricky to emulate those instruction which is one of the
> > (many) reasons why KVM will not even try to do so.
> >
> > Add support for handling those by requesting KVM to inject external
> > dabt into the quest.
> >
> > Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> > ---
> >  target/arm/cpu.h     |  3 ++
> >  target/arm/kvm.c     | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  target/arm/kvm32.c   | 26 +++++++++++++++++
> >  target/arm/kvm64.c   | 36 +++++++++++++++++++++++
> >  target/arm/kvm_arm.h | 22 ++++++++++++++
> >  5 files changed, 168 insertions(+)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index 4ffd991..45fdd2e 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -560,6 +560,9 @@ typedef struct CPUARMState {
> >          uint64_t esr;
> >      } serror;
> >
> > +    uint8_t ext_dabt_pending:1; /* Request for injecting ext DABT */
> > +    uint8_t ext_dabt_raised:1; /* Tracking/verifying injection of ext DABT */
> > +
>
> Why the bit-fields? We don't use them anywhere else in cpu.h, and that's
> probably because they're not portable. We should just use bools.
>
Old habit of optimizations.
I can drop the bit fields but I'd rather stay with the original type
to be consistent with the kvm ones. I am not sure though why in this case
that would not be portable - bit fields can get tricky but that should not
be the case here (?)

> >      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
> >      uint32_t irq_line_state;
> >
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 85860e6..8b7b708 100644
> > --- a/target/arm/kvm.c
> > +++ b/target/arm/kvm.c
> > @@ -39,6 +39,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
> >
> >  static bool cap_has_mp_state;
> >  static bool cap_has_inject_serror_esr;
> > +static bool cap_has_inject_ext_dabt;
> >
> >  static ARMHostCPUFeatures arm_host_cpu_features;
> >
> > @@ -244,6 +245,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >          ret = -EINVAL;
> >      }
> >
> > +    if (kvm_check_extension(s, KVM_CAP_ARM_NISV_TO_USER)) {
> > +        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_NISV_TO_USER, 0)) {
> > +            warn_report("Failed to enable DABT NISV cap");
> > +        } else {
> > +            /* Set status for supporting the external dabt injection */
> > +            cap_has_inject_ext_dabt = kvm_check_extension(s,
> > +                                    KVM_CAP_ARM_INJECT_EXT_DABT);
> > +        }
> > +    }
> > +
> >      return ret;
> >  }
> >
> > @@ -703,9 +714,20 @@ int kvm_put_vcpu_events(ARMCPU *cpu)
> >          events.exception.serror_esr = env->serror.esr;
> >      }
> >
> > +    if (cap_has_inject_ext_dabt) {
> > +        events.exception.ext_dabt_pending = env->ext_dabt_pending;
> > +    }
> > +
> >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
> >      if (ret) {
> >          error_report("failed to put vcpu events");
> > +    } else if (env->ext_dabt_pending) {
> > +        /*
> > +         * Mark that the external DABT has been injected,
> > +         * if one has been requested
> > +         */
> > +        env->ext_dabt_raised = env->ext_dabt_pending;
> > +        env->ext_dabt_pending = 0;
> >      }
> >
> >      return ret;
> > @@ -737,6 +759,30 @@ int kvm_get_vcpu_events(ARMCPU *cpu)
> >
> >  void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
> >  {
> > +    ARMCPU *cpu = ARM_CPU(cs);
> > +    CPUARMState *env = &cpu->env;
> > +
> > +    if (unlikely(env->ext_dabt_raised)) {
> > +        /*
> > +         * Verifying that the ext DABT has been properly injected,
> > +         * otherwise risking indefinitely re-running the faulting instruction
> > +         * Covering a very narrow case for kernels 5.5..5.5.4
>
> I'm still not convinced that QEMU needs to add workarounds for broken KVM,
> when KVM can be fixed, and even is already fixed. If you really want to
> keep it, then can you break this patch into two, splitting the dabt
> injection out from the workaround?
>
I can definitely do that.
Not a big fan of adding features that expose issues, even if those
are a rare case. Rather have those handled, on the safe side, so
I would prefer to keep it. Although I must admit this is bit unfortunate.

> > +         * when injected abort was misconfigured to be
> > +         * an IMPLEMENTATION DEFINED exception (for 32-bit EL1)
> > +         */
> > +        if (!arm_feature(env, ARM_FEATURE_AARCH64) &&
> > +            unlikely(kvm_arm_verify_ext_dabt_pending(cs))) {
> > +
> > +            error_report("Data abort exception with no valid ISS generated by "
> > +                   "guest memory access. KVM unable to emulate faulting "
> > +                   "instruction. Failed to inject an external data abort "
> > +                   "into the guest.");
> > +            abort();
> > +       }
> > +       /* Clear the status */
> > +       env->ext_dabt_raised = 0;
> > +    }
> > +
> >  }
> >
> >  MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
> > @@ -819,6 +865,11 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
> >              ret = EXCP_DEBUG;
> >          } /* otherwise return to guest */
> >          break;
> > +    case KVM_EXIT_ARM_NISV:
> > +        /* External DABT with no valid iss to decode */
> > +        ret = kvm_arm_handle_dabt_nisv(cs, run->arm_nisv.esr_iss,
> > +                                       run->arm_nisv.fault_ipa);
> > +        break;
> >      default:
> >          qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
> >                        __func__, run->exit_reason);
> > @@ -953,3 +1004,33 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
> >  {
> >      return (data - 32) & 0xffff;
> >  }
> > +
> > +int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                             uint64_t fault_ipa)
> > +{
> > +    ARMCPU *cpu = ARM_CPU(cs);
> > +    CPUARMState *env = &cpu->env;
> > +
> > +   /*
> > +    * ISS [23:14] is invalid so there is a limited info
> > +    * on what has just happened so the only *useful* thing that can
> > +    * be retrieved from ISS is WnR & DFSC (though in some cases WnR
> > +    * might be less of a value as well)
> > +    */
> > +
> > +    /*
> > +     * Set pending ext dabt and trigger SET_EVENTS so that
> > +     * KVM can inject the abort
> > +     */
> > +    if (cap_has_inject_ext_dabt) {
> > +        kvm_cpu_synchronize_state(cs);
> > +        env->ext_dabt_pending = 1;
> > +    } else {
> > +        error_report("Data abort exception triggered by guest memory access "
> > +                     "at physical address: 0x"  TARGET_FMT_lx,
> > +                     (target_ulong)fault_ipa);
> > +        error_printf("KVM unable to emulate faulting instruction.\n");
>
> return -1;
>
> > +    }
> > +
> > +    return cap_has_inject_ext_dabt ? 0 : -1;
>
> return 0;

Agreed. Will change that.

>
> > +}
> > diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> > index f271181..4795a7d 100644
> > --- a/target/arm/kvm32.c
> > +++ b/target/arm/kvm32.c
> > @@ -564,3 +564,29 @@ void kvm_arm_pmu_init(CPUState *cs)
> >  {
> >      qemu_log_mask(LOG_UNIMP, "%s: not implemented\n", __func__);
> >  }
> > +
> > +
> > +#define ARM_REG_DFSR  ARM_CP15_REG32(0, 5, 0, 0)
> > +#define ARM_REG_TTBCR ARM_CP15_REG32(0, 2, 0, 2)
> > +
> > +#define DFSR_FSC(v)   (((v) >> 6 | (v)) & 0x1F)
> > +#define DFSC_EXTABT(lpae) (lpae) ? 0x10 : 0x08
> > +
> > +int kvm_arm_verify_ext_dabt_pending(CPUState *cs)
> > +{
> > +    uint32_t dfsr_val;
> > +
> > +    if (!kvm_get_one_reg(cs, ARM_REG_DFSR, &dfsr_val)) {
> > +
>
> extra line
>
> > +        ARMCPU *cpu = ARM_CPU(cs);
> > +        CPUARMState *env = &cpu->env;
> > +        uint32_t ttbcr;
> > +        int lpae = 0;
> > +
> > +        if (!kvm_get_one_reg(cs, ARM_REG_TTBCR, &ttbcr)) {
> > +            lpae = arm_feature(env, ARM_FEATURE_LPAE) && (ttbcr & TTBCR_EAE);
> > +        }
> > +        return DFSR_FSC(dfsr_val) != DFSC_EXTABT(lpae);
> > +    }
> > +    return 1;
> > +}
> > diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> > index be5b31c..2f8ffc6 100644
> > --- a/target/arm/kvm64.c
> > +++ b/target/arm/kvm64.c
> > @@ -1430,3 +1430,39 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm_debug_exit_arch *debug_exit)
> >
> >      return false;
> >  }
> > +
> > +
> > +#define ARM64_REG_ESR_EL1 ARM64_SYS_REG(3, 0, 5, 2, 0)
> > +#define ARM64_REG_TCR_EL1 ARM64_SYS_REG(3, 0, 2, 0, 2)
> > +
> > +#define ESR_DFSC(aarch64, v)    \
> > +    ((aarch64) ? ((v) & 0x3F)   \
> > +               : (((v) >> 6 | (v)) & 0x1F))
> > +
> > +#define ESR_DFSC_EXTABT(aarch64, lpae) \
> > +    ((aarch64) ? 0x10 : (lpae) ? 0x10 : 0x8)
> > +
> > +int kvm_arm_verify_ext_dabt_pending(CPUState *cs)
> > +{
> > +    uint64_t dfsr_val;
> > +
> > +    if (!kvm_get_one_reg(cs, ARM64_REG_ESR_EL1, &dfsr_val)) {
> > +        ARMCPU *cpu = ARM_CPU(cs);
> > +        CPUARMState *env = &cpu->env;
> > +        int aarch64_mode = arm_feature(env, ARM_FEATURE_AARCH64);
> > +        int lpae = 0;
> > +
> > +        if (!aarch64_mode) {
> > +
>
> extra line
>
> > +            uint64_t ttbcr;
> > +
> > +            if (!kvm_get_one_reg(cs, ARM64_REG_TCR_EL1, &ttbcr)) {
> > +                lpae = arm_feature(env, ARM_FEATURE_LPAE)
> > +                        && (ttbcr & TTBCR_EAE);
> > +            }
> > +        }
> > +        return ESR_DFSC(aarch64_mode, dfsr_val) !=
> > +                ESR_DFSC_EXTABT(aarch64_mode, lpae) ;
>                   ^ extra space
>
> > +    }
> > +    return 1;
> > +}
> > diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> > index ae9e075..777c9bf 100644
> > --- a/target/arm/kvm_arm.h
> > +++ b/target/arm/kvm_arm.h
> > @@ -450,6 +450,28 @@ struct kvm_guest_debug_arch;
> >  void kvm_arm_copy_hw_debug_data(struct kvm_guest_debug_arch *ptr);
> >
> >  /**
> > + * kvm_arm_handle_dabt_nisv
>                               ^ missing :
> > + * @cs: CPUState
> > + * @esr_iss: ISS encoding (limited) for the exception from Data Abort
> > + *           ISV bit set to '0b0' -> no valid instruction syndrome
> > + * @fault_ipa: faulting address for the synch data abort
> > + *
> > + * Returns: 0 if the exception has been handled
>                                                   , < 0 otherwise
>
> > + */
> > +int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                             uint64_t fault_ipa);
> > +
> > +/**
> > + * kvm_arm_verify_ext_dabt_pending
>                                      ^ missing :
> > + * @cs: CPUState
> > + *
> > + * Verify the fault status code wrt the Ext DABT injection
> > + *
> > + * Returns: 0 if the fault status code is as expected, non-zero otherwise
>
> I'd return a boolean from a function like this, true when verified and
> false otherwise.
>
No objections here - will change that.

Thank you for the review.

BR


Beata
> > + */
> > +int kvm_arm_verify_ext_dabt_pending(CPUState *cs);
> > +
> > +/**
> >   * its_class_name:
> >   *
> >   * Return the ITS class name to use depending on whether KVM acceleration
> > --
> > 2.7.4
> >
> >
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
