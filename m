Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB037627
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 02:36:22 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2be5e2a3c86so32423851fa.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Sep 2023 19:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694140581; x=1694745381; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SloDScCMx4oSLnsTG5Eji59Tx/5anpswbLezsyOC20=;
        b=NHoCMtnGdhe1LdllJIYsQH8zF/r+3TsRKzmEUf/WJBaSM3hgXUBQ26gOnLS3MOLSOA
         Ij4TLCOTofXbz7VItgv+YQ5jFweVBIJX3V3cAGKSHwN52y1NKutJOpFWvcIzZqTO1Cak
         eFbWhtCDF1zVUGM/4SnbRqlbdBSSvvFC5dXaU1MYCucTt5wXGMiI9gd/C8rS3MYg9p14
         HtY9Y+XfLv3z2rmAXfu3TIelE71JpoWjH2ry4eQWCiy1OeZqZEwP4mh0HLzQq5JS/MI9
         BbMQ0u0C8ky99ZxXKU22Db03Kflt3ITqmGQ85YVmKtTEHBo419uQzri962TqzIAfTBU2
         1vSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694140581; x=1694745381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3SloDScCMx4oSLnsTG5Eji59Tx/5anpswbLezsyOC20=;
        b=BxXg1KydHkgvLajJwD16eoD3FR0xB7v9hKxyHZ6Z3u5VXw5cLMlHjyJmPIcjOWGXNs
         zUMhrFA5pXnpp42e2t88IIbdlu3t1kpPMmAUKJun8JRMMx/+S+Eiei/xFsnokB4IfqoF
         tcOlyvhLND35n9bsFF+Jw2tUEY6zfVY7rbYE8tpFwwUEh1zgECS8wWVcofTyr1sDjDpi
         UzeU/DgKJshEkWCpdN5AWVuLrBsMP94Hu/3HKe0AATxBYM0wmvaR2ou7QU5qOs1MJWpj
         bzqqUfFQFrawAPnolSOODToKVH0zpupy0pxeri/Y2argIVXqMIkmgK6Z8B+IT0PAA7Y6
         xK/Q==
X-Gm-Message-State: AOJu0YxsZKiQNwtjGdqczVy1002WQkToZNrLDG+sdX9LiG6TZxA4be/c
	4uJmm4+GapvbFR/wolghsQRu2iknj2bYk/xItFw=
X-Google-Smtp-Source: AGHT+IGPnaH1hB1XaAWpoSpVu9fE6H6lAvlQx/cBu/gZNMgWAzXLEKoti/amvId+mp2eIUJ6sUeQ6zygE6V1VF/TXK8=
X-Received: by 2002:a2e:800f:0:b0:2b9:601d:2c0 with SMTP id
 j15-20020a2e800f000000b002b9601d02c0mr285241ljg.25.1694140580444; Thu, 07 Sep
 2023 19:36:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <d2b3c53537fef3f0a2d27d8be663a64123d4bc3c.1693659382.git.haibo1.xu@intel.com>
 <20230904-a69c6a228bf4553cc58bca17@orel> <CAJve8ok03P-t7pTA9mH=5vvkUy4NtxHac_Z_NM88cs55YQZATg@mail.gmail.com>
 <20230907-5d3da2b6dca23bedb31b33a0@orel> <CAJve8om1VibbkHBuG4B+KbKY2eug42wGk9wiYtCYeF-WDY8EgQ@mail.gmail.com>
In-Reply-To: <CAJve8om1VibbkHBuG4B+KbKY2eug42wGk9wiYtCYeF-WDY8EgQ@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 8 Sep 2023 10:36:09 +0800
Message-ID: <CAJve8o=_09khYSEapJfb2xiqzCLdM6FbR=Q9gAawZ6nhHDUZCQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: riscv: selftests: Add sstc timer test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Greentime Hu <greentime.hu@sifive.com>, 
	wchen <waylingii@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Matlack <dmatlack@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Peter Gonda <pgonda@google.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Like Xu <likexu@tencent.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, zhang songyi <zhang.songyi@zte.com.cn>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 8, 2023 at 9:19=E2=80=AFAM Haibo Xu <xiaobo55x@gmail.com> wrote=
:
>
> On Fri, Sep 8, 2023 at 3:01=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
> >
> > On Thu, Sep 07, 2023 at 12:20:29PM +0800, Haibo Xu wrote:
> > > On Mon, Sep 4, 2023 at 10:58=E2=80=AFPM Andrew Jones <ajones@ventanam=
icro.com> wrote:
> > > >
> > > > On Sat, Sep 02, 2023 at 08:59:30PM +0800, Haibo Xu wrote:
> > > > > Add a KVM selftest to validate the Sstc timer functionality.
> > > > > The test was ported from arm64 arch timer test.
> > > > >
> > > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > > ---
> > >
> > > > > diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/too=
ls/testing/selftests/kvm/riscv/arch_timer.c
> > > > > new file mode 100644
> > > > > index 000000000000..c50a33c1e4f9
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> > > > > @@ -0,0 +1,130 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > +/*
> > > > > + * arch_timer.c - Tests the riscv64 sstc timer IRQ functionality
> > > > > + *
> > > > > + * The test validates the sstc timer IRQs using vstimecmp regist=
ers.
> > > > > + * It's ported from the aarch64 arch_timer test.

> > >
> > > > > +
> > > > > +static void guest_code(void)
> > > > > +{
> > > > > +     uint32_t cpu =3D guest_get_vcpuid();
> > > > > +     struct test_vcpu_shared_data *shared_data =3D &vcpu_shared_=
data[cpu];
> > > > > +
> > > > > +     local_irq_disable();
> > > > > +     timer_irq_disable();
> > > > > +     local_irq_enable();
> > > >
> > > > I don't think we need to disable all interrupts when disabling the =
timer
> > > > interrupt.
> > > >
> > >
> > > There is no local_irq_disable() protection during the initial debug
> > > phase, but the test always
> > > fail with below error messages:
> > >
> > > Guest assert failed,  vcpu 0; stage; 0; iter: 0
> > > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> > >   riscv/arch_timer.c:78: config_iter + 1 =3D=3D irq_iter
> > >   pid=3D585 tid=3D586 errno=3D4 - Interrupted system call
> > >   (stack trace empty)
> > >   0x1 !=3D 0x0 (config_iter + 1 !=3D irq_iter)
> > >
> > > To be frank, I am not quite sure why the local_irq_disable/enable() m=
atters.
> > > One possible reason may be some timer irq was triggered before we set=
 up the
> > > timecmp register.
> >
> > We should ensure we know the exact, expected state of the vcpu before,
> > during, and after the test. If a state doesn't match expectations,
> > then the test should assert and we should go investigate the test code
> > to see if setup/checking is correct. If it is, then we've found a bug
> > in KVM that we need to go investigate.
> >
> > For Sstc, a pending timer interrupt completely depends on stimecmp, so
> > we need to watch that closely. Take a look at the attached simple timer
> > test I pulled together to illustrate how stimecmp, timer interrupt enab=
le,
> > and all interrupt enable interact. You may want to use it to help port
> > the arch_timer.
> >
>
> Thanks for sharing the test codes. Will have an investigation on it.
>

Hi Andrew,

You are right. The local_irq_disable() was not needed here.
It's my fault that I also removed the local_irq_enable() when trying
your suggestion.

Thanks for your review and help on this patch set!

Regards,
Haibo

> > Thanks,
> > drew
