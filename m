Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE5D56261E
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790093668; cv=none; b=aHWaMh8izfJXnp7RmEUFdHXmqlZxJGTn9fNK9JxpzuSFiC45sAWyvPoBpFwFgRooZzD+z8EIBgQ+W1DVu0Ormx/hD9yt+JuR6iMbu1x0S4Io9bji3KZ7vFdPKN12Ez588VoxWC92KZbbbBNo/sZyq2YdG+HQ6CYGWMQubw1YoNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790093668; c=relaxed/simple;
	bh=WVEiEygNMDHySIvPGsGorKAHhAeu1Doh8M3qMllu1iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=kbZ/cU+4IruVpCdEGK/I3ZDxcNGH8kJFxUkeouISgKCoDLGBRk/jeAwByPW8yGicosfOSE4qBMFIng1WoRWDQvgz/TI/eoFAQqM+mYjo4O376ZIWqovSC1XVuG7FDu2Rk4rGG2fFbItaeEDu8ovYXvU7uTqq2LHAl/dmaZ5L+eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nJ8XdZe7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nJ8XdZe7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58DA31576;
	Tue, 22 Sep 2026 09:14:22 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C4013F632;
	Tue, 22 Sep 2026 09:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790093665; bh=WVEiEygNMDHySIvPGsGorKAHhAeu1Doh8M3qMllu1iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ8XdZe7UmDjZeIEaFvomQle08uzGmHCiS2Rq8CcpN6Gvv9DM37NojYuQ9ZMEPYBl
	 /PbS9JPpv4uZ/re6KfVvv+RWdOAUO/6QBJ+UjShH+q/16XgjWW7sNXOfRXSOCv/i2J
	 Twn8qebu306VL4W8Hu0fVNTj14brpStYv7LXNmYM=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 06/22] KVM: arm64: nv: Use a helper for stage-2 descriptor updates
Date: Tue, 22 Sep 2026 17:14:19 +0100
Message-ID: <arKpWwN_KrcPtSpx@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-7-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-7-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:45AM -0700, Oliver Upton wrote:
> Use a helper for handling stage-2 descriptor updates so the
> implementation can be shared with updates to table descriptors.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 47 +++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c2fb7290f0c8..a70af3b3f05d 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -227,9 +227,23 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  	return 0;
>  }
>  
> -static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u64 new,
> -			      struct s2_walk_info *wi)
> +static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
> +			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
> +			      struct kvm_walk_access *access)
>  {
> +	u64 old, new;
> +	int ret;
> +
> +	old = new = ws->desc;
> +
> +	if (wi->ha)
> +		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +
> +	if (old == new)
> +		return 0;
> +
> +	ws->desc = new;
> +
>  	if (wi->be) {
>  		old = (__force u64)cpu_to_be64(old);
>  		new = (__force u64)cpu_to_be64(new);
> @@ -238,7 +252,13 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
>  		new = (__force u64)cpu_to_le64(new);
>  	}
>  
> -	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
> +	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
> +	if (!ret || ret == -EAGAIN)
> +		return ret;
> +
> +	out->esr = ESR_ELx_FSC_SEA_TTW(ws->level);
> +	out->desc = ws->desc;
> +	return 1;
>  }
>  
>  static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
> @@ -287,7 +307,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  	struct s2_walk_step ws = {};
>  	phys_addr_t base_addr;
>  	unsigned int addr_top, addr_bottom;
> -	u64 new_desc;  /* page table entry */
>  	int ret;
>  
>  	switch (BIT(wi->pgshift)) {
> @@ -340,8 +359,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  			return ret;
>  		}
>  
> -		new_desc = ws.desc;
> -
>  		/* Check for valid descriptor at this point */
>  		if (!(ws.desc & KVM_PTE_VALID)) {
>  			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> @@ -386,21 +403,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  		return 1;
>  	}
>  
> -	if (wi->ha)
> -		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> -
> -	if (new_desc != ws.desc) {
> -		ret = swap_guest_s2_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
> -		if (ret == -EAGAIN)
> -			return ret;
> -		if (ret) {
> -			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
> -			out->desc = ws.desc;
> -			return 1;
> -		}
> -
> -		ws.desc = new_desc;
> -	}
> +	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> +	if (ret)
> +		return ret;
>  
>  	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
>  		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
> -- 
> 2.47.3
> 

IIUC, you pulled stuff around swap_guest_s2_desc() and put it inside it, 
while changing the function name to handle_desc_update(), so it should be 
the same logic.

It looks much better this way, and most things seem to have the same efect.

The only thing that I notice was "ws->desc = new":
The previous version would do that only after running __kvm_at_swap_desc() 
and only when the return value is zero. 

The new version does that every time "old != new", and before running 
__kvm_at_swap_desc() and does not take into account it's return value.

This means that on this new version if __kvm_at_swap_desc() returns 1:
	ws->desc = new;
	ret = 1;
	out->desc = ws->desc; //(i.e. new)

And in the previous version, it would make out->desc = ws->desc, that being 
the original value, not the new one.

Is this ok? 
(I am commenting because it could be unintentional)

Thanks!
Leo
