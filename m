Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DB54418FC
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332048; cv=none; b=RgvfYRc5Qm79J0ZmymtMdwP5YvQPVZJoLg7PREbZ536W4pZcwUrPUSaBcFQlGGId6shq8otnUF7tCldn/ilEWp3r+yYxTBImioojf3yrwVA0mkgGmBCqkjR/bUZryiivrjli7hHSIPWFU0HOADL1dr/hJGtpsnddg0v8uBfdMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332048; c=relaxed/simple;
	bh=q8U45XHhzj16eoExXEX7LXiHz3I0NO+PekQa60zbKws=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oSrvyTfQ/VjpXoZzxuGumORjNFbD8dLcyzF+FjwI/rsNe7CpLlWv/zRSYnAY/A38YbCOkhZIfNSZLkJE/rYxucfufY/htrBSz2th3zDeTz3u0fBljV8Q/JryIhxOa7USu9pLH9i17jWzreT9frfUddVYPBHuOlAWEECJm1hshAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9IZKJA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9IZKJA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DC51F000E9;
	Wed, 29 Jul 2026 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785332044;
	bh=d9ewqgq2jtwMc38GRNGU3zkBYHw2ALdSi9CvD70wNyE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9IZKJA5Z9W5kwN7X2OCTxa/vCNGlz3kGYCc5Xe8g7Mk3YEtVE7mm3ghQOOXn+D9B
	 5R6mVWku3ZYdK5ywLmGnyzDU3suwzv8kMUCb97lz5mCvO9f0X0XKlVWz81vIvMkogh
	 c8UMOnwvpaqH2HpWxhqr/efJQS+me/nuHougTw2wNKloTHn1i+jxBGwzHITTDNyG/Z
	 lSN07sGI8zN/GacdL5JCCZgdMACcWkI3nPaNh61v710sKe/8JPzONd7zJszxx1tdxH
	 nt/CAmf/4K3XZrewyl0HR9YcWWDOYpEZ/6sVH47wRaDFIeZt376pO69A9qXhsxUptT
	 MFVNu8j3nVCIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260729131823.2021516-3-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 13:34:03 +0000
Message-Id: <20260729133403.C4DC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing bug: `enter_exception64` reads stale `SCTLR_EL1` duri=
ng early trap handling in nVHE/pKVM.
--

--- Patch [2]: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg av=
ailable to HYP code ---
commit e62bbea08d3143161297d701776a47e619a76db1
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code

This commit replaces the locally open-coded __vcpu_read_sys_reg and
__vcpu_write_sys_reg wrappers in exception.c with the canonical
vcpu_{read,write}_sys_reg accessors. For nVHE builds, it maps these
accessors directly to the raw in-memory context accessors, allowing HYP
code to reuse helpers without function duplication.

> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exceptio=
n.c
> index bef40ddb16dbc..754e2dc1df54a 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c

[ ... ]

> @@ -101,14 +85,14 @@ static void enter_exception64(struct kvm_vcpu *vcpu,=
 unsigned long target_mode,
> =20
>  	switch (target_mode) {
>  	case PSR_MODE_EL1h:
> -		vbar =3D __vcpu_read_sys_reg(vcpu, VBAR_EL1);
> -		sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> -		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> +		vbar =3D vcpu_read_sys_reg(vcpu, VBAR_EL1);
> +		sctlr =3D vcpu_read_sys_reg(vcpu, SCTLR_EL1);

[Severity: High]
This is a pre-existing issue, but does enter_exception64() read a stale
SCTLR_EL1 value from the in-memory context here?

When a protected VM triggers an early EL2 trap, the hypervisor handles it
via the kvm_handle_pvm_sysreg() -> inject_undef64() -> inject_sync64() call
chain. At that point, the guest's system registers aren't fully saved to the
in-memory vcpu->arch.ctxt.

While inject_sync64() explicitly synchronizes VBAR_EL1 from hardware to mem=
ory:

arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_sync64() {
    ...
    __vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
    ...
}

It doesn't appear to synchronize SCTLR_EL1 before triggering exception
injection.

Since nVHE builds map vcpu_read_sys_reg() directly to the memory context,
enter_exception64() seems to use a stale SCTLR_EL1 value to calculate the
PSR_PAN_BIT and PSR_SSBS_BIT for the exception's PSTATE.

This corrupted PSTATE is then written directly to the hardware SYS_SPSR_EL2
by inject_sync64(), potentially poisoning the guest's state upon ERET.

Should SCTLR_EL1 also be synchronized from hardware before injection?

> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
>  		break;
>  	case PSR_MODE_EL2h:
> -		vbar =3D __vcpu_read_sys_reg(vcpu, VBAR_EL2);
> -		sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> -		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> +		vbar =3D vcpu_read_sys_reg(vcpu, VBAR_EL2);
> +		sctlr =3D vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
>  		break;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.2021=
516-1-fuad.tabba@linux.dev?part=3D2
