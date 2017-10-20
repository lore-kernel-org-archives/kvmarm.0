From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/8] arm: KVM: Add optimized PIPT icache flushing
Date: Fri, 20 Oct 2017 17:27:12 +0100
Message-ID: <20171020162711.2mb2wyw5xqfhkc4o@lakrids.cambridge.arm.com>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
 <20171020154904.31427-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171020154904.31427-3-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Fri, Oct 20, 2017 at 04:48:58PM +0100, Marc Zyngier wrote:
> @@ -181,18 +185,40 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
>  		return;
>  	}
>  
> -	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
> +	/*
> +	 * CTR IminLine contains Log2 of the number of words in the
> +	 * cache line, so we can get the number of words as
> +	 * 2 << (IminLine - 1).  To get the number of bytes, we
> +	 * multiply by 4 (the number of bytes in a 32-bit word), and
> +	 * get 4 << (IminLine).
> +	 */
> +	iclsz = 4 << (read_cpuid(CPUID_CACHETYPE) & 0xf);
> +
>  	while (size) {
>  		void *va = kmap_atomic_pfn(pfn);
> +		void *end = va + PAGE_SIZE;
> +		void *addr = va;
>  
> -		__cpuc_coherent_user_range((unsigned long)va,
> -					   (unsigned long)va + PAGE_SIZE);
> +		do {
> +			write_sysreg(addr, ICIMVAU);
> +			addr += iclsz;
> +		} while (addr < end);
> +
> +		dsb(ishst);

I believe this needs to be ISH rather than ISHST.

Per, ARM DDI 0487B.b, page G3-4701, "G3.4 AArch32 cache and branch
predictor support":

    A DSB or DMB instruction intended to ensure the completion of cache
    maintenance instructions or branch predictor instructions must have
    an access type of both loads and stores.

> +		isb();
>  
>  		size -= PAGE_SIZE;
>  		pfn++;
>  
>  		kunmap_atomic(va);
>  	}
> +
> +	/* Check if we need to invalidate the BTB */
> +	if ((read_cpuid_ext(CPUID_EXT_MMFR1) >> 28) != 4) {
> +		write_sysreg(0, BPIALLIS);
> +		dsb(ishst);

Likewise here.

Otherwise, looks good!

Thanks,
Mark.

> +		isb();
> +	}
>  }
>  
>  static inline void __kvm_flush_dcache_pte(pte_t pte)
> -- 
> 2.14.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
