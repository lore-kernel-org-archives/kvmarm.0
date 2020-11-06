Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6F3C4741F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 15:30:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8580F22202
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 15:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8580F22202
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4DF14B87A;
	Fri,  6 Nov 2020 10:30:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TUcFWABNBgji; Fri,  6 Nov 2020 10:30:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948364B869;
	Fri,  6 Nov 2020 10:30:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D664B869
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 10:30:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Su-iF6FMTex7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 10:30:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ADAB4B811
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 10:30:10 -0500 (EST)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@misterjones.org>)
 id 1kb3gc-008Eeb-Vr; Fri, 06 Nov 2020 15:29:59 +0000
MIME-Version: 1.0
Date: Fri, 06 Nov 2020 15:29:58 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 3/5] ARM: implement support for SMCCC TRNG entropy
 source
In-Reply-To: <20201105125656.25259-4-andre.przywara@arm.com>
References: <20201105125656.25259-1-andre.przywara@arm.com>
 <20201105125656.25259-4-andre.przywara@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7b36daa49c78d60dc788bbb3c9c1bdaa@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, will@kernel.org,
 catalin.marinas@arm.com, ardb@kernel.org, linux@armlinux.org.uk,
 lorenzo.pieralisi@arm.com, linus.walleij@linaro.org,
 linux-kernel@vger.kernel.org, broonie@kernel.org, sudeep.holla@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-05 12:56, Andre Przywara wrote:
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
> ---
>  arch/arm/Kconfig                  |  4 ++
>  arch/arm/include/asm/archrandom.h | 64 +++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fe2f17eb2b50..06fda4f954fd 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1667,6 +1667,10 @@ config STACKPROTECTOR_PER_TASK
>  	  Enable this option to switch to a different method that uses a
>  	  different canary value for each task.
> 
> +config ARCH_RANDOM
> +	def_bool y
> +	depends on HAVE_ARM_SMCCC
> +
>  endmenu
> 
>  menu "Boot options"
> diff --git a/arch/arm/include/asm/archrandom.h
> b/arch/arm/include/asm/archrandom.h
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
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_VERSION, &res);
> +	if ((s32)res.a0 < 0)
> +		return false;
> +	if (res.a0 >= ARM_SMCCC_TRNG_MIN_VERSION) {
> +		/* double check that the 32-bit flavor is available */
> +		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_FEATURES,
> +				     ARM_SMCCC_TRNG_RND32,
> +				     &res);
> +		if ((s32)res.a0 >= 0)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static inline bool __must_check arch_get_random_long(unsigned long *v)
> +{
> +	return false;
> +}
> +
> +static inline bool __must_check arch_get_random_int(unsigned int *v)
> +{
> +	return false;
> +}
> +
> +static inline bool __must_check arch_get_random_seed_long(unsigned 
> long *v)
> +{
> +	struct arm_smccc_res res;
> +
> +	if (smccc_trng_available) {
> +		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND32, 8 * sizeof(*v), &res);
> +
> +		if (res.a0 != 0)
> +			return false;
> +
> +		*v = res.a3;
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static inline bool __must_check arch_get_random_seed_int(unsigned int 
> *v)
> +{
> +	return arch_get_random_seed_long((unsigned long *)v);

I don't think this cast is safe. At least not on 64bit.

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
