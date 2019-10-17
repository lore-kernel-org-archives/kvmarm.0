Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0045ECE58D
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 17:42:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A6F720820
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 17:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A6F720820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9B5A4A8BC;
	Thu, 17 Oct 2019 13:42:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GRhQNes2S+wH; Thu, 17 Oct 2019 13:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1994A8C4;
	Thu, 17 Oct 2019 13:42:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB094A898
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Oct 2019 13:42:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PB1OhZhinOrW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Oct 2019 13:41:59 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31A784A87D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Oct 2019 13:41:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A68E329;
 Thu, 17 Oct 2019 10:41:38 -0700 (PDT)
Received: from [10.1.196.105] (unknown [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 597AF3F718;
 Thu, 17 Oct 2019 10:41:37 -0700 (PDT)
Subject: Re: [PATCH] arm64: KVM: Invoke compute_layout() before alternatives
 are applied
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20191016165953.o6ogh4fdmsjmd2sw@linutronix.de>
From: James Morse <james.morse@arm.com>
Message-ID: <ecfbb413-e97e-c3eb-e051-1f218b387edd@arm.com>
Date: Thu, 17 Oct 2019 18:41:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016165953.o6ogh4fdmsjmd2sw@linutronix.de>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>
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

Hi Sebastian,

On 16/10/2019 17:59, Sebastian Andrzej Siewior wrote:
> compute_layout() is invoked as part of an alternative fixup under
> stop_machine(). This function invokes get_random_long() which acquires a
> sleeping lock on -RT which can not be acquired in this context.

> Rename compute_layout() to kvm_compute_layout() and invoke it before
> stop_machines() invokes the fixups.

Nit: stop_machine() applies the alternatives.


> Add a __init prefix to
> kvm_compute_layout() because the caller has it, too (and so the code can
> be discarded after boot).


> diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
> index b9f8d787eea9f..7532f044d713b 100644
> --- a/arch/arm64/include/asm/alternative.h
> +++ b/arch/arm64/include/asm/alternative.h
> @@ -35,6 +35,12 @@ void apply_alternatives_module(void *start, size_t length);
>  static inline void apply_alternatives_module(void *start, size_t length) { }
>  #endif
>  
> +#ifdef CONFIG_KVM_ARM_HOST
> +void kvm_compute_layout(void);
> +#else
> +static inline void kvm_compute_layout(void) { }
> +#endif

I don't think alternative.h is where this belongs... Could you move it to kvm_mmu.h, which
is where the kvm_update_va_mask macro that depends on it lives.

You can avoid the #ifdef if you use if(IS_ENABLED()) in the caller.
This has the advantage that the compiler will catch invalid C regardless of the build
options. (and its easier on the eye)


> diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
> index d1757ef1b1e74..c28652ee06f64 100644
> --- a/arch/arm64/kernel/alternative.c
> +++ b/arch/arm64/kernel/alternative.c
> @@ -238,6 +238,7 @@ static int __apply_alternatives_multi_stop(void *unused)
>  void __init apply_alternatives_all(void)
>  {
>  	/* better not try code patching on a live SMP system */
> +	kvm_compute_layout();
>  	stop_machine(__apply_alternatives_multi_stop, NULL, cpu_online_mask);
>  }

This is a funny place to do this kvm check, its not needed to apply the alternatives.

apply_alternatives_all() is only called from smp_cpus_done(), immediately before it calls
hyp_mode_check(), could we move it there to live with the 'started at EL2' message?

(to save you battling the header-jungle: To include asm/kvm_mmu.h, you need to include
linux/kvm_host.h first)


We end up calling it unconditionally, but I don't think that matters, both callers do the
right thing.

With that:
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
