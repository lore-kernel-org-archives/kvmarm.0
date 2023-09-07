Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDDFEA9
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 04:20:42 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso9016751fa.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 21:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694060440; x=1694665240; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggNyFVV0uCZfL0MPihiu3QYZ5fZKGzQ4fJp4UHCFGEg=;
        b=K1tEi7Q6QAsfeoBMmmE6yo1DFSMv7Yccwu4K8rs42U+05H+cA3VcVotgvNjV8RQ9iv
         19XHJ/1meC2LTbaFyKRXjvTvhG2NzniExaDiM0OiZNqmiOXmzMhT9WnRq60CJfyjBYyk
         T9wxLEgGnwEc1tiSs7DPcubyOg7fp6diEhj6cohI/r+kdmYtwtBUKum0+dhFo/irf0yn
         ylJVLHogJTySPIqvNptapkpjq7RhO4Y2LKliyrVx6SeORg/mm9HI1K1OLG6Bc6z5fr/T
         jNA1jbB2gTSrUvv9fdrA59NI9b+Gj5P1LkJ/2asZLmdxnAvhBbnsWZmi0hYuq27mQGxO
         ZqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694060440; x=1694665240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggNyFVV0uCZfL0MPihiu3QYZ5fZKGzQ4fJp4UHCFGEg=;
        b=cBCoZZr1mCUqWX4QfLMj49lQYyKFjuIXMT+FAPl4cEQpL2p3u9UgTjod/MW6NgruiC
         8Kq8zcfedp7GD1J3URXMmelmxTVsJQhRnppq0HrYNEbQfG0WC/FwI4jRPev+Au2F5HrT
         nEmN993vDOLVSJdgeQ1TNBsUTEU6Z56A/adGVPTzXkWhXKgFhlzs7jr/WRlUhoc8K+zd
         tfAZkbN7T3eNxoXNNmZfjL5YoYivGdr9qvdeDBihX0mu+iReOtzy2jJ/rr/YPH4IuIJJ
         iHiM8upRkfkMIL/0vaeK94fGVvAt0ZSETOVfCEFP8b7HT8HJAm/bH8zR8o9EU/Sa8RxR
         WbqQ==
X-Gm-Message-State: AOJu0YzQq7ypinisLR48W1/BRvY+J4Wnz2rSf9aaO5ZdW9JF6nxbAies
	/iH1N/RWFAqBKQjP0pKY7RFpCvxIbm7JUR5g8lBePJQAIn8=
X-Google-Smtp-Source: AGHT+IEs3wMkr3Qdbzy7z2cdD2QQiWNG7Kmko0xSRTbnllA2oAUwbpm0j15v/Il5Cbh5yzHk8TJ3foGdBVTBUXfKPp0=
X-Received: by 2002:a2e:8708:0:b0:2bb:aaec:abad with SMTP id
 m8-20020a2e8708000000b002bbaaecabadmr3613921lji.30.1694060440378; Wed, 06 Sep
 2023 21:20:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <d2b3c53537fef3f0a2d27d8be663a64123d4bc3c.1693659382.git.haibo1.xu@intel.com>
 <20230904-a69c6a228bf4553cc58bca17@orel>
In-Reply-To: <20230904-a69c6a228bf4553cc58bca17@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 7 Sep 2023 12:20:29 +0800
Message-ID: <CAJve8ok03P-t7pTA9mH=5vvkUy4NtxHac_Z_NM88cs55YQZATg@mail.gmail.com>
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

On Mon, Sep 4, 2023 at 10:58=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, Sep 02, 2023 at 08:59:30PM +0800, Haibo Xu wrote:
> > Add a KVM selftest to validate the Sstc timer functionality.
> > The test was ported from arm64 arch timer test.
> >
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---

> > diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/tes=
ting/selftests/kvm/riscv/arch_timer.c
> > new file mode 100644
> > index 000000000000..c50a33c1e4f9
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
> > @@ -0,0 +1,130 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * arch_timer.c - Tests the riscv64 sstc timer IRQ functionality
> > + *
> > + * The test validates the sstc timer IRQs using vstimecmp registers.
> > + * It's ported from the aarch64 arch_timer test.
> > + *

> guest_run[_stage]() can be shared with aarch64, we just have a single
> stage=3D0 for riscv.
>

Yes, we can. But if we share the guest_run[_stage]() by moving it to
kvm/arch_timer.c
or kvm/include/timer_test.h, we need to declare extra sub-functions
somewhere in a
header file(etc. guest_configure_timer_action()).

> > +
> > +static void guest_code(void)
> > +{
> > +     uint32_t cpu =3D guest_get_vcpuid();
> > +     struct test_vcpu_shared_data *shared_data =3D &vcpu_shared_data[c=
pu];
> > +
> > +     local_irq_disable();
> > +     timer_irq_disable();
> > +     local_irq_enable();
>
> I don't think we need to disable all interrupts when disabling the timer
> interrupt.
>

There is no local_irq_disable() protection during the initial debug
phase, but the test always
fail with below error messages:

Guest assert failed,  vcpu 0; stage; 0; iter: 0
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  riscv/arch_timer.c:78: config_iter + 1 =3D=3D irq_iter
  pid=3D585 tid=3D586 errno=3D4 - Interrupted system call
  (stack trace empty)
  0x1 !=3D 0x0 (config_iter + 1 !=3D irq_iter)

To be frank, I am not quite sure why the local_irq_disable/enable() matters=
.
One possible reason may be some timer irq was triggered before we set up th=
e
timecmp register.

> > +
> > +     guest_run(shared_data);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +void test_vm_cleanup(struct kvm_vm *vm)
> > +{
> > +     kvm_vm_free(vm);
> > +}
> > --
> > 2.34.1
> >
>
> Thanks,
> drew
