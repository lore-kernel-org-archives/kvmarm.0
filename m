Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9319E2E8DEB;
	Fri,  3 Jul 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096309; cv=none; b=dZyowFyt4V2X8mJNcMaUIXRJ3Lal7sFt64+BYyHt+q5XWjObMeIM7E5r2qTjundx/ZpYPVzVnErwtJGZnk6MBk2dbEGpazVZ0b05qtPo3dwbr9hjRg3QD723fCeIruPPx196zGQDvH//vkX+XxIGWMMXN7+jkVoYrTllOWMO2Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096309; c=relaxed/simple;
	bh=/QafPryBiG4hFIUvK6iZH1UHgvXeMdPNkYKEIEwW+Zo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j/fyUs30CMppgPHzej5ZHn6R0BrUqoLVbylkEdBqiPJgTlYx7vTEFAAPt5icyKC9X/j2g2ogTJx6AX66oCO5s9SdzRQCfntp7bRiirm8lMOQCKWQkRkeDmSOg5zHOVhUQQHcukn8hPHtddZCmcuwbBGYntrtQcZyZkbk+ta3akI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPFGP9oS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPFGP9oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE071F000E9;
	Fri,  3 Jul 2026 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096308;
	bh=+H0uy/l72ZvA2ERHQ9dn26YP+mrjXePtx1fB6MalpH8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPFGP9oS3KBOk/k+ZSO3xXqe4l5aGtOdA5CtobrtcRMoec/zHLWlVEtkDmJ/aVdOv
	 GUOPk4xHd4wWLj3qkq6INcr1I1e8yQGSAMOIzKLz8xnEPOejlmRIQmfmU9Nfvoj8jq
	 Frj9CAff/IPZ9UVqFvY16NN74g7shcCv/vFpH/RWstz45HAp4FAWlvwAchFNzeumWh
	 ydboAh/P1ahsw0PWpoy3W6B90iKj7zfHtZNxOww8q2Ynr/qeC5Tynw2RnTmiKnu5iK
	 lRVdEYBW/7KpTfdJ9vIHjlk4b3J/hsalOKC1rkOSJTcuJrPFM05E8QOaGFzle7eKBb
	 WgXLEiMKg5jIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/40] KVM: arm64: gic-v5: Add GIC VDPEND and GIC
 VDRCFG hyp calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-27-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-27-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:31:47 +0000
Message-Id: <20260703163147.AAE071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing Context Synchronization Event (ISB) after writing to the V=
DPEND system register.
--

commit 3d6631fff5db53c3f7f6517ea282e7e87b142f9a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls

This commit introduces hypercalls to manage SPI and LPI pending states for a
VM using the GIC VDPEND and GIC VDRCFG system instructions. It wraps these
EL2-only instructions for NVHE/hVHE configurations to allow the hypervisor
to inject interrupts and query deactivated states.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5=
-sr.c
> index 46992a6c2cacb..c50e6ae93ba3f 100644
> --- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
> @@ -149,3 +149,23 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *=
cpu_if)
>  {
>  	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
>  }
> +
> +void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
> +{
> +	u64 value;
> +
> +	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MAS=
K);
> +	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
> +	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
> +	gic_insn(value, VDPEND);
> +}

[Severity: High]
Is a context synchronization event needed immediately after this system reg=
ister
write?

When __vgic_v5_vdpend() completes the write via gic_insn(), it returns dire=
ctly.
Without an explicit isb() before returning, could the CPU pipeline be left =
in
an undefined architectural state for subsequent instructions?

For comparison, the __vgic_v5_vdrcfg() implementation in this same patch
includes an isb() immediately after its gic_insn() call.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D26
