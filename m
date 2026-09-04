Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FB30C16A;
	Fri,  4 Sep 2026 13:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527159; cv=none; b=CRD7Hu64ueMSjYJlHtj9WLu+riWjrZLjyV//sUo4kECKSCLsR0k70DPx8iCHAktsByPHboA4N89SQyNR9eNwGGE3gcZ+G0/pZ0MW3D7NgPqBGMfJGl5xX/jV3Xl92aRF3GoaV6IrbuVXKCZpQkJRjyFslOmP2dEyoI1U43DjYbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527159; c=relaxed/simple;
	bh=qhu6btIAusw6rHvt5juXkHhc8a2yXLOxN1F8bEaJaRE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JcfKI+npRfr4K7zQbqWL4BTPBN62yyjllzZ+/akqjP2Kr9ZhuYY8nbpSQ2bGdSkJTqggVVMOBLYmpWjai6fCeSiZHtYrgbHm/jO9Ivh+4LMOvFRH0laLU8JD4TDPHU6dp/yrKMD9lQP7Iv1TsNCgor0XApTzBnVjcP9oAfwtKzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaNxFtHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaNxFtHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CFD1F01564;
	Fri,  4 Sep 2026 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788527157;
	bh=fFLnlLSXjYy6jFtau2Yv7Nd0enqAeLIWbFxH8QhnDv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iaNxFtHK2LTS/061jTlgZiAj+brwwa86PrwuNC6jH6awHVegFh35omCtGWTNMFg9P
	 gBRv0aYWBSYl0juwANHhHiKI28NTVh1gfPcdgGugbkJj3g0i5g8JkzOR9D3yLnej3T
	 Ybmh5GyALNzOiwDZa3bzuePy4yDk9WmSEestoZUCOugvWPAvgHPjyzChEjKFNGLuLu
	 8QCkcm7F9GhRaSLcfXDmxi1YGjpm472DLARe5HJDEGNQHptdePU5TeDGZuAmbGDAp7
	 vhKyCE04eqFKLXixxrLhhz0LtMEiWtBlKPBJxhdDFGGFx83QJ5JbJGVuoEtzSof1id
	 xOWm+qm2G3vsw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260904113404.4051341-24-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-24-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:05:56 +0000
Message-Id: <20260904130556.A8CFD1F01564@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Skipping the doorbell request when the IRS is disabled breaks vSGI=
 wakeups and causes a KVM blocked-state deadlock when the IRS is re-enabled.
--

commit 614bfb31d4f0af06eb90b62b9d08cfb10894ae32
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state

This commit uses the GICv5 ICH_CONTEXTR_EL2 IRICHPPIDIS field to emulate the
guest enabling and disabling the IRS. It programs IRICHPPIDIS when loading a
VPE and skips calculating the doorbell priority mask and requesting a doorb=
ell
when a VPE enters WFI with a disabled IRS.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index bdf06dbff4231..5a5abf51d4ddd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -1101,7 +1103,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
>  	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
> =20
>  	cpu_if->vgic_contextr =3D 0;
> -	if (vcpu_get_flag(vcpu, IN_WFI)) {
> +
> +	/* Request a doorbell if entering WFI, unless the IRS is disabled */
> +	if (vcpu_get_flag(vcpu, IN_WFI) &&
> +	    READ_ONCE(vcpu->kvm->arch.vgic.enabled)) {

[Severity: High]
Does skipping the doorbell request when the IRS is disabled break vSGI wake=
ups
and cause a KVM blocked-state deadlock when the IRS is re-enabled?

If a guest disables the IRS (setting vgic.enabled =3D false) and a VCPU
executes WFI, vgic_v5_put() will skip requesting the hardware doorbell.
If another VCPU sends a vSGI to this sleeping VCPU, the hardware cannot
assert a doorbell to wake the physical CPU, so the vSGI is ignored.

Furthermore, if another VCPU later re-enables the IRS, KVM sets
KVM_REQ_RELOAD_GICv5 and kicks the sleeping VCPU. The VCPU thread wakes up =
in
kvm_vcpu_block(), but because KVM_REQ_RELOAD_GICv5 does not set
KVM_REQ_UNBLOCK and does not make kvm_arch_vcpu_runnable() return true
(as db_fired is false), kvm_vcpu_check_block() returns 0. The VCPU thread
goes right back to sleep without processing the request or re-requesting a
doorbell, resulting in a permanent hang.

>  		u32 priority_mask;
>  		int dbpm;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D23
