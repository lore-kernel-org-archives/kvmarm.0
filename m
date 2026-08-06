Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE82C3261
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786033315; cv=none; b=YL0JWQLx3UnFCgfeeF4kSRC0Dbr7Zy7GAmfrd3pL2Js4JSpufOecZt1WkdGZPNhjjDs9puML+nCrgxd+q43hU8fEFN4Kudz8RBROSxteIGHvEZ8VjWq7JnXszdOAZWNshr9sI+sZQkp69I06yOpVyZU7/2e9SYSGWmM/FRI3G1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786033315; c=relaxed/simple;
	bh=YpAZsBTBHfOWn98a0J8Pkrh9F4NMleu15ho9SrxatPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G51kC2bPtV4QInJ2xZt1enrr5sc3W/NwySstK0Ody9I5iNFReeIoMBV0q2QpFrpET98kUfn4jSF+61EfiGusWh6cN3nimFHwMGkovHCi1fK33QU6UixKRLjh/Z8NbiRVgaxA7kh7z+YnmvfN9GSb2L5pnLO43OQi34HqmYdWIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EVcskk3K; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EVcskk3K"
X-Forwarded-Encrypted: i=1; AHgh+RphjUJC5/sh0xTOtGaxpGbCAejXuXQBH1PN5BTGx7xw/f6Buzzf2qggp+kNigau6DCeHP9QJ4I=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786033309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=86swyc2XR9zidBek0gZHlj2E5P9dzEjsE79qGoC6SXA=;
	b=EVcskk3KsKV/oct4AasEv+o1SMF+KTuEnGoXyNmTdyJ5k1AsF0aqLIlv4CovPgsJtT9a8H
	giBRJH8520DzDm8LWOC9r4zu3bcT6qQkZU3mFadnxXa8XFZPGI/TZuQ/s2PtZB8/NaJzNe
	gNQa5zf4eKYXN8ZxuPMw2gnU0QFLKro=
X-Gm-Message-State: AOJu0YwREUHg3Ss+4NhxFcFta3qqFEgadgv3xnUjGTgCzJo6fDahEMfA
	UOHYWP4dmtwNJfSMeyx4eoi5v+OCr93Mn1wawPOyXRidHPkdkLZWsZcVczO6jw5Zb9QcsqIPh8q
	Y7TUCWj2WUuAkJLZFg3x1EdySFMiDBiubNcr830v0
X-Received: by 2002:a05:622a:e106:20b0:51c:6b7:d3de with SMTP id
 d75a77b69052e-52cfe9f3116mr817471cf.5.1786033280113; Thu, 06 Aug 2026
 09:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806150105.4010701-1-smostafa@google.com> <20260806153135.02E851F000E9@smtp.kernel.org>
In-Reply-To: <20260806153135.02E851F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 17:20:43 +0100
X-Gmail-Original-Message-ID: <CA+EHjTypNs3i8qAqtnyN3wodZDZv79HnN51BobNdMguE9wo58w@mail.gmail.com>
X-Gm-Features: AUfX_myK7gV-2pjnJHRq_JJk4TqwcNWtCy5tCRxJURLuUPc_gdk7PhMNMNhRpAo
Message-ID: <CA+EHjTypNs3i8qAqtnyN3wodZDZv79HnN51BobNdMguE9wo58w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
To: sashiko-reviews@lists.linux.dev
Cc: Mostafa Saleh <smostafa@google.com>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Thu, 6 Aug 2026 at 16:32, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Virtual timer traps are inadvertently disabled for non-protected=
 guests under pKVM on hardware with broken CNTVOFF_EL2, breaking their conf=
igured timer offsets.
>
> Pre-existing issues:
> - [High] `__timer_enable_traps()` uses the global `is_protected_kvm_enabl=
ed()` check and an unsynced `poffset`, unconditionally disabling physical t=
imer traps for non-protected VMs under pKVM.

This only runs on broken-CNTVOFF hardware, where the workaround pins
CNTVOFF_EL2=3D0 for all guests. Dropping the trap changes nothing
observable.


/fuad

> --
>
> --- Patch [1]: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2 ---
> commit d5e405a74fba9d73744f97970471012a4473ce3c
> Author: Mostafa Saleh <smostafa@google.com>
> Subject: KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
>
> The commit fixes a guest kernel panic when launching a protected VM with
> protected hvhe mode on hardware with a broken CNTVOFF_EL2. It achieves
> this by conditionally enabling virtual timer traps only when the guest
> actually has a non-zero virtual timer offset.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nv=
he/timer-sr.c
> > index ff176f4ce7deb..98b6e37ee8fa4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
> [ ... ]
>
> [Severity: High]
> This is a pre-existing issue, but does the physical timer trap logic earl=
ier
> in __timer_enable_traps() improperly grant all guests under pKVM access t=
o
> the physical timer?
>
> Looking at the physical timer access check in this function:
>
>         if (is_protected_kvm_enabled() ||
>             !kern_hyp_va(vcpu->kvm)->arch.timer_data.poffset)
>                 set |=3D CNTHCTL_EL1PCTEN;
>
> The is_protected_kvm_enabled() static key reflects host pKVM support and
> applies to all guests. Additionally, the fallback poffset check evaluates=
 to
> true under pKVM because the EL2-private hyp_vm->kvm is never populated wi=
th
> the host's poffset during init_pkvm_hyp_vm().
>
> Can this cause non-protected VMs on older hardware without CNTPOFF_EL2 to
> bypass physical timer offset emulation and read the raw physical timer
> directly?
>
> > @@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
> >        * Trap the virtual counter/timer if we have a broken cntvoff
> >        * implementation.
> >        */
> > -     if (has_broken_cntvoff())
> > +     if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu=
)))
>
> [Severity: High]
> Could this condition inadvertently disable virtual timer traps for
> non-protected guests under pKVM?
>
> The new check evaluates hyp_timer_get_offset(vcpu_vtimer(vcpu)). However,
> under pKVM (nVHE), the EL2-private pkvm_hyp_vcpu structure's timer_cpu st=
ate
> is never synchronized from the host vCPU during init_pkvm_hyp_vcpu() or
> flush_hyp_vcpu().
>
> Since ctxt->offset.vm_offset remains NULL, hyp_timer_get_offset() will
> unconditionally return 0. Will this allow any non-protected guest with a
> configured virtual timer offset to bypass the trap and incorrectly observ=
e an
> offset of 0?
>
> >               set |=3D CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;
> >
> >       sysreg_clear_set(cnthctl_el2, clr, set);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806150105.40=
10701-1-smostafa@google.com?part=3D1
>
