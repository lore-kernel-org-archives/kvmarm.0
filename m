Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F6920297F
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230107; cv=none; b=jnXtu/LiIUdIivz/WW46vv3iQHjS+OTE5oKAS5g/IX7m3CjPLwOWHS0fmp08bpeDx7YwgM3oRj15zwcfTt4KYmpyT1omAC+Qyr+BOm6Cv1A/rm+27s7KsrNNHHwEDSrIlKBewX2zBv12nFPt95VYRVFJkFd36pBJugR6T/YgsDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230107; c=relaxed/simple;
	bh=KRMMggr7mJGhbXIuFAZlNauIkkFFP3ZpQpH52aqAhUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uj2BPLQJ7sMr6MchusXmX61EqJuvSj04o8uvW6RX3jml0rquiDUKeDOe6KVi+9ogGt9VviFvuKL2NZN+wKmj3EMbynpI3HIDHM4e4RfMaCQgKhw1DX644oE2UikFO281Qb3hM8pbQUZYGetmZky/UgiOrkhnyE45VjQNU+yWQVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CTi9Cy9v; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CTi9Cy9v"
Date: Wed, 9 Apr 2025 13:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744230103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G69pC/4W/QZaHjnKi7YS0ZiEO6jpBrj4cDS7fNNEBl0=;
	b=CTi9Cy9v7gVIiYj8VwyuYntA/nxdFd/RV+xWD6t8S0j68/HXxfwwBx8vLXpu/JcdrmEbvz
	wDQZEYHjaxRw4VMsKHzGg4ioxrjB6OhGRQJ7HE5RGR0LOCZOjyGkMj1weJRAFel4IA1vTn
	d4W+KNCGLS066r/lIm91byDUQ0Cz7mQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Message-ID: <Z_bWzRSgyom1_hvJ@linux.dev>
References: <20250409160106.6445-1-maz@kernel.org>
 <20250409160106.6445-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409160106.6445-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 09, 2025 at 05:01:01PM +0100, Marc Zyngier wrote:
> The MDCR_EL2 documentation indicates that the HPMN field has
> the following behaviour:
> 
> "On a Warm reset, this field resets to the expression NUM_PMU_COUNTERS."
> 
> However, it appears we reset it to zero, which is not very useful.
> 
> Add a reset helper for MDCR_EL2, and handle the case where userspace
> changes the target PMU, which may force us to change HPMN again.
> 
> Reported-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 13 +++++++++++++
>  arch/arm64/kvm/sys_regs.c |  8 +++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a1bc10d7116a5..4dc4f3a473c3f 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1033,6 +1033,19 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>  
>  	kvm->arch.arm_pmu = arm_pmu;
>  	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);

nit: Can we rename pmcr_n to nr_pmu_counters? The current name is misleading.

> +
> +	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
> +	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
> +		struct kvm_vcpu *vcpu;
> +		unsigned long i;
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +			val &= ~MDCR_EL2_HPMN;
> +			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.pmcr_n);
> +			__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
> +		}

Shouldn't we be taking the vCPU mutex(es) here?

Thanks,
Oliver
