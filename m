Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB7AA4C
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 01:19:48 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b962535808so27658051fa.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Sep 2023 18:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694135986; x=1694740786; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTau3cyTONyicNIG022ikGJaiNee6rRJkeeHB5/yKBk=;
        b=bwU4Ot3vTqLPxKPOiNK6l+hILh52brTYO6mVFe0TcKpPHClff8qRZRH1N0+CKilZ1g
         19fmu3V5FAq3bu2qOt6B6m5J+jRLaxZKzKbJzeXazZXYuAAS1br4gxq9ZLdGrUodp0La
         uJ5U2NR9PHEEqXcbMjUfxA56fKUXgULJTfDA/qQ7hyi1x4FK8GQ+kSPqWNxA8Oywmlzr
         fWGTUoaiE7uPkk4GD7aqCOO0qbL/iq/1axmqURN5IKHXKVnzF/eylRrvt6Dx/cwR55Iq
         LZ87tmfvz3tie8DFuodpnL22ouG51NATiPSv5zv8WdNUyyTDVP2iXq1LdvJMET7OOo03
         uA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694135986; x=1694740786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTau3cyTONyicNIG022ikGJaiNee6rRJkeeHB5/yKBk=;
        b=Lm81DspYHmfh0HHelGOVBigL9utThfKIgz6jGqOrF1Ss22bNCnnJcFNZ/0dc7ozFp3
         OgG28Xxefm4CtzwyyhhZnam2WSJq1AKF0xzzkyjWhFgIJ6KPb2wnrYrBhxze1lQKiwUi
         QBsRjtmmaxmxR76pxqWz/kRvwThg9Q+IpUPXjt2tR/FKj+r51CEV2AGKwuyWyfP5hmqF
         ipjFa78D6ogbeO2JKYrCFPOUhPQ3UEWGdeoTPMCR/+FRbowAGA18cXYX3W7ARv/IlbKQ
         kUCh0ZoP3dfl8LvQLrcMXUpxq0IAp1A6GRBehJD0aoi9S69CaLHQAq13/L3zGsHIU3lf
         mL5g==
X-Gm-Message-State: AOJu0YzyKGi/JmDaKYHCDsN012tfDZmzgYvly8oqwElOEzbfOsKUX3q9
	LHqm2oaTL8lDfNiwzKLT7/dmm3Wleono8Turq/Y=
X-Google-Smtp-Source: AGHT+IEL308YxAoiG5EsgNnKWxBjdP+kxPSyqo+hXH6H8rBb5eKOkbqrZtAmLlCbAvhCqZW27NcA1wdyNy3dVkq5eys=
X-Received: by 2002:a2e:9090:0:b0:2b6:cdfb:d06a with SMTP id
 l16-20020a2e9090000000b002b6cdfbd06amr631578ljg.22.1694135986206; Thu, 07 Sep
 2023 18:19:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <d2b3c53537fef3f0a2d27d8be663a64123d4bc3c.1693659382.git.haibo1.xu@intel.com>
 <20230904-a69c6a228bf4553cc58bca17@orel> <CAJve8ok03P-t7pTA9mH=5vvkUy4NtxHac_Z_NM88cs55YQZATg@mail.gmail.com>
 <20230907-5d3da2b6dca23bedb31b33a0@orel>
In-Reply-To: <20230907-5d3da2b6dca23bedb31b33a0@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 8 Sep 2023 09:19:32 +0800
Message-ID: <CAJve8om1VibbkHBuG4B+KbKY2eug42wGk9wiYtCYeF-WDY8EgQ@mail.gmail.com>
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

On Fri, Sep 8, 2023 at 3:01=E2=80=AFAM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Sep 07, 2023 at 12:20:29PM +0800, Haibo Xu wrote:
> > On Mon, Sep 4, 2023 at 10:58=E2=80=AFPM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> > > On Sat, Sep 02, 2023 at 08:59:30PM +0800, Haibo Xu wrote:
> > > > Add a KVM selftest to validate the Sstc timer functionality.
> > > > The test was ported from arm64 arch timer test.
> > > >
> > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > ---
> >
> > > > diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools=
/testing/selftests/kvm/riscv/arch_timer.c
> > > > new file mode 100644
> > > > index 000000000000..c50a33c1e4f9
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> > > > @@ -0,0 +1,130 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * arch_timer.c - Tests the riscv64 sstc timer IRQ functionality
> > > > + *
> > > > + * The test validates the sstc timer IRQs using vstimecmp register=
s.
> > > > + * It's ported from the aarch64 arch_timer test.
> > > > + *
> >
> > > guest_run[_stage]() can be shared with aarch64, we just have a single
> > > stage=3D0 for riscv.
> > >
> >
> > Yes, we can. But if we share the guest_run[_stage]() by moving it to
> > kvm/arch_timer.c
> > or kvm/include/timer_test.h, we need to declare extra sub-functions
> > somewhere in a
> > header file(etc. guest_configure_timer_action()).
>
> OK, whatever balances the reduction of duplicate code and avoidance of
> exporting helper functions. BTW, riscv may not need/want all the same
> helper functions as aarch64. Anyway, I guess I'll see how the next versio=
n
> turns out.
>
> >
> > > > +
> > > > +static void guest_code(void)
> > > > +{
> > > > +     uint32_t cpu =3D guest_get_vcpuid();
> > > > +     struct test_vcpu_shared_data *shared_data =3D &vcpu_shared_da=
ta[cpu];
> > > > +
> > > > +     local_irq_disable();
> > > > +     timer_irq_disable();
> > > > +     local_irq_enable();
> > >
> > > I don't think we need to disable all interrupts when disabling the ti=
mer
> > > interrupt.
> > >
> >
> > There is no local_irq_disable() protection during the initial debug
> > phase, but the test always
> > fail with below error messages:
> >
> > Guest assert failed,  vcpu 0; stage; 0; iter: 0
> > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> >   riscv/arch_timer.c:78: config_iter + 1 =3D=3D irq_iter
> >   pid=3D585 tid=3D586 errno=3D4 - Interrupted system call
> >   (stack trace empty)
> >   0x1 !=3D 0x0 (config_iter + 1 !=3D irq_iter)
> >
> > To be frank, I am not quite sure why the local_irq_disable/enable() mat=
ters.
> > One possible reason may be some timer irq was triggered before we set u=
p the
> > timecmp register.
>
> We should ensure we know the exact, expected state of the vcpu before,
> during, and after the test. If a state doesn't match expectations,
> then the test should assert and we should go investigate the test code
> to see if setup/checking is correct. If it is, then we've found a bug
> in KVM that we need to go investigate.
>
> For Sstc, a pending timer interrupt completely depends on stimecmp, so
> we need to watch that closely. Take a look at the attached simple timer
> test I pulled together to illustrate how stimecmp, timer interrupt enable=
,
> and all interrupt enable interact. You may want to use it to help port
> the arch_timer.
>

Thanks for sharing the test codes. Will have an investigation on it.

> Thanks,
> drew
