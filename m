Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E6A4F30D5
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 14:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792778; cv=none; b=bP5Tg6tAAjCuozMv7hf0VNX5BIn+i+rjxxz8uy2hlD3lSBwyNiRhJOFCDPUuekRociqbHE8mIAJRBWQ/lWGg6q1qHEwbPOSOSqbWy7es06lNW/TBnPOIAENgBGOgtVdN8/rY/RDWfhQtKFhnIzB/xKa8VO15Ud7mQ9QzMx9ja+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792778; c=relaxed/simple;
	bh=r3k3fDYG2MvTPsgaP6Offm+VihJbdwFTPeuaVnZh8MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVm57WfHd+jfQRwxoh4j9D0/bxUHnjVfr+hzJf6HqXmUUoXlzQSF6HkyLntB83LvMd5nBG8e5KgjKqdTFES1ZcbmmBGNR3lCu4hTxXvdPb0yKFtJFUdNv4Agd7q4G90FIY4225zbQ9eW3HNtZhShKTFx+NRxdzx0unO5IdgswPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qF1o4IpG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qF1o4IpG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C1AE1476;
	Mon,  7 Sep 2026 07:52:40 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF5BC3F528;
	Mon,  7 Sep 2026 07:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788792764; bh=r3k3fDYG2MvTPsgaP6Offm+VihJbdwFTPeuaVnZh8MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qF1o4IpGeCgp+dwszPCHkoxTcmnXtaGGWXUv2hK5Mgx59+6iDTmlxeJbgeE+Aj+F9
	 xAhjHuG3OPANGiLXlPKvFuxpXGUcRcBa/MDvpnTy1puP+WL8qlKht9fgzigEGysL/y
	 x596PS7ELJWcAbr42mzvdhrzPtTGQbDR5VFnyUvQ=
Date: Mon, 7 Sep 2026 15:52:34 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 08/20] KVM: arm64: Add a range to
 __pkvm_host_reclaim_page_guest()
Message-ID: <ggblnclfadr4oy7i3d43okgedqqx3ak5edhxfrjhceh4763xyw@iyxtswi72edn>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-9-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-9-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:52AM +0100, Vincent Donnefort wrote:

[...]

> +int __pkvm_host_reclaim_page_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index f04cea5ff389..0d17e59d5335 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -74,7 +74,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>  int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  		     unsigned long vcpu_hva);
>  
> -int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
> +int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn, u64 nr_pages);

I feel like __pkvm_host_reclaim_"page"_guest(),
__pkvm_reclaim_dying_guest_"page"() aren't good names since they deal
with multiple pages now.

[...]

>  
> -static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
> +static int __get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa,
> +				 kvm_pte_t *ptep, u64 *physp, s8 *levelp)
>  {
>  	kvm_pte_t pte;
>  	u64 phys;
> @@ -905,20 +906,32 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
>  		return -EHWPOISON;
>  	if (!kvm_pte_valid(pte))
>  		return -ENOENT;
> -	if (level != KVM_PGTABLE_LAST_LEVEL)
> -		return -E2BIG;
>  
>  	phys = kvm_pte_to_phys(pte);
> -	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> +	ret = check_range_allowed_memory(phys, phys + kvm_granule_size(level));
>  	if (WARN_ON(ret))
>  		return ret;
>  
>  	*ptep = pte;
>  	*physp = phys;
> +	*levelp = level;
>  
>  	return 0;
>  }
>  
> +static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, u64 size,
> +			       kvm_pte_t *ptep, u64 *physp)
> +{
> +	s8 level;
> +	int ret;
> +
> +	ret = __get_valid_guest_pte(vm, ipa, ptep, physp, &level);
> +	if (ret)
> +		return ret;
> +
> +	return kvm_granule_size(level) == size ? 0 : -E2BIG;
> +}
> +
>  int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> @@ -1001,7 +1014,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>  	host_lock_component();
>  	guest_lock_component(vm);
>  
> -	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> +	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
>  	if (ret)
>  		goto unlock;
>  
> @@ -1033,7 +1046,7 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>  	host_lock_component();
>  	guest_lock_component(vm);
>  
> -	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> +	ret = get_valid_guest_pte(vm, ipa, PAGE_SIZE, &pte, &phys);
>  	if (ret)
>  		goto unlock;
>  
> @@ -1285,6 +1298,14 @@ static void hyp_poison_page(phys_addr_t phys)
>  	hyp_fixmap_unmap();
>  }
>  
> +static void hyp_poison_range(phys_addr_t phys, u64 size)
> +{
> +	u64 offset;
> +
> +	for (offset = 0; offset < size; offset += PAGE_SIZE)
> +		hyp_poison_page(phys + offset);
> +}
> +

I believe get_valid_guest_pte and hyp_poison_range changes/addition can
be made into its own patch, focusing on small helpers?
If so I believe it can make reviewing easier.

Thanks,
Wei-Lin Chang

[...]
