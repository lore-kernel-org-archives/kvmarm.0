Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97977A2C
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 07:01:55 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31c3df710bdso2597062f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 00:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693983713; x=1694588513; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7a/rYlLL01jELhspFfU/LX4lJTwK+IpYr9KpIjgxodg=;
        b=DtByMTssQbhPJbGoWJVbS1IVGYIhYmIeK2vgX2j5MglTd/iPJ76xeKakE82weRS52D
         sFqUOV0sbnsfkP0UI/Z9aT15h0i9Nid5bwQTxh8hunEiS7XAjPAFWR6SYR+nz95IjahE
         1zwC/hQPoIP+NaVKfKQoOyfyY04mHAnYPLDhTng9nny2aSG/qu5T97fCfP7QLe+m0tdI
         f9Lqg6ggD1bWkoJGhpF7vf6huldv+NdUHv57PHoaDT8cINBpXyBmKmP0E+smgTIYfE6m
         ySk4DLb5RiII5VX2iXO+tUt2EkIv3d2240Cqeq0PTZxaVZoSD1bzbdxIH6Wr7SMiik13
         WImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693983713; x=1694588513;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7a/rYlLL01jELhspFfU/LX4lJTwK+IpYr9KpIjgxodg=;
        b=k7O3Sf13Qc4lpGBwvxGLFCwjEvfIakQJ0PGb5QcON8quUoK4ahTXLVALkEVYgJLAfI
         hxuu8N/Ltsk8Dq1/4wk1VmoVQqkrFXADEkKX3nsmu/KgEayjgh6ZJnPN58vQbm+JuNoS
         Z5Qk596yW3A5lUBMQvXfJCRBWY8OqhesEn0C33LGzSEpyKbhKsrg+pK5YzqldJetWtpM
         NrGKNP1TxjK7DweE8/FYzmKN3TbCzMei6uMcttgFVVtRIbcy7k//TGNkvuU3YaQOKjzd
         gOXAsHl9LzR/OPNU4nDFIeeTK7DnyCpkBAN1+IjWYwdL0e5XxF0hLPHmS4NcAPFDye9g
         N9BA==
X-Gm-Message-State: AOJu0YzAa2ARS2/QO3AGY52CVU7nGCX5ACT4H8ba+617pLDfPk8qYmR5
	oK7TEJQn6pxbl82L92ROs0JQ4A==
X-Google-Smtp-Source: AGHT+IH5D+U+nZV7Ok6E7RGjtfz50olmDnpckxh8umsRSqUfH3ZIM1q14NQMvG0C714ykQWhmjyeJw==
X-Received: by 2002:adf:e7d0:0:b0:31c:8151:86a9 with SMTP id e16-20020adfe7d0000000b0031c815186a9mr1273125wrn.67.1693983713483;
        Wed, 06 Sep 2023 00:01:53 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d4805000000b003197c7d08ddsm19530729wrq.71.2023.09.06.00.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 00:01:52 -0700 (PDT)
Date: Wed, 6 Sep 2023 09:01:51 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <xiaobo55x@gmail.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, David Matlack <dmatlack@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Lei Wang <lei4.wang@intel.com>, Like Xu <likexu@tencent.com>, Peter Gonda <pgonda@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, David Woodhouse <dwmw@amazon.co.uk>, 
	Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 2/8] KVM: arm64: selftest: Split arch_timer test code
Message-ID: <20230906-3f0318fa20365f9211998bae@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <c87337cfd7fb135e2efed589360a78c26a402eac.1693659382.git.haibo1.xu@intel.com>
 <20230904-11e853ffe3d8e9cf9ec6079d@orel>
 <CAJve8onwjBQcbVy75qyOF3A51-T0WyBkmeCV_wOZvzaPcrBVFg@mail.gmail.com>
 <CAJve8ok-zZAG7T3t5XD-CtJn47tTE867Xaaw_YHYy1XmUL41rw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8ok-zZAG7T3t5XD-CtJn47tTE867Xaaw_YHYy1XmUL41rw@mail.gmail.com>

On Wed, Sep 06, 2023 at 11:44:26AM +0800, Haibo Xu wrote:
> On Wed, Sep 6, 2023 at 10:14 AM Haibo Xu <xiaobo55x@gmail.com> wrote:
> >
> > On Mon, Sep 4, 2023 at 9:24 PM Andrew Jones <ajones@ventanamicro.com> wrote:
...
> > > > +
> > > > +enum guest_stage {
> > > > +     GUEST_STAGE_VTIMER_CVAL=1,
> > > > +     GUEST_STAGE_VTIMER_TVAL,
> > > > +     GUEST_STAGE_PTIMER_CVAL,
> > > > +     GUEST_STAGE_PTIMER_TVAL,
> > > > +     GUEST_STAGE_MAX,
> > > > +};
> > >
> > > This enum also belongs in aarch64/arch_timer.c
> > >
> >
> > Yes, it should be in aarch64/arch_timer.c
> >
> 
> After moving the above enum definition to aarch64/arch_timer.c, the
> below errors was reported
> while compiling kvm/arch_timer.o
> 
> include/timer_test.h:37:26: error: field ‘guest_stage’ has incomplete type
>    37 |         enum guest_stage guest_stage;
>         |                                        ^~~~~~~~~~~
> 
> Since kvm/arch_timer.c was independent of kvm/aarch64/arch_timer.c
> during OBJ compiling,
> I think it may be not possible to move the enum definition to
> aarch64/arch_timer.c
> 
> If we keep the definition in this header file, we can enclose it with
> #ifdef __aarch64__ for aarch64 only.
>

Let's change struct test_vcpu_shared_data to

 struct test_vcpu_shared_data {
        int nr_iter;
        int guest_stage;
        uint64_t xcnt;
 };

and then let the aarch64 code treat guest_stage as an enum and the riscv
code can completely ignore it (no need to create an unused enum).

Thanks,
drew
