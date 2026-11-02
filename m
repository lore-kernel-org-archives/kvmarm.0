Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631931;
	b=ttZMt9m7thH2PV8bXsNUnKauo1HH08Eh5rKQ971wp/ZRv7wmF/Dy6Qel9CP0BgB1+83O
	 EuiS/YgG3aisGCH9C6lgwDyYj6OnYq1KkpYZnJfdcbUVphufWQjeuJQbO9x/TdKQJqZMT
	 +vj7B2ISrM16OMkEuIhjwnFAmhweuqImqO4LnnYtBmvZvMysOlH+N7w6CaT6C6tPNlBYm
	 jq5mF9rZTHBHO9++O1Dw4KgPwFIkwiM7bol+RrXVw46MPKW3UwP3hIsvkiKS+xJ7KiCuX
	 MAxJlmIGJeKNE2jUGAQMZ1aEyNXNKEnC98Kvi/HuLmQaQGk4uh9bJe4Uq9aAuU4lObg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631931;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=X+UT+byrE0jZoNDfAKw7V84nblODh2jj2mA2zA3zSFA=;
	b=OnoXzgILaL8ylgXyz+GXu+SZggRhpCnIrfx83r7NXionEmCrj6dLyZXoxXiXjNsVGTFo
	 VVjUEzIUBbiB69c/UQblfHvRp0fmSRS0n8Hcsae8uw1raTg7JFLfQQBaZgSVyCNvRDksa
	 bNcN28Addzdamty2zR464ID7S2jO/hmQsm6+sKVCpbmS4jnlwTP7axhbDKady4SAeBYgo
	 ps4irIxBubH92JuPx6NIoHdc/pG2eAtHmt20i0E0/wjPYBzELTDSJUFz6WOPrgR53ZJvy
	 bsJkjTVT0IvYCwuuk1pzcJj2cBHPe1JZrp0LqxOMQjHjCqvIj92fNkIIqPeHQXeQpjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KS8lQxeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22AB606A914;
	Mon,  2 Nov 2026 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KS8lQxeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F5B1F00A18;
	Mon,  2 Nov 2026 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631930;
	bh=X+UT+byrE0jZoNDfAKw7V84nblODh2jj2mA2zA3zSFA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KS8lQxeII+BTqd1wjOu3NA/D7cwPImgGnm6oKKec5GC9MxQygmcrR+7xFdDOO0Or5
	 TxRn4V87l73YSJwJhaO8FSmCqif5A98SqVBClkHRfbbXhmf4WO9hr2Eb6AZg6MWXkq
	 dTg+dOAU2q6L+QCvFmVQOxPO9XW3GC0WkoC7OLMCPIveHMPkLpMNb9OukQu5vrPaoI
	 rQnhKAbr6hbyBItbAuooCird0UBbUKfU1PMiaoAQjEgYinnmJedu3sCweQvf8v0s7j
	 7DCci4ta4S/tvEIwD4SUhSWnf/q+NuXdduCsdW7n9BTg8XpUAmsKK7ObQMBth/WdKR
	 e4dxQJH+Fw2cg==
Message-ID: <sashiko-outbox-193628@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/11] KVM: arm64: CCA: Add basic infrastructure for
 creating a realm
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-7-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-7-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 15:05:29 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: arm64: missing realm->ia_bits initialization in kvm_init_real=
m()
- [Medium] KVM: arm64: cca: clamp Realm IPA limit to host limit in kvm_init=
_ipa_range()
--

commit e03ea9b753f8211e9e93f2e5edff9ba91b09d112
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Add basic infrastructure for creating a realm

This commit introduces the initial functions and state structures for
creating and destroying a Realm VM, and checks the requested IPA size
against the RMM's supported Stage-2 address size.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1301c563d7052..b049ea67d9af3 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -981,10 +981,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops =3D {
> =20
>  static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>  {
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
>  	u32 kvm_ipa_limit =3D get_kvm_ipa_limit();
>  	u64 mmfr0, mmfr1;
>  	u32 phys_shift;
> =20
> +	if (kvm_vm_is_realm(kvm))
> +		kvm_ipa_limit =3D kvm_rmm_ipa_limit();

[Severity: Medium]
Should kvm_init_ipa_range() clamp kvm_ipa_limit with min(kvm_ipa_limit,
kvm_rmm_ipa_limit()) instead of overwriting it?

In arch/arm64/kvm/rmi.c, rmm_check_features() only rejects the case where
kvm_lpa2_is_enabled() is true and the RMM lacks RMI_FEATURE_REGISTER_0_LPA2:

	if (kvm_lpa2_is_enabled() &&
	    !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
		kvm_err("RMM doesn't support LPA2\n");
		return -ENXIO;
	}

It does not prevent running with !kvm_lpa2_is_enabled() when the RMM suppor=
ts
LPA2 and reports a 52-bit S2SZ in RMI_FEATURE_REGISTER_0_S2SZ, or when S2SZ
exceeds the host's sanitised ID_AA64MMFR0_EL1.PARange. Meanwhile,
kvm_set_ipa_limit() caps get_kvm_ipa_limit() to 48 bits when
!kvm_lpa2_is_enabled() && PAGE_SIZE !=3D SZ_64K.

If kvm_rmm_ipa_limit() is larger than get_kvm_ipa_limit(), overwriting
kvm_ipa_limit allows userspace to create a Realm via
kvm_arch_init_vm()->kvm_init_stage2_mmu()->kvm_init_ipa_range() with
phys_shift > get_kvm_ipa_limit(). That causes kvm_get_vtcr() to configure
VTCR_EL2_T0SZ for 52 bits without VTCR_EL2_DS, kvm_pgtable_stage2_init() to
attempt allocating 256 concatenated PGD pages, and kvm_handle_guest_abort()
to inject an address size fault for any fault_ipa >=3D
BIT_ULL(get_kvm_ipa_limit()):

		/* Beyond sanitised PARange (which is the IPA limit) */
		if (fault_ipa >=3D BIT_ULL(get_kvm_ipa_limit())) {
			kvm_inject_size_fault(vcpu);
			return 1;
		}

[ ... ]

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 5b07beff8bc91..45ecbaa467d1d 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> +int kvm_init_realm(struct kvm *kvm)
> +{
> +	struct realm *realm =3D &kvm->arch.realm;
> +
> +	realm->sro =3D kmalloc_obj(*realm->sro);
> +	if (!realm->sro)
> +		return -ENOMEM;
> +
> +	return 0;
> +}

[Severity: High]
Where does realm->ia_bits get initialized?

This patch adds unsigned int ia_bits to struct realm in
arch/arm64/include/asm/kvm_rmi.h and calls kvm_init_realm() from
kvm_arch_init_vm() after kvm_init_stage2_mmu() has configured
kvm->arch.mmu.vtcr, but neither kvm_init_realm() nor kvm_init_ipa_range()
sets realm->ia_bits (for example to VTCR_EL2_IPA(kvm->arch.mmu.vtcr)).

Later patches in the series ("KVM: arm64: CCA: Tear down RTTs", "KVM: arm64:
CCA: Add Realm RTT mapping and invalidation helpers", and "KVM: arm64: CCA:
Support runtime faulting of memory") read realm->ia_bits in
get_start_level(), realm_destroy_rtts(), realm_unmap_stage2(),
realm_unmap_shared_range(), kvm_realm_unmap_range_filter(),
kvm_realm_is_private_address(), and kvm_gpa_from_fault(). With realm->ia_bi=
ts
left at 0, expressions such as stage2_pgtable_levels(realm->ia_bits),
(1UL << ia_bits), and BIT(realm->ia_bits - 1) will compute wrong RTT start
levels, wrong IPA bounds, and undefined shifts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D6
