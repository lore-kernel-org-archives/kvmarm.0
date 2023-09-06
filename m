Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850F8110D
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 09:09:34 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2bcc4347d2dso51601701fa.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 02:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693991372; x=1694596172; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFAc0ENvdawtNpNN8VvAfyOPRtP79Ec15LEe0csz82o=;
        b=hqOZGdra9UKxXgmjNLdU+2tiSWxTKIl8egptnAN5ng/pumjVroyiTLTz94MVmbP/Z0
         XTc+QF2nSHnH/PXLd0me5UVVyMzwDwWDjvHAzoeSdeHBn9e0UywBGqsplrcnMuhgQZK6
         +E2V4yn7A3jE8xL446XNteR+LrStPAQd76zfRpBQCApxHoPZuC8u12/u/nKCd0IyYzRI
         m5JrWTy+vrW9R1M6Em8mQ7buMH+I2nikREtg7XJ4FiJVknQxIZcYxDvszCUEjhzp4CGi
         aecb5PsF5r8loPRTDBfpdWIpnuAw6VTOBotPGZSXbzVPwYnNfF8MiilX2wn9dTlRy9q7
         oPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693991372; x=1694596172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rFAc0ENvdawtNpNN8VvAfyOPRtP79Ec15LEe0csz82o=;
        b=Zsq9QGBuHL6OGRsssPT2Inr0ap4nchq3N66daE1Tdadj7U1xAH/koBu6CAZSWltLMp
         D64EUj4tpzKujAuyXj7bSFPKKP8Yh4odwGsPtYDDmIYdO23QP06A7+5gG6T+kT2jh2YT
         KYIo5MnSkxk8v4XMPXqUbAmDDlQ6STq51rvI/EHxDSNNlwA1YMv2G/G1IletQWZsjD2x
         oKDpcdICP0scOZM+V5dLUVELFjRKoWd4ewszmK8YTUlcda64z0eXw8xuWvNdq8NoiYkS
         kGLN97s9ao9tvv5qODwUxQaMVY5ZM2DHOILDcmfAcqX+dxK9ZusgasCfYGrfvNhTbySK
         I1SA==
X-Gm-Message-State: AOJu0YzBf7z4cIR8n2v/fW4A9MRB/fTsTICZ3lDi5Faw19XQf7RI61iK
	Xu+tqMI+zU6jilMWybmI1UD7EWOEoWPBaqhypj4=
X-Google-Smtp-Source: AGHT+IGaZt6wsaWTbeCCw1/OFTccreQdD11HazSIZhfbhlO6zQVsNMMI+83UdqvCNrcOOuteAKYC2L4cc72BzWIWZ78=
X-Received: by 2002:a2e:9859:0:b0:2bd:1fee:aacf with SMTP id
 e25-20020a2e9859000000b002bd1feeaacfmr1890357ljj.24.1693991372034; Wed, 06
 Sep 2023 02:09:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1693659382.git.haibo1.xu@intel.com> <8173daae52720dbdabbd88a5d412f653e6706de1.1693659382.git.haibo1.xu@intel.com>
 <20230904-06f09083d5190fd50e53b1ea@orel> <CAJve8on7Yi7cDuXOVznuRdTvfUhig2hZy8g72nvnHkM7omoVAw@mail.gmail.com>
 <20230906-c35fdc0e07d2cc0f9cb93203@orel>
In-Reply-To: <20230906-c35fdc0e07d2cc0f9cb93203@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 6 Sep 2023 17:09:20 +0800
Message-ID: <CAJve8ok-Z6VCziFj5t0=BoouZ-VLyGaqEng-dYGTFnP-CR36kw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] tools: riscv: Add header file csr.h
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, wchen <waylingii@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, David Matlack <dmatlack@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Lei Wang <lei4.wang@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Peter Gonda <pgonda@google.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Like Xu <likexu@tencent.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, zhang songyi <zhang.songyi@zte.com.cn>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 6, 2023 at 3:13=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Wed, Sep 06, 2023 at 02:35:42PM +0800, Haibo Xu wrote:
> > On Mon, Sep 4, 2023 at 9:33=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > On Sat, Sep 02, 2023 at 08:59:25PM +0800, Haibo Xu wrote:
> > > > Borrow the csr definitions and operations from kernel's
> > > > arch/riscv/include/asm/csr.h to tools/ for riscv.
> > > >
> > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > ---
> > > >  tools/arch/riscv/include/asm/csr.h | 521 +++++++++++++++++++++++++=
++++
> > > >  1 file changed, 521 insertions(+)
> > > >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> > > >
> > > > diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/=
include/asm/csr.h
> > > > new file mode 100644
> > > > index 000000000000..4e86c82aacbd
> > > > --- /dev/null
> > > > +++ b/tools/arch/riscv/include/asm/csr.h
> > > > @@ -0,0 +1,521 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > +/*
> > > > + * Copyright (C) 2015 Regents of the University of California
> > > > + */
> > > > +
> > > > +#ifndef _ASM_RISCV_CSR_H
> > > > +#define _ASM_RISCV_CSR_H
> > > > +
> > > > +#include <linux/bits.h>
> > > > +
> > > > +/* Status register flags */
> > > > +#define SR_SIE               _AC(0x00000002, UL) /* Supervisor Int=
errupt Enable */
> > > > +#define SR_MIE               _AC(0x00000008, UL) /* Machine Interr=
upt Enable */
> > > > +#define SR_SPIE              _AC(0x00000020, UL) /* Previous Super=
visor IE */
> > > > +#define SR_MPIE              _AC(0x00000080, UL) /* Previous Machi=
ne IE */
> > > > +#define SR_SPP               _AC(0x00000100, UL) /* Previously Sup=
ervisor */
> > > > +#define SR_MPP               _AC(0x00001800, UL) /* Previously Mac=
hine */
> > > > +#define SR_SUM               _AC(0x00040000, UL) /* Supervisor Use=
r Memory Access */
> > > > +
> > > > +#define SR_FS                _AC(0x00006000, UL) /* Floating-point=
 Status */
> > > > +#define SR_FS_OFF    _AC(0x00000000, UL)
> > > > +#define SR_FS_INITIAL        _AC(0x00002000, UL)
> > > > +#define SR_FS_CLEAN  _AC(0x00004000, UL)
> > > > +#define SR_FS_DIRTY  _AC(0x00006000, UL)
> > > > +
> > > > +#define SR_VS                _AC(0x00000600, UL) /* Vector Status =
*/
> > > > +#define SR_VS_OFF    _AC(0x00000000, UL)
> > > > +#define SR_VS_INITIAL        _AC(0x00000200, UL)
> > > > +#define SR_VS_CLEAN  _AC(0x00000400, UL)
> > > > +#define SR_VS_DIRTY  _AC(0x00000600, UL)
> > > > +
> > > > +#define SR_XS                _AC(0x00018000, UL) /* Extension Stat=
us */
> > > > +#define SR_XS_OFF    _AC(0x00000000, UL)
> > > > +#define SR_XS_INITIAL        _AC(0x00008000, UL)
> > > > +#define SR_XS_CLEAN  _AC(0x00010000, UL)
> > > > +#define SR_XS_DIRTY  _AC(0x00018000, UL)
> > > > +
> > > > +#define SR_FS_VS     (SR_FS | SR_VS) /* Vector and Floating-Point =
Unit */
> > > > +
> > > > +#ifndef CONFIG_64BIT
> > >
> > > How do we ensure CONFIG_64BIT is set?
> > >
> >
> > Currently, no explicit checking for this.
> > Shall we add a gatekeeper in this file to ensure it is set?
>
> Not in this file, since this file is shared by all the tools and...
>
> >
> > #ifndef CONFIG_64BIT
> > #error "CONFIG_64BIT was not set"
> > #endif
>
> ...we'll surely hit this error right now since nothing is setting
> CONFIG_64BIT when compiling KVM selftests.
>
> We need to define CONFIG_64BIT in the build somewhere prior to any
> headers which depend on it being included. Maybe we can simply
> add -DCONFIG_64BIT to CFLAGS, since all KVM selftests supported
> architectures are 64-bit.
>

Make sense! Another option can be just add "#define CONFIG_64BIT" at
the begin of csr.h

> (Please trim emails, as I've been doing, when discussing specific parts.)
>

Sure, thanks for the suggestions!

> Thanks,
> drew
