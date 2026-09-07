Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D1543E083
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776962; cv=none; b=iu3TuZUoof/aju3XjepRzQbWRSkS6SMBWrxatxgqQH3huMMKlgG2jrW7PMHh4MQ9FovwhzPdmP84tENCSmLA++mTHBYtYqUIIJpzbuwGdtSZ6QCD+rd+/kEfKPqJRvPfIzNicPorDHgFtzaljE1sBzFAOYSt9rYCofBQS+n9jcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776962; c=relaxed/simple;
	bh=gr4ntL2ls1kQt9OlB8hZM5ulhfyIRqyK823Iegsl1Sk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NeOn5S6ZJ3yuhg3iiGXGGw6RrSOme8T+f3V5BRGPqJlHxu/Kr6zlAu86AhHy4E3RWc2Nooe1NKOlihNzjRxJWW0Nr7/9OvQSYK5wV1Dxx+VyrIx/nlbYERsnAe0VbWYU0x+MOAOT5HLua6R1aLDZktQTN/OySuqhKD5rbHhthJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sLh7pfDM; arc=none smtp.client-ip=91.218.175.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sLh7pfDM"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gr4ntL2ls1kQt9OlB8hZM5ulhfyIRqyK823Iegsl1Sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788776956; v=1; x=1789381756;
 b=sLh7pfDMa6wElmZIHam4ysbLqEZxMjHo3M3BNPt3VYFHWJPZdo7TvLO6rnGRJx+EduiGQYh/
 Mbeg+7UMzJ35zrC4Vlyv4dM2TDjBndUfkgodtGZhuUJjIksKFnBTXe83rQS5UolfxhnJfLb2U7f
 dlX4n/o7SFC0cPm8aqxhJujY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e229a098b1f85d39;
	Mon, 07 Sep 2026 10:29:16 +0000
X-Mizu-Trace-ID: e229a098b1f85d39
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17358so5813e87.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 03:29:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzBvmvYcuCTrDsFjtmaWXhGgfH8YYfLcYskytDEAzuYHF+8ELTRsppxGiYWz3PEVJlOAzwFdRg=@lists.linux.dev
X-Gm-Message-State: AFuF++lzCo/mt2qJfwC0KKI5VTRyMAZYgM1dzeAWAkm4DMYwBPoumIoP
	tbdEpIHiHIseQ8YKiRdF8DyRgAvW/XsOZ4+rFTvTwv0rPYkRKsznw0/2MHL4PYlMjC+/Sv3cQjz
	eEHiHPy6ziiNTxk5gaaQMVsHM8HWffGY0aw0wmlQG
X-Received: by 2002:a05:6512:3d22:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b74d1f915cmr158049e87.1.1788776950693; Mon, 07 Sep 2026
 03:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260903160819.831518-1-fuad.tabba@linux.dev> <dd850141-ea85-4d94-9793-393f24a2fdc2@arm.com>
In-Reply-To: <dd850141-ea85-4d94-9793-393f24a2fdc2@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 7 Sep 2026 11:28:34 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyuLKYE1UL4XYvq4rxW7fgFNafdTY8H0=Qt6Hnjz3wYvQ@mail.gmail.com>
X-Gm-Features: AcwNN1Wj8Xs--qUJv8B64ImQS5H8o3vx5bKORqTK09jwke8ojoQgldDdImoBrM8
Message-ID: <CA+EHjTyuLKYE1UL4XYvq4rxW7fgFNafdTY8H0=Qt6Hnjz3wYvQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Ben Horgan <ben.horgan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

On Mon, 7 Sept 2026 at 10:12, Ben Horgan <ben.horgan@arm.com> wrote:
...
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index 7404a6e83a930..8863ae99596bc 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -873,6 +873,11 @@ static __always_inline bool system_supports_mpam_hcr(void)
> >       return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
> >  }
> >
> > +static __always_inline bool system_supports_mpam_sysregs(void)
> > +{
> > +     return alternative_has_cap_unlikely(ARM64_MPAM_SYSREGS);
> > +}
>
> The sashiko comments reminded me about the possibility of mismatched systems. I see two cases to
> consider here. One is if the firmware doesn't touch the MPAM system registers and leaves
> MPAM3_EL3.TRAPLOWER set to 1. In which case the user is required to add arm64.nompam to the cmdline
> as the MPAM registers can't be accessed from EL2. The second is if the f/w clears
> MPAM3_EL3.TRAPLOWER, in which case arm64.nompam can't be used without making MPAM1_EL1 etc, shared
> between guests. Perhaps for these mismatched systems we need to unconditionally enable the EL2 traps
> for the cpus that support MPAM and not advertise any support for MPAM. Furthermore, if we, before
> kvm gets involved, unconditionally enable the EL2 traps on systems where MPAM can't be enabled then
> I'm not sure that we need to distinguish system_supports_mpam_sysregs() and system_supports_mpam()
> in the kvm code. What do you think? Does that fit in with the pattern of how cpu features are
> generally handled?

This patch misses that case. check_override reads the CPU's own ID
registers, detect_ftr_has_mpam() the sanitised ones, so
finalise_el2_state clears the traps and neither cap is set.

Not advertising MPAM already happens, since a mismatch lowers the ID
field to 0. The trap default is the missing half, and I agree it
belongs in finalise_el2_state, which already computes whether
MPAM2_EL2 can be touched. KVM then needs only system_supports_mpam(),
and the cap goes.

The one host left is a forced nVHE, where test_has_mpam()'s MPAM1_EL1
read would trap before cpu_enable_mpam(). The respin makes the caps
false when is_hyp_nvhe(), so MPAM is off there rather than the boot
hanging [1].

I'll respin along those lines.

Cheers,
/fuad

[1] https://lore.kernel.org/all/apqrky27mJmUV9UA@willie-the-truck/


>
> Thanks,
>
> Ben
>
>
> > +
> >  static inline bool system_supports_pmuv3(void)
> >  {
> >       return cpus_have_final_cap(ARM64_HAS_PMUV3);
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 17b83a2518a8f..36a27692e5cf7 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
> >       return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
> >  }
> >
> > +static bool
> > +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
> > +{
> > +     /* The registers exist whether or not firmware enabled MPAM. */
> > +     return detect_ftr_has_mpam();
> > +}
> > +
> >  static void
> >  cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
> >  {
> > @@ -3116,6 +3123,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >               .matches = test_has_mpam,
> >               .cpu_enable = cpu_enable_mpam,
> >       },
> > +     {
> > +             .desc = "Memory Partitioning And Monitoring system registers",
> > +             .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +             .capability = ARM64_MPAM_SYSREGS,
> > +             .matches = test_has_mpam_sysregs,
> > +     },
> >       {
> >               .desc = "Memory Partitioning And Monitoring Virtualisation",
> >               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 1ce7130e25490..8941335724f6b 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> >       u64 clr = MPAM2_EL2_EnMPAMSM;
> >       u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> >
> > -     if (!system_supports_mpam())
> > +     if (!system_supports_mpam_sysregs())
> >               return;
> >
> >       /* trap guest access to MPAMIDR_EL1 */
> > @@ -317,7 +317,7 @@ static inline void __deactivate_traps_mpam(void)
> >       u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
> >       u64 set = MPAM2_EL2_EnMPAMSM;
> >
> > -     if (!system_supports_mpam())
> > +     if (!system_supports_mpam_sysregs())
> >               return;
> >
> >       sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
> > diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> > index 2775ba3359cfe..aa5be51385f68 100644
> > --- a/arch/arm64/tools/cpucaps
> > +++ b/arch/arm64/tools/cpucaps
> > @@ -78,6 +78,7 @@ KVM_PROTECTED_MODE
> >  MISMATCHED_CACHE_TYPE
> >  MPAM
> >  MPAM_HCR
> > +MPAM_SYSREGS
> >  MTE
> >  MTE_ASYMM
> >  MTE_FAR
> >
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
>
