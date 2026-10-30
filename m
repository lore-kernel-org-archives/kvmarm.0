Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793363375;
	b=FMrL3p2GFjTdoASUIM4ppbPQkNxfJf4C5omJ6CN8netTodDOtha4ejF/YZaZUnRM9EB/
	 krCvyPIsxkF6FiDHN42T4hYSaeWQTjw3J+GdRNC1ZvoFmGFfreyohMud9b1esTegzQqr2
	 HDblNfprlcFnue2EGixZ89VpRFihoz8qDEYm9/4wzPJZwh6yn7GkwwIIIKyYfPUKSD8e2
	 IgjnhPUxBLGP7njyzvQYsHZV1KGBgHjY6GTV/0fRVbhLSTK1BAa/8TXfQzahKH9Mg5fV9
	 hzeAm2cVhLQ0caLLm7LulrwZo7TgNks83M8tnLWqyXJ+3G93HaiQ2qj5ZKcjGKnEZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793363375;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=O+fMJYNqO1rC4JyvXyWYRoIcA05TzHcyXa930/m//oM=;
	b=0tQYJ7UjV9ic5prnonXZRIgwDoq8MnUWv4r94oHTBBQmNh1BDF046n4cLZzQZ6DAFT7n
	 u3Czmbg3qcZ7KDXV8rc+YU5f24GVUCb0yKfTi+ggaysz652NUO1kEPWAfIlYp1ZBIDUE0
	 BGlBQ/jBAO/bYYL7F8B6zR9BgjUJ/YZ7q8rGJ7ui+xYGMGwBNlfdUUiPhduCA2x0Pi0tv
	 gXJq85NWXcCt6HdQ6Eb6IaoKQ1Gv/nLLHZEXT3mT4kS8rXZ+GdSZ0fJ9mwtdtTjoa5JCd
	 KvIqW7gDgSp7MXCKrSdD900Lhb5lUPmEHk4CRECyVJFyIGPF8dOl8RbNov1MubbJkJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LV51gQtw;
	arc=none smtp.remote-ip=91.218.175.15
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65035606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 12:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65035606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LV51gQtw
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ATotVCKzOa5daMcaBxaevqyz3J/MtuzsEl1bHk96I5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793363372; v=1; x=1793968172;
 b=LV51gQtwPnRic+PpoDXrtfuOiPj+iEUNMDvXqXtkNIPKTv9MBjP1fA+vjM7yGB+NRTkZwM/q
 9o8FU2TE45K5q1J0eqtCCsO8idXaQ6ZVLM/Nzt0BYXFzIWnsYfJ8HNuPjfP1KHjuU7bEiPnadBz
 UkoE8xFo7ZahnDxgE7Bobudc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ac82bf94dcdc4453;
	Fri, 30 Oct 2026 12:29:32 +0000
X-Mizu-Trace-ID: ac82bf94dcdc4453
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so5674e87.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 05:29:27 -0700 (PDT)
X-Gm-Message-State: AFq9FYLNzE7Lq5xNBsoWoBsViQmXvKxoO1KPSiKf7BdCltsJuPPbzHoj
	0xkBn7XToMI3iHiIjXB0PHDV4Cgzhj+wwV+AjHKx69ZHMpjFHyNrjA1RZX18VL6JVqokG3QsGUz
	w51kB+0m2jDhOMT/+5VG2Btz2vv07RdB1rnPZTsne
X-Received: by 2002:ac2:550e:0:b0:5bf:d226:862e with SMTP id
 2adb3069b0e04-5bfd22686c8mr228723e87.2.1793363366455; Fri, 30 Oct 2026
 05:29:26 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261030105139.3543230-1-fuad.tabba@linux.dev>
 <sashiko-outbox-190923@kernel.org> <20261030120837.3752397-1-fuad.tabba@linux.dev>
 <sashiko-outbox-191007@kernel.org>
In-Reply-To: <sashiko-outbox-191007@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 30 Oct 2026 12:28:50 +0000
X-Gmail-Original-Message-ID: <CA+EHjTww0xwZpCNO2O2zd08T_y23KffA1CsMCCZ2cfjtE_rFGA@mail.gmail.com>
X-Gm-Features: AclHuK-DSjx38bmEPygqQZV-47VGAYcpoaYBLREG938yPZ9XUE_xpDZ28v470Ek
Message-ID: <CA+EHjTww0xwZpCNO2O2zd08T_y23KffA1CsMCCZ2cfjtE_rFGA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Oct 2026 at 12:24, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM: arm64: nv: missing base changes in kvm_get_pa_bits() and reply changelog
> --
>
> commit f427a1e42f6e3dddeb1163b0cde7acfb4c92d8ef
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
>
> This commit replaces get_kvm_ipa_limit() with kvm_get_pa_bits(kvm) in
> kvm_handle_guest_abort() when checking whether a translation fault IPA
> exceeds the guest's PARange.
>
> >     KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap
> >
> >     On Fri, 30 Oct 2026 11:09:43 +0000, sashiko-bot@kernel.org wrote:
> >     [...]
> >     > Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
> >     > fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48), won't
> >     > kvm_handle_guest_abort() fall through to kvm_inject_sea() and inject a
> >     > synchronous external abort into the guest instead of calling
> >     > kvm_inject_size_fault() to inject a stage-1 level 0 address size fault?
> >
> >     Yes. I'll fold this into v2:
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1db10d8d6db73..596b2b6ebbdf0 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2440,8 +2440,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >       is_iabt = esr_trap_is_iabt(esr);
> >
> >       if (esr_fsc_is_translation_fault(esr)) {
> > -             /* Beyond sanitised PARange (which is the IPA limit) */
> > -             if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> > +             /* Beyond sanitised PARange */
> > +             if (fault_ipa >= BIT_ULL(kvm_get_pa_bits(kvm))) {
> >                       kvm_inject_size_fault(vcpu);
> >                       return 1;
> >               }
>
> [Severity: Medium]
> Was the incremental reply diff applied directly instead of being folded into
> the base patch?

Patience, young grasshopper... this will be folded into the base
patch, see above.

/fuad
