Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6855C07E9B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:40:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CB2A61242
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CB2A61242
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9847C4B13C;
	Wed, 21 Jul 2021 04:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tooNSFkixMIS; Wed, 21 Jul 2021 04:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 892554B0E9;
	Wed, 21 Jul 2021 04:40:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 074E14B0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:40:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KkMyaOHp5J6S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 04:40:03 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4AA84B0E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:40:03 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 f12-20020a056830204cb029048bcf4c6bd9so1374907otp.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 01:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=j0mH812Q+H6nf50XosopteGpGbFozpi9Pxd4x5dKswI=;
 b=qIC8YvCO8PbewH0w8Yp4rcJ1AhQE2Vo9Hct4hWBUB7+021hwzAn0ncwjQeJD1Dk2Se
 FYnIfLHKTMXuCV78XdB7ApfT5HGJomGrLtrh3fS6MzHN/FVMOdga2/0hWeYYntPdswcv
 AGJq23LtpbRpnIBA3A68fqj7mb1AZoq5/Vf3++fP2lzaOZgXh312jg8SrgowAoch5v7n
 ggBQlLH7ec2PvPQGLOlGIgaveOzYLsnAgH0Ww3m8at54fuwV1us6Jyyfli31oeTuh0ee
 StjcmdKjtG7J71ziWLcw64ph9GPnZUFFfOwYzHGlV0d11Tu11c0LCy9jS7+WxjqAjvPh
 iqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=j0mH812Q+H6nf50XosopteGpGbFozpi9Pxd4x5dKswI=;
 b=lz090TXUgrPNoEv/tB+EYPyX2MjIEIVcaqfLnZszdRLTWByFMTDgtWse29yK7fQ4+d
 exl/0nO5zQmOD62LjP+KD11R33nFpyB0pA0NR4px1kaVIzCnzBqzHeTtJ6MMwgiThj+A
 Fd5hYlfX8ZhK/B9Csf+PaNWyddFdWH4eJ+yMH1daPxScE9wqBP9d0WCMYN5u7QUA49Lq
 VPX+mPqv9kcCKp2m2RP1+S4JnbX5+ifsGRHzt3SRDt1CM3x0wtRZmmofw4HOc5oOek1r
 yvtl4X6QLLgogfYetcMiVKk2+eOH/Xp6ADMZRD4W75RQDp+qawGnmDFC6hsPcjyu/+QY
 XQeQ==
X-Gm-Message-State: AOAM5310RuDKNwcdCRvgX4gqkkP86i9IDRhfPO83rTiInC5v6RrtpInc
 GXQsVc+IzgJ2VSu1svpVRvuJHN3BD3T1k7Invt2tuw==
X-Google-Smtp-Source: ABdhPJz8wMJl99b6XXHrZ5unyCNp0pMN0AtIw+pAluMMpktoXDkoKasGVZ+UTnYKTHRgtx0Nj0isPvGyNhvgkEReXmo=
X-Received: by 2002:a05:6830:1455:: with SMTP id
 w21mr25392148otp.365.1626856803030; 
 Wed, 21 Jul 2021 01:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-15-tabba@google.com>
 <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
In-Reply-To: <CAOQ_Qshr4dmvFSd7Cr0tBg0iy2Fvp78RvyCteJ3vSBFVoBrN8Q@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jul 2021 09:39:26 +0100
Message-ID: <CA+EHjTxUr4s+7YuT-VxZGL5LkRRnXB1XKOAEfqP2+t+YffwFAQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
To: Oliver Upton <oupton@google.com>
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

Hi Oliver,

On Mon, Jul 19, 2021 at 8:43 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Jul 19, 2021 at 9:04 AM Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected KVM does not support protected AArch32 guests. However,
> > it is possible for the guest to force run AArch32, potentially
> > causing problems. Add an extra check so that if the hypervisor
> > catches the guest doing that, it can prevent the guest from
> > running again by resetting vcpu->arch.target and returning
> > ARM_EXCEPTION_IL.
> >
> > Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> > AArch32 systems")
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Would it make sense to document how we handle misbehaved guests, in
> case a particular VMM wants to clean up the mess afterwards?

I agree, especially since with this patch this could happen in more
than one place.

Thanks,
/fuad

> --
> Thanks,
> Oliver
>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 8431f1514280..f09343e15a80 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -23,6 +23,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >                         write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
> >         }
> >
> > +       /*
> > +        * Protected VMs might not be allowed to run in AArch32. The check below
> > +        * is based on the one in kvm_arch_vcpu_ioctl_run().
> > +        * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> > +        * prevent a guest from dropping to AArch32 EL0 if implemented by the
> > +        * CPU. If the hypervisor spots a guest in such a state ensure it is
> > +        * handled, and don't trust the host to spot or fix it.
> > +        */
> > +       if (unlikely(is_nvhe_hyp_code() &&
> > +                    kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> > +                    FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> > +                              PVM_ID_AA64PFR0_ALLOW) <
> > +                            ID_AA64PFR0_ELx_32BIT_64BIT &&
> > +                    vcpu_mode_is_32bit(vcpu))) {
> > +               /*
> > +                * As we have caught the guest red-handed, decide that it isn't
> > +                * fit for purpose anymore by making the vcpu invalid.
> > +                */
> > +               vcpu->arch.target = -1;
> > +               *exit_code = ARM_EXCEPTION_IL;
> > +               goto exit;
> > +       }
> > +
> >         /*
> >          * We're using the raw exception code in order to only process
> >          * the trap if no SError is pending. We will come back to the
> > --
> > 2.32.0.402.g57bb445576-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
