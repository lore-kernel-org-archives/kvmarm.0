Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941028E6
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 05:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707974986; cv=none; b=Jx38/+TpmmEnTXaJRzkgxkDsyNM3qFFE4/bSnPL0zy7CQwGdCXfkks9DRYmmHhbBLv8vSjILdJaujPHgp2/odTiOYRb3k6iS1J1CxYpQhXAlQnqQQHa/PnKuMEkq0Kt3dXhOw808EOJm9hu+HcurjH1RXDUoldcIIbOfVEBZQIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707974986; c=relaxed/simple;
	bh=uxfb1c2RaLDUFG8vm19/j7Iy8u7uEX3/DuKkwKNBZ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uh+W7obFYsOQT7YMzo216yoUB9l3EAocQniEHCcSASbxSoeFIAPTrgwYf5WFSBGqDNOQSV7ZNR5nMzPXRKa7c3sHfe+n2aoxwVh6IbG2fY+gqDllqfCfR4NAJ3wuOc8xJ4RoACwMfdyH17CvBmNvYUZdnEp6J+7HCPi0dUk5rUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JMvt0zE8; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JMvt0zE8"
Date: Thu, 15 Feb 2024 14:29:28 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707974980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DJo0Z4lBIwPC8cwQYpRIOozyv+hDmIUKGggHbYocrU8=;
	b=JMvt0zE8GQid/p0MkbZRVsrGi+W1t/zzYgVElcer9c55Q/gCxwMPmPwlihKR9pJE5PDW6a
	3TReNnyec55HT7lqFR8vxrbuXYbBEtah7kNXvaRJcOH5q6IAqYdGrmnRZNi1baOoo8DGHb
	bAuguauFjnb5bxQGCxF8X/D8yC0/wLM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH v8 05/10] KVM: selftests: Add support for protected
 vm_vaddr_* allocations
Message-ID: <Zc2hOL1y+GIMaMux@vm3>
References: <20240203000917.376631-1-seanjc@google.com>
 <20240203000917.376631-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203000917.376631-6-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 02, 2024 at 04:09:11PM -0800, Sean Christopherson wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> Test programs may wish to allocate shared vaddrs for things like
> sharing memory with the guest. Since protected vms will have their
> memory encrypted by default an interface is needed to explicitly
> request shared pages.
> 
> Implement this by splitting the common code out from vm_vaddr_alloc()
> and introducing a new vm_vaddr_alloc_shared().
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerly Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++----
>  2 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index a82149305349..cb3159af6db3 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -590,6 +590,9 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  			    enum kvm_mem_region_type type);
> +vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
> +				 vm_vaddr_t vaddr_min,
> +				 enum kvm_mem_region_type type);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
>  vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
>  				 enum kvm_mem_region_type type);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ea677aa019ef..e7f4f84f2e68 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1431,15 +1431,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>  	return pgidx_start * vm->page_size;
>  }
>  
> -vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
> -			    enum kvm_mem_region_type type)
> +static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
> +				     vm_vaddr_t vaddr_min,
> +				     enum kvm_mem_region_type type,
> +				     bool protected)
>  {
>  	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
>  
>  	virt_pgd_alloc(vm);
> -	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
> -					      KVM_UTIL_MIN_PFN * vm->page_size,
> -					      vm->memslots[type]);
> +	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
> +						KVM_UTIL_MIN_PFN * vm->page_size,
> +						vm->memslots[type], protected);
>  
>  	/*
>  	 * Find an unused range of virtual page addresses of at least
> @@ -1459,6 +1461,20 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  	return vaddr_start;
>  }
>  
> +vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
> +			    enum kvm_mem_region_type type)
> +{
> +	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
> +				  vm_arch_has_protected_memory(vm));
> +}
> +
> +vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
> +				 vm_vaddr_t vaddr_min,
> +				 enum kvm_mem_region_type type)
> +{
> +	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
> +}
> +
>  /*
>   * VM Virtual Address Allocate
>   *
Reviewied-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

> -- 
> 2.43.0.594.gd9cf4e227d-goog
> 
