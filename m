Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58334DCDB
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714615; cv=none; b=EFFKWwY4GYA+kbbnftyzMfhpP6C+sH+LTCI7N7l1dk7pMXZuiYbus6UFKOk7iRrPyNYrZIeF6l4Tnco6RViOWHuYU7WrO5LqNX/ZB/EBWgP3mqncbQ9MKUwWQB/xxROz4i8EAf3N+QudK1WvcjRgep844aMWUMai0XMEsGze8pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714615; c=relaxed/simple;
	bh=6cVMC97yFmSE8ndgpYxHvn6YGtHiUpKUaOxil8N4wVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUazKim857MU47hbaFcJb93fdx4YSSaHpBYr1+uIWjGiVvL3ROUT7qd5CZrdZv4jzMnILmOpsPF580InvfXf0+ztzXXvPjzUORmWJj4rdnxRA9M7nr86kTEGaWvOpvh4gnw57IKGisQ8W6BGDOCxSgb0n654XzVPtuKvtVSdOKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2nwFU/vh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2nwFU/vh"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47d493a9b96so6756635e9.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767714610; x=1768319410; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eow7YGp2kuH+GE5d9YWARtTCyG6zUNWe3jwWa64b+uA=;
        b=2nwFU/vh2H8AD38KpybMSL3r9VR7+rjMlW+TwklEomYwhhScQ5Z+sU8Ovwsb2vStjz
         0RaSyu2kMb3Va/m0z/MNwwAwJU4t6IsZi2rweJbyekYLcmSEzNzKJA1c9/RbB0XX8jW8
         Ke13qiTgqb50meSEeKRXHT5pFZB8WfvOW3zHJ8ECLKttjWi6xSnsbt5fz+hIkOaUtIfs
         cH3MT8axougUxLLpFG90NkiFjTkYhA6VBoObgzGQOv3fJ6JF4EDqxVFHMk7sBK4tPwd0
         bbXrkz61HC2kM9rZHWPcoHJetgqwjpTxMtQAJk5qlf1mgdsYb51W2iu3CrOJ1PNCpYPY
         IGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714610; x=1768319410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eow7YGp2kuH+GE5d9YWARtTCyG6zUNWe3jwWa64b+uA=;
        b=smAZHfUlvkeK9mcb3mgIcoo+YNuuv7B/cZ26wBs2BQNlnQmaE2XkRPV4LkPv3Cw4R8
         I7AzSpjoGvXoiRG9ZFzyy7k+UHXZUuqYCzRiM5K4AjEhZbT7n9UTtXJyUGt61Z8ybhDJ
         qp+ZX32j1ncYD7MIGL825B2qla5GDoEl/nZdqcq91U5YLehLEqLwMVqThYHS/B1PVLpF
         FPaeAtB3qLFwZrljOarQ0T++l/1L6LJkvYSk4f1C4uqcVsjWtA/uu0vCse+0IfSWpCaB
         B03y2hi7gQCzJSno+9Lhrvxuz3Odf0ttiUh5KSbL6aCpM9PFZUa8QfZlM/i+xvWEU5r1
         1Clg==
X-Gm-Message-State: AOJu0Yxx+F4yqqSWzUc9cYAqX4sUVGHvS76WrdwoCJFxOqWb30ZkRZ38
	WdjiGezQwXd7PbGaj73yziagqN9CIpPBkTiPbraV3S2vk2ZUFf2HdNCiK8nU7fXyKQ==
X-Gm-Gg: AY/fxX7y84P096ohXA3P4tF6TUXveFLav4+j4IWgz+ebxztnegGf1X+GlUa4OL0o5Wy
	dMhOwOAlbkob5MR2VGrlZOCk/NTLc0Xqc7T1BgSjkM6wfCTwPeDzXCenyDZmjtWXIG2gMmHRTRH
	zKnf1ga6KJPE9ZSVEHe0d6fPgSgAfBB+kRLpSqsgZRZw/Te/wHXzb0KTcsVccvNFYzzPEFrIHa2
	7LbHB9+qjCLri8mI75rr5CY55SgDDyF9rlKSKraZwgNd65xGpsbgJPhGkRJNcRrU1GimYg25O2v
	fN7rJT8ZXfdexe+QcvLleqmOMaS8XTP+HTF6rCDJSqV3NJSg4fSv2KjARVXq9CmSqiizM0PMv6p
	UepCVR/amdiF3MK0FriaDSfZMvpmYUHj6OBfRVlNNv8XhJF9gN5ljCN1SjTxMm8b4z25RA2SSaH
	YPwK9wu/rgZK6stfM6tRFF6o6rBrLY/geQ8Shqi+LRJSdOqQ/oCw==
X-Google-Smtp-Source: AGHT+IEX//ZJItyO7FjqymCb6lXmINJqdOCw7NIAx+KO+aXRUmmcBMYkYR4qL9qlFKEcw46R6zcraA==
X-Received: by 2002:a05:600c:4f54:b0:477:8b77:155f with SMTP id 5b1f17b1804b1-47d7f064497mr35962835e9.8.1767714610364;
        Tue, 06 Jan 2026 07:50:10 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f41f5e0sm49020395e9.8.2026.01.06.07.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:50:10 -0800 (PST)
Date: Tue, 6 Jan 2026 15:50:07 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 25/30] KVM: arm64: Implement the MEM_UNSHARE hypercall
 for protected VMs
Message-ID: <aV0vL8Mfl-yjWelz@google.com>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-26-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-26-will@kernel.org>

On Mon, Jan 05, 2026 at 03:49:33PM +0000, Will Deacon wrote:
> Implement the ARM_SMCCC_KVM_FUNC_MEM_UNSHARE hypercall to allow
> protected VMs to unshare memory that was previously shared with the host
> using the ARM_SMCCC_KVM_FUNC_MEM_SHARE hypercall.
> 
> Signed-off-by: Will Deacon <will@kernel.org>


Reviewed-by: Vincent Donnefort <vdonnefort@google.com>


> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 32 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 22 +++++++++++++
>  3 files changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 42fd60c5cfc9..e41a128b0854 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -36,6 +36,7 @@ extern unsigned long hyp_nr_cpus;
>  int __pkvm_prot_finalize(void);
>  int __pkvm_host_share_hyp(u64 pfn);
>  int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
> +int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 365c769c82a4..c1600b88c316 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -920,6 +920,38 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
>  	return ret;
>  }
>  
> +int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
> +{
> +	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +	u64 phys, ipa = hyp_pfn_to_phys(gfn);
> +	kvm_pte_t pte;
> +	int ret;
> +
> +	host_lock_component();
> +	guest_lock_component(vm);
> +
> +	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = -EPERM;
> +	if (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte)) != PKVM_PAGE_SHARED_OWNED)
> +		goto unlock;
> +	if (__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED))
> +		goto unlock;
> +
> +	ret = 0;
> +	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_GUEST));
> +	WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED),
> +				       &vcpu->vcpu.arch.pkvm_memcache, 0));
> +unlock:
> +	guest_unlock_component(vm);
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
>  int __pkvm_host_unshare_hyp(u64 pfn)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index d8afa2b98542..2890328f4a78 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -988,6 +988,19 @@ static bool pkvm_memshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> +static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	u64 ipa = smccc_get_arg1(vcpu);
> +
> +	if (!PAGE_ALIGNED(ipa))
> +		return;
> +
> +	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
> +	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa)))
> +		ret[0] = SMCCC_RET_SUCCESS;
> +}
> +
>  /*
>   * Handler for protected VM HVC calls.
>   *
> @@ -1005,6 +1018,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
>  		if (smccc_get_arg1(vcpu) ||
> @@ -1023,6 +1037,14 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  
>  		handled = pkvm_memshare_call(val, vcpu, exit_code);
>  		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
> +		if (smccc_get_arg2(vcpu) ||
> +		    smccc_get_arg3(vcpu)) {
> +			break;
> +		}
> +
> +		pkvm_memunshare_call(val, vcpu);
> +		break;
>  	default:
>  		/* Punt everything else back to the host, for now. */
>  		handled = false;
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
