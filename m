Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CB6C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 11:55:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B05F23CD5
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 11:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tei1JmJF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B05F23CD5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B41B14B3B8;
	Mon, 29 Jun 2020 07:55:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yeaxE6o3-Bla; Mon, 29 Jun 2020 07:55:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2364B3C4;
	Mon, 29 Jun 2020 07:55:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D0E4B3B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 07:55:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G0l7RNnykSmz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 07:55:07 -0400 (EDT)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5C54B332
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 07:55:07 -0400 (EDT)
Received: by mail-io1-f68.google.com with SMTP id y2so16834352ioy.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 04:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fEJFWBnpsD1Fzxq+UGFqbCNX3W+nZoqUk4DjhMHNxrc=;
 b=Tei1JmJFXM/uRL0vORJ6QdAtj+XiwqDwDInAPjjzy7erYQ2SGnDGFUqn8USuLbD/9R
 7EBZpHhfgdWUVBAR9BUeL7X+iRwSUbefOJRulJ3qKPH5DMqLCuJQjJ0ebLuvK0BDzvIC
 l6nKSIfU+smq3AMIOrjooYCcUCqhhZZbWS8CHQm0gpGp8SxNDSJcCDud1EVYjy772IC8
 PQ1D7fxPecfDC8J7XR8iS/sXTtqly3B9Aj+cGiQyyhtJfZ/1ZVgveKK5YdACUeuZz9Ps
 OFavMcU1tdlU17aJKgLQ28fYiM6N2TFL+4ZYQ8kl137rrszFZ4xTDiBisLVD+Pybhmlt
 fLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fEJFWBnpsD1Fzxq+UGFqbCNX3W+nZoqUk4DjhMHNxrc=;
 b=pCEWvhchP/u4SGGjj2bgrUyVnhtPTXKMk5VWbvLJFb+UL8ez54rN4KzAZbGEJGSgYM
 01wwwgNbZPUNk4LsAkTohz31FnXXHLPYfXWFiAwbCIdo2HCX0cgZ4XVpxwBEAuMxI1qI
 ryb+jj5MOllb5JKVbgkazKd1e5lu/TFPNOpg/T5hbx6TyOvfBZWsM8CXBdOyO4cVxPk4
 dH9cl78Rk1AiJZ7Px51lIhREGymNj9WmcgI7muE6FM1LAvn+k9HRTHCA/mpoIFf1zNW6
 q3eiyFlA5D48x/oB4XwqC9tHEr8XghRRGU9MnGUqSLq5e208xO9B5VKMOSSodY5si5Eh
 jNCA==
X-Gm-Message-State: AOAM533eWatHeCvxMn8KRV5PFtIeLrdkMhKBO6an+Rr4afCa2kPvUOJL
 sqrQ727FWDnQjMKEgqDzRTw8I7SowI8foGp2kJcPmA==
X-Google-Smtp-Source: ABdhPJxFiRnOqZiR0JV6/Tck6vbv5sducHrJs2fK7Ug0C0z5E5z3rdeB5b5cpHQ1cqIsbnujm4ZIsDmbLRgcUGhgm9s=
X-Received: by 2002:a5d:849a:: with SMTP id t26mr16661198iom.22.1593431706751; 
 Mon, 29 Jun 2020 04:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200628150459.18566-1-beata.michalska@linaro.org>
 <20200628150459.18566-2-beata.michalska@linaro.org>
 <20200629081510.ochvmmmikhe62bsm@kamzik.brq.redhat.com>
In-Reply-To: <20200629081510.ochvmmmikhe62bsm@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Mon, 29 Jun 2020 12:54:55 +0100
Message-ID: <CADSWDzvdX6iDgd8YuZ3aGnz6qDzjzs7=a7A0MB2k4KAcRG6s9Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] target/arm: kvm: Handle DABT with no valid ISS
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

On Mon, 29 Jun 2020 at 09:15, Andrew Jones <drjones@redhat.com> wrote:
>
> On Sun, Jun 28, 2020 at 04:04:58PM +0100, Beata Michalska wrote:
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
> >  target/arm/kvm.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 56 insertions(+), 1 deletion(-)
> >
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index eef3bbd..2dd8a9a 100644
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
> > @@ -245,6 +246,16 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >          ret = -EINVAL;
> >      }
> >
> > +    if (kvm_check_extension(s, KVM_CAP_ARM_NISV_TO_USER)) {
> > +        if (kvm_vm_enable_cap(s, KVM_CAP_ARM_NISV_TO_USER, 0)) {
> > +            error_report("Failed to enable KVM_CAP_ARM_NISV_TO_USER cap");
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
> > @@ -810,6 +821,45 @@ void kvm_arm_vm_state_change(void *opaque, int running, RunState state)
> >      }
> >  }
> >
> > +/**
> > + * kvm_arm_handle_dabt_nisv:
> > + * @cs: CPUState
> > + * @esr_iss: ISS encoding (limited) for the exception from Data Abort
> > + *           ISV bit set to '0b0' -> no valid instruction syndrome
> > + * @fault_ipa: faulting address for the synchronous data abort
> > + *
> > + * Returns: 0 if the exception has been handled, < 0 otherwise
> > + */
> > +static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                             uint64_t fault_ipa)
>
> The indent of 'uint64_t fault_ipa' is off. Should be under CPUState.
>
> > +{
> > +    /*
> > +     * Request KVM to inject the external data abort into the guest
> > +     */
> > +    if (cap_has_inject_ext_dabt) {
> > +        struct kvm_vcpu_events events = { };
> > +        /*
> > +         * The external data abort event will be handled immediately by KVM
> > +         * using the address fault that triggered the exit on given VCPU.
> > +         * Requesting injection of the external data abort does not rely
> > +         * on any other VCPU state. Therefore, in this particular case, the VCPU
> > +         * synchronization can be exceptionally skipped.
> > +         */
> > +        events.exception.ext_dabt_pending = 1;
> > +        /*
> > +         * KVM_CAP_ARM_INJECT_EXT_DABT implies KVM_CAP_VCPU_EVENTS
> > +         */
>
> Single line comments may be done with /* ... */
>
> > +        return kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
> > +
>
> Extra blank line here.
>
> > +    } else {
> > +        error_report("Data abort exception triggered by guest memory access "
> > +                     "at physical address: 0x"  TARGET_FMT_lx,
> > +                     (target_ulong)fault_ipa);
> > +        error_printf("KVM unable to emulate faulting instruction.\n");
> > +    }
> > +    return -1;
> > +}
> > +
> >  int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
> >  {
> >      int ret = 0;
> > @@ -820,7 +870,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
> >              ret = EXCP_DEBUG;
> >          } /* otherwise return to guest */
> >          break;
> > -    default:
> > +    case KVM_EXIT_ARM_NISV:
> > +        /* External DABT with no valid iss to decode */
> > +        ret = kvm_arm_handle_dabt_nisv(cs, run->arm_nisv.esr_iss,
> > +                                       run->arm_nisv.fault_ipa);
> > +        break;
> > +     default:
>
> An extra space got added in front of 'default:'
>
> >          qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
> >                        __func__, run->exit_reason);
> >          break;
> > --
> > 2.7.4
> >
> >
>
> Besides the format changes
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
Done.
Thanks a lot for the reviews!

BR
Beata
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
