Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95D5C83
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 06:01:11 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b6b98ac328so10429231fa.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 23:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687932069; x=1690524069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g54qKoeGjWz5wLaqSLQFYfEyGEtCRjTvx7zRiV5BneY=;
        b=pRHmeOTKG1duvuJdNrnOYKjshYw/mxtRaKMgxu4E1HMkpMdYmGSzyB4cg3zihRBtPP
         0NmsViUdeBCv8M0Z3VRMzR1C4Ts6OfTwvNR7BZVtnTDzqaklNhPUJYysZ0kyHY110omI
         bhOi2BP90QAPOwLl7+qaczPrpcEWNepM2g+UWzbepApTyOLlhPqcSrSJ80RXe4c3WZyz
         1R4eyC3FfhCWkcQgC1Tp+r2jdZ3fv+qiSWe/IzZGKGH5vN5o9goeoEn9wggd/W83197l
         GEsNLEo+0d68XFI//YuPtaVErM049r73/DGqxY2YaEe+QOh+VwuEixrCFPLlrljSXJq3
         DhEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687932069; x=1690524069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g54qKoeGjWz5wLaqSLQFYfEyGEtCRjTvx7zRiV5BneY=;
        b=kCC5gRArJ6JuyR9jEJrLuC2DGUuszMJRpqd2sOf8ILjMq/1h5X6kMBxSwaoYWLmjbR
         vnlbz2s7GpQO4wTlXS06UKSH11NUqrhV3PlbjGOM5V52ep43qh8HsSYF1a+UXTC+4WrD
         eTra287GAvAzAqalbxDuZL+daNZJkcZRZniVpS9mHQ87cPqvttIPdcpeuUmiTAXpJ4Yo
         ZOo+ixaMQ6UjNJ/ygSAXfMeq/n0INMc1ZgiEqT3+pmVuSZ7gO0kpj4Z/IX6KFn3Tr9xL
         JVdi5WztpOm0eqUclGbaXuH7mimg3VWEnlH2+JGZkYrT0SnDm9/+aRN4eVOl/TJED68T
         0ZxA==
X-Gm-Message-State: AC+VfDzm7CVRO/To2goo5+12eGyiEUTal8Unpplak1aByVyTrtgLkzaW
	mQz4Lq1dXQrJf04Odu1257/bFNvHgOdYLn4Qj/g=
X-Google-Smtp-Source: ACHHUZ7VQCn+YpLvmFmYlf+FOQl2niELacwE4Dcgqiq8I8RkRNKRsyCtVuMehnHMGr1vYCdhl+c2sAGOLh6Bb/4fwYA=
X-Received: by 2002:a05:651c:8f:b0:2b6:a17b:a120 with SMTP id
 15-20020a05651c008f00b002b6a17ba120mr5672641ljq.22.1687932068929; Tue, 27 Jun
 2023 23:01:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1687515463.git.haibo1.xu@intel.com> <47f0502d076c071260a87953cbabadfc85d278cf.1687515463.git.haibo1.xu@intel.com>
 <20230627-adcb173b3ee813e2e16353bd@orel>
In-Reply-To: <20230627-adcb173b3ee813e2e16353bd@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 28 Jun 2023 14:00:57 +0800
Message-ID: <CAJve8onuBoOOOL4yp3wTTsBMqxf4MZL6uUjgMBjUmWsTO61A2g@mail.gmail.com>
Subject: Re: [PATCH v4 09/12] KVM: selftests: Only do get/set tests on present
 blessed list
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Gardon <bgardon@google.com>, 
	David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 27, 2023 at 5:11=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, Jun 23, 2023 at 06:40:11PM +0800, Haibo Xu wrote:
> > Only do the get/set tests on present and blessed registers
> > since we don't know the capabilities of any new ones.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/get-reg-list.c | 29 ++++++++++++++--------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing=
/selftests/kvm/get-reg-list.c
> > index b956ee410996..3beb6b62de0a 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -52,6 +52,10 @@ extern int vcpu_configs_n;
> >       for_each_reg_filtered(i)                                         =
       \
> >               if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
> >
> > +#define for_each_present_blessed_reg(i)                      \
> > +     for ((i) =3D 0; (i) < blessed_n; ++(i))           \
> > +             if (find_reg(reg_list->reg, reg_list->n, blessed_reg[i]))
> > +
> >  static const char *config_name(struct vcpu_reg_list *c)
> >  {
> >       struct vcpu_reg_sublist *s;
> > @@ -189,6 +193,16 @@ static void run_test(struct vcpu_reg_list *c)
> >               return;
> >       }
> >
> > +     for_each_sublist(c, s)
> > +             blessed_n +=3D s->regs_n;
> > +     blessed_reg =3D calloc(blessed_n, sizeof(__u64));
> > +
> > +     n =3D 0;
> > +     for_each_sublist(c, s) {
> > +             for (i =3D 0; i < s->regs_n; ++i)
> > +                     blessed_reg[n++] =3D s->regs[i];
> > +     }
> > +
> >       /*
> >        * We only test that we can get the register and then write back =
the
> >        * same value. Some registers may allow other values to be writte=
n
> > @@ -198,8 +212,11 @@ static void run_test(struct vcpu_reg_list *c)
> >        * be written need to have the other values tested, then we shoul=
d
> >        * create a new set of tests for those in a new independent test
> >        * executable.
> > +      *
> > +      * Only do the get/set tests on present, blessed list registers,
> > +      * since we don't know the capabilities of any new registers.
> >        */
> > -     for_each_reg(i) {
> > +     for_each_present_blessed_reg(i) {
> >               uint8_t addr[2048 / 8];
> >               struct kvm_one_reg reg =3D {
> >                       .id =3D reg_list->reg[i],
> > @@ -242,16 +259,6 @@ static void run_test(struct vcpu_reg_list *c)
> >               }
> >       }
> >
> > -     for_each_sublist(c, s)
> > -             blessed_n +=3D s->regs_n;
> > -     blessed_reg =3D calloc(blessed_n, sizeof(__u64));
> > -
> > -     n =3D 0;
> > -     for_each_sublist(c, s) {
> > -             for (i =3D 0; i < s->regs_n; ++i)
> > -                     blessed_reg[n++] =3D s->regs[i];
> > -     }
> > -
> >       for_each_new_reg(i)
> >               ++new_regs;
> >
> > --
> > 2.34.1
> >
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>
> Thanks,
> drew

Thanks for the review!
