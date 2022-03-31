Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2FAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 31 Mar 2022 05:45:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D75A4B224;
	Thu, 31 Mar 2022 01:45:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rU2fXdemlIQ2; Thu, 31 Mar 2022 01:45:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 133F34B1C0;
	Thu, 31 Mar 2022 01:45:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BABA4B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 01:45:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Q-C3mNPPHCC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 01:45:52 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 680F14B0FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 01:45:52 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 gp15-20020a17090adf0f00b001c7cd11b0b3so1633368pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2022 22:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3CahhRbHJliYCk8SCDDE9S8QhZBX4JDzO4bMq29WbPA=;
 b=DU1PRXajt9xwfySAfcfZDJAERfhEW5QUfqxmSWYqAe8ZqnbjXoU7T2y+cgjV03qCMI
 rOYQYaW0AmJDCDyzXzZEdGViZT3wYZxAp/nKOZ3hxuVIjfjltg5pIBj2CkhbJCRyOubT
 skipLBveK+Sq1QT60UKZh2/thi+U/sxFIfTTPhExIDyf6+gV07F3rZT16lhchjVO5ALC
 CFsr+AOZ7A6WKM8WQ+GCO8YM3P2JV3EeAL2zE7q6KcfBn/gno1I5TakOH2tUDCdMuFwY
 e3yL5g6+UoCGwO9sLnXj/JAQNNtHHbr1h6/uSBNcmKM48ajuRI6gdm4Lm/M+w6fdEV2X
 Xntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3CahhRbHJliYCk8SCDDE9S8QhZBX4JDzO4bMq29WbPA=;
 b=G0+LyYEanyGcaClgZZ/ybZliH3XzXHWUYiqjGk3GAJuFJVfEoYYJh6pHgw2wPlsJ5I
 T9LiANa4PQsUss3wFh1Hi3B1iq2qwc9sVjhO+h3sENbB2gDZQ2esVTACDhzSR+zdHs8W
 ql7WtnukE1FFArb85Y3t6KlkNZ4E7O+RCKQ5Qd+Z4br6IMYYm+qgHa3VUNcP4/Hc9Vqa
 eDAHAZEcWEKyj7Ui0FKXgI7dhvQPg1140hpBsmSXrOhDEGcsosUKP/bBzaIhUBDJyMb8
 qE1boXCHSyBZb/6zs+xyT0XvOZvT2m3iNpJg1WMLA61/BsqZamPRz+aVCG46YJkkHdTS
 T3xA==
X-Gm-Message-State: AOAM5335R6GVsRiXxehbrtuuIe+5EBuWlLUwoYYl93nR2Eox8fFWVA4t
 1MsILkvmmzMzbMzBlFK+/Ldb1yDyzTRCNpF5ajVeXA==
X-Google-Smtp-Source: ABdhPJwWSAFR9Xjp4XYSMhEU8GleXUItke2DRjJSACYT/izT484PG4Cixo6aO3WMmw4+zkFkm/aKPwA4OBzo/q5yowA=
X-Received: by 2002:a17:902:da88:b0:156:2b13:81c5 with SMTP id
 j8-20020a170902da8800b001562b1381c5mr3690705plx.138.1648705551272; Wed, 30
 Mar 2022 22:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
 <20220329011301.1166265-2-oupton@google.com>
In-Reply-To: <20220329011301.1166265-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 30 Mar 2022 22:45:35 -0700
Message-ID: <CAAeT=FwR_hy3kYn2SgHELWb4F9mUmRemXWxOoiF=H23q-gzEjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
To: Oliver Upton <oupton@google.com>
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

Hi Oliver,

On Mon, Mar 28, 2022 at 6:13 PM Oliver Upton <oupton@google.com> wrote:
>
> KVM currently does not trap ID register accesses from an AArch32 EL1.
> This is painful for a couple of reasons. Certain unimplemented features
> are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
> architecture to v8.0. Additionally, we attempt to paper over
> heterogeneous systems by using register values that are safe
> system-wide. All this hard work is completely sidestepped because KVM
> does not set TID3 for AArch32 guests.
>
> Fix up handling of CP15 feature registers by simply rerouting to their
> AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
> to fix up the oddball CP10 feature registers still.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 66 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dd34b5ab51d4..30771f950027 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2339,6 +2339,65 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>         return 1;
>  }
>
> +static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
> +
> +/**
> + * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
> + *                            CRn=0, which corresponds to the AArch32 feature
> + *                            registers.
> + * @vcpu: the vCPU pointer
> + * @params: the system register access parameters.
> + *
> + * Our cp15 system register tables do not enumerate the AArch32 feature
> + * registers. Conveniently, our AArch64 table does, and the AArch32 system
> + * register encoding can be trivially remapped into the AArch64 for the feature
> + * registers: Append op0=3, leaving op1, CRn, CRm, and op2 the same.
> + *
> + * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-bit
> + * System registers with (coproc=0b1111, CRn==c0)", read accesses from this
> + * range are either UNKNOWN or RES0. Rerouting remains architectural as we
> + * treat undefined registers in this range as RAZ.
> + */
> +static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
> +                                  struct sys_reg_params *params)
> +{
> +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> +       int ret = 1;
> +
> +       params->Op0 = 3;

Nit: Shouldn't we restore the original Op0 after emulate_sys_reg() ?
(unhandled_cp_access() prints Op0. Restoring the original one
 would be more robust against future changes)

> +
> +       /*
> +        * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
> +        * Avoid conflicting with future expansion of AArch64 feature registers
> +        * and simply treat them as RAZ here.
> +        */
> +       if (params->CRm > 3)
> +               params->regval = 0;
> +       else
> +               ret = emulate_sys_reg(vcpu, params);
> +
> +       /* Treat impossible writes to RO registers as UNDEFINED */
> +       if (params->is_write)

This checking can be done even before calling emulate_sys_reg().
BTW, __access_id_reg() also injects UNDEFINED when p->is_write is true.

> +               unhandled_cp_access(vcpu, params);
> +       else
> +               vcpu_set_reg(vcpu, Rt, params->regval);
> +
> +       return ret;
> +}
> +
> +/**
> + * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
> + *                       AArch32 ID register.
> + * @params: the system register access parameters
> + *
> + * Note that CP15 ID registers where CRm=0 are excluded from this check, as they
> + * are already correctly handled in the CP15 register table.

I don't think this is true for all of the registers:)
I think at least some of them are not trapped (TCMTR, TLBTR,
REVIDR, etc), and I don't think they are handled in the CP15
register table.

Thanks,
Reiji


> + */
> +static inline bool kvm_is_cp15_id_reg(struct sys_reg_params *params)
> +{
> +       return params->CRn == 0 && params->Op1 == 0 && params->CRm != 0;
> +}
> +
>  /**
>   * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
>   * @vcpu: The VCPU pointer
> @@ -2360,6 +2419,13 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
>         params.Op1 = (esr >> 14) & 0x7;
>         params.Op2 = (esr >> 17) & 0x7;
>
> +       /*
> +        * Certain AArch32 ID registers are handled by rerouting to the AArch64
> +        * system register table.
> +        */
> +       if (ESR_ELx_EC(esr) == ESR_ELx_EC_CP15_32 && kvm_is_cp15_id_reg(&params))
> +               return kvm_emulate_cp15_id_reg(vcpu, &params);
> +
>         if (!emulate_cp(vcpu, &params, global, nr_global)) {
>                 if (!params.is_write)
>                         vcpu_set_reg(vcpu, Rt, params.regval);
> --
> 2.35.1.1021.g381101b075-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
