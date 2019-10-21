Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87404CA9EB0
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:43:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1AC4D20656
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 11:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AC4D20656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC704A9A9;
	Mon, 21 Oct 2019 07:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A-ZL97KEcnpG; Mon, 21 Oct 2019 07:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C304A9AE;
	Mon, 21 Oct 2019 07:43:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FAE24A9A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Gr8AWzIGMYq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 07:43:01 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B87F14A964
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 07:43:01 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMW5R-0002zr-A7; Mon, 21 Oct 2019 13:42:57 +0200
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 08/10] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 21 Oct 2019 12:42:57 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191011125930.40834-9-steven.price@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-9-steven.price@arm.com>
Message-ID: <099040bb979b7cb878a7f489033aacc7@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com,
 linux@armlinux.org.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 2019-10-11 13:59, Steven Price wrote:
> SMCCC 1.1 calls may use either HVC or SMC depending on the PSCI
> conduit. Rather than coding this in every call site provide a macro
> which uses the correct instruction. The macro also handles the case
> where no PSCI conduit is configured returning a not supported error
> in res, along with returning the conduit used for the call.
>
> This allow us to remove some duplicated code and will be useful later
> when adding paravirtualized time hypervisor calls.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Acked-by: Will Deacon <will@kernel.org>
> ---
>  include/linux/arm-smccc.h | 44 
> +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 5daf0e2adf47..fd84a9bfb455 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -303,6 +303,50 @@ asmlinkage void __arm_smccc_hvc(unsigned long
> a0, unsigned long a1,
>  #define SMCCC_RET_NOT_SUPPORTED			-1
>  #define SMCCC_RET_NOT_REQUIRED			-2
>
> +/* Like arm_smccc_1_1* but always returns SMCCC_RET_NOT_SUPPORTED.
> + * Used when the PSCI conduit is not defined. The empty asm 
> statement
> + * avoids compiler warnings about unused variables.

nit: comment style.

> + */
> +#define __fail_smccc_1_1(...)						\
> +	do {								\
> +		__declare_args(__count_args(__VA_ARGS__), __VA_ARGS__);	\
> +		asm ("" __constraints(__count_args(__VA_ARGS__)));	\
> +		if (___res)						\
> +			___res->a0 = SMCCC_RET_NOT_SUPPORTED;		\
> +	} while (0)
> +
> +/*
> + * arm_smccc_1_1_invoke() - make an SMCCC v1.1 compliant call
> + *
> + * This is a variadic macro taking one to eight source arguments, 
> and
> + * an optional return structure.
> + *
> + * @a0-a7: arguments passed in registers 0 to 7
> + * @res: result values from registers 0 to 3
> + *
> + * This macro will make either an HVC call or an SMC call depending 
> on the
> + * current PSCI conduit. If no valid conduit is available then -1
> + * (SMCCC_RET_NOT_SUPPORTED) is returned in @res.a0 (if supplied).
> + *
> + * The return value also provides the conduit that was used.
> + */
> +#define arm_smccc_1_1_invoke(...) ({					\
> +		int method = psci_ops.conduit;				\
> +		switch (method) {					\
> +		case PSCI_CONDUIT_HVC:					\
> +			arm_smccc_1_1_hvc(__VA_ARGS__);			\
> +			break;						\
> +		case PSCI_CONDUIT_SMC:					\
> +			arm_smccc_1_1_smc(__VA_ARGS__);			\
> +			break;						\
> +		default:						\
> +			__fail_smccc_1_1(__VA_ARGS__);			\
> +			method = PSCI_CONDUIT_NONE;			\
> +			break;						\
> +		}							\
> +		method;							\
> +	})
> +
>  /* Paravirtualised time calls (defined by ARM DEN0057A) */
>  #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\

All this should most probably go on top of the SMCCC conduit cleanup 
that
has already been already queued in the arm64 tree (see 
arm64/for-next/smccc-conduit-cleanup).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
