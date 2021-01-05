Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C39BC43381
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 22:42:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 877B0230F9
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 22:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 877B0230F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F8A4B27B;
	Tue,  5 Jan 2021 17:42:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oVG-y7B3qjxW; Tue,  5 Jan 2021 17:42:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C29EF4B275;
	Tue,  5 Jan 2021 17:42:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8799B4B275
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 17:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSEocoBwsQkd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 17:42:20 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13ECD4B274
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 17:42:20 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id s26so2229284lfc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jan 2021 14:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8K2dvcU71/pwC4jHD+/NcfPpaQp8N4YqmX2cYFswaOA=;
 b=kK3zWPXdyTwPn82VV/feVszy0Lq50DMsPDdgRgcF1Wpq77EkMrDzcqnOXz/0nzGRfO
 x0IFp2wggLCsQrWnb8SRTsX/Vrx8VkIgg/Ylb1NZqnwdVr9WHwaQbPmpAkcqGa/PS/t7
 DCXi8Vf8l7bPZvFad4etuPwapVD45Yol+IDO0cfMQx/Zl5Lxy3ze3u3CvIZDHn0Q1VLY
 GiwREZwRmuEeL0eVTvqGxHKWTH+wnX8vR+BTG6Kv3fHV08fnBnndvUv+z/rvmDhJElcT
 PxJWTWY5XTMmat5xasDU6rV96z68nXhRmZq0rumnZsRhv2OnnoohBdvLU1YPi5oYoWah
 GMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8K2dvcU71/pwC4jHD+/NcfPpaQp8N4YqmX2cYFswaOA=;
 b=MzPbnNjIWUsY+RO46cZYzYvTRiQSPNsJpcMnCQ6FJodr9IjwBNzzbRkyeRsll0c3cf
 dBXzeQ74vHs4PdHl+Yj4kPRc0/Ssbp/Nol5vYhubtJ+SzLupYmBJBXv5dksYRu+R0z7j
 1nbANc6v1y/4MkZgCKxAa0Pq8zxqMbgWxmdKyehWjvkzdMRln0HLRWSFOE21PWjIUjlZ
 ch3uWCPv67C8WyczaXICe1z4VrLd5zwX7P2eQJ0Rw/Dcp0EUVDyhkKjQXwO6a5TU0Ab6
 GGI52E/i7QG12PvsLeuoQE/WAHC6PsyQ7a0hdkLNhIh9WhMUuLH+JCNOCzAS4COWJjm1
 2Qhg==
X-Gm-Message-State: AOAM533c6D11CMFPnJn4/gs4xaZBktVfgTauemDs6qfG4XxPufwkfYNH
 s5Bzryy9zshDj1lHPdVQMsdGz1Bjt0slwz7SSiRfmQ==
X-Google-Smtp-Source: ABdhPJxl91pFKLGKMJ2qJbq7uSrwslFYWBBcYxhh8yfs4emkwQTnkNoJxxJHYBFyu7OqqnU/vlBUeb6vbAfah5W7RYI=
X-Received: by 2002:a05:651c:48b:: with SMTP id
 s11mr759044ljc.28.1609886538340; 
 Tue, 05 Jan 2021 14:42:18 -0800 (PST)
MIME-Version: 1.0
References: <20210104135011.2063104-1-maz@kernel.org>
 <20210104135011.2063104-13-maz@kernel.org>
In-Reply-To: <20210104135011.2063104-13-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 5 Jan 2021 16:42:06 -0600
Message-ID: <CAAdAUtgdNyfq6wYi5mw4yBHKZ7UeSHdERxS=GYJFj=rBF0ZEDQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/17] arm64: Allow ID_AA64MMFR1_EL1.VH to be
 overridden from the command line
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jan 4, 2021 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As we want to be able to disable VHE at runtime, let's match
> "id_aa64mmfr1.vh=" from the command line as an override.
> This doesn't have much effect yet as out boot code doesn't look
Typo: out -> our
> at the cpufeature, but only at the HW registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h |  3 +++
>  arch/arm64/kernel/cpufeature.c      |  6 +++++-
>  arch/arm64/kernel/idreg-override.c  | 12 ++++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 465d2cb63bfc..ef9487dfadca 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -813,6 +813,9 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
>         return 8;
>  }
>
> +extern u64 id_aa64mmfr1_val;
> +extern u64 id_aa64mmfr1_mask;
> +
>  u32 get_kvm_ipa_limit(void);
>  void dump_cpu_features(void);
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2dbfc0096b0d..623a74090c9e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -555,6 +555,9 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>
>  #define ARM64_FTR_REG(id, table) ARM64_FTR_REG_OVERRIDE(id, table, NULL, NULL)
>
> +u64 id_aa64mmfr1_val;
> +u64 id_aa64mmfr1_mask;
> +
>  static const struct __ftr_reg_entry {
>         u32                     sys_id;
>         struct arm64_ftr_reg    *reg;
> @@ -602,7 +605,8 @@ static const struct __ftr_reg_entry {
>
>         /* Op1 = 0, CRn = 0, CRm = 7 */
>         ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
> -       ARM64_FTR_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1),
> +       ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1,
> +                              &id_aa64mmfr1_val, &id_aa64mmfr1_mask),
>         ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
>
>         /* Op1 = 0, CRn = 1, CRm = 2 */
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 392f93b67103..75d9845f489b 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -10,6 +10,7 @@
>  #include <linux/libfdt.h>
>
>  #include <asm/cacheflush.h>
> +#include <asm/cpufeature.h>
>  #include <asm/setup.h>
>
>  struct reg_desc {
> @@ -22,7 +23,18 @@ struct reg_desc {
>         }                       fields[];
>  };
>
> +static const struct reg_desc mmfr1 __initdata = {
> +       .name           = "id_aa64mmfr1",
> +       .val            = &id_aa64mmfr1_val,
> +       .mask           = &id_aa64mmfr1_mask,
> +       .fields         = {
> +               { "vh", ID_AA64MMFR1_VHE_SHIFT },
> +               {}
> +       },
> +};
> +
>  static const struct reg_desc * const regs[] __initdata = {
> +       &mmfr1,
>  };
>
>  static int __init find_field(const char *cmdline, const struct reg_desc *reg,
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
