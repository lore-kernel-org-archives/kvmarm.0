Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D352E7621
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781455549; cv=none; b=X1ioQVwfR4UCo/33k9qUTOXw5BxBb4VK8M/FbOK4hS2SxISJxz6KOIsNpyc3U9AzMmZcppSGk6t7A4zMc3v7X2t8dRzp2RdZN+hZO994jLAlwAPF1s/8hb8imGt1rZ9WiLmiAijQ7N60Zcck0IQNTPGPJFUMycEr5luyIQIUmAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781455549; c=relaxed/simple;
	bh=5uhr6w1bulh3lKNqfvKhIQxd0cwWSpCi9XRvQrI/MGU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=umyq82UisbQSz8DPZt4YId6MqsWP0tt1Qwol8rdsTfikiDtKIddnVEqjEa0tjv034FWpXuoZlpNMbJfi2+s31zaF721CKjdAqILW1eMXgnVjX6u73ESPQqfCDkFyWVeLIwq1mkmxwvq2/PL0E7OLNb1aHf3a0jF+883MSQjvSig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NI5kzTAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NI5kzTAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D398B1F000E9;
	Sun, 14 Jun 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781455548;
	bh=8QKoaw+Dtco+lRAjUbfhT79XRPhxiHYL6kh249wNXuQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NI5kzTATKbQv2JzgrWRFzRvCv0bjJGy1kOGbP50+K4dBirNInGCcbmiI26KuAdDm2
	 6pP25H8MJfUF4au0Vwx5AF8+O3l6av3lTk0IOaP3uOFWF6avPXiLgzBDfxAr6C9U89
	 FCVoguFMwet9zRzaQdKi6YwcuXrIjsJY/38j1acZYnrUaLQlBHoC57OTSXLthG4d/H
	 279l2kgEdK0MUX+4yl1KSlQaRLEr0Rz0VfvD2SKH+fFFk9l+a+fsLhtp8LBYSj2OhJ
	 guuMy8nyAuDOi5Vpde5fBLmkUvCcfVHPwbp5ZT4MXnD9F3PEOGqq+mZ1AFqU2H63Ry
	 qgZAyGHugPxrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260614163336.3490925-5-tabba@google.com>
References: <20260614163336.3490925-5-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 14 Jun 2026 16:45:47 +0000
Message-Id: <20260614164547.D398B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incorrect Emulation of Illegal Exception Return corrupts ELR_EL2 a=
nd may cause spurious Instruction Aborts
--

commit 56bc216de713f5bf0e45ff5ad97580cbdc7eeb66
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation

This commit fixes the FPAC syndrome constructed during nested ERET
emulation to include the IL bit. It ensures that the IL bit is set to 1
for ERET and its authenticated variants, which are always 32-bit A64
instructions.

> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2777,7 +2777,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>  		 */
>  		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR_IL_BIT)) {
>  			esr &=3D ESR_ELx_ERET_ISS_ERETA;
> -			esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
> +			esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC) | ESR_ELx_IL;
>  			kvm_inject_nested_sync(vcpu, esr);
>  			return;
>  		}
>  	}
> =20
>  	preempt_disable();
>  	vcpu_set_flag(vcpu, IN_NESTED_ERET);
>  	kvm_arch_vcpu_put(vcpu);
> =20
>  	if (!esr_iss_is_eretax(esr))
>  		elr =3D __vcpu_sys_reg(vcpu, ELR_EL2);
> =20
>  	trace_kvm_nested_eret(vcpu, elr, spsr);
> =20
>  	*vcpu_pc(vcpu) =3D elr;
>  	*vcpu_cpsr(vcpu) =3D spsr;

[Severity: High]
This is a pre-existing issue, but does setting the PC to the target address
here cause issues when an illegal exception return is detected?

If kvm_check_illegal_exception_return() previously detected an illegal retu=
rn
and set PSR_IL_BIT in spsr, kvm_emulate_nested_eret() unconditionally
advances the guest PC to the ERET target address (elr) and returns to the
guest, relying on hardware to generate the Illegal Execution State exceptio=
n.

Wouldn't the hardware then save the target address into the guest's ELR_EL2
instead of the faulting ERET address, corrupting the architectural state?

Additionally, since the hardware fetches the instruction at the target addr=
ess
using the guest EL2 translation regime before execution, an unmapped or
unexecutable target address could trigger an Instruction Abort instead of t=
he
required Illegal Execution State exception, per ARM ARM D1.8.2.

Could this result in the guest hypervisor receiving a spurious Instruction
Abort for an EL1/EL0 address?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614163336.3490=
925-1-tabba@google.com?part=3D4
