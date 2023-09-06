Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03C3A2C
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 06:58:52 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2bcc4347d2dso49975691fa.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Sep 2023 23:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693983531; x=1694588331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mj5YAk9nW64JbldMW8YdC1sTTtqvjYgtps2lTsCHpYo=;
        b=sO1o5NFJJNjG1HQUXFOELe1GgzK1VmXTqNT1BbIvC5wuZNvFzrg/PLo/7SrnqhJcPQ
         +yVzRhxc5MRwgN9MwJgD4bgvAZgdEXn36sUopGgB2pYWXI2GbGV6pF1g7X0cPTsjBf6I
         FCC+hyYiKH4c97JpOkmHZWozHEFIJd/iOl3/4jEvC0tMPNhP7FKEpLOwnuoImI4ycv5a
         /PeBgbhlhwMzp2DvQ54/NzpcPzD9IXB1PUhcM27W4fnaWKUpcr5+3k+nHYX6H3ZTF0W0
         5SqU0GtvEQiRPoM4AFGFXIA4EQlXpW0eS+0gkO+Vo50xDDOXO1/7uD41qlnavANghj2p
         LBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693983531; x=1694588331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mj5YAk9nW64JbldMW8YdC1sTTtqvjYgtps2lTsCHpYo=;
        b=gpwUTKxMZiCTKMCLAX0IEZSFeu7IRqX7h/tGUA+oQ8xAFQ66aS4paas6adchoH1t8E
         LbWCSq0/kBA0DNAf9Zj7lTYvfymc5VLpU8nJ2nWJYDPgGRt01FWtTEQbmS8QpuIX8k6x
         HZL+yWAeXLml3Kogh9oq2Et2chIdoFBv2OOQTMJootvc6zjsTTB78TzNOG6I0SZW2Fm0
         egRUncZBrZf+XXWCl3zJF3G5IL0hTa0ipZncSfgWzIkKXCI2k6dh8SuE96Y68miI0hPv
         /28cSZ7mQhe2JwSa+lIcZDwETWRUzToFAqfj7oDt4yPqrfswk3my2RvjiDOxaTWRynxr
         FjsA==
X-Gm-Message-State: AOJu0YyLJfMcEue6f58KUeo/SxnXGOc7+SMc1Mf4j+7RRvy4e54/Ik+4
	TZkOIiTeYh38pq+PjvYBo5wL1Gza7XO105mVWLUo2Qcg
X-Google-Smtp-Source: AGHT+IE5k4BkYJLpWFCfNUOmKLfmxEPqFdxQE/tVIpYXTE4NnniGY9MqScwe9jg+eEiCfVTG2Yf6yKtZBBdMlQhXqo0=
X-Received: by 2002:a2e:a16f:0:b0:2b9:36d5:729c with SMTP id
 u15-20020a2ea16f000000b002b936d5729cmr1600017ljl.47.1693983530484; Tue, 05
 Sep 2023 23:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <c87337cfd7fb135e2efed589360a78c26a402eac.1693659382.git.haibo1.xu@intel.com>
 <20230904-11e853ffe3d8e9cf9ec6079d@orel> <CAJve8onwjBQcbVy75qyOF3A51-T0WyBkmeCV_wOZvzaPcrBVFg@mail.gmail.com>
 <20230906-6996fca9840e6de7b75692ec@orel>
In-Reply-To: <20230906-6996fca9840e6de7b75692ec@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 14:58:39 +0800
Message-ID: <CAJve8okKAMp5dG-=rwmP+8ndk_jzOvAz5s8uhU8JdMer5WbEng@mail.gmail.com>
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

On Wed, Sep 6, 2023 at 2:41=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Wed, Sep 06, 2023 at 10:14:52AM +0800, Haibo Xu wrote:
> > On Mon, Sep 4, 2023 at 9:24=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > On Sat, Sep 02, 2023 at 08:59:24PM +0800, Haibo Xu wrote:
> ...
> > > > +
> > > > +#include "kvm_util.h"
> > > > +
> > > > +#define NR_VCPUS_DEF            4
> > > > +#define NR_TEST_ITERS_DEF       5
> > > > +#define TIMER_TEST_PERIOD_MS_DEF    10
> > > > +#define TIMER_TEST_ERR_MARGIN_US    100
> > > > +#define TIMER_TEST_MIGRATION_FREQ_MS    2
> > > > +
> > > > +#define msecs_to_usecs(msec)    ((msec) * 1000LL)
> > >
> > > I'd move the above to include/test_util.h
> > >
> >
> > Yes, msecs_to_usecs() macro should be a common API for all the tests.
> >
> > > > +
> > > > +#define GICD_BASE_GPA    0x8000000ULL
> > > > +#define GICR_BASE_GPA    0x80A0000ULL
> > >
> > > These defines belong in aarch64/arch_timer.c
> > >
> >
> > These 2 defines were also defined in other test cases, shall we move th=
em
> > to an aarch64 specific header file? Maybe
> > tools/testing/selftests/kvm/include/aarch64/gic.h?
>
> Even though currently all the aarch64 tests that use the gic are using
> these defines for the base addresses, each test is free to choose whateve=
r
> base addresses it likes. I'd just move them back to aarch64/arch_timer.c
> for now. Consolidating them into shared, default base addresses, if done
> at all, is work for another series.
>

Ok, will move them to aarch64/arch_timer.c for this test.

> Thanks,
> drew
