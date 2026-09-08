Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0733AD88
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899507; cv=none; b=nIWhFH7Pu+j3MgmMU5u3lcbuyteqSztzLw0UyQmEmdLjFPZqLJwaEWcewrNITLhWzEOgxAO13NzVD716jCPa+bzSvLgJDJW+siTkr+2ducGQr49tW9DdZQ/gyWyXuLmO3tps2JTXnhskRo7Cr9Kmh5kq4FVY8m1Gu2ml0joV3rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899507; c=relaxed/simple;
	bh=lGTl0otGojAcDg+A4KtBiY5DZQZAPrKd6C3f9h9ypPI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JF7P+MjzMmNd7qnuiCqMl5mP3fGWBUmSZgatvr2tRZMD5Bhw7O1VNFDOSeMbmoOL+JffhEztwl6ShVv682ZT0WIGZWvBd/f4tsdNOcG/ci0/SLFDWjSKLHZ52QnOpjgO/KPrcsK7VBKcA6kqbm18aSW80Zq/mQrkAcpgdoH2kSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k99yrSNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k99yrSNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B735E1F00A3A;
	Tue,  8 Sep 2026 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899506;
	bh=A+ykyYEx8KacrHMgyxTFutardRMxgiAimqg31tTQDt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k99yrSNnHhaMCRhbieFslDujjVu07xwdCXQvX2leLjAD0lE31CSM2jOU10lu5OtvZ
	 fCxoCsZLTKYo6owJlDzWoLv1Rp26Qnf3RnzIBttYhIlsy+hocKU9DUY7Mp/OPf0asD
	 6Qe9XdtcXpPvK+5vi8CwpWVFcic0cjvCXd4nKzSVO8cEyJHZBe10L7LjTvJkiLQKs7
	 ujOTx2AEVEqgzdyVPnS9iLBMkRGb7Rjg8j2IwsUcos1CLlSdz3l8Mf3+m+ZYs+jH6f
	 1BNet1oxbQwIlJnpW8aPpZeZ1EmIdPapsVUUK+AcfaDtfMgn0Raa9fBxe73EzfLjn/
	 HI2vM4R3dEpkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Enable S1PIE for hVHE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260908-kvm-arm64-nvhe-pie-v2-1-79e42d28cc08@kernel.org>
References: <20260908-kvm-arm64-nvhe-pie-v2-1-79e42d28cc08@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:31:45 +0000
Message-Id: <20260908203145.B735E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] S1PIE permission indirection registers are incorrectly swapped=
 for hVHE mode, zeroing PIRE0_EL2 and causing an immediate fatal Permission=
 Fault upon MMU enable.
--

commit 3004dc878365b596c5ed9c6a57b485c6d2028592
Author: Mark Brown <broonie@kernel.org>
Subject: KVM: arm64: Enable S1PIE for hVHE

This patch enables S1PIE for the hypervisor when running in hVHE mode. It
configures permission indirection to map to non-PIE meanings to minimize
page table manipulation changes. It also explicitly configures TCR2_EL2
when running in VHE or hVHE modes.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe=
/hyp-init.S
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S

[ ... ]

> @@ -137,8 +137,20 @@ alternative_if ARM64_HAS_CNP
>  alternative_else_nop_endif
>  	msr	ttbr0_el2, x2
> =20
> -	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
> -	msr	tcr_el2, x0
> +	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
> +	msr	tcr_el2, x1
> +
> +alternative_if ARM64_HAS_S1PIE
> +	/* S1PIE is only enabled with TCR2_EL2.PIE if we are running hVHE */
> +	mov_q	x1, KVM_HVHE_PIR_EL2
> +	msr	REG_PIR_EL2, x1
> +	msr	REG_PIRE0_EL2, xzr

[Severity: Critical]
Does this initialization swap the target registers? Since hVHE uses TTBR0_E=
L2
for its translation regime, permission indirection for this space is govern=
ed
by PIRE0_EL2. By zeroing PIRE0_EL2 and writing the valid permissions to
PIR_EL2, won't this cause the CPU to evaluate execution permissions as No
Access and immediately trigger a Permission Fault when the MMU is enabled?

> +alternative_else_nop_endif
> +

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -349,6 +349,14 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot p=
rot, kvm_pte_t *ptep)
> =20
>  		if (system_supports_bti_kernel())
>  			attr |=3D KVM_PTE_LEAF_ATTR_HI_S1_GP;
> +	} else if (cpus_have_final_cap(ARM64_HAS_S1PIE) &&
> +		   cpus_have_final_cap(ARM64_KVM_HVHE) &&
> +		   (prot & KVM_PGTABLE_PROT_W)) {
> +		/*
> +		 * When using S1PIE for hVHE set DBM for writable
> +		 * mappings since AP[2] is ineffective.
> +		 */
> +		attr |=3D KVM_PTE_LEAF_ATTR_HI_S1_DBM;
>  	}

[Severity: Critical]
This comment correctly notes that DBM replaces AP[2], which is the encoding
behavior specifically for the TTBR0 PIE encoding. Doesn't this further conf=
irm
that the permission configuration should be written to PIRE0_EL2 in the
assembly initialization instead of PIR_EL2?

> =20
>  	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-kvm-arm64-=
nvhe-pie-v2-1-79e42d28cc08@kernel.org?part=3D1
