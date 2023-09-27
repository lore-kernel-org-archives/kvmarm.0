Received: from out-206.mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CD31FCC
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 07:02:29 +0000 (UTC)
Date: Wed, 27 Sep 2023 07:02:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695798147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J/NkQrf917Vyjx9AgyGMqg2PAn7EJlOnWPmYiD9+8lA=;
	b=ppk3TYKD1+mhj6CzxF/W8NuWWgXi+sB3PxbrSBG99yK6K7/Xlp0O43QlfxMLZSrTd1pBqb
	5h4QvDNXZiphttmTdJqsenCSCd+g/VMunl1yJ4mNRBmnC0xKgYcF1Zuu93C9pUb/Rjv4U3
	ys/53utsncsY1k7VIZLIt4EUzRnGFvU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 06/13] KVM: arm64: Use LPA2 page-tables for stage2 if
 HW supports it
Message-ID: <ZRPTfptM8Ee0RVSm@linux.dev>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-7-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918065740.3670662-7-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 18, 2023 at 07:57:33AM +0100, Ryan Roberts wrote:

[...]

>  static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
>  {
> -	u64 pa = pte & KVM_PTE_ADDR_MASK;
> -
> -	if (PAGE_SHIFT == 16)
> -		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> +	u64 pa;
> +
> +	if (system_supports_lpa2()) {
> +		pa = pte & KVM_PTE_ADDR_MASK_LPA2;
> +		pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
> +	} else {
> +		pa = pte & KVM_PTE_ADDR_MASK;
> +		if (PAGE_SHIFT == 16)
> +			pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> +	}
>  
>  	return pa;
>  }
>  
>  static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
>  {
> -	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
> -
> -	if (PAGE_SHIFT == 16) {
> -		pa &= GENMASK(51, 48);
> -		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
> +	kvm_pte_t pte;
> +
> +	if (system_supports_lpa2()) {
> +		pte = pa & KVM_PTE_ADDR_MASK_LPA2;
> +		pa &= GENMASK(51, 50);
> +		pte |= FIELD_PREP(KVM_PTE_ADDR_51_50_LPA2, pa >> 50);
> +	} else {
> +		pte = pa & KVM_PTE_ADDR_MASK;
> +		if (PAGE_SHIFT == 16) {
> +			pa &= GENMASK(51, 48);
> +			pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
> +		}
>  	}

These accessors are common between stage-1 and stage-2 walks... Aren't
bits [9:8] of the descriptor still being used to encode shareability for
hyp stage-1 at this point?

You may as well squash the subsequent patch (LPA2 format for S1) into this
one such that the change is atomic.

-- 
Thanks,
Oliver
