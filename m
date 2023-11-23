Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D23D9C
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cho65pUz"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-507f1c29f25so523822e87.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 18:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700707819; x=1701312619; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D08p5YAHoEvBUZt7xMX5L9P22HbicVdwPxBXjnz6Npw=;
        b=Cho65pUzKKJw1gUvvWr//KaSGd7m3C9v7F980d6Lq+sC8/rD5B4Xu80klrauFMki2B
         R5FDprxM4jmmm0xR9AU8rUrz8q/SVOqcWZn90eFv7g0arXcG/4Mt9SlWkOxUVgt8dLNG
         lf8ASemze9xiiRryYTB4IY0+drvk0bGUhi1IBrxhvkZXmDUFaXr30zr77fhvEn+W1+r9
         eKBpCjk3505KT29RcmkSiQnEj+6Y2kOAZvq8c7icFVS7hoAP25T74Sg2Ucg4jRYq+xDf
         PyHhL50qNLa6WU2ctcNP0Pa6+jM1n3s1frMNOHL0aejVeRIDtCnYwI9fe6ihNhPZIgTQ
         uPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700707819; x=1701312619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D08p5YAHoEvBUZt7xMX5L9P22HbicVdwPxBXjnz6Npw=;
        b=qe8l6yQDyZ4tfgeT4WOF6TQ4GkSN3PhlxeCJWHJgDHPxGtqn+6LFF53a5HKAzgY2o8
         KRH0Rozkxwh6I8DcaonwtH4ISmFb1csH1cO/ggbh1CSqgI4IXVEnNRCnmTbWCydhEhxZ
         QlMhswi/vRXdUnETkVuUJ3dDEUWuXM8MeZC1qkr0E3kFR+V3U9udyqBk1DUUptBVwF5I
         EZ5QkY+gZ5ftX+78fHlo6qMaCtKOgixXK2ht8xXHlutxXbeSUJme3StY2mAyV566dmao
         2TUdAb/ZTU5YUEyZTJCM3lrKbgMlTEpz9s7sRexiv+pyc1uTsn1xeWoIIhi+3lLAAbhz
         f4yA==
X-Gm-Message-State: AOJu0YwmGFy07sOq+BxkYXJfbljE/h4ajMAR1MMzBrrfmIEmrTDWLxxF
	0JRIiF8Zk46U/Da/ECY/Mtl//8HEq12UVo5PRgM=
X-Google-Smtp-Source: AGHT+IHYfupwzu0CW6znUvnxSIcpycCfMCyG5yvT7i4wgCWs3TEwSE0e3Jej9CVUNIj28w27da85FVVMqHACxKhDkTk=
X-Received: by 2002:a05:6512:158e:b0:507:a766:ad27 with SMTP id
 bp14-20020a056512158e00b00507a766ad27mr4204558lfb.16.1700707818800; Wed, 22
 Nov 2023 18:50:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <cda6cc71c9bdde87fe87f6c2dec4f03ca249dd62.1694421911.git.haibo1.xu@intel.com>
 <20231003-d44206f71d0b22e539833697@orel> <CAJve8o=Q74U0Z3PayrzY7heNc0qeTw5VYS+tdkpm=aJdefQEbQ@mail.gmail.com>
 <20231122-b471122622059496906801c1@orel>
In-Reply-To: <20231122-b471122622059496906801c1@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Thu, 23 Nov 2023 10:50:07 +0800
Message-ID: <CAJve8o=gsY=qQUce-Z25p6C2BO5eLnH9N=MxjcdX0v0hFKN8kw@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] KVM: selftests: Unify the makefile rule for split targets
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 22, 2023 at 4:13=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sun, Oct 08, 2023 at 10:58:57AM +0800, Haibo Xu wrote:
> > On Tue, Oct 3, 2023 at 6:28=E2=80=AFPM Andrew Jones <ajones@ventanamicr=
o.com> wrote:
> > >
> > > On Thu, Sep 14, 2023 at 09:36:56AM +0800, Haibo Xu wrote:
> > > > A separate makefile rule was used for split targets which was added
> > > > in patch(KVM: arm64: selftests: Split get-reg-list test code). This
> > > > could be avoided by minor changes to the recipes of current rule.
> > > >
> > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/Makefile | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/s=
elftests/kvm/Makefile
> > > > index a3bb36fb3cfc..7972269e8c5f 100644
> > > > --- a/tools/testing/selftests/kvm/Makefile
> > > > +++ b/tools/testing/selftests/kvm/Makefile
> > > > @@ -249,13 +249,10 @@ TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(SP=
LIT_TESTS_OBJS))
> > > >  -include $(TEST_DEP_FILES)
> > > >
> > > >  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
> > > > -     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LI=
BKVM_OBJS) $(LDLIBS) -o $@
> > > > +     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LD=
LIBS) -o $@
> > > >  $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
> > > >       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> > > >
> > > > -$(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
> > > > -     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LD=
LIBS) -o $@
> > > > -
> > > >  EXTRA_CLEAN +=3D $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) =
$(SPLIT_TESTS_OBJS) cscope.*
> > > >
> > > >  x :=3D $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OB=
J))))
> > > > @@ -274,6 +271,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
> > > >  x :=3D $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> > > >  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> > > >  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> > > > +$(SPLIT_TESTS_TARGETS): $(OUTPUT)/%: $(ARCH_DIR)/%.o
> > > >
> > > >  cscope: include_paths =3D $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) =
include lib ..
> > > >  cscope:
> > > > --
> > > > 2.34.1
> > > >
> > >
> > > I just noticed that with and without this patch we're building the
> > > arch-specific part in tools/testing/selftests/kvm/riscv even when we =
have
> > > an $(OUTPUT) directory (e.g. O=3Dbuild). Those build artifacts should=
 be in
> > > build/kselftest/kvm/riscv instead.
> > >
> >
> > Thanks for pointing it out. I will have a look in next week!
> >
>
> Hi Haibo,
>
> Paolo just fixed this
>
> https://lore.kernel.org/all/20231121165631.1170797-1-pbonzini@redhat.com/
>

Thanks for the info! I will rebase the patch set in next version.

Thanks,
Haibo

> Thanks,
> drew
