Received: from mta0.migadu.com (out-93.mta0.migadu.com [91.218.175.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFDC476065
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258033; cv=none; b=oWixySPICD5dJqFS7TpHzQIgG6rkQ1FfNn7POTsXBD5GDei5r0AFbjaYQn4G8AJQ55jwPmrhifNW9umf6snjLH7m9kEMtWSthrZ8my5dksRdZCmbGqO/8J+JH1igtNEHA/Z2ITJ5xk96L44MAdWdjzIznUsVYhNp8N76NxFhxOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258033; c=relaxed/simple;
	bh=H60r6ANJeggJfSv+YkYOCVRj4yhsoXN8Me4lrvljq/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NrhFxP0QBrS2g0X+yydM7AkqizVqmY8mL39tGPppQpOPyHEvgSlA+ES/UbUp3TFbQCbrcz8hvqqEsfyobCcmrYWn81BQd/pTlJ40N8Er2EaUqkleQWGiwXD3YjFJUbfzkUUOb4jADy80mY1JV3JBxxCpxJnOZvMziCcoFMSuLL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w3Rl4HnT; arc=none smtp.client-ip=91.218.175.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w3Rl4HnT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=H60r6ANJeggJfSv+YkYOCVRj4yhsoXN8Me4lrvljq/k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788258029; v=1; x=1788862829;
 b=w3Rl4HnTjt+ejfGXmtiH0pYxNA8K0r8U5OwEvsrwN8DWSGsQ/IC9xTq2oqRwsWWWT46tNjBz
 yeUCWZrCScyaslVxOH8B9dGjm+zaetYZVCWBR4hLs7NqJvtBZUXYZguSFNB9PAnQb0StZzfOkwH
 d4mpIt/CMNPlEc+xIe/jv4bY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6978a41203612863;
	Tue, 01 Sep 2026 10:20:24 +0000
X-Mizu-Trace-ID: 6978a41203612863
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so6564e87.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 03:20:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByuD9ZUM2LGspz3szQbyIBWIpOiLx37zgxQQVleueowD1/sIWEtZ+HIkfgOCraW+ZH76PPZ/Jg=@lists.linux.dev
X-Gm-Message-State: AFuF++mc6ksE8bh+1T67I8wm6XgGIbrVTAuGLpEbzRrHcR/RxfYriR/i
	PtZsNrIws7OdL3RhRV0ts0Sp0vCmGAVK3PzwWQM02VfNfPtad/qomiBHDwC06xMW84AVdi0W7vm
	RYhnrS1YXLw8Ed5C+mpiWNDC8a+kTenBk39Btv3G0
X-Received: by 2002:a05:6512:3b0d:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b5fefc71e5mr147962e87.0.1788258022394; Tue, 01 Sep 2026
 03:20:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-9-fuad.tabba@linux.dev>
 <20260831210027.E0C331F000E9@smtp.kernel.org>
In-Reply-To: <20260831210027.E0C331F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:19:45 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxCSyadXyk1dFODy=mw9zLJazaTX1EZ3UP_462gzzxEOA@mail.gmail.com>
X-Gm-Features: AcwNN1UsCibrFa9hVHuI7G6kYOpGE1458rdNWHKqrF77E5QClzmW2N960RFDlAk
Message-ID: <CA+EHjTxCSyadXyk1dFODy=mw9zLJazaTX1EZ3UP_462gzzxEOA@mail.gmail.com>
Subject: Re: [PATCH 08/17] KVM: arm64: Implement HVC handling for protected
 guests at EL2
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

And you got me here too, Sashiko. 1/1

On Mon, 31 Aug 2026 at 22:00, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] kvm_handle_pvm_hvc64 incorrectly intercepts ARM_SMCCC_ARCH_FEATU=
RES_FUNC_ID and unconditionally returns NOT_SUPPORTED for Spectre mitigatio=
ns (ARCH_WORKAROUND_1, 2, 3), leaving protected guests vulnerable.
> --
>
> commit 3a993faeabc602db9d44970bfb0c7813227c0324
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Implement HVC handling for protected guests at EL2
>
> This commit extends kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
> SMCCC_ARCH_FEATURES, and the vendor hypervisor call UID at EL2. It also
> adds handlers to forward protected guest HVCs to the host.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index af334318d0a03..0fe11f95e2e26 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>
> [ ... ]
>
> > @@ -1144,8 +1144,37 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu,=
 u64 *exit_code)
> >  {
> >       u64 val[4] =3D { SMCCC_RET_INVALID_PARAMETER };
> >       bool handled =3D true;
> > +     u32 feature;
> > +     uuid_t uuid;
> >
> >       switch (smccc_get_function(vcpu)) {
>
> [ ... ]
>
> > +     case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +             /* SUCCESS only for the architecture calls EL2 implements=
. */
> > +             feature =3D smccc_get_arg1(vcpu);
> > +             switch (feature) {
> > +             case ARM_SMCCC_VERSION_FUNC_ID:
> > +             case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +                     val[0] =3D SMCCC_RET_SUCCESS;
> > +                     break;
> > +             default:
> > +                     val[0] =3D SMCCC_RET_NOT_SUPPORTED;
> > +                     break;
>
> [Severity: High]
> Does this catch-all default case inadvertently disable Spectre mitigation=
s
> in the protected guest kernel?

It does, and it's a regression: the base punts ARCH_FEATURES to the
host, which answers it from the spectre state. v2 will copy that state
over and handle it at EL2.

Thank you,
/fuad



/fuad

>
> When the guest OS boots, it queries ARM_SMCCC_ARCH_FEATURES_FUNC_ID for
> ARM_SMCCC_ARCH_WORKAROUND_1 (and others) to check availability. Because t=
his
> default case blindly returns SMCCC_RET_NOT_SUPPORTED, the guest will assu=
me
> the workarounds are unavailable.
>
> Could this allow an untrusted guest userspace process to exploit transien=
t
> execution attacks (like V2, V4, BHB) and leak guest kernel or other guest
> userspace memory?
>
> > +             }
> > +             break;
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.27=
2420-1-fuad.tabba@linux.dev?part=3D8
