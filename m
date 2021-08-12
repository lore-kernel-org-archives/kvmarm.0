Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FB7C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 13:09:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12BE0610A7
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 13:09:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 12BE0610A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6AA4A17F;
	Thu, 12 Aug 2021 09:09:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0wJr8CuloLUA; Thu, 12 Aug 2021 09:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6407F4A19F;
	Thu, 12 Aug 2021 09:09:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90CDC4A17F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 09:09:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8t99fqtPGwM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 09:09:13 -0400 (EDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
 [209.85.210.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D244B49F92
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 09:09:13 -0400 (EDT)
Received: by mail-ot1-f46.google.com with SMTP id
 r19-20020a0568301353b029050aa53c3801so7658540otq.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WRqzbWQ5nIKrt8ACxqIhdjGTjjV3XNEnx9RLXFnLp9U=;
 b=af9F5gG94wT94ta0EmdCDZ8PMu/JYSODDydH43su3PYUH4Z+npHCVd+twnuabLyLNV
 AIRifFs11BXjl7YazhGbXPfY4lNp4+/FEqPxhzIGR0b3jyb4NHjP7kUl0QOJ/VbDYSCB
 zNvXzIbE8H6Z1AG4SI7PCxZR0ffFQ77Cz11R/oC77w/C3MuMlI+IVT+jryt6r3kbgt03
 UeVzl+KGq4v/L8c0z7v3ETQ1rM0re5bwSmmKhOrdWFpgq+zjfmf0rwokthr5pRl130jX
 oLOOYQm4tbe896knjGw2NJTQSh1bNrKbUMtFmPczK4ih0DP8ZsNDXMkHcnAvjd5BYv8M
 713Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WRqzbWQ5nIKrt8ACxqIhdjGTjjV3XNEnx9RLXFnLp9U=;
 b=SA7BMuzpiDUiAeWmgOcgU38TUezTZLUECsdR7TEiUWxbkaSiUxG8g97cGg1/PijbMk
 bu5xc2O/lc6kD1acr+Fg0y6MiJQLlkbMrg0lePpKlj+8f4B1SsKN7NumsHrkh4P5NdSr
 iy9G0chjYN72uLRgzN7bNxk4QrNpGEy4IErsJSDaOpa2UAZIW30TVB1w9aTdtj5PxP4t
 avnwoMdulxC2Pm+QqW+uY11l+b7jGF10VcLvxB4LvTB32fVfq49zE8NdVmhS/gJRkErr
 TH4KFc4TdaSn9FP6RYItXJFPoF+HtW4RQXzS1DAOel5hqchmEV+X7GwcsKaLUPd2Do5i
 ygjA==
X-Gm-Message-State: AOAM532yd0rzcvM6UJPeJ21bGdQ2ktG9Magc/BAbAJ6lyz7UMPgnBziU
 pEe7I4og0X8Q9+PC/KEYLRDbkLOKG6YzeegJEbY0dA==
X-Google-Smtp-Source: ABdhPJzOnqtXcXrXssuHj4ykZZNRW7+lUJI1VruW/y3wcegljhCDGPhQVqab0qVckurvGz4++zn4Vc5YQG/X0aDIIwE=
X-Received: by 2002:a05:6830:1095:: with SMTP id
 y21mr3282853oto.144.1628773752727; 
 Thu, 12 Aug 2021 06:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-15-tabba@google.com>
 <20210812095743.GL5912@willie-the-truck>
In-Reply-To: <20210812095743.GL5912@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Aug 2021 15:08:36 +0200
Message-ID: <CA+EHjTzE1w-ePBw+JZw-+ScSKWYExKw9HNTo8rNJAJnAUNf6tw@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,


On Thu, Aug 12, 2021 at 11:57 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:45PM +0100, Fuad Tabba wrote:
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
> >                       write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
> >       }
> >
> > +     /*
> > +      * Protected VMs might not be allowed to run in AArch32. The check below
> > +      * is based on the one in kvm_arch_vcpu_ioctl_run().
> > +      * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> > +      * prevent a guest from dropping to AArch32 EL0 if implemented by the
> > +      * CPU. If the hypervisor spots a guest in such a state ensure it is
> > +      * handled, and don't trust the host to spot or fix it.
> > +      */
> > +     if (unlikely(is_nvhe_hyp_code() &&
> > +                  kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> > +                  FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> > +                            PVM_ID_AA64PFR0_ALLOW) <
> > +                          ID_AA64PFR0_ELx_32BIT_64BIT &&
> > +                  vcpu_mode_is_32bit(vcpu))) {
> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
> > +             goto exit;
> > +     }
>
> Would this be better off inside the nvhe-specific run loop? Seems like we
> could elide fixup_guest_exit() altogether if we've detect that we're in
> AArch32 state when we shouldn't be and it would keep the code off the shared
> path.

Yes, it makes more sense and would result in cleaner code to have it
there, especially in the future where there's likely to be a separate
run loop for protected VMs. I'll move it.

Thanks,
/fuad
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
