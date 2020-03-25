Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6CDC1975A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 15:15:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB3802076A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 15:15:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J11jbYhc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB3802076A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368364B09F;
	Wed, 25 Mar 2020 11:15:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KTTGD3FSHQid; Wed, 25 Mar 2020 11:15:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C794B093;
	Wed, 25 Mar 2020 11:15:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFFF24B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 11:15:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJRlVQGkwjgD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 11:15:19 -0400 (EDT)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5E214A4CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 11:15:19 -0400 (EDT)
Received: by mail-io1-f67.google.com with SMTP id k9so2582297iov.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 08:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=f/nHfhqolLq9DAlvAPV5hSMp5M2cRTZ5m4aLtZbOM8s=;
 b=J11jbYhcH8sxlSp+x21Pqjk5+VPDMUjGAYfVtnYu3o3RC0TjQX8zi3QIYaaIr8S7kH
 D00oZSFQjRO7/BfJ646aizaA+2/vDXVfnxyMkKI+/N3c6RvuW4PPGLn/3YA4NFzpr5Zq
 u9ticRNE+WCfBtatOB+Kx6JLY1IE9dOdHm3GSIEm/cFaQkb2tpV+DgBNlqowWcsq5pKQ
 bCGxSf0w4RaydLePY6VPWRywD6Pa2Jtnilcbe5YAeSfaXcyeXzFvFZv+8oRxrdW82W2a
 J0XA1zlqurqgsCk3yjiE5CY8nBr0CGGPvy8yJrInPmMlUiccgDgByOnjadZUrKMu+3Mv
 DhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=f/nHfhqolLq9DAlvAPV5hSMp5M2cRTZ5m4aLtZbOM8s=;
 b=R6gVEx0Ag/L2eiT+rQbHhaB4yvlwZxGc1bzjRpOnA6Py2p6m1YggeCq2XS/l5Joq83
 ZZrWoyuaH+tC05HCUrum5TzwvgVa7OdVj+PuRqCLcjuPPJfdcJi/RwvM6Zmm5BZ95i4x
 LCDYnlG3wq0QeHEzn9bJ4n523UhDxuR/0L30ZAcCB5uoZuG6WprfIIk6jHJm7NT9D+ae
 9rItv75rEbf0a2VUQ8Ndh7P9+JsvUDTjtWRO73CZHOcok7fHFo7h1YaMVK41bK0m/kIr
 uyTJ+ecdTficyTNZ76eDbFa4afchFXBgPGLhcxtomiVpgyx5dt2kjPnWcTrou9wzwNjC
 03lg==
X-Gm-Message-State: ANhLgQ0nEY6hmkb7m1GjF6JH/pDCJJA8KIpYyXbiX3Q1jOK5j0aR+lqR
 czz4qH4NKWQHKNCZg1u5Qia73KE7szG1yGNFe88vGA==
X-Google-Smtp-Source: ADFU+vtGkefyEPNZu1kccV3WqAr8fY1zL3k8ApBQ+YFOAgIsLdyKoYg3Xb5HqXWhcgAOrETpgTzpHNpuSmbuXVx+0Q8=
X-Received: by 2002:a6b:b212:: with SMTP id b18mr3384277iof.117.1585149319068; 
 Wed, 25 Mar 2020 08:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-2-beata.michalska@linaro.org>
 <20200323124405.xdv56zplli23sl46@kamzik.brq.redhat.com>
In-Reply-To: <20200323124405.xdv56zplli23sl46@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Wed, 25 Mar 2020 15:15:07 +0000
Message-ID: <CADSWDzt7SL3bBYdm5a7CTzsHJbuo4GbewxaTQOkbfsUmSYFzZA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] target/arm: kvm: Handle DABT with no valid ISS
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

Hi,

On Mon, 23 Mar 2020 at 12:44, Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Mar 23, 2020 at 11:32:26AM +0000, Beata Michalska wrote:
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
> >  target/arm/kvm.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  target/arm/kvm_arm.h | 11 +++++++++++
> >  3 files changed, 67 insertions(+)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index 4ffd991..4f834c1 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -560,6 +560,8 @@ typedef struct CPUARMState {
> >          uint64_t esr;
> >      } serror;
> >
> > +    uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
> > +
> >      /* State of our input IRQ/FIQ/VIRQ/VFIQ lines */
> >      uint32_t irq_line_state;
> >
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 85860e6..c088589 100644
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
>
> Shouldn't this be an error? If KVM says it has KVM_CAP_ARM_NISV_TO_USER,
> then I think it should always work to enable it, unless userspace passes
> the wrong flags. Currently flags must be zero, but if they were to change
> then we'll need to add the flags to vmstate and fail migration when they
> aren't compatible, and I guess that failure would occur here.
>
That's a fair point. From the kernel point of view this one is pretty
straightforward,
so it should not fail. I haven't used the error here as the lack of
this cap is not really
critical for guest but indeed it might be worth to have it here .

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
> > @@ -819,6 +837,11 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
> > @@ -953,3 +976,34 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
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
>
> I guess this is just an expensive 'vcpu_dirty=true', which the comment
> above justifies, but not super clearly. Can you try to clarify the
> comment some more?  I also wonder if we shouldn't add a KVM function
> that just marks a vcpu dirty, rather than fetching all registers.
>
I can definitely adjust the comments here to explain the case more
clearly. And I would definitely vote for moving the flag
setting/clearing outside the
sync so that it can be triggered separately without involving all the series
of potentially unnecessary ioctls. WIll draft that in the next iteration.

Thanks
Beata


> > +        env->ext_dabt_pending = 1;
> > +    } else {
> > +        error_report("Data abort exception triggered by guest memory access "
> > +                     "at physical address: 0x"  TARGET_FMT_lx,
> > +                     (target_ulong)fault_ipa);
> > +        error_printf("KVM unable to emulate faulting instruction.\n");
> > +        return -1;
> > +    }
> > +
> > +    return 0;
> > +}
> > diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> > index ae9e075..39472d5 100644
> > --- a/target/arm/kvm_arm.h
> > +++ b/target/arm/kvm_arm.h
> > @@ -450,6 +450,17 @@ struct kvm_guest_debug_arch;
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
> > +                             uint64_t fault_ipa);
> > +/**
> >   * its_class_name:
> >   *
> >   * Return the ITS class name to use depending on whether KVM acceleration
> > --
> > 2.7.4
> >
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
