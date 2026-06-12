Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C86175A7D
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250851; cv=pass; b=nf4He0tYBMtcG8mACYgBeR+56e61Rls/layUziPsoiMrO0v/jnBOhUpz0oQsKck1u7woVH6obpytplwCq4ZIIzQHagyPsrLoROYymiC7tAiZZ2+NDSAkbIkDdB9sUCcV9i+OECD6LNXDhS61WILnt4eTB5HR4KXU/zUnLS1EXT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250851; c=relaxed/simple;
	bh=SBpatKOzZkFx1HiX+Oq7s4rs5V2EfRMOnTtOPNRtVfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jUwRsq1Q9N9pa524RhLyr7gZTFOzEUET02tN81ophakelCiVU6EThVq+Fhe6FHOGbSES9F7DSAD5jE5LDagWzhkJBjhfOYF+D4CEuDNALsAqseVXqb2Ic7P8TxazTWOBNj6MLBCOUcXPDwMdQAlYaGRlyqgsEkxlHelGResywpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MLPVVCR6; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MLPVVCR6"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5177d1ff061so293251cf.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 00:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781250848; cv=none;
        d=google.com; s=arc-20240605;
        b=C4zcuxVRExUtb78DE6h+PbnMPyj07FujRS1YarL3RA+QFugRKJaFFeHeE7fb/vEb0/
         4wDiLPgm12/qaCt4iyD8QwgmfQjB+/chtCzrA8OVka2ElmtsDc9dTuOwpX9dDPySxVOX
         FD072SAhrgRmCIYO/yhK9C85GHbLeCTXfrlnzs1IdGMthjDodhkfs8G8mNiTTt2Megwa
         pX7Cfa58OdRzuWOnn+krWyUURbZaotbItcBXYTHdfsZi/uj8CIwZTA2xVhzCseeeyLGm
         XkwkRoq3HJk1tBaq0raf3zOuanT6ZZs/0wKOSnJYM6dfyZNA9BC4yDD4ONPYNpo+ny+L
         ivIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JoaYAmvGpmBwzI+pMZvdHO/dT94EXz13THilzJ6ncCg=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=M4ScVoXKYjJxNdku/rQvJWbd++e9dsMJVWVJIHa5qpnFjMm/2+OcyU4HPiu4FDLUYK
         ZkpZydn0UGqPNj7fbxx3dh01InD26HJ0WxxWYb5JCHJ6VNAmfx+37Bp9FRza6LY9QH19
         If4MJ/jF5NRs6JCKvebSxI90PnbRnxXtmNoYQcEZnB/WUpBIVn4FwZaq9BZhTCh2ga/K
         JK36vz51M4aAi4mX8mkPwYIZv9LvkFsacsVw/j6hJcot6Pj481C4BasFFBN9uqjE8hiI
         ViDZDKsn3Q+J5bVrf6wXYeAP6TZcTsRbhSQHs2Wz93JYsA/CCoiWy/6Mm2NkxBc5/cpH
         laCg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781250848; x=1781855648; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JoaYAmvGpmBwzI+pMZvdHO/dT94EXz13THilzJ6ncCg=;
        b=MLPVVCR6pAeFYrgNnkFR5hNBb5L5tEcjS5q81R0nj1Cm/syHgsmKvSJ+9ZaB2zjTav
         JzR5kvL826HI5RQl0+ttkwrUMV3/bJb5tGXPyy58OMJkhbRirLeZUQ6DMfTAUJQO0nuU
         7JJab43qJZxTOwf9w+8hjcTFWl83wJkybaEpa9fjxsixRPj4fYGPWoBWDwhi7SraV6KF
         gx37otPlmuqp/hZDYrDhUYfqlwNsX4n0Hf7fpEt1KU3UCD8Bp0wxci5MH96FnwFOx9JH
         NAZrZ8TCtTocmQ0MLptcvjUDorSNzDskd7K23c2N4f6kqSkIUg+8delId60zgqHtE7DR
         qRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781250848; x=1781855648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JoaYAmvGpmBwzI+pMZvdHO/dT94EXz13THilzJ6ncCg=;
        b=ajgtWIBO+Dz6pMKJ4ZDmBrpwNaeFjLitSwLOEvHWlfTTL3PvBgt4fj550MyT7OX7W4
         +/+DIcwVIGlVk2dBk0H7KjTwhCkz+5bYOtCXhOA/qKQwhzf5kWxmh/2NSXu37nxMrugd
         Yui2jQSPWup6pJkRaw2EsRWbpDWJj7B14HZadIMZWA3aIvKzi5zLltBB1qLroWKYrv9p
         AeWLDzVntZbBWtM/yz4HCFr0gY5mLEruuz1WRQWQpO75rnJNWx47PKO25IW5FKwz3Cr/
         HxJEx0p7JOHvK/6/ObUkAaRChMpBgLLyPw6ZFzr/lASLMKJP0XBAsqbps33eoBcyfq6x
         UNUw==
X-Gm-Message-State: AOJu0YxkMehvn5sUMbEyYpBV25B/HOJB3nUGjmxScB7TPUnKYIEulgBR
	5CcK+ZjlxvfLuX1FCCJX3W5q1U8nLhtqAJhXI+oqTVIjgmUw8416IsrswaCg5sj/iy3H+0eiUy6
	H5/exPgBSJYad8l1nYJByXKfXDBj/lEkyBujafrLe
X-Gm-Gg: Acq92OHnhKXnI12KUbjbTXQzBuNYEY4nnFpq6dT3slZekY8HWo2DxI5K3jeV5wqb7Ez
	nZYTbd15whTiua7vCbdlKwgt/k9v2AgOMrsxvH8ecrNkdvzxPQdwkIGTkzn4e8l/WEq9MD63BZq
	LMm0E+QOUXLXsTfafyZbQSH9jma2oW9wprZyMnygf+MajhKFePHwpKJqqd3GE4Dq6K3dbrTG4n4
	shvOFD8BtzkMGdMBpPs9yCikc/A08eNIsuzJCIKhqOoLOXmk5Gk5ifvM/07P0ONPocCr5P5fTCm
	BlJiybQt34h5Ldtl0To=
X-Received: by 2002:a05:622a:1a9f:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-517fb03d852mr7102021cf.10.1781250847822; Fri, 12 Jun 2026
 00:54:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-6-tabba@google.com> <20260612071712.2DD1E1F000E9@smtp.kernel.org>
In-Reply-To: <20260612071712.2DD1E1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 08:53:30 +0100
X-Gm-Features: AVVi8CeOXky3l-B0jQq_Uks69NaPyyRL_5PelFcshFJpDpmwLIhQ2PoZcoSXYlg
Message-ID: <CA+EHjTxBWG79osczbR_NX7LtMKsDSjuL0s5+DUwmW6NdDnfA7Q@mail.gmail.com>
Subject: Re: [PATCH v1 05/11] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello again,

On Fri, 12 Jun 2026 at 08:17, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Hardware/Memory State Desynchronization in EL2 sysreg accessors
> --
>
> commit 69d4753f169931c6c1990fc9118b5a6cffe54554
> Author: tabba@google.com <tabba@google.com>
>
> KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
>
> The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> shared with hyp code. Add _vcpu_read_sys_reg()/_vcpu_write_sys_reg()
> inlines in kvm_emulate.h that dispatch on is_nvhe_hyp_code() to the
> host- or hyp-side accessor. A follow-up series uses this to share that
> emulation code at EL2.
>
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/=
asm/kvm_emulate.h
> > index 5bf3d7e1d92c7..aed9fc0b717b1 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff=
(struct kvm_vcpu *vcpu)
> >       return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> >  }
> >
> > +static inline u64 _vcpu_read_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_=
sysreg reg)
> > +{
> > +     if (!is_nvhe_hyp_code())
> > +             return vcpu_read_sys_reg(vcpu, reg);
> > +
> > +     return __vcpu_sys_reg(vcpu, reg);
> > +}
> > +
> > +static inline void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val,=
 enum vcpu_sysreg reg)
> > +{
> > +     if (!is_nvhe_hyp_code())
> > +             vcpu_write_sys_reg(vcpu, val, reg);
> > +     else
> > +             __vcpu_assign_sys_reg(vcpu, reg, val);
> > +}
>
> [Severity: High]
> If these accessors are called from nVHE EL2 code during guest exit handli=
ng,
> will they read and write from the in-memory sys_regs array instead of the
> active hardware registers?
>
> Since the guest's system registers remain live in the CPU hardware during=
 the
> run loop:
>
>     do {
>         __guest_enter(vcpu);
>     } while (fixup_guest_exit(vcpu, &exit_code));
>
> and aren't saved to memory until __sysreg_save_state_nvhe() runs after th=
e
> loop terminates, it seems _vcpu_read_sys_reg() might read stale values fr=
om
> memory.
>
> Likewise, would _vcpu_write_sys_reg() updates write to memory without upd=
ating
> the active hardware registers before the guest is re-entered?
>
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >       if (vcpu_mode_is_32bit(vcpu)) {
> > @@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu =
*vcpu)
> >
> >               r =3D vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
> >
> > -             sctlr =3D vcpu_read_sys_reg(vcpu, r);
> > +             sctlr =3D _vcpu_read_sys_reg(vcpu, r);
> >               sctlr |=3D SCTLR_ELx_EE;
> > -             vcpu_write_sys_reg(vcpu, sctlr, r);
> > +             _vcpu_write_sys_reg(vcpu, sctlr, r);
> >       }
> >  }
>
> [Severity: High]
> When kvm_vcpu_set_be() is used at EL2, could this result in the guest bei=
ng
> re-entered without the new endianness taking effect?
>
> Whether updating the 32-bit pstate via *vcpu_cpsr() or the 64-bit SCTLR v=
ia
> _vcpu_write_sys_reg(), the modifications appear to happen to the in-memor=
y
> state rather than the active hardware registers (like SPSR_EL2 or SCTLR_E=
L1).
>
> If so, wouldn't the updates be lost and unobserved by the guest upon re-e=
ntry?
>
> >
> > @@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *=
vcpu)
> >       r =3D is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
> >       bit =3D vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
> >
> > -     return vcpu_read_sys_reg(vcpu, r) & bit;
> > +     return _vcpu_read_sys_reg(vcpu, r) & bit;
> >  }
>
> [Severity: High]
> Could this result in kvm_vcpu_is_be() reading an incorrect endianness sta=
te
> at EL2?
>
> If the guest modifies SCTLR_EL1 and traps to EL2, calling this helper wou=
ld
> use _vcpu_read_sys_reg() which accesses the stale memory array instead of=
 the
> current hardware register state.

This patch is no-functional-change: _vcpu_{read,write}_sys_reg() only
diverge from
vcpu_{read,write}_sys_reg() when is_nvhe_hyp_code() is true, and at this co=
mmit
neither kvm_vcpu_set_be() nor kvm_vcpu_is_be() has an nVHE-EL2 caller. The =
nVHE
branch uses __vcpu_sys_reg() because vcpu_read_sys_reg() is host-only;
under nVHE
that host accessor reads from memory anyway (locate_register() returns
SR_LOC_MEMORY when SYSREGS_ON_CPU is clear, enforced by the
WARN_ON_ONCE(!has_vhe() && loc !=3D SR_LOC_MEMORY); the HW path uses VHE-on=
ly
SYS_*_EL12). So the EL2 branch reads exactly what the host accessor
would, via the
same accessor all existing EL2 sysreg emulation already uses
(exception.c does the
same dispatch keyed on has_vhe()).

Cheers,
/fuad
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.75=
5562-1-tabba@google.com?part=3D5
