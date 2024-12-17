Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91211F8666
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458033; cv=none; b=M0l9tYePZFI2bqVQ4jx9495k3LXx7A35PcNVyvO6TAN4EdBpfS/eN5u2nLCeKhTTevoAEReD3uEJIs/vVao+k+fdqgPQDkC21/AhUivZBaYS38XWeNSRwNhQNr22o7hruUnGry0VJCMCYhrVH7Xi5dfNXDghs9g/mVbwwfMfAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458033; c=relaxed/simple;
	bh=qMEOpVhUZv4nNpC1bLeESAEgdrPGdPWMXJFSENL0pU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AxTnyuEUGFFLe1L12ttp+5B9aTyS2BVT6xfXWVUcW0c72VUVrN0ewp7B3FQqY3qFQP1TaL0mV9R1c0TTYD6Z5Aq6P/1EHMHy2q0HssrH4xKuZC/wMWHHVBwzePu6KVYM4Jf9C2w8EC0ruz+M4V6H/NUD73KGzX+X3hrZE4RDlMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhW8hkws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhW8hkws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40955C4CED7
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734458033;
	bh=qMEOpVhUZv4nNpC1bLeESAEgdrPGdPWMXJFSENL0pU8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nhW8hkwsWdpBLejDjXoW685AoyG9HKdiHyF9YMOG65WRicB/Bt9uoQ/viXW+MYXQV
	 qS9UQZxQLW0Awdij9Lt7cU8W6wcwPYpJWvgEp6CZhp2/Zxk0u7I6YuyF3p/RwdDu0u
	 AjCy6Odl2nVsVrh+Mf4c0T1Dbew/GFkQqbJWFarHdc8o4722rxQOBhDzsrGGITJtsy
	 l1vNFinuUWnPREZF/hNy68Q3E5gxZRfDZ/Ha0Ej7Eu8BVCj9Z87t/D2upgOEHWZjeC
	 KKbQh+jL2ioe6qQFVU/eo31BT3zWtKYu4QKKFK0HLd3MnWUnI9wU2Pwfu8zAux0iu7
	 XCsQSm54Z9XFw==
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e3c9ec344efso3847589276.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:53:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVu9Vz5iTnxS7HzqRMr5zAGX4YboTXJJmaMi2GwyNW9mIl9c+WSS9tF+dfLDzRibzhDXpWmCu4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVIzJ2ED48BNw2KBIlg+6DKlulvrxgv52tzylK3JVF4q5/z0gZ
	Jlj6gV8w99Pd06tw0S+xPD51z0ZzLN1OCEDDY4IbWJcg9nrCW7FylFfWNShv/y4xdE5Hb2QOaa9
	vsiYafgb1vp/rEbNbR/PMSaRFfQ==
X-Google-Smtp-Source: AGHT+IF5JQzGU4/LvJbn9lbcAFqYTEIAbJeDA2+0eOZ2ppT8uu/tpW7Im8ML47g3K6HHz8XrComx258Lkz1WjawzG1g=
X-Received: by 2002:a05:6902:1249:b0:e4c:2726:e665 with SMTP id
 3f1490d57ef6-e536069af95mr535992276.25.1734458032442; Tue, 17 Dec 2024
 09:53:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-7-anshuman.khandual@arm.com> <20241216234251.GA629562-robh@kernel.org>
 <c64709f7-e1c6-482e-8665-912be50b15bd@arm.com>
In-Reply-To: <c64709f7-e1c6-482e-8665-912be50b15bd@arm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 17 Dec 2024 11:53:41 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+EO_s49sSK3JQQEDDpcndf4hSpM_gfoe8tZ8=4y3f-tg@mail.gmail.com>
Message-ID: <CAL_Jsq+EO_s49sSK3JQQEDDpcndf4hSpM_gfoe8tZ8=4y3f-tg@mail.gmail.com>
Subject: Re: [PATCH V3 6/7] arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024 at 2:48=E2=80=AFAM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On 12/17/24 05:12, Rob Herring wrote:
> > On Mon, Dec 16, 2024 at 09:38:30AM +0530, Anshuman Khandual wrote:
> >> Fine grained trap control for MDSELR_EL1 register needs to be configur=
ed in
> >> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, bu=
t EL2
> >> is also present.
> >
> > Shouldn't this be "when kernel enters at EL2, and EL3 is also present"?
>
> AFAICT - HDFGRTR2_EL2 and HDFGWTR2_EL2 registers configure traps into EL2=
 when
> accessed from EL1/EL0, provided all required EL3 trap controls are in pla=
ce as
> well. These EL2 based trap configs need to be set before the kernel final=
ly
> enters EL1. Although there is an assumption about EL3 based trap configs =
being
> in place, do we need to mention that in commit message as well. Is not up=
dating
> booting.rst takes care of all EL3 requirements.

My point is just I read 'kernel enters at EL1' as meaning the kernel
booted at EL1 and EL2 is not accessible. Maybe should reworded as
'before/if the kernel drops to EL1'

> > Though it is really "If EL3 set FGTEn2 and the kernel is entered in
> > EL2, then FGT2 must be initialized for MDSELR_EL1."
> >
> > If it was me, I'd just plagarize what was written for prior FGT
> > commits for this code. :)
>
> There are many commits that changed __init_el2_fgt() with different descr=
iption
> formats. Do you have particular one in mind which can be followed here ? =
:)
>
> >
> >> This adds a new helper __init_el2_fgt2() initializing this
> >> new FEAT_FGT2 based fine grained registers.
> >
> > "This adds" is the same as saying "This patch/commit adds" which is wel=
l
> > documented to avoid. Use imperative "Add a new helper...". Though it is
> > clear from the diff that is what you are doing...
>
> Sure, will fix it.
>
> >
> >
> >> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoin=
t and
> >> watchpoint exceptions when kernel enters at EL1, but EL2 is also prese=
nt.
> >> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
> >>
> >> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirem=
ents.
> >>
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will@kernel.org>
> >> Cc: Jonathan Corbet <corbet@lwn.net>
> >> Cc: Marc Zyngier <maz@kernel.org>
> >> Cc: Oliver Upton <oliver.upton@linux.dev>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: linux-doc@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: kvmarm@lists.linux.dev
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >> Changes in V3:
> >>
> >> - Dropped MDCR_EL3.TDA boot requirement from documentation (separate s=
eries)
> >> - Dropped MDCR_EL2_EBWE definition as MDCR_EL2 is now defined in tools=
 sysreg
> >>
> >> https://lore.kernel.org/all/20241211065425.1106683-1-anshuman.khandual=
@arm.com/
> >>
> >>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
> >>  arch/arm64/include/asm/el2_setup.h   | 26 ++++++++++++++++++++++++++
> >>  2 files changed, 44 insertions(+)
> >>
> >> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch=
/arm64/booting.rst
> >> index 3278fb4bf219..054cfe1cad18 100644
> >> --- a/Documentation/arch/arm64/booting.rst
> >> +++ b/Documentation/arch/arm64/booting.rst
> >> @@ -288,6 +288,12 @@ Before jumping into the kernel, the following con=
ditions must be met:
> >>
> >>      - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
> >>
> >> +  For CPUs with the Fine Grained Traps (FEAT_FGT2) extension present:
> >> +
> >> +  - If EL3 is present and the kernel is entered at EL2:
> >> +
> >> +    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
> >> +
> >>    For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
> >>
> >>    - If EL3 is present and the kernel is entered at EL2:
> >> @@ -322,6 +328,18 @@ Before jumping into the kernel, the following con=
ditions must be met:
> >>      - ZCR_EL2.LEN must be initialised to the same value for all CPUs =
the
> >>        kernel will execute on.
> >>
> >> +  For CPUs with FEAT_Debugv8p9 extension present:
> >> +
> >> +  - If the kernel is entered at EL1 and EL2 is present:
> >> +
> >> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> >> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> >> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
> >> +
> >> +  - If EL3 is present:
> >> +
> >> +    - MDCR_EL3.EBWE (bit 43) must be initialized to 0b1
> >> +
> >>    For CPUs with the Scalable Matrix Extension (FEAT_SME):
> >>
> >>    - If EL3 is present:
> >> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/a=
sm/el2_setup.h
> >> index 4ef52d7245bb..2fbfe27d38b5 100644
> >> --- a/arch/arm64/include/asm/el2_setup.h
> >> +++ b/arch/arm64/include/asm/el2_setup.h
> >> @@ -105,6 +105,13 @@
> >>                                              // to own it.
> >>
> >>  .Lskip_trace_\@:
> >> +    mrs     x1, id_aa64dfr0_el1
> >> +    ubfx    x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> >> +    cmp     x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> >> +    b.lt    .Lskip_dbg_v8p9_\@
> >> +
> >> +    orr     x2, x2, #MDCR_EL2_EBWE
> >> +.Lskip_dbg_v8p9_\@:
> >>      msr     mdcr_el2, x2                    // Configure debug traps
> >>  .endm
> >>
> >> @@ -244,6 +251,24 @@
> >>  .Lskip_gcs_\@:
> >>  .endm
> >>
> >> +.macro __init_el2_fgt2
> >> +    mrs     x1, id_aa64mmfr0_el1
> >> +    ubfx    x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> >> +    cmp     x1, #ID_AA64MMFR0_EL1_FGT_FGT2
> >
> > We already read this field in __init_el2_fgt, shouldn't we leverage tha=
t
> > and move all this there rather than read the feature reg twice.
>
> Should not __init_el2_fgt2() remain separate to contain all future FEAT_F=
GT2
> related trap enabled/disable checks ? OTOH reading id_aa64mmfr0_el1 regis=
ter
> should improve some performance as well.

That's the tradeoff. I'll defer to others whether a single id register
read here is preferred.

> >> +    b.lt    .Lskip_fgt2_\@
> >> +
> >> +    mrs     x1, id_aa64dfr0_el1
> >> +    ubfx    x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> >> +    cmp     x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> >> +    b.lt    .Lskip_dbg_v8p9_\@
> >> +
> >> +    mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1
> >> +    msr_s   SYS_HDFGWTR2_EL2, x0
> >> +    msr_s   SYS_HDFGRTR2_EL2, x0
> >
> > If Debug v8.9 is not present, but FGT2 is, shouldn't we write 0 to thes=
e
> > registers? That is what we do for FGT.
>
> Just to summerize what's being done in __init_el2_fgt()
>
> .macro __init_el2_fgt
>         ...............
>         mov     x0, xzr
>         ...............
> .Lskip_spe_fgt_\@:
>         msr_s   SYS_HDFGRTR_EL2, x0
>         msr_s   SYS_HDFGWTR_EL2, x0
>         ...............
> .Lset_fgt_\@:
>         msr_s   SYS_HFGRTR_EL2, x0
>         msr_s   SYS_HFGWTR_EL2, x0
>         msr_s   SYS_HFGITR_EL2, xzr
>         ...............
>
> If the relevant features are not present and their traps need not be hand=
led,
> all FEAT_FGT based trap control registers (SYS_HDFGRTR_EL2, SYS_HDFGWTR_E=
L2,
> SYS_HFGRTR_EL2, SYS_HFGWTR_EL2 and SYS_HFGITR_EL2) get cleared. Hence sam=
e
> needs to be done for all FEAT_FGT2 register as well. Fair enough, somethi=
ng
> like the following makes sense ?
>
> .macro __init_el2_fgt2
>         mrs     x1, id_aa64mmfr0_el1
>         ubfx    x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
>         cmp     x1, #ID_AA64MMFR0_EL1_FGT_FGT2
>         b.lt    .Lskip_fgt2_\@
>
>         mov     x0, xzr
>         mrs     x1, id_aa64dfr0_el1
>         ubfx    x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
>         cmp     x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
>         b.lt    .Lskip_dbg_v8p9_\@
>
>         orr     x0, x0, #HDFGWTR2_EL2_nMDSELR_EL1
> .Lskip_dbg_v8p9_\@:
>         msr_s   SYS_HDFGWTR2_EL2, x0
>         msr_s   SYS_HDFGRTR2_EL2, x0
>         msr_s   SYS_HFGRTR2_EL2, xzr
>         msr_s   SYS_HFGWTR2_EL2, xzr
>         msr_s   SYS_HFGITR2_EL2, xzr
> .Lskip_fgt2_\@:
> .endm

Looks good.

>
> Just wondering - following the same principle if clearing these FEAT_FGT2=
 trap
> registers would make sense in itself, even without FEAT_Debugv8p9 enablem=
ent ?

Probably and there's a Jira for it. Though there was some debate about
whether anything was needed before any users. But that's kind of a
mute point anyway because I need it for PMU now, too.

> Something like the commit
>
> commit 31c00d2aeaa2da89361f5b64a64ca831433be5fc
> Author: Mark Brown <broonie@kernel.org>
> Date:   Thu Apr 1 19:09:40 2021 +0100
>
>     arm64: Disable fine grained traps on boot
>
>     The arm64 FEAT_FGT extension introduces a set of traps to EL2 for acc=
esses
>     to small sets of registers and instructions from EL1 and EL0.  Curren=
tly
>     Linux makes no use of this feature, ensure that it is not active at b=
oot by
>     disabling the traps during EL2 setup.
>
>
> >
> >
> > I just realized I forgot to add FGT2 setup for the PMUv3.9 features I
> > already added in 6.12 and 6.13. So this really needs to land sooner
> > rather than later to add that.
> Not sure if I got this correctly. Are you suggesting to carve out __init_=
el2_fgt2()
> from the series and post separately with PMUv3.9 requirements and fallbac=
k clearing
> for all FEAT_FGT2 trap config registers as mentioned above ?

Yes, as it needs to not be held up by any of the debug issues Mark
raised. Also, it may need to be back ported to 6.12. And for that we'd
want the PMU parts, but not the Debug. I still have to figure out what
needs to be done on the KVM side.

Rob
