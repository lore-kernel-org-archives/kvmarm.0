Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9B34D901
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787988065; cv=none; b=Eo6QXIKsl9UPivEtk27w36ZYOzM4YwWxJZPnKZwkBs4WOURh4hk15dVaP+mhH65q+pGaslJisebGNWLyl9VUiisvajwU8Pr0iee+JBaS4RC40ErfZK7fNb5r2N/j1KK83u15eV/zghdElHeERmH+NkXDa/vo6ml9aD7M+KG6ptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787988065; c=relaxed/simple;
	bh=EpkQ0ceANb6rjXIjzvpwbZfTL/LJFC4Lo8PQDuZHwcQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Nkyya1iaAbcyhUgTgRVCH1ANE73BIkwd0OklaKFT5m2Dd7daqTTUg+R6a3CAm+Ceh+e3Ltb4MEKWbJ8S8cX9Ya9ENAwr5cJ9Dm2O56kyyV2G5xvAk2BzwuMUh1OXb8f+lGzqfgCBeLBTe/tpDs+OdEc593ZWTXVDVQ7OS9p6At0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NybgQ9C2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NybgQ9C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20271F000E9;
	Sat, 29 Aug 2026 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787988064;
	bh=df03sOxp/01MfIgQYvXnGzR42qjUTpzQ1A6daidzi8Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NybgQ9C21YlHspqH7241JT1t7jWyf3YrAS/7peubnORbY0ztRdvwso5OuM025h7ZP
	 hhhyTMzA1yuDKX9s9G6FawFIQTaMpF76vso4fylWvrS1jUTlFSqGQfwqaMHdWX+xGC
	 vbhbudGKJgDkTcfVbW25tt9fTqs2LlxDdAtFgdvHqKnd6U0TgawR3SREIP7wCP42yx
	 nFdO9yokKQNuoT/FfFs1dUSswpsHu3fiijLzZF0oWHlA1gk35ZqvjW7LbmBLmak/h7
	 lVoJe6QF169I+hpdR9pTaWiErmZbw2pA8JM4BryFaPUfz38w1ijcAEqQreri0+3plh
	 wKHAx6LjN6CUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU
 under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260829071120.2522788-1-fuad.tabba@linux.dev>
References: <20260829071120.2522788-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 07:21:03 +0000
Message-Id: <20260829072103.D20271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] pKVM unconditionally leaks and overwrites protected guest cont=
ext (including general purpose registers, system registers, and trap config=
uration) to and from the untrusted host on every guest entry/exit.
--

commit 4f524814ed8b14fca5b29ea5c6eacae85dfdeb56
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM

This commit ensures that the HCR_EL2.VSE bit is synchronized from the hyp
vCPU back to the host vCPU on guest exit under pKVM. It prevents the same
virtual SError from being pended repeatedly.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 65a7c735aa398..be35ff5958c82 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -276,6 +276,10 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
> =20
>  	host_vcpu->arch.iflags		=3D hyp_vcpu->vcpu.arch.iflags;
> =20
> +	/* Cleared by hardware once the guest takes the vSError. */
> +	host_vcpu->arch.hcr_el2 &=3D ~HCR_VSE;
> +	host_vcpu->arch.hcr_el2 |=3D hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
> +

[Severity: Critical]
This is a pre-existing issue, but does this code unconditionally leak and
overwrite protected guest context to and from the untrusted host on every
guest entry and exit?

In sync_hyp_vcpu(), just above the lines added here, the code copies the
confidential guest context back into host memory:

    if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
        host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

This appears to leak protected guest register state to the host on each exi=
t.

Additionally, on the entry path in flush_hyp_vcpu(), the untrusted host
context completely overwrites the protected guest's context:

    hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;

It also seems to allow the host to inject its own debug trap configuration:

    hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;

Could this allow the untrusted host EL1 to read and write all protected
guest registers and inject debug traps, breaking the pKVM threat model
guarantee that host EL1 cannot read or modify protected-VM memory or
register state?

>  	sync_hyp_vgic_state(hyp_vcpu);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829071120.2522=
788-1-fuad.tabba@linux.dev?part=3D1
