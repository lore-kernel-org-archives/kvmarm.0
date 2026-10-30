Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377570;
	b=auAJPzndR4l3tZalkD6TFYuODreKW9M+q/fjCCqVgPup2r43/4GKZEpTiSMbI83gCD39
	 FBAQTCCraTygiym6cZHBfyGINs8NWQelvj3E3NuwgfeMHLE/xVCZawf8p3EWFEl38tLAc
	 /U/dM6QVC0RRSxkzvsLbchIHAaho+pddkTQzW3cFUUAJokMbWC4M49J75VGPOjHDl1z1a
	 8iiXimeNJLNYINp8gq325JaXgM7StHBTDojmdl9XS8Nz6jG+a4HqpY9XbIr6pDnBuvWsr
	 VVe4G5GtN6n503QccLZSsB1pqJ5pxfWIH3B/NMMkG+ewBzWLx2o2WOxtYHYNAMTpZYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377570;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=BYFL3nmGIe5uqAJ7ySXc+HIMxodwTgtPAlbSO8zHUZc=;
	b=PH9DGC+g4zkHJ5ix/LpkD5qs6CFbJ2oxbRzO+x0Rxnvy2I5MpPXhNOIAPmP5vE+Ayqnt
	 j6zo7Bd797QTx05Jfam/DFrZScCl5c+BqxzpUbpraxTCTtHA/GvnXjXe1Yn4H0Wh7L0Uo
	 7+L79Xab2YcJm85rGV2LZAPjxnK8ku9MBMkikvvd403nhRm25p7DyOFgROyT/ws9CzlBi
	 h7NtfswzebcR3Vb0Njb/e0u+U2asEms/Rrv5jsZHRDRJtrhH2v4yabpGV63EpmmsIBwQR
	 M6uCBHp8VM6Gyh8faj89zoRxiHunCiWsvwBOETQ1oSdhvnfVWpYdzQPgecgsV3BkaKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="fy9ErNh/";
	arc=none smtp.remote-ip=95.215.58.13
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7711F606A31D
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 16:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7711F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fy9ErNh/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=rlRDC0pvLWmlWBgv4+/1L8F8/Elr7ocDXxBBBXsFeHg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793377565; v=1; x=1793982365;
 b=fy9ErNh/RoWVcFBikUbLHGQqJGzM3PFNCuSpActqS66c5rWhn7XKDEMJ3ADPvCYcw7YEQaOO
 +djy2mPrnVHNwcxGevwliPwxowZieuGjaEoCAQnM9NbBZ8AKT7J8l2cGMzmBcqZYEdyFbnRACxk
 q68/BgJOLNkdag4T7VgstDPg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 00c95837bffe26bc;
	Fri, 30 Oct 2026 16:26:05 +0000
X-Mizu-Trace-ID: 00c95837bffe26bc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so7287e87.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 09:26:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzKRuO6Z5yZDUFasxiGb6RpxOxn3QlaFfWlOS3WzB7J6uQqXB9ECc+1jXmB9S6PtOk5A2gEXrw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIHuLTNdDqpEZ15cvoH4YCk2+n4PaO5VZiUERJjt6fvlN15DOEK
	tV41KR8EI9CiLQwYs2BipHCXO2fx10NUq7SgyP1ZjkMgnZyz5P5BNIgcVrZSEaIezh3xnNt2DJn
	/WWyJdAZMioaQHvHTG8UFeQdNqzvF5acMHS/T/jbN
X-Received: by 2002:a05:6512:b1c:b0:5bf:c1d8:b44b with SMTP id
 2adb3069b0e04-5bfd182316amr366664e87.14.1793377560715; Fri, 30 Oct 2026
 09:26:00 -0700 (PDT)
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
 <e6bxdvc4utkt3circfrvzdxhtgdqxz2y736ufhjyxpi6xa5caf@qmtah7wbjx6g>
In-Reply-To: <e6bxdvc4utkt3circfrvzdxhtgdqxz2y736ufhjyxpi6xa5caf@qmtah7wbjx6g>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 30 Oct 2026 16:25:24 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzb0iEK+1jRem506W-oktJp9W+VC0j1hyUm7K2gzAtN3A@mail.gmail.com>
X-Gm-Features: AclHuK9l39S_WZUCSKurnsOngPafKQCMrHrFT3A1BTygQFuis7J1Ue_h0K6N794
Message-ID: <CA+EHjTzb0iEK+1jRem506W-oktJp9W+VC0j1hyUm7K2gzAtN3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: sashiko-bot@kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Oct 2026 at 16:18, Wei-Lin Chang <weilin.chang@arm.com> wrote:
>
> On Fri, Oct 30, 2026 at 12:08:37PM +0000, Fuad Tabba wrote:
> > On Fri, 30 Oct 2026 11:09:43 +0000, sashiko-bot@kernel.org wrote:
> > [...]
> > > Because fault_ipa < BIT_ULL(get_kvm_ipa_limit()) (52) and
> > > fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr)) (48), won't
> > > kvm_handle_guest_abort() fall through to kvm_inject_sea() and inject a
> > > synchronous external abort into the guest instead of calling
> > > kvm_inject_size_fault() to inject a stage-1 level 0 address size fault?
> >
> > Yes. I'll fold this into v2:
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 705f6d84770e9..2a05c7cf8552a 100644
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
> >
> > [...]
> > > Should setup_s1_walk() and setup_s2_walk() use kvm_get_pa_bits(vcpu->kvm)
> > > instead of get_kvm_ipa_limit() so that check_output_size() raises a
> > > stage-1 address size fault for TTBR base addresses and descriptors with
> > > bits [51:48] set rather than letting walk_s1() and __kvm_at_s12() truncate
> > > those bits when passing the address to stage-2?
> >
> > No. setup_s2_walk() passes pa52bit=false, so its output size is
> > already at most 48. setup_s1_walk()'s output size can only exceed 48
> > because, on an LPA2 host, NV guests see stage-1 TGRAN4/TGRAN16 at
> > 52_BIT, which Wei-Lin's patch [1] stops advertising.
>
> Agreed, however would it be more future-proof if they are changed to
> kvm_get_pa_bits() anyway?

Ack. A walk on behalf of the guest should be bounded by the guest's
PARange rather than the host's IPA limit. Will do that in v2.

Thanks!
/fuad
