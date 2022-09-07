Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CA1C38145
	for <kvmarm@archiver.kernel.org>; Wed,  7 Sep 2022 04:53:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92BEC4C08E;
	Wed,  7 Sep 2022 00:53:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4p5az3Bv7-8M; Wed,  7 Sep 2022 00:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 540A34C1EE;
	Wed,  7 Sep 2022 00:53:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CD74C08E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 00:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mXmPcs7-Z057 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2022 00:53:09 -0400 (EDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com
 [209.85.217.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D87034BBE1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 00:53:09 -0400 (EDT)
Received: by mail-vs1-f46.google.com with SMTP id c3so13745671vsc.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 21:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=IB8D7t/VEzk35ELr98MItPXiflxE6OsuKH8uCTmfVu0=;
 b=N1hXa/JWneN7X9IKmS2ao6iy9YLDaictBmMhbFg9cxBE0NkduKrzAFcYl/y/xmoyzt
 3xH52+Rrdxv1/XQHNpBESXIuZb04hiO8kTyT5HpGbf32y40cBBgBt72l7BapgBjNFcx4
 zS/Ng4Kpxj1EsZ9Umceh5gRXPh2dfwTZ3IN3pc46taHI4yt8KPpEz3UMHC8sFRmcJ4XB
 LaWRtRKHYlXpNuRfvtU8CSlYXws1Yfxg9QQxhizldcDJgXvUC00ImExcNMF6UMhuHW1B
 adGT/aC3XvK7X45UkNBLfAM5f6lPc59hCxPJh/Li/4DwqzGSDk9ihVf/C0ZcVmCBFcAp
 Y8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=IB8D7t/VEzk35ELr98MItPXiflxE6OsuKH8uCTmfVu0=;
 b=dbAjo+R9pN/qQCNmkTHeRrYse+b0JcndxVWa52un1b80gpwYULJ+LmKKPE8Xb1PgrX
 r8Aijn1EpJ1V8V5sozeH6oIOdtq8Vz5yQk8nzY0FP8eT7j8/hwsyEbcHQ8c+BcFNgk54
 yvndKSxvAainFomAxJWCkIjQgW5fNsqYGWXHXW0u05lOU00KN0iYfT34cOrEe0UWEi49
 PxtkBJarSAV2bpY6t38qEa9dbaLYQPqO3AhxPrd728mvPUtUUDemF9bjgiGpeN5+Oz0C
 WvmsJhUSp62nJpZC5FMP/SinGXAMQbUYWiOaUnDEp1KWfpy6gyM1ZBfP5SBZBzQT8Qrd
 TN9A==
X-Gm-Message-State: ACgBeo1EXkyCPDYQjcDzUzVYbLgkoizWQ/kJ8FGul0qt9xXS8uV3csyw
 PtSM3fZjbrQolCLGf8RHhWpxi4BkAQ4WQVAlvdCZ5A==
X-Google-Smtp-Source: AA6agR4rCcd4O9978QvJHzO0pfaEsiyK7hjVqXjHxCjrcSZ0IqTMgr7I9V1ZuIniIvotAbRsX7V2bCI8HVlzNIUociw=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr514173vse.9.1662526389280; Tue, 06 Sep
 2022 21:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-7-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-7-oliver.upton@linux.dev>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 6 Sep 2022 21:52:53 -0700
Message-ID: <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> One of the oddities of the architecture is that the AArch64 views of the
> AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any EL.
> Nonetheless, KVM exposes these registers to userspace for the sake of
> save/restore. It is possible that the UNKNOWN value could differ between
> systems, leading to a rejected write from userspace.
>
> Avoid the issue altogether by handling the AArch32 ID registers as
> RAZ/WI when on an AArch64-only system.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 63 ++++++++++++++++++++++++++-------------
>  1 file changed, 43 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6d0511247df4..9569772cf09a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1144,6 +1144,20 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
> +                                      const struct sys_reg_desc *r)
> +{
> +       /*
> +        * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
> +        * EL. Promote to RAZ/WI in order to guarantee consistency between
> +        * systems.
> +        */
> +       if (!kvm_supports_32bit_el0())
> +               return REG_RAZ | REG_USER_WI;
> +
> +       return id_visibility(vcpu, r);
> +}
> +
>  static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *r)
>  {
> @@ -1331,6 +1345,15 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>         .visibility = id_visibility,            \
>  }
>
> +/* sys_reg_desc initialiser for known cpufeature ID registers */
> +#define AA32_ID_SANITISED(name) {              \
> +       SYS_DESC(SYS_##name),                   \
> +       .access = access_id_reg,                \
> +       .get_user = get_id_reg,                 \
> +       .set_user = set_id_reg,                 \
> +       .visibility = aa32_id_visibility,       \
> +}
> +
>  /*
>   * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
>   * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
> @@ -1418,33 +1441,33 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>         /* AArch64 mappings of the AArch32 ID registers */
>         /* CRm=1 */
> -       ID_SANITISED(ID_PFR0_EL1),
> -       ID_SANITISED(ID_PFR1_EL1),
> -       ID_SANITISED(ID_DFR0_EL1),
> +       AA32_ID_SANITISED(ID_PFR0_EL1),
> +       AA32_ID_SANITISED(ID_PFR1_EL1),
> +       AA32_ID_SANITISED(ID_DFR0_EL1),
>         ID_HIDDEN(ID_AFR0_EL1),
> -       ID_SANITISED(ID_MMFR0_EL1),
> -       ID_SANITISED(ID_MMFR1_EL1),
> -       ID_SANITISED(ID_MMFR2_EL1),
> -       ID_SANITISED(ID_MMFR3_EL1),
> +       AA32_ID_SANITISED(ID_MMFR0_EL1),
> +       AA32_ID_SANITISED(ID_MMFR1_EL1),
> +       AA32_ID_SANITISED(ID_MMFR2_EL1),
> +       AA32_ID_SANITISED(ID_MMFR3_EL1),
>
>         /* CRm=2 */
> -       ID_SANITISED(ID_ISAR0_EL1),
> -       ID_SANITISED(ID_ISAR1_EL1),
> -       ID_SANITISED(ID_ISAR2_EL1),
> -       ID_SANITISED(ID_ISAR3_EL1),
> -       ID_SANITISED(ID_ISAR4_EL1),
> -       ID_SANITISED(ID_ISAR5_EL1),
> -       ID_SANITISED(ID_MMFR4_EL1),
> -       ID_SANITISED(ID_ISAR6_EL1),
> +       AA32_ID_SANITISED(ID_ISAR0_EL1),
> +       AA32_ID_SANITISED(ID_ISAR1_EL1),
> +       AA32_ID_SANITISED(ID_ISAR2_EL1),
> +       AA32_ID_SANITISED(ID_ISAR3_EL1),
> +       AA32_ID_SANITISED(ID_ISAR4_EL1),
> +       AA32_ID_SANITISED(ID_ISAR5_EL1),
> +       AA32_ID_SANITISED(ID_MMFR4_EL1),
> +       AA32_ID_SANITISED(ID_ISAR6_EL1),
>
>         /* CRm=3 */
> -       ID_SANITISED(MVFR0_EL1),
> -       ID_SANITISED(MVFR1_EL1),
> -       ID_SANITISED(MVFR2_EL1),
> +       AA32_ID_SANITISED(MVFR0_EL1),
> +       AA32_ID_SANITISED(MVFR1_EL1),
> +       AA32_ID_SANITISED(MVFR2_EL1),
>         ID_UNALLOCATED(3,3),
> -       ID_SANITISED(ID_PFR2_EL1),
> +       AA32_ID_SANITISED(ID_PFR2_EL1),
>         ID_HIDDEN(ID_DFR1_EL1),

Perhaps it might be better to handle ID_AFR0_EL1 and ID_DFR1_EL1
in the same way as the other AArch32 ID registers for consistency ?
(i.e. treat them RAZ/USER_WI instead of RAZ if kvm_supports_32bit_el0()
 is false instead of RAZ)

Thank you,
Reiji


> -       ID_SANITISED(ID_MMFR5_EL1),
> +       AA32_ID_SANITISED(ID_MMFR5_EL1),
>         ID_UNALLOCATED(3,7),
>
>         /* AArch64 ID registers */
> --
> 2.37.2.789.g6183377224-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
