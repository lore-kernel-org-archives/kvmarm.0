Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F433F44D0;
	Thu, 24 Sep 2026 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267159; cv=none; b=gsDN8vWCCvTX2lUL7amtmK9nRAoBHtMxPiRXjkOERF2sYDW52WoplU6TCdI1b8CcgAZOJIoxLcWp6CzgI35vWyQrUmC4neGEoklzzOGe//n8rT8g/orZcFyva3NrJ4DkbO+5h1xZQWzuZUmL74b5WtLO5gmPTIIglMxcX/ejsOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267159; c=relaxed/simple;
	bh=TKiEo/CWXEF+EeD1xHtmS5GpJ8VQt6W+WtZS/8DuxTY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IcaoAfKP1RKsM4d6UfqoJYC4H0RQaR1uGaQMmtRcbA90t4xSBeS3FxdSFXo2e5BB6gtiuapMBDfqvsxLlHlRlRHG9tMCZstKteT5za1BlDiX6FRFFT3QMWzyfKT5jr8F3+O3L4RSIDPNATYISryZGIWOVcb2VvQQFZjpU4tW6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRFLVemd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRFLVemd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766101F000FF;
	Thu, 24 Sep 2026 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790267157;
	bh=FT09YpekquXDNrqRsZLeKliq6DvYj8VBiERd7t3uQ/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PRFLVemdSE3nxIuC+amzwYmQH485NhriN4XMEl+n3P5oNeTHjwn0QbtNY4L/RrmSJ
	 GbNVwjcaYWJcRUY6WYJ9S+Yp17xGCzgATg6uaSvf032itn8tPGn0qVkX8/83JjcM2V
	 p1SIXHYun4/ggPK7tDgSekdFl+uYtsd7VBZ4yCqYL0i2u0dv32AF3vYX2IGXhFFDQS
	 ms0yl3Ahjw+nkODLsOQiMTxRYHkug1Zo+QNMhGMifHq1pO4clHQpPqix6jkqLCK5pf
	 LQnBDcTsNWjHyUORFqAvP4gDHH9rZNjC0jvIdY/z30w+0JF07jiLkttaee0uQzQ4N2
	 NE9+mDBOKP+MA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 18/22] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260924160504.853911-19-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
 <20260924160504.853911-19-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 16:25:56 +0000
Message-Id: <20260924162557.766101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: CCA: Realm VCPU features bypass capability allowlist
--

commit e303d487e75069060645d8d27a0d2607328fb9fc
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests

Limit the capabilities that are allowed for Realm VMs. Similarly block
the vm_ioctls backed by the capabilities.

Repurpose the kvm_pkvm_ioctl_allowed() to support both pKVM and Realm
ioctls. Rename the helper to kvm_vm_ioctl_allowed() and move it
into arch/arm64/kvm/arm.c. Also add a generic kvm_vm_ext_allowed()
to handle pKVM and Realm capability filtering and route them accordingly.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0e77f59ded6d9..106b52e556e20 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -136,6 +136,49 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_exiting_guest_mode(vcpu) =3D=3D IN_GUEST_MODE;
>  }
> =20
> +static inline bool kvm_vm_ext_allowed(struct kvm *kvm, long ext)
> +{
> +	/*
> +	 * We could be called with kvm as NULL, so can't use kvm_vm_* for pKVM
> +	 * flavors
> +	 */
> +	if (is_protected_kvm_enabled())
> +		return kvm_pkvm_ext_allowed(kvm, ext);
> +	else if (kvm && kvm_vm_is_realm(kvm))
> +		return kvm_realm_ext_allowed(ext);
> +	else
> +		return true;
> +}

[Severity: High]
While this patch correctly limits VM-level capabilities and ioctls for Realm
VMs, does it miss restricting VCPU-level features during initialization?

Looking at kvm_vcpu_init_check_features() in arch/arm64/kvm/arm.c:

static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
					const struct kvm_vcpu_init *init)
{
	unsigned long features =3D init->features[0];
	...
	if (features & ~system_supported_vcpu_features())
		return -EINVAL;

Since system_supported_vcpu_features() only checks global host capabilities,
can a malicious userspace process managing the VM enable restricted VCPU
features (such as KVM_ARM_VCPU_PMU_V3 or KVM_ARM_VCPU_EL1_32BIT) on a Realm
VCPU?

If userspace creates a Realm VM and VCPU, then invokes the KVM_ARM_VCPU_INIT
ioctl with restricted features set in init.features[0], this could activate
host KVM emulation logic for a Realm. Would this break the intended isolati=
on
boundary and lead to inconsistent state or host/RMM crashes when KVM attemp=
ts
to emulate hardware for a Realm managed by the RMM?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924160504.8539=
11-1-suzuki.poulose@arm.com?part=3D18
