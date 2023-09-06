Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA45EC2
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 09:01:14 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2bd0d135ca3so57734761fa.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 02:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693990872; x=1694595672; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGBcwbFPU/bGY4zSYaJ1ifEXL5+F/gokQ5BwkUen+qA=;
        b=oxGSvQtW4ec0+ziumVXwlkafiuG4zBL5j+xy4xPp4wpEo4JLZ2SuKTrO3Ih+Wr8WuK
         6hTzy9Ip+ulGPhnKyRfu4NDVn338XmvN0UKCw2EJsr3BaOYjFs60f9+cbWIxWaeWcYDU
         LniLJjwTTbxnWPHyPloiNcemmJSG76aRoDQL9WEqIz+QpghjMuZT4aRrwW/0l+vIgNSX
         7S7Cmy2zxrtKaHaDeFUY3fSB7Pu4tWqGbjNRLWYOtExOf/BUw1GZ4MZaIZ4wodq7WQ76
         uYq2UoUVzrqKX1BEcS0H0D9exYWYkRvTTIkwtMdGYdnzWVuUviIO13Tjiz+lK9fYB2Ra
         KDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693990872; x=1694595672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGBcwbFPU/bGY4zSYaJ1ifEXL5+F/gokQ5BwkUen+qA=;
        b=YJdL57Y2c+bZPxSPhElXIxXlSUs/tiDSTTEZuoyK7v1jetbAeRmnUbPj/CE7Kw2ytT
         804aUoZkRgyDJ+ag6FxJMruC2nNhvrsvhDF2ej2+o7Jvdle7OMn2tlqJAll94Aw4FuG3
         oTWUk284AOyFGFPc9OSXk8I0DWQkjcgTtZAPKEhFI0SA1wiiN8s48mUT3jLlYGtiCzAA
         Hq72PvK+AwpVeY2oNM7nsSEVB+AwuCge+Y2nLwN4NICT8s7DGMYLauDys2cxGDEKYbm9
         bDickUlR0HTxEWwYuriw3GYNvV18QSvpIAShmTFBRsT9D9nlo/HJSY9Tk9CcN7vUgEqG
         L6/g==
X-Gm-Message-State: AOJu0Yzr6O10ICCHuZ87mFvj8PNTctxDVVMjXpeaVHtr02c4R2Q9eMf9
	gq0nI+jFfX6vyK9iBaHfUvG0mcNai8wbl8/TPFw=
X-Google-Smtp-Source: AGHT+IFEeFdFaGaTLQBI687uLLemZurhXtmM5YDshrwY9B8n6Jsr0TB3y/S2wMiOM3uqcoQPE8js1WezowOosvA6ZU4=
X-Received: by 2002:a2e:3603:0:b0:2b9:e53f:e201 with SMTP id
 d3-20020a2e3603000000b002b9e53fe201mr1722458lja.31.1693990872213; Wed, 06 Sep
 2023 02:01:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <c87337cfd7fb135e2efed589360a78c26a402eac.1693659382.git.haibo1.xu@intel.com>
 <20230904-11e853ffe3d8e9cf9ec6079d@orel> <CAJve8onwjBQcbVy75qyOF3A51-T0WyBkmeCV_wOZvzaPcrBVFg@mail.gmail.com>
 <CAJve8ok-zZAG7T3t5XD-CtJn47tTE867Xaaw_YHYy1XmUL41rw@mail.gmail.com> <20230906-3f0318fa20365f9211998bae@orel>
In-Reply-To: <20230906-3f0318fa20365f9211998bae@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 17:01:00 +0800
Message-ID: <CAJve8omsTQB04dZDCtK=0Fz3ExTuPFVQKvxz9Du5WyfqOwnuSg@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] KVM: arm64: selftest: Split arch_timer test code
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Greentime Hu <greentime.hu@sifive.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Lei Wang <lei4.wang@intel.com>, Like Xu <likexu@tencent.com>, 
	Peter Gonda <pgonda@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 6, 2023 at 3:01=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Wed, Sep 06, 2023 at 11:44:26AM +0800, Haibo Xu wrote:
> > On Wed, Sep 6, 2023 at 10:14=E2=80=AFAM Haibo Xu <xiaobo55x@gmail.com> =
wrote:
> > >
> > > On Mon, Sep 4, 2023 at 9:24=E2=80=AFPM Andrew Jones <ajones@ventanami=
cro.com> wrote:
> ...
> > > > > +
> > > > > +enum guest_stage {
> > > > > +     GUEST_STAGE_VTIMER_CVAL=3D1,
> > > > > +     GUEST_STAGE_VTIMER_TVAL,
> > > > > +     GUEST_STAGE_PTIMER_CVAL,
> > > > > +     GUEST_STAGE_PTIMER_TVAL,
> > > > > +     GUEST_STAGE_MAX,
> > > > > +};
> > > >
> > > > This enum also belongs in aarch64/arch_timer.c
> > > >
> > >
> > > Yes, it should be in aarch64/arch_timer.c
> > >
> >
> > After moving the above enum definition to aarch64/arch_timer.c, the
> > below errors was reported
> > while compiling kvm/arch_timer.o
> >
> > include/timer_test.h:37:26: error: field =E2=80=98guest_stage=E2=80=99 =
has incomplete type
> >    37 |         enum guest_stage guest_stage;
> >         |                                        ^~~~~~~~~~~
> >
> > Since kvm/arch_timer.c was independent of kvm/aarch64/arch_timer.c
> > during OBJ compiling,
> > I think it may be not possible to move the enum definition to
> > aarch64/arch_timer.c
> >
> > If we keep the definition in this header file, we can enclose it with
> > #ifdef __aarch64__ for aarch64 only.
> >
>
> Let's change struct test_vcpu_shared_data to
>
>  struct test_vcpu_shared_data {
>         int nr_iter;
>         int guest_stage;
>         uint64_t xcnt;
>  };
>
> and then let the aarch64 code treat guest_stage as an enum and the riscv
> code can completely ignore it (no need to create an unused enum).
>

Good idea! Will fix it in v3.

> Thanks,
> drew
