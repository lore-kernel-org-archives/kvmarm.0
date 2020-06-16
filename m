Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30F2C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 22:44:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D6F2207E8
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 22:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jwKTGkot"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D6F2207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84B024A49C;
	Tue, 16 Jun 2020 18:44:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j0sug3wuifgy; Tue, 16 Jun 2020 18:44:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA994B122;
	Tue, 16 Jun 2020 18:44:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 598554B109
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 18:44:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id luvFETc0MVrY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 18:44:15 -0400 (EDT)
Received: from mail-il1-f193.google.com (mail-il1-f193.google.com
 [209.85.166.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F5504B0BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 18:44:15 -0400 (EDT)
Received: by mail-il1-f193.google.com with SMTP id j19so194894ilk.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 15:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rj7RCWU2TEDQylXlKwtIkp9D//dlG4LaBf/aiSxKiVc=;
 b=jwKTGkot7wWAsWfAevCa7n4oDDIULZWG6+IvhL/aBsSUfd8xoi1CHHiQjNLbPy6Nds
 JzjmjeLcF8+swR/XLC2A3jG0dcBSOPUzA2ZwIsmx3x6s8DiGcQMI8MaOvbKuOhGL3iYy
 0KumbVWOS0jshNewOy9vw25TKxRiETG0JjFw98aGQ3JcK+pWrrCyV8NDVg0fVI2Nfhg2
 nGkdogLmLckeWxseHoQIjJdjZeGFa3Ks2awf3XLJTLM3lizA3GGFWi+FkkaZY+b6Tkan
 xb734VFuz1YHqZpeU8IIPlD0OLN3yShVm8rLkPK2IudZOBAZ8XBOyvbGyz8qrXKvRRrz
 YUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rj7RCWU2TEDQylXlKwtIkp9D//dlG4LaBf/aiSxKiVc=;
 b=lqLFG+hz3P7/+igHEl0vh7cwD2QlTpuyWxqOeXKIHxoSh7P3ao1iGNgLjsZ9cKjBBt
 /Ao44MDvrv3H8UiIL2DaMBYfs3dwvCFeretIc6qnu+K9zhBYfr3wrqbqJzHwoiu9OiPJ
 3kY9v7noLekYTjWdDK6DQ/zDlDlSpE6+vWGqIBd3LXiTF3O1k5c72zPjobS1VClMbFUP
 xw1z/r06b811tda/EUz5/xDQVSc8jqOa8C8sa+Cr6lggIeu4QM2p4escRHXlh35fA962
 oA2joPYuBoX0vbxTkPBBd76tml+7PTAWwrKm6dXZHLz0/+CMxLyJOPq054LgOvxSauPv
 1Omg==
X-Gm-Message-State: AOAM5324WoI9T6VRABC+njK0OhnCJ/WnaUxZhilPg6KU689E781/XS2x
 pNRSxKQTa+XQ3ptqosq7dmKIcR37bpUEpiSR75NeOQ==
X-Google-Smtp-Source: ABdhPJyHSf6KGlyZm3i8Rr//oem1gemzV8CkuAY8ysTcBDzQxMk28uTJD2ZJioCvlncaZT55iRuz0w3yi9d26EBUClw=
X-Received: by 2002:a05:6e02:11a5:: with SMTP id
 5mr5677396ilj.108.1592347454432; 
 Tue, 16 Jun 2020 15:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200529112757.32235-1-beata.michalska@linaro.org>
 <20200529112757.32235-2-beata.michalska@linaro.org>
 <20200616083337.yfgc4cyad4ipaqb7@kamzik.brq.redhat.com>
In-Reply-To: <20200616083337.yfgc4cyad4ipaqb7@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Tue, 16 Jun 2020 23:44:03 +0100
Message-ID: <CADSWDzvGSPkLgjafEg2j0oUMhj0gVEOiiB5PCusJKZHqMRV14g@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] target/arm: kvm: Handle DABT with no valid ISS
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

Hi Andrew,

Thanks for the feedback.

On Tue, 16 Jun 2020 at 09:33, Andrew Jones <drjones@redhat.com> wrote:
>
> Hi Beata,
>
> I see Peter just picked this up, so I'm a bit late getting to it. I do
> have a couple comments below though.
>
> Thanks,
> drew
>
> On Fri, May 29, 2020 at 12:27:56PM +0100, Beata Michalska wrote:
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
> >  target/arm/kvm.c     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  target/arm/kvm_arm.h | 11 +++++++++
> >  3 files changed, 76 insertions(+), 1 deletion(-)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index 677584e..3702f21 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -570,6 +570,8 @@ typedef struct CPUARMState {
> >          uint64_t esr;
> >      } serror;
> >
> > +    uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
> > +
> >      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
> >      uint32_t irq_line_state;
> >
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 4bdbe6d..bf84224 100644
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
> > @@ -703,9 +714,16 @@ int kvm_put_vcpu_events(ARMCPU *cpu)
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
> > +    } else {
> > +        /* Clear instantly if the call was successful */
> > +        env->ext_dabt_pending = 0;
> >      }
> >
> >      return ret;
> > @@ -819,7 +837,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
> >          qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
> >                        __func__, run->exit_reason);
> >          break;
> > @@ -955,3 +978,42 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
> >  {
> >      return (data - 32) & 0xffff;
> >  }
> > +
> > +int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                             uint64_t fault_ipa)
>
> This function could be static since it's in the same file as its one
> and only caller.
>
Right. Will do.

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
> > +     * Request KVM to inject the external data abort into the guest
> > +     * by setting a pending exception on the affected vcpu.
> > +     */
> > +    if (cap_has_inject_ext_dabt) {
> > +        /* Set pending exception */
> > +        env->ext_dabt_pending = 1;
> > +        /*
> > +         * Even though at this point, the vcpu regs are out of sync,
> > +         * directly calling the KVM_SET_VCPU_EVENTS ioctl without
> > +         * explicitly synchronizing those, is enough and it also avoids
> > +         * overwriting changes done by KVM.
> > +         * The vcpu is not being marked as 'dirty' as all the changes
> > +         * needed to inject the abort are being handled by KVM only
> > +         * and there is no need for syncing either way
> > +         */
> > +        return kvm_put_vcpu_events(cpu);
>
> This looks fragile. What if we change kvm_put_vcpu_events() in a way
> that requires CPU synchronization? Or, what if we change something else
> that results in the VCPU getting flagged as dirty before finishing this
> run loop, and then we end up calling kvm_put_vcpu_events() twice, possibly
> causing some other problem?
>
> I think I'd prefer seeing the KVM_SET_VCPU_EVENTS ioctl get called
> directly from here with the events set to only inject the dabt, as we
> know that will be handled immediately and doesn't require any CPU
> synchronization.
>
It might be 'fragile' though I would expect any  changes to kvm_put_vcpu_events
revisit all users, but I have no objections to calling ioctl directly
here if that's
the prefered way.

Will try to push the changes sometime later this week.

Thanks again for the review.

BR
Beata

> Thanks,
> drew
>
> > +    } else {
> > +        error_report("Data abort exception triggered by guest memory access "
> > +                     "at physical address: 0x"  TARGET_FMT_lx,
> > +                     (target_ulong)fault_ipa);
> > +        error_printf("KVM unable to emulate faulting instruction.\n");
> > +        return -1;
> > +    }
> > +}
> > diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> > index 48bf5e1..e939e51 100644
> > --- a/target/arm/kvm_arm.h
> > +++ b/target/arm/kvm_arm.h
> > @@ -453,6 +453,17 @@ struct kvm_guest_debug_arch;
> >  void kvm_arm_copy_hw_debug_data(struct kvm_guest_debug_arch *ptr);
> >
> >  /**
> > + * kvm_arm_handle_dabt_nisv:
> > + * @cs: CPUState
> > + * @esr_iss: ISS encoding (limited) for the exception from Data Abort
> > + *           ISV bit set to '0b0' -> no valid instruction syndrome
> > + * @fault_ipa: faulting address for the synch data abort
> > + *
> > + * Returns: 0 if the exception has been handled, < 0 otherwise
> > + */
> > +int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
> > +                            uint64_t fault_ipa);
> > +/**
> >   * its_class_name:
> >   *
> >   * Return the ITS class name to use depending on whether KVM acceleration
> > --
> > 2.7.4
> >
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
