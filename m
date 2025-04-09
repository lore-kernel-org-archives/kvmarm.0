Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B2421481D
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230575; cv=none; b=OTBgUGNDBc9qo3B693aoPF57qWIrV4DmlyoWVkY0vquRiTUB7t7SbU8C54+Fq5EKnUHnQMsnB5Om4z36vOyThtRTvKBddtO07FKThuuU6vpQTUCtRmQkqUTINlub3rz/enz+hHYEg5xuGCMLh/VLjWUUt6S3newgQMF8L0q2PV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230575; c=relaxed/simple;
	bh=0ia5qCe2BpgBZcITCypk88iN9Wpb5lhnnHK8nuZh8IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6XxnQqyf8Y8bCvEVmHRIGWww76B31BdBbDotVnIHRVKDM5Q0qVcS8oH3Xa+B9oXOugo+8Rb4Os2IlzzvdPLHipEJmIAbbfsvDiSVKaMZkrBmIqrs6wRhmP40I2WJ7GHT84LfD8gJdbUUcuLZW4DIULGtTy0aCnp9qxUnc9ooHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i8EAhSbD; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i8EAhSbD"
Date: Wed, 9 Apr 2025 13:29:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744230571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8MWm6Fd/agMeB9eO07odRN2tJuMWbyOOIV2lDS1aT4U=;
	b=i8EAhSbD3oIJrrUWLt1yR8/WfDQQkIbD/PIUo5M/qIAZLkDido4pQfiVdeH8l6VFHnIGgV
	+47lGZWoXWLHzNKcZTCjyOaV8eufmJFCIQ8eY7BCKnZpoiFichCZUufJjIN6SNceN5YXYm
	5d2ekFidltTVmfuSoU4tZsOrYThobts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/6] KVM: arm64: Handle out-of-bound write to
 HDCR_EL2.HPMN
Message-ID: <Z_bYp_ow7hGKCZjx@linux.dev>
References: <20250409160106.6445-1-maz@kernel.org>
 <20250409160106.6445-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409160106.6445-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

HDCR? I thought you gave up on 32-bit a loooong time ago ;-)

On Wed, Apr 09, 2025 at 05:01:05PM +0100, Marc Zyngier wrote:
> We don't really pay attention to what gets written to MDCR_EL2.HPMN,
> and funky guests could play ugly games on us.
> 
> Restrict what gets written there, and limit the number of counters
> to what the PMU is allowed to have.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 00b5396492d51..e53b8f82ca7f8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2571,17 +2571,33 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
> -	u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +	if (!p->is_write) {
> +		p->regval = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +	} else {

nit: you can do an early return for an emulated read and get rid of a
level of indentation for the write case.

> +		u64 hpmn = FIELD_GET(MDCR_EL2_HPMN, p->regval);
> +		u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +		u64 val = p->regval;
>  
> -	if (!access_rw(vcpu, p, r))
> -		return false;
> +		/*
> +		 * If HPMN is out of bounds, limit it to what we actually
> +		 * support. This matches the UNKNOWN definition of the field
> +		 * in that case, and keeps the emulation simple. Sort of.
> +		 */
> +		if (hpmn > vcpu->kvm->arch.pmcr_n) {
> +			hpmn = vcpu->kvm->arch.pmcr_n;
> +			u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
> +		}
>  
> -	/*
> -	 * Request a reload of the PMU to enable/disable the counters affected
> -	 * by HPME.
> -	 */
> -	if ((old ^ __vcpu_sys_reg(vcpu, MDCR_EL2)) & MDCR_EL2_HPME)
> -		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +		vcpu_write_sys_reg(vcpu, val, r->reg);
> +
> +		/*
> +		 * Request a reload of the PMU to enable/disable the
> +		 * counters affected by HPME.
> +		 */
> +
> +		if ((old ^ __vcpu_sys_reg(vcpu, MDCR_EL2)) & MDCR_EL2_HPME)
> +			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +	}
>  
>  	return true;
>  }
> -- 
> 2.39.2
> 

Thanks,
Oliver
