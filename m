Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48573CAA3A
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 22:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805952; cv=none; b=d25ZoprHxGbnYsAN/m3wnSGxzRh3CaKTrCrRc0W4FUORBXdsixc/+Jnbr/Xq88lFM8Bbj+scRmNf46vj8BHcfu3wW/YsD3bz01sNsFl+mrLOEPv548oqQxYUzHbOWnY2XlLyb8RI+9NAx9fZcUsqEPDhAGb0rYsUiwORjMnwGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805952; c=relaxed/simple;
	bh=37jaK42kR4hlKDVjcN1QZbGI9p7Cr726ukexTJmO+4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pTZqy1ntiER4W0wNAzsLZxMF3tQi3cTPrWvdKMUIfv8pZj7R+Fii1B1/cEyyWTDubcgCRP9C6cOjE3Wb3Q8HqXMYc6FSw6FgEx3f22HbVAG+qgfO9u8uTUbgjGnwokP76MTQ4a3Zqfu12PvVTVyrSdl3+aqwhQKeNMkiIRrYqZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ai3ninsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ai3ninsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014471F000FF;
	Wed, 30 Sep 2026 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790805951;
	bh=+dAXqnbG3ZkwSaLzTvCaXYGAD5/KCPFVviy+E8ULsEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ai3ninsTWWad2n0RGT8j0oO58N26epWblmPU53qIpivvkW6a5x/eSqu8GS59P4NPI
	 VeQsK0SkjG04kbQ9b0CQt6yUOQ88SW6J3dMOqOpRGJj0T0GYznB6Rhs73UOEpEYHZI
	 HomjM7RaaLfNhrgK3XImHKjTV+xpMkD4uFmCfJRcVZkBUemacRsvL2w6pFGXcHUAcW
	 IdTqUGfFdMtOP4+KDj9hm3F2R+ab6NWTs+kf6lw8dpRTMKEc2XycHCW9mFDLuSyLm7
	 FDHTiYoe610IWxtgNtcApzjLoKXsSbRGfQFUUOctBNqyjyxoj+po0E3ZQPMkKytkVa
	 G4KGSkWnkz7mA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with
 S1PIE or S1POE but not TCR2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 22:05:50 +0000
Message-Id: <20260930220551.014471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] kvm: arm64: TOCTOU race bypasses S1PIE/TCR2 ID register valida=
tion
--

commit ecf3602b27fe0cb6f8ce76b1a8c6698e3dee08f4
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Refuse to start a guest with S1PIE or S1POE but not TCR2

This commit adds validation to reject starting a guest with FEAT_S1PIE or
FEAT_S1POE enabled if FEAT_TCR2 is disabled, as the hypervisor requires
TCR2 to properly context-switch these registers.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..3ae293798b270 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> @@ -5928,6 +5946,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  		kvm_vgic_finalize_idregs(kvm);
>  	}
> =20
> +	if (!kvm_validate_id_regs(vcpu->kvm))
> +		return -EINVAL;
> +

[Severity: Critical]
Does this introduce a Time-Of-Check to Time-Of-Use (TOCTOU) regression
that bypasses the S1PIE/TCR2 ID register check?

If Thread A executes the first KVM_RUN, it passes this kvm_validate_id_regs=
()
check because the invalid configuration hasn't been set yet. The config_lock
is then released.

Thread B could then execute KVM_SET_ONE_REG for the ID register, take
config_lock, and inject the invalid S1PIE=3D1/TCR2=3D0 configuration via
set_id_reg() in arch/arm64/kvm/sys_regs.c, bypassing the immutability check
because KVM_ARCH_FLAG_HAS_RAN_ONCE is not yet set.

When Thread A proceeds to execute kvm_calculate_traps(), it reads the
maliciously modified ID registers and disables the traps, before finally
setting KVM_ARCH_FLAG_HAS_RAN_ONCE in kvm_arch_vcpu_run_pid_change() in
arch/arm64/kvm/arm.c.

This regression allows KVM to configure traps based on S1PIE, disabling the
trap for PIRE0_EL1, but skipping context-switching the register because TCR2
is disabled. Could this allow the guest to directly overwrite the host's
physical PIRE0_EL1 register?

>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-arm64-gcs-=
v21-0-3556644cd927@kernel.org?part=3D2
