Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB0619C
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 00:03:17 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1a1fa977667so2864216fac.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 17:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685750596; x=1688342596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HShfi++5J2EhwWlVUZ0n0KinSTI5Empl7iSlltk47U=;
        b=eeOjfV1pYEoTg2ArO6FIFiv7fWCWy+1mL3j3NuPxGHOc5m4ooNise/lzcD4UY18PqL
         K5QHHZkuMXKD5WcArmWJWZyMBS1y3BQ/lyZ4VPcs0OxYDr73Vf8NEQbrqX8Rq/vdJUZF
         yEF/Xig+o1owA2qNIkaIU3TGjDRecNfY5/8GGobfhkE0J6RCH/XBQpxRxiLTAyb+NkN6
         +op/eFn+I/Y/mWAeCDzQJ0p2x9abkWtasVO0OLzHxhJBUUc37KuD0+1I14fyvZAoVIIS
         XjY9IZpJPR7GcgeYV7d83wojijNT7Ct8DwVUX/NFaTB2JsXQCMgCI1T39JkCw80fEgfE
         RJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685750596; x=1688342596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HShfi++5J2EhwWlVUZ0n0KinSTI5Empl7iSlltk47U=;
        b=cmCMhYVm9hFavyHkJ9KzV8W2HGduOt6yXDvh0mGS9utRGffdQZqpYaRxA+Txmbf8EP
         vaw+WHdFHtquyLtGPqAWiRWKhQycW3Ars37DcCQFmBrfg7o1vrPcrTUqy1hv3zN3c2fi
         e131W1x3r7PKmver63PgB2K8u0dj4tw4DVXqHjLx1DURo676JWZyKgAzJ5MOL1wqqb0V
         yQ7LXi4DH7nL/d6BJuFqKVrC9BYmBLW1ZjXSRL4TAPjUz4HyDJilSuQn6NBaAenuHh4u
         CIEF8xFTarCYEbmlGKUA1HWiLlYmYChbgtaKinxmsR5BMaRgrbWT8Z2PPnDwcAkfWJ64
         ngvQ==
X-Gm-Message-State: AC+VfDx1Zn+VN5MW99zC5HFSYnLu5khtnXLKIFWnujqwxYvPVOAA+kvl
	tGvXHi+sDrYK9ht9FSDBfWjE17VsKOmx9wnnXrGdVw==
X-Google-Smtp-Source: ACHHUZ44cUV4eYucBKN3GuJX5jHZxrspSPJYCrKqKuQg9wG/63bUKJcf+/F6/ilanpB2b7C6tSLKXooDC1BXarhaxTs=
X-Received: by 2002:a05:6870:c7a5:b0:18e:8a68:fe41 with SMTP id
 dy37-20020a056870c7a500b0018e8a68fe41mr3285243oab.56.1685750596342; Fri, 02
 Jun 2023 17:03:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602005118.2899664-6-jingzhangos@google.com> <f314beb1e53c1cbdc46909e857a246bab242b153.camel@amazon.com>
In-Reply-To: <f314beb1e53c1cbdc46909e857a246bab242b153.camel@amazon.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 2 Jun 2023 17:03:04 -0700
Message-ID: <CAAdAUtgbNax4s-Yix6ZybhyG0boxE_2O9NQGRQEsSZ-Q2BBqKQ@mail.gmail.com>
Subject: Re: [PATCH v11 5/5] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To: "Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "maz@kernel.org" <maz@kernel.org>, 
	"oupton@google.com" <oupton@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "rananta@google.com" <rananta@google.com>, 
	"tabba@google.com" <tabba@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"reijiw@google.com" <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 2, 2023 at 12:22=E2=80=AFPM Jitindar Singh, Suraj
<surajjs@amazon.com> wrote:
>
> On Fri, 2023-06-02 at 00:51 +0000, Jing Zhang wrote:
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > specific to ID register.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      |   2 +-
> >  arch/arm64/kvm/sys_regs.c           | 291 +++++++++++++++++++-------
> > --
> >  3 files changed, 203 insertions(+), 91 deletions(-)
> >
> >
> > +
> > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                     const struct sys_reg_desc *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
> > kvm_arm_pmu_get_pmuver_limit());
>
> Maybe it's never possible, but does this need a:
> pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit()) ?
Yes, will fix it and also update the comment above it.
>
> > +
> > +       return val;
> >  }
> >
> >
> Thanks
> - Suraj
Thanks,
Jing
