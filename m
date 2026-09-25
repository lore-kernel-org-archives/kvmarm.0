Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F944AF17C
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346964; cv=none; b=t0R6JOSHaeq1oBlkEbrWaVpeXaSP1vcViRp9eyLGS9OLvPGEFQsFNUsgEDcX4rXeqdhrly4yNsJRLe7YvOj1Py+pO1xXSM9xBBCVVk7h+RiopCUadf2xPFrz0gANNZLPtx3hETgY4koRVSjjoqJiT5yrS1txM/GB+Pao9i+zLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346964; c=relaxed/simple;
	bh=CbDQbY/I+0IrhR/1AD3K4GWP5zTg6mcUkUrlxG9cKWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=QZLfKOgP5SRCx1fjs+NdZSOXipg7XieV83Wl/J++6eBvgVo+he+m+8UMSy/DLLtJ6fCjB+NT3DyuHwMfYREziCHU+8sYGswnasOX9H8dLuWWf06i00IclzcBKEMRm/afdp7dhgMrATElFkdJ7XflZBCsfzbFmEkJsEVmvOhe6m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gIksoA4X; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gIksoA4X"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C436F1688;
	Fri, 25 Sep 2026 07:35:41 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1158E3F85F;
	Fri, 25 Sep 2026 07:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790346945; bh=CbDQbY/I+0IrhR/1AD3K4GWP5zTg6mcUkUrlxG9cKWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIksoA4XHHQCRzuofqc4YtmWA69vm+tqLMBFNOJffbAlXihCEzxK6lzBW2UHHmAle
	 28X2d/w+7PrNSv5bv0XUY45RFepffK3bi8ecgy6c5gfMOR8E4VJHoAj1H0rJOFS9Ga
	 7ctzfD5uZSyfh/TSNP4s4GuLcexDYKi4C/a2R+0U=
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
Subject: Re: [PATCH 12/22] KVM: arm64: Create helper for stage-1 descriptor updates
Date: Fri, 25 Sep 2026 15:35:34 +0100
Message-ID: <araGtgtFCDVdzN_o@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-13-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-13-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:51AM -0700, Oliver Upton wrote:
> Prepare for FEAT_HAFT support by creating a helper for descriptor
> updates to be used for both leaf and table descriptors.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 52 ++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 816d23e7752d..0218176107b5 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -455,9 +455,28 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
>  	return 0;
>  }
>  
> -static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
> -			    struct s1_walk_info *wi)
> +static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> +			      struct s1_walk_step *ws, struct s1_walk_result *wr,
> +			      struct kvm_walk_access *access)
>  {
> +	u64 old, new;
> +	int ret;
> +
> +	old = new = ws->desc;
> +
> +	if (wi->ha)
> +		new |= PTE_AF;
> +
> +	if (new == old)
> +		return 0;
> +
> +	if (wi->s2 && !ws->s2_trans.writable) {
> +		fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws->level), true);
> +		return -EPERM;
> +	}
> +
> +	ws->desc = new;
> +
>  	if (wi->be) {
>  		old = (__force u64)cpu_to_be64(old);
>  		new = (__force u64)cpu_to_be64(new);
> @@ -466,7 +485,12 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
>  		new = (__force u64)cpu_to_le64(new);
>  	}
>  
> -	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
> +	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
> +	if (!ret || ret == -EAGAIN)
> +		return ret;
> +
> +	fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws->level), false);
> +	return ret;
>  }
>  
>  static void compute_s1_permissions(struct kvm_vcpu *vcpu,
> @@ -617,25 +641,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  
>  	compute_s1_permissions(vcpu, wi, wr);
>  
> -	if (wi->ha)
> -		new_desc |= PTE_AF;
> -
> -	if (new_desc != ws.desc) {
> -		if (wi->s2 && !ws.s2_trans.writable) {
> -			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws.level), true);
> -			return -EPERM;
> -		}
> -
> -		ret = kvm_swap_s1_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
> -		if (ret == -EAGAIN)
> -			return ret;
> -		if (ret) {
> -			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws.level), false);
> -			return ret;
> -		}
> -
> -		ws.desc = new_desc;
> -	}
> +	ret = handle_desc_update(vcpu, wi, &ws, wr, access);
> +	if (ret)
> +		return ret;
>  
>  	if (!(ws.desc & PTE_AF)) {
>  		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(ws.level), false);
> -- 
> 2.47.3
> 

This seems the exact format from the earlier patch for nested.c.
I checked equivalency, and seems correct.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
