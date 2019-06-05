Return-Path: <SRS0=9SrU=UE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B924C282DE
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 09:00:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ABE62075C
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 09:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ABE62075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A08B84A47E;
	Wed,  5 Jun 2019 05:00:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JqckQGHXkv7W; Wed,  5 Jun 2019 05:00:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7324A47A;
	Wed,  5 Jun 2019 05:00:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1014A3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 05:00:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c2HaZTySp1wP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jun 2019 05:00:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE0F44A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 05:00:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05B0AA78;
 Wed,  5 Jun 2019 02:00:25 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A5123F690;
 Wed,  5 Jun 2019 02:00:18 -0700 (PDT)
Subject: Re: [PATCH v1 2/6] KVM: arm64: Consume pending SError as early as
 possible
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20190604144551.188107-1-james.morse@arm.com>
 <20190604144551.188107-3-james.morse@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <e8a742cd-9b37-c4b3-f34a-4663081a8529@arm.com>
Date: Wed, 5 Jun 2019 10:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190604144551.188107-3-james.morse@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
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

Hi James,

On 04/06/2019 15:45, James Morse wrote:
> On systems with v8.2 we switch the 'vaxorcism' of guest SError with an
> alternative sequence that uses the ESB-instruction, then reads DISR_EL1.
> This saves the unmasking and re-masking of asynchronous exceptions.
> 
> We do this after we've saved the guest registers and restored the
> host's. Any SError that becomes pending due to this will be accounted
> to the guest, when it actually occurred during host-execution.
> 
> Move the ESB-instruction as early as possible. Any guest SError
> will become pending due to this ESB-instruction and then consumed to
> DISR_EL1 before the host touches anything.
> 

Since you're moving the ESB from a HAS_RAS alternative location to a
normal location, it might be worth noting in the commit message that the
ESB is a NOP when RAS is not implemented, to clarify that we are not
uselessly adding a barrier (or potentially undefined instruction).

> This lets us account for host/guest SError precisely on the guest
> exit exception boundary.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> N.B. ESB-instruction is a nop on CPUs that don't support it.
> 
>  arch/arm64/include/asm/kvm_asm.h | 2 +-
>  arch/arm64/kvm/hyp/entry.S       | 5 ++---
>  arch/arm64/kvm/hyp/hyp-entry.S   | 2 ++
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 9170c43b332f..5c9548ae8fa7 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -45,7 +45,7 @@
>   * Size of the HYP vectors preamble. kvm_patch_vector_branch() generates code
>   * that jumps over this.
>   */
> -#define KVM_VECTOR_PREAMBLE	4
> +#define KVM_VECTOR_PREAMBLE	8
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 93ba3d7ef027..7863ec5266e2 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -138,8 +138,8 @@ ENTRY(__guest_exit)
>  
>  alternative_if ARM64_HAS_RAS_EXTN
>  	// If we have the RAS extensions we can consume a pending error
> -	// without an unmask-SError and isb.
> -	esb
> +	// without an unmask-SError and isb. The ESB-instruction consumed any
> +	// pending guest error when we took the exception from the guest.
>  	mrs_s	x2, SYS_DISR_EL1
>  	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
>  	cbz	x2, 1f
> @@ -157,7 +157,6 @@ alternative_else
>  	mov	x5, x0
>  
>  	dsb	sy		// Synchronize against in-flight ld/st
> -	nop
>  	msr	daifclr, #4	// Unmask aborts
>  alternative_endif
>  
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 914036e6b6d7..b8d37a987b34 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -230,6 +230,7 @@ ENDPROC(\label)
>  .macro valid_vect target
>  	.align 7
>  661:
> +	esb

Having said the above, if the kernel is built without RAS support (you
have to disable some of options enabled by default to get to that) but
runs on a CPU that does have the RAS extention, should we execute a nop
instead of an esb (so have an alternative here)?

Also, when we have the smccc workaround installed we do two esb, is that
intentional/necessary?

Could we have only one esb at the start of hyp_ventry (and "only" 26
nops after it) for KVM_INDIRECT_VECTORS? Or does this not affect
performance that much to be of interest?

>  	stp	x0, x1, [sp, #-16]!
>  662:
>  	b	\target
> @@ -320,6 +321,7 @@ ENTRY(__bp_harden_hyp_vecs_end)
>  	.popsection
>  
>  ENTRY(__smccc_workaround_1_smc_start)
> +	esb
>  	sub	sp, sp, #(8 * 4)
>  	stp	x2, x3, [sp, #(8 * 0)]
>  	stp	x0, x1, [sp, #(8 * 2)]
> 

Thanks,

-- 
Julien Thierry
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
