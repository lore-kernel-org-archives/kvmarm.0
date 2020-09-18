Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42377C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:00:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79900206CA
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9klp6VK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79900206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9AFD4B11C;
	Fri, 18 Sep 2020 05:00:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id diHqm01DFEXA; Fri, 18 Sep 2020 05:00:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2FC4B3CA;
	Fri, 18 Sep 2020 05:00:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C934B3B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:00:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysloNkoZHAaZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:00:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61B614B3B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:00:37 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D0321206A2;
 Fri, 18 Sep 2020 09:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600419636;
 bh=sS/8JplItwCkNumUCLY99BH14edEVQTYTremro9k1ME=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=F9klp6VKy8shxMeV/bDmXMBg3ofKSjRpH4tdqrVKH1LrGLV9TccfTOUMlrhr+G1Gl
 6V3E69YQT+H4Im6IjvaccSBO6ynmITyjQP4mexV9Bmlt5X6ewG/7ktNFxSLWjyByVy
 1J5MMiWmq0aFOUX0SXu4MhTS0BC6MBgYHi5WTy3I=
Date: Fri, 18 Sep 2020 10:00:30 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 04/11] kvm: arm64: Remove __hyp_this_cpu_read
Message-ID: <20200918090029.GC30834@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-5-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-5-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Sep 16, 2020 at 06:34:32PM +0100, David Brazdil wrote:
> this_cpu_ptr is meant for use in kernel proper because it selects between
> TPIDR_EL1/2 based on nVHE/VHE. __hyp_this_cpu_ptr was used in hyp to always
> select TPIDR_EL2. Unify all users behind this_cpu_ptr and friends by
> selecting _EL2 register under __KVM_VHE/NVHE_HYPERVISOR__.
> 
> Under CONFIG_DEBUG_PREEMPT, the kernel helpers perform a preemption check
> which is omitted by the hyp helpers. Preserve the behavior for nVHE by
> overriding the corresponding macros under __KVM_NVHE_HYPERVISOR__. Extend
> the checks into VHE hyp code.
> 
> Acked-by: Andrew Scull <ascull@google.com>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h          | 20 --------------
>  arch/arm64/include/asm/percpu.h           | 33 +++++++++++++++++++++--
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 +--
>  arch/arm64/kvm/hyp/include/hyp/switch.h   |  8 +++---
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c           |  2 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 +--
>  7 files changed, 41 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index c085032e2e3e..c196eec25498 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -143,26 +143,6 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
>  		addr;							\
>  	})
>  
> -/*
> - * Home-grown __this_cpu_{ptr,read} variants that always work at HYP,
> - * provided that sym is really a *symbol* and not a pointer obtained from
> - * a data structure. As for SHIFT_PERCPU_PTR(), the creative casting keeps
> - * sparse quiet.
> - */
> -#define __hyp_this_cpu_ptr(sym)						\
> -	({								\
> -		void *__ptr;						\
> -		__verify_pcpu_ptr(&sym);				\
> -		__ptr = hyp_symbol_addr(sym);				\
> -		__ptr += read_sysreg(tpidr_el2);			\
> -		(typeof(sym) __kernel __force *)__ptr;			\
> -	 })
> -
> -#define __hyp_this_cpu_read(sym)					\
> -	({								\
> -		*__hyp_this_cpu_ptr(sym);				\
> -	 })
> -
>  #define __KVM_EXTABLE(from, to)						\
>  	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
>  	"	.align		3\n"					\
> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
> index 0b6409b89e5e..36f304401c38 100644
> --- a/arch/arm64/include/asm/percpu.h
> +++ b/arch/arm64/include/asm/percpu.h
> @@ -19,7 +19,21 @@ static inline void set_my_cpu_offset(unsigned long off)
>  			:: "r" (off) : "memory");
>  }
>  
> -static inline unsigned long __my_cpu_offset(void)
> +static inline unsigned long __hyp_my_cpu_offset(void)
> +{
> +	unsigned long off;
> +
> +	/*
> +	 * We want to allow caching the value, so avoid using volatile and
> +	 * instead use a fake stack read to hazard against barrier().
> +	 */

I don't think we need to copy/paste the comment...

> +	asm("mrs %0, tpidr_el2" : "=r" (off) :
> +		"Q" (*(const unsigned long *)current_stack_pointer));

... especially given that we're not preemptible at EL2 with nVHE, maybe
we don't need to play this trick at all because we're always going to be
on the same CPU. So we could actually just do:

	return read_sysreg(tpidr_el2);

which is much better, and the comment should say something to that effect.

> +
> +	return off;
> +}
> +
> +static inline unsigned long __kern_my_cpu_offset(void)
>  {
>  	unsigned long off;
>  
> @@ -35,7 +49,12 @@ static inline unsigned long __my_cpu_offset(void)
>  
>  	return off;
>  }
> -#define __my_cpu_offset __my_cpu_offset()
> +
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +#define __my_cpu_offset __hyp_my_cpu_offset()

Why would VHE code need to use this? Especially in light of my preemption
comments above, shouldn't it now be using __kern_my_cpu_offset()?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
