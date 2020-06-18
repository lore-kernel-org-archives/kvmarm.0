Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47D0C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 13:57:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B86C2082F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 13:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvEtPq7y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B86C2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A81284B18E;
	Thu, 18 Jun 2020 09:57:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KKX8c2J+f60w; Thu, 18 Jun 2020 09:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82AB14B197;
	Thu, 18 Jun 2020 09:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2B9C4B18E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 09:57:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIXwaiBjYAhq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 09:57:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E39214B147
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 09:57:48 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C69B12082F;
 Thu, 18 Jun 2020 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1592488667;
 bh=LnYEKbo5XLm8oVGmH1Jg4y8ZvUiouHun1liXREq5bac=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=BvEtPq7yWq1HoWLreLAPoRHu9zg2dv4gVjA+/sWolyzzhzCuYfusljrsDt7PCh1Rl
 8VzOVSWJVHPKOQf8ENECav3J03US/j4/DonegZKfy7eWRDwY3D9dWQ05qwLpA4LpOi
 HaPbrU2sScJRWJ14HAyMty8l/Dv/fn0Im1rhu9eQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jlv34-004BYE-2D; Thu, 18 Jun 2020 14:57:46 +0100
MIME-Version: 1.0
Date: Thu, 18 Jun 2020 14:57:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 02/15] arm64: kvm: Move __smccc_workaround_1_smc to
 .rodata
In-Reply-To: <20200618122537.9625-3-dbrazdil@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-3-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <02322fdac903aa1786c334d0ddd7f38a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 android-kvm@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi David,

On 2020-06-18 13:25, David Brazdil wrote:
> This snippet of assembly is used by cpu_errata.c to overwrite parts of 
> KVM hyp
> vector. Move it to its own source file and change its ELF section to 
> .rodata.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/Makefile    |  1 +
>  arch/arm64/kvm/hyp/hyp-entry.S | 16 ----------------
>  arch/arm64/kvm/hyp/smccc_wa.S  | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 31 insertions(+), 16 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/smccc_wa.S
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 8c9880783839..5d8357ddc234 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -7,6 +7,7 @@ ccflags-y += -fno-stack-protector 
> -DDISABLE_BRANCH_PROFILING \
>  		$(DISABLE_STACKLEAK_PLUGIN)
> 
>  obj-$(CONFIG_KVM) += hyp.o
> +obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
> 
>  hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o 
> sysreg-sr.o \
>  	 debug-sr.o entry.o switch.o fpsimd.o tlb.o hyp-entry.o
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S 
> b/arch/arm64/kvm/hyp/hyp-entry.S
> index 9c5cfb04170e..d362fad97cc8 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -318,20 +318,4 @@ SYM_CODE_START(__bp_harden_hyp_vecs)
>  1:	.org __bp_harden_hyp_vecs + __BP_HARDEN_HYP_VECS_SZ
>  	.org 1b
>  SYM_CODE_END(__bp_harden_hyp_vecs)
> -
> -	.popsection

I'd be tempted to leave the .popsection in place, if only for symmetry  
with the initial .pushsection.

> -
> -SYM_CODE_START(__smccc_workaround_1_smc)
> -	esb
> -	sub	sp, sp, #(8 * 4)
> -	stp	x2, x3, [sp, #(8 * 0)]
> -	stp	x0, x1, [sp, #(8 * 2)]
> -	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
> -	smc	#0
> -	ldp	x2, x3, [sp, #(8 * 0)]
> -	ldp	x0, x1, [sp, #(8 * 2)]
> -	add	sp, sp, #(8 * 4)
> -1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
> -	.org 1b
> -SYM_CODE_END(__smccc_workaround_1_smc)
>  #endif
> diff --git a/arch/arm64/kvm/hyp/smccc_wa.S 
> b/arch/arm64/kvm/hyp/smccc_wa.S
> new file mode 100644
> index 000000000000..aa25b5428e77
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/smccc_wa.S
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2015-2018 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
> + */
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_mmu.h>
> +
> +	/*
> +	 * This is not executed directly and is instead copied into the 
> vectors
> +	 * by install_bp_hardening_cb().
> +	 */
> +	.data
> +	.pushsection	.rodata
> +	.global		__smccc_workaround_1_smc
> +__smccc_workaround_1_smc:

You probably want to replace this with SYM_DATA_START (and SYM_DATA_END 
at the end).

> +	esb
> +	sub	sp, sp, #(8 * 4)
> +	stp	x2, x3, [sp, #(8 * 0)]
> +	stp	x0, x1, [sp, #(8 * 2)]
> +	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
> +	smc	#0
> +	ldp	x2, x3, [sp, #(8 * 0)]
> +	ldp	x0, x1, [sp, #(8 * 2)]
> +	add	sp, sp, #(8 * 4)
> +1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
> +	.org 1b

Otherwise, looks good.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
