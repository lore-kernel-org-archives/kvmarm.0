Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0952C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 14:32:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04709408D1;
	Mon, 21 Feb 2022 09:32:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yUUTAywXIylR; Mon, 21 Feb 2022 09:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863F140B8D;
	Mon, 21 Feb 2022 09:32:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7548140B03
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 09:32:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R226rAXTvihI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 09:32:48 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E03D4408D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 09:32:47 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D8CB0B811C9;
 Mon, 21 Feb 2022 14:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ED4C340EB;
 Mon, 21 Feb 2022 14:32:41 +0000 (UTC)
Date: Mon, 21 Feb 2022 14:32:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 10/40] arm64/sme: Basic enumeration support
Message-ID: <YhOihgeVRTztfDqv@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-11-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-11-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On Mon, Feb 07, 2022 at 03:20:39PM +0000, Mark Brown wrote:
> diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
> index b72ff17d600a..5626cf208000 100644
> --- a/Documentation/arm64/elf_hwcaps.rst
> +++ b/Documentation/arm64/elf_hwcaps.rst
> @@ -259,6 +259,39 @@ HWCAP2_RPRES
>  
>      Functionality implied by ID_AA64ISAR2_EL1.RPRES == 0b0001.
>  
> +HWCAP2_SME
> +
> +    Functionality implied by ID_AA64PFR1_EL1.SME == 0b0001, as described
> +    by Documentation/arm64/sme.rst.
> +
> +HWCAP2_SME_I16I64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.I16I64 == 0b1111.
> +
> +HWCAP2_SME_F64F64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F64F64 == 0b1.
> +
> +HWCAP2_SME_I8I32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.I8I32 == 0b1111.
> +
> +HWCAP2_SME_F16F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F16F32 == 0b1.
> +
> +HWCAP2_SME_B16F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.B16F32 == 0b1.
> +
> +HWCAP2_SME_F32F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F32F32 == 0b1.
> +
> +HWCAP2_SME_FA64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.FA64 == 0b1.

More of a question for the libc people: should we drop the fine-grained
HWCAP corresponding to the new ID_AA64SMFR0_EL1 register (only keep
HWCAP2_SME) and get the user space to use the MRS emulation? Would any
ifunc resolver be affected?

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 64a748c2b351..2634e32bbfb9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -251,6 +251,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>  };
>  
>  static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_SME_SHIFT, 4, 0),

Shouldn't this field also be visible (if SME is enabled)?

> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 5280e098cfb5..576490be3c2b 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -987,6 +987,32 @@ void fpsimd_release_task(struct task_struct *dead_task)
>  
>  #endif /* CONFIG_ARM64_SVE */
>  
> +#ifdef CONFIG_ARM64_SME
> +
> +void sme_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
> +{
> +	/* Set priority for all PEs to architecturally defined minimum */
> +	write_sysreg_s(read_sysreg_s(SYS_SMPRI_EL1) & ~SMPRI_EL1_PRIORITY_MASK,
> +		       SYS_SMPRI_EL1);
> +
> +	/* Allow SME in kernel */
> +	write_sysreg(read_sysreg(CPACR_EL1) | CPACR_EL1_SMEN_EL1EN, CPACR_EL1);
> +	isb();
> +}
> +
> +/*
> + * This must be called after sme_kernel_enable(), we rely on the
> + * feature table being sorted to ensure this.
> + */
> +void fa64_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
> +{
> +	/* Allow use of FA64 */
> +	write_sysreg_s(read_sysreg_s(SYS_SMCR_EL1) | SMCR_ELx_FA64_MASK,
> +		       SYS_SMCR_EL1);
> +}
> +
> +#endif /* CONFIG_ARM64_SVE */

I think instead of worrying about the order, we could check the
sanitised register value in sme_kernel_enable() and set the FA64 bit.
Also to me 'fa64_kernel_enable' somehow implies that the kernel cares
about FA64 for itself but AFAICT we never run the kernel in streaming
mode.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
