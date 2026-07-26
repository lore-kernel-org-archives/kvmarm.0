Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C263B9
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785077934; cv=none; b=OdIvolOMkCYpBW/XluZw2cGHd+kqv8S4AgQ+G+jIppMn6VI2kW3O6vxOmEh3tfc0drrxy5ZJxcNmXTJnei054fhY2reTLS3j5FUSCcCi3maEBRfSUlS1phzCwW0oYL28v6TalHosCbV6HEukOcpJOlCbQw5ezY0SSwqaJ09wucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785077934; c=relaxed/simple;
	bh=o5ZOFt8icxcpB4FvUherYm9klLewhVqBNx9wjiOnIv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BJRSZI9iLLwHL9sNbIiqICP7l0QF7cQxj0zI2elAYBAjpSMXMKSG4pEY/Ju8NRc9fCDgJ8dgoW1GmrlRm7NR9d7pE1rzhISqQ/jVZeRBT1t60mLVtNFqKL63c7WttBIJgRUVU39ozC6CeCYK2MmDP+jfldYtk0iWUjcD6oGzvu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gaAx79A3; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gaAx79A3"
X-Forwarded-Encrypted: i=1; AHgh+Rr/t1csjXCWo7B40uSb5OzjX64BrO+Ubr4gtj1HwGwiINgKLYMU+6Ztg0EpnPDA9da6+GC8H+k=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785077930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/aTk4jmlnNg1KClaqxP9X6gm3x68hTtCrq/OstIgSfw=;
	b=gaAx79A3sd+LU4QW7e9hf/0Wwl6LdpLa7wIo4/9UpymMZJE4RoUUNx0aXN+fv0CJrakzxL
	UeF80zuH/dwXY8VaIxj8G9ieetbbrrI5zF7EDGl2coM2vRvJ+mdmicXAYw+ndLGioG1QD4
	2D19vEetfrVNpztPWDkFH6yM7QJZZ0o=
X-Gm-Message-State: AOJu0YxfSUkXXh/5CElB62tX/AETDzLbXiH/cLHFvW5VQajTROzefnCp
	OcUUrEwu/cBdfppoizzaxlgjkRbImfNTlYL7Yubq2BwwClCzOpP1VK64IpeZtMFlhjuJKDQei4j
	mCZCPxpBzmErd0Tl4fZMlIpUfuxv0jfP87wVhiG9/
X-Received: by 2002:a05:622a:1f85:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-529a5db6ae5mr25121551cf.2.1785077921474; Sun, 26 Jul 2026
 07:58:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260726143643.303456-1-fuad.tabba@linux.dev> <20260726143643.303456-2-fuad.tabba@linux.dev>
 <20260726145440.2D4CA1F000E9@smtp.kernel.org>
In-Reply-To: <20260726145440.2D4CA1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 26 Jul 2026 15:58:04 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxbNeqZBmQmy2Uvzu6soUWH8b0daoT6oEY1dG2-SH6COA@mail.gmail.com>
X-Gm-Features: AUfX_mzBuzVRlQMIvhRVAd2ElE2NZpEtPxojuWYcyAhDmlxSK2JE607otqXsl6k
Message-ID: <CA+EHjTxbNeqZBmQmy2Uvzu6soUWH8b0daoT6oEY1dG2-SH6COA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Sun, 26 Jul 2026 at 15:54, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Critical] The patch breaks pKVM guest isolation by allowing the host t=
o arm hardware debug exceptions against a protected VM.
>
> Pre-existing issues:
> - [Critical] The hypervisor unconditionally copies trap configurations an=
d debug states between the untrusted host and the protected VM on every ent=
ry and exit, violating pKVM state isolation and confidentiality.

For both issues, protected VM state isolation is WIP upstream [1],
coming soon (fingers crossed).

/fuad

[1] https://lore.kernel.org/all/20260715081238.1891918-1-fuad.tabba@linux.d=
ev/

> --
>
> --- Patch [1]: [PATCH 1/2] KVM: arm64: Flush external_mdscr_el1 to the pK=
VM hyp vCPU ---
> commit 11c3469e00f567f8f8ae658ca753847976608a5d
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
>
> This commit propagates the external_mdscr_el1 register state to the pKVM
> hyp vCPU during flush_debug_state(). This ensures that a non-protected gu=
est
> runs with the correct hardware flags set by the host.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -108,10 +108,16 @@ static void flush_debug_state(struct pkvm_hyp_vcp=
u *hyp_vcpu)
> >
> >       hyp_vcpu->vcpu.arch.debug_owner =3D host_vcpu->arch.debug_owner;
>
> [Severity: Critical]
> This is a pre-existing issue, but does this allow the host to hijack debu=
g
> ownership for a protected VM?
>
> The hypervisor unconditionally copies the untrusted host's debug_owner he=
re
> on every guest entry.
>
> Additionally, similar unconditional copying occurs for trap configuration=
s
> and debug states from the host structure:
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:flush_hyp_vcpu() {
>     ...
>     hyp_vcpu->vcpu.arch.mdcr_el2 =3D host_vcpu->arch.mdcr_el2;
>     ...
> }
>
> And on guest exit, state is copied back out to the host:
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:sync_debug_state() {
>     ...
>     if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
>         host_vcpu->arch.vcpu_debug_state =3D hyp_vcpu->vcpu.arch.vcpu_deb=
ug_state;
>     ...
> }
>
> Could this allow the host to reconfigure the protected guest's execution
> environment via mdcr_el2, and leak private hardware debug register state
> back to the untrusted host?
>
> > -     if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
> > +     if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {
> >               hyp_vcpu->vcpu.arch.vcpu_debug_state =3D host_vcpu->arch.=
vcpu_debug_state;
> > -     else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
> > +     } else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu)) {
> >               hyp_vcpu->vcpu.arch.external_debug_state =3D host_vcpu->a=
rch.external_debug_state;
> > +             /*
> > +              * The world switch loads MDSCR_EL1 from external_mdscr_e=
l1
> > +              * (ctxt_mdscr_el1()).
> > +              */
> > +             hyp_vcpu->vcpu.arch.external_mdscr_el1 =3D host_vcpu->arc=
h.external_mdscr_el1;
>
> [Severity: Critical]
> Is this a regression that breaks pKVM guest isolation by allowing the hos=
t to
> arm hardware debug exceptions against a protected VM?
>
> By copying external_mdscr_el1 from the untrusted host to the EL2 private
> state unconditionally, a malicious host could populate external_mdscr_el1
> with debug flags (e.g., MDE=3D1 and SS=3D1) prior to KVM_RUN.
>
> The world switch would then load these host-controlled values directly in=
to
> the hardware MDSCR_EL1 register. Under the pKVM threat model, could this
> allow the host to intercept execution, extract register state, and modify
> control flow of a protected VM?
>
> > +     }
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726143643.30=
3456-1-fuad.tabba@linux.dev?part=3D1
