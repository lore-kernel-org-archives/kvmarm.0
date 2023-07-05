Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC54415497
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 19:30:20 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6b74e2d8c98so6210212a34.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 12:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688585420; x=1691177420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqX3jBV18tBGLew6n5pqhYJHUJdONqGoznuxLJ4bNJo=;
        b=IVPIjuZHat1iuuLvfvSos5iJX/2lmZUo1bmup6rR3K4cb/WS+SVxblPkvKuOdBsjhX
         x60erhF6Wu+2y7bkpcfRoVcfPC94ZOnrpEKh+Of84S1xMYzIYjIklmliHCDcccn5vEGx
         FBb7Df+4BnMn3M67TdKUtR+KhOzdVOsO9wviYUSyMXNY+EZiNOyNawI1TU5wD74UjsKM
         /pBR0auEmosa8w+TlKpDnctX2Lmx04C9ImNP0UITF0yxwoUzUR/u6fWNvtRe6xHDsYCU
         Tj3bmdbw+866QJoXWlWzSm0haJ+/NLGDm0na0dyh3yDeU8uOjFJcAgZde6r5fYWJhnSa
         2N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688585420; x=1691177420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqX3jBV18tBGLew6n5pqhYJHUJdONqGoznuxLJ4bNJo=;
        b=G8jDWNDS8ef9JVWPSYIqRq7iLCj/o92EmfzEr5N4oxW6RWzrFGDKmMUDrapvuYJtVO
         5iNElvieBMctagVQqoXf1eYNrqXg9x8V/VWKfAgYxifsQkE5gL+8uuorGgkMe6yAJk1A
         5XD1PyLTkEUpD0ZZfSAbkUzrg8doMVTtahaP6Y/iAPQeTqnhZIbn5xzWjO59MNX042uX
         TDc/RleMGqot3H8aysg1CDmvTQLczXc/ADVVNOfNsBLoA5g4rWJiFcUrGl2InV7rBqLh
         BWmxuv+biijuTHEOeIHRoK745dqVfX0br8ZxkKLRuiWlinfPTpI+7Qg74Ayxgd+OYdds
         ejIQ==
X-Gm-Message-State: ABy/qLbIMFaa9Ah2wCcLZ2lezkGKpa/X7nWYcvqBW1yZBpd+8O8hYViO
	X5lWRYzhuU8abflR2pJ99CxiZtUF8x7mWwrpIvxMyw==
X-Google-Smtp-Source: ACHHUZ70Gtekf0SGSHttYmgSXUjbdIozILLI5Av5ouRVJwniR1+XidKzHjGrqewMdl4gdeplc7dVaD7g6tf/cwg3JSk=
X-Received: by 2002:a05:6870:b623:b0:1b0:91aa:fcfa with SMTP id
 cm35-20020a056870b62300b001b091aafcfamr21013186oab.55.1688585419752; Wed, 05
 Jul 2023 12:30:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-4-jingzhangos@google.com> <ZJnBdtkzeQuPqQGO@linux.dev>
In-Reply-To: <ZJnBdtkzeQuPqQGO@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 5 Jul 2023 12:30:08 -0700
Message-ID: <CAAdAUthHzVZUhymUv6wnwaRXC+88GRyQd6AGtgj8zLOAz_=W6A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Mon, Jun 26, 2023 at 9:49=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Jun 07, 2023 at 07:45:53PM +0000, Jing Zhang wrote:
> > Return an error if userspace tries to set SVE field of the register
> > to a value that conflicts with SVE configuration for the guest.
> > SIMD/FP/SVE fields of the requested value are validated according to
> > Arm ARM.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
> >  1 file changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 3964a85a89fe..8f3ad9c12b27 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1509,9 +1509,36 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct=
 kvm_vcpu *vcpu,
> >
> >       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> >
> > +     if (!system_supports_sve())
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
> > +
>
> If the system doesn't support SVE, wouldn't the sanitised system-wide
> value hide the feature as well? A few lines up we already mask this
> field based on whether or not the vCPU has the feature, which is
> actually meaningful.
Yes, you are right. This change is not needed actually.
>
> >       return val;
> >  }
> >
> > +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                            const struct sys_reg_desc *rd,
> > +                            u64 val)
> > +{
> > +     int fp, simd;
> > +     bool has_sve =3D id_aa64pfr0_sve(val);
> > +
> > +     simd =3D cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_=
AdvSIMD_SHIFT);
> > +     fp =3D cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP=
_SHIFT);
> > +     /* AdvSIMD field must have the same value as FP field */
> > +     if (simd !=3D fp)
> > +             return -EINVAL;
> > +
> > +     /* fp must be supported when sve is supported */
> > +     if (has_sve && (fp < 0))
> > +             return -EINVAL;
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_I=
NIT */
> > +     if (vcpu_has_sve(vcpu) ^ has_sve)
> > +             return -EPERM;
>
> Same comment here on cross-field plumbing.
Will fix.
>
> --
> Thanks,
> Oliver

Thanks,
Jing
