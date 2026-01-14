Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB3E257845
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 09:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768382876; cv=none; b=GWnGH4mg/Q4b0H7t3HeLWvvNvHqCtHuORqxdrXKllp6VyJBZFkyKKkkvIC0vBjPDc9AG6/kWH+KCPIeELOLFkCSNVqFjOM9kNigqvv0VNmxPCQmn8hSIQD49w12LJ59qos6/jyNldMOD8o9bX+AQikX5mDtBYSL2ih7FcYDktLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768382876; c=relaxed/simple;
	bh=vT/SHrgrKq6WisSwZQKI5TBKlgZu6AE9Vrb37GEgtks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRZWFFhZ/gwRpJm34/9UVeLt4f50lB60Ph4XED2fESw4bjVIk7tAYguJx6feMVJgWilFjUpp+ncORZtoGLJzy0t4wxo5oDaFXndVCSCuQB6INThqFFzoLIggMcccKa3y1VSh0Hh50Vaby4RNG/Jv3/d7vWhgY6VSFks96Yn487g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CTe0721k; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CTe0721k"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-432d2c7a8b9so4658762f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 01:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768382870; x=1768987670; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kap4gu0a51WoqK/VPbkwUanlik+X2vGOaSYLGv2cqSA=;
        b=CTe0721kgFaSK8tlE6bs6uqk+a1dCJFIXsh7FX37uAwpchBynM/ZiBz34OaDjruNZO
         ysxjHRz0bDn3oi7sdOBar3J7RP6cv+HU5S5oR3rbUIa5989jM+urkhPitNf6uPFce82f
         6d09MjTOEhR45VUEPuNhqAvJVreLBJZXQIFKAR56vKUxZNxB9hKI6lZmGMGx+sXn6h8B
         jKkWP5nFeBlBcZ63hR6jFSOusR8rv0Q8Mnxl/69jGSKep2tnqMdNXYrAXHME47YSKh77
         2gvxUKuuDq9xZ2CAL0UScV8FSxZ0JofinACo1LgaLnaV4gcFX5FbNGHJri3Is7qOJWr1
         iT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768382870; x=1768987670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kap4gu0a51WoqK/VPbkwUanlik+X2vGOaSYLGv2cqSA=;
        b=tzGFwE4zjXPmOB69jluKN6MiC5nfRJ6dBhr7/AFUVWu6bCTEpbAgUGxq8d+sSzfrA6
         GQnfjHZ1h58RH5qtNuEIgA3b/T/sPnU7nekVukMRFZnXkVUUANeCAOCbzgUf/jbNdUzC
         oXOUjpmkJ8Ag1LMKG/y3Qo3Wcg/FOZ7syIYTR+WkMghGGwfCbsuxoDQbQvE4vQeBJ6lg
         37WsYkaNUlJf4uREPsrlIHR+FvzGMsUew3FVCknrIU24+4AYmFRh6uDErmggsNyrE9Uu
         +XEGjKJ3fIUExXettvgpJnA+EFh6Tcpai5mGkoGWw8xfAJ96Hxmk/kZY2vZ/1KU0kPTb
         Zf3Q==
X-Gm-Message-State: AOJu0YyLTONG+EY3OwCNBnrVQ8TcaNjPwB8sRSq5B0OaiVAtBbqvHLdo
	vnFF27tC3SaO+QbjjC1okWmCdrusP8Ubb1Znva1uDIWczdovN4tYjFcCutCSWsJZqw==
X-Gm-Gg: AY/fxX5xsodgOAafmnCSagbdz3hdpVQEzd62GGQuxbF0l4wok6vPAqSLaz3r2wKvfzm
	ILODVa9znf4xj9T7/OeOeeZa0uw97oTwDSeS3CUEoamNZo3U/QTbNoAiE+NQvwZeKuIsvjQX5on
	ivYIxIFZUrQTGqlfCJLhnmZkb2tOuoJ6ueeocGgQDbAATqXY68Z2mKiThQIvqmASlDAa6WGmP3r
	trMZZa3vw7gKmfb4zgqV2koS9JteynLjfAGQUvmpkYPL5HfeNx5H/6LvlIWEZmOpl6Hv4INzGdd
	CE9ScIptfjR9xc+htgYpaplB+Nvupj/WK1TgEH/CHg9eOH7HY4qIKv1ZdTFRZH0QAilndT6Omii
	0doOtgqwlELDx4P8q5+u8IQ3QXEVRBTyFcjyWEZTTjiv32XK4VVfjlbedNayLfAmUEsgt5tnn+6
	ZiActGcKeWNO2e8+2nrko8VHuoEHpzS6oGETJXsqVMuOsnOrdmDA==
X-Received: by 2002:a05:6000:2011:b0:431:4c6:724d with SMTP id ffacd0b85a97d-4342c5487f2mr2035382f8f.29.1768382870113;
        Wed, 14 Jan 2026 01:27:50 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df96asm48157294f8f.28.2026.01.14.01.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 01:27:49 -0800 (PST)
Date: Wed, 14 Jan 2026 09:27:46 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Petteri Kangaslampi <pekangas@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: Calculate hyp VA size only once
Message-ID: <aWdhkpXRLEek7AnL@google.com>
References: <20260113194409.2970324-1-pekangas@google.com>
 <20260113194409.2970324-2-pekangas@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113194409.2970324-2-pekangas@google.com>

On Tue, Jan 13, 2026 at 07:44:09PM +0000, Petteri Kangaslampi wrote:
> Calculate the hypervisor's VA size only once to maintain consistency
> between the memory layout and MMU initialization logic. Previously the
> two would be inconsistent when the kernel is configured for less than
> IDMAP_VA_BITS of VA space.
> 
> Signed-off-by: Petteri Kangaslampi <pekangas@google.com>

Tested-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_mmu.h |  3 ++-
>  arch/arm64/kvm/arm.c             |  4 ++--
>  arch/arm64/kvm/mmu.c             | 28 ++++-----------------------
>  arch/arm64/kvm/va_layout.c       | 33 +++++++++++++++++++++++++++-----
>  4 files changed, 36 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 2dc5e6e742bb..d968aca0461a 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -103,6 +103,7 @@ alternative_cb_end
>  void kvm_update_va_mask(struct alt_instr *alt,
>  			__le32 *origptr, __le32 *updptr, int nr_inst);
>  void kvm_compute_layout(void);
> +u32 kvm_hyp_va_bits(void);
>  void kvm_apply_hyp_relocations(void);
>  
>  #define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
> @@ -185,7 +186,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>  
>  phys_addr_t kvm_mmu_get_httbr(void);
>  phys_addr_t kvm_get_idmap_vector(void);
> -int __init kvm_mmu_init(u32 *hyp_va_bits);
> +int __init kvm_mmu_init(u32 hyp_va_bits);
>  
>  static inline void *__kvm_vector_slot2addr(void *base,
>  					   enum arm64_hyp_spectre_vector slot)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4f80da0c0d1d..4703f0e15102 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2568,7 +2568,7 @@ static void pkvm_hyp_init_ptrauth(void)
>  /* Inits Hyp-mode on all online CPUs */
>  static int __init init_hyp_mode(void)
>  {
> -	u32 hyp_va_bits;
> +	u32 hyp_va_bits = kvm_hyp_va_bits();
>  	int cpu;
>  	int err = -ENOMEM;
>  
> @@ -2582,7 +2582,7 @@ static int __init init_hyp_mode(void)
>  	/*
>  	 * Allocate Hyp PGD and setup Hyp identity mapping
>  	 */
> -	err = kvm_mmu_init(&hyp_va_bits);
> +	err = kvm_mmu_init(hyp_va_bits);
>  	if (err)
>  		goto out_err;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 48d7c372a4cd..d5a506c99f73 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2284,11 +2284,9 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
>  	.virt_to_phys		= kvm_host_pa,
>  };
>  
> -int __init kvm_mmu_init(u32 *hyp_va_bits)
> +int __init kvm_mmu_init(u32 hyp_va_bits)
>  {
>  	int err;
> -	u32 idmap_bits;
> -	u32 kernel_bits;
>  
>  	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
>  	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
> @@ -2302,25 +2300,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
>  	 */
>  	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
>  
> -	/*
> -	 * The ID map is always configured for 48 bits of translation, which
> -	 * may be fewer than the number of VA bits used by the regular kernel
> -	 * stage 1, when VA_BITS=52.
> -	 *
> -	 * At EL2, there is only one TTBR register, and we can't switch between
> -	 * translation tables *and* update TCR_EL2.T0SZ at the same time. Bottom
> -	 * line: we need to use the extended range with *both* our translation
> -	 * tables.
> -	 *
> -	 * So use the maximum of the idmap VA bits and the regular kernel stage
> -	 * 1 VA bits to assure that the hypervisor can both ID map its code page
> -	 * and map any kernel memory.
> -	 */
> -	idmap_bits = IDMAP_VA_BITS;
> -	kernel_bits = vabits_actual;
> -	*hyp_va_bits = max(idmap_bits, kernel_bits);
> -
> -	kvm_debug("Using %u-bit virtual addresses at EL2\n", *hyp_va_bits);
> +	kvm_debug("Using %u-bit virtual addresses at EL2\n", hyp_va_bits);
>  	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
>  	kvm_debug("HYP VA range: %lx:%lx\n",
>  		  kern_hyp_va(PAGE_OFFSET),
> @@ -2345,7 +2325,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
>  		goto out;
>  	}
>  
> -	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
> +	err = kvm_pgtable_hyp_init(hyp_pgtable, hyp_va_bits, &kvm_hyp_mm_ops);
>  	if (err)
>  		goto out_free_pgtable;
>  
> @@ -2354,7 +2334,7 @@ int __init kvm_mmu_init(u32 *hyp_va_bits)
>  		goto out_destroy_pgtable;
>  
>  	io_map_base = hyp_idmap_start;
> -	__hyp_va_bits = *hyp_va_bits;
> +	__hyp_va_bits = hyp_va_bits;
>  	return 0;
>  
>  out_destroy_pgtable:
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index 91b22a014610..2346f9435a71 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -46,9 +46,31 @@ static void init_hyp_physvirt_offset(void)
>  	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
>  }
>  
> +/*
> + * Calculate the actual VA size used by the hypervisor
> + */
> +__init u32 kvm_hyp_va_bits(void)
> +{
> +	/*
> +	 * The ID map is always configured for 48 bits of translation, which may
> +	 * be different from the number of VA bits used by the regular kernel
> +	 * stage 1.
> +	 *
> +	 * At EL2, there is only one TTBR register, and we can't switch between
> +	 * translation tables *and* update TCR_EL2.T0SZ at the same time. Bottom
> +	 * line: we need to use the extended range with *both* our translation
> +	 * tables.
> +	 *
> +	 * So use the maximum of the idmap VA bits and the regular kernel stage
> +	 * 1 VA bits as the hypervisor VA size to assure that the hypervisor can
> +	 * both ID map its code page and map any kernel memory.
> +	 */
> +	return max(IDMAP_VA_BITS, vabits_actual);
> +}
> +
>  /*
>   * We want to generate a hyp VA with the following format (with V ==
> - * vabits_actual):
> + * hypervisor VA bits):
>   *
>   *  63 ... V |     V-1    | V-2 .. tag_lsb | tag_lsb - 1 .. 0
>   *  ---------------------------------------------------------
> @@ -61,10 +83,11 @@ __init void kvm_compute_layout(void)
>  {
>  	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
>  	u64 hyp_va_msb;
> +	u32 hyp_va_bits = kvm_hyp_va_bits();
>  
>  	/* Where is my RAM region? */
> -	hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
> -	hyp_va_msb ^= BIT(vabits_actual - 1);
> +	hyp_va_msb  = idmap_addr & BIT(hyp_va_bits - 1);
> +	hyp_va_msb ^= BIT(hyp_va_bits - 1);
>  
>  	tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
>  			(u64)(high_memory - 1));
> @@ -72,9 +95,9 @@ __init void kvm_compute_layout(void)
>  	va_mask = GENMASK_ULL(tag_lsb - 1, 0);
>  	tag_val = hyp_va_msb;
>  
> -	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
> +	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (hyp_va_bits - 1)) {
>  		/* We have some free bits to insert a random tag. */
> -		tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
> +		tag_val |= get_random_long() & GENMASK_ULL(hyp_va_bits - 2, tag_lsb);
>  	}
>  	tag_val >>= tag_lsb;
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
