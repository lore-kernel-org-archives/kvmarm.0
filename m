Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A5EC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 12:02:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AE5364EDD
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 12:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AE5364EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DBDA4B56F;
	Mon, 15 Mar 2021 08:02:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XHRfH4slkJtP; Mon, 15 Mar 2021 08:02:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4104C4B4F3;
	Mon, 15 Mar 2021 08:02:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DFF64B4F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 08:02:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aYbIiv9uBn4Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 08:02:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE6D84B48E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 08:02:47 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DC164ED2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615809766;
 bh=pKDYtf7UiwMwhGb5OugYKdHJp6nVCYTST0NZnpxnYBI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=BQTMIuMkB1PrjurJ/suYgZwYbr4chEt2an6hzna72s6isJoMCGrvDJzqTNOZDmfjf
 3TOGYvcAslkb0dox05Y24f9KWHtkxX+M5eeFYMFeoAT4apDJYPB83F6lTCSqoGbNIP
 9urQiWBwjVcemXMOHTvkN5wBE0d+NXrGog2Tivj06XcZ6t6OxYrGSQrBEMxv4kDHr0
 n2thsTzBAftIDKE8E6iUg7zkz1Jayy48+7tWLT061NZXgEKLdBTt0HETBzMFkjlnvn
 3wMIK1FEPuJHu4+WVWyOWQghpjbQIcEvkW1IiLfkvbUKBhsVmuZK9QibmEFPLtkXRQ
 FQimQ28uewQpw==
Received: by mail-ot1-f47.google.com with SMTP id
 68-20020a9d0f4a0000b02901b663e6258dso4972688ott.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:02:46 -0700 (PDT)
X-Gm-Message-State: AOAM533i7qLlc2FR05rbjymcel1zf9akz41Sapuf6ghvdXbw0Yj5Kabm
 4Zr/gXcNuJfKVMxM6clghHFas0oPlxU90I3WBvs=
X-Google-Smtp-Source: ABdhPJx2aURTMFTXLhyY55yp8MnoGqDYXpEXtgJR6ZHPoqFptGwVbX8S62S/rOtwe+2lwHUXYTIM0xwmHDboagQSrE8=
X-Received: by 2002:a9d:6e15:: with SMTP id e21mr13669773otr.77.1615809765969; 
 Mon, 15 Mar 2021 05:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210106103453.152275-1-andre.przywara@arm.com>
 <20210106103453.152275-4-andre.przywara@arm.com>
In-Reply-To: <20210106103453.152275-4-andre.przywara@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 15 Mar 2021 13:02:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXENEpQMWXCxDa28mC0qqNubVFE42VvLPm-NDWTOpRtUiQ@mail.gmail.com>
Message-ID: <CAMj1kXENEpQMWXCxDa28mC0qqNubVFE42VvLPm-NDWTOpRtUiQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] ARM: implement support for SMCCC TRNG entropy
 source
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Theodore Ts'o <tytso@mit.edu>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
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

On Wed, 6 Jan 2021 at 11:35, Andre Przywara <andre.przywara@arm.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Implement arch_get_random_seed_*() for ARM based on the firmware
> or hypervisor provided entropy source described in ARM DEN0098.
>
> This will make the kernel's random number generator consume entropy
> provided by this interface, at early boot, and periodically at
> runtime when reseeding.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> [Andre: rework to be initialised by the SMCCC firmware driver]
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I think this one could be dropped into rmk's patch tracker now, right?


> ---
>  arch/arm/Kconfig                  |  4 ++
>  arch/arm/include/asm/archrandom.h | 64 +++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 138248999df7..bfe642510b0a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1644,6 +1644,10 @@ config STACKPROTECTOR_PER_TASK
>           Enable this option to switch to a different method that uses a
>           different canary value for each task.
>
> +config ARCH_RANDOM
> +       def_bool y
> +       depends on HAVE_ARM_SMCCC_DISCOVERY
> +
>  endmenu
>
>  menu "Boot options"
> diff --git a/arch/arm/include/asm/archrandom.h b/arch/arm/include/asm/archrandom.h
> index a8e84ca5c2ee..f3e96a5b65f8 100644
> --- a/arch/arm/include/asm/archrandom.h
> +++ b/arch/arm/include/asm/archrandom.h
> @@ -2,9 +2,73 @@
>  #ifndef _ASM_ARCHRANDOM_H
>  #define _ASM_ARCHRANDOM_H
>
> +#ifdef CONFIG_ARCH_RANDOM
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/kernel.h>
> +
> +#define ARM_SMCCC_TRNG_MIN_VERSION     0x10000UL
> +
> +extern bool smccc_trng_available;
> +
> +static inline bool __init smccc_probe_trng(void)
> +{
> +       struct arm_smccc_res res;
> +
> +       arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_VERSION, &res);
> +       if ((s32)res.a0 < 0)
> +               return false;
> +       if (res.a0 >= ARM_SMCCC_TRNG_MIN_VERSION) {
> +               /* double check that the 32-bit flavor is available */
> +               arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_FEATURES,
> +                                    ARM_SMCCC_TRNG_RND32,
> +                                    &res);
> +               if ((s32)res.a0 >= 0)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
> +static inline bool __must_check arch_get_random_long(unsigned long *v)
> +{
> +       return false;
> +}
> +
> +static inline bool __must_check arch_get_random_int(unsigned int *v)
> +{
> +       return false;
> +}
> +
> +static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
> +{
> +       struct arm_smccc_res res;
> +
> +       if (smccc_trng_available) {
> +               arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND32, 8 * sizeof(*v), &res);
> +
> +               if (res.a0 != 0)
> +                       return false;
> +
> +               *v = res.a3;
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
> +{
> +       return arch_get_random_seed_long((unsigned long *)v);
> +}
> +
> +
> +#else /* !CONFIG_ARCH_RANDOM */
> +
>  static inline bool __init smccc_probe_trng(void)
>  {
>         return false;
>  }
>
> +#endif /* CONFIG_ARCH_RANDOM */
>  #endif /* _ASM_ARCHRANDOM_H */
> --
> 2.17.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
