Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FCAC43334
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jul 2022 06:13:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC0A4B77B;
	Fri,  8 Jul 2022 02:13:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FB6YHAh-R985; Fri,  8 Jul 2022 02:13:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A92394B594;
	Fri,  8 Jul 2022 02:13:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA61C4B594
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 02:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oyHG2hfmicyO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 02:13:52 -0400 (EDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D90004B577
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 02:13:52 -0400 (EDT)
Received: by mail-vs1-f43.google.com with SMTP id o13so20420739vsn.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2022 23:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9kdI7fJ9HKcnF+19AuXCv4R1tDk5TG26VjCxQHvO5u8=;
 b=YhLiZ57UkwJfno4mNVHsQc6j6NYYIB2FeqxM/ysU8y1foQ924puiAmNgczPDV842zx
 ZI8v8WIFjImHN0JgZQOzv7+pz0oqnfk5Ppni33ZKMaf6sKWpWjpWaPffdrUwwWOcjBia
 ZqKgv5zOcZCDbyw6pMHWMreNrWB2il8kUw73FgzugbWWwPYpO355dHFWQ1h+ndhhrvgj
 45xzhQhJTeJtQNaSXSvLp6sCN5H0QA0+xB1yguLGvuo2hTIdZ2UnCL/OUGjyV2juEWze
 GfmupVO2Ld9FTe8IrXo96KO4G+166D/b63z524NznPZtQp/BidA95aicX43e4Fa0XS9X
 LK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9kdI7fJ9HKcnF+19AuXCv4R1tDk5TG26VjCxQHvO5u8=;
 b=WwahqkYaXG76D7HbU0cWAbali7JRu0ZPqyMB+lXFrG7Hzot3fOR37G7p5RJxpuhkqx
 XAAcAQBxJcMjVwz/2/jXfpnH9bIZfVjrPfbTgYkL1jcVITNL0NaZDEE5uJdJR+czMrvM
 T3t+KusXPewUYIcGIGsID8jwIEQPLJlydmChLKoQrqgQKZEkx/Nv4WPdyXpRj40cHFBY
 elKiZXdThGoA/mofDfqbSUm4b4HaDvFjQizcy5w+/VVL+eG46Y5GyqwjwbsRvPjIVO2T
 yTSW/CuWOwCWXG+TXA3o9fnznJ3BGO2HWCD+cQLPtQMQ7HF6JRL1HPDpF7ODtZerNRGw
 W9uw==
X-Gm-Message-State: AJIora+EusdeWfbrh7m1EyKjBmFFQbVOch3EU3NLORp1KeQqTB3uXDeB
 LkCvG7tlNxpOoBMIjqm+Df9qQmsCJpgov6a8iHrVVw==
X-Google-Smtp-Source: AGRyM1suSrk/70+H5gMThZ7ls53+MmoXup9DqDwa+knSTDnqvGP4RjQRi4hofApOL600gSPxUjm6/FE2Hp6HIWpzha4=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr674569vsb.63.1657260832132; Thu, 07 Jul
 2022 23:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-5-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-5-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 7 Jul 2022 23:13:36 -0700
Message-ID: <CAAeT=Fz9+1=EV6fwqVMSncOj_9y7eRuuv1+P92MXbP1GOJeZaA@mail.gmail.com>
Subject: Re: [PATCH 04/19] KVM: arm64: Push checks for 64bit registers into
 the low-level accessors
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Marc,

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Make sure the check occurs on every paths where we can pick
> a sysreg from userspace, including the GICv3 paths.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0fbdb21a3600..89e7eddea937 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2656,6 +2656,10 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
>  {
>         struct sys_reg_params params;
>
> +       /* 64 bit is the only way */
> +       if (KVM_REG_SIZE(id) != sizeof(__u64))
> +               return NULL;

This doesn't seem to be necessary since the equivalent check
is done by index_to_params().

Thank you,
Reiji

> +
>         if (!index_to_params(id, &params))
>                 return NULL;
>
> @@ -2871,9 +2875,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>                 return demux_c15_get(reg->id, uaddr);
>
> -       if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
> -               return -ENOENT;
> -
>         err = get_invariant_sys_reg(reg->id, uaddr);
>         if (err != -ENOENT)
>                 return err;
> @@ -2906,9 +2907,6 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>                 return demux_c15_set(reg->id, uaddr);
>
> -       if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
> -               return -ENOENT;
> -
>         err = set_invariant_sys_reg(reg->id, uaddr);
>         if (err != -ENOENT)
>                 return err;
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
