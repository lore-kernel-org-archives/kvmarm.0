Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2554CEE75
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351522; cv=none; b=CrbwqSwxfC90pi42Z+m7IWT7dm63G7o7NSrveOSzDr4p4h2MR6Y1gSX8Qm5fGTA08d7M9VTa237n4tYyER/Sn2HHTiuX9IE4f0E8nmgGAsqrxeaGwti5RfnByqdoZP6Ay74QvZZFYwjcMrIve3ZgL6jwOt/VvZDqAktEQ7rsg+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351522; c=relaxed/simple;
	bh=O8UecQmp1X5oftek2FhEpGS0Nrpn7t3tl6EEW3PJlSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=fgn/SXj9jDATwxTuI4FY+iaPi2DoNVbA/DQYHUHp+4F8JIgTd6mYra1o1oWvykjZ7U8gJetgyMqCJwS04WYx0DojqjkavFkMo1UwsjrmYah9EQ7mCB7Cg3iWkJ+RFVHxg573WsdWxC2ZdSKoAKszJGOqRfJcx3L1sL+ps7YrHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XkRGgzcm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XkRGgzcm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B48D81BB2;
	Fri, 25 Sep 2026 08:51:46 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEDC43F86F;
	Fri, 25 Sep 2026 08:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790351510; bh=O8UecQmp1X5oftek2FhEpGS0Nrpn7t3tl6EEW3PJlSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkRGgzcmnEh5sB+yqSvQPlYj1aoCQXgGii+lsftJQgaC/GpxIxDdSJHh4Yppe+Fv6
	 mz/TUMk2bzFKvAbsh5FqUxZoqLjQSmO2WotN7n73+ozguZgv/XuM8Smw17xg/8DU9j
	 MIuKiMBg+niq/zDXpNP6Aw9AA9TmJMre4AabLROs=
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
Subject: Re: [PATCH 15/22] KVM: arm64: Don't update descriptors for "non-arch" access
Date: Fri, 25 Sep 2026 16:51:46 +0100
Message-ID: <araYkodBdZIsQnf-@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-16-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-16-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:54AM -0700, Oliver Upton wrote:
> WALK_ACCESS_NONARCH is a special indicator that the page table walk
> request is not due to an architectural behavior and instead used
> internally for KVM. Currently, the only user of this is SEA injection to
> identify the correct translation level that generated the abort.
> 
> Ensure "non-arch" table walks are not made visible to the guest and
> explicitly avoid descriptor updates. These accesses are not expected to
> be used for pseudo-TLB fills, nor are they used to dirty any memory.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/at.c     | 15 ++++++++++++++-
>  arch/arm64/kvm/nested.c | 12 +++++++++++-
>  2 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index faffb69c2eef..8d76eaf463c9 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -459,6 +459,15 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
>  	return 0;
>  }
>  
> +static bool should_set_access_flag(struct s1_walk_info *wi, struct s1_walk_step *ws,
> +				   struct kvm_walk_access *access)
> +{
> +	if (access->type == WALK_ACCESS_NONARCH)
> +		return false;
> +
> +	return wi->ha;
> +}
> +
>  static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
>  				   struct s1_walk_result *wr, struct kvm_walk_access *access)
>  {
> @@ -468,6 +477,7 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
>  	/* R_RKMHW */
>  	case WALK_ACCESS_CMO:
>  	case WALK_ACCESS_AT:
> +	case WALK_ACCESS_NONARCH:
>  		return false;
>  	default:
>  		/* R_NSXRD */
> @@ -484,7 +494,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  
>  	old = new = ws->desc;
>  
> -	if (wi->ha)
> +	if (should_set_access_flag(wi, ws, access))
>  		new |= PTE_AF;
>  
>  	if (should_set_dirty_state(wi, ws, wr, access))
> @@ -555,6 +565,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  				.write	= wi->ha,
>  			};
>  
> +			if (access->type == WALK_ACCESS_NONARCH)
> +				s2_access.type = WALK_ACCESS_NONARCH;
> +
>  			ret = kvm_walk_nested_s2(vcpu, &s2_access, &ws.s2_trans);
>  			if (ret == -EAGAIN)
>  				return ret;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 54228db30371..4d128003ae7a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -228,6 +228,15 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  	return 0;
>  }
>  
> +static bool should_set_access_flag(struct s2_walk_info *wi, struct s2_walk_step *ws,
> +				   struct kvm_walk_access *access)
> +{
> +	if (access->type == WALK_ACCESS_NONARCH)
> +		return false;
> +
> +	return wi->ha;
> +}
> +
>  static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
>  				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
>  {
> @@ -235,6 +244,7 @@ static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step
>  	/* R_RKMHW */
>  	case WALK_ACCESS_CMO:
>  	case WALK_ACCESS_AT:
> +	case WALK_ACCESS_NONARCH:
>  		return false;
>  	default:
>  		/* R_NSXRD */
> @@ -251,7 +261,7 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  
>  	old = new = ws->desc;
>  
> -	if (wi->ha)
> +	if (should_set_access_flag(wi, ws, access))
>  		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  
>  	if (should_set_dirty_state(wi, ws, out, access))
> -- 
> 2.47.3
> 

Avoids update to AF and S2AP[1]/AP[2], LGTM.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
