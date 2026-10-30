Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793363052;
	b=oCuHSMg0DGhiVn9KK6ngJpvT2g8n0KAML5YROgkg2AnaPSlvgjtqpTE4WFUk0CqI2jyL
	 c3N+E0XmzSCfLtjiXQetUk+5WTLn//ozFxnWAYknEpAcHhQNr+6oqASQ6ZFXZob5eGXaB
	 OcWe6D8BCIjYqF6W/UA96ZRMXVwNCG8GoEjNqh9ksuevu0KDl+waNhrSvZ/CqtCUtrcMH
	 laBsNhUhWSltaHT1GEnDIaQJBtkcmGOwyfiTxhkojRf6sVKuDG89DswnIJKN9vgGPGWKA
	 5sA77b47PEhjMVkuj+TnfZCGgSVEgVTF4ZepU35ANdKtMwqcJ6wduRQwfRjNoVy3woQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793363052;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iK3PcvtF+u0Hw0tjGTktom3Ojqq/cjL49aUrJ/QI6GA=;
	b=bSXvBsd0qTJrb3Y3ILNnY7+2lvg+2iA7/NNiFLHeWzOVAU8stf411a3KzJYMIVQXbtUy
	 UbQ2iZ+cICFHkcYg02/s66uBj7XTOr1cIAg9zzliMgPT9cl4YiEvEu1Wgfo7vgZz+RHQ7
	 iaPd8zyZc5nZdpvYY+W2XiYU/mAgoy64HdBUaHTqFAnhngliDPsm2pDzJaKElV7an0IpV
	 BC+BZ/pypSpHuMa6a9REAkV6CnQUhw4Qmiid+0X+LylEV6om/VSgP6LKd2rMO9jatHRVx
	 xXMmrqgYIL99ZK4ImD273vzb+rZ5/hvYPmcI9Bt9AKzym93xoPC28nkr5jKU0t1i8Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0c6eGnT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45410606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0c6eGnT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946C31F000C1;
	Fri, 30 Oct 2026 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793363051;
	bh=iK3PcvtF+u0Hw0tjGTktom3Ojqq/cjL49aUrJ/QI6GA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y0c6eGnTYsVvrV/drLwTzpfxf4ja/hVkI86IWYfG64MqzkpVuBSCfm7gwJIZzDtUz
	 k0MV4HBeI2WPO706CNHdZvzz/otngDBUoDANRG+qbd6Cbv5hS9D832ekeJFM1IQWLq
	 lozkgxKDFW46LGSguu8DCWkgreRteMjBs3Mz1vjE5UGSRQRFQzUzulV9GwkibMVmkN
	 Ost7KJmX2j8edQmKfemNBAzW9lEy70trd7XM72FHZVB1zbZgWr/yaPqgr+mFvcLHxl
	 cWoWCNdmKMddkuqRivo/1Jf8wDj3QMuqL2e7s9Bal/COipvA58Hh3pcNxi3KscM6fj
	 dzAFCYngYFsKA==
Message-ID: <sashiko-outbox-191007@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261030120837.3752397-1-fuad.tabba@linux.dev>
References: <20261030105139.3543230-1-fuad.tabba@linux.dev>
 <sashiko-outbox-190923@kernel.org>
 <20261030120837.3752397-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 12:24:11 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: nv: missing base changes in kvm_get_pa_bits() and re=
ply changelog
--

commit f427a1e42f6e3dddeb1163b0cde7acfb4c92d8ef
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap

This commit replaces get_kvm_ipa_limit() with kvm_get_pa_bits(kvm) in
kvm_handle_guest_abort() when checking whether a translation fault IPA
exceeds the guest's PARange.

>     KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
>    =20
>     On Fri, 30 Oct 2026 11:09:43 +0000, sashiko-bot@kernel.org wrote:
>     [...]
>     > Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
>     > fault_ipa >=3D BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48),=
 won't
>     > kvm_handle_guest_abort() fall through to kvm_inject_sea() and injec=
t a
>     > synchronous external abort into the guest instead of calling
>     > kvm_inject_size_fault() to inject a stage-1 level 0 address size fa=
ult?
>    =20
>     Yes. I'll fold this into v2:
>=20
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..596b2b6ebbdf0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2440,8 +2440,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	is_iabt =3D esr_trap_is_iabt(esr);
> =20
>  	if (esr_fsc_is_translation_fault(esr)) {
> -		/* Beyond sanitised PARange (which is the IPA limit) */
> -		if (fault_ipa >=3D BIT_ULL(get_kvm_ipa_limit())) {
> +		/* Beyond sanitised PARange */
> +		if (fault_ipa >=3D BIT_ULL(kvm_get_pa_bits(kvm))) {
>  			kvm_inject_size_fault(vcpu);
>  			return 1;
>  		}

[Severity: Medium]
Was the incremental reply diff applied directly instead of being folded into
the base patch?

In arch/arm64/kvm/reset.c, kvm_get_pa_bits() is still unchanged and
unconditionally returns kvm_ipa_limit:

u32 kvm_get_pa_bits(struct kvm *kvm)
{
	/* Fixed limit until we can configure ID_AA64MMFR0.PARange */
	return kvm_ipa_limit;
}

Without the base changes to kvm_get_pa_bits() (and with the commit message
containing only the mailing-list reply text), this change in
kvm_handle_guest_abort() in arch/arm64/kvm/mmu.c is a functional no-op: on a
52-bit LPA2 host running a nested virtualization guest whose sanitised
ID_AA64MMFR0_EL1.PARange is capped at 48 bits, kvm_get_pa_bits(kvm) still
returns 52 rather than 48, so neither nested stage-2 MMU sizing nor stage-1
level 0 address size fault injection is updated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030120837.3752=
397-1-fuad.tabba@linux.dev?part=3D1
