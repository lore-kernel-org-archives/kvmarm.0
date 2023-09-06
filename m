Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CADDF5A
	for <kvmarm@lists.linux.dev>; Wed,  6 Sep 2023 13:47:38 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-31c3726cc45so3279387f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Sep 2023 06:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694008056; x=1694612856; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y8t/IGzui+H5qdVxzJl2s3G8bPpmqSY5irt+QEZLU50=;
        b=LDPDlQLuDdFcTei+Yzzs84RewJ61VgCqOwlpl0IsfCtxapGLMxEUsU7SBiCtYFAOtu
         RPfSN0w/ymfRFiNYxZEMgIqbiv1dhCcEQn6PM/wAimSBS7gn1iRet5t679r0zjpBHSaH
         dksAGOBsfky2N+3YUrifOEF1EZAqAsYGb38faccgGvWswS7kSRaH/mbgYdTKQ+waTlWe
         AlYWDwfWoKYs7Y5he1A5Nqx616B2VSfDqZ3a19vpVR69M5veZSYyEPpZQaYDAkyLQn7R
         GY64sv2Rk//7F51WWUexn4mCOYAuH4asvaS+GzkIbjBkp9XVwn+T4LyBA4Sl/YOw+Oa+
         sr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694008056; x=1694612856;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8t/IGzui+H5qdVxzJl2s3G8bPpmqSY5irt+QEZLU50=;
        b=ItgtP68IK+LmxORV/YQMnxKJXERBLtr6TmYsu9X9/rYYUtm2VS8VwHZfQjEXaBNo4u
         Xm6OHRQ+bMCgJGjxwLS3VgCiyaKMrVd+sGll4jFbuDDneOL6Mnx2aOYbC03a7rSLXzEu
         LMwRfDGPVsBdX4KHTCpwf2SCyYaWKbfmTLFWDFX1tZgVJoDu1qG3YOrV9vEXljkBKVd0
         G8i35GTmOkCquA+GckVQ6S5Qcr9fYNfsOuCaeqjHtAdvBPezo642zMjcfv/1XKMNNQMM
         GxctmqlN++Qyl73GPST2huB/QFuIZO0WT/q0WemVRFzH8ZOewJkKoe/Th+OWi6dHLk3l
         SAzw==
X-Gm-Message-State: AOJu0YzwhJgdqq+FJy0V336owCq2x+sUl3wke0vmMRcAScZCYmfC9X2r
	lnT6vG2278vhEw5UTkHchKWGCQ==
X-Google-Smtp-Source: AGHT+IH2baeDANzYLEU+6JGXtK6JPZZwhj4Y9FCTJIRzFumqNrzyHLa/aBqci+k9LlX/9np1HUfmTQ==
X-Received: by 2002:a5d:5087:0:b0:317:ef76:b773 with SMTP id a7-20020a5d5087000000b00317ef76b773mr2318629wrt.45.1694008056476;
        Wed, 06 Sep 2023 06:47:36 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id x12-20020a05600c21cc00b003fed78b03b4sm19716726wmj.20.2023.09.06.06.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 06:47:34 -0700 (PDT)
Date: Wed, 6 Sep 2023 15:47:31 +0200
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
Message-ID: <20230906-11348d34e52289c8f52be8f9@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <8173daae52720dbdabbd88a5d412f653e6706de1.1693659382.git.haibo1.xu@intel.com>
 <20230904-06f09083d5190fd50e53b1ea@orel>
 <CAJve8on7Yi7cDuXOVznuRdTvfUhig2hZy8g72nvnHkM7omoVAw@mail.gmail.com>
 <20230906-c35fdc0e07d2cc0f9cb93203@orel>
 <CAJve8ok-Z6VCziFj5t0=BoouZ-VLyGaqEng-dYGTFnP-CR36kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8ok-Z6VCziFj5t0=BoouZ-VLyGaqEng-dYGTFnP-CR36kw@mail.gmail.com>

On Wed, Sep 06, 2023 at 05:09:20PM +0800, Haibo Xu wrote:
> On Wed, Sep 6, 2023 at 3:13 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Wed, Sep 06, 2023 at 02:35:42PM +0800, Haibo Xu wrote:
> > > On Mon, Sep 4, 2023 at 9:33 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> > > >
> > > > On Sat, Sep 02, 2023 at 08:59:25PM +0800, Haibo Xu wrote:
> > > > > Borrow the csr definitions and operations from kernel's
> > > > > arch/riscv/include/asm/csr.h to tools/ for riscv.
> > > > >
> > > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > > ---
> > > > >  tools/arch/riscv/include/asm/csr.h | 521 +++++++++++++++++++++++++++++
> > > > >  1 file changed, 521 insertions(+)
> > > > >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> > > > >
> > > > > diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/include/asm/csr.h
> > > > > new file mode 100644
> > > > > index 000000000000..4e86c82aacbd
> > > > > --- /dev/null
> > > > > +++ b/tools/arch/riscv/include/asm/csr.h
> > > > > @@ -0,0 +1,521 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > +/*
> > > > > + * Copyright (C) 2015 Regents of the University of California
> > > > > + */
> > > > > +
> > > > > +#ifndef _ASM_RISCV_CSR_H
> > > > > +#define _ASM_RISCV_CSR_H
> > > > > +
> > > > > +#include <linux/bits.h>
> > > > > +
> > > > > +/* Status register flags */
> > > > > +#define SR_SIE               _AC(0x00000002, UL) /* Supervisor Interrupt Enable */
> > > > > +#define SR_MIE               _AC(0x00000008, UL) /* Machine Interrupt Enable */
> > > > > +#define SR_SPIE              _AC(0x00000020, UL) /* Previous Supervisor IE */
> > > > > +#define SR_MPIE              _AC(0x00000080, UL) /* Previous Machine IE */
> > > > > +#define SR_SPP               _AC(0x00000100, UL) /* Previously Supervisor */
> > > > > +#define SR_MPP               _AC(0x00001800, UL) /* Previously Machine */
> > > > > +#define SR_SUM               _AC(0x00040000, UL) /* Supervisor User Memory Access */
> > > > > +
> > > > > +#define SR_FS                _AC(0x00006000, UL) /* Floating-point Status */
> > > > > +#define SR_FS_OFF    _AC(0x00000000, UL)
> > > > > +#define SR_FS_INITIAL        _AC(0x00002000, UL)
> > > > > +#define SR_FS_CLEAN  _AC(0x00004000, UL)
> > > > > +#define SR_FS_DIRTY  _AC(0x00006000, UL)
> > > > > +
> > > > > +#define SR_VS                _AC(0x00000600, UL) /* Vector Status */
> > > > > +#define SR_VS_OFF    _AC(0x00000000, UL)
> > > > > +#define SR_VS_INITIAL        _AC(0x00000200, UL)
> > > > > +#define SR_VS_CLEAN  _AC(0x00000400, UL)
> > > > > +#define SR_VS_DIRTY  _AC(0x00000600, UL)
> > > > > +
> > > > > +#define SR_XS                _AC(0x00018000, UL) /* Extension Status */
> > > > > +#define SR_XS_OFF    _AC(0x00000000, UL)
> > > > > +#define SR_XS_INITIAL        _AC(0x00008000, UL)
> > > > > +#define SR_XS_CLEAN  _AC(0x00010000, UL)
> > > > > +#define SR_XS_DIRTY  _AC(0x00018000, UL)
> > > > > +
> > > > > +#define SR_FS_VS     (SR_FS | SR_VS) /* Vector and Floating-Point Unit */
> > > > > +
> > > > > +#ifndef CONFIG_64BIT
> > > >
> > > > How do we ensure CONFIG_64BIT is set?
> > > >
> > >
> > > Currently, no explicit checking for this.
> > > Shall we add a gatekeeper in this file to ensure it is set?
> >
> > Not in this file, since this file is shared by all the tools and...
> >
> > >
> > > #ifndef CONFIG_64BIT
> > > #error "CONFIG_64BIT was not set"
> > > #endif
> >
> > ...we'll surely hit this error right now since nothing is setting
> > CONFIG_64BIT when compiling KVM selftests.
> >
> > We need to define CONFIG_64BIT in the build somewhere prior to any
> > headers which depend on it being included. Maybe we can simply
> > add -DCONFIG_64BIT to CFLAGS, since all KVM selftests supported
> > architectures are 64-bit.
> >
> 
> Make sense! Another option can be just add "#define CONFIG_64BIT" at
> the begin of csr.h

Nope, other tools/tests may want to include csr.h someday and they may or
may not be targeting 64-bit. They'll need to appropriately set
CONFIG_64BIT themselves. We could require

#define CONFIG_64BIT
#include <asm/csr.h>

everywhere we include it, but that's error prone since it'll get forgotten
and nothing will complain unless a define which isn't also present in
!CONFIG_64BIT is used.

Thanks,
drew
