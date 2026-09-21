Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306CF2580F2;
	Mon, 21 Sep 2026 07:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974560; cv=none; b=hENWsekAAa8Rk534ngRlsZWwsBmuzQlP+OZsJyF8T6EEE1NryQtIcBin5TbheWhhoM8vCfI94A1nOWpUKK51tzSqjPOzVGwz7KzOeoLcRqoW2tpvinwcf2aAT+Sz2RZ4ccy+g3ikQBI7JIfor56iQZcsHO6B0zmvZhl24V3Rkrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974560; c=relaxed/simple;
	bh=YWp9yyTYvwNPegixRFPoINomQRv6/h1pbRYActZZKF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjOWw9/4IEoNIAul/b8PpYg2UjYHmfYnjX6JX/UHB/F+pyTKsk7b8DTso1xRnAYmyDi7VV+6x5qGaOitdg9SuMCXgbtE5MycoRsy8aahWKiL7CrcObDUjat77g+0loKON1jZ5gnIWRu4Ycmu7DYY2Dk0jAXELQNtojtpTMfwepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifECKoSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifECKoSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDF11F000FF;
	Mon, 21 Sep 2026 07:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789974558;
	bh=7zgk872CgQmAHV14Qfyxg/FEnkqmHGMnxfF1BBY1yrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ifECKoSlHbavrN+0+bCRxvFwjygcAWnLw2r6GesTzN6CMULnk1vSJX+4nqfVCL4RB
	 zLPinjhdhuz85QTjxp47XNBB6Nd5e3dDVvKIQ65AvYi4GTWXQ5XL8sMm881IVpW2hj
	 s5VqgOyodRr+tYDDYo+hcXJmvQVrgXmRQ7sX//CzMjnDIB17DppiJnz+GANEFLwz2C
	 feTy7h5vyRQZLjGPOXyzPC5+3SB4Ps/DsbY05LAmdA0C5uC2Vp4het7qNxj9bS6IdV
	 AqGSvpfZbLfXEejSDqN1cxPGv8LBT826V5eONP8BbYI6u5Ryg+KD+FtfJfd/LHJT0V
	 TZHHQpt+rx0FQ==
Date: Mon, 21 Sep 2026 00:09:17 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Jack Thomson <jackabt@amazon.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
Message-ID: <arDYHSlFHm_XzGvN@kernel.org>
References: <20260921063718.1604533-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921063718.1604533-1-fuad.tabba@linux.dev>

Hi Fuad,

On Mon, Sep 21, 2026 at 07:37:18AM +0100, Fuad Tabba wrote:
> __kvm_vcpu_set_target() copies the requested features into the VM-wide
> bitmap before kvm_setup_vcpu() runs and doesn't undo it when setup
> fails, so a rejected KVM_ARM_VCPU_INIT leaves the VM recording features
> that were never set up. With HAS_EL2 | HAS_EL2_E2H0 on a host without
> FEAT_NV1, kvm_vcpu_init_nested() returns -EINVAL before it allocates any
> nested stage-2 MMU, and vcpu_has_nv() is then true with
> nested_mmus_size == 0; its -ENOMEM paths do the same on a VM's first
> INIT.
> 
> Nothing in the tree loads a vCPU whose init failed, so this is latent.
> The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
> it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
> or not the vCPU has been initialised.

That's a bug, not a feature. We should require an initialized vcpu for
the ioctl.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index eaf583b771931..b25725f91c925 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1685,6 +1685,7 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  				 const struct kvm_vcpu_init *init)
>  {
> +	DECLARE_BITMAP(old_features, KVM_VCPU_MAX_FEATURES);
>  	unsigned long features = init->features[0];
>  	struct kvm *kvm = vcpu->kvm;
>  	int ret = -EINVAL;
> @@ -1695,11 +1696,15 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  	    kvm_vcpu_init_changed(vcpu, init))
>  		goto out_unlock;
>  
> +	/* Setup reads the VM-wide bitmap, so undo the copy if setup fails. */
> +	bitmap_copy(old_features, kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>  	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
>  
>  	ret = kvm_setup_vcpu(vcpu);
> -	if (ret)
> +	if (ret) {
> +		bitmap_copy(kvm->arch.vcpu_features, old_features, KVM_VCPU_MAX_FEATURES);
>  		goto out_unlock;
> +	}

The bitmap copy is a bit confusing because there's only two possible
situations:

 - KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is unset and the bitmap was
   previously zero

 - KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is set and @init->features is
   identical to vcpu_features (see kvm_vcpu_init_changed())

While there's nothing wrong with your diff, I'd prefer if the above
detail was represented directly.

	ret = kvm_setup_vcpu(vcpu);
	if (ret) {
		/*
		 * Clear the bitmap if setup fails on the first vCPU to be
		 * initialized.
		 */
		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
			bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);

		goto out_unlock;
	}

Thanks,
Oliver
