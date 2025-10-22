Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFAE22D78A
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 07:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116705; cv=none; b=Smy+/htDI17oZ2tLm4+yOINi6Qud5jy0aIy23QC8JOujmgtco5lVxbkZJiiVHw/ZO92CF7GlpxL3HA8nI5QGbya2Bm+8RM2GVAQxka72bG1h4X4pDC81qRypOxkS6a/IgSRZIZYlUtUV0eU7unFIdFfGZCuq7kgfk7WamSrZBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116705; c=relaxed/simple;
	bh=pbMjXVwEQZcNpXzl8m7LMFt9/8jLL+StOFCJYgjOh+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnWm0ccO3kOsVDRuXMO0aeJnY+nmoiekj/lIZqneXZ2p27ZQa+TKlKkiBYEsNU3Slo9rCCDF4R9L55c6GsLuxrOaAlwHVwWO4kuQ5lhWjtoJfG8B4xO+7dBxgnQBq6RRoHr+hzSRZegZttFuwaq9JLIpi7IJPUczCj2LEqk9ldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/ARPoIj; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/ARPoIj"
Date: Wed, 22 Oct 2025 00:04:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761116700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6XSSTLCS1TZ0ZhjGf5BQOvNt71mRr5p/Fed2+JopWuw=;
	b=o/ARPoIjdXq6DC7H4kMGg4IR7zH3Hgd+Sg9m5PjudMvw7zpP2FrsbHRwuTGQIg9fo+7VjT
	WTVtZRRdybkM+TAP2GoWyEkmZyzF7wMMWGEHT7FSeIB/zIXpG0/IfptMg2Xu+vv86JonuS
	E3DxBLhe4VLPTAuSc4NwP7tpk1EzbC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when
 GICv3 is configured
Message-ID: <aPiCF97QlTHAo6Jo@linux.dev>
References: <20251013083207.518998-1-maz@kernel.org>
 <20251013083207.518998-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013083207.518998-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 13, 2025 at 09:32:06AM +0100, Marc Zyngier wrote:
> Drive the idreg fields indicating the presence of GICv3 directly from
> the vgic code. This avoids having to do any sort of runtime clearing
> of the idreg.
> 
> Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 4c3c0d82e4760..2c518b0a4d81b 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -161,10 +161,16 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  
>  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>  
> -	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
> +	*__vm_id_reg(&kvm->arch, SYS_ID_AA64PFR0_EL1) &= ~ID_AA64PFR0_EL1_GIC;
> +	*__vm_id_reg(&kvm->arch, SYS_ID_PFR1_EL1) &= ~ID_PFR1_EL1_GIC;

I'd prefer this to be done as a kvm_read_vm_id_reg() / kvm_set_vm_id_reg(),
if only to ensure this flow hits the config_lock lockdep assertion like
other writers of the ID registers.

Thanks,
Oliver
