Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AA3313E2B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854108; cv=none; b=R2Ohg/Jt3wixuKnt6iaDjhdiZ0tOIkTXguKttnGFyMPiJZi3jPmP8oA4h4twQLOPR/6MxW147Zqunb3SvXQw4wyA8/Pb8dsWc/Njd+qHtQcKIuPMphw/OTHxxVFPGDcYg6rQWXXHqVIM++84oZMfnQWKtyrCpJvknb05AfKSZVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854108; c=relaxed/simple;
	bh=FZsJDa+Saab1rqZhoxJFNW/rPt7akQYvk2TVt+IZmlE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XV2eeYUDctbNr/i3ALEgKbUn06ARNnPw2JPl6KDVNddlT5tvbiVVW8mAlWVzodXPksH419vEdPAPay6DKkDlmkMO7oJs0ylrd91M2zBdWoxandDNFfG3ms3fjHeBqc2ySEO7cVpcl8Y/6Ci+/Yyb81oKbBEzwXqvE16xfbgb4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8U8Gk7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8U8Gk7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AB91F00A3D;
	Fri, 19 Jun 2026 07:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781854106;
	bh=Amw1cI7QNYrqmwloGw8rDm4kMExWiD1brGLoHbJFU4U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A8U8Gk7zC4CM6ITnler/ofPbBYCQ7GEIk8m610IycNDif6J2mm8m4xM0iWuvV2UbP
	 bLuTSwZRzYQ7DrXH3dX9SaHfAM9f7X431XUH6Y/eT/twtW8uEwB3Hnrop1yWWNuTdO
	 31cS2tOw6+4dhZRBhnOJ391RtUPRL8hu+JDi8HNedKxveudcJPD6bPK8ICJf092/LR
	 iFcNDy0c3fb6TlnMoKBf3M/pLB3uDGbhZm6bXv+Ay/CZLmHa6Xb7O7ihVd45ZAAEtG
	 Z5+Q7rWTOVU35ADm1fL/LLAzm5pC6+B82qx9B7VCmd6/GE0qSHwcJiJ+ieFR9IbsNQ
	 iA0w98M53V4mw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260619070719.812227-9-tabba@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-9-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:28:26 +0000
Message-Id: <20260619072826.A4AB91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Dropped register updates for non-protected guests due to missing P=
KVM_HOST_STATE_DIRTY flag.
- [High] Missing HCR_EL2 sync on guest exit causes an infinite loop of virt=
ual SError injections.
--

commit b6999f3ffe5ca70d542b029d1a2d4a9e5e9d8276
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

This commit defers copying a non-protected guest's register context between
the host and hypervisor. It introduces a PKVM_HOST_STATE_DIRTY flag to only
sync the state when modified by the host.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
[ ... ]
> @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	bool inject_serror =3D ARM_SERROR_PENDING(exception_index) ||
> +		ARM_EXCEPTION_CODE(exception_index) =3D=3D ARM_EXCEPTION_EL1_SERROR;
> +
> +	/*
> +	 * An SError injected below writes the host ctxt; for a non-protected
> +	 * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> +	 */
> +	if (is_protected_kvm_enabled()) {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);

[Severity: High]
Does unconditionally clearing this flag on every exit drop register updates
for non-trap exits?

For non-trap exits like ARM_EXCEPTION_IRQ or ARM_EXCEPTION_IL,
handle_trap_exceptions() will not be called to set the flag again.

If an asynchronous request like KVM_REQ_VCPU_RESET (triggered by PSCI CPU_O=
N)
modifies the host vcpu->arch.ctxt in the kvm_arch_vcpu_ioctl_run() loop, or
if an undefined exception is injected via handle_exit(), flush_hyp_vcpu()
will skip copying these updates because the dirty flag is clear.

Could this cause the guest to resume execution from its old pc with stale
state?

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;

[Severity: High]
Does removing the hcr_el2 sync cause an infinite loop of virtual SError
injections?

To inject a virtual SError, the host sets HCR_VSE in host_vcpu->arch.hcr_el=
2.
When the guest takes the SError, the hardware clears the VSE bit, which is
captured in hyp_vcpu->vcpu.arch.hcr_el2 on exit.

Since this patch removes the copy-back of hcr_el2 to the host for both
protected and non-protected guests, the host's HCR_VSE bit remains set
permanently.

Will this cause flush_hyp_vcpu() to endlessly re-inject the SError on every
subsequent entry?

> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
> +	} else {
> +		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.ctxt.regs.pst=
ate;
> +	}
> =20
>  	host_vcpu->arch.fault		=3D hyp_vcpu->vcpu.arch.fault;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070719.8122=
27-1-tabba@google.com?part=3D8
