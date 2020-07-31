Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D0EC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 23:21:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DAEC20791
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 23:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zQHfcgUB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DAEC20791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88E84B2E2;
	Fri, 31 Jul 2020 19:21:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BYY-26+3d6eE; Fri, 31 Jul 2020 19:21:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B5E4B1C4;
	Fri, 31 Jul 2020 19:21:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8EF4B1B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 19:21:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YVisVmRhr5DO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 19:21:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 648264B1A7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 19:21:44 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 42BD120888
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596237703;
 bh=O43Lpuq7vfYewBlTgQCnArXYf22qg3TUSWFiVVk2lA4=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=zQHfcgUBLOXHeE5sB5ZZ3poFBxfiYQXAwopMHq4AIA2cxdQU2dkMLpjf65+n4bdjm
 u2kiHUkAtv/CbGb3edJDX3/qN/iIldEJaHxuAUQjBXRvN+4RNZcRc64G7vR9SYSL0W
 q/YeBOiGAOU1CSE7h6w1wYZ1Jy1JikQlHL6uCdEM=
Received: by mail-oi1-f169.google.com with SMTP id e6so7942616oii.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 16:21:43 -0700 (PDT)
X-Gm-Message-State: AOAM530F9OvgNeCbPxs6JU6riWVY0bdZkJvtiQj9CgLyAVw5yqIJeUYX
 VmN4fjU7p1capeW7LWV5kDeMOy05Rw4n8b20Kw==
X-Google-Smtp-Source: ABdhPJwHDnMeymJ74OVOp04DULFpegZIhUhKZqgt0EM5CPzgh0SOfFj5Qs6F70qgSh/2nV/GtDDqprxinp9aZ+m/rvM=
X-Received: by 2002:aca:4844:: with SMTP id v65mr4938636oia.152.1596237702533; 
 Fri, 31 Jul 2020 16:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200717205233.903344-1-robh@kernel.org>
 <20200717205233.903344-4-robh@kernel.org>
 <20200729163800.GA24572@gaia>
In-Reply-To: <20200729163800.GA24572@gaia>
From: Rob Herring <robh@kernel.org>
Date: Fri, 31 Jul 2020 17:21:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLrHgtMmv=N-DwJR_1LDVXdu-5=A1-LMAOUbzpcuCa8cA@mail.gmail.com>
Message-ID: <CAL_JsqLrHgtMmv=N-DwJR_1LDVXdu-5=A1-LMAOUbzpcuCa8cA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Will Deacon <will@kernel.org>,
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

On Wed, Jul 29, 2020 at 10:38 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Fri, Jul 17, 2020 at 02:52:33PM -0600, Rob Herring wrote:
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index ce3080834bfa..ce5b0d9b12bf 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -46,6 +46,17 @@
> >  #define read_sysreg_el2(r)   read_sysreg_elx(r, _EL2, _EL1)
> >  #define write_sysreg_el2(v,r)        write_sysreg_elx(v, r, _EL2, _EL1)
> >
> > +static inline u64 __hyp_text read_sysreg_par(void)
> > +{
> > +     u64 par;
> > +     if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > +             dmb(sy);
> > +     par = read_sysreg(par_el1);
> > +     if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > +             dmb(sy);
> > +     return par;
> > +}
>
> Even if that's not always called on a critical path, I agree with Andrew
> that we could use alternatives here for dmb(sy).

His suggestion in the KVM code was to use cpus_have_final_cap() rather
than cpus_have_const_cap. But given it's just a dmb or nop,
alternatives is a better choice for all of these?

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index baf5ce9225ce..3f798e0f1419 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -94,10 +94,16 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
> >       case TPIDR_EL1:         *val = read_sysreg_s(SYS_TPIDR_EL1);    break;
> >       case AMAIR_EL1:         *val = read_sysreg_s(SYS_AMAIR_EL12);   break;
> >       case CNTKCTL_EL1:       *val = read_sysreg_s(SYS_CNTKCTL_EL12); break;
> > -     case PAR_EL1:           *val = read_sysreg_s(SYS_PAR_EL1);      break;
> >       case DACR32_EL2:        *val = read_sysreg_s(SYS_DACR32_EL2);   break;
> >       case IFSR32_EL2:        *val = read_sysreg_s(SYS_IFSR32_EL2);   break;
> >       case DBGVCR32_EL2:      *val = read_sysreg_s(SYS_DBGVCR32_EL2); break;
> > +     case PAR_EL1:
> > +             if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > +                     dmb(sy);
> > +             *val = read_sysreg_s(SYS_PAR_EL1);
> > +             if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > +                     dmb(sy);
> > +             break;
> >       default:                return false;
> >       }
>
> Can't we use read_sysreg_par() directly here?

I assumed read_sysreg_s() was used here for some reason instead of
read_sysreg()?

> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 8afb238ff335..98609532e61a 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -260,7 +260,17 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
> >       local_irq_save(flags);
> >       asm volatile("at s1e1r, %0" :: "r" (addr));
> >       isb();
> > +     /*
> > +      * Arm Erratum 1508412 requires dmb(sy) before and after reads of
> > +      * PAR_EL1.
> > +      * As this location is not a hot path, just condition it on the config
> > +      * option.
> > +      */
> > +     if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> > +             dmb(sy);
> >       par = read_sysreg(par_el1);
> > +     if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> > +             dmb(sy);
> >       local_irq_restore(flags);
>
> Why not read_sysreg_par()?

Okay with read_sysreg_par() going in asm/sysreg.h instead? I was
hesitant to add it there as there didn't seem to be any other
instances of a function for a specific register there.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
