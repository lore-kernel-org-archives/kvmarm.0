Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E737EA9
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 01:21:02 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2563ca70f64so251188a91.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 18:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686273662; x=1688865662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twlI1LD4oryR8OR0rQu9NKOMo/NUVR/h5zjz7GVrnR8=;
        b=XWHgzO7540E60svSCzllKPcC2GCkvrzWjfew09EYySK6CIVycShnDFvaJ/ReMzuKop
         tJHDJHoJzt7aqoo+FkCB8sShxnEGHscNeCK2oQsmFiPbzo8s62H5qlR/zy2nXm4qubve
         BTdpAq1EDOPUR7fhJ/I4QUVF409qSoljmufyYAd+YmZ8/g5n5DwwYVDhbDpTdNlnJWRp
         rV2uao+FGjxkgbxjVwie8xF7SJrgN2OrRVfvddabb+yOj6iGDZR3KzEUPk5ryidqm01T
         38Clp/syDd1nNbqlFunhiLBApy1OOhy4b7gYMi5u/IIC55njbLiA16sn0flz1M4SurH/
         nriw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686273662; x=1688865662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twlI1LD4oryR8OR0rQu9NKOMo/NUVR/h5zjz7GVrnR8=;
        b=B7DM/JyJJIRPDighgx9fRq74tRGb3NcEvX+cGfM41mwKF249GhGL+0ToQCoxM5bovG
         Kpwi+AleN3sC2vJh/3vsDzXpl8d7ERnd34QzY156Dqm8Zgpr/vQP3t1uLKKdZ/Se7M8o
         ssWYujZi/zT+1f1MB4DYdS08TZZtPTiCBaJ5p6m9IJMdEsknZtW2SiMOr45/WLpSLb9N
         cjAQBSGLYVbj+jEU8aAEGjS5GdyOmJSDoUjoMKy5whMFX5h+wX2atp2Biw3niVZRYGPF
         zrTMAUdA5H/YIdy5uNZzNe8AlO31yI4eBmsrqaugZShgm3FuYCyCj+Wia1QbuTTkTRkj
         acXA==
X-Gm-Message-State: AC+VfDyLg9L0TUfcg3+pmxv1SPmcDa5MTDnruHBDo08Fj2rUabsYQVPQ
	m2JdsDc64c2pzIGmKVXv781LlYnuhqxUSWCN/GE=
X-Google-Smtp-Source: ACHHUZ6UCki4RhqRqkb6Pa4UkvtBuYqIvtIA6byJWicKvwzZ4Yd6I0HApD+3vIJuG+swD389v/xkWd3GhTMn5b2Ldws=
X-Received: by 2002:a17:90a:c783:b0:250:c4c1:882 with SMTP id
 gn3-20020a17090ac78300b00250c4c10882mr60804pjb.30.1686273662263; Thu, 08 Jun
 2023 18:21:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1684999824.git.haibo1.xu@intel.com> <da390e6200e838fce320a2a43b2f87951b4e0bbb.1684999824.git.haibo1.xu@intel.com>
 <20230525-2bab5376987792eab73507ac@orel> <CAJve8okR_iH4vF9DV9zTkDaeYe25kP7KUcKQphmjG5q-iVb-KA@mail.gmail.com>
 <20230608-344953a953eeb63ef6c26fb8@orel>
In-Reply-To: <20230608-344953a953eeb63ef6c26fb8@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 9 Jun 2023 09:20:50 +0800
Message-ID: <CAJve8o=xhANzM7qPsyC-4rc8oB9TWTxBJKtiqNxe-w_+w_d-1g@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: riscv: selftests: Add get-reg-list test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 8, 2023 at 5:58=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Jun 08, 2023 at 05:45:21PM +0800, Haibo Xu wrote:
> > On Fri, May 26, 2023 at 1:18=E2=80=AFAM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> >
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_R=
EG_RISCV_CORE_REG(mode),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(sstatus),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(sie),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(stvec),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(sscratch),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(sepc),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(scause),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(stval),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(sip),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(satp),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_RE=
G_RISCV_CSR_REG(scounteren),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_=
REG_RISCV_TIMER_REG(frequency),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_=
REG_RISCV_TIMER_REG(time),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_=
REG_RISCV_TIMER_REG(compare),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_=
REG_RISCV_TIMER_REG(state),
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_A,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_C,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_D,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_F,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_H,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_I,
> > > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KV=
M_RISCV_ISA_EXT_M,
> > >
> > > I think all the above should have the size KVM_REG_SIZE_ULONG. Please=
 also
> > > test with a 32-bit host.
> > >
> >
> > Hi Andrew,
> >
> > Just noticed the RISC-V 32-bit kvm selftests was not supported currentl=
y.
>
> Oh, right.
>
> > Even though I tried to remove the below check for 32-bit, there were
> > still many warning and error messages during compiling.
> > It seems 32-bit KVM selftests was not supported either for ARM/x86. Do
> > we have a plan to support it on risc-v?
>
> No plan and, if there was, it would be super low priority. So for stuff
> like using KVM_REG_SIZE_ULONG, we'll just have to try and get it right
> without testing. If somebody adds 32-bit support to these tests someday,
> then, hopefully, it'll just work (I'm allowed one overly optimistic
> comment per day).
>

Sure, Will try to get it right for a 32-bit system.

> Thanks,
> drew
