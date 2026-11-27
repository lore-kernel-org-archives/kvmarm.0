Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795271;
	b=bxy1Zopyp0n7Wxb7aTTSoTDmFQR8tlzJnG0YtHNKXegsqglZnZr3EM+sghd3yoH0JFYW
	 Vfu5xw2L4C1SMeDq2mIcv1nVptNFiVQjYYcg+4akwTJ1SxhSGxHYRLCWWEnaIH7BRhUXL
	 IJt7FZw+fiui2GfO6V+9y4/A+jUURb5DVBQOAF5mI81f3Us+dE8PQyUiRmIb9svOhTfEO
	 UzyRvFZeVc+MZfN8PcDwk9IwktOtkhyoKLei5WInXjsx5cUgXsXUR8QMam2lEzmoUusRA
	 4KJTNRR8nVCQkz40gQwzQyVnR+EgLzcTCn49BjHUX6rYjUtxgzmW1iF2oTEsWgSiNDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795271;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7UxfaiiTOT478PPr1iWmH+Tl9BO2ShQhjyrGz1UW5KA=;
	b=iyaq2ms7XN4z6JHzZVExqTDiZE1SLwAe4g6NidQ2+xt+CYCEZlT6lavjssS/Ph6XiueW
	 1PIqLTmn0zKXfJCGY4+cD7RHnJYrGxasR60bvRNJ+XjrH3NnjWoVuxxJshkFiWGIL+py8
	 LJtPKyepalYOFKGx/3to1NeQIPBq4vwsDpBMyFgANVi3cSImhv5v1xNue1pA2ujQxQ1ik
	 9HUw8ayvr7kXFLaO1jCWi6UVCPm6YKoEerSsBGLFzucq0g0pO0xCRP3gWbWl0IKXv+vo9
	 GzZg74cZnYl5BMXJnMRK/0o16nMtzeKitGSNLfL27FZZayqVotadLy7b1ap2AlReB3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k82rc6tf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F3606A32C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k82rc6tf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3188E1F00937;
	Fri, 27 Nov 2026 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795270;
	bh=7UxfaiiTOT478PPr1iWmH+Tl9BO2ShQhjyrGz1UW5KA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k82rc6tfzt79dDDrveyODdpx395+zy1AC0XPSEE1nRv5r2Vcj0v6xF5Oskj2UOF4B
	 PVuizAsIZHOV7iPxUS3HBcOqGHgX5LBOqh7Psav9EgrzxqIWfu+yqFH7lvbMFd4s2y
	 Deu72/wQc8Kf0K8Cmiss7ZXn6GCVTT4cBN2qiC8ylg4tmR4xs5rj5vg4xtX2NtHvtC
	 87ZSIcu/A5fplRZakrX8YAH/KUxyk3WCoQSF2doUc2RSi+HP+8H0XwXSInLO9PGHl4
	 DnV3HpjAP9fGNn1jURyNgyu8eLJguQAdwkVCbyaHK2RQHdMAmBgngPSqPO/fGrIUF1
	 kEgTlSIjrAEbQ==
Message-ID: <sashiko-outbox-237810@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: nv: Fix AT emulation for TCR2_EL1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dan Carpenter" <dan@pereq.eu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261127-nv-tcr2-v3-v1-1-9c15c1cabe01@pereq.eu>
References: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
 <20261127-nv-tcr2-v3-v1-1-9c15c1cabe01@pereq.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 16:01:09 +0000
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
- [High] KVM: arm64: nv: missing mmu->last_vcpu_ran check in
  __kvm_at_s1e01_fast() [1]
--

commit f484417c3817214769a2572e772a7f25d111b06a
Author: Dan Carpenter <dan@pereq.eu>

KVM: arm64: nv: Fix AT emulation for TCR2_EL1

This commit masks disabled PIE and POE bits in effective_tcr2() and loads
and restores the guest's TCR2 and POR_EL0 registers during fast-path AT
emulation when the host CPU supports those features.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 30d8f062b2c29..893bf88f2f750 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c

[ ... ]

> @@ -1437,8 +1463,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcp=
u, u32 op, u64 vaddr)
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
> +	if (cpus_have_final_cap(ARM64_HAS_TCR2))
> +		write_sysreg_el1(effective_tcr2(vcpu, TR_EL10), SYS_TCR2);
>  	if (kvm_has_tcr2(vcpu->kvm)) {
> -		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
>  		if (kvm_has_s1pie(vcpu->kvm)) {
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
> @@ -1452,6 +1479,17 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vc=
pu, u32 op, u64 vaddr)
>  	__load_stage2(mmu);

[Severity: High]
This problem wasn't introduced by this patch, but when __kvm_at_s1e01_fast()
switches to the shadow stage-2 MMU here [1], does it need to call
kvm_arm_vmid_update(&mmu->vmid) and check and update mmu->last_vcpu_ran
the way vcpu_prepare_mmu() does?

When trapping from vEL2 with HCR_EL2.{E2H,TGE} !=3D {1,1}, vcpu_prepare_mmu=
()
only checked the L1 vcpu->arch.hw_mmu, not the nested shadow stage-2 MMU
returned by lookup_s2_mmu().  If another vCPU sharing that shadow stage-2
MMU previously ran on the same physical CPU, the hardware AT instruction
can hit its stale stage-1 TLB entries and return a wrong translation in
PAR_EL1, or leave stage-1 TLB entries tagged with mmu->vmid that
vcpu_prepare_mmu() will not flush when the previous vCPU runs again on
this CPU.  Skipping kvm_arm_vmid_update() can also program a stale VMID
into VTTBR_EL2 after a VMID rollover.

[1] https://sashiko.dev/#/bug/linux-43f4f36e-e7bb-4c4f-85b2-b2a827b9cf32

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-nv-tcr2-v3=
-v1-0-9c15c1cabe01@pereq.eu?part=3D1
