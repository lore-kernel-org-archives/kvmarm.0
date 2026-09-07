Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BA385529
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765813; cv=none; b=YCqvlhbsSLEuL2NS2N+9Mvf8kUDAu0BMcdC20EPkq6sFmo/+apTrB26FrniGK+Jci1aIb8E5ozbEVKWc31ZZ8NaldEzD8WV4TiUFE97q4QIPO4McbEjqgY27+d62jFA5Ieiv6qwd/Tjm5GjDe84ntwSgGtX/MgxrPBEKDTu85jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765813; c=relaxed/simple;
	bh=xCA+lcFT3pi/GNqXopt3d+U+nbhIyyt6cd7+eXJ2uvM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mY3DBRb04Yiha0IiGmdKZR71wE7aJrwqzNMtRrdg8NCjULa7nIuyxuP/jTYRu4GHvo6hbGDW0c3dFgrI/d28L4QBTo8ZxEAJ+xng7D+SgI9dR5AM35dlNHk0dxaW7qraYB+BmG5m5LSs6ewCMQGtNfIDsU+8CDqR+FUZYBP2vis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhddphMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhddphMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66021F00A3A;
	Mon,  7 Sep 2026 07:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788765812;
	bh=x6tT2VZemZemuh06w1YgThe/yxrd/3JobSURHLn4jio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhddphMc1YxwlQ/B0kKkKSRx1+ade1oMmH3gvv8XHW/0wzq2piEEnaqBOq/WnUETW
	 3B+dSkq53kBwqcwl+8SepdERQ+erL+KUjyZ8WGdFPRM63zF+Pw70yjPX9AZSzQ84Wz
	 dVCMYdFWCyAkHvyKjJtmWLbanleMK03ZO8v7ijoBUH+FPs2pa4hzza7+VPdB9iW9F4
	 rsCemKmXouLYGl7s8WS+/2EFnuvYRvUvmu22wCp97ATWakLLPg+pd9otdYwmBAiwDk
	 Toys5gyvoJ7D/74iWqv2U3uGo4E3jN2VdZSphj0aOundk8xsLissWRQLkkvL7lavek
	 8PfPiKl1W6S0A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260907070002.3333525-5-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 07:23:31 +0000
Message-Id: <20260907072331.A66021F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] State Leak and Host Integrity Bypass via Unswitched Debug Register=
s for Protected vCPUs
--

commit d142f7027c7a95ffce6ea110097ca91e27e8ccea
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Skip fixed-feature state flush for protected vCPUs

This commit modifies flush_hyp_vcpu() and related debug state flushing
functions to skip copying fixed-feature states, such as mdcr_el2, TWI/TWE,
and debug state, for protected vCPUs. The host's debug registers are
considered hypervisor-owned for protected guests, and the debug state
flush now returns early in this case.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index ca7122b0bccdd..aeff6ded40fd6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -200,6 +200,9 @@ static void flush_debug_state(struct pkvm_hyp_vcpu *h=
yp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +

[Severity: High]
Does this early return in flush_debug_state() in
arch/arm64/kvm/hyp/nvhe/hyp-main.c bypass the debug register context switch
for protected guests?

By returning early here, hyp_vcpu->vcpu.arch.debug_owner is never updated
from the host and remains at its default VCPU_DEBUG_FREE. During the world
switch, __debug_switch_to_guest_common() and
__debug_switch_to_host_common() return early if debug_owner =3D=3D FREE.
Consequently, KVM bypasses saving the host's live hardware debug registers =
and
loading the guest's debug registers. The guest enters execution with the ho=
st's
actual hardware breakpoint registers still active in the pipeline.

Normally, this is mitigated because KVM sets MDCR_EL2.TDA to trap debug
accesses if the guest doesn't own the registers. However, for protected VMs,
pvm_init_traps_mdcr() only sets TDA if DebugVer is unimplemented. With
TDA unset, the protected guest can freely read the host's debug registers
(leaking host state) and overwrite them when it explicitly reads or writes
DBGBVRn_EL1, DBGBCRn_EL1, or MDSCR_EL1.

>  	hyp_vcpu->vcpu.arch.debug_owner =3D host_vcpu->arch.debug_owner;
> =20
>  	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {

[ ... ]

> @@ -218,6 +221,9 @@ static void sync_debug_state(struct pkvm_hyp_vcpu *hy=
p_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +

[Severity: High]
Does this early return in sync_debug_state() in
arch/arm64/kvm/hyp/nvhe/hyp-main.c skip restoring the host's debug registers
upon guest exit?

Because the context switch back to the host returns early due to the bypass=
ed
flush, any guest modifications to the hardware debug registers persist into=
 the
host execution context. When the guest exits, the corrupted debug registers
remain active when the host resumes execution, allowing an untrusted protec=
ted
guest to mount an attack against the host kernel.

>  	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
>  		host_vcpu->arch.vcpu_debug_state =3D hyp_vcpu->vcpu.arch.vcpu_debug_st=
ate;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.3333=
525-1-fuad.tabba@linux.dev?part=3D4
