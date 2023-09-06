Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659CA362
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 07:13:36 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-4fe15bfb1adso5521880e87.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 00:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693984414; x=1694589214; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aTsez1MtzhhlmQ/mCF+KXbnv+lrjtNHxtrQ8tWacSro=;
        b=YxNsQxYk1UZMJEU/xnMV/Kxg5JTMyTrb1UcQU/AjTnXjtzkER005LY5l547oOt+e8U
         D1CInkV0A98g96WGd1VMsy11r6vucfIk+OcQ1BFq/l3GWXh0zIXt0swV1ngi17LEr96R
         Yc2vdXzyk5x+6jbiUhiG3v8dWQCcwRbX6UKp78GSBjRkj4cbN7CGZDvVC7po/yt+y60U
         m2I5UCmd8AY8kOFfbQbnVS2OGuhtz5rV8q/UkZwRFxm6Pkw9xAQgsFZquqVpKFvIw8RV
         wMulL0utfOtj6YaEYd55InlSqIC6SYbJ0Bsoph07pKBbk0QFFGTL9ixa86D0ag3HE6BC
         NVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693984414; x=1694589214;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aTsez1MtzhhlmQ/mCF+KXbnv+lrjtNHxtrQ8tWacSro=;
        b=R9rFof/05GowAnDLqxOr/sJcy5MtntJg6boeytCpIb1s/DQJ/2xaficbK8QdyhfuYP
         SxpOELpH59Buh7lxJopAeyr6qzqPHWjH1pM8f8v1/7voE5RCZMOqYrhSMGry8wp1UCKm
         g44TyD7jLky2NSlF/PBDhxQPGnxpy33FS2fIqlEjXP87+oBTI33aaaapSMwUEjvKchx5
         ru4iPbX7Pr5IMFfUKa2cPkQj6EFhKOVq7OZNR0Y1Ot8uUiyeBbIAT4u4tNrYYQ8MrdzK
         PfMrSBS4sO3u/K8dspmB07EzPFzGFs7ElYCiRcU8ErBJEJFslgxKtFFgA7uHNGci2pQy
         HcJQ==
X-Gm-Message-State: AOJu0YxDflrNJtkP+6wbgmG7oEmyNtXb/QAZMZ7EeRhMsrAANOz3oXoW
	P/EbcCPNUIuVgy2Mrl8dze9iww==
X-Google-Smtp-Source: AGHT+IFUfuCxBleSioCsaDTw5kdKiT/iGJ6erAaiBayaHgVuc5Zh2EjkSrt7wvrXGoCM5I5C4sZAoA==
X-Received: by 2002:a2e:9254:0:b0:2b9:55c9:c228 with SMTP id v20-20020a2e9254000000b002b955c9c228mr1549101ljg.27.1693984413992;
        Wed, 06 Sep 2023 00:13:33 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id e2-20020a05600c218200b003fef5402d2dsm22237218wme.8.2023.09.06.00.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 00:13:33 -0700 (PDT)
Date: Wed, 6 Sep 2023 09:13:32 +0200
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
	wchen <waylingii@gmail.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Lei Wang <lei4.wang@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Peter Gonda <pgonda@google.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Like Xu <likexu@tencent.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, 
	zhang songyi <zhang.songyi@zte.com.cn>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 3/8] tools: riscv: Add header file csr.h
Message-ID: <20230906-c35fdc0e07d2cc0f9cb93203@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <8173daae52720dbdabbd88a5d412f653e6706de1.1693659382.git.haibo1.xu@intel.com>
 <20230904-06f09083d5190fd50e53b1ea@orel>
 <CAJve8on7Yi7cDuXOVznuRdTvfUhig2hZy8g72nvnHkM7omoVAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8on7Yi7cDuXOVznuRdTvfUhig2hZy8g72nvnHkM7omoVAw@mail.gmail.com>

On Wed, Sep 06, 2023 at 02:35:42PM +0800, Haibo Xu wrote:
> On Mon, Sep 4, 2023 at 9:33 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Sat, Sep 02, 2023 at 08:59:25PM +0800, Haibo Xu wrote:
> > > Borrow the csr definitions and operations from kernel's
> > > arch/riscv/include/asm/csr.h to tools/ for riscv.
> > >
> > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > ---
> > >  tools/arch/riscv/include/asm/csr.h | 521 +++++++++++++++++++++++++++++
> > >  1 file changed, 521 insertions(+)
> > >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> > >
> > > diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/include/asm/csr.h
> > > new file mode 100644
> > > index 000000000000..4e86c82aacbd
> > > --- /dev/null
> > > +++ b/tools/arch/riscv/include/asm/csr.h
> > > @@ -0,0 +1,521 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * Copyright (C) 2015 Regents of the University of California
> > > + */
> > > +
> > > +#ifndef _ASM_RISCV_CSR_H
> > > +#define _ASM_RISCV_CSR_H
> > > +
> > > +#include <linux/bits.h>
> > > +
> > > +/* Status register flags */
> > > +#define SR_SIE               _AC(0x00000002, UL) /* Supervisor Interrupt Enable */
> > > +#define SR_MIE               _AC(0x00000008, UL) /* Machine Interrupt Enable */
> > > +#define SR_SPIE              _AC(0x00000020, UL) /* Previous Supervisor IE */
> > > +#define SR_MPIE              _AC(0x00000080, UL) /* Previous Machine IE */
> > > +#define SR_SPP               _AC(0x00000100, UL) /* Previously Supervisor */
> > > +#define SR_MPP               _AC(0x00001800, UL) /* Previously Machine */
> > > +#define SR_SUM               _AC(0x00040000, UL) /* Supervisor User Memory Access */
> > > +
> > > +#define SR_FS                _AC(0x00006000, UL) /* Floating-point Status */
> > > +#define SR_FS_OFF    _AC(0x00000000, UL)
> > > +#define SR_FS_INITIAL        _AC(0x00002000, UL)
> > > +#define SR_FS_CLEAN  _AC(0x00004000, UL)
> > > +#define SR_FS_DIRTY  _AC(0x00006000, UL)
> > > +
> > > +#define SR_VS                _AC(0x00000600, UL) /* Vector Status */
> > > +#define SR_VS_OFF    _AC(0x00000000, UL)
> > > +#define SR_VS_INITIAL        _AC(0x00000200, UL)
> > > +#define SR_VS_CLEAN  _AC(0x00000400, UL)
> > > +#define SR_VS_DIRTY  _AC(0x00000600, UL)
> > > +
> > > +#define SR_XS                _AC(0x00018000, UL) /* Extension Status */
> > > +#define SR_XS_OFF    _AC(0x00000000, UL)
> > > +#define SR_XS_INITIAL        _AC(0x00008000, UL)
> > > +#define SR_XS_CLEAN  _AC(0x00010000, UL)
> > > +#define SR_XS_DIRTY  _AC(0x00018000, UL)
> > > +
> > > +#define SR_FS_VS     (SR_FS | SR_VS) /* Vector and Floating-Point Unit */
> > > +
> > > +#ifndef CONFIG_64BIT
> >
> > How do we ensure CONFIG_64BIT is set?
> >
> 
> Currently, no explicit checking for this.
> Shall we add a gatekeeper in this file to ensure it is set?

Not in this file, since this file is shared by all the tools and...

> 
> #ifndef CONFIG_64BIT
> #error "CONFIG_64BIT was not set"
> #endif

...we'll surely hit this error right now since nothing is setting
CONFIG_64BIT when compiling KVM selftests.

We need to define CONFIG_64BIT in the build somewhere prior to any
headers which depend on it being included. Maybe we can simply
add -DCONFIG_64BIT to CFLAGS, since all KVM selftests supported
architectures are 64-bit.

(Please trim emails, as I've been doing, when discussing specific parts.)

Thanks,
drew
