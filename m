Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCEDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 18:55:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E4B40431;
	Tue, 22 Feb 2022 13:55:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zufpoE1+xy14; Tue, 22 Feb 2022 13:55:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D77249ED1;
	Tue, 22 Feb 2022 13:55:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF5649E3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:55:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WfRgck7yIe-6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 13:55:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 152CB40431
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 13:55:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60D2D1042;
 Tue, 22 Feb 2022 10:55:05 -0800 (PST)
Received: from lakrids (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15A843F66F;
 Tue, 22 Feb 2022 10:55:02 -0800 (PST)
Date: Tue, 22 Feb 2022 18:55:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kalesh Singh <kaleshsingh@google.com>
Subject: Re: [PATCH v2 4/9] KVM: arm64: Add guard pages for pKVM (protected
 nVHE) hypervisor stack
Message-ID: <YhUxhEHNKlqip51u@lakrids>
References: <20220222165212.2005066-1-kaleshsingh@google.com>
 <20220222165212.2005066-5-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220222165212.2005066-5-kaleshsingh@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 Pasha Tatashin <pasha.tatashin@soleen.com>, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
 surenb@google.com
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

On Tue, Feb 22, 2022 at 08:51:05AM -0800, Kalesh Singh wrote:
> Maps the stack pages in the flexible private VA range and allocates
> guard pages below the stack as unbacked VA space. The stack is aligned
> to twice its size to aid overflow detection (implemented in a subsequent
> patch in the series).
> 
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/setup.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 27af337f9fea..69df21320b09 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -105,11 +105,28 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
>  		if (ret)
>  			return ret;
>  
> -		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va;
> +		/*
> +		 * Private mappings are allocated upwards from __io_map_base
> +		 * so allocate the guard page first then the stack.
> +		 */
> +		start = (void *)pkvm_alloc_private_va_range(PAGE_SIZE, PAGE_SIZE);
> +		if (IS_ERR_OR_NULL(start))
> +			return PTR_ERR(start);

As on a prior patch, this usage of PTR_ERR() pattern is wrong when the
ptr is NULL.

> +		/*
> +		 * The stack is aligned to twice its size to facilitate overflow
> +		 * detection.
> +		 */
> +		end = (void *)per_cpu_ptr(&kvm_init_params, i)->stack_pa;
>  		start = end - PAGE_SIZE;
> -		ret = pkvm_create_mappings(start, end, PAGE_HYP);
> -		if (ret)
> -			return ret;
> +		start = (void *)__pkvm_create_private_mapping((phys_addr_t)start,
> +					PAGE_SIZE, PAGE_SIZE * 2, PAGE_HYP);
> +		if (IS_ERR_OR_NULL(start))
> +			return PTR_ERR(start);

Likewise.

Thanks,
Mark.

> +		end = start + PAGE_SIZE;
> +
> +		/* Update stack_hyp_va to end of the stack's private VA range */
> +		per_cpu_ptr(&kvm_init_params, i)->stack_hyp_va = (unsigned long) end;
>  	}
>  
>  	/*
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
