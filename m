Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360D8C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 03:58:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 954484B175;
	Sun,  3 Apr 2022 23:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AtyL9L3A73zp; Sun,  3 Apr 2022 23:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B7F4B150;
	Sun,  3 Apr 2022 23:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8334B090
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 23:58:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ry+0OYbzmmn for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 23:58:05 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23F354A119
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 23:58:05 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id s8so7757379pfk.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2022 20:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PIS05ym5w1d+Mlq2cABcR0KR9m3g+YJtsa/sE4OhS2k=;
 b=AMK1z3WsncgnRYcnZkhTzdfB2tmThpo1J+RJmQF+9WzSoLI+bawDcdr/Ade56iAQBX
 i3+ZFq6PQM7ASZYAlLyuXNS9zkf3xNRY+s/gWnzzzbjLkp/RZs9axi/AGLV+s02n4a7R
 ULbkQuGHamOI5DhZ/7NfIUkgSueZ8cDF/5oakXvCaJvFf8h0PxskUuCovzTxfzx4oroM
 7xK+24d7heHb03MhTazG0mtjzS6VKOrdNtrgWDaIyKjFGcf8ZBmgl6hyD4sCsUotZhSc
 4aj4QB7APIZiuwdo7euIsYeCUhNnzS2puBHlg7pbXWA7gMYXYgItj9ecpwQMmWFOF2NS
 UI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PIS05ym5w1d+Mlq2cABcR0KR9m3g+YJtsa/sE4OhS2k=;
 b=n7zpEtjk77Nvrt7HGxdP3EBmf92vKXQnkgN23PPmz/VCOqur2oNLk1NJSACFhSlri0
 3Ma0lJH+xr1tICoUBb2suOhU+j6RQQqAg4gAu4C9l+DY4eAJs2tjOOzbf1LXBUGvyOah
 8/9IRZ7PBU+gAtdubkc5QivwIG9FgYS/OjyXYKe3yd3iUIQpJKrCS51D5zKyHT4vgtD0
 0apfTbmBbk6zdYQVZz83ChPDaQ4QeJectP0ugkidngUxHHA214Q1Y/woEH9hAGlhU531
 KIaN+WGj55sjqCljhlga3HhhZgTwgBM56u9maiQVbCT70oeLUs4TtlWLKOV5SIkBoUuJ
 zwIw==
X-Gm-Message-State: AOAM5312tR8vfc1d6X3aUgm1KsekwbkdIqAkldoRQCxPzr+rRpNikQBJ
 Dvb8oKTp16FDJweZQ6gP9Ioz2qD/qKPfI07KI0hYoz7olVBusA==
X-Google-Smtp-Source: ABdhPJwmoXhGeQNRDquyBYcS4RsvdcgA6YiyfzIFEASfaq4Kklv+UmNjM2R6OUs2nFFulBe2SAznKzgf7AgF8xCU67o=
X-Received: by 2002:a63:af47:0:b0:398:4be1:ce1d with SMTP id
 s7-20020a63af47000000b003984be1ce1dmr24515445pgo.514.1649044683975; Sun, 03
 Apr 2022 20:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
In-Reply-To: <20220401010832.3425787-3-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 3 Apr 2022 20:57:47 -0700
Message-ID: <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
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

On Thu, Mar 31, 2022 at 6:08 PM Oliver Upton <oupton@google.com> wrote:
>
> In order to enable HCR_EL2.TID3 for AArch32 guests KVM needs to handle
> traps where ESR_EL2.EC=0x8, which corresponds to an attempted VMRS
> access from an ID group register. Specifically, the MVFR{0-2} registers
> are accessed this way from AArch32. Conveniently, these registers are
> architecturally mapped to MVFR{0-2}_EL1 in AArch64. Furthermore, KVM
> already handles reads to these aliases in AArch64.
>
> Plumb VMRS read traps through to the general AArch64 system register
> handler.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/handle_exit.c      |  1 +
>  arch/arm64/kvm/sys_regs.c         | 61 +++++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0e96087885fe..7a65ac268a22 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -673,6 +673,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
>  int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
> +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 97fe14aab1a3..5088a86ace5b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -167,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>         [ESR_ELx_EC_CP15_64]    = kvm_handle_cp15_64,
>         [ESR_ELx_EC_CP14_MR]    = kvm_handle_cp14_32,
>         [ESR_ELx_EC_CP14_LS]    = kvm_handle_cp14_load_store,
> +       [ESR_ELx_EC_CP10_ID]    = kvm_handle_cp10_id,
>         [ESR_ELx_EC_CP14_64]    = kvm_handle_cp14_64,
>         [ESR_ELx_EC_HVC32]      = handle_hvc,
>         [ESR_ELx_EC_SMC32]      = handle_smc,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8b791256a5b4..4863592d060d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2341,6 +2341,67 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>
>  static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
>
> +/*
> + * The CP10 ID registers are architecturally mapped to AArch64 feature
> + * registers. Abuse that fact so we can rely on the AArch64 handler for accesses
> + * from AArch32.
> + */
> +static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *params)
> +{
> +       params->is_write = ((esr & 1) == 0);
> +       params->Op0 = 3;
> +       params->Op1 = 0;
> +       params->CRn = 0;
> +       params->CRm = 3;
> +
> +       switch ((esr >> 10) & 0xf) {
> +       /* MVFR0 */
> +       case 0b0111:
> +               params->Op2 = 0;
> +               break;
> +       /* MVFR1 */
> +       case 0b0110:
> +               params->Op2 = 1;
> +               break;
> +       /* MVFR2 */
> +       case 0b0101:
> +               params->Op2 = 2;
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       return true;
> +}
> +
> +/**
> + * kvm_handle_cp10_id() - Handles a VMRS trap on guest access to a 'Media and
> + *                       VFP Register' from AArch32.
> + * @vcpu: The vCPU pointer
> + *
> + * MVFR{0-2} are architecturally mapped to the AArch64 MVFR{0-2}_EL1 registers.
> + * Work out the correct AArch64 system register encoding and reroute to the
> + * AArch64 system register emulation.
> + */
> +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> +{
> +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> +       u32 esr = kvm_vcpu_get_esr(vcpu);
> +       struct sys_reg_params params;
> +       int ret;
> +
> +       /* UNDEF on any unhandled register or an attempted write */
> +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> +               kvm_inject_undefined(vcpu);

Nit: For debugging, it might be more useful to use unhandled_cp_access()
(, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
rather than directly calling kvm_inject_undefined().

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji



> +               return 1;
> +       }
> +
> +       ret = emulate_sys_reg(vcpu, &params);
> +
> +       vcpu_set_reg(vcpu, Rt, params.regval);
> +       return ret;
> +}
> +
>  /**
>   * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
>   *                            CRn=0, which corresponds to the AArch32 feature
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
