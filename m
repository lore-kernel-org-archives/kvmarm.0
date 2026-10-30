Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793358584;
	b=AEsQBKGuyk9yQ4Cr+RmJxzq9ofp6K0Hel5307lxYzlKFqaclHk4HPRW7OiJreUP/n0Q1
	 pErm0RFsmZiGQ9KGvJCRW2UbJnCqb4dddtcX2GcmZFlFwCdzxOE2PEnFjK5M0xw7EFNJN
	 H6W4BhVRQ4gK3vD3LBNBjQFBTSnlTOoWq20tAyRkAasvy78G6GQauHfGsz2griDiH578/
	 PrBUAb7LSmYWzcvkbFOCQpvpxQ1OtVTqxPrLVDQiFaW4n479tlERYQ0s+Uo/ZTc7DdkuR
	 KbX3UbwHVF/0p3PDJ6SeBh/cplQGPEKSE0EHRYQdfGd/CBJUQ//iFpC1oPNJGmfvrJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793358584;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8WoMRCc/S5XxQ6dzf0Vot7qM8Zz5Z1n+1sVhMT7/3FE=;
	b=UFrCvlGKlkr35YMscBhF2mJI7kC1Jea/AJhubEKteztoAYxa52T4UqcdmKHPnY3np5KU
	 kp4G6uR06TtDnTPI7253VX23d7P0WLORjFhZTjjRny0Ndp2TuGRO0y1rDXrR9nAqDVIwJ
	 e/TDkvT6g3UguozWhJlxSKoW+7izvF0AXqNkEq2VopP3ZvKDClfYuCYeS9ug/pwGgCkBw
	 QwRgCG+ZTjtOjJn20FuNL8bHILYWKw85Lp9AvBLmc4QujYmV210E3JlnCzBRAz3mWH3YH
	 /Nvxcwub900XxEbicUON0K96q5tTNjZ7G/Mako2asC3/Gwors+2GpVPNaH9d68/DEsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H8Ec74G3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE16606A31D
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 11:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H8Ec74G3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D523F1F000C1;
	Fri, 30 Oct 2026 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793358584;
	bh=8WoMRCc/S5XxQ6dzf0Vot7qM8Zz5Z1n+1sVhMT7/3FE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H8Ec74G3s36rhGNSq7WxZRLcW/CKB4vvpcMPuGoFa4edbILcect895RNVwx2AWZow
	 DDnivVLysuvg/bY6D9ffsxiNbq18M/CuaumD5FRpYyyL2xc885alU7/6P1r6xCRPDQ
	 rYdvzxzzbWhdXN3Ud8v9UE3TVsh/in+w7bZuEuaYHd2HGPceOGQ0BwtKZPGvwmzUiP
	 QPEAOZaBufcavg4Tz0DdQTYenVHvazDAhvcIsqjhgmnaBzC6TJ4NRsuCCOxdhopqBI
	 Z/iWRAc3B4xN69sKcIu1Ay9NXczXlL/xdHHx8kSS21BtfEEaEwlnDGzzU3bhX3kLlw
	 cox3Bqe8cd5Ow==
Message-ID: <sashiko-outbox-190923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261030105139.3543230-1-fuad.tabba@linux.dev>
References: <20261030105139.3543230-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 11:09:43 +0000
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
- [Medium] KVM: arm64: nv: wrong fault injected in kvm_handle_guest_abort()
- [Medium] KVM: arm64: nv: uncapped max_oa_bits in setup_s1_walk()
--

commit 67127beccb09ede5294ce8bb377da5dd05338982
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap

This commit caps kvm_get_pa_bits() at 48 bits when KVM_ARM_VCPU_HAS_EL2 is
set on the VM so that nested stage-2 MMUs, emulated TLBI ranges, nested
page-table walks, and AT checks are sized to the PARange exposed to a
nested virtualization guest rather than the host IPA limit.

> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 10eb7249aa9e8..1918837757682 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -220,6 +220,10 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> =20
>  u32 kvm_get_pa_bits(struct kvm *kvm)
>  {
> +	/* An NV guest's PARange is capped by limit_nv_id_reg() */
> +	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features))
> +		return min(kvm_ipa_limit, 48U);

[Severity: Medium]
When kvm_get_pa_bits() caps an NV guest at 48 bits on a 52-bit host,
init_nested_s2_mmu() initializes the nested stage-2 MMU with a 48-bit IPA
limit (setting VTCR_EL2_IPA(mmu->vtcr) to 48), while get_kvm_ipa_limit()
remains 52.

In arch/arm64/kvm/mmu.c:kvm_handle_guest_abort(), the translation fault
handler still checks the faulting IPA against get_kvm_ipa_limit() before
checking VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr):

	if (esr_fsc_is_translation_fault(esr)) {
		/* Beyond sanitised PARange (which is the IPA limit) */
		if (fault_ipa >=3D BIT_ULL(get_kvm_ipa_limit())) {
			kvm_inject_size_fault(vcpu);
			return 1;
		}

		/* Falls between the IPA range and the PARange? */
		if (fault_ipa >=3D BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
			fault_ipa |=3D FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));

			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
		}
	}

If an NV guest running with a nested stage-2 MMU (!is_hyp_ctxt(vcpu)) on a
52-bit host accesses an address in [2^48, 2^52) (for example, with the
stage-1 MMU disabled via SCTLR_EL1.M =3D=3D 0 or HCR_EL2.DC =3D=3D 1, or wi=
th
4K/16K LPA2 TCR_EL1.DS =3D=3D 1 and IPS =3D=3D 0b0110), hardware stage-1 wi=
ll not
raise an address size fault because the physical CPU supports 52-bit PA,
and will instead raise a stage-2 level 0 translation fault against the
48-bit nested stage-2 MMU.

Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
fault_ipa >=3D BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48), won't
kvm_handle_guest_abort() fall through to kvm_inject_sea() and inject a
synchronous external abort into the guest instead of calling
kvm_inject_size_fault() to inject a stage-1 level 0 address size fault?

[Severity: Medium]
The commit message notes that capping kvm_get_pa_bits() at 48 bits also
bounds the nested walker's limits and AT's address size checks.

In arch/arm64/kvm/at.c:setup_s1_walk(), the MMU-disabled path checks
kvm_get_pa_bits(vcpu->kvm):

	if (wr->level =3D=3D S1_MMU_DISABLED) {
		if (va >=3D BIT(kvm_get_pa_bits(vcpu->kvm)))
			goto addrsz;

However, the MMU-enabled path in setup_s1_walk() and the nested stage-2
walker in arch/arm64/kvm/nested.c:setup_s2_walk() still clamp max_oa_bits
using get_kvm_ipa_limit():

arch/arm64/kvm/at.c:setup_s1_walk():
	wi->max_oa_bits =3D min(get_kvm_ipa_limit(), ps_to_output_size(ps, wi->pa5=
2bit));

arch/arm64/kvm/nested.c:setup_s2_walk():
	/* Global limit for now, should eventually be per-VM */
	wi->max_oa_bits =3D min(get_kvm_ipa_limit(),
			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));

Because limit_nv_id_reg() caps ID_AA64MMFR0_EL1.PARANGE at 48 bits and
TGRAN4_2/TGRAN16_2 at IMP, but leaves stage-1 TGRAN4 and TGRAN16 at 52_BIT
on an LPA2 host, arch/arm64/kvm/at.c:has_52bit_pa() returns true when an
NV guest sets TCR_ELx.DS =3D 1 with 4K or 16K pages. When the guest also
sets TCR_ELx.PS/IPS =3D 0b0110, wi->max_oa_bits in setup_s1_walk() evaluates
to 52 instead of 48.

Should setup_s1_walk() and setup_s2_walk() use kvm_get_pa_bits(vcpu->kvm)
instead of get_kvm_ipa_limit() so that check_output_size() raises a
stage-1 address size fault for TTBR base addresses and descriptors with
bits [51:48] set rather than letting walk_s1() and __kvm_at_s12() truncate
those bits when passing the address to stage-2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030105139.3543=
230-1-fuad.tabba@linux.dev?part=3D1
