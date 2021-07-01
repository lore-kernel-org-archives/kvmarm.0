Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BBAC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:25:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED39561418
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED39561418
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01474A98B;
	Thu,  1 Jul 2021 09:25:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NVAkxzf620vq; Thu,  1 Jul 2021 09:25:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808D84AEF8;
	Thu,  1 Jul 2021 09:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 661A64A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qr0012ycQl43 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:25:02 -0400 (EDT)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com
 [209.85.210.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55D934A98B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:25:02 -0400 (EDT)
Received: by mail-ot1-f43.google.com with SMTP id
 7-20020a9d0d070000b0290439abcef697so6514676oti.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 06:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hraBInRNxPgdnbUbMg0qrqax/fr5kijfG4UaFdWb7BE=;
 b=irFqnuywbLSAokHXkS/wK61T/mygsiXIUO7uXOhZaGZTUB1TOAmTOxE2N5E/IxAQiU
 TrV/NMFqTwKQxydLqUimJkd1AQE9XbMZglLbz2n1gIn6eSy6eJtz/HqOjQMjVsYfzzMD
 IVXHHPoOkJi2oPpyEi/H1Ezw8w+MtR3glpkyOrnC0lbvALUIcQXzksP5ixPdalhdUhhX
 lH9PmMdOqPx+eGfDwb/JWInQflonLGx2mMJrJc8DLDMmkVtYbqNVZWh0Vwe91tLT9ZFX
 8d57IFh9PpWku+jBUusr/FYJhs0dEw01Dh6774lK+RRLce8QRvuTnvzu4YKlu4tqWBP7
 igzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hraBInRNxPgdnbUbMg0qrqax/fr5kijfG4UaFdWb7BE=;
 b=mB3ZpnV8jAhc9Zt6zRKgW2PcXftaZ37tmm1RQjJbsBUjA2WGhO+24gv+ZpNhQt/0BW
 4JNCrEBRr5uzNpNRK3YfQd7n824pyEbXY9JHsH8GMLJRB++UjLLyMrtBl1Zuk9Vqn+w6
 nU0QSmEk/BlGRiBwNBR6Itsclv2duswmnBuJkgtqenbCPbkCkHSEcy0PMoFJVTl0ITAe
 qJFynblAhOnJGnX97YUujICZi9pY5ZJ2i3F8YSO43P64mSePPoMdoFKvi8xw/Pgcb/a+
 GPVemm88T6gKZeBrLbDJa+t7dCsJLUfG1klAU+pbCYMezh85zcwvA/a4nj5RdQvgDm1N
 nlzQ==
X-Gm-Message-State: AOAM532XPkfD5GqGK0+XbR7B613YqZcJwNLcb7+X8q9o/uIN48EMaZhI
 SMM5+ug5mgYsdYXvVmvt8c0qGxpcwPL60G+o452Lew==
X-Google-Smtp-Source: ABdhPJzlXLgqaANV6pZoXRl/E2Qhat/JRkTnMfbvN/lBw5fcXa7R8iRew0/Lw2QoXMgoqflPNvYiACCIRnRclJgMVJs=
X-Received: by 2002:a05:6830:1de2:: with SMTP id
 b2mr13983035otj.365.1625145901605; 
 Thu, 01 Jul 2021 06:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-3-tabba@google.com>
 <20210701125329.GA9757@willie-the-truck>
In-Reply-To: <20210701125329.GA9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 14:24:25 +0100
Message-ID: <CA+EHjTz13dgJYSgVYwjiG89bhnNbXbJJAiY559yZRa0N=A50Cw@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: MDCR_EL2 is a 64-bit register
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

On Thu, Jul 1, 2021 at 1:53 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:39PM +0100, Fuad Tabba wrote:
> > Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
> > More recent features (e.g., FEAT_SPEv1p2) use bits above 31.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
> >  arch/arm64/include/asm/kvm_asm.h   |  2 +-
> >  arch/arm64/include/asm/kvm_host.h  |  2 +-
> >  arch/arm64/kvm/debug.c             |  5 +++--
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
> >  arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
> >  6 files changed, 17 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 692c9049befa..25d8a61888e4 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -280,18 +280,18 @@
> >  /* Hyp Debug Configuration Register bits */
> >  #define MDCR_EL2_E2TB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2TB_SHIFT  (UL(24))
> > -#define MDCR_EL2_TTRF                (1 << 19)
> > -#define MDCR_EL2_TPMS                (1 << 14)
> > +#define MDCR_EL2_TTRF                (UL(1) << 19)
> > +#define MDCR_EL2_TPMS                (UL(1) << 14)
> >  #define MDCR_EL2_E2PB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2PB_SHIFT  (UL(12))
> > -#define MDCR_EL2_TDRA                (1 << 11)
> > -#define MDCR_EL2_TDOSA               (1 << 10)
> > -#define MDCR_EL2_TDA         (1 << 9)
> > -#define MDCR_EL2_TDE         (1 << 8)
> > -#define MDCR_EL2_HPME                (1 << 7)
> > -#define MDCR_EL2_TPM         (1 << 6)
> > -#define MDCR_EL2_TPMCR               (1 << 5)
> > -#define MDCR_EL2_HPMN_MASK   (0x1F)
> > +#define MDCR_EL2_TDRA                (UL(1) << 11)
> > +#define MDCR_EL2_TDOSA               (UL(1) << 10)
> > +#define MDCR_EL2_TDA         (UL(1) << 9)
> > +#define MDCR_EL2_TDE         (UL(1) << 8)
> > +#define MDCR_EL2_HPME                (UL(1) << 7)
> > +#define MDCR_EL2_TPM         (UL(1) << 6)
> > +#define MDCR_EL2_TPMCR               (UL(1) << 5)
> > +#define MDCR_EL2_HPMN_MASK   (UL(0x1F))
>
> Personally, I prefer to use the BIT() macro for these things, but what
> you've got here is consistent with the rest of the file and I think that's
> more important.
>
> >  /* For compatibility with fault code shared with 32-bit */
> >  #define FSC_FAULT    ESR_ELx_FSC_FAULT
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 5e9b33cbac51..d88a5550552c 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -209,7 +209,7 @@ extern u64 __vgic_v3_read_vmcr(void);
> >  extern void __vgic_v3_write_vmcr(u32 vmcr);
> >  extern void __vgic_v3_init_lrs(void);
> >
> > -extern u32 __kvm_get_mdcr_el2(void);
> > +extern u64 __kvm_get_mdcr_el2(void);
> >
> >  #define __KVM_EXTABLE(from, to)                                              \
> >       "       .pushsection    __kvm_ex_table, \"a\"\n"                \
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5645af2a1431..45fdd0b7063f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -286,7 +286,7 @@ struct kvm_vcpu_arch {
> >
> >       /* HYP configuration */
> >       u64 hcr_el2;
> > -     u32 mdcr_el2;
> > +     u64 mdcr_el2;
> >
> >       /* Exception Information */
> >       struct kvm_vcpu_fault_info fault;
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index d5e79d7ee6e9..f7385bfbc9e4 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -21,7 +21,7 @@
> >                               DBG_MDSCR_KDE | \
> >                               DBG_MDSCR_MDE)
> >
> > -static DEFINE_PER_CPU(u32, mdcr_el2);
> > +static DEFINE_PER_CPU(u64, mdcr_el2);
> >
> >  /**
> >   * save/restore_guest_debug_regs
> > @@ -154,7 +154,8 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> >
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  {
> > -     unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
> > +     unsigned long mdscr;
> > +     u64 orig_mdcr_el2 = vcpu->arch.mdcr_el2;
>
> This is arm64 code, so 'unsigned long' is fine here and you can leave the
> existing code as-is.

I'll keep the existing code as it is.

Thanks,
/fuad


> With that:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
