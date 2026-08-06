Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A7390218
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030297; cv=none; b=ZeUxwgo/2tKaLC4B32T/wd7urWqTM2pdh9s75E4dj8vzoKh/i3OJsx+ZPuroXzY3gY6y4LLRagzuQC1zt/PGqMMW8wTEi/nNcKK0KxuEm1P/RSvEOpv1OaO2Af+U/x7avCVIIwlbwsQsvua5EnE5EjynsgFkfPaKY3FqDPggG7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030297; c=relaxed/simple;
	bh=59BoZEWvzjZH9smtNe2wm+ZXBC4pJ7y7R4IUojiDnM0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ueHxbhaoDwUBNbtatOUFqqZhuoYv6sXSNfq7CM8efXFEBloRnD90kBlBBcIfJVRFhEgYCGrQhlYKhlRrYPhN4lF4SwafL/cbPiN02wk5pWi+SUrsJn0uiKlf5cgsr3bTk/9zQtgumzMz6bkLCBg5+vn6ynSYFidnSUcAQ7Ve1v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enlTbWOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enlTbWOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E851F000E9;
	Thu,  6 Aug 2026 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030295;
	bh=EJDcZ6emdtPfgb7FvyVBubOepJ2plBbWFS413YeU4aU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=enlTbWOqeQoB9tKkXk+Q5WQL3ximWZ34a30U344UzeK31g01kfTap5k01L/OsPfQr
	 Z0qZZYjSbuanvQIkptofzt0DZNmenb7LIp53CO1p0uO4t876g6SDedlzKlHpVp8+L8
	 cMZg2gWBn+KRrprII4WX/z4CTzGpwZa4hQxzLgg6r5+NTh86rQeKL5ScrE4pmJX2i0
	 ocq0Ew4ec11DP9VKRHk+1YSEkDGSqkvMVA6hIFspsDXCjuqn9guopBxMLooD1NGul/
	 l4acJjUujv1wZjnhf4F/jsbs90spp7YHiQkrgJZxQSayDSy4d1rp/QWSWlct29RS0E
	 35FhZq1vr1s3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806150105.4010701-1-smostafa@google.com>
References: <20260806150105.4010701-1-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:31:34 +0000
Message-Id: <20260806153135.02E851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Virtual timer traps are inadvertently disabled for non-protected g=
uests under pKVM on hardware with broken CNTVOFF_EL2, breaking their config=
ured timer offsets.

Pre-existing issues:
- [High] `__timer_enable_traps()` uses the global `is_protected_kvm_enabled=
()` check and an unsynced `poffset`, unconditionally disabling physical tim=
er traps for non-protected VMs under pKVM.
--

--- Patch [1]: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2 ---
commit d5e405a74fba9d73744f97970471012a4473ce3c
Author: Mostafa Saleh <smostafa@google.com>
Subject: KVM: arm64: Fix hvhe and broken CNTVOFF_EL2

The commit fixes a guest kernel panic when launching a protected VM with
protected hvhe mode on hardware with a broken CNTVOFF_EL2. It achieves
this by conditionally enabling virtual timer traps only when the guest
actually has a non-zero virtual timer offset.

> diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe=
/timer-sr.c
> index ff176f4ce7deb..98b6e37ee8fa4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
[ ... ]

[Severity: High]
This is a pre-existing issue, but does the physical timer trap logic earlier
in __timer_enable_traps() improperly grant all guests under pKVM access to
the physical timer?

Looking at the physical timer access check in this function:

	if (is_protected_kvm_enabled() ||
	    !kern_hyp_va(vcpu->kvm)->arch.timer_data.poffset)
		set |=3D CNTHCTL_EL1PCTEN;

The is_protected_kvm_enabled() static key reflects host pKVM support and
applies to all guests. Additionally, the fallback poffset check evaluates to
true under pKVM because the EL2-private hyp_vm->kvm is never populated with
the host's poffset during init_pkvm_hyp_vm().

Can this cause non-protected VMs on older hardware without CNTPOFF_EL2 to
bypass physical timer offset emulation and read the raw physical timer
directly?

> @@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>  	 * Trap the virtual counter/timer if we have a broken cntvoff
>  	 * implementation.
>  	 */
> -	if (has_broken_cntvoff())
> +	if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu)))

[Severity: High]
Could this condition inadvertently disable virtual timer traps for
non-protected guests under pKVM?

The new check evaluates hyp_timer_get_offset(vcpu_vtimer(vcpu)). However,
under pKVM (nVHE), the EL2-private pkvm_hyp_vcpu structure's timer_cpu state
is never synchronized from the host vCPU during init_pkvm_hyp_vcpu() or
flush_hyp_vcpu().

Since ctxt->offset.vm_offset remains NULL, hyp_timer_get_offset() will
unconditionally return 0. Will this allow any non-protected guest with a
configured virtual timer offset to bypass the trap and incorrectly observe =
an
offset of 0?

>  		set |=3D CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
> =20
>  	sysreg_clear_set(cnthctl_el2, clr, set);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806150105.4010=
701-1-smostafa@google.com?part=3D1
