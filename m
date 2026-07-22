Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF61F42FCC9;
	Wed, 22 Jul 2026 08:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709488; cv=none; b=lKz6FaPpUeuT9Tsm81xogX8vy21QVhDuLuNPLC7GevZtHiOuGbJXvKki5qbt3QP09/dDRLam8zwGCbi5qahZq7B+DmgrQbxMp7Fm9rMQ8WpW8fxdysi6ka+4bOcSTXGJj0PcaWtSQGZXg5G+m5H8NVTi5YuOiiogVcbZhKCJa0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709488; c=relaxed/simple;
	bh=8D0BxG4eaYm/ikiaqKAoB7Me6EP7g1RztoUF7Ip9cgs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FUHlXYW0g04z48X9K0teqj5sOs5D0GXV7vJWly08NCcOiNgVfVCrVoM8qZUg0j0fwB++ZI4DFowIScuTlNi+Qke7SfHcbN+5JaHfbG9sXCTgdATACRJh7eo/o0w0FxV8iMfRzKyeEq3d66nBcmv6jwcooaPSZxc5ozB1KVR15ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtmaWn4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtmaWn4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BD11F000E9;
	Wed, 22 Jul 2026 08:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784709484;
	bh=do6Z/xLKRrnkGvua9CYbifedqBjEtJiAG/B7H9slZvM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FtmaWn4auZobQm2Xdcka9BK/bC9tdzggeulp3lna9vT3pNGImY5pIGd2jKmisAzdh
	 8VB9DSyX6vH9bvVvo4OVPKV9hjCLSSqiHVFe8psrf2TAZnaE2IZY/J9K7nEGgR/FnY
	 XJ6/Q4YTPxv9wJbfSpaloPtUO5kYVyBJBZjHxYJT18dDksTJz/MkMzo59oRDPBr6pf
	 lkq3DSNtx1qDY/cUDEmbO052fJbgprAt38EZ4Rr6w0baIb2M5rzJbtJjZP603SeeQx
	 HJKE5wHu1tiCtaAQSAnZN/ermvNygZKspByhDchDMKWJwYEsPbdMpl9XNG8Dyksz9T
	 YO1Bm+zvPI8QA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/28] KVM: arm64: Add sanitisation for NVHCR_EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260722074234.3330999-21-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-21-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:38:03 +0000
Message-Id: <20260722083803.C0BD11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Subsystem rule violation: Numeric range loop over sparse `enum vcp=
u_sysreg`
--

--- Patch [20]: [PATCH v3 20/28] KVM: arm64: Add sanitisation for NVHCR_EL2=
 ---
commit b143c0689f4a9db3345ab50e6a712d0698ebaa75
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add sanitisation for NVHCR_EL2

This commit adds sanitisation support for the NVHCR_EL2 register.
It mimics the format of HCR_EL2 but conditionally depends on FEAT_NV3
being present. If FEAT_NV3 is absent, it relies on standard VNCR data
transfers.

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 82be8bcb07035..34e63480886cd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1828,6 +1828,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	resx =3D get_reg_fixed_bits(kvm, HCR_EL2);
>  	set_sysreg_masks(kvm, HCR_EL2, resx);
> =20
> +	/* NVHCR_EL2 */
> +	resx =3D get_reg_fixed_bits(kvm, NVHCR_EL2);
> +	set_sysreg_masks(kvm, NVHCR_EL2, resx);
> +
>  	/* HCRX_EL2 */
>  	resx =3D get_reg_fixed_bits(kvm, HCRX_EL2);
>  	set_sysreg_masks(kvm, HCRX_EL2, resx);

[Severity: High]
This is a pre-existing issue, but later in kvm_init_nv_sysregs() there is
a loop over enum vcpu_sysreg:

	for (enum vcpu_sysreg sr =3D __SANITISED_REG_START__; sr < NR_SYS_REGS; sr=
++)
		__vcpu_rmw_sys_reg(vcpu, sr, |=3D, 0);

Does this numeric range loop iterate over unintended registers?

The KVM ARM64 subsystem guidelines state that enum vcpu_sysreg is sparsely
numbered by VNCR byte offsets. Using a < comparison and incrementing over a
numeric range touches register indices that happen to fall within the byte
span.

Could this silently drop or corrupt guest state by applying operations to
unrelated registers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D20
