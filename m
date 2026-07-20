Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01DA9475
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554708; cv=none; b=AkYwsyxFhSJkrGOAmSnBK75z0swCwewqWaguXJ6Grknkwi9VrhdwWG81vAq4mAT3XTWvKdOh88c1hNqnwJw5DY7oVtpuE0FPUk1lmeY1kFfLW8uODX/ahFW/bdNFsWeLLAf6wVPkZRUor4qm5BnyzS3guOU35BJdOAhVHcf0cLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554708; c=relaxed/simple;
	bh=kCmKr46cKI0/c7RWZ1nJt+8fMXqXmwYm8Z/Nv/JW5fw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FsxQg7gjT9aKr3vbxnZEVqBwM3HB/a+VHvSIPAbNNxPAypMr37RIyCMYUxGttodExSt9VY+/tLVfGQ6feoDX5i7yo7dG0C7wKqicziWY7qkDgy16b8dV0sTcw9IU37xgCm+NpjaPVZn2qzLpLtvT8MVxsb0+Nm/UX8fP2OJyKxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4j3bvFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4j3bvFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A32C1F000E9;
	Mon, 20 Jul 2026 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784554707;
	bh=Hoba2A8lD9Mrb6Xp+r9ATcFCEZcnrO+sSqQVoNE6nFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c4j3bvFa9IhUhusGbOmt/JlPLfyaoBjxkC1zXjH75TdEPJKP2EQv7gG0A+b46rRGR
	 MXKN3bQK7HtURWVkHgW20ZMk9eFTPCfq7rwaRSWfgsizaKNxj+76/6/xmVNgzKo+sU
	 y7izrI0Dp8DMXB0XKydkRm1LrNm27bKYgRe4AwOWTqBb0mwATS8MwMK1B2ffCkpX1r
	 rMSq7bddBadukh+jLQbEslsV6AL9oOwtY855gWctN6AYd5Us7wa047b+lWWIYeW2xT
	 sFoLJJ2yu8zvBNpYRX6r1bHrVpHgRNxp+eAk0JvnmKqS7qahBlVgvuxASE+2kmmkWr
	 4WTPf0PnHBV2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] KVM: arm64: vgic-v3: Simplify initial GICv3
 configuration sampling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260720132220.2143486-6-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
 <20260720132220.2143486-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 13:38:26 +0000
Message-Id: <20260720133827.2A32C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The `noinstr` function `kvm_patch_ich_vtr_el2()` calls a non-`no=
instr` function (`vgic_v3_broken_seis()`), causing a `noinstr` section viol=
ation.
- [Medium] `WARN_ON` inside the `noinstr` alternative patching callback `kv=
m_patch_ich_vtr_el2()` violates instrumentation rules and risks deadlocks.
--

--- Patch [4]: [PATCH 4/5] KVM: arm64: vgic-v3: Simplify initial GICv3 conf=
iguration sampling ---
commit bf26cd3d96184399493f95667d1786d9b2823890
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: vgic-v3: Simplify initial GICv3 configuration sampling

This commit simplifies the initial GICv3 configuration sampling by returning
early if GICv5 CPU interface support is present. It also inlines a workarou=
nd
for a broken locally generated SEI directly into the alternative patching
callback.

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index ef62dd498f5cf..68d4a486df0a1 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -906,6 +906,9 @@ void noinstr kvm_patch_ich_vtr_el2(struct alt_instr *=
alt,
> =20
>  	vtr =3D res.a1;
> =20
> +	if (vgic_v3_broken_seis())
> +		vtr &=3D ~ICH_VTR_EL2_SEIS;

[Severity: Medium]
Does this code call an instrumentable function from within a noinstr sectio=
n?

Looking at vgic_v3_broken_seis(), it calls is_midr_in_range_list(). Calling=
 an
instrumentable function from a noinstr function like kvm_patch_ich_vtr_el2()
breaks safety invariants, which can result in objtool build warnings or
ftrace/kprobe recursion deadlocks if the patching code is traced.

[Severity: Medium]
Also, just before this addition in kvm_patch_ich_vtr_el2(), there is a WARN=
_ON
call:

	if (WARN_ON(res.a0 =3D=3D HVC_STUB_ERR))
		return;

	vtr =3D res.a1;

Is it safe to use WARN_ON inside a noinstr alternative patching callback?

Alternative patching callbacks like kvm_patch_ich_vtr_el2() typically run u=
nder
stop_machine() with CPUs parked and interrupts disabled. If WARN_ON trigger=
s,
it invokes the warning exception machinery which can attempt to acquire con=
sole
locks. If a parked CPU holds these locks, it could cause a hard deadlock.
Additionally, WARN_ON expands to instrumentable paths, directly violating
noinstr requirements.

> +
>  	/* Compute target register */
>  	oinsn =3D le32_to_cpu(*origptr);
>  	rd =3D aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720132220.2143=
486-1-maz@kernel.org?part=3D4
