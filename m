Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39972314A6C
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767716812; cv=none; b=AGRUEhDfL7Nfi6ptVraI0ZS769bJHeWMeEkz5r8okC+sRitKhQ6GWO8SuypWJSeFAZa+Et/uCMhUWTbF+kKsaAhpw36/fie+JaWYjNYhi1FpfzVqTWyOZkvisls7RRPd2wV6A4el0bwEOv5Vl8mBgP2TBn6rToyJtcLcmJXLHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767716812; c=relaxed/simple;
	bh=nlfTEC5pmR1JRg1s+mONFiOiwOSiMJA45Ei7NGRGpQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJ0eo+eyQM/L49wAP588Nh2o9dqg+xoM6q5s58QbZKJoCbSCohmgdgXtM/4AIohlVPUFuAO7yzpY8J9uIYtQXiMdC8uNUY/qC35g4MXA+GqqPct6Oy2Ai0RnK6kOPrVku1NFFCVm2zjLu2ldoGE8XtyjMZfZiPFx5MJAsnjaWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cEvYQQ0w; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cEvYQQ0w"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so12075205e9.2
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 08:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716808; x=1768321608; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w+Ejsdv+4cSG7ZPhph+YM70TsgyLaB5ykH3UcPAAKxY=;
        b=cEvYQQ0w3aHe78r8uE3fSjp6EFVDVu7R1/zKeUnWlP+5SdV0YBlIueeL3tMo8ZuMR6
         Ux6PeEFZ3hEU/1roUq8qaVMLIBJlPW3YkLxeOOP28AmWwOaibDEaI/uYwBeBKctGMvhd
         FC0XwtmMyJIJIWm9R1rtQsvO9mSzPz4momc2GHKCmTMvgqSc2U2lfjLA2cedMZkhrmBX
         FuNYsm5CerYjH/op6MdLN1Pwxc6Na+9xjg9aEKeeKvbBGDKLyMRgbrdMfrShVvFh7vgn
         K6ex9p72jjHOKqrN2tVJLquv+zX7CdEav8i0E/9bhHljkDw38+0ZPy6WsaZHtaGvOB9p
         pT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716808; x=1768321608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+Ejsdv+4cSG7ZPhph+YM70TsgyLaB5ykH3UcPAAKxY=;
        b=sI/O5EzG6Iy78PloctIGiK9GksBT22dDn2JBXiE2sstPnyL6eCze5jSgljSYWLOb+X
         tvliBgpwEBiAxJxIQNehXSThLdzJcD8MeMN+B6FI22yo1dHC5lwVz6okiP7MkLl3l7MC
         ZmJPZSGuZcn3pXQ8f2zFvHp0sjKGXJokzuz4xM2XU2wIn6K1WPDxrSGFqeUEN1QvkVOf
         ZCea/8zOt2n1OdoRxCMe756i2P0bBKDrbRa8iAuDFp3uMuxvSzuPoiQAxHdXO/5NLuSt
         MqeVi9dsC/DfEonCU6Fybe3tgOPqBvYzF1WBhfY1XSuy8UbJaGEcEEnv9VK8fY6MIVyv
         yd/A==
X-Gm-Message-State: AOJu0YzBhl+gfdcF0unHI2NJdCbE7txs3MRc7enkRIUak1cbqunMSZDm
	MiAO5qJaAG4/f1c2um98ImssjkD1PbkBvZrLpiKSJ6s4uA5+bGfNPo/4NMfkCM9sWQ==
X-Gm-Gg: AY/fxX4KjNf5K5NSiY1gHvdNUQAxPgVyW1OKo+i01ORRf5AdFvKVxrvpawFaaR9B4FB
	KvvYE792YYeC2ktXP/9yN30Tir81fXHgXoSpJErgQV93Co6BGAAA0g/IjSM7LwrJEE/R+Fp/ifo
	1aik16SbqP4UMVkOcYngWsUNoXvXgHmIjytV1P5jWZjxPy+IfwrA2FkVLbECaVIRKzTYQLCIMFZ
	ZSxSO7E+HZ7gjFGavtvVyVJRLaUyH2XyCivGvbmtOOFBz6ncMCqiqZCUJiDBxD5ZI+4LvWnNIJ1
	RriLAuWsm02KzjrPbvfh2ovoZqSzXKLzb6BJREztp1BGC5lgRRxCA5HbuLrg7fDFud62ObJ3/RN
	Jhgw3LJYdum+OvF28UBy+OsYhyUmbIKJNEvdv+3yfGjHJnxzN03gUBoqKkQqnEF/08SVjQyln2h
	p8xvihZzWNCbOQiaG3/IocjUr7aGEjhl39kT98Fql6X0o6vS+YAg==
X-Google-Smtp-Source: AGHT+IF7hlGyFV379hs3oKbqbIx8gkC6RYZlwJeShX+Gt9MMQwN8OR3S6eiOzaGyxDfGnvr8mxiw5w==
X-Received: by 2002:a05:600c:8216:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-47d7f073134mr38448755e9.11.1767716808352;
        Tue, 06 Jan 2026 08:26:48 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f410c25sm57181765e9.2.2026.01.06.08.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 08:26:47 -0800 (PST)
Date: Tue, 6 Jan 2026 16:26:44 +0000
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
Subject: Re: [PATCH 13/30] KVM: arm64: Introduce
 __pkvm_reclaim_dying_guest_page()
Message-ID: <aV03xOYPTdurX2k4@google.com>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-14-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-14-will@kernel.org>

On Mon, Jan 05, 2026 at 03:49:21PM +0000, Will Deacon wrote:
> To enable reclaim of pages from a protected VM during teardown,
> introduce a new hypercall to reclaim a single page from a protected
> guest that is in the dying state.
> 
> Since the EL2 code is non-preemptible, the new hypercall deliberately
> acts on a single page at a time so as to allow EL1 to reschedule
> frequently during the teardown operation.
> 
> Co-developed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 +++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 79 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 14 ++++
>  6 files changed, 105 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index cad3ba5e1c5a..f14f845aeedd 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -86,6 +86,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 9c0cc53d1dc9..cde38a556049 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -41,6 +41,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
> +int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 04c7ca703014..506831804f64 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -74,6 +74,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>  int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  		     unsigned long vcpu_hva);
>  
> +int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
>  int __pkvm_start_teardown_vm(pkvm_handle_t handle);
>  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index a5ee1103ce1f..b1940e639ad3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -570,6 +570,14 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
>  	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
>  }
>  
> +static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> +
> +	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn);
> +}
> +
>  static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> @@ -622,6 +630,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_unreserve_vm),
>  	HANDLE_FUNC(__pkvm_init_vm),
>  	HANDLE_FUNC(__pkvm_init_vcpu),
> +	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
>  	HANDLE_FUNC(__pkvm_start_teardown_vm),
>  	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
>  	HANDLE_FUNC(__pkvm_vcpu_load),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index ae126ab9febf..edbfe0e3dc58 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -725,6 +725,32 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
>  	return check_page_state_range(&vm->pgt, addr, size, &d);
>  }
>  
> +static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
> +{
> +	kvm_pte_t pte;
> +	u64 phys;
> +	s8 level;
> +	int ret;
> +
> +	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
> +	if (ret)
> +		return ret;
> +	if (!kvm_pte_valid(pte))
> +		return -ENOENT;
> +	if (level != KVM_PGTABLE_LAST_LEVEL)
> +		return -E2BIG;
> +
> +	phys = kvm_pte_to_phys(pte);
> +	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> +	if (WARN_ON(ret))
> +		return ret;
> +
> +	*ptep = pte;
> +	*physp = phys;
> +
> +	return 0;
> +}
> +
>  int __pkvm_host_share_hyp(u64 pfn)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> @@ -958,6 +984,59 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
>  	return 0;
>  }
>  
> +static void hyp_poison_page(phys_addr_t phys)
> +{
> +	void *addr = hyp_fixmap_map(phys);
> +
> +	memset(addr, 0, PAGE_SIZE);
> +	/*
> +	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
> +	 * here as the latter may elide the CMO under the assumption that FWB
> +	 * will be enabled on CPUs that support it. This is incorrect for the
> +	 * host stage-2 and would otherwise lead to a malicious host potentially
> +	 * being able to read the contents of newly reclaimed guest pages.
> +	 */
> +	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
> +	hyp_fixmap_unmap();
> +}
> +
> +int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
> +{
> +	u64 ipa = hyp_pfn_to_phys(gfn);
> +	kvm_pte_t pte;
> +	u64 phys;
> +	int ret;
> +
> +	host_lock_component();
> +	guest_lock_component(vm);
> +
> +	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
> +	if (ret)
> +		goto unlock;
> +
> +	switch (guest_get_page_state(pte, ipa)) {
> +	case PKVM_PAGE_OWNED:
> +		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE));
> +		hyp_poison_page(phys);
> +		break;
> +	case PKVM_PAGE_SHARED_OWNED:
> +		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
> +		break;
> +	default:
> +		ret = -EPERM;
> +		goto unlock;
> +	}
> +
> +	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE));
> +	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
> +
> +unlock:
> +	guest_unlock_component(vm);
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
>  int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
>  {
>  	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 7f8191f96fc3..9f0997150cf5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -832,6 +832,20 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
>  	unmap_donated_memory_noclear(addr, size);
>  }
>  
> +int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
> +{
> +	struct pkvm_hyp_vm *hyp_vm;
> +	int ret = -EINVAL;
> +
> +	hyp_spin_lock(&vm_table_lock);
> +	hyp_vm = get_vm_by_handle(handle);
> +	if (hyp_vm && hyp_vm->kvm.arch.pkvm.is_dying)
> +		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
> +	hyp_spin_unlock(&vm_table_lock);
> +
> +	return ret;
> +}
> +
>  int __pkvm_start_teardown_vm(pkvm_handle_t handle)
>  {
>  	struct pkvm_hyp_vm *hyp_vm;
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
