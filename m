Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B857C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 18:57:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B907849F48;
	Thu, 10 Feb 2022 13:57:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yQcJMvrC4J8t; Thu, 10 Feb 2022 13:57:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C20B849F0C;
	Thu, 10 Feb 2022 13:57:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D01E249F09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 13:57:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WSz0nRhq440u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 13:57:36 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ACCF412FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 13:57:36 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id AC3CAB8271F;
 Thu, 10 Feb 2022 18:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D286C004E1;
 Thu, 10 Feb 2022 18:57:30 +0000 (UTC)
Date: Thu, 10 Feb 2022 18:57:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 08/40] arm64/sme: Manually encode SME instructions
Message-ID: <YgVgFq/mkPeABSyv@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-9-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-9-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:37PM +0000, Mark Brown wrote:
> As with SVE rather than impose ambitious toolchain requirements for SME
> we manually encode the few instructions which we require in order to
> perform the work the kernel needs to do. The instructions used to save
> and restore context are provided as assembler macros while those for
> entering and leaving streaming mode are done in asm volatile blocks
> since they are expected to be used from C.
> 
> We could do the SMSTART and SMSTOP operations with read/modify/write
> cycles on SVCR but using the aliases provided for individual field
> accesses should be slightly faster. These instructions are aliases for
> MSR but since our minimum toolchain requirements are old enough to mean
> that we can't use the sX_X_cX_cX_X form and they always use xzr rather
> than taking a value like write_sysreg_s() wants we just use .inst.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h       | 25 +++++++++++++
>  arch/arm64/include/asm/fpsimdmacros.h | 53 +++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index cb24385e3632..c90f7f99a768 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -249,6 +249,31 @@ static inline void sve_setup(void) { }
>  
>  #endif /* ! CONFIG_ARM64_SVE */
>  
> +#ifdef CONFIG_ARM64_SME
> +
> +static inline void sme_smstart_sm(void)
> +{
> +	asm volatile(".inst 0xd503437f");
> +}
> +
> +static inline void sme_smstop_sm(void)
> +{
> +	asm volatile(".inst 0xd503427f");
> +}
> +
> +static inline void sme_smstop(void)
> +{
> +	asm volatile(".inst 0xd503467f");
> +}

I think you can use xzr with __msr_s. It would be more consistent if we
had some sysregs defined to be used with __msr_s.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
