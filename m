Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2828E3D7D7B;
	Wed, 13 May 2026 07:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778659065; cv=none; b=iM4CsKxinSt0kMKdlQG81yRxBgFUv3bqvsaWX6cxT3c+gqJe17tT1dlTMRDaOtIUhlpfBlZaJtSfkgNERDqr3Vh9ICV7DYZ7fdJykmcG6uB3HIRt3WCkw3R6Cr0aqp+9XjxBCZnKd7NAIFhUn4LMGmBMzS87/8tciXkoUT8PFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778659065; c=relaxed/simple;
	bh=bR1i92frDxooM1/4hRznpgGK1PwGwO8I8wpOQKsxaig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C+vO9UbNPwAuNHeJSv/JQeQEkiPE2+vn+z0IFFyspa20PJGigqnWkTOmn6Wkj8Gb2VP5f5gvT118Qb2apbGc1tgpaguu7eVJWYjOeVn0LJrYf1briCWYyJiW/Yo8VP8QCnOZXSywa8L0KqnmQaRzqaGCWDZzCaP/6TTVbeAm1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orykS+qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orykS+qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D17CC2BCC7;
	Wed, 13 May 2026 07:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778659064;
	bh=bR1i92frDxooM1/4hRznpgGK1PwGwO8I8wpOQKsxaig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=orykS+qrrrRNFxk7x/UmKrWLdvYQkQowPXI0p076mIuKFeymoBdbMkuIrhPF7xc1o
	 aVTVCBoGbkyvc48jQn598HmxZ9Ar+o/yssqekrG3bWfzyXG5A5A+Zfcswc7eY/pjMg
	 fT6a2+VyuOvcLb/vM8Hn2wK5zFC4yN2BLQTLNgrE0mXArVrIS3qNlmuAZ7q70TFYxR
	 bDEMt1EpMfDA/37IbfOnPT/dcluEhOvlwGEcl4ZArCPY1PaYqgmnCeAANHks7QtDBv
	 uMAoPxGcaERtzu4+rI623u1q+YlsWgG/fXhqcgzfnXIHC9OXl9EUnAlQfY9oRRp6Dv
	 19/arP+5NHgzw==
Date: Wed, 13 May 2026 00:57:42 -0700
From: Oliver Upton <oupton@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v7 09/20] KVM: arm64: Set up MDCR_EL2 to handle a
 Partitioned PMU
Message-ID: <agQu9kLnbHjSni-C@kernel.org>
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-10-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504211813.1804997-10-coltonlewis@google.com>

On Mon, May 04, 2026 at 09:18:02PM +0000, Colton Lewis wrote:
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 3ad6b7c6e4ba7..0ab89c91e19cb 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -36,20 +36,43 @@ static int cpu_has_spe(u64 dfr0)
>   */
>  static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  {
> +	int hpmn = kvm_pmu_hpmn(vcpu);
> +
>  	preempt_disable();
>  
>  	/*
>  	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>  	 * to disable guest access to the profiling and trace buffers
>  	 */
> -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
> -					 *host_data_ptr(nr_event_counters));
> +
> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
>  	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>  				MDCR_EL2_TPMS |
>  				MDCR_EL2_TTRF |
>  				MDCR_EL2_TPMCR |
>  				MDCR_EL2_TDRA |
> -				MDCR_EL2_TDOSA);
> +				MDCR_EL2_TDOSA |
> +				MDCR_EL2_HPME);
> +
> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
> +		/*
> +		 * Filtering these should be redundant because we trap
> +		 * all the TYPER and FILTR registers anyway and ensure
> +		 * they filter EL2, but set the bits if they are here.
> +		 */
> +		if (is_pmuv3p1(read_pmuver()))
> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
> +		if (is_pmuv3p5(read_pmuver()))
> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;

Neither of these controls are of any consequence on unsupported
hardware (RES0). Set them unconditionally?

> +		/*
> +		 * Take out the coarse grain traps if we are using
> +		 * fine grain traps.
> +		 */
> +		if (kvm_vcpu_pmu_use_fgt(vcpu))

I think open coding the check here would actually improve readability.

		if (cpus_have_final_cap(ARM64_HAS_FGT) &&
		    (cpus_have_final_cap(ARM64_HAS_HPMN0) ||
		     vcpu->kvm->arch.nr_pmu_counters != 0))
			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
> +
> +/**
> + * kvm_pmu_hpmn() - Calculate HPMN field value
> + * @vcpu: Pointer to struct kvm_vcpu
> + *
> + * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
> + * partitioned, this is the number of counters set for the guest if
> + * supported, falling back to max_guest_counters if needed. If we are not
> + * partitioned or can't set the implied HPMN value, fall back to the
> + * host value.
> + *
> + * Return: A valid HPMN value
> + */
> +u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
> +{
> +	u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
> +
> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)
> +	    && !vcpu_on_unsupported_cpu(vcpu)
> +	    && (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0))
> +		return nr_guest_cntr;
> +
> +	return *host_data_ptr(nr_event_counters);
> +}

This helper isn't helpful. Just open code it in the place where we are
computing MDCR_EL2.

> @@ -542,6 +542,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
>  		return 1;
>  
> +	/*
> +	 * If partitioned then we are limited by the max counters in
> +	 * the guest partition.
> +	 */
> +	if (kvm_pmu_is_partitioned(arm_pmu))
> +		return arm_pmu->max_guest_counters;
> +

Ok, this is exactly what I was getting at earlier. What about a VM with
an emulated PMU? It should use cntr_mask calculation, not the guest
range.

Thanks,
Oliver
