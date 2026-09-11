Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419344AB88
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 11:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126037; cv=none; b=sx4bBAYCuWrrBw1WRnIZHrwcltPNC7FoR4n2lKmMkB5v9BmEt/ZiNg1zoW1djZ82nI5dNto7yLxnJZpm23KdXsmkMSCRskxhKEC0StHwgJNQ1mc/wShcxlsML4V0wSpIxNT9zzXW8fhAIZhpade2CnuwjNXyOCk7JyUqwb6CHVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126037; c=relaxed/simple;
	bh=vpyKjLRGOj2W4xkPI8SZ0I4va0+wufP6r6XYtBNdJWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8HfpH7yXyYBzV1VJr2xM/r6raWLg2n0Ad6pQE7w3mhiSNHYlRwymxjEaoD7wEtA9hbmGZJrYKlr8KPu9Ha6t8Ra1vkUiLnehDiu590J/gaDujDPV/ekttx+YCU3QWQiaTuTGChLuvyqCV16+AIxj1ZhUGKiNEFi1AKGIGmcH8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HwQd73d9; arc=none smtp.client-ip=91.218.175.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HwQd73d9"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vpyKjLRGOj2W4xkPI8SZ0I4va0+wufP6r6XYtBNdJWk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789126026; v=1; x=1789730826;
 b=HwQd73d9gNG+IPelh22CAqFI7kPeH74dM10dHc01tFA6OINvm1PsIUs5g+NJ/D2ycGkssTo/
 e487Zp3baGZ5QfJeqrsDKj7Ud62Pr0MV+BWLRN9Kle0ii+1lDONGkHTkObFTH3TCOhmsi2eLqqN
 +rDQzUWlX/404IihLESWsVJQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a6a0ab3f8a6adf7c;
	Fri, 11 Sep 2026 11:27:06 +0000
X-Mizu-Trace-ID: a6a0ab3f8a6adf7c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so3961e87.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 04:27:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx96B/T82BxCkUjP2ZX2M7Uaii7ULbapAT+XgyDqScDoaIay+EsdwZvUC48NSTF8enSMhLAF8I=@lists.linux.dev
X-Gm-Message-State: AFuF++ks3m8guOo3+cLiljaOE1/Yd3jSg59LITsAcIbUO2xnK3yKtUv4
	grqUHJ3OlM+j1qsPp5wzUoFC/pqT8erwwE7FxGkv4CiJhC2YRkaybffFmnDVzs/iuIZSa65WZ1p
	M7MgIl5JOKbACEo+fZRKA5l7nDbi1iZWDdId38o0L
X-Received: by 2002:a05:6512:405a:b0:5b8:9e63:dfb9 with SMTP id
 2adb3069b0e04-5b8a053c7f3mr116427e87.0.1789126021546; Fri, 11 Sep 2026
 04:27:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260911104715.307500-1-fuad.tabba@linux.dev> <20260911110152.D086C1F000FF@smtp.kernel.org>
In-Reply-To: <20260911110152.D086C1F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 11 Sep 2026 12:26:25 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz_1kDi156qfVA__U7tKoRcHFN6nqxToGoHTgo+iCXnMg@mail.gmail.com>
X-Gm-Features: AcwNN1XK5NZmQtmA_G87LkzjfrWgk16FdSVJre-x2uudy8mjxi7_qgOu0YA8lNk
Message-ID: <CA+EHjTz_1kDi156qfVA__U7tKoRcHFN6nqxToGoHTgo+iCXnMg@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Sept 2026 at 12:02, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] KVM fails to trap guest MPAM accesses if the host boots with the=
 `arm64.nompam` kernel parameter on MPAM-capable hardware, potentially allo=
wing the guest to bypass virtualization isolation.

Right, and it's documented rather than fixed: [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260908145622.2828319-1-fuad.tabba@linux.d=
ev/

> --
>
> commit b4685c49d4f8e9f9eb2e612a24ecf71fcf533869
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
>
> This commit changes how KVM determines whether to trap guest MPAM accesse=
s.
> It relies on a per-CPU flag set based on the ID registers rather than usi=
ng
> the system-wide system_supports_mpam() check.
>
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 8b080804bc90b..fde75a63cf045 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2281,9 +2281,16 @@ static void cpu_set_hyp_vector(void)
> >
> >  static void cpu_hyp_init_context(void)
> >  {
> > +     u64 pfr0 =3D __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> > +     u64 pfr1 =3D __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> > +
>
> [Severity: High]
> This is a pre-existing issue, but does reading the software-overridden ID
> register value here in cpu_hyp_init_context() allow the arm64.nompam kern=
el
> parameter to falsely report no MPAM hardware to the KVM trap initializati=
on
> logic?
>
> By using __read_sysreg_by_encoding(), the software override for arm64.nom=
pam
> forces the MPAM fields to 0. This causes the HAS_MPAM flag to evaluate to
> false even when physical MPAM hardware is present.
>
> >       kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
> >       kvm_init_host_debug_data();
> >
> > +     /* The traps take effect without MPAMEN, which ARM64_MPAM require=
s. */
> > +     if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1))
> > +             host_data_set_flag(HAS_MPAM);
> >
> >       if (!is_kernel_in_hyp_mode())
> >               cpu_init_hyp_mode();
>
> [ ... ]
>
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index 1ce7130e25490..2cb611e2bd69b 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct =
kvm_vcpu *vcpu)
> >       u64 clr =3D MPAM2_EL2_EnMPAMSM;
> >       u64 set =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> >
> > -     if (!system_supports_mpam())
> > +     if (!host_data_test_flag(HAS_MPAM))
> >               return;
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does skipping the guest MP=
AM
> trap activation in __activate_traps_mpam() based on the overridden HAS_MP=
AM
> flag leave the hardware trap state at its UNKNOWN reset value?
>
> When the host boots with the arm64.nompam parameter, HAS_MPAM is false. T=
his
> causes KVM to skip setting the MPAM2_EL2 trap bits (TRAPMPAM0EL1 and
> TRAPMPAM1EL1) during guest entry. Additionally, the EL2 initialization in
> finalise_el2_state() also skips initializing MPAM2_EL2 when the ID regist=
ers
> are overridden.
>
> Because MPAM2_EL2 is never initialized by the host, it retains its
> architecturally UNKNOWN reset value. If its trap bits happen to reset to =
0,
> a guest can execute MPAM instructions without trapping to KVM. This would
> allow the guest to bypass virtualization isolation and directly manipulat=
e
> memory bandwidth and cache partitioning across the system, potentially
> causing resource starvation or side-channel information leaks.
>
> Does this patch codify and reinforce gating the trap initialization on th=
e
> overridden software ID registers rather than the physical hardware
> capabilities?
>
> >
> >       /* trap guest access to MPAMIDR_EL1 */
> > -     if (system_supports_mpam_hcr()) {
> > +     if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
> >               write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_=
EL2);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911104715.30=
7500-1-fuad.tabba@linux.dev?part=3D1
