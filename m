Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0793EFD15
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528023; cv=none; b=F1uTtPk8uaCVaqdOYwCqqq+rOIihIsAIihAxxSNUv+lrRov8C0kXM5qGW7kuPZLNGqkE4pYPKiPO6puMTiIBFugeEKVd2A8KguDb5j7cAhNAo9KiIpXTCu4gAi9R4Wnh0/2SvSIGYmTQgUW/pqsAHtcHMTQ4A7pIzuiTAKYm4B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528023; c=relaxed/simple;
	bh=Z4ogKaGOWOsrgF4xpf7X6IfhLUMGGIDUqw6T9websk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQqg6Wxtfe4db76vd2zBQid02RzMFHE9hEQEo6HTAti6ek6Fwbege8kYc9YyUcYMMnFfAp+n0FYoQ52Yg1DXWWy31jyeiJsTybkkuRY+Sh4BqcRxvFmtyvBTraCmhnGAwTXiwNjyMFN89dl5fMPbBrEYn/WeNxVAEq73Nh6jP/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdID3IyO; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdID3IyO"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4908b92904fso40370375e9.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781528020; x=1782132820; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfy5IF3x0JtW9CpNalnLLpK8u6eZ7BRMq0IeQhp39Ds=;
        b=bdID3IyOg4bH4HzcLZKhAcZVOvGJM6+H3/6nqncJ4bcTACjcCtlm9tnli2587zmxrn
         qFrYpcjTQ7z8RvfevwSHexLvu8QZmJPVxoIAJs+SLoyda0EMBvWO1bCCSkThcdkZJYnE
         3ffKkdiSbd4s9TbNTaDVe3AEyxgEMj5KrdQPjrFuC8dxXSluiNmgsE4ThUFJB7B4bwOO
         HlozWN0pUU0Rl6gRyI5LxDSKwzZycz48H8tpJptOGsYcPkrRRCp2ozrUFHL7LugpNSlJ
         5rCnGWq5R056a9+Nfm6Qj5oCs2bmcIyPQSMn3ocv0vMYfTogE30+RrfLrsk3mjSOWZva
         FfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781528020; x=1782132820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfy5IF3x0JtW9CpNalnLLpK8u6eZ7BRMq0IeQhp39Ds=;
        b=tAFD3Vt7coQ1jNvTgF4c3GDoKya2rICTnM13YR5OQGEXnlbxKYbywdSbq6+INLGgV4
         ZincYnJyLfXZbQhSSeZwUPnB7wPjOV8g+HzScvXvxpJyyvLLjK5HsZFymHYS/4PLJNz+
         dm6u29S3gGL0Hnd2hX3D3SsSj9cNPcCq1XenZAOKROxk7vkC2opypyft+ge5/6roDhBa
         rZuHMz37xmIJv2Ugx2lAP1lQDYOPVpYJShU1UWv4W0EngbmpmP2vQtI6YbEaUrNIGfAv
         12Th9HOSjBljfgDvB+Q6EHkHotqYd54B2++MNthRtwbj8uDrPnWw+4I3iYu/fceq59RD
         6aww==
X-Forwarded-Encrypted: i=1; AFNElJ8zMsEsQZ7aW5bBreq4uCTPaNCeOuPOoHXI2jB4GrRN+dHcMKF2eJFsxHxYIV76KF0bJOpl7OQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjMOk5RlFNmpwIHE7geKC6mcZ0qnCerTtrwGkmGHprukZnADQO
	I4yLHjwxj30ngLX6qlGhOxf7ROQoziMhHXCDHGvZomg2Os6IZSizsxXalULlMKHl8Q==
X-Gm-Gg: Acq92OH5RfNqd5GCDXKFOFE86ag8UfbIVqnkwb7nKt+JA4ULkp5XevvfQXZyj6HOKOn
	Ere/j4Bb+9QsNc928pnx5KJ/xYXgVDxCyEmg61rcvy6tRTfzbw/UPhdn6uDW+i70AMaEAo+jZXp
	KffrJ1YJP9KZhY+7U6T3z4U6Jk66ya5+d1piyWvAxcvSo0Tiz96Wr2RlEjC5DzBPScuhSgCKgiy
	coIH4CfGIoyzkHUQlNARiSK+apTsaq/hJUBD9mDIWik24Suqbys9eRBc6SIrVDovUfXDl6KTGw3
	XaBVHtzoDZCrNGFIhoxcGnkaavfPK4AgNjiS12xSdc2WuE623w52tkZgj68Bx+fy3TwOkUjIcLF
	lrtBMlvu8Qa+AvygVpDjTsLZErMPYThHo9m+XF7fjQiHZkdgurX6BDIznzIuugyW6pw6EGMm21t
	zAiyd3/PVnFKgbo5XsNW63IK8XXSDgV4tqCfEUgqKhRYqEf/+Hy9+kfzYECpRI3oylLDU=
X-Received: by 2002:a7b:c7d7:0:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490ec5215bamr127730525e9.33.1781528019556;
        Mon, 15 Jun 2026 05:53:39 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49220308f13sm265864385e9.5.2026.06.15.05.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 05:53:38 -0700 (PDT)
Date: Mon, 15 Jun 2026 13:53:35 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Per Larsen <perlarsen@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/11] KVM: arm64: Use guard(hyp_spinlock) in pKVM
 hypervisor code
Message-ID: <ai_1z13TyEXbHx4Q@google.com>
References: <20260612065925.755562-1-tabba@google.com>
 <20260612065925.755562-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612065925.755562-3-tabba@google.com>

On Fri, Jun 12, 2026 at 07:59:16AM +0100, tabba@google.com wrote:
> Convert the manual hyp_spin_lock()/hyp_spin_unlock() pairs in
> arch/arm64/kvm/hyp/nvhe/{pkvm,mm,page_alloc,ffa}.c to
> guard(hyp_spinlock) and scoped_guard(hyp_spinlock), dropping several
> unlock-only goto labels in favour of direct returns.
> 
> hyp_fixblock_lock in mm.c is left as an explicit lock/unlock pair: it is
> acquired in hyp_fixblock_map() and released in hyp_fixblock_unmap(), so
> its critical section spans two functions and cannot be expressed as a
> single lexical scope.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c        | 154 +++++++++++----------------
>  arch/arm64/kvm/hyp/nvhe/mm.c         |  37 ++-----
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c |  13 +--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c       |  86 +++++----------
>  4 files changed, 105 insertions(+), 185 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..46cd4fa924be 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -313,17 +313,16 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
>  			      struct kvm_cpu_context *ctxt)
>  {
>  	DECLARE_REG(u32, id, ctxt, 1);
> -	int ret = 0;
>  
>  	if (id != HOST_FFA_ID) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
> -	hyp_spin_lock(&host_buffers.lock);
> +	guard(hyp_spinlock)(&host_buffers.lock);
>  	if (!host_buffers.tx) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	hyp_unpin_shared_mem(host_buffers.tx, host_buffers.tx + 1);
> @@ -336,10 +335,7 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_1_2_regs *res,
>  
>  	ffa_unmap_hyp_buffers();
>  
> -out_unlock:
> -	hyp_spin_unlock(&host_buffers.lock);
> -out:
> -	ffa_to_smccc_res(res, ret);
> +	ffa_to_smccc_res(res, 0);
>  }
>  
>  static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
> @@ -418,18 +414,20 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
>  	DECLARE_REG(u32, fraglen, ctxt, 3);
>  	DECLARE_REG(u32, endpoint_id, ctxt, 4);
>  	struct ffa_mem_region_addr_range *buf;
> -	int ret = FFA_RET_INVALID_PARAMETERS;
> +	int ret;
>  	u32 nr_ranges;

nit: inverted christmas tree

>  
> -	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)
> -		goto out;
> +	if (fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE ||
> +	    fraglen % sizeof(*buf)) {

nit: I don't know if we wouldn't want extra parenthesis here for readability.

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
>  
> -	if (fraglen % sizeof(*buf))
> -		goto out;
> -
> -	hyp_spin_lock(&host_buffers.lock);
> -	if (!host_buffers.tx)
> -		goto out_unlock;
> +	guard(hyp_spinlock)(&host_buffers.lock);
> +	if (!host_buffers.tx) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
>  
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
> @@ -444,19 +442,14 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
>  		 */
>  		ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
>  		WARN_ON(res->a0 != FFA_SUCCESS);
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, ret);
> +		return;
>  	}
>  
>  	ffa_mem_frag_tx(res, handle_lo, handle_hi, fraglen, endpoint_id);
>  	if (res->a0 != FFA_SUCCESS && res->a0 != FFA_MEM_FRAG_RX)
>  		WARN_ON(ffa_host_unshare_ranges(buf, nr_ranges));
>  
> -out_unlock:
> -	hyp_spin_unlock(&host_buffers.lock);
> -out:
> -	if (ret)
> -		ffa_to_smccc_res(res, ret);
> -
>  	/*
>  	 * If for any reason this did not succeed, we're in trouble as we have
>  	 * now lost the content of the previous fragments and we can't rollback
> @@ -465,7 +458,6 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_1_2_regs *res,
>  	 * sharing/donating them again and may possibly lead to subsequent
>  	 * failures, but this will not compromise confidentiality.
>  	 */
> -	return;
>  }
>  
>  static void __do_ffa_mem_xfer(const u64 func_id,
> @@ -480,29 +472,29 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	struct ffa_composite_mem_region *reg;
>  	struct ffa_mem_region *buf;
>  	u32 offset, nr_ranges, checked_offset;
> -	int ret = 0;
> +	int ret;
>  
>  	if (addr_mbz || npages_mbz || fraglen > len ||
>  	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	if (fraglen < sizeof(struct ffa_mem_region) +
>  		      sizeof(struct ffa_mem_region_attributes)) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
> -	hyp_spin_lock(&host_buffers.lock);
> +	guard(hyp_spinlock)(&host_buffers.lock);
>  	if (!host_buffers.tx) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	if (len > ffa_desc_buf.len) {
> -		ret = FFA_RET_NO_MEMORY;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_NO_MEMORY);
> +		return;
>  	}
>  
>  	buf = hyp_buffers.tx;
> @@ -512,53 +504,41 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
>  	offset = ep_mem_access->composite_off;
>  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	if (fraglen < checked_offset) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	reg = (void *)buf + offset;
>  	nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
>  	if (nr_ranges % sizeof(reg->constituents[0])) {
> -		ret = FFA_RET_INVALID_PARAMETERS;
> -		goto out_unlock;
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
>  	}
>  
>  	nr_ranges /= sizeof(reg->constituents[0]);
>  	ret = ffa_host_share_ranges(reg->constituents, nr_ranges);
> -	if (ret)
> -		goto out_unlock;
> +	if (ret) {
> +		ffa_to_smccc_res(res, ret);
> +		return;
> +	}
>  
>  	ffa_mem_xfer(res, func_id, len, fraglen);
>  	if (fraglen != len) {
> -		if (res->a0 != FFA_MEM_FRAG_RX)
> -			goto err_unshare;
> -
> -		if (res->a3 != fraglen)
> -			goto err_unshare;
> +		if (res->a0 != FFA_MEM_FRAG_RX || res->a3 != fraglen)
> +			WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
>  	} else if (res->a0 != FFA_SUCCESS) {
> -		goto err_unshare;
> +		WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));

I am not sure this is really better for this function. At least we had a single
callsite to this WARN_ON(ffa_host_unshare_ranges) ... 

Or alternatively if we really want guard() this can just set ret = XXX and then

  if (ret)
      WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));

So we can keep a single call site for the rollback.

>  	}
> -
> -out_unlock:
> -	hyp_spin_unlock(&host_buffers.lock);
> -out:
> -	if (ret)
> -		ffa_to_smccc_res(res, ret);
> -	return;
> -
> -err_unshare:
> -	WARN_ON(ffa_host_unshare_ranges(reg->constituents, nr_ranges));
> -	goto out_unlock;
>  }
>  

[...]

>  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
> @@ -996,22 +975,19 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  	struct kvm *host_kvm;
>  	unsigned int idx;
>  	size_t vm_size;
> -	int err;
>  
> -	hyp_spin_lock(&vm_table_lock);
> -	hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
> -	if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying) {
> -		err = -EINVAL;
> -		goto err_unlock;
> +	scoped_guard(hyp_spinlock, &vm_table_lock) {
> +		hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
> +		if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying)
> +			return -EINVAL;
> +
> +		host_kvm = hyp_vm->host_kvm;
> +
> +		/* Ensure the VMID is clean before it can be reallocated */
> +		__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> +		remove_vm_table_entry(handle);
>  	}
>  
> -	host_kvm = hyp_vm->host_kvm;
> -
> -	/* Ensure the VMID is clean before it can be reallocated */
> -	__kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> -	remove_vm_table_entry(handle);
> -	hyp_spin_unlock(&vm_table_lock);
> -
>  	/* Reclaim guest pages (including page-table pages) */
>  	mc = &host_kvm->arch.pkvm.teardown_mc;
>  	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
> @@ -1042,10 +1018,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  	teardown_donated_memory(mc, hyp_vm, vm_size);
>  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>  	return 0;
> -
> -err_unlock:
> -	hyp_spin_unlock(&vm_table_lock);
> -	return err;

For this one too I doubt this is really interesting: only one path using
err_unlock and actually the entire label could be just removed to to simply do
hyp_spin_unlock() return -EINVAL;

This would avoid adding another tab with that scoped_guard(). But that's
probably my aversion to scoped_guard() talking.

>  }
>  
>  static u64 __pkvm_memshare_page_req(struct kvm_vcpu *vcpu, u64 ipa)
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
