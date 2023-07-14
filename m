Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566F36FC8
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 10:55:23 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C91B51570;
	Fri, 14 Jul 2023 03:56:04 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70BB83F67D;
	Fri, 14 Jul 2023 03:55:21 -0700 (PDT)
Date: Fri, 14 Jul 2023 11:55:10 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Message-ID: <ZLEoL8NbvmRNysJF@monolith.localdoman>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-3-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617013138.1823-3-namit@vmware.com>

Hi,

On Sat, Jun 17, 2023 at 01:31:38AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> While no real problem was encountered, having an inline assembly without
> volatile keyword and output can allow the compiler to ignore it. And
> without a memory clobber, potentially reorder it.
> 
> Add volatile and memory clobber.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  lib/arm64/asm/mmu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 5c27edb..cf94403 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -14,7 +14,7 @@
>  static inline void flush_tlb_all(void)
>  {
>  	dsb(ishst);
> -	asm("tlbi	vmalle1is");

From the gas manual [1]:

"asm statements that have no output operands and asm goto statements, are
implicitly volatile."

Looks to me like both TLBIs fall into this category.

And I think the "memory" clobber is not needed because the dsb macro before and
after the TLBI already have it.

[1] https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#Volatile

Thanks,
Alex

> +	asm volatile("tlbi	vmalle1is" ::: "memory");
>  	dsb(ish);
>  	isb();
>  }
> @@ -23,7 +23,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
>  {
>  	unsigned long page = vaddr >> 12;
>  	dsb(ishst);
> -	asm("tlbi	vaae1is, %0" :: "r" (page));
> +	asm volatile("tlbi	vaae1is, %0" :: "r" (page) : "memory");
>  	dsb(ish);
>  	isb();
>  }
> -- 
> 2.34.1
> 
> 
