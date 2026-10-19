Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616D4B0495
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 10:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404103; cv=none; b=o699aMuAxU7c1Lk7fVTMQF7AtaEN75gQmIWWOHaBcoZQ89hcBebAOVG42sNIZbgAQFXKVhAQf8SiDqujIPX2Vet86tpXE2P/JfkwgOGXp0QwOW53JrnvYLKeU0FCCnNpmwuYm+v4bFvUO9aHW5RWD7zQOgar4xisrxYT/Af15GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404103; c=relaxed/simple;
	bh=OKUR09aYo4+hANOYcFiQPjrHiwdQlPDgUbuHfofpoeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fF8+6yVGgQdNL0vzNfoDNtZP94O74ikH1pjRRoKuJg7++i2KOlk8sGDA2Jk9PRwhOAZOCH1won4TYmxHR1d8DS9papkxN3LaAHksd+eX8mZZJRCPOKuujAUhkubMV89NltKLqqRimdByBMS2/48ZkTpZoFcWN4TycsoDvzCC9t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hCACPEcN; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hCACPEcN"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1e3b87ac5so8683475e9.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 03:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792404100; x=1793008900; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JvNBlD/JZ8hRBqmq1fD5HU1ZQqr0SeMst3WentULn88=;
        b=hCACPEcNgFCxGdpJbyAwkSRA3/0ehoHNsInYPCfRHy/f3ek8jbv0gioBPdpCUmMVN0
         NaJRH/DhIAFI82ehCxIKlWdLAygu5NmspyMKnYskky+KZf8/AMjGtleJvZDSOvHnHEue
         Ep3k1w/aJ6f6r/mWYZo2q+0h/SdLsEpA+VncrjH4VIMDSRZCp4C0mzfYP7RABnf16sjk
         MIBXkR4UB2ub9owixXkYj/d/t5JF2RSv79Vq+qe6+csHN+ImU9nkVLLicMOn7X6KXIB9
         EqNfiUeUqJ4R07FLwu2zOnSEJdLi8tGxAhUADzL/E+JjaZlguLfVsWEsY2vU/ZztUsHT
         vW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792404100; x=1793008900;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JvNBlD/JZ8hRBqmq1fD5HU1ZQqr0SeMst3WentULn88=;
        b=zuKjXT8ZQNPrjELFhltBnYXL32sMhrKjW+Wc3IgkiZBhFDeVomGUanqhm44TJR/s4x
         jxaD+PTX+LXMYlADAzjZF00MEyfUspfHX7LfOo8JvpJdwapNg3LUYaXacDxQ9bhlgCGr
         /uJs9NDZ1dC9iWZ9WWwXVf/1/GmDuje5uvr5Ha7iBrr2Q1sGBqaCgWjAmFzbbF3DVzFR
         0ChfapH7ozJXlEQBqvnwhAJnwr3GBfH6JwflLXrSz7pK/5H/nlrPRpZVWRyoliWEIkSL
         o+ufKRMCcJCaigd9zUK4RGcveDhumDE1QPTk6sYfkMpsjXzNbfVuYMDgvUlpjqQRzFzy
         hFdw==
X-Forwarded-Encrypted: i=1; AKwUvBycaZ54MvgnIcRxZ7JqeItd6dTJirdDoRykIGkSLAV1xJaTfg7SNtlfeTiC157MqtiqB7vLFZQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYJqUMHXEAIeru5VQ5C80Nnb3SlxgG+s3iLd1LYFs/EYugawNPXd
	pgYvJ4U+rR0BpZPXQ68a/Fd0j8BQaHHNTA3q51pmcIU7sYa8yRblbYvH0rxa0KaIkvHDF6Qap2A
	9aQMwnQ==
X-Gm-Gg: AYBFou0JYExbSfkDMOHzQMMiG4AcxfXOlrB+hr5DWSsOczSFfmRZhpHSVcP2l4I7L7Q
	taDTnSSgJ7V7HjBh24C5gZm09wk2xVoI0GhEw268Q7kbSRc8B6dnCR5532mlWwMAgszSc6Z/5Ec
	rJHM5GPvyOxFK2jHlC3jcyu9YtSauhgLyjcteRSfrlBPwLcPz30+C9l1HUomE2l5Z7lbT0ZwLo9
	7BcoxI6RMg8i26rVYoDiT8qDHdcGA/0kwQFMsKD4rSW8yXPwsponpxTmlnhia55w1H3sVg/MD18
	XiuJUPGFL6Uef7ZOl6qUTNXxPBNZMKvAFIURlvM8jNhmWBTY/i3EAEZlCHUBLntNStAfX0RLbj5
	eY8PQ3WDsGHUgCPV+HYayWHCMmkjp1LwO5kTV//w9bGg/OuvArFCgBrolCqZtceTcDqKlOsVZ6x
	Fv1m2T0/lvECDXSd69ldNVVXVHAViRf2us+D7x4W95w0nzPfaNohe4WUP1EgEZql9x/t3vh9Trh
	X8YI5XGNQBzLZg6oMe6Jl8ZnLtAnG54s2tXMtq8EE4=
X-Received: by 2002:a05:600c:674f:b0:4a1:7e76:d02f with SMTP id 5b1f17b1804b1-4a1d75fce45mr143600135e9.14.1792404021999;
        Mon, 19 Oct 2026 03:00:21 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d85f92d9sm190610495e9.4.2026.10.19.03.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 03:00:19 -0700 (PDT)
Date: Mon, 19 Oct 2026 11:00:15 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Ensure TLBs and I-cache are private to
 each vCPU in pKVM
Message-ID: <atXqLxU5bBtJ8U9W@google.com>
References: <20261014125510.2928306-1-fuad.tabba@linux.dev>
 <20261014125510.2928306-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014125510.2928306-3-fuad.tabba@linux.dev>

On Wed, Oct 14, 2026 at 01:55:10PM +0100, Fuad Tabba wrote:
> All vCPUs of a VM share its VMID, so KVM flushes a physical CPU's TLBs
> and I-cache for the VM whenever a different vCPU of that VM is loaded
> there (vcpu_prepare_mmu()). Commit fce886a602073 ("KVM: arm64: Plumb the
> pKVM MMU in KVM") moved pKVM guests, protected or not, onto the
> hypervisor's stage-2 and VMID, and the host stopped flushing for them.
> Nothing at EL2 flushes instead, so a vCPU can hit TLB and I-cache
> entries that another vCPU of the same VM left on that CPU.
> 
> Track the last vCPU loaded on each physical CPU in the hyp VM, and flush
> at EL2 in __pkvm_vcpu_load() when it changes.
> 
> Fixes: fce886a602073 ("KVM: arm64: Plumb the pKVM MMU in KVM")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  8 ++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 21 ++++++++++++++++++---
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 9abfe6b7e942b..02c8fc7a10904 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -54,6 +54,9 @@ struct pkvm_hyp_vm {
>  	unsigned short refcount;
>  	hyp_spinlock_t lock;
>  
> +	/* Per physical CPU, the vcpu_idx of the last vCPU of this VM loaded there. */
> +	int *last_vcpu_ran;

Unlikely to be a problem in pratice, but vcpu_idx is "unsigned int". I wonder if
this shouldn't be unsigned int here too and initialised to UINT_MAX?

> +
>  	/*
>  	 * The vCPU initialised RUNNABLE: claimed under vm_table_lock,
>  	 * released only if its own init fails.
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index d715aa942577e..f0b77236c871e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -827,11 +827,19 @@ DEFINE_KVM_HOST_HCALL(void, __pkvm_vcpu_load,
>  	pkvm_handle_t, handle, unsigned int, vcpu_idx, u64, hcr_el2)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	int *last_ran;
>  
>  	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
>  	if (!hyp_vcpu)
>  		return;
>  
> +	/* TLBs and I-cache are private to each vCPU, see vcpu_prepare_mmu(). */
> +	last_ran = &pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu)->last_vcpu_ran[hyp_smp_processor_id()];
> +	if (*last_ran != vcpu_idx) {
> +		__kvm_flush_cpu_context(hyp_vcpu->vcpu.arch.hw_mmu);
> +		*last_ran = vcpu_idx;
> +	}
> +
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index ac020d0501d2e..f18fa762746c9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -489,10 +489,11 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
>  }
>  
>  static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
> -			     unsigned int nr_vcpus, pkvm_handle_t handle)
> +			     int *last_vcpu_ran, unsigned int nr_vcpus, pkvm_handle_t handle)
>  {
>  	struct kvm_s2_mmu *mmu = &hyp_vm->kvm.arch.mmu;
>  	int idx = vm_handle_to_idx(handle);
> +	unsigned long cpu;
>  
>  	hyp_vm->kvm.arch.pkvm.handle = handle;
>  
> @@ -512,6 +513,10 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>  	mmu->vtcr = host_mmu.arch.mmu.vtcr;
>  	mmu->arch = &hyp_vm->kvm.arch;
>  	mmu->pgt = &hyp_vm->pgt;
> +
> +	for (cpu = 0; cpu < hyp_nr_cpus; cpu++)
> +		last_vcpu_ran[cpu] = -1;
> +	hyp_vm->last_vcpu_ran = last_vcpu_ran;
>  }
>  
>  static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
> @@ -887,6 +892,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
>  	size_t vm_size, pgd_size;
>  	unsigned int nr_vcpus;
>  	pkvm_handle_t handle;
> +	int *last_vcpu_ran;
>  	void *pgd = NULL;
>  	int ret;
>  
> @@ -915,13 +921,19 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
>  		goto err_unpin_kvm;
>  	}
>  
> +	last_vcpu_ran = hyp_alloc(array_size(hyp_nr_cpus, sizeof(*last_vcpu_ran)));
> +	if (!last_vcpu_ran) {
> +		ret = hyp_alloc_errno();
> +		goto err_free_hyp_vm;
> +	}
> +
>  	ret = -ENOMEM;
>  
>  	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
>  	if (!pgd)
> -		goto err_free_hyp_vm;
> +		goto err_free_last_ran;
>  
> -	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
> +	init_pkvm_hyp_vm(host_kvm, hyp_vm, last_vcpu_ran, nr_vcpus, handle);
>  
>  	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
>  	if (ret)
> @@ -938,6 +950,8 @@ int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva)
>  	kvm_guest_destroy_stage2(hyp_vm);
>  err_remove_mappings:
>  	unmap_donated_memory(pgd, pgd_size);
> +err_free_last_ran:
> +	hyp_free(last_vcpu_ran);
>  err_free_hyp_vm:
>  	hyp_free(hyp_vm);
>  err_unpin_kvm:
> @@ -1112,6 +1126,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  		hyp_free(hyp_vcpu);
>  	}
>  
> +	hyp_free(hyp_vm->last_vcpu_ran);
>  	hyp_free(hyp_vm);
>  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>  	return 0;
> -- 
> 2.39.5
> 
