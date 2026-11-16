Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810463;
	b=RC+Wlp+HwasV8RyY0DAgc6o7GN2V1o+mrhRQmnDhnc2NVOJNEEVKPt5EK8Vj/hSuZBYO
	 qj/M1a17eU63XwqE03i6CmJV4Zu2HDhyc1h15Mf5gTpbzx1lgmYZmEepMJDQUNC0DNkzM
	 yGRqbaaTw3g/vawHJRSedrg/IgStOrJBq6Lw3JA38X5zCBJ5w2FMqGZYMUUvUT7YBbzKC
	 m8TAuWRdH8Z7CD76ioS2CU3jtB6QYzYLqQVJmHw7Eg6ll9VLAYjqL5MLpMEUjHc0gP1lY
	 1S/fs5vAQwf5UzE4Y3qm+Iu0vD+D5gHLjYcaVRzlfYVGJ41GaeMkCoQPSNsi9uqEzAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KV+43zelnsECjCpvRpUFYcAi+MzS5TjkQJGdFaKIx0o=;
	b=nkxWBojX0SyzxofODrtzQarOm+Pkuiu2Hk/P/Zk2vEQmTmY6ipGueFgRwRBFakKvlaJ4
	 +YETXvVjDDPSt7mCeZVbphUF41x4fUAyaHO/cM7z0MH8WVx+fHCQnvNe9xxR1pdbnoJGz
	 jWaYhAAQ9n/ytaIypQk6U6hS4Nw7+cC+9nILOb7ayVpkQzA3U7Vx5PV8ATMw/xTegfoxU
	 1pVv0BFtXuQuDGclDFXJywC4uMM0Sw2Uv9MdsO2gG0qarVpEFus9UdZ/RHAfmjxge5t3L
	 dQcASvDDIBTAH4NdCFvykxQKeShyHYHN80+pOkH2PBhkQTN6kavGt0kvBZxOO31ZN1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPrpcnL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA00606A32A
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 06:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPrpcnL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543231F000C4;
	Mon, 16 Nov 2026 06:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810462;
	bh=KV+43zelnsECjCpvRpUFYcAi+MzS5TjkQJGdFaKIx0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IPrpcnL3jhRuKQNEdl1vNJQVDB6nGAa8fMU/4haEOoP/GgsN0vG7t0MRiReFNpb7S
	 DCMZYVQN15Mzw9a5KefE1e9Us8At8aYI/bMGWqA9uT0Rd/DIGUf2BVkdGv0/0bv3h8
	 WXTJ7Whztcpxe0j0bBap7thajAygbLWYiXL8Yt3FFEEt2bQsqS297em9ZUQR3auvvo
	 B29dj9Ds1fow4t5UOV3FOv0lyXyH4KqZeGQl9v4YCM1lbqDjOhRWMSxJ++mAb+MFT1
	 izVYR2jmHRpvu8ZIQd3MzFspRvClbIlsTPAFONx0KWitj9qzdLw42XsW8FvX62KIKN
	 0yukxFanMJ7JQ==
Message-ID: <sashiko-outbox-216278@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: nv: Fix AT emulation for TCR2_EL1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <eec50693a12e1ba34d60458ae8fe605ac198a79c.1794808373.git.dan@pereq.eu>
References: <cover.1794808373.git.dan@pereq.eu>
 <eec50693a12e1ba34d60458ae8fe605ac198a79c.1794808373.git.dan@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 06:27:41 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: nv: unmasked PIE/POE in SYS_TCR2 in
  __kvm_at_s1e01_fast() and __kvm_at_s1e2()
--

commit ba7c962c50af660f734650ef98aa65969755bc0a
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: nv: Fix AT emulation for TCR2_EL1

This commit sanitizes hardware SYS_TCR2 during nested AT instruction
emulation by masking out unsupported PIE and POE bits and clearing
SYS_TCR2 when the guest VM does not support FEAT_TCR2.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 30d8f062b2c29..06765881a4c81 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1438,7 +1438,13 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vc=
pu, u32 op, u64 vaddr)
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
>  	if (kvm_has_tcr2(vcpu->kvm)) {
> -		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
> +		u64 tcr2 =3D effective_tcr2(vcpu, TR_EL10);
> +
> +		if (!kvm_has_s1pie(vcpu->kvm))
> +			tcr2 &=3D ~TCR2_EL1_PIE;
> +		if (!kvm_has_s1poe(vcpu->kvm))
> +			tcr2 &=3D ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
> +		write_sysreg_el1(tcr2, SYS_TCR2);
>  		if (kvm_has_s1pie(vcpu->kvm)) {
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
> @@ -1452,6 +1458,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcp=
u, u32 op, u64 vaddr)
>  	__load_stage2(mmu);
> =20
>  skip_mmu_switch:
> +	if (cpus_have_final_cap(ARM64_HAS_TCR2) && !kvm_has_tcr2(vcpu->kvm))
> +		write_sysreg_el1(0, SYS_TCR2);
> +
>  	/* Temporarily switch back to guest context */
>  	write_sysreg_hcr(vcpu->arch.hcr_el2);
>  	isb();
> @@ -1554,6 +1563,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u6=
4 vaddr)
>  		if (!vcpu_el2_e2h_is_set(vcpu))
>  			val |=3D HCR_EL2_NV | HCR_EL2_NV1;
> =20
> +		if (cpus_have_final_cap(ARM64_HAS_TCR2) && !kvm_has_tcr2(vcpu->kvm))
> +			write_sysreg_el1(0, SYS_TCR2);

[Severity: Medium]
Does hardware SYS_TCR2 still retain unmasked PIE, POE, and E0POE bits in
__kvm_at_s1e2() and on the !mmu_cs path of __kvm_at_s1e01_fast() when
kvm_has_tcr2(vcpu->kvm) is true?

When the guest runs at vEL2 with HCR_EL2.E2H =3D=3D 1, HCRX_EL2_TCR2En is s=
et
and the guest writes its TCR2_EL2 directly into hardware SYS_TCR2 without
trapping.  The RES0 masks in tcr2_el2_feat_map are only applied in
software by vcpu_read_sys_reg(vcpu, TCR2_EL2), so on a guest exit for an
AT trap, hardware SYS_TCR2 still holds any raw PIE, POE, or E0POE bits
written by vEL2.

If the VM has FEAT_TCR2 enabled but FEAT_S1PIE or FEAT_S1POE disabled,
KVM does not load PIR_EL1, PIRE0_EL1, or POR_EL1 for the guest, so both
paths will evaluate Stage-1 permissions against stale PIR/POR values from
another VM or the host VMM's POR_EL0.  Writing vcpu_read_sys_reg(vcpu,
TCR2_EL2) to SYS_TCR2 (and restoring the raw guest value afterwards) when
kvm_has_tcr2(vcpu->kvm) is true would apply the configured RES0 masks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794808373.gi=
t.dan@pereq.eu?part=3D1
