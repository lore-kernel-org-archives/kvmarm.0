Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870ABC43460
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 17:45:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 023496135A
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 17:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 023496135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C244B52D;
	Thu, 20 May 2021 13:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o5NGo8oveDp0; Thu, 20 May 2021 13:45:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437C44B50E;
	Thu, 20 May 2021 13:45:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF6464B410
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 13:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f8S8LFVZoQc7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 13:45:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90E5C4B223
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 13:45:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AC0411B3;
 Thu, 20 May 2021 10:45:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6BF3F719;
 Thu, 20 May 2021 10:45:37 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: arm64: Handle physical FIQ as an IRQ while
 running a guest
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-3-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2311e75e-589c-4602-e81f-c639e7a33bd9@arm.com>
Date: Thu, 20 May 2021 18:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-3-maz@kernel.org>
Content-Language: en-US
Cc: Hector Martin <marcan@marcan.st>, kernel-team@android.com
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

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> As we we now entertain the possibility of FIQ being used on the host,
> treat the signalling of a FIQ while running a guest as an IRQ,
> causing an exit instead of a HYP panic.

I've mulling over this, and I can't find anything wrong with it. Any FIQs for
which there is no handler registered by the interrupt controller will panic in the
default_handle_fiq() FIQ handler, similar to the current KVM behaviour. And if
there is a handler registered (only AIC does it for now), then a FIQ will be
handled just like any other interrupt instead of KVM panic'ing when the host can
handle it just fine.

I've briefly considered creating a new return code from __kvm_vcpu_run,
ARM_EXCEPTION_FIQ, but I really don't see any reason for it, since it will serve
the same purpose as ARM_EXCEPTION_IRQ, which is to resume the guest without any
special exit handling.

It makes sense to me for KVM to handle FIQs just like IRQs, now that the kernel
treats them the same:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5f49df4ffdd8..9aa9b73475c9 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -76,6 +76,7 @@ el1_trap:
>  	b	__guest_exit
>  
>  el1_irq:
> +el1_fiq:
>  	get_vcpu_ptr	x1, x0
>  	mov	x0, #ARM_EXCEPTION_IRQ
>  	b	__guest_exit
> @@ -131,7 +132,6 @@ SYM_CODE_END(\label)
>  	invalid_vector	el2t_error_invalid
>  	invalid_vector	el2h_irq_invalid
>  	invalid_vector	el2h_fiq_invalid
> -	invalid_vector	el1_fiq_invalid
>  
>  	.ltorg
>  
> @@ -179,12 +179,12 @@ SYM_CODE_START(__kvm_hyp_vector)
>  
>  	valid_vect	el1_sync		// Synchronous 64-bit EL1
>  	valid_vect	el1_irq			// IRQ 64-bit EL1
> -	invalid_vect	el1_fiq_invalid		// FIQ 64-bit EL1
> +	valid_vect	el1_fiq			// FIQ 64-bit EL1
>  	valid_vect	el1_error		// Error 64-bit EL1
>  
>  	valid_vect	el1_sync		// Synchronous 32-bit EL1
>  	valid_vect	el1_irq			// IRQ 32-bit EL1
> -	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
> +	valid_vect	el1_fiq			// FIQ 32-bit EL1
>  	valid_vect	el1_error		// Error 32-bit EL1
>  SYM_CODE_END(__kvm_hyp_vector)
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
