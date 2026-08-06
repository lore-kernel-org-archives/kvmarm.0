Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B4427F99
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011624; cv=none; b=l3eYSM5GBeI/IP2uFxos1HOG9U+/MdGjpDLVG7fDKQrNPHI/Cd4c3BO+Uo+CgBouhnuB7ff8GUfSLwmPfFCgEWEKYDgVepGSbIgnTKQY3DMzUAPUvY6DbJnb2zxcXc8f/qR6BhGSultu352p73EPE3BaMK7v4w2RGmYwNRy5ZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011624; c=relaxed/simple;
	bh=S3zOmOyzxJlYNPmB86u24IuwczZY22GuBlU9DXxQwqA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HzDRQLI2HCsGT8LDOwYIVgn7LHJWtnRfKAb6VPZTk3fOr0PeFxO/ktu+kwE2KE4nlDfsgCU3zUQD+u/a3elv2PnjFAqhLiVkowfhyGPYhRZ08ztMWNQ2tzFJnh5MuF3lkDRKu7WKcEAorYgs6PuWCdTFnWVJO5YvPZpIEooQ97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BA9RWtpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BA9RWtpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7921F000E9;
	Thu,  6 Aug 2026 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786011622;
	bh=9yBjXpM0IFpiJKYZrtnt8yUq4g06yvtRXn2u+zsdMJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BA9RWtpfDxnYh9FR9DfJPsNiHvRS/o6Rb4lq37v0gncRG7EAloKTku7mbD3CuATu6
	 OaG8nxU58ZGo0p8+TEkhdICqyOxs97yujHFxatiCjRLVroeic4HbVU74CmezMOK1Y1
	 wUzfG7HOETLTs+mcGSr/kTU7ob/iuToU3x50rSnWmDu1L+ic5WV2wiK4dVIfFzozcE
	 Wt9xJ23iqTR7ezQJOP8BSquDUET+IelgSK/BqrRqxvqnmk+YX1ogX8Mn5hvDK45ovF
	 ppfc3+HeBkPekf2FAZz/mO+etn+w3M9LUk4rkOpQiAI4pqlEpSKYHxEF9FO+dZF4rK
	 z+CXy3cw4WoHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 2/4] KVM: arm64: Reject the GICv5 CPU interface
 hypercalls under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260806100256.371164-3-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
 <20260806100256.371164-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 10:20:21 +0000
Message-Id: <20260806102022.4C7921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing pointer validation in always-on legacy hypercalls allo=
ws arbitrary hypervisor memory corruption and information leaks by the host.
- [High] Missing Context Synchronization Event (`isb()`) after writing to `=
SYS_ICC_ICSR_EL1`.
- [High] Missing Context Synchronization Event (`isb()`) after writing to `=
SYS_SCTLR`.
--

--- Patch [2]: [PATCH v1 2/4] KVM: arm64: Reject the GICv5 CPU interface hy=
percalls under pKVM ---
commit ecfed0b01b70bb8a7e96b451e64a9f311953ed53
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM

__vgic_v5_save_apr() and __vgic_v5_restore_vmcr_apr() remain callable
after pKVM finalises. pKVM never registers a GICv5 vgic, so neither has
a valid caller in protected mode, and on a GICv3 machine the registers
they access are UNDEFINED at EL2 and panic the hypervisor.

Reject both when protected mode is enabled.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index d3df96ed8ba42..a9afd350b1fb3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -695,6 +695,9 @@ static void handle___vgic_v5_save_apr(struct kvm_cpu_=
context *host_ctxt)
>  {
>  	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> =20
> +	if (unlikely(is_protected_kvm_enabled()))
> +		return;
> +
>  	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
>  }
> =20
> @@ -702,6 +705,9 @@ static void handle___vgic_v5_restore_vmcr_apr(struct =
kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> =20
> +	if (unlikely(is_protected_kvm_enabled()))
> +		return;
> +
>  	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
>  }

[Severity: Critical]
This is a pre-existing issue, but could the missing pointer validation in
these always-on legacy hypercalls allow hypervisor memory corruption and
information leaks by the host?

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);

	__kvm_adjust_pc(kern_hyp_va(vcpu));
}

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_save_aprs() {
	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
}

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_restore_vmcr_aprs() {
	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
}

By exploiting the idempotence of kern_hyp_va() for EL2 linear-map pointers,
could a malicious host pass a pointer to EL2-private structures, tricking
EL2 into reading or writing private memory instead of host memory?

Should EL2 validate that the pointer points to host memory, or use the
known pkvm_get_loaded_hyp_vcpu() state instead of trusting the
host-supplied pointer?

[Severity: High]
This is a pre-existing issue, but does the write to SYS_ICC_ICSR_EL1
require a Context Synchronization Event (isb()) before returning?

arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_restore_state() {
...
	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
}

Since writes to most ICC_*_EL1 registers require an immediate isb(), could
placing a function return between the write and a barrier cause the CPU
to observe an undefined pipeline state?

Would this lead to unpredictable behavior or spurious faults when
switching to a guest?

[Severity: High]
This is a pre-existing issue, but is there a missing Context Synchronization
Event (isb()) after writing to SYS_SCTLR here?

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_enable_ssbs() {
	u64 tmp;

	tmp =3D read_sysreg_el2(SYS_SCTLR);
	tmp |=3D SCTLR_ELx_DSSBS;
	write_sysreg_el2(tmp, SYS_SCTLR);
}

If every write to a control-plane system register must be followed by an
isb() as the very next instruction, could missing the isb() before
returning result in executing subsequent instructions with an
architecturally undefined pipeline state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.3711=
64-1-fuad.tabba@linux.dev?part=3D2
