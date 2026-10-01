Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2779951B188
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864471; cv=none; b=e7W4YFheYjDrc2uYZHoHf3JY9skgoXFIuWQHdflhShwZABGJSZ1jVmHnTTJ6E7hc4sdeTvTw4YgA+32c5KGcVI6woSsz6RwnLpeft7YEmqHADpH7D6wQIsgSbPtlBz0gRxL56IlQN+A8ixqvgJ0uTC0yyk2XKF0Zw3wCfaaeySc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864471; c=relaxed/simple;
	bh=O5C6NWgeqkFXh7VH41+A0m8eMVNRkAKQcjqUBdUek24=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jAbbfEZiArp94HR4BaTZCqXyTo0HT78aLQok1+JTDqrgZT2ooGzuJBMiuVRQA+J04g9IX7QHysFJZoYx0yKHoNwZ/kylI3Ni+AAWpzQrYbGpab3PkiImfdnwW2ILKHBgWQAKJwLGI3Lw1YDBTSyr1J22AHeQt28ZSIsmEZga+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUmi7jk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUmi7jk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794CA1F000FF;
	Thu,  1 Oct 2026 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864469;
	bh=yiZaOxoZQWQLGoR/aa6tOqaFKHqeljJ2axf8kl+MhrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lUmi7jk/De7gHxtoUSXTUURahqTc8Xw9dUl+wSuCn9oymy6m5dweHMwlw2f2+HmSD
	 1F1XMoloSvMtOtj5/iJulaIyF26iUqtn21zM8Zi8QrTp3CNX/HC1gQCcLxWhjKnxVg
	 0SYoDSAWqFTi2OmEuV+FGlGnl4MBCVs9DJwJgTxXY2b/XJwVnm245bKDhe7etx/Yko
	 8nDQl3dmAWDesRUg0SIPZSFo0H3TacCl2CsSo/hzMB5uLV8n0bHQfVU6SylQISCUHq
	 lUZKmRGiPGQILXyhSsSA/PLS1J7S5Bk/JNppbA7l8tBwauok6mSAcYEcOort04cxLX
	 c0TyNWOPtkukg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/18] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001135711.1640520-13-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-13-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 14:21:08 +0000
Message-Id: <20261001142109.794CA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] kvm: host DoS via KVM_SET_VCPU_EVENTS and uncleared INCREMENT_=
PC
- [High] kvm: silently dropped exception injections on non-trap exits for p=
rotected guests
--

commit 8bf814727f8778e45c8fb25a3c96ee3b58fc462e
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Prevent host PC adjustments for protected vCPUs

This commit modifies __kvm_adjust_pc() to leave PC_UPDATE_REQ (including
INCREMENT_PC and PENDING_EXCEPTION) on the host copy for protected VMs. It
introduces kvm_adjust_pc_get() which returns NULL for protected vCPUs,
bypassing the adjustment and leaving the flag clearing to entry/exit handle=
rs.

> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exceptio=
n.c
> index 6e60d890afa4a..93d68b1d38be8 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -353,12 +353,19 @@ static void kvm_inject_exception(struct kvm_vcpu *v=
cpu)
>   */
>  void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
>  {
> -	if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
> -		kvm_inject_exception(vcpu);
> -		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> -		vcpu_clear_flag(vcpu, EXCEPT_MASK);
> -	} else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
> -		kvm_skip_instr(vcpu);
> -		vcpu_clear_flag(vcpu, INCREMENT_PC);
> +	struct kvm_vcpu *target =3D kvm_adjust_pc_get(vcpu);
> +
> +	if (!target)
> +		return;

[Severity: Critical]
Can this early return leave INCREMENT_PC uncleared, leading to a host panic?

When an unprivileged host userspace VMM manages a protected VM and sets
SCTLR2_EL1.NMEA=3D1, a guest MMIO exit causes kvm_handle_mmio_return() to s=
et
INCREMENT_PC on the host vCPU copy.

If entry is then aborted due to a pending signal, we exit to userspace
with -EINTR. Because target is NULL for protected VMs, we return early here
without clearing INCREMENT_PC.

If userspace then calls KVM_SET_VCPU_EVENTS to inject an SError (with
serror_pending=3D1), serror_is_masked() returns false, which causes
pend_serror_exception() to call kvm_pend_exception(). This hits the asserti=
on:

WARN_ON(vcpu_get_flag(v, INCREMENT_PC));

crashing the host if panic_on_warn is set. While Patch 14 attempts to fix t=
his
by clearing PC_UPDATE_REQ on exit from EL2, INCREMENT_PC is set at EL1 on M=
MIO
return after the EL2 exit.

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 00038a162d09b..2fcd3f8cc8fc4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -644,6 +644,38 @@ static void handle___pkvm_host_mkyoung_guest(struct =
kvm_cpu_context *host_ctxt)
>  	cpu_reg(host_ctxt, 1) =3D  ret;
>  }
> =20
> +/*
> + * PKVM_HOST_STATE_DIRTY names the authoritative copy, the host's when s=
et.
> + * A loaded protected vCPU takes the request at its next entry instead.
> + */
> +struct kvm_vcpu *kvm_adjust_pc_get(struct kvm_vcpu *vcpu)
> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +
> +	if (!is_protected_kvm_enabled())
> +		return vcpu;
> +
> +	hyp_vcpu =3D pkvm_get_loaded_hyp_vcpu();
> +	if (!hyp_vcpu || vcpu =3D=3D &hyp_vcpu->vcpu)
> +		return vcpu;
> +
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return NULL;

[Severity: High]
Does deferring exception injection to the entry path cause host-injected
exceptions to be silently dropped on non-trap exits?

If a protected guest exits due to an IRQ (ARM_EXCEPTION_IRQ) and userspace
calls KVM_SET_VCPU_EVENTS with serror_pending=3D1, PENDING_EXCEPTION is set=
 on
the host vCPU.=20

On KVM_RUN, flush_hyp_vcpu() evaluates the exit code and bypasses the
ec_handler for non-trap exits:

	case ARM_EXCEPTION_IRQ:
	case ARM_EXCEPTION_EL1_SERROR:
	case ARM_EXCEPTION_IL:
		break;

This ignores the PENDING_EXCEPTION flag during entry. When the guest exits
again, sync_hyp_vcpu() unconditionally clears PC_UPDATE_REQ (which includes
PENDING_EXCEPTION), permanently losing the injected exception.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001135711.1640=
520-1-fuad.tabba@linux.dev?part=3D12
