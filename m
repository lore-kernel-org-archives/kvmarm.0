Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3F2BAF9
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806238; cv=none; b=eQvYX9GY3jl/xsbrTdo6Uz9zu3MNR2vjCzNXVBIZh2ZCfAMrsdsYGwtrEpQRR7M12Sm5QljckL2niY8L+YWurOccWSAhs4jlXvXmcLIhwAj765Q9RtqOUd9wzVZ56tfl0g0ux63DlVGRrFMUDR6n+yxoQgWqQUSRCI3+ArGevws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806238; c=relaxed/simple;
	bh=aiiGfHlzYhLKBPI7T+oe19y05r9wkNreqH/OubXhk4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/WNfEqveIymkvOunDkXE3Gi4VfAWmAso9rAD4dsi7wzQb53ceDroEyyPkPCDoQEFSYcQvlW5fiWbsBmQC5p8WWilL7cg8HfSS3cHH3QKChukNF3h8u4qS/fQp8E7Ste6vZuznk9f7llMIpdleA5kEHKvyzTBn2O1iFZwNDs7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZq1COae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZq1COae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AAEC4CED1;
	Mon, 17 Feb 2025 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739806237;
	bh=aiiGfHlzYhLKBPI7T+oe19y05r9wkNreqH/OubXhk4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tZq1COae0oQ//5zMRRtaXRd2PhYc0QB91P1UmS7tDTNizTkjKcC8gGQgzKYLogVNs
	 Vk+Yj9H8uRcr5db3ASGaN+CXyQ3x7dWSm/cXCcjrZ2tFSB8bxUqvT8kf282Gl8sTBg
	 C6RghwXLYsd0qesKbMEHgS/kCNhjsaWucSwy3IN7idsvxPGDe/CmutZeWe8qOSKrE9
	 dzCTMnnnjkIKa2/sQFWMvC6tjLel1wbF0YpABkjHmg4ajyNM0BUvAckHw6kancR1Q0
	 kGILqyCn+ktpt9CRKpSGDygLe5A1JXKWLZgUTxm3YCJRsedpNuMA/hplQgOQtmqgzu
	 E5+kwUUOCi2lQ==
Date: Mon, 17 Feb 2025 15:30:31 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v1 3/3] KVM: arm64: Create each pKVM hyp vcpu after its
 corresponding host vcpu
Message-ID: <20250217153031.GA16398@willie-the-truck>
References: <20250214150258.464798-1-tabba@google.com>
 <20250214150258.464798-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214150258.464798-4-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 14, 2025 at 03:02:58PM +0000, Fuad Tabba wrote:
> Instead of creating and initializing _all_ hyp vcpus in pKVM when
> the first host vcpu runs for the first time, initialize _each_
> hyp vcpu in conjunction with its corresponding host vcpu.
> 
> Some of the host vcpu state (e.g., system registers and traps
> values) are not initialized until the first time the host vcpu is
> run. Therefore, initializing a hyp vcpu before its corresponding
> host vcpu has run for the first time might not view the complete
> host state of these vcpus.
> 
> Additionally, this behavior is inline with non-protected modes.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h      |  2 +
>  arch/arm64/include/asm/kvm_pkvm.h      |  1 +
>  arch/arm64/kvm/arm.c                   |  4 ++
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
>  arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
>  6 files changed, 53 insertions(+), 42 deletions(-)

[...]

>  static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>  			      struct pkvm_hyp_vm *hyp_vm,
> -			      struct kvm_vcpu *host_vcpu,
> -			      unsigned int vcpu_idx)
> +			      struct kvm_vcpu *host_vcpu)
>  {
>  	int ret = 0;
>  
>  	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
>  		return -EBUSY;
>  
> -	if (host_vcpu->vcpu_idx != vcpu_idx) {
> -		ret = -EINVAL;
> -		goto done;
> -	}
> -
>  	hyp_vcpu->host_vcpu = host_vcpu;
>  
>  	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
>  	hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
> -	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
> +	hyp_vcpu->vcpu.vcpu_idx = READ_ONCE(host_vcpu->vcpu_idx);
>  
>  	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
>  	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> @@ -687,27 +689,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  		goto unlock;
>  	}
>  
> -	idx = hyp_vm->nr_vcpus;
> +	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
> +	if (ret)
> +		goto unlock;
> +
> +	idx = hyp_vcpu->vcpu.vcpu_idx;
>  	if (idx >= hyp_vm->kvm.created_vcpus) {
>  		ret = -EINVAL;
>  		goto unlock;
>  	}
>  
> -	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
> -	if (ret)
> +	if (hyp_vm->vcpus[idx]) {
> +		ret = -EINVAL;
>  		goto unlock;
> +	}

I'm not sure how much we care at EL2, but it looks like there's a
potential spectre gadget here given that 'idx' is now untrusted.
Perhaps chuck something like:

	idx = array_index_nospec(idx, hyp_vm->kvm.created_vcpus);

before indexing into 'hyp_vm->vcpus[]'?

Either way:

Acked-by: Will Deacon <will@kernel.org>

Will
