Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0921E0DAD
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728503735; cv=none; b=taxn46AD1xUAfQ8qXZ9fQtFba9+Ad/wADr26rOwNwDKl3po9kkMaHuX2ybqLlpr5xpHrfJIS5ZsFFYvMgKJ3Pt6jJQZr6FSWMvRMcMJoDdZiQWA1U7dstHtMfU3jKqk8vXeTXFGAn/1GvWf9TYrRc0DV3PANIax+UL4PPnlGfcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728503735; c=relaxed/simple;
	bh=Sc4nKdsPXx5tCl7kmTjYsRcV+p7U/RIuhom/uIbzdng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8LbQ5IAWa0J2HfmaxNrgvIfSNJdGbVjgGnfyi3odkFVlwWMeVVxd663YicEpusApAjicboRMgcRE4oLNJeV0tCz81o2UHtbIKK4xaCzjmSAqlSdVjO+07cLEbTXvF+3zWzohcNwWihFMybaqwf7za2/giIeIaRPE2pu1pEKiCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hhBUjPzv; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hhBUjPzv"
Date: Wed, 9 Oct 2024 12:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728503730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HZO8ZUZ4JIYjAEgdyh9A4+ZHn421cNn46YVdgA+yVeY=;
	b=hhBUjPzv2ppG7U3cT1WxcIVI+Ynk3LJC5aRTUlzkg1L8ZjZfvX8szPPsA7CIni6wh9ZNB3
	cZCmKsQjlK8P2TPb0VN4+w0SsEe56T6uSgi335RaAcOYmdZAWghYnPp64jeCbrYjhNCtcV
	bII/V3+ViQ2fwKsYl5ApipIztcH6Rxo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 07/36] KVM: arm64: nv: Save/Restore vEL2 sysregs
Message-ID: <ZwbfqaxYFoThx_mc@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 07:59:50PM +0100, Marc Zyngier wrote:
> +static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
> +{
> +	u64 val;
> +
> +	/* These registers are common with EL1 */
> +	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
> +	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
> +
> +	write_sysreg(read_cpuid_id(),				vpidr_el2);

I don't think we need to restore VPIDR_EL2 here, so long as we do it on
vcpu_put() when leaving a nested VM context. That seems like the right
place to have it, as we could be running a mix of nested and non-nested
VMs and don't ever poke VPIDR_EL2 for non-NV VMs.

> @@ -89,7 +192,29 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
>  	 */
>  	__sysreg32_restore_state(vcpu);
>  	__sysreg_restore_user_state(guest_ctxt);
> -	__sysreg_restore_el1_state(guest_ctxt);
> +
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt))) {
> +		__sysreg_restore_vel2_state(vcpu);
> +	} else {
> +		if (vcpu_has_nv(vcpu)) {
> +			/*
> +			 * Only set VPIDR_EL2 for nested VMs, as this is the
> +			 * only time it changes. We'll restore the MIDR_EL1
> +			 * view on put.
> +			 */

Slightly ambiguous what "VPIDR_EL2" this is referring to (hardware reg
v. guest value). Maybe:

			/*
			 * Use the guest hypervisor's VPIDR_EL2 when in a nested
			 * state. The hardware value of MIDR_EL1 gets restored on
			 * put.
			 */

> +			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
> +
> +			/*
> +			 * As we're restoring a nested guest, set the value
> +			 * provided by the guest hypervisor.
> +			 */
> +			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
> +		} else {
> +			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
> +		}
> +
> +		__sysreg_restore_el1_state(guest_ctxt, mpidr);
> +	}
>  
>  	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
>  }
> @@ -112,12 +237,20 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
>  
>  	host_ctxt = host_data_ptr(host_ctxt);
>  
> -	__sysreg_save_el1_state(guest_ctxt);
> +	if (unlikely(__is_hyp_ctxt(guest_ctxt)))
> +		__sysreg_save_vel2_state(vcpu);
> +	else
> +		__sysreg_save_el1_state(guest_ctxt);
> +
>  	__sysreg_save_user_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  
>  	/* Restore host user state */
>  	__sysreg_restore_user_state(host_ctxt);
>  
> +	/* If leaving a nesting guest, restore MPIDR_EL1 default view */

typo: MIDR_EL1

> +	if (vcpu_has_nv(vcpu))
> +		write_sysreg(read_cpuid_id(),	vpidr_el2);
> +
>  	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
>  }
> -- 
> 2.39.2
> 

-- 
Thanks,
Oliver
