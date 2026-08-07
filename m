Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852737AA9F;
	Fri,  7 Aug 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120075; cv=none; b=eJ2JnBcKS1HTnlTkAEll5vW3B7DotNLVjBl2WsSqe0Mb0r0OXOcak9HPIBJMJ7BhWFwsr9N8/pGRys4MQcX5a3US9gSE/4g777zZeUQvsIm49dUMBtpGXTtCCRQ67QnRGTwyZbuwpbmKN4G1TzNJBn7B3G9KA6yaVgdFtk1rY00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120075; c=relaxed/simple;
	bh=aTdVNjEp1j9zrZ6lhwdmYKSppcT148SPHXrxEbI02AI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qdnKhkP4xRrKTOluMUUSTfPHjaNzfAqgEfMBP1KvLVw/t+emXqN4Tn90kEM/77Cj+/e917zH6xl/I6Tv/e5aoh+Iw3MH6MsEKomNqWL2MfNXuu5EtiVkuNMFmneBxxlLRhcF1j1zoTIsG8JvtRxRdaJgpVBbxeZOMfEhUn60uaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fmk7E1qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fmk7E1qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C64C1F000E9;
	Fri,  7 Aug 2026 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786120073;
	bh=Pih278byRYTqLFEVMr33W90FAamwFlAjjpu+imhSVug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fmk7E1qatcmjTG7yXRU+KvfQ1sQ+OrgNHjeU4F1JDHuBAgeD6X4MApKIqNTc+eC3P
	 qdnOW/8yZJDG9DqrsvqE1sEryPIMOUFZhaf7Hj5wRqG63qwEIY0/UV4Bs0VrDQFg8f
	 tDXk3y02Hozfr24SCq7dEBUa6k/4ckIbfbYJZVbHsDhJgmPotA37SZexl4nNbfQK1n
	 CwqjXXuEW4cvJwmUleG9RbQV9xAr+eTX1XUdoV9tfIzVMjR0I9WuIDVangZtKZ/tA1
	 aWLyR91LlXlAAA+hUQNDz4yP6toN8miStFoaFUbO3QmnX+gMbRnUHCHxcieb/Zw0LK
	 1pF4QIQia6FLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg
 userspace accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-32-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-32-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:27:52 +0000
Message-Id: <20260807162753.3C64C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `gic_v5_icc_reg_descs` array is not sorted by sysreg encoding,=
 which will cause KVM module initialization to fail.
--

--- Patch [31]: [PATCH v5 31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg u=
serspace accessors ---
commit fc4bd92f943a451cf5400e9e01e75819d02ae623
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors

This commit adds functions to handle userspace reads and writes of the GICv5
EL1 system registers to support VM migration. It wires these accessors into
KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS and enforces that register state can only
be written before a vCPU has run.

> diff --git a/arch/arm64/kvm/vgic-sys-reg-v5.c b/arch/arm64/kvm/vgic-sys-r=
eg-v5.c
> new file mode 100644
> index 0000000000000..6b255eacbf60d
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic-sys-reg-v5.c

[ ... ]

> +static const struct sys_reg_desc gic_v5_icc_reg_descs[] =3D {
> +	{ SYS_DESC(SYS_ICC_ICSR_EL1),
> +	  .set_user =3D set_gic_icsr, .get_user =3D get_gic_icsr, },
> +	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1),
> +	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler,=
 },
> +	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1),
> +	  .set_user =3D set_gic_ppi_enabler, .get_user =3D get_gic_ppi_enabler,=
 },

[ ... ]

> +	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR14_EL1),
> +	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priori=
tyr, },
> +	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR15_EL1),
> +	  .set_user =3D set_gic_ppi_priorityr, .get_user =3D get_gic_ppi_priori=
tyr, },
> +	{ SYS_DESC(SYS_ICC_APR_EL1),
> +	  .set_user =3D set_gic_apr, .get_user =3D get_gic_apr, },
> +	{ SYS_DESC(SYS_ICC_CR0_EL1),
> +	  .set_user =3D set_gic_cr0, .get_user =3D get_gic_cr0, },
> +	{ SYS_DESC(SYS_ICC_PCR_EL1),
> +	  .set_user =3D set_gic_pcr, .get_user =3D get_gic_pcr, },
> +};

[Severity: High]
Will this cause KVM module initialization to fail?

During load, check_sysreg_table() verifies that the sys_reg_desc arrays are
strictly sorted by their sysreg encoding (Op0, Op1, CRn, CRm, Op2). If they
are out of order, check_sysreg_table() returns false and causes the init to
fail with -EINVAL.

Here, SYS_ICC_APR_EL1, SYS_ICC_CR0_EL1, and SYS_ICC_PCR_EL1 (which all have
CRm=3D0) are placed at the end of the array after SYS_ICC_PPI_PRIORITYR15_E=
L1
(which has CRm=3D9). Additionally, SYS_ICC_ICSR_EL1 is placed at the very
beginning of the array.

Does this array need to be reordered strictly by encoding so the validation
checks pass and the binary searches work correctly?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D31
