Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21EF20E7
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:15:41 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b9dc1bff38so100609551fa.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 10:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692206139; x=1692810939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHzwP25lc2+5c3C6UwJkbP07p9JjcSoaHXyiPwCJzpU=;
        b=fQXxAGiQN4dFyoOtWD4APY/yIxHdbFpIum5aPTDTxm+FvcXEsBlLCL3pp8mM/q77jE
         c9F0FGauolC0CF9Nj7pTa+V8w4z3OmbLrheu8LNqRDULZ5ZcA9RvtIJqRB07jqTjaRwg
         U+UpkPk/oH1zpY8XavV5RIAAhI42yzxQBoxOyp22+pci8pLhir5SQIeri2sq+gvCNAkH
         9yHgb5IZt2KpLhFoxyFUM3uGj/IWm+9hpKnlLFfQ3TkXGhYKtCh7djaSyKxQqsvIA98l
         93Z+MIp28orCRiEzJdR+fWZ1Wc+Fa3+bxv6/P76Sv4gdRJaXIqppjVcnPOM/3wQ3NDaU
         Nj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692206139; x=1692810939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KHzwP25lc2+5c3C6UwJkbP07p9JjcSoaHXyiPwCJzpU=;
        b=O19z8o0sOvHBBVCBsP5A8exVFC2nhRj3LGbeoHcYZ1L8fQn27ZmEJqe0wuQ4/G2LoP
         bNpLFHE3u1jSd8YVZbaI8+DdVVdtgL9FqPcWGxG3AZvi//osdHkQSshMsxeXOVFPPuxL
         EwhUwCZBlwEd5LfrSxQ7nYD7wTy4QlE8YYRxwrBPC1psJoGGa6lOPxTdjmLTnMjgWguL
         WwtQDEcNauWjrjZbiS2mOPNFxiLyImADs7kR8IxauiO8/ndHiP4gbXGsrMedbhjKglm/
         SGmQbT5XqhMKVB7fwKFzHWOEdl8UPxcoTYHNeh84A5BqKt5a7fCLgkrPLFIY+nPJEs8t
         hOoQ==
X-Gm-Message-State: AOJu0YzCtmf4zBsR04qMQpBWtGUIIjKutJ7EjaLasFTi4PXi4kdyCQU5
	JlOwaPf+13yeyScbd2GgS+PTHnYMh07yx1dogsKRrQ==
X-Google-Smtp-Source: AGHT+IGLSaJ3/O+Pfy5Uz0nILdeFwQS4LZ9hdXZc4YhdJvRYKlDuwaIsK6a1aIppt4bzPTuIfQMIrpF3hvU89A6BsQc=
X-Received: by 2002:a2e:7013:0:b0:2b6:a763:5d13 with SMTP id
 l19-20020a2e7013000000b002b6a7635d13mr1934137ljc.27.1692206139312; Wed, 16
 Aug 2023 10:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-11-jingzhangos@google.com> <eaa2519e-15b3-2fd4-199e-8e3368df7e0d@redhat.com>
In-Reply-To: <eaa2519e-15b3-2fd4-199e-8e3368df7e0d@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 16 Aug 2023 10:15:26 -0700
Message-ID: <CAAdAUtj0zUqpjm1L+7-D5eeEK85f0jiqDyjoQm47tpzDGxhaLw@mail.gmail.com>
Subject: Re: [PATCH v8 10/11] KVM: arm64: selftests: Import automatic system
 register definition generation from kernel
To: Shaoqin Huang <shahuang@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Tue, Aug 15, 2023 at 11:54=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com=
> wrote:
>
> Hi Jing,
>
> On 8/8/23 00:22, Jing Zhang wrote:
> > Import automatic system register definition generation from kernel and
> > update system register usage accordingly.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index c692cc86e7da..a8cf0cb04db7 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -200,14 +200,15 @@ ifeq ($(ARCH),x86_64)
> >   LINUX_TOOL_ARCH_INCLUDE =3D $(top_srcdir)/tools/arch/x86/include
> >   else
> >   LINUX_TOOL_ARCH_INCLUDE =3D $(top_srcdir)/tools/arch/$(ARCH)/include
> > +ARCH_GENERATED_INCLUDE =3D $(top_srcdir)/tools/arch/$(ARCH)/include/ge=
nerated
> >   endif
> >   CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dg=
nu99 \
> > -     -Wno-gnu-variable-sized-type-not-at-end -MD\
> > +     -Wno-gnu-variable-sized-type-not-at-end -MD \
> >       -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
> >       -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> >       -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> >       -I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> > -     $(KHDR_INCLUDES)
> > +     -I$(ARCH_GENERATED_INCLUDE) $(KHDR_INCLUDES)
> >   ifeq ($(ARCH),s390)
> >       CFLAGS +=3D -march=3Dz10
> >   endif
> > @@ -255,8 +256,16 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> >   $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
> >       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -=
o $@
> >
> > +ifeq ($(ARCH),arm64)
> > +GEN_SYSREGS :=3D $(ARCH_GENERATED_INCLUDE)/asm/sysreg-defs.h
> > +ARCH_TOOLS :=3D $(top_srcdir)/tools/arch/$(ARCH)/tools/
> > +
> > +$(GEN_SYSREGS): $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg
> > +     mkdir -p $(dir $@); awk -f $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TO=
OLS)/sysreg > $@
> > +endif
> > +
> >   x :=3D $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> > -$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> > +$(TEST_GEN_PROGS): $(LIBKVM_OBJS) $(GEN_SYSREGS)
>
> I don't this this really works. Since the $(GEN_SYSREG) is the
> prerequisites of $(TEST_GEN_PROGS). Only when $(TEST_GEN_PROGS) being
> compiled, the $(GEN_SYSREG) can be generated.
>
> But the fact is, the $(TEST_GEN_PROGS) is relies on $(TEST_GEN_OBJ),
> which means $(TEST_GEN_OBJ) will be compiled before $(TEST_GEN_PROGS),
> but $(TEST_GEN_OBJ) depends on $(GEN_SYSREG) again, at the time, the
> $(GEN_SYSREG) hasn't been generated, so it will has error:
>
> No such file or directory.
>
> #include "asm/sysreg-defs.h"
>
> I think the correct way to generate $(GEN_SYSREGS) is add a prerequisite
> for $(TEST_GEN_OBJ), like:
>
> $(TEST_GEN_OBJ): $(GEN_SYSREGS)

You're right. Fixed.

>
> Thanks,
> Shaoqin
>
> >   $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> >
> >   cscope: include_paths =3D $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) inc=
lude lib ..
> --
> Shaoqin
>

Thanks,
Jing
