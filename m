Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0919DC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 08:10:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76A8961131
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 08:10:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 76A8961131
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E79934B103;
	Thu, 19 Aug 2021 04:10:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W1X8oG0As6b9; Thu, 19 Aug 2021 04:10:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 009104B108;
	Thu, 19 Aug 2021 04:10:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F63B4B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 04:10:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1oPCwihLqrxg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 04:10:19 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8A014B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 04:10:18 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id w20so10979328lfu.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 01:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cPvH0LAivty+kbGWONu/jrOGMYsTsQGu9Ph+/kEuth0=;
 b=g5iwvH8XtD7qDEMB1qOF7bydpGwXpsD48tcbfS1oqQ1/AOUKJ58PaLfDH/Uf7ZvMxL
 9slA7pl+LKesXBh9sAoUdK8o5t7/R5NlMqMlsMViU2NaAAcTiRSwM9+7In32BROIWMiO
 SLXjhlfNgiP3XulDo6rYqIecUgk3X+GLsp90ZdVudD00utjZ/I5aZxIXqeJgsjP9XKRk
 xZ9lJZVoq7lNj7IF4r7/R+A5/lprgvfHhUtkOsOjq8Bdz71XvbkC1TqNd33VIYEGH1AE
 Gr/YN0lpgkXlpvE3F/PsNvtpnxlN/ehBHKhLXsjjZbil2pQuuexGvvUKmhZKRpsm7Gj6
 tj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cPvH0LAivty+kbGWONu/jrOGMYsTsQGu9Ph+/kEuth0=;
 b=fzJ96uU2FHeSud0k2kEpwlWeqvMzojAQXzaNbZFUNo7MK9E6xlqvnZULl65U+WH4zr
 PI4uTXXxLdPZ2o15/y+mBsTGmEm0M/O/5ApYDnSisQfsYXOOBAb3hSlLZ7AYW4j2sBGL
 IL0cin7uIY5kmaTCZ/uLrajSl/bi2/msZNYLEa7k4Zn7La3ZbuG0hIiQVToWzqhilYRw
 j7oG2aVNBEFGOKt2epow4g1+lg7He5ee+ypHnR58EmsyLHL42pyuS4y5xVnt9MfHykjq
 dELpOjE6qAyj4aw5XsY8YQA2kr9kC+4S49HI9Z+llc6sL7w4pzuzoK5p0NXLxuL2m8lZ
 z4MQ==
X-Gm-Message-State: AOAM533pWERGN555/Mz8igkAiV4/64//EdMot+pTzcS3nWHOECQj24Ib
 SzeaZ+YjiUNpRRmnWX2D9zchWDFB1dnOFgZ63CkxqA==
X-Google-Smtp-Source: ABdhPJwRJHRfC6bp+yucaRYcXg+6U4jr3ewQU/A/l03h51iZvbtfcjZ1PlG9Cpe3GEnFknctx1QJD+vQf8rj5XBM0m8=
X-Received: by 2002:a05:6512:3fa8:: with SMTP id
 x40mr9659895lfa.0.1629360617193; 
 Thu, 19 Aug 2021 01:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-16-tabba@google.com>
In-Reply-To: <20210817081134.2918285-16-tabba@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 19 Aug 2021 01:10:06 -0700
Message-ID: <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
To: Fuad Tabba <tabba@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Fuad,

On Tue, Aug 17, 2021 at 1:12 AM Fuad Tabba <tabba@google.com> wrote:
>
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
>
> If this were to happen, The VMM can try and fix it by re-
> initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
> likely not possible for protected VMs.
>
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 398e62098898..0c24b7f473bf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -20,6 +20,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
>                 return NULL;
>  }
>
> +/*
> + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
> + * check below is based on the one in kvm_arch_vcpu_ioctl_run().
> + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> + * hypervisor spots a guest in such a state ensure it is handled, and don't
> + * trust the host to spot or fix it.
> + *
> + * Returns true if the check passed and the guest run loop can continue, or
> + * false if the guest should exit to the host.
> + */
> +static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)

This does a bit more than just check & return, so maybe call it
handle_aarch32_guest()?

> +{
> +       if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&

maybe initialize a local with a hyp pointer to the kvm structure.

> +           vcpu_mode_is_32bit(vcpu) &&
> +           FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> +                                        PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
> +               ID_AA64PFR0_ELx_32BIT_64BIT) {

It may be more readable to initialize a local variable with this
feature check, i.e:

bool aarch32_allowed = FIELD_GET(...) == ID_AA64PFR0_ELx_32BIT_64BIT;

and then:

  if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu) &&
!aarch32_allowed) {

> +               /*
> +                * As we have caught the guest red-handed, decide that it isn't
> +                * fit for purpose anymore by making the vcpu invalid. The VMM
> +                * can try and fix it by re-initializing the vcpu with
> +                * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> +                * protected VMs.
> +                */
> +               vcpu->arch.target = -1;
> +               *exit_code = ARM_EXCEPTION_IL;
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
>  /* Switch to the guest for legacy non-VHE systems */
>  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
> @@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>                 /* Jump in the fire! */
>                 exit_code = __guest_enter(vcpu);
>
> +               if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
> +                       break;
> +
>                 /* And we're baaack! */
>         } while (fixup_guest_exit(vcpu, &exit_code));
>
> --
> 2.33.0.rc1.237.g0d66db33f3-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
