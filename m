Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77655295B
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788880508; cv=none; b=Sp/mOzqUS8tsYX9rw5F3hCB3lcLMbkIomP7onn1+bntP0EnL57VPUIN0QFb7USODXS+MyMcBeNaICZjXi6mLGfcKM6Q2WcRYryBJN5AVmI/Skw3/wte+dOuC9dFKmsTjmQRTT9eYgQC2YJ7C4VTEfu4oGcu5DCdob18s9YFU3h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788880508; c=relaxed/simple;
	bh=QTqLWFHG3Tpe4yIm3WRN0zKcthbqv4jzUx6b8V5sTpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SPAG64BkrRHp+wWgUMv+HMVM1D2KGSnLZXqRuP2L/4QCpZREM8OS94n+exDaujcW9a8nNUZC9PJaa2cDV/4FN1bG+k6IJOUEd1QDED89Is20qZGpkYaLF4Sfcy6r8K7HPxRygnS4cruO6PcbpwPNOezXTyV5xTLIRNiyTdwBsLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FblilvCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FblilvCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6901F00A3A;
	Tue,  8 Sep 2026 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788880497;
	bh=zk4cZT11t2+tesSid4wBJa8f+KggpUUxcoortmLB1ts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FblilvCscVGoVVR44tOuE+LugPo/sBSxCqaHbECZLveDnmv91CJ+T600UmUTRmETd
	 FLkDZzZpYGR6hcGhbI+lAV31LM26cxk/xo/pbJu9hnyiVgqEr6wcE8OLLKpm6x2Io6
	 9QVs9/RM32EQftmY/YdpSmB8B9acg3R7VMDf0vY/vInYs3CuczFF1yu9Rc3D0e2AHe
	 XGOwQmHdtiHiggP3UTmbaArID4uTvufHSqhxn44DSCquULc+dUAS9DO0//aFlJFWm0
	 SCX7Qdd33bD/BsBgGxLhX3r1nwzMfgFu4bop+CYhh+ei+4x3k45GasR4qZs0UkYapi
	 DQX9E4Txiqw3w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Trap guest MPAM accesses whenever MPAM
 is implemented
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260908145651.2828597-1-fuad.tabba@linux.dev>
References: <20260908145651.2828597-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 15:14:47 +0000
Message-Id: <20260908151457.0A6901F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Guests can bypass EL2 traps and directly access physical MPAM regi=
sters if the host has asymmetric CPUs or boots with `arm64.nompam`.
--

commit e23ed2fd702c6c43a8b21feffe356931e0f7eb5a
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented

This commit modifies the EL2 MPAM trap activation to gate on the sanitized
ID registers rather than the MPAMEN bit. This ensures that guest MPAM
accesses are trapped whenever MPAM registers are implemented, even if
firmware hasn't enabled MPAM.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 1ce7130e25490..8941335724f6b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
[ ... ]
> @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_=
vcpu *vcpu)
>  	u64 clr =3D MPAM2_EL2_EnMPAMSM;
>  	u64 set =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> =20
> -	if (!system_supports_mpam())
> +	if (!system_supports_mpam_sysregs())

[Severity: High]
This is a pre-existing issue, but does gating this early return on the
sanitized system-wide ID registers allow the guest direct access to
physical MPAM registers in asymmetric or overridden configurations?

During early boot, head.S (in finalise_el2_state) reads the physical
CPU ID registers and clears the EL2 MPAM traps. If the system has
asymmetric MPAM CPUs, or if the kernel is booted with arm64.nompam,
system_supports_mpam_sysregs() evaluates to false.

When that happens, __activate_traps_mpam() takes this early return and
skips setting TRAPMPAM0EL1 and TRAPMPAM1EL1. Since the hardware traps
were already cleared by head.S (or left clear by firmware), the guest's
MPAM register accesses execute natively without trapping to EL2. This
could allow an untrusted guest to manipulate host cache and memory
bandwidth partitioning.

This patch swaps one system-wide capability (ARM64_MPAM) for another
(ARM64_MPAM_SYSREGS), which inherits the exact same bypass. Should KVM
base its trap activation on the physical ID registers to safely isolate
the guest instead?

>  		return;
> =20
>  	/* trap guest access to MPAMIDR_EL1 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908145651.2828=
597-1-fuad.tabba@linux.dev?part=3D1
