Return-Path: <SRS0=Is6r=32=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D82C35247
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:48:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9E8721775
	for <kvmarm@archiver.kernel.org>; Thu,  6 Feb 2020 21:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BAGyVylt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9E8721775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65B614A4C0;
	Thu,  6 Feb 2020 16:48:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Ox0EanQmiKh; Thu,  6 Feb 2020 16:48:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20234A51F;
	Thu,  6 Feb 2020 16:48:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8294A3A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:48:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YrPf1qKx2caD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Feb 2020 16:48:17 -0500 (EST)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2402D4A389
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Feb 2020 16:48:17 -0500 (EST)
Received: by mail-il1-f196.google.com with SMTP id b15so6535412iln.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Feb 2020 13:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Wy1Sqdo0M2y1UUkfOruL8IBYp1Ki3GytyCuyoZOPLQA=;
 b=BAGyVyltUOacgCnahSh4chCmoHo3fSgdE1cTe+KSdqHvUTP35lEDhHva/ef/e2xhU9
 Apwu5z99bZ6SYGDxBcVoYh+FxU0EDNq9mRk4ckENMWpQ/XgaR2aNngYxX//tH/yCs6Qo
 7u8HJq9F+bICLxNOakFsmeFhvVve4DEfVaF7NVQhsE5J+QEa7sUa9kZmAAMiXGQJoOVl
 NnpxT3adltjuuUWJTeISjwGaom6xdubSK3rXgnViYpC1iC13X4arU1e+1BowowYBvmoO
 6SrZVYM2HZkL9aYimkezGECZMNy+FFb/Tk/v6JDz7Qxr2EPKMYcBCBFwuCOdPLeJH+Kb
 jSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Wy1Sqdo0M2y1UUkfOruL8IBYp1Ki3GytyCuyoZOPLQA=;
 b=ivlAkAqZ33cdE1VVVbTbCT34nyzyKBLLC2lpamoC9dYTNM6MQKea3lO2dZrK3aTuG1
 oEob9fSiz5DTRH5zMZOmxZeUoXij+j84YvD+dKDHLIaoPm0eQXBZx9Q+6SxLEYjiizBz
 hM+simRWMjIU47RTY1vD/5vwqBhObb8qozvQVpFFMSM+h9GJXsZ6x4mwsp8PVDMSOG57
 7t6gQaSgiK2i8GBWusEQIvZwhKncx3y55fLhKw7yvnAejZuzBkk0TnojuLPwy53PLxZR
 +tSmjQ8pUBzVi9SI4lp+3V2bRP3xQj4enuDqoRWy4O8BoJKviY0AG7kM/IjctDJlrHFa
 JDag==
X-Gm-Message-State: APjAAAUQOFDZUIt2tCYtlupKJzyGN1OLaVSypzknU7RDfAFCige7j4zZ
 epLHkejOFItz1JEqp6L/vZfTOVEAh2TSMXS+e8RbFw==
X-Google-Smtp-Source: APXvYqyk3SoOlAS3jd+ejumnymdpbTX14OcRwFgoos/s9hZz8ZoBujulACpx/OR846tg5po0Sb6vhvX0esagjErxnJ8=
X-Received: by 2002:a05:6e02:5c3:: with SMTP id
 l3mr6351768ils.260.1581025696368; 
 Thu, 06 Feb 2020 13:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20200129202441.12745-1-beata.michalska@linaro.org>
 <20200129202441.12745-3-beata.michalska@linaro.org>
 <20200205165739.2jkklbpmy3yrdq3q@kamzik.brq.redhat.com>
In-Reply-To: <20200205165739.2jkklbpmy3yrdq3q@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Thu, 6 Feb 2020 21:48:05 +0000
Message-ID: <CADSWDzu70AXg5pNY3sLr5GFbKtXaFmV_UgSm6TWw7oshv4vcEw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] target/arm: kvm: Handle DABT with no valid ISS
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

On Wed, 5 Feb 2020 at 16:57, Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Jan 29, 2020 at 08:24:41PM +0000, Beata Michalska wrote:
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
> >  target/arm/cpu.h     |  2 ++
> >  target/arm/kvm.c     | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  target/arm/kvm32.c   |  3 ++
> >  target/arm/kvm64.c   |  3 ++
> >  target/arm/kvm_arm.h | 19 +++++++++++
> >  5 files changed, 123 insertions(+)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index c1aedbe..e04a8d3 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -558,6 +558,8 @@ typedef struct CPUARMState {
> >          uint8_t has_esr;
> >          uint64_t esr;
> >      } serror;
> > +    /* Status field for pending external dabt */
> > +    uint8_t ext_dabt_pending;
> >
> >      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
> >      uint32_t irq_line_state;
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 8d82889..e7bc9b7 100644
> > --- a/target/arm/kvm.c
> > +++ b/target/arm/kvm.c
> > @@ -37,6 +37,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
> >
> >  static bool cap_has_mp_state;
> >  static bool cap_has_inject_serror_esr;
> > +static bool cap_has_inject_ext_dabt; /* KVM_CAP_ARM_INJECT_EXT_DABT */
>
> nit: the KVM_CAP_ARM_INJECT_EXT_DABT comment is unnecessary

Might be - I just find it handy when looking for  related details.
I will remove that one though.

>
> >
> >  static ARMHostCPUFeatures arm_host_cpu_features;
> >
> > @@ -62,6 +63,12 @@ void kvm_arm_init_serror_injection(CPUState *cs)
> >                                      KVM_CAP_ARM_INJECT_SERROR_ESR);
> >  }
> >
> > +void kvm_arm_init_ext_dabt_injection(CPUState *cs)
> > +{
> > +    cap_has_inject_ext_dabt = kvm_check_extension(cs->kvm_state,
> > +                                    KVM_CAP_ARM_INJECT_EXT_DABT);
> > +}
> > +
> >  bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
> >                                        int *fdarray,
> >                                        struct kvm_vcpu_init *init)
> > @@ -216,6 +223,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >          ret = -EINVAL;
> >      }
> >
> > +    if (kvm_check_extension(s, KVM_CAP_ARM_NISV_TO_USER))
> > +        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_NISV_TO_USER, 0)) {
> > +            warn_report("Failed to enable DABT NISV cap");
> > +        }
> > +
>
> Missing {} around the outer block.

Checkpatch didn't complain ...
Will fix that.

>
> As KVM_CAP_ARM_INJECT_EXT_DABT is a VM capability then I think we should
> set cap_has_inject_ext_dabt here, like cap_has_mp_state gets set. I see
> you've followed the pattern used for cap_has_inject_serror_esr, but that
> looks wrong too since KVM_CAP_ARM_INJECT_SERROR_ESR is also a VM
> capability. The way it is now we just keep setting
> cap_has_inject_serror_esr to the same value, NR_VCPUS times.
>
You are totally right - I have completely missed that point! Thanks.

> >      return ret;
> >  }
> >
> > @@ -598,6 +610,10 @@ int kvm_put_vcpu_events(ARMCPU *cpu)
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
> > @@ -627,6 +643,8 @@ int kvm_get_vcpu_events(ARMCPU *cpu)
> >      env->serror.has_esr = events.exception.serror_has_esr;
> >      env->serror.esr = events.exception.serror_esr;
> >
> > +    env->ext_dabt_pending = events.exception.ext_dabt_pending;
> > +
>
> afaict from Documentation/virt/kvm/api.txt and the KVM code you cannot
> get this state. Therefore the above line (and extra stray blank line)
> should be dropped.
>
That's true, though this is a lightweight way of resetting the vcpu state.
We would have to do that otherwise to mark that this case has been handled
and that the abort is no longer pending.

> >      return 0;
> >  }
> >
> > @@ -634,6 +652,7 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
> >  {
> >  }
> >
> > +
>
> stray blank line
>
> >  MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
> >  {
> >      ARMCPU *cpu;
> > @@ -699,6 +718,11 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
> > @@ -833,3 +857,75 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
> >  {
> >      return (data - 32) & 0xffff;
> >  }
> > +
> > +int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                             uint64_t fault_ipa)
> > +{
> > +    ARMCPU *cpu = ARM_CPU(cs);
> > +    CPUARMState *env = &cpu->env;
> > +    uint32_t ins, ins_fetched;
>
> ins_fetched is a bool

Actually that's int (as per cpu_memory_rw_debug)
>
> > +
> > +    /*
> > +     * Hacky workaround for kernels that for aarch32 guests, instead of expected
> > +     * external data abort, inject the IMPLEMENTATION DEFINED exception with the
> > +     * lock-down. This is actually handled by the guest which results in
> > +     * re-running the faulting instruction.
> > +     * This intends to break the vicious cycle.
> > +     */
>
> This doesn't seem like the right thing to do. What happens on real
> hardware in this case? If an OS would get into a "vicious cycle" on
> real hardware then it should get into one on KVM too.
>
That's the problem. that would not happen on a real hardware.
We might end up here due to a KVM bug (which has been fixed recently)
when the injected
abort is not the one expected (as of not the one that would be
triggered by hw in this
particular case).
Details in : https://patchwork.kernel.org/patch/11358083/

> > +    if (!is_a64(env)) {
> > +        static uint8_t setback;
> > +
> > +        /*
> > +         * The state has not been synchronized yet, so if this is re-occurrence
> > +         * of the same abort triggered by guest, the status for pending external
> > +         * abort should not get cleared yet
> > +         */
> > +        if (unlikely(env->ext_dabt_pending)) {
> > +            if (setback) {
> > +                error_report("Most probably triggered kernel issue with"
> > +                             " injecting external data abort.");
> > +                error_printf("Giving up trying ...\n");
> > +                /* Here is where the fun comes to an end */
> > +                return -EINVAL;
> > +            }
> > +        }
> > +        setback = env->ext_dabt_pending;
> > +    }
> > +
> > +    kvm_cpu_synchronize_state(cs);
> > +   /*
> > +    * ISS [23:14] is invalid so there is a limited info
> > +    * on what has just happened so the only *useful* thing that can
> > +    * be retrieved from ISS is WnR & DFSC (though in some cases WnR
> > +    * might be less of a value as well)
> > +    */
> > +
> > +    /*
> > +     * Get current PC before it will get updated to exception vector entry
> > +     */
> > +    target_ulong ins_addr = is_a64(env) ? env->pc : env->regs[15];
>
> ins_addr should be declared above
>
> But what are we doing? pc is a guest virtual address. Oh, I see...
>
> > +
> > +    /*
> > +     * Get the faulting instruction
> > +     * Instructions have a fixed length of 32 bits
> > +     * and are always little-endian
> > +     */
> > +    ins_fetched = !cpu_memory_rw_debug(cs, ins_addr, (uint8_t *) &ins,
> > +                                       sizeof(uint32_t), 0);
>
> ... we're trying to actual walk the KVM guest's page tables. That
> seems a bit odd, and the "_debug" function name used for it makes
> it seem even more odd.
>
> > +
> > +    error_report("Data abort exception with no valid ISS generated by "
> > +                 "guest memory access at physical address: 0x" TARGET_FMT_lx,
> > +                 (target_ulong)fault_ipa);
> > +
> > +    error_printf(ins_fetched ? "%s : 0x%" PRIx32 " (ins encoded)\n"  : "%s\n",
> > +                 "KVM unable to emulate faulting instruction",
> > +                 (!ins_fetched ? 0 : ldl_le_p(&ins)));
> > +    error_printf("Injecting a data abort exception into guest.\n");
>
> The guest shouldn't be able to generate three lines of errors on the host
> whenever it wants. That's a security bug. One trace point here seems like
> the most we should do. Or, after these three lines we should kill the
> guest.
>
You have a point here, this can indeed be exploited by the malicious
guest. Not sure if killing it is necessary here.
I could limit the logging though that gets tricky for aborts triggered by
user-space processes which would probably leave the guest running
without much of an issue there.
I can y get rid of logging the additional info and keep the single
statement of an instruction not being emulated but that still leaves an
open door for potential exploits...

> Actually, I don't think we should attempt to get the instruction at all.
> We should do what the KVM documenation suggests we do when we get
> this exit. We should either do a user selected action: one of suspend,
> dump, restart, or inject a dabt (as is done below). The last choice hopes
> that the guest will handle it in some graceful way, or that it'll crash
> with all the information needed for a post-mortem crash investigation.
>
> And I don't think we should do the "very brave" option of trying to
> emulate the instruction, even if we identify it as a valid MMIO address.
> That just sounds like a huge can of worms.
>
> Does QEMU already have a way for users to select a
> don't-know-how-to-handle-guest-exception behavior?
>

The function is attempting to inject the external data abort. The rest is for
the aftermath analysis to easy figuring out what has happened
which will not be so easy in case of user-space process triggering
the DABT with no valid ISS. There is no attempt of emulating the instruction
just simply saying the guest tried to access this address with this instruction
which couldn't be handled. Might be excessive in some cases
(like misbehaving kernel) but it also might be handy on those rare
occasions when there is not much to analyze.
But as per the issue you have raised above I will rework that.

Not sure if there is a mechanism to specify the 'preferred' behavior though.

BR


Beata


> > +    /*
> > +     * Set pending ext dabt and trigger SET_EVENTS so that
> > +     * KVM can inject the abort
> > +     */
> > +    env->ext_dabt_pending = 1;
> > +
> > +    return 0;
> > +}
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
