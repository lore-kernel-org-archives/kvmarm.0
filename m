Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D0FC388F9
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 11:58:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3AD55206C0
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 11:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljrPPUWk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AD55206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB5C4B9C8;
	Wed, 11 Nov 2020 06:58:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YvrTkQjuU1dP; Wed, 11 Nov 2020 06:58:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 682F94B9A1;
	Wed, 11 Nov 2020 06:58:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA564B993
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 06:58:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WaWq6JlV9tUD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 06:58:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8288C4B93D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 06:58:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 09EB2206C0;
 Wed, 11 Nov 2020 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605095879;
 bh=/7MRKKrDUo9TycWnJXr7Tsd8o8HUKPY81SVaBRioCQc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ljrPPUWknrN67qmN6o3dYPupqKXGt4q5z7HxVWgxg4G8OfSP0YyMkyuCzFg82EJDV
 0o8sZhTLg/84fuGkZDgxHPGAH8RBOoyj+g8tOZW+ywIIriq/M0jIUO3FH7/WNsEGFM
 AtK/GwJYxxubqR9ciVnLX2+NRPlNlbYv0G0hRl3Y=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcol9-009kX5-Tc; Wed, 11 Nov 2020 11:57:56 +0000
MIME-Version: 1.0
Date: Wed, 11 Nov 2020 11:57:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 13/24] kvm: arm64: Add CPU entry point in nVHE hyp
In-Reply-To: <20201109113233.9012-14-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-14-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7b8f9dec846f172c2919e1d3f3c65245@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On 2020-11-09 11:32, David Brazdil wrote:
> When nVHE hyp starts interception host's PSCI CPU_ON SMCs, it will need
> to install KVM on the newly booted CPU before returning to the host. 
> Add
> an entry point which expects the same kvm_nvhe_init_params struct as 
> the
> __kvm_hyp_init HVC in the CPU_ON context argument (x0).
> 
> The entry point initializes EL2 state with the same init_el2_state 
> macro
> used by the kernel's entry point. It then initializes KVM using the 
> same
> helper function used in the __kvm_hyp_init HVC.
> 
> When done, the entry point branches to a function provided in the init
> params.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/kernel/asm-offsets.c    |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h 
> b/arch/arm64/include/asm/kvm_asm.h
> index 893327d1e449..efb4872bb29f 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -155,6 +155,7 @@ struct kvm_nvhe_init_params {
>  	unsigned long tpidr_el2;
>  	unsigned long hyp_stack_ptr;
>  	unsigned long vector_ptr;
> +	unsigned long psci_cpu_entry_fn;
>  };
> 
>  /* Translate a kernel address @ptr into its equivalent linear mapping 
> */
> diff --git a/arch/arm64/kernel/asm-offsets.c 
> b/arch/arm64/kernel/asm-offsets.c
> index 0cbb86135c7c..ffc84e68ad97 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -114,6 +114,7 @@ int main(void)
>    DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params,
> tpidr_el2));
>    DEFINE(NVHE_INIT_STACK_PTR,	offsetof(struct kvm_nvhe_init_params,
> hyp_stack_ptr));
>    DEFINE(NVHE_INIT_VECTOR_PTR,	offsetof(struct kvm_nvhe_init_params,
> vector_ptr));
> +  DEFINE(NVHE_INIT_PSCI_CPU_ENTRY_FN,	offsetof(struct
> kvm_nvhe_init_params, psci_cpu_entry_fn));
>  #endif
>  #ifdef CONFIG_CPU_PM
>    DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 1697d25756e9..f999a35b2c8c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -6,6 +6,7 @@
> 
>  #include <linux/arm-smccc.h>
>  #include <linux/linkage.h>
> +#include <linux/irqchip/arm-gic-v3.h>

This should probably be included from the file that provides 
init_el2_state.

> 
>  #include <asm/alternative.h>
>  #include <asm/assembler.h>
> @@ -159,6 +160,35 @@ alternative_else_nop_endif
>  	ret
>  SYM_CODE_END(___kvm_hyp_init)
> 
> +SYM_CODE_START(__kvm_hyp_cpu_entry)
> +	msr	SPsel, #1			// We want to use SP_EL{1,2}
> +
> +	/*
> +	 * Check that the core was booted in EL2. Loop indefinitely if not
> +	 * because it cannot be safely given to the host without installing 
> KVM.
> +	 */
> +	mrs	x1, CurrentEL
> +	cmp	x1, #CurrentEL_EL2
> +	b.ne	.

This is a bit brutal. Consider using a WFE/WFI loop as we have in other
places already (see __secondary_too_slow for example).

> +
> +	/* Initialize EL2 CPU state to sane values. */
> +	mov	x29, x0
> +	init_el2_state nvhe
> +	mov	x0, x29
> +
> +	/*
> +	 * Load hyp VA of C entry function. Must do so before switching on 
> the
> +	 * MMU because the struct pointer is PA and not identity-mapped in 
> hyp.
> +	 */
> +	ldr	x29, [x0, #NVHE_INIT_PSCI_CPU_ENTRY_FN]
> +
> +	/* Enable MMU, set vectors and stack. */
> +	bl	___kvm_hyp_init
> +
> +	/* Leave idmap. */
> +	br	x29

To a point I made against an earlier patch: psci_cpu_entry_fn seems to 
be a HYP
VA, and really needs to be documented as such, because this is pretty 
hard to
follow otherwise.

> +SYM_CODE_END(__kvm_hyp_cpu_entry)
> +
>  SYM_CODE_START(__kvm_handle_stub_hvc)
>  	cmp	x0, #HVC_SOFT_RESTART
>  	b.ne	1f

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
