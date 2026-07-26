Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBBD3BBFA5
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785077683; cv=none; b=IO+8lUgcAWHUmcUGyfZFH9sBq5wkid7SoolbVdHvAKPLXozON84uwI7KyZzaCb3nXczjDmoP/BfrVaiYgeMZlBDeLOKMLCX7c3YVV2++un4i6RkTaZE6gFydKL7a4UOTZDhqHTREapd85GKIO2OMUipn0dIMuk1U05BoxwC96Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785077683; c=relaxed/simple;
	bh=y5NcmBoxfuegtyaxB9Zxpnc5ZbmqHtwRssSIfUl0xjI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b7KFPg70TaOvovQfbh8GS4P9KhdEMpR/B05yBl48eRif6z/V9UaNf78UC2kvkqRF/xnAyb0oo/xxcSdGOPA5xT1grC/o/wf8ll95wP93yZDotiD29oJoXVbT05Xfm86EYRA0LpMakOUuZU/DIUG+zK+9y44hcn9b8dG883fm9i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0VDmftB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0VDmftB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4CA1F000E9;
	Sun, 26 Jul 2026 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785077680;
	bh=ml5R2Qf2vOlxJvLxgIMoTqIqlRj/ymOVJ0vQBRUQn44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C0VDmftBrivFWcsewpVWwJxX/Kk6YE7tb1oNVwITdSLLdI7jS2EBeU34YXqHeNcfL
	 tfU3ZUNVq6rnLfSGpb39FDBBQ40MwH+lrE0OVSv8vrVw467E5893DjpDRrKAURPeL/
	 YzrplEPh8/mrJI+ANdaSmbvMNfrl3EoxGy+oHkozrGWS41TCS3rh11q92cmgOcoCIV
	 6avpw5o3wAogvyoCfJZnnJrkNu1rQGxryzbhQPTLdNmh2JZEbruxsFTp8CI4GXJ1iq
	 f8ZCBozB2eTSgUMilfvKJ7vVqXnGXtVL0Vz2cVYNI53JMvxdORPM50suQ4jsrS6wDn
	 ggLGR3M9qQ0Iw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Flush external_mdscr_el1 to the pKVM
 hyp vCPU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260726143643.303456-2-fuad.tabba@linux.dev>
References: <20260726143643.303456-1-fuad.tabba@linux.dev>
 <20260726143643.303456-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 14:54:39 +0000
Message-Id: <20260726145440.2D4CA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] The patch breaks pKVM guest isolation by allowing the host to =
arm hardware debug exceptions against a protected VM.

Pre-existing issues:
- [Critical] The hypervisor unconditionally copies trap configurations and =
debug states between the untrusted host and the protected VM on every entry=
 and exit, violating pKVM state isolation and confidentiality.
--

--- Patch [1]: [PATCH 1/2] KVM: arm64: Flush external_mdscr_el1 to the pKVM=
 hyp vCPU ---
commit 11c3469e00f567f8f8ae658ca753847976608a5d
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU

This commit propagates the external_mdscr_el1 register state to the pKVM
hyp vCPU during flush_debug_state(). This ensures that a non-protected guest
runs with the correct hardware flags set by the host.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -108,10 +108,16 @@ static void flush_debug_state(struct pkvm_hyp_vcpu =
*hyp_vcpu)
> =20
>  	hyp_vcpu->vcpu.arch.debug_owner =3D host_vcpu->arch.debug_owner;

[Severity: Critical]
This is a pre-existing issue, but does this allow the host to hijack debug
ownership for a protected VM?

The hypervisor unconditionally copies the untrusted host's debug_owner here
on every guest entry.

Additionally, similar unconditional copying occurs for trap configurations=
=20
and debug states from the host structure:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:flush_hyp_vcpu() {
    ...
    hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
    ...
}

And on guest exit, state is copied back out to the host:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:sync_debug_state() {
    ...
    if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
        host_vcpu->arch.vcpu_debug_state =3D hyp_vcpu->vcpu.arch.vcpu_debug=
_state;
    ...
}

Could this allow the host to reconfigure the protected guest's execution
environment via mdcr_el2, and leak private hardware debug register state=20
back to the untrusted host?

> -	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
> +	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {
>  		hyp_vcpu->vcpu.arch.vcpu_debug_state =3D host_vcpu->arch.vcpu_debug_st=
ate;
> -	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
> +	} else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu)) {
>  		hyp_vcpu->vcpu.arch.external_debug_state =3D host_vcpu->arch.external_=
debug_state;
> +		/*
> +		 * The world switch loads MDSCR_EL1 from external_mdscr_el1
> +		 * (ctxt_mdscr_el1()).
> +		 */
> +		hyp_vcpu->vcpu.arch.external_mdscr_el1 =3D host_vcpu->arch.external_md=
scr_el1;

[Severity: Critical]
Is this a regression that breaks pKVM guest isolation by allowing the host =
to=20
arm hardware debug exceptions against a protected VM?

By copying external_mdscr_el1 from the untrusted host to the EL2 private
state unconditionally, a malicious host could populate external_mdscr_el1
with debug flags (e.g., MDE=3D1 and SS=3D1) prior to KVM_RUN.

The world switch would then load these host-controlled values directly into=
=20
the hardware MDSCR_EL1 register. Under the pKVM threat model, could this=20
allow the host to intercept execution, extract register state, and modify=20
control flow of a protected VM?

> +	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726143643.3034=
56-1-fuad.tabba@linux.dev?part=3D1
