Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE184BB299;
	Tue, 15 Sep 2026 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490949; cv=none; b=IyUYcHjKEI6qDRC2jJpZzXuRNNLfbsSfMErkC755pJSGAbNM+WIubGdMMsx75ebl9qg57UPA09S2mbMAP9RoQ0AAZYKkCZAakEcUdbvcUKbAL5jm9sqQnFdGIXduaFZSVxXX++k1TUNKiMTylKT/qgS0xWq2SALlMdfsv8n7LmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490949; c=relaxed/simple;
	bh=d5TNoPThVfvDNTS0zdtXvlytOeowYGtm4Ib/+j13LBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XjGOD+lW+W1pY/7GIEqWBH5l+eq75eIC4JcH3EniqWq/uzwWcF54IWwEdDuKcj6ktdPZvuRg6fzQ3XiD4I5UQwBSZ1/L5Aef7olnoSuxUFcxgtPLPe8hKDK21OHoNiAa6pUkaV5F6ggx+ySRqpp2q9srgWGaQwRxMBtGMymvmPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ueu92SXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ueu92SXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9729B1F000FF;
	Tue, 15 Sep 2026 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789490947;
	bh=eBdB5BlVQd7/RSKFkVBdemwdP0kpPR7PsNIoCzA7544=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ueu92SXN3LBzbT1kZsqgP3QB0EyMTEZftCUTVsJOW2n/k/fxZQZH3O/f8JKfTZ6Xp
	 FPDm7E64zDKcBN4xcSINi2qvF4fVMT8ozX1sOg0eccgSG8mrkdApslWYgQ2TytoTkS
	 brb33td1wYlNu8WnXDPJBBh4S03pyEnhpvGH+BTw334THfrqTaYac1rseYpHwBVw0k
	 VobigM+2IeN147FZnz9pzKYaxN60g2LQneFZxNrDADxLREDnTgOPQTTBCK7BHmWFHM
	 /VocUnmnsSeb7wIDM7VebfHSOs95Pv6YsUI3kHm8uI0LpPBLPdenM+DqyFxcUmXbAP
	 i1i7c4LfYmiJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 23/23] KVM: arm64: CCA: Control user register access
 for Realms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260915160141.3543048-24-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-24-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 16:49:07 +0000
Message-Id: <20260915164907.9729B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm64: kvm: KVM_SET_ONE_REG rejects PMCR_EL0 for Realm VMs breakin=
g PMU config
--

commit 2d966a4231d9ac9707a0d74a6ba5b743ae7b69b3
Author: Jean-Philippe Brucker <jpb@kernel.org>

KVM: arm64: CCA: Control user register access for Realms

This commit restricts user register access for Realm VMs by limiting which
registers the VMM can read or modify. KVM explicitly allows access to
ID_AA64DFR0_EL1 and SVE_VLS for Realm parameter configuration before the Re=
alm
Descriptor is created.

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
[ ... ]
> +static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) =3D=3D KVM_REG_ARM_CORE) {
> +		u64 off =3D core_reg_offset_from_id(reg->id);
> +
> +		return kvm_realm_validate_core_reg(off);
> +	} else {
> +		switch (reg->id) {
> +		case KVM_REG_ARM_ID_AA64DFR0_EL1:
> +		case KVM_REG_ARM64_SVE_VLS:
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}

[Severity: High]
Does this logic unconditionally reject KVM_SET_ONE_REG calls for PMCR_EL0?

When the VMM attempts to restore or configure the PMU, kvm_arm_set_reg()
calls validate_realm_set_reg(). Because the UAPI equivalent of SYS_PMCR_EL0
is missing from this whitelist, the VMM is prevented from configuring the
number of PMU counters for Realm VMs, breaking VM initialization.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> +static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *=
vcpu,
> +						 u64 reg)
> +{
> +	if (!vcpu_is_rec(vcpu))
> +		return false;
> +
> +	switch (reg) {
> +	case SYS_ID_AA64DFR0_EL1:
> +	case SYS_PMCR_EL0:
> +		return false;
> +	}
> +	return true;
> +}

[Severity: High]
This explicitly unhides SYS_PMCR_EL0 in kvm_realm_sys_reg_hidden_user(),
meaning it is returned to the VMM via KVM_GET_REG_LIST.

Since validate_realm_set_reg() in arch/arm64/kvm/guest.c rejects writes to
the PMU register, does this create an ABI inconsistency where the register
is listed but cannot be set?

Could this mismatch in configuration flow be corrected to allow PMU support
for Realm VMs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915160141.3543=
048-1-suzuki.poulose@arm.com?part=3D23
