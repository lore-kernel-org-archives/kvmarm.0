Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508112E8B8D
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845557; cv=none; b=HCzMlRRV2OfMp2Yo9E7ZOL30J0W0cH/vRQNwI3p8MMKl6z4LJyE0NizzyKXQow21PSrYf+m9BraIuWWOeKXg0N9y0+z7OX4lbUhnunb2/ZqRVrkbq3usRrwzoQhFbNn7mtZ5XKoOiRFRVpv1zr1A9YRmNKQYVWplgslRePylD/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845557; c=relaxed/simple;
	bh=jLgV+Ozu4o70AcCXJA++YR4MO939yACBlwIJ27BPj0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MEseSUlgzasm/yyF/mmHhksLHMO2AYk49RRlhVhh2CL8gCnBwUqWCsOilqaVT1b6BpoTYLN8DvgC/A3o/nhDZB9+Q7lHSb0YZ9pHnMqI2mC0qY7AvExMs2ElARmOPq+eVpDVo7wOhWz/eNLGgKDaZwGGuJd4IhgNoA+gyHNZK1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5717A339;
	Thu,  4 Dec 2025 02:52:27 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AD8A3F59E;
	Thu,  4 Dec 2025 02:52:32 -0800 (PST)
Date: Thu, 4 Dec 2025 10:52:30 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v3 4/9] KVM: arm64: Handle FEAT_IDST for sysregs without
 specific handlers
Message-ID: <20251204105230.GB98666@e124191.cambridge.arm.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-5-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:48:01AM +0000, Marc Zyngier wrote:
> Add a bit of infrastrtcture to triage_sysreg_trap() to handle the
> case of registers falling into the Feature ID space that do not
> have a local handler.
> 
> For these, we can directly apply the FEAT_IDST semantics and inject
> an EC=0x18 exception. Otherwise, an UNDEF will do.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 616eb6ad68701..fac2707221b47 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2588,6 +2588,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  
>  		params = esr_sys64_to_params(esr);
>  
> +		/*
> +		 * This implements the pseudocode UnimplementedIDRegister()
> +		 * helper for the purpose of fealing with FEAT_IDST.
                                            *dealing

> +		 *
> +		 * The Feature ID space is defined as the System register
> +		 * space in AArch64 with op0==3, op1=={0, 1, 3}, CRn==0,
> +		 * CRm=={0-7}, op2=={0-7}.
> +		 */
> +		if (params.Op0 == 3 &&
> +		    !(params.Op1 & 0b100) && params.Op1 != 2 &&
> +		    params.CRn == 0 &&
> +		    !(params.CRm & 0b1000)) {
> +			if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
> +				kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +			else
> +				kvm_inject_undefined(vcpu);
> +
> +			return true;
> +		}
> +
>  		/*
>  		 * Check for the IMPDEF range, as per DDI0487 J.a,
>  		 * D18.3.2 Reserved encodings for IMPLEMENTATION
> -- 
> 2.47.3
> 

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
