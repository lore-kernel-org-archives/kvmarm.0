Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52C648122F
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172561; cv=none; b=H58qcNdynlXWJnOkmOLhMCsuznVAfZbqgNezJBbfh0CHu4eIts5WTOtZjTpQw0Ap4oPE51sqMI3xPvfcmpfk1wO3U9YXo25Evg10B3DxC/yBeigO321aaYp/p8e8wFZ7EaqO62/GMSvM7gcIqF0mpp13Rnn2GlJotkVeFvjZ7xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172561; c=relaxed/simple;
	bh=hwrWkdlaO6l99jLCSLYA6wwC2fCX8+B4LKiceVhse+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=j185Fg5CB6cCAwcVeS7FKnO0MwLFDNnNtrpNw2xmh0j+pzv0Vp2P6yJfG9tW0ElZeDWupLRQIOpEcPZQxYgm+Z888EV86B0quOSFJUkQxvVTpQhVl1o1Z7td3C6oAyMOIwxswEYV9xWcGzA49j4POVtlHu8AlF1ocE+pu4/2fA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TCB5UmTW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TCB5UmTW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AC851516;
	Wed, 23 Sep 2026 07:09:15 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60AD03F86C;
	Wed, 23 Sep 2026 07:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790172558; bh=hwrWkdlaO6l99jLCSLYA6wwC2fCX8+B4LKiceVhse+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCB5UmTW8u2HErVnzcLeWfr8oZZ2TUQJwqp6gNKUkItVy+Pfxuv+qQjlvVwJIj4Yw
	 fw1At00XtlAy/jIwEfkSAKsk6fo/jwMDW9810rl6ZrvjraSnCRgTmbOrB3IQnUQ/37
	 ThEd0xsvG18th6udpouVI1l+UmoNLh75N0yHErHg=
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
Subject: Re: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Date: Wed, 23 Sep 2026 15:09:11 +0100
Message-ID: <arPdh3ybzm71k07O@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-8-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-8-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:46AM -0700, Oliver Upton wrote:
> Set the dirty state on descriptors at stage-2 for write accesses when
> DBM is set.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 43 +++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a70af3b3f05d..e5a407fc0880 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -132,6 +132,7 @@ struct s2_walk_info {
>  	unsigned int	t0sz;
>  	bool		be;
>  	bool		ha;
> +	bool		hd;
>  };
>  
>  struct s2_walk_step {
> @@ -227,6 +228,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  	return 0;
>  }
>  
> +static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
> +				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
> +{
> +	switch (access->type) {
> +	/* R_RKMHW */
> +	case WALK_ACCESS_CMO:
> +	case WALK_ACCESS_AT:
> +		return false;
> +	default:
> +		/* R_NSXRD */
> +		return access->write && wi->hd && out->writable;
> +	}
> +}
> +
>  static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
>  			      struct kvm_walk_access *access)
> @@ -239,6 +254,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  	if (wi->ha)
>  		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  
> +	if (should_set_dirty_state(wi, ws, out, access))
> +		new |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
>  	if (old == new)
>  		return 0;
>  
> @@ -403,16 +421,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  		return 1;
>  	}
>  
> -	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> -	if (ret)
> -		return ret;
> -
> -	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> -		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
> -		out->desc = ws.desc;
> -		return 1;
> -	}
> -
>  	addr_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
>  
>  	/* Calculate and return the result */
> @@ -422,6 +430,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  	compute_s2_permissions(vcpu, wi, &ws, out);
>  	out->level = ws.level;
>  	out->desc = ws.desc;
> +
> +	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> +	if (ret)
> +		return ret;
> +
> +	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> +		*out = (struct kvm_s2_trans) {
> +			.esr	= compute_fsc(ws.level, ESR_ELx_FSC_ACCESS),
> +			.desc	= ws.desc,
> +		};
> +
> +		return 1;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -518,6 +540,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
>  	wi->ha = vtcr & VTCR_EL2_HA;
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
> +	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);

Should we not check if the feature is available before setting the HD bit?
Or does it being RES0 mean that it can't be 1 in any case? 
(The Arm ARM's Glossary seems to allow direct writes to RES0 sometimes, 
IIUC)


>  }
>  
>  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
> -- 
> 2.47.3
> 


IIUC here you add the hd bit for the walk info, and set it based on VTCR, 
using it to decide on automatically uptating the dirty-state if it's also a 
write fault and the page is writable.

Then you move the the kvm_walk_nested_s2() and AF testing code to after the 
functions that fill the out struct, so you can use it to figure out the 
writable part used above.

Everything seems right, but one part:

IIRC, HAFDBS would need HD=1, and DBM=1 set to be able to properly update 
the dirty bit. DBM should be the 'writable' here, but you are using S2AP[1] 
to decide on writable instead, which I understand to be incorrect according 
to documentation. I am sure you have reason for that here, thogh.

On the other hand, since you are effectively making dirty=writable in a
previous patch, the HAFDBS mechanism here seems not to work at all:

compute_s2_permissions(): trans->writable = ws->desc.S2AP[1];
('trans' is 'out')
handle_desc_update() 	: new = ws->desc;
			  if (... && out->writable)
				new |= S2AP[1];
 
So 'new' will only get the dirty bit, if it already has the dirty bit. :(

(I can be missing something here, though)

Thanks!
Leo

