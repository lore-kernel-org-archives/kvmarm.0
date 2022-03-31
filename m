Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA003C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 31 Mar 2022 15:34:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D38040797;
	Thu, 31 Mar 2022 11:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZYLdDx28lfve; Thu, 31 Mar 2022 11:34:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D348640C31;
	Thu, 31 Mar 2022 11:34:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 687E34087B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 11:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QtpeAtRM99cx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 11:34:10 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C5BE40797
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 11:34:09 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id q11so29001743iod.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=R6qVglK0FzawAXT0u5ibNFLRdw4AR1UKBBbJVmhDGmw=;
 b=f12ZZUEl0m4XNN/vangV6Vr6v1IK2xC1y0f78ppu9bR4Qtu/4hbU7bfXFE6KbOoArQ
 +Mm0CuHBUdpXPTNte/WciKsKtHgb6w+Hj+7531DSKyEuvGGCRxUa+JKZv8FYwExwaG5X
 9ZPcXpqz9u1Y1KlPXSrsSFFR/YsngCCQzH9SC6PtB/ojuebV9c6LWk7VuM8qGbezBpM4
 XTv24iderEEW7syCge5Ihsvd+7Yr7pW2qpVV012o84iZ2D70X9Z6Wo/AyI5l13sOBDjP
 U0e0CqEyG8AO+aIRBSEyHHBdDO56V5rtfM9k+VWIAw0Bz+a3GBH18zLypYweYyUrXnrM
 Tq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=R6qVglK0FzawAXT0u5ibNFLRdw4AR1UKBBbJVmhDGmw=;
 b=YUHLM2gCqxQQO/FgaBQ+/AWv5JGWLcZJvgXIMzVPcpJrstSVxQolN2fYjpRRnjTRlD
 qtJCQIV1bL4AXu3Ggug5TnKesuAecdOO5GuxumWVD2JVAl85479szqF5T5s0KGuKWo/w
 whLErISK/dnE3QEISnmPlmSYu8UYQbRTP7gYAlpGrSvkTwI7uPL2Ja9fJpLE30jrYNaU
 TcojmcQt9rAhg46MraS1ptxn9QpQiZxpHaikbk9BzdvZ7e1dDwf6rweJXcPMCS3XkF+O
 ZeuAOTgp7WX3N0lhdYdTZAM2g4b+udT06Xk+qDAmt9p6nE+/uF21Cp4jPWTkGRIIADlW
 wN2g==
X-Gm-Message-State: AOAM531LERLhCRLpTLQKB8JUHuuuYI36v5oBEanOBbD13pK+oK7zK8kN
 IzIOzL6BTeiEXydlodD/q64VnQ==
X-Google-Smtp-Source: ABdhPJyDekBrm8Mb4uDZ8bLm4Yo7RYoSABckPoxXi5s6USil5NnmuontTT10XVUc64Tr+EazrPyeFA==
X-Received: by 2002:a02:aa0b:0:b0:317:c63a:6625 with SMTP id
 r11-20020a02aa0b000000b00317c63a6625mr3224223jam.222.1648740848931; 
 Thu, 31 Mar 2022 08:34:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 j9-20020a926e09000000b002c9f3388cd4sm1732964ilc.21.2022.03.31.08.34.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 31 Mar 2022 08:34:08 -0700 (PDT)
Date: Thu, 31 Mar 2022 15:34:04 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
Message-ID: <YkXJ7JyycOZyo+Ry@google.com>
References: <20220329011301.1166265-1-oupton@google.com>
 <20220329011301.1166265-2-oupton@google.com>
 <CAAeT=FwR_hy3kYn2SgHELWb4F9mUmRemXWxOoiF=H23q-gzEjw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwR_hy3kYn2SgHELWb4F9mUmRemXWxOoiF=H23q-gzEjw@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

On Wed, Mar 30, 2022 at 10:45:35PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
> >
> > KVM currently does not trap ID register accesses from an AArch32 EL1.
> > This is painful for a couple of reasons. Certain unimplemented features
> > are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
> > architecture to v8.0. Additionally, we attempt to paper over
> > heterogeneous systems by using register values that are safe
> > system-wide. All this hard work is completely sidestepped because KVM
> > does not set TID3 for AArch32 guests.
> >
> > Fix up handling of CP15 feature registers by simply rerouting to their
> > AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
> > to fix up the oddball CP10 feature registers still.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 66 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 66 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index dd34b5ab51d4..30771f950027 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2339,6 +2339,65 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
> >         return 1;
> >  }
> >
> > +static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
> > +
> > +/**
> > + * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
> > + *                            CRn=0, which corresponds to the AArch32 feature
> > + *                            registers.
> > + * @vcpu: the vCPU pointer
> > + * @params: the system register access parameters.
> > + *
> > + * Our cp15 system register tables do not enumerate the AArch32 feature
> > + * registers. Conveniently, our AArch64 table does, and the AArch32 system
> > + * register encoding can be trivially remapped into the AArch64 for the feature
> > + * registers: Append op0=3, leaving op1, CRn, CRm, and op2 the same.
> > + *
> > + * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-bit
> > + * System registers with (coproc=0b1111, CRn==c0)", read accesses from this
> > + * range are either UNKNOWN or RES0. Rerouting remains architectural as we
> > + * treat undefined registers in this range as RAZ.
> > + */
> > +static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
> > +                                  struct sys_reg_params *params)
> > +{
> > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > +       int ret = 1;
> > +
> > +       params->Op0 = 3;
> 
> Nit: Shouldn't we restore the original Op0 after emulate_sys_reg() ?
> (unhandled_cp_access() prints Op0. Restoring the original one
>  would be more robust against future changes)
> 
> > +
> > +       /*
> > +        * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
> > +        * Avoid conflicting with future expansion of AArch64 feature registers
> > +        * and simply treat them as RAZ here.
> > +        */
> > +       if (params->CRm > 3)
> > +               params->regval = 0;
> > +       else
> > +               ret = emulate_sys_reg(vcpu, params);
> > +
> > +       /* Treat impossible writes to RO registers as UNDEFINED */
> > +       if (params->is_write)
> 
> This checking can be done even before calling emulate_sys_reg().
> BTW, __access_id_reg() also injects UNDEFINED when p->is_write is true.
> 
> > +               unhandled_cp_access(vcpu, params);
> > +       else
> > +               vcpu_set_reg(vcpu, Rt, params->regval);
> > +
> > +       return ret;
> > +}
> > +
> > +/**
> > + * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
> > + *                       AArch32 ID register.
> > + * @params: the system register access parameters
> > + *
> > + * Note that CP15 ID registers where CRm=0 are excluded from this check, as they
> > + * are already correctly handled in the CP15 register table.
> 
> I don't think this is true for all of the registers:)
> I think at least some of them are not trapped (TCMTR, TLBTR,
> REVIDR, etc), and I don't think they are handled in the CP15
> register table.

Thanks for the review! This patch was a bit sloppy and indeed skipped a
few steps in the comments. I believe the only register in CRm=0 that is
trapped is actually CTR, hence the others are not present in the table.

I'll send out a v2 soon that addresses your feedback and the other
embarrasing omissions on my end :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
