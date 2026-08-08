Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE1255F28
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 09:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786180191; cv=none; b=Np1ey5jKbm/5qnNUrf0GfWu23Mt5Gwd2UK44MgaiWqIB6qjwGt2r0AMLR8/fiDlnT0i+uXFpjSfJkL8f24anCJajFHUFkw+Wi7wi0ech5oQtvXDzpzVSKsvmgQ97N0LZG3csfQKY/8Rv/PkAGUppsGP9viKodzKJgZFSJf38NxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786180191; c=relaxed/simple;
	bh=v1Wz5E0vFn0fK3cKGqLndXLyALFSdPBy3/GnerQXvdM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kYZy5HwuV+ejaGVuDmg6NyMoYkIh5lSM6ICqkJKayBzgZZa1vMUUZ7Fd705i5CA1K8RVArkcJL99ij2hr/6BTZEAQJxR/fQGgixTzt+gPFmcNeBT2THf3P/GBoXYLv1sdPf/kxifxfzBqPj//SkU/ISXrxqYb2EGb6zlLUOs67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jit1ZgYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jit1ZgYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6441F000E9;
	Sat,  8 Aug 2026 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786180190;
	bh=gNG5QMx+5tBJ7T0BAE0kJ0HzS8NX0uT9gvedzkkfFOE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jit1ZgYboiSabgERtTmE7Ri7vUapLhbw9Z2eBeCiLXldk9XZ17Wnvc2s8SIyqUvik
	 sUPl6Pvb4niXeSE1ipzIfgXzlqifcDAH9e1WUOD0yY90hG1L9SgKMft4M0EUl+zUgO
	 FUPSqFbvJpYFjs8oX+MQmdZ/uh76dtv9ZNUlC5pa/SMS+F19S8lSpzMmN2vTF2Xo0O
	 +EpJA/YZWfWOlX4AhgP7n4Sr16M/njK1wYag7MAMkgXeVq3iSIsi8LXDCDtuZSclpz
	 HVBVvkghJZuSJCabIs+SJ7h3Vyj3kDOh2kPtuhxEgePWDaqbBWSh6EYxe4EbJN/ux9
	 U6Eu6mIRKyqwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] KVM: arm64: Fix timer offsets for non-protected
 VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260808085824.732659-3-smostafa@google.com>
References: <20260808085824.732659-1-smostafa@google.com>
 <20260808085824.732659-3-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 08 Aug 2026 09:09:48 +0000
Message-Id: <20260808090949.4C6441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (`isb()`) after writing to c=
ontrol-plane system register `cnthctl_el2`.
--

--- Patch [2]: [PATCH v2 2/3] KVM: arm64: Fix timer offsets for non-protect=
ed VMs ---
commit 0ed46cb1bdd2dc0d545a0cd2b0b6f500a46a254f
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Fix timer offsets for non-protected VMs

This commit fixes an issue where timer offsets for non-protected guests
were not correctly applied in pKVM. It corrects the protected VM check
in __timer_enable_traps() and initializes the previously null timer offsets.

> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe=
/timer-sr.c
> index ff176f4ce7deb..51b4f5010b660 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> @@ -45,11 +45,11 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
[ ... ]
>  	clr =3D CNTHCTL_EL1PCEN;
> -	if (is_protected_kvm_enabled() ||
> -	    !kern_hyp_va(vcpu->kvm)->arch.timer_data.poffset)
> +	if (vcpu_is_protected(vcpu) ||
> +	    !timer_get_offset(vcpu_ptimer(vcpu)))
>  		set |=3D CNTHCTL_EL1PCTEN;
>  	else
>  		clr |=3D CNTHCTL_EL1PCTEN;

[Severity: High]
This is a pre-existing issue, but do __timer_enable_traps() and
__timer_disable_traps() in arch/arm64/kvm/hyp/nvhe/timer-sr.c need an
explicit isb() after writing to cnthctl_el2?

Looking at the end of __timer_enable_traps(), it updates cnthctl_el2 and
returns:

arch/arm64/kvm/hyp/nvhe/timer-sr.c:__timer_enable_traps() {
    ...
    sysreg_clear_set(cnthctl_el2, clr, set);
}

The same pattern exists in __timer_disable_traps().

Because sysreg_clear_set() does not embed a Context Synchronization Event,
the CPU executes the subsequent RET instruction (and any caller instructions
before an eventual isb() or ERET) against an architecturally undefined
pipeline state.

Could this missing immediate context synchronization event after a
control-plane system register write lead to unexpected traps or memory
safety violations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260808085824.7326=
59-1-smostafa@google.com?part=3D2
