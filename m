Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214088;
	b=jRmhNIZkm40RgfYGwLNRaEVxfcNZI6deWMjKZSb1fQ+WW2Sobt7VR78Gl/FajQFm2ccQ
	 VDktV67hZ4gc+xXhjasowFNSvQXYyIJn+ofyWbTZ/3TbwjnLdxHfHKfp0yq5upADbY4d9
	 445LLbqH4L63G6MGpgKqQW1S3x2XV5BfR+roYsYOEfsDHZCBeDPQfZ+xr6Ec1gM16eRrR
	 Tbkqj60kXn17Ku3okfovbSMrBYluqgCzNV31A5nJPNdqk9vljNbmZfcMiJlNikBa4NPD9
	 UBX5ETj7D9EAdhNG6ZeoIZYocBvzqmNGSnrFPTdKyzUcD0Gdy3GtUFsDREhWSDmt4sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214088;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TgA3cf+7c85/LODnXBDcyc695QEfQZqCtmG9Unmhpr8=;
	b=qkECdZYyu6ay4WFixvhoMnsli16uHgPya0OaNSGfeTtRQxRH1l7cDy31zNN+BtI4Cokt
	 pQfJIg0MWu8ucwFaUV1tdO0uu+kcPecGbMcdWFu3g2n+D2CGmwte8n+MQ5FWOJB/OCaTw
	 iVZtZJ0uLOhKZkZ57PAF3YsvPnovrLmWk7Sb9/AcNnzZHEqp74Wua2UxTAaCAEdWA+ZUg
	 04SCRNZUEb3qj3bgFOsoej+gTabTgPzIab5LFNrpGbLMyfdnNNA2enx6a+MjktYu9UOR8
	 TclxV21hsXJr+R5fgoSc1X54irKGUvZqLwO7P+7cBZy1j2DQXGhXSQgJX0de4eDsBjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezG2ikQY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2C606A31C;
	Mon,  9 Nov 2026 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ezG2ikQY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7C01F008A1;
	Mon,  9 Nov 2026 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794214088;
	bh=TgA3cf+7c85/LODnXBDcyc695QEfQZqCtmG9Unmhpr8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ezG2ikQYp9bEaY9RwtWdfDChL0+Iq3sIx9eFEj58PJQDCtbVCqW8/KlHSBvYHhf9k
	 Q5OULDlwHW6QFulaNMCANUEN3qj536uMARWueX8bwcCX14kc4xwzONc9O7DcAGr+wC
	 C8JnPlFjOcLGWApTxFvLXc8xp1cFiiVhAKCfLxwpmJrbMF9wqEudL4THldvLqZWvIN
	 ySgDTK17FzmdgnxfZBMVHkYn9q3Wdg4ItNKTK5FHWY6N6VuJFqoo9Y4K+d0m4QM0aY
	 CuAbtpWgbQeySDgs9OX+BwMT8eOjkiJJmU52elJ2oamlTs/R1UiSuD5PIsisA14M+0
	 jUI/dsdbIfg5A==
Message-ID: <sashiko-outbox-204612@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/16] KVM: arm64: Advertise ID_AA64ZFR0_EL1 to
 protected VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261109083205.806619-5-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
 <20261109083205.806619-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:48:07 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] KVM: arm64: GPA and GPI exposed without vm_has_ptrauth() in
  pvmid_aa64isar1 [1]
--

commit 2d2ae4f2681e16f1e4bc8fc816b7e7d62dcaf9be
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs

This commit copies the host's sanitised ID_AA64ZFR0_EL1 register value to
EL2 and exposes its capped feature fields to protected VMs when SVE is
enabled for the guest.

> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 7a0aed1d8b0b3..8456bb44edd52 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c

[ ... ]

> @@ -124,6 +125,22 @@ static const struct pvm_ftr_bits pvmid_aa64pfr2[] =
=3D {
>  	FEAT_END
>  };
> =20
> +static const struct pvm_ftr_bits pvmid_aa64zfr0[] =3D {
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SVEver, SVE2p3, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, AES, AES2, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, EltPerm, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, BitPerm, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, BF16, EBF16, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, B16B16, B16MM, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SHA3, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SM4, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, I8MM, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F16MM, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F32MM, IMP, vm_has_sve),
> +	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F64MM, IMP, vm_has_sve),
> +	FEAT_END
> +};
> +
>  static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
>  	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
>  	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),

[Severity: High]
This problem wasn't introduced by this patch, but should GPA and GPI in
pvmid_aa64isar1[] also be gated on vm_has_ptrauth() [1]?

arch/arm64/kvm/hyp/nvhe/sys_regs.c:pvmid_aa64isar1[] {
	MAX_FEAT(ID_AA64ISAR1_EL1, DPB, DPB2),
	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, APA, PAuth, vm_has_ptrauth),
	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, API, PAuth, vm_has_ptrauth),
    ...
	MAX_FEAT(ID_AA64ISAR1_EL1, GPA, IMP),
	MAX_FEAT(ID_AA64ISAR1_EL1, GPI, IMP),
    ...
}

Unlike APA, API, GPA3 and APA3, the GPA and GPI entries use MAX_FEAT()
instead of MAX_FEAT_FUNC(..., vm_has_ptrauth).  On a host with generic
pointer authentication, a protected VM created without pointer
authentication still sees GPA or GPI advertised in ID_AA64ISAR1_EL1 while
HCR_EL2.API and HCR_EL2.APK remain clear, so guest generic PAuth
instructions or key accesses trap to EL2 and inject an UNDEFINED exception
into the guest.

[1] https://sashiko.dev/#/bug/linux-01433c94-7171-4ed8-85e1-6ba36cf8dd5f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109083205.8066=
19-1-fuad.tabba@linux.dev?part=3D4
