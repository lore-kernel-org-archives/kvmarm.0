Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2D5A5B
	for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 07:08:54 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f6094cb2ebso18992875e9.3
        for <kvmarm@lists.linux.dev>; Mon, 29 May 2023 00:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685344133; x=1687936133;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J9yQZI29FBb5uk90C946uFQGVpaFZWwP+axkfkJPRmA=;
        b=OGzmkwym+ds5lNbK7+lHCLxUguUfy0QTJ/UI2yLcw74+JBxqixt+zmx3lNyihLZ/qW
         Rrl7u4zd2ZxT7qCL27Mau576RJoJ1CiSa0kWXOUmjHxKhQMPTfGNSIi0byquj1Nki8n7
         cCB+xb/M+P51G/dtVskzHEkGHBRc60UcS6xABlKWzdN9VqozEbcdLXxh/0kiL9B4u4h8
         S557VMaZShp76FvJQOnFzyQD/SYCQVb+/87pTopt7EtnK3a3prWQRrU/9gyxDitIX4ea
         07jX2bKWoC2ai9FXbUtUjmVHAPupvol8Q7kZEcQ8Ii51pvvXXPZUzSPTvb6/hRgb3eYL
         SuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685344133; x=1687936133;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9yQZI29FBb5uk90C946uFQGVpaFZWwP+axkfkJPRmA=;
        b=WjLm+wTGRSjCT5Hv6cAhZrRImn2qaarOcd9q1M9sHMHTKchZC7px/dPAHE4nrdCkmQ
         cgd/3E0tegoOy9vT5+tfvlEMroqSj7jaWzIuBYK/h5km7VgEpz4ZeXhVNM4DMT+pxzUH
         Y6fHMUOIMp30oQEad8J24pqU1oYpleg42r4jcnprYNiudnB6j+87RLC1eCAWLcuCab0d
         DWmSzgK1PWlujiw8qTqz032QOOBa8cEAUudOhoFb7yDtVPt5BfzkuubDjixVDx+iKUdY
         L5SRzhtBJtos78PaLz2q1eveOlPNrceUD8c4uf8d9FhRxdBYW+gn9vdo4F1cKQm4q7A7
         Yg9w==
X-Gm-Message-State: AC+VfDx5v16AjWlLpr1vjBE9NkKagjN2ccrYg66LLOSZus/gDHnyp8Iy
	ThIFNP2ghHtxk4kE2T95pGZnvA==
X-Google-Smtp-Source: ACHHUZ73LyzFhpd/6+sfi011A/EFvj9Fd34HsRwL8GCzpeQu6/GsXCR3FkDg7Ni/nfr2tAz4KOAc6A==
X-Received: by 2002:a1c:f616:0:b0:3f6:82a:5d1b with SMTP id w22-20020a1cf616000000b003f6082a5d1bmr9377055wmc.34.1685344132851;
        Mon, 29 May 2023 00:08:52 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m17-20020a056000009100b0030ae973c2e7sm3092863wrx.83.2023.05.29.00.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 00:08:52 -0700 (PDT)
Date: Mon, 29 May 2023 09:08:51 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <xiaobo55x@gmail.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 11/11] KVM: riscv: selftests: Add get-reg-list test
Message-ID: <20230529-7b3e41e6aca55f9e90dd6cd3@orel>
References: <cover.1684999824.git.haibo1.xu@intel.com>
 <da390e6200e838fce320a2a43b2f87951b4e0bbb.1684999824.git.haibo1.xu@intel.com>
 <20230525-2bab5376987792eab73507ac@orel>
 <CAJve8o=5ji5D-S8k+GaGd7sH7KXNWxDaWhD3jyxtHizKSMtjbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8o=5ji5D-S8k+GaGd7sH7KXNWxDaWhD3jyxtHizKSMtjbA@mail.gmail.com>

On Sat, May 27, 2023 at 12:39:57PM +0800, Haibo Xu wrote:
> On Fri, May 26, 2023 at 1:18 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, May 25, 2023 at 03:38:35PM +0800, Haibo Xu wrote:
...
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.a6),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.a7),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s2),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s3),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s4),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s5),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s6),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s7),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s8),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s9),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s10),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.s11),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.t3),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.t4),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.t5),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(regs.t6),
> >
> > ...all the above would just be indices rather than named registers. I
> > guess that's better for these registers.
> >
> 
> You mean to show it as KVM_REG_RISCV_CORE_REG(regs.regs[0]) ...
> KVM_REG_RISCV_CORE_REG(regs.regs[31])?
>

I'm OK with these registers using their names in this list, it does look
better. However the original idea for these lists was that they would be
generated from print_reg(). In this case, print_reg() is generating them
with their number instead of name. Either print_reg() could learn how to
generate their names by handling the offset ranges of each register type,
e.g.

switch (reg_off) {
case 10 ... 17:
   strdup_printf("... KVM_REG_RISCV_CORE_REG(regs.a%d),", reg_off - 10);

or we can use the numbers here in this list, or we can leave it as you
have it (i.e. done manually).

Thanks,
drew
