Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641878;
	b=R9uxBBrPpyLDf5Iqj4PhOhi5Weu9/gBnaB0gW3ILiRPForhzk72mnX63LEt5f4L8d+Sq
	 4FliTj313PEIbP0P3hZmXrhpyuiqWiMCMRRj4oQBNgGpVu1Gryinudxl7izdk7SEsrGum
	 fLRRRGF8WKK/mUumRdNi4bHULCGrUmfAL0gbILF117pYlaL5sPHVstHY+LjnB5tVL0DKV
	 avfJ55GtC5hAXWddvsr4DL5giRh7J6U6o91VamaKMBeII8kBVfb4p0JlivCBw7JNkq/bJ
	 ZexXCSJTzaHimfndHGGQwDJh7ooZMxhKxojhibaNsNS0sK010ouuD86BMJOMcQ1fM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641878;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=O8N1kMQ7yFiL0PQibHTZpgh1F2b/FxnAQsUkhCgElMY=;
	b=h0kIVEAU9FxhILXVNItqoVcFZsoAOWD6bJD7MYuiYTgsmdk5jgSL/RiSqoj9oJ5ldnhN
	 b0gD9qTyt41ygQKpJw0R3v3lXtiYVqKoeA/lHL9uy0gr3271CLkaBRx34lowpvZOWtf9N
	 MLyHw58olXRX2GBQtvyCkd6mNgfsbbreNtTtEYpq9Xx7XxSVq8fyGAnu3Yl7Dh1z+8E7o
	 bEtiQmOE6/Wq+0S1FekXJyHabJvOmZpOfdCaheVV36wPSGG/R1rzVKwh4bIzq1DmhhVIv
	 lmRlV/Du4aywyu9uZPPsyyLu8SWWW+N8dGvQJXTbmJpZ/eXzUiPuPk17fs8FCIswHyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q4w9QhlL;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327F7606A337
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 17:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 327F7606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q4w9QhlL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 427671C14;
	Mon,  2 Nov 2026 09:51:13 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D73F33F59E;
	Mon,  2 Nov 2026 09:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793641876; bh=J8BylPXMv6beH/RHCzF+1ctvTDrsNfDjubU8mtMU/Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4w9QhlLHDWNvKZXOORuFy+aAR1Qd8/LFOhovOEorlAbW12ydZ+Gsp15IL+APHRsT
	 KIwDroWB4XGkNWR3KRusMCscEnGlQK0HL8P6Q78ZHswRrr7dtMiHY2ioXzye4TOdHw
	 D/X5ArBPYh5PpTpd9dn7RHOgO+sPgwhtUVGO0Ss8=
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
Subject: Re: [PATCH v2 06/28] KVM: arm64: nv: Use a helper for stage-2 descriptor updates
Date: Mon,  2 Nov 2026 17:51:12 +0000
Message-ID: <aujNkD1SdAkcEsZg@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-7-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-7-oupton@kernel.org>
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

On Fri, Oct 23, 2026 at 01:55:48PM -0700, Oliver Upton wrote:
> Use a helper for handling stage-2 descriptor updates so the
> implementation can be shared with updates to table descriptors.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 47 +++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a3cbf37dddc9..dea5c31f10df 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -246,9 +246,23 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
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
> @@ -257,7 +271,13 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
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
> @@ -306,7 +326,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  	struct s2_walk_step ws = {};
>  	phys_addr_t base_addr;
>  	unsigned int addr_top, addr_bottom;
> -	u64 new_desc;  /* page table entry */
>  	int ret;
>  
>  	switch (BIT(wi->pgshift)) {
> @@ -359,8 +378,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  			return ret;
>  		}
>  
> -		new_desc = ws.desc;
> -
>  		/* Check for valid descriptor at this point */
>  		if (!(ws.desc & KVM_PTE_VALID)) {
>  			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> @@ -405,21 +422,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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


LGTM. FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
