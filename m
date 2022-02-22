Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2D8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 18:32:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B0E41016;
	Tue, 22 Feb 2022 13:32:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3-kQLjTJBiLp; Tue, 22 Feb 2022 13:32:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCA0B49B07;
	Tue, 22 Feb 2022 13:32:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8395243C96
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:32:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rz9HAN6r+Q1N for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 13:32:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9060041014
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:32:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C95D1139F;
 Tue, 22 Feb 2022 10:32:37 -0800 (PST)
Received: from lakrids (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61EB33F66F;
 Tue, 22 Feb 2022 10:32:35 -0800 (PST)
Date: Tue, 22 Feb 2022 18:32:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 5/9] arm64: asm: Introduce test_sp_overflow macro
Message-ID: <YhUsQZUqgb94EjmD@lakrids>
References: <20220222165212.2005066-1-kaleshsingh@google.com>
 <20220222165212.2005066-6-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220222165212.2005066-6-kaleshsingh@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, surenb@google.com
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

On Tue, Feb 22, 2022 at 08:51:06AM -0800, Kalesh Singh wrote:
> From: Quentin Perret <qperret@google.com>
> 
> The asm entry code in the kernel uses a trick to check if VMAP'd stacks
> have overflowed by aligning them at THREAD_SHIFT * 2 granularity and
> checking the SP's THREAD_SHIFT bit.
> 
> Protected KVM will soon make use of a similar trick to detect stack
> overflows, so factor out the asm code in a re-usable macro.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> [Kalesh - Resolve minor conflicts]
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/include/asm/assembler.h | 11 +++++++++++
>  arch/arm64/kernel/entry.S          |  7 +------
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index e8bd0af0141c..ad40eb0eee83 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -850,4 +850,15 @@ alternative_endif
>  
>  #endif /* GNU_PROPERTY_AARCH64_FEATURE_1_DEFAULT */
>  
> +/*
> + * Test whether the SP has overflowed, without corrupting a GPR.
> + */
> +.macro test_sp_overflow shift, label
> +	add	sp, sp, x0			// sp' = sp + x0
> +	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
> +	tbnz	x0, #\shift, \label
> +	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
> +	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
> +.endm

I'm a little unhappy about factoring this out, since it's not really
self-contained and leaves sp and x0 partially-swapped when it branches
to the label. You can't really make that clear with comments on the
macro, and you need comments at each use-sire, so I'd ratehr we just
open-coded a copy of this.

> +
>  #endif	/* __ASM_ASSEMBLER_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 772ec2ecf488..ce99ee30c77e 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -53,15 +53,10 @@ alternative_else_nop_endif
>  	sub	sp, sp, #PT_REGS_SIZE
>  #ifdef CONFIG_VMAP_STACK
>  	/*
> -	 * Test whether the SP has overflowed, without corrupting a GPR.
>  	 * Task and IRQ stacks are aligned so that SP & (1 << THREAD_SHIFT)
>  	 * should always be zero.
>  	 */
> -	add	sp, sp, x0			// sp' = sp + x0
> -	sub	x0, sp, x0			// x0' = sp' - x0 = (sp + x0) - x0 = sp
> -	tbnz	x0, #THREAD_SHIFT, 0f
> -	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
> -	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
> +	test_sp_overflow THREAD_SHIFT, 0f
>  	b	el\el\ht\()_\regsize\()_\label
>  
>  0:

Further to my comment above, immediately after this we have:

	/* Stash the original SP (minus PT_REGS_SIZE) in tpidr_el0. */
	msr     tpidr_el0, x0

	/* Recover the original x0 value and stash it in tpidrro_el0 */
	sub     x0, sp, x0
	msr     tpidrro_el0, x0

... which is really surprising with the `test_sp_overflow` macro because
it's not clear that modifies x0 and sp in this way.

Thanks,
Mark.
... 

> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
