Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0775C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 19:44:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 583D86120D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 19:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 583D86120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D86584B0E4;
	Mon, 19 Jul 2021 15:43:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EvkfyArMmWcO; Mon, 19 Jul 2021 15:43:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB44C4B0DE;
	Mon, 19 Jul 2021 15:43:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4AD74B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 15:43:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jCAtyrSgduIQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 15:43:55 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A8234A023
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 15:43:55 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id 8so32092866lfp.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Gmu9FJSBhEcTSsmtt+iIhZ+8zB3ttk3MjsTqKSz3Yrw=;
 b=ibg8A6Fhp+23S6tzVmCXeCEtj3odd8AVkQbrVXxhoRY4hnV6gHo2WGoSgPOUVxw0xp
 qAkVNVkfWmVR4/Ha1068xBHFDcyEuYHenDejQPoKAOL/4l8/Sp5ILgH9PU4FUlqE6Wjp
 29uaJBXcRd++t/O167Y4BlwyJMNAdiTbX3Uft4nOjOFo+2E+VuhE47aAGYI8g6tAPjEX
 sEQxADLvqI+UDxQRTpx0KbQADJ4BSKAjek4vY4hqD1AeNo8VoiJydWppvu7wTge17KFl
 WePVEJ1ETYzJulqcA7YDnUIsSV1ux5dQ9HEuz9EhiytfdiDIsiVfs8JzFgK88b0heUw7
 v9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Gmu9FJSBhEcTSsmtt+iIhZ+8zB3ttk3MjsTqKSz3Yrw=;
 b=ncMcq+yzC/MjmpRwNEFwNo/dODlBLP1YhUirSJf8IpAaKC1s0OV5rwTt3uBx8RBQp2
 l5Jn33xyhcJbOiFXqm7/VD1+oWQJdeujfCBnjIyT4ugl6IV1pLyKZopM9xAyPVe0tFwA
 xw7JiSYZRfW7m/VFAC+yTaJzGL9DbCue8aAh1rIdcvwpdQaTZvbJ+eWJy5BMHN4zLFXg
 /Yr6rVHftIDzMYV/a2Me/1x+tWiK43hUbD/XobHfd1opJk5OW54bL2tNvg6zTjvC0HBg
 XUj/4iNShrNQV7Z3j37knUXZC8XW3G6F0bvuDckUaphrsAVsKUhg+w/OGI7giRiCpHli
 qFHw==
X-Gm-Message-State: AOAM531hN31Yg5QdifKrfIiUGctthz7eXKH+9AJVDqkuUUM4Ay6FtS8+
 Ein3AMqtu2XxNmWRkzLzAZ9DlqS3DlIULy5BcSj+9A==
X-Google-Smtp-Source: ABdhPJwHb2gGExmEkhtp61ra3gEDYpWPNEBUJorQ1IC6P0PEeGqqusawSvPdSUGD+XYIHJG6fexg/5948QAeT1sZEv8=
X-Received: by 2002:a05:6512:3237:: with SMTP id
 f23mr17557452lfe.524.1626723832655; 
 Mon, 19 Jul 2021 12:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-15-tabba@google.com>
In-Reply-To: <20210719160346.609914-15-tabba@google.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 19 Jul 2021 12:43:41 -0700
Message-ID: <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
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

On Mon, Jul 19, 2021 at 9:04 AM Fuad Tabba <tabba@google.com> wrote:
>
> Protected KVM does not support protected AArch32 guests. However,
> it is possible for the guest to force run AArch32, potentially
> causing problems. Add an extra check so that if the hypervisor
> catches the guest doing that, it can prevent the guest from
> running again by resetting vcpu->arch.target and returning
> ARM_EXCEPTION_IL.
>
> Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> AArch32 systems")
>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Would it make sense to document how we handle misbehaved guests, in
case a particular VMM wants to clean up the mess afterwards?

--
Thanks,
Oliver

> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8431f1514280..f09343e15a80 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -23,6 +23,7 @@
>  #include <asm/kprobes.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_fixed_config.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
> @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>                         write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
>         }
>
> +       /*
> +        * Protected VMs might not be allowed to run in AArch32. The check below
> +        * is based on the one in kvm_arch_vcpu_ioctl_run().
> +        * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> +        * prevent a guest from dropping to AArch32 EL0 if implemented by the
> +        * CPU. If the hypervisor spots a guest in such a state ensure it is
> +        * handled, and don't trust the host to spot or fix it.
> +        */
> +       if (unlikely(is_nvhe_hyp_code() &&
> +                    kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> +                    FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> +                              PVM_ID_AA64PFR0_ALLOW) <
> +                            ID_AA64PFR0_ELx_32BIT_64BIT &&
> +                    vcpu_mode_is_32bit(vcpu))) {
> +               /*
> +                * As we have caught the guest red-handed, decide that it isn't
> +                * fit for purpose anymore by making the vcpu invalid.
> +                */
> +               vcpu->arch.target = -1;
> +               *exit_code = ARM_EXCEPTION_IL;
> +               goto exit;
> +       }
> +
>         /*
>          * We're using the raw exception code in order to only process
>          * the trap if no SError is pending. We will come back to the
> --
> 2.32.0.402.g57bb445576-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
