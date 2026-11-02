Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643295;
	b=UEo2tLK81qBxT5CHgLvYyrOb6Gl2ZUlYe0P7SDGhGytjE+ft4LME9qEkprS/OjTrC7Tr
	 JJ3CS0zhlpXDA7e4f5GzcHuq8nLw0ST6/9GkI04F2Z+qgCVK5+ZbVQXbPp1MwN3HJp/D2
	 KdSenPsKUtN3UwVXGSn8GweYjn3PCw9sbHKfhDHAqNbQDkGiUJGrwkSFtDsaHyUeq3V/Z
	 BgfpCwan9XowHiNQ5P5pu5wkctebgxehMwLT6I8jKhAhJhXTdsURC8Wr+2zQ9z9s7Wp3O
	 pQziZZlq+f6EftDmTvu0O2jpmS8ITRGHiw53wdy15Wqvn1xhsmYkr1Zs2bO/j1WbMug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643295;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=pkPN+xY3L0Qfr9wcegQPH3A4C/l/pEV4vQo3GiExsQQ=;
	b=Km+c2PpvpDKWms5/xLFx8uLjly8rIgMk4gOkn7kWx3d4csuF2A4TU7djk+mxeF8Xyke5
	 XzWow8yLpZLEYwYDQ5k6YBTEnFafO22TO2tvg3/QAye4aJuWEXM9jxxBC/rls1ET0ljy8
	 LV/662yAIQDqb/EZRVdkOxOJ3OY9Gk6nkaQzxLnO5/uVcMKakgr9qPvXfkDUHkkNJNiu7
	 jHDDPhccCPS1uwaPMo7riryIgHT4ZJfPLzPnC0mvzcDWGSkWfnoJLtN5eBYQyvcO+ecin
	 Y55T64bf0kDz2emKzH9bFo6SleZIUfl/Xq4ACDiqsN5qeGgiJ8lyAb+XqdPQ3OFLNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XHn6qwUi;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0742606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 18:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0742606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XHn6qwUi
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C52C31C14;
	Mon,  2 Nov 2026 10:14:50 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68F973F673;
	Mon,  2 Nov 2026 10:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793643294; bh=27pau5S5uokMsAT08PVwL/ml+3ox+5UnlnMf+zd9nAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHn6qwUivwORTbvbj3zwkMBmp6GPU2w0yg1eXw+6tuZjPHCY4NcA9WflRxR7olJzu
	 L4tyoWX8mqa88oEfLCQF2nLaBWEbqeVvnmSJn4zpTibWWcSWCBwR3qHuqbtVaIui/x
	 +dPnfBTjr0Jd4UfqDLVhXew36zqYA4zPIgoATLeE=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 07/28] KVM: arm64: nv: Set dirty state at stage-2
Date: Mon,  2 Nov 2026 18:14:49 +0000
Message-ID: <aujTGWJDPIsKBv3V@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-8-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-8-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:55:49PM -0700, Oliver Upton wrote:
> Set the dirty state on descriptors at stage-2 for write accesses when
> DBM is set.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 51 +++++++++++++++++++++++++++++++----------
>  1 file changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index dea5c31f10df..1d581d3bd557 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -151,6 +151,7 @@ struct s2_walk_info {
>  	unsigned int	t0sz;
>  	bool		be;
>  	bool		ha;
> +	bool		hd;
>  };
>  
>  struct s2_walk_step {
> @@ -246,6 +247,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  	return 0;
>  }
>  
> +static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
> +				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
> +{
> +	switch (access->type) {
> +	/* R_ZYGHJ */
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
> @@ -258,6 +273,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  	if (wi->ha)
>  		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  
> +	if (should_set_dirty_state(wi, ws, out, access))
> +		new |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
>  	if (old == new)
>  		return 0;
>  
> @@ -272,11 +290,15 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  	}
>  
>  	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
> -	if (!ret || ret == -EAGAIN)
> +	if (ret == -EAGAIN)
>  		return ret;
> +	if (!ret) {
> +		out->desc = ws->desc;
> +		out->dirty = out->desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +		return 0;
> +	}
>  
>  	out->esr = ESR_ELx_FSC_SEA_TTW(ws->level);
> -	out->desc = ws->desc;
>  	return 1;
>  }


Before that out->desc would only be updated if __kvm_at_swap_desc() 
returned != (0 or -EAGAIN). Now it only gets updated if ret == 0.
Is this intentional?

>  
> @@ -422,16 +444,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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
> @@ -441,6 +453,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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

The block got moved down in walk_nested_s2_pgd(), and IIUC if the 
descriptor lacks the AF, we zero all other fields except esr and desc, 
cleaning everything that just got set in the lines above (out->writable, 
etc).

Any particular reason for doing it like this, instead of keeping where it 
was, and avoid calculating the other out->* fields?


>  
> @@ -537,6 +563,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
>  	wi->ha = vtcr & VTCR_EL2_HA;
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
> +	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
>  }
>  
>  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
> -- 
> 2.47.3
> 

Thanks!
Leo
