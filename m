Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20DD39E185
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784569352; cv=none; b=vE0mhwrBccwELPReAQdVdBqME11+D6kqz5hjkze+LbiMBhR1GJ9wnlFWhu0djcMBigo90Oc1BxacADFwYeARnkOQzAxZE3V90l0ICHzRccS6tRuxRHjhBWhlnV0S9DgvNMqccsJdlYDQX0oA9nfn3GqkWzJ8q8pYB4WCpHCqPnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784569352; c=relaxed/simple;
	bh=leBh9jga1a1eS/CON1lKyPGjIhxo0s9Jby3aNQS/SFk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V0Gwhp13MLDhKwfQK0uc9McWSloB+GcYIJbonXMw6UerwSSyRKjXqsuB3mEi/wimU6QPlqq5P4ZVLZE1ri91w4mWp+dg1JttCg9GcOnIEcrm8XLE7kaJxoPK5+q1/gQd/gh5mnusci0Jy4lDwH9bNOXpJj1acsr3rhdm4dnF4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcayQh0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcayQh0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3AB1F000E9;
	Mon, 20 Jul 2026 17:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784569350;
	bh=GYPg2116tFgp7QUNzae4Y0T1+69fojMFvWr0vc46edI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CcayQh0U5zKrzylVfvOXPUUWR0gs6Cq/MDuiPZiqXdBIV5R1PK3OVorq76CZZmN4K
	 MyovHbEkEJa6FwEYJMdAF0iHb4a2IYIpyhTKZCFGWoUBwjTMbUIdocmt4JdP3CSyMN
	 asw/aa8bAO9skZ+n/cnO4DdVjwNzfwCrF/MUNAfjD31ASI19ZZZijb6vvNRmrBH584
	 bqs8kuMA1Etr+oMrYl0izXGGRBitvK9PHw6Kk8pe065y0t6UG8KPm25RpHS+v4MFvg
	 /Y0n1US4pbg6a0lq4S4/zU3O0D33k/ZecHb+LZQYpyLYfjWlNvFeWz84PffLSnrVBI
	 67IIrtmECgNag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720162412.1401272-1-fuad.tabba@linux.dev>
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720162412.1401272-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:42:29 +0000
Message-Id: <20260720174229.DF3AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The MDCR_EL2 trap configuration register is unconditionally co=
pied from the untrusted host VCPU on every guest entry, violating pKVM isol=
ation guarantees for protected VMs.
- [Critical] The protected VM's register context (`ctxt`) is copied back to=
 the untrusted host VCPU on every exit, leaking confidential guest state.
--

--- Patch [10]: [PATCH v1 10/11] KVM: arm64: nVHE: Check hypercall handlers=
 against the declared ABI ---
commit 3f8ed457b3a7f1b8aabe10f15d93afe4df7e93a2
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: nVHE: Check hypercall handlers against the declared ABI

This commit generates the unmarshalling of hypercall handlers using
DEFINE_KVM_HOST_HCALL. It checks the handler's parameter list against the
signature declared in kvm_hcall.h to prevent caller/handler disagreements.
Manual DECLARE_REG casts are removed from the handler bodies.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -228,15 +282,11 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_co=
ntext *host_ctxt)
>  		 * loading a vcpu. Therefore, if SME features enabled the host
>  		 * is misbehaving.
>  		 */
> -		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> +		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
> +			return -EINVAL;
> =20
> -		if (!hyp_vcpu) {
> -			ret =3D -EINVAL;
> -			goto out;
> -		}
> +		if (!hyp_vcpu)
> +			return -EINVAL;
> =20
>  		flush_hyp_vcpu(hyp_vcpu);

[Severity: Critical]
This is a pre-existing issue, but does this function allow the untrusted
host to bypass pKVM isolation guarantees?

Looking at flush_hyp_vcpu() in arch/arm64/kvm/hyp/nvhe/hyp-main.c, the
MDCR_EL2 trap configuration is copied unconditionally from the untrusted
host vCPU on every guest entry:

hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;

For a protected VM, the MDCR_EL2 trap configuration should be strictly
EL2-private and initialized internally. By syncing this from the host on
every entry, could the host maliciously reconfigure the guest's debug
traps?

[Severity: Critical]
This is also a pre-existing issue, but does the exit path leak
confidential guest execution state to the host?

In the corresponding sync_hyp_vcpu() function called after the guest
run, the protected VM's register context is copied back to the host
vCPU:

host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

Since this copies the hypervisor's private copy of the guest's context
back into the host-controlled structure, won't this allow the host EL1
to directly inspect highly confidential execution state (including
general purpose registers and system registers) after the hypercall
returns?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.1401=
272-1-fuad.tabba@linux.dev?part=3D10
