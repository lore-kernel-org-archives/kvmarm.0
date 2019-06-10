Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01584C31E44
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:38:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E19720820
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E19720820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF16E4A51E;
	Mon, 10 Jun 2019 12:38:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q6SOQn7iOlt9; Mon, 10 Jun 2019 12:38:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938194A4DF;
	Mon, 10 Jun 2019 12:38:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F8D54A4DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BklfdQD2OU-4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 12:38:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C30D4A4D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:38:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20C33337;
 Mon, 10 Jun 2019 09:38:35 -0700 (PDT)
Received: from [10.1.197.57] (bionic-guest.cambridge.arm.com [10.1.197.57])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AD963F246;
 Mon, 10 Jun 2019 09:38:33 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Skip more of the SError vaxorcism
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20190610163034.116151-1-james.morse@arm.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <54049114-9e59-dc1a-b355-6c3e7c0ab1f7@arm.com>
Date: Mon, 10 Jun 2019 17:38:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190610163034.116151-1-james.morse@arm.com>
Content-Language: en-GB
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi James,

On 10/06/2019 17:30, James Morse wrote:
> During __guest_exit() we need to consume any SError left pending by the
> guest so it doesn't contaminate the host. With v8.2 we use the
> ESB-instruction. For systems without v8.2, we use dsb+isb and unmask
> SError. We do this on every guest exit.
> 
> Use the same dsb+isr_el1 trick, this lets us know if an SError is pending
> after the dsb, allowing us to skip the isb and self-synchronising PSTATE
> write if its not.
> 
> This means SError remains masked during KVM's world-switch, so any SError
> that occurs during this time is reported by the host, instead of causing
> a hyp-panic.
> 
> If you give gcc likely()/unlikely() hints in an if() condition, it
> shuffles the generated assembly so that the likely case is immediately
> after the branch. Lets do the same here.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> This patch was previously posted as part of:
> [v1] https://lore.kernel.org/linux-arm-kernel/20190604144551.188107-1-james.morse@arm.com/
> 
>   arch/arm64/kvm/hyp/entry.S | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index a5a4254314a1..c2de1a1faaf4 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -161,18 +161,24 @@ alternative_if ARM64_HAS_RAS_EXTN
>   	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
>   1:	ret
>   alternative_else
> -	// If we have a pending asynchronous abort, now is the
> -	// time to find out. From your VAXorcist book, page 666:
> +	dsb	sy		// Synchronize against in-flight ld/st
> +	mrs	x2, isr_el1
> +	and	x2, x2, #(1<<8)	// ISR_EL1.A
> +	cbnz	x2, 2f

It doesn't appear that anyone cares much about x2 containing the masked 
value after returning, so is this just a needlessly long-form TBNZ?

Robin.

> +	ret
> +
> +2:
> +	// We know we have a pending asynchronous abort, now is the
> +	// time to flush it out. From your VAXorcist book, page 666:
>   	// "Threaten me not, oh Evil one!  For I speak with
>   	// the power of DEC, and I command thee to show thyself!"
>   	mrs	x2, elr_el2
> +alternative_endif
>   	mrs	x3, esr_el2
>   	mrs	x4, spsr_el2
>   	mov	x5, x0
>   
> -	dsb	sy		// Synchronize against in-flight ld/st
>   	msr	daifclr, #4	// Unmask aborts
> -alternative_endif
>   
>   	// This is our single instruction exception window. A pending
>   	// SError is guaranteed to occur at the earliest when we unmask
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
