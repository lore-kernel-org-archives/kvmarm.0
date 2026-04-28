Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E284243901E
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777386160; cv=pass; b=exJYwqwCLISfuNcZZBKCa1xjra5FS/2YR06DFOOMMtW1gi2xEEag4b9bEdHKZCSGGCrQtgJRfYk5e+ld8GNzPvu4FnYe4chzGUhLUFmLg/XCAdgIt40NU6bCNk9YQ6e1/RnOY2bLwiHKe864hT/KT+kKNOLnjrjeqFfwrYsXCm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777386160; c=relaxed/simple;
	bh=Lhrvsxcq8dhyXHcIWCHjE9nElfckc1204ADXSFXxPGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DQEKbH837QIjZgZKnheCvjLRuFsnyXB9FR846O3ibTD0pU/rEzPie+eHNM+dgvA0Yu20GZZfRpIZ/1VT7mRXJuDh358LEd1/tGKKgZ8UKssYupDbcE2N+SLOnEQJh7+AyJ3i0IzIMVu301W7Q8taBguNqEKtW2R9n1mibp0Xg68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJe/DPJi; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJe/DPJi"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d6b393d60so71871cf.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 07:22:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777386156; cv=none;
        d=google.com; s=arc-20240605;
        b=TGnZ7j0mSyX2P/Whg615tnpIiSpeFshCUq03T/NwSYMXiBkSgw0oVOnmdfC2i8o7rp
         4Tblq5E0cOXl7/p8UjHanrg1BVmMT1jH9xwv6O/HgBWFohzzF6+AU9MEo0U/Xhh9YwBX
         +eefm8PGuUJuD52QOSbDpTD+gmmnqrSVM+1AhF4GnCbzP1wkGYMvADWmRophD2+QmkIn
         VPkABHo/UwXVXWC5TGJJy+Aji9IiidkF5GZGTEe6ZN6jZ48HYC75aswGuvj9oo2I9csm
         /bkG95O2NevwOAlkcGNrrVPKI+77Fe8RrgG+Hpe1SVlVHHz30ZSAdt0QcY+o2k+v0aIU
         /iSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uXGQeShfh02U1wpxLV3lnM8sw0Cqx8U4IJOmflxKdf4=;
        fh=4Di6zVVUaQ3AXNdTD0B83oybRKZCLiVfFTFLD8CWb64=;
        b=T0xM5oEM9B6qHUGy0jRChHRlnIo+4IYUDXqFTTrBVBvIVABbVpVk/vD5ar5MNI/p4k
         fuse5LYBszKltKzJvMCRn8r5h5zJQzbUdhOVjTPp3Hor4Nw+VvesV9HxnfRw6ahPh8Fv
         TGipPpKJCorRc28qcx9k4KH8OnjuCNb8jhhKt4+8VvPnLEEKMJQ9Li/PyVfxFtZSIxt4
         yf97REwXVZwCFA2TnwFAUrgnTp0xzQ276sFo8zJAeZ2/P1YmqbosUt6pfiH6530F6Mvu
         kGrgwz0ye1y9Awc1mr/4BLOg6lHc4xAal3Hd3ROLtD8gRAXX/fLOENBfpFWujm4gQYfN
         og2Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777386156; x=1777990956; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXGQeShfh02U1wpxLV3lnM8sw0Cqx8U4IJOmflxKdf4=;
        b=iJe/DPJiQVcqhcNr4II++MxIxpvA9Xug4QzMTcB7FONT+bwHpa4oknUVmhV1RH8yWZ
         BjAKLfaB1QrUp88qPC5gUZ5A2+JmS5yzvm1fU4hNPblMZy7hZxC9oQGiivRN8myZCuVc
         NQU1hNL7t8GrxBZbzISSCbtJ9907PpkfeEGwFAsMTkhRCwBnUBdhOWpshks1i6r12vdV
         SHYnbXWFwCOpVAbqtCmedAotlopeAJ/Uqyg7qxtn37nJvJK7w4eBPKkGaL8qb6rsbl6a
         kCYiyr4AigsrkK8jWMjllCbdAoUPbvymxWaVjYuuWuiLusPSj7W1A+ULUv2LetFcCqjf
         JiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777386156; x=1777990956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uXGQeShfh02U1wpxLV3lnM8sw0Cqx8U4IJOmflxKdf4=;
        b=CwR2zGBlLf3S7CnPlEN2zAa+K8PBNUdrmnsGBoePpseFaIEtox9VGEU6OM0BuVLjaL
         bYJW6v9hEtcooMtCkGYqxITecJR602rGi6tCkNJUv63t5OfGvDzPVypFDPKFVp3k2kqA
         T8S7IL5aI4PrqsYADW2xAMlYhOBg0xV/Vxrv8qofhPd2fadw1ViTZTnVCWaLeyru4QPm
         pgjo/bUP0Bq+euoCYnVgqad+3H0acFlKwJD0Y+2uLhrEeRQXCwfBhmzNE6KFBLc6Z0eL
         3nmGksBbt5gRsnZHPMX30A7ySw1qwIciKFGHv6YTcDtI9nEXt8A+Acu2oSqCA1byD5Og
         KcKg==
X-Forwarded-Encrypted: i=1; AFNElJ9MT/yLim9pz7P0fHJiVYsVOHn/5xsodZ2Q3F9VF6iIQp4L8F9DQFO6ZGlJb5bD55UvwkdqUkY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxdHXTNrmmb0BO6XFplk3jOHNTZNZ5PILLROyXEajbypNDuMGA
	UHSO8Ph1okQIBDKFVNpbTHQGP12i74PGPv07KHGUdk6GUjD3SrZN+KyVJ861xjNB5uoVjFDocDq
	IOznbKEEWmfHpJ94yXopqeiZk78E1kMO1IiS1ElUE
X-Gm-Gg: AeBDiet4eEWUDG/C3FZ3M+fN5+4lGleXP8ucIbgRtp2zCXuyWeLVWLOvXjBMPoDAPiZ
	05GKrOZC14varyAqWjSPmoF0xTmZSTlKMrrXEBQCfBnfokP1gcnMnkpWlC7tZdOS9hMTpuxzdug
	dLsBnBHYxhpGA9MLOO2T3O3erICs82D0o+LE7Vm0fOyXQk0blQc4Ve8w63jNdwWFvK8owIkzixk
	Tkp5TSZUZmstaFCrzWSs4C2e8iXj39lYhKHs93xXaiol35X9IHLyfLowMScE7DH4EVrb/aen+nQ
	HBcrF713pR4J7lI6p5Le/7/l0BzOguusSSii653VtBhmWKZFO1w0T7QIV67+sWo=
X-Received: by 2002:a05:622a:14a:b0:50f:be7b:923a with SMTP id
 d75a77b69052e-5100dd824admr13692471cf.9.1777386155175; Tue, 28 Apr 2026
 07:22:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com> <20260428103008.696141-3-tabba@google.com>
 <afC7H1fu4vFzTRTt@willie-the-truck>
In-Reply-To: <afC7H1fu4vFzTRTt@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Apr 2026 15:21:58 +0100
X-Gm-Features: AVHnY4IcRutI69cs69i--7xOx374S2gpBibzxSLDc-9Cnq9PVlW1EEta-ioTBlc
Message-ID: <CA+EHjTy=xvvBN0UyK2bO6J-GuUZnHRwjjdrhkK8Vr+iridWCfg@mail.gmail.com>
Subject: Re: [PATCH 2/8] KVM: arm64: Synchronise HCR_EL2 writes on the guest
 exit path
To: Will Deacon <will@kernel.org>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	vdonnefort@google.com, catalin.marinas@arm.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Tue, 28 Apr 2026 at 14:50, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Apr 28, 2026 at 11:30:02AM +0100, Fuad Tabba wrote:
> > MSR HCR_EL2 is not self-synchronising. Per ARM DDI 0487 M.b K1.2.4
> > (p.K1-16823) and B2.6.1 (p.B2-297), a Context Synchronisation Event
> > is required between an HCR_EL2 write and any subsequent direct
> > register access at the same EL that depends on the new value being
> > in effect.
> >
> > On the entry path, the HCR_EL2 write in __activate_traps is followed
> > by further EL2 sysreg work (MDCR_EL2, CPTR_EL2, VBAR_EL2, and on the
> > speculative-AT errata path SCTLR_EL1/TCR_EL1) before ERET into the
> > guest. None of those intervening accesses depend on the new HCR_EL2
> > value, and ERET is a CSE per ARM DDI 0487 M.b D1.4.4.1 rule RBWCFK
> > (p. D1-7209) conditional on SCTLR_EL2.EOS=3D1, which is set
> > unconditionally by INIT_SCTLR_EL2_MMU_ON (see the prerequisite patch
> > in this series). The requirement is therefore satisfied implicitly
> > on the activate path.
> >
> > The deactivate path is different: after write_sysreg_hcr() in
> > __deactivate_traps() further EL2 sysreg work runs before any natural
> > CSE - on nVHE, __deactivate_cptr_traps and the VBAR_EL2 write; on
> > VHE, the timer context save which reads CNTP_CVAL_EL0 under the new
> > TGE/E2H, and the EL1 sysreg restore. Add an explicit isb() at each
> > of the two deactivate sites.
> >
> > The practical impact today is bounded: HCR_EL2.E2H does not toggle
> > in either path, and the trap bits being changed primarily affect
> > EL1&0 behaviour. But the architectural rule should be honoured.
> > Note that write_sysreg_hcr() itself already issues isb() on the
> > Ampere errata path (sysreg.h), confirming the architectural
> > expectation; the fast path optimises that away.
> >
> > The fix is at the call sites rather than inside write_sysreg_hcr()
> > because the macro has many users (e.g. the activate path, at.c,
> > hardirq.h, ptrauth alternatives) where the immediately-following
> > code either reaches ERET or has another CSE; making the macro emit
> > an unconditional ISB would impose unnecessary cost on those
> > well-formed users.
> >
> > Fixes: 9404673293b0 ("KVM: arm64: timers: Correctly handle TGE flip wit=
h CNTPOFF_EL2")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++++++
> >  arch/arm64/kvm/hyp/vhe/switch.c  | 11 +++++++++++
> >  2 files changed, 22 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe=
/switch.c
> > index 8d1df3d33595..9d7ead5a5503 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -105,6 +105,17 @@ static void __deactivate_traps(struct kvm_vcpu *vc=
pu)
> >       __deactivate_traps_common(vcpu);
> >
> >       write_sysreg_hcr(this_cpu_ptr(&kvm_init_params)->hcr_el2);
> > +     /*
> > +      * MSR HCR_EL2 is not self-synchronising. Per ARM ARM K1.2.4 p.K1=
-16823
> > +      * and B2.6.1 p.B2-297, a Context Synchronisation Event is requir=
ed
> > +      * between an HCR_EL2 write and any subsequent direct register ac=
cess at
> > +      * the same EL that depends on the new value being in effect.
> > +      * The activate_traps path falls through to ERET (a CSE), but the
> > +      * deactivate path still executes further EL2 sysreg work (CPTR/V=
BAR
> > +      * writes below) before any natural CSE, so make the synchronisat=
ion
> > +      * explicit.
> > +      */
> > +     isb();
>
> Sorry, but I don't understand this. Please can you explain why you think
> that CPTR and VBAR have an ordering dependency on HCR_EL2? Preferably,
> the comment would talk about the specific fields that are relevant.

You're right, I misread the spec in my excitement to fix an issue
raised by my new and improved prompts. I went back to the access
pseudocode for the registers being written after write_sysreg_hcr():

- CPTR_EL2/VBAR_EL2 (nVHE) are direct EL2-only registers; their write
semantics at EL2 don't consult HCR_EL2.
- CPACR_EL1/VBAR_EL1/CNTP_CVAL_EL0 (VHE) redirect to their EL2
counterparts on ELIsInHost(EL2) =E2=80=94 i.e., HCR_EL2.E2H =E2=80=94 and E=
2H doesn't
toggle here. TGE isn't a condition for these EL2-level accesses.

So the whole "depends on the new value being in effect" doesn't
actually bite for any of the accesses I cited. I'll drop this patch.
The natural CSEs cover whatever real synchronisation is needed.

Cheers,
/fuad

>
> Will
