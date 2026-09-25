Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437104908BF
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348854; cv=none; b=kVcf/WNy8j8wzTXImKLdu1SC0h4hKmP4U36RK0U6BOTdRQ6Ly9NpKcOb5Hr/d8yJESUrc6I20iZPuefagHdoUtiVXcEo/L819BnU0jG66Hj/qgoo1WoHkLtFE8HR+ur8G445rh3mWnrpydZQDR3FwSqlLVxHd9XEeR6wYAftobc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348854; c=relaxed/simple;
	bh=9Nk4FeN4yFiJxjUNWIuUAqKVNF/tj1LVNSXRUSTgCB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=PMaAOO7BPZCtMTrGxg6nMb487+Ylb1hOPxpTk6i3oQadgfHgyxm6w/L+KdOU9nKteoCtx/GQW0iD0JUULN7HWJBjXce8YBNjjLUowG/5b6+jSzxJmn5b0/cwdWAdokkubEJUP8YqkiDaET0UkXU6/RmiRcRRnSFxn2+TCPC+AC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hP2wFnNB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hP2wFnNB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAC441688;
	Fri, 25 Sep 2026 08:07:11 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35DB33F86F;
	Fri, 25 Sep 2026 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790348835; bh=9Nk4FeN4yFiJxjUNWIuUAqKVNF/tj1LVNSXRUSTgCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP2wFnNBu4TUlcRlvF4IFz15ZwcCgqlDUNCw7lwkDZh/N5k0xJ3ZR+Ev6EXCa92T+
	 fsCTrL1zAh4/I+GN92LZL9CPB11jbnCI9hMs5rIIhccJrZ0yivWUFNXuScE8FTh9v1
	 Q6I1JHVfw+Lbit4whcvB7hXebt/vUw+4pM6H2NbA=
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
Subject: Re: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Date: Fri, 25 Sep 2026 16:07:11 +0100
Message-ID: <araOHyWfQnVM_htB@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-14-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-14-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:52AM -0700, Oliver Upton wrote:
> Mark the descriptor as dirty if the permissions are sufficient to grant
> write access. Note that compute_s1_direct_permissions() already
> considers the DBM bit as writable.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
> 
> Spotted right before posting:
> 
> TCR_ELx.HD is conditioned on TCR_ELx.HA being set, which is missing from
> this patch. I'll address in v2.
> 
>  arch/arm64/include/asm/kvm_arm.h    |  1 +
>  arch/arm64/include/asm/kvm_nested.h |  1 +
>  arch/arm64/kvm/at.c                 | 23 +++++++++++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3f9233b5a130..3f7fa9c3e9c5 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -111,6 +111,7 @@
>  #define TCR_EL2_DS		(1UL << 32)
>  #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
>  #define TCR_EL2_HPD		(1 << 24)
> +#define TCR_EL2_HD		(1 << 22)
>  #define TCR_EL2_HA		(1 << 21)
>  #define TCR_EL2_TBI		(1 << 20)
>  #define TCR_EL2_PS_SHIFT	16
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 347d79fd350c..1bb070328b1c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -316,6 +316,7 @@ struct s1_walk_info {
>  	bool	     		s2;
>  	bool			pa52bit;
>  	bool			ha;
> +	bool			hd;
>  };
>  
>  struct s1_walk_result {
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 0218176107b5..bfba31b270a9 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -412,6 +412,10 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	wi->ha &= (wi->regime == TR_EL2 ?
>  		  FIELD_GET(TCR_EL2_HA, tcr) :
>  		  FIELD_GET(TCR_HA, tcr));
> +	wi->hd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, DBM);
> +	wi->hd &= (wi->regime == TR_EL2 ?
> +		  FIELD_GET(TCR_EL2_HD, tcr) :
> +		  FIELD_GET(TCR_HD, tcr));

Right: has feature and the HD bit is set.

Out of curiosity, on the regime part, I noticed that it's defined by an 
enum that can have translation regimes of EL1&0, EL2&0 and EL2. TCR_HD is 
defined as TCR_EL1_HD.

For TR_EL20, should not the format be TCR_EL2_HD (bit 22) instead of TCR_HD 
(from TCR_EL1_HD, bit 40)? 

Or are we never getting TR_EL20 here?

>  
>  	return 0;
>  
> @@ -455,6 +459,22 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
>  	return 0;
>  }
>  
> +static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
> +				   struct s1_walk_result *wr, struct kvm_walk_access *access)
> +{
> +	bool perm = wi->as_el0 ? wr->uw : wr->pw;
> +
> +	switch (access->type) {
> +	/* R_RKMHW */
> +	case WALK_ACCESS_CMO:
> +	case WALK_ACCESS_AT:
> +		return false;
> +	default:
> +		/* R_NSXRD */
> +		return access->write && wi->hd && perm;
> +	}
> +}
> +
>  static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  			      struct s1_walk_step *ws, struct s1_walk_result *wr,
>  			      struct kvm_walk_access *access)
> @@ -467,6 +487,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (wi->ha)
>  		new |= PTE_AF;
>  
> +	if (should_set_dirty_state(wi, ws, wr, access))
> +		new &= ~PTE_RDONLY;
> +
>  	if (new == old)
>  		return 0;

Right, this is inverted compared to S2, as AP[2]=0 mean writable.

If the above curiosity about the regime gets answered, then :)
FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
