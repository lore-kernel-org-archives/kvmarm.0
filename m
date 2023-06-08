Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9F539B
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 09:45:33 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1a3136fd194so327591fac.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 02:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686217533; x=1688809533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWfXcI9qpNRXyZ49c1qVkzQX/sqIlGyUNHOIKGAzDQA=;
        b=OoOYd2Yl2fvO4CeoY9SXHmrdO/GnjLe13sWCrJ7lGe1yhDuyXVDlqo0aUAKF0FKt9F
         uEbaKxjDxSqxqK3VGqMeVp/mo6E9VAG1KNWCB0Y1+PWB/moUVnUjS1NHX3MLj8gLWZ6z
         SsE9OQSfsUMJoyg9sQB2EtUigZho4LxaKSjdF4sCvz6wVdlD4AGj9a0TH/W8c5cYCVQP
         4kTNx9yq3tD7FM3+jK+lGWxjLs98WKyMsVCvksXQYHXH/ArNdQ0oQUlPlOSpbl04LXv5
         8Urqn++vTFktCKLCVxhFq0WA7NQuJmzpA31w40ViBGkfOQ8lMcSiN/BxLM8WpSOTLZL5
         6DiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686217533; x=1688809533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWfXcI9qpNRXyZ49c1qVkzQX/sqIlGyUNHOIKGAzDQA=;
        b=GdhsVDjepge86wwIfEsmKBgc/hn8bnb7e0wRf0rqjnVLJ9W8RblOCiwMU7y+5xZgNz
         N3Ax70L15BZ2j113pX7LfYXA5L4RZyJnuNqSLtN6B82x5xyrZ8Oo6xn/OZhHShseHDaM
         OhbX4PDq05Q89yvgBqxWyzTrowZRBOBd296R6AgYj70EEkE8QU5gI1I+VMGBD1/zehVy
         bBOxC6gz3AAbHdnesoqnVprDODq0GSxRSTbrCzBxkilbQUOxt/T23D8RhdvX7XiJaMeH
         nuJEe7lv//kx5byQEjpRcs2ktpRqy/fx0WBWRAFBiEyHSUVPKnbgIvfFRsrBHhUdEWYz
         C3cw==
X-Gm-Message-State: AC+VfDx2Z8CNuLselDmH7JQXlVPqUptd25ApVA87BdxP7LzAcZ86ymf4
	SPuAfUGEzp9TAHCTRy5iNDe16zVrrzoO5edkCdc=
X-Google-Smtp-Source: ACHHUZ5IWgmj+LEHtiTJyB5L+4nONSN43H9fR9QcrJW/5jde8UjA7NnpuuS9XpaB5O5YV3svfxnb3boBreWg1R1DcOk=
X-Received: by 2002:a05:6808:315:b0:39a:62f7:9463 with SMTP id
 i21-20020a056808031500b0039a62f79463mr4776127oie.41.1686217532902; Thu, 08
 Jun 2023 02:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1684999824.git.haibo1.xu@intel.com> <da390e6200e838fce320a2a43b2f87951b4e0bbb.1684999824.git.haibo1.xu@intel.com>
 <20230525-2bab5376987792eab73507ac@orel>
In-Reply-To: <20230525-2bab5376987792eab73507ac@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 8 Jun 2023 17:45:21 +0800
Message-ID: <CAJve8okR_iH4vF9DV9zTkDaeYe25kP7KUcKQphmjG5q-iVb-KA@mail.gmail.com>
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

On Fri, May 26, 2023 at 1:18=E2=80=AFAM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>

> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_R=
ISCV_CORE_REG(mode),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(sstatus),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(sie),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(stvec),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(sscratch),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(sepc),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(scause),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(stval),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(sip),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(satp),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RI=
SCV_CSR_REG(scounteren),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_=
RISCV_TIMER_REG(frequency),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_=
RISCV_TIMER_REG(time),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_=
RISCV_TIMER_REG(compare),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_=
RISCV_TIMER_REG(state),
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_A,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_C,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_D,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_F,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_H,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_I,
> > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RI=
SCV_ISA_EXT_M,
>
> I think all the above should have the size KVM_REG_SIZE_ULONG. Please als=
o
> test with a 32-bit host.
>

Hi Andrew,

Just noticed the RISC-V 32-bit kvm selftests was not supported currently.
Even though I tried to remove the below check for 32-bit, there were
still many warning and error messages during compiling.
It seems 32-bit KVM selftests was not supported either for ARM/x86. Do
we have a plan to support it on risc-v?

Regards,
Haibo

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h
b/tools/testing/selftests/kvm/include/kvm_util_base.h
index ac4aaa21deee..a32ccc06435b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -205,9 +205,9 @@ extern enum vm_guest_mode vm_mode_default;

 #elif defined(__riscv)

-#if __riscv_xlen =3D=3D 32
-#error "RISC-V 32-bit kvm selftests not supported"
-#endif
+//#if __riscv_xlen =3D=3D 32
+//#error "RISC-V 32-bit kvm selftests not supported"
+//#endif

>
> Thanks,
> drew
