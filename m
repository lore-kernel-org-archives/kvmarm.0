Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5B07C
	for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 01:17:31 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b703a0453fso91699321fa.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 18:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690334250; x=1690939050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEjI6egyxi9u1ADPXuzcHhehfkVm87hXX6VHMBuwIsI=;
        b=oDD4iFsVrv8jnWE057VUgfWbQlc4DL6kmzAsP4WSrvt3268tdn+UYiQUY/qgFknmGL
         3QVnj6awcXC+CM9h083T6h+ozpOfXoe/rOHjeg6SMTgZLFaNTIioGA9LslTo7NRMQUuC
         eKuiB22kkSe/gy7KRZvYxW00c7q/6IFBVMz76sWFJjWhuP1d6tb6jjBMR1ppA46LFxB2
         HinAk7q7gIIkerWWX/sq3jTg2kPITQz5G3/EiBRgTm4kWxelcn4Ra45m8/8IOWTpckh5
         zw1ZODBr7V9MH8cnxvHezsjSh9I6RHgH4KlfmrekAwKRwjQ8WT2nP1q7vNJrua/h0Auc
         7/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690334250; x=1690939050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEjI6egyxi9u1ADPXuzcHhehfkVm87hXX6VHMBuwIsI=;
        b=fuX5msKEGcgB3K2FoLKVqBVWfBgO1WHc79WCiVQOfCFbWyhIa3xzQvCR8hsB5x3wo6
         J3Ui5LlFf2PVGu7vKESwujU57VuBdcugeP3/gt7m4sugWwY4W6QZpmmxsNsDfEnX0mDP
         NfPurnsPa6NQrATOrXPC64IKJIp2FpnNPPwibCfUayPRnlcFnFBdmFR1i/mrWoYPrJLY
         ELWxnMa4N5CrB2Dk2jMMC/GG7icWieHYffPZCsBQZHLM0+aPdpSkoJmG88LnJtuV2jrC
         xHQXXTRshR9tsaOIPWIQv4GS1zZ5knsQnhh1HDgIAP0HKvmHuTX+W3zadV0RTW9mHxE4
         XHJQ==
X-Gm-Message-State: ABy/qLbx36+qjpFSkI4hSZ3iy3q1Mp3sPlGVdrZBlQTkQidusYJsN/ro
	58WtEvhqI7hfPr4xw5USYAzrmfFAOjD7Z3a0qQs=
X-Google-Smtp-Source: APBJJlGXi8CmqDI19BM+v2OBqqoutBJ+ULI8h/HZwAJ56aNGXbBV0H91SM2VTLCSn2uRBq2rmN7+Hx+VCsmvFHGhusA=
X-Received: by 2002:a2e:918a:0:b0:2b9:35ae:c9ac with SMTP id
 f10-20020a2e918a000000b002b935aec9acmr315516ljg.2.1690334249480; Tue, 25 Jul
 2023 18:17:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1690273969.git.haibo1.xu@intel.com> <1f25f27d1316bc91e1e31cd3d50a1d20f696759a.1690273969.git.haibo1.xu@intel.com>
 <CAJve8okJ-HYpsOrqH4Zvn7OBtwXWa4JumC+ZsMfHKB-deVYd2A@mail.gmail.com> <20230725-f5cf47c63abd8673d22b4936@orel>
In-Reply-To: <20230725-f5cf47c63abd8673d22b4936@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 26 Jul 2023 09:17:18 +0800
Message-ID: <CAJve8ony79xS2qPtdex+tSSEP2uTebzBRExUob9kOiwxpC7PEg@mail.gmail.com>
Subject: Re: [PATCH v6 06/13] KVM: arm64: selftests: Split get-reg-list test code
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 25, 2023 at 8:44=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Tue, Jul 25, 2023 at 04:50:36PM +0800, Haibo Xu wrote:
> > On Tue, Jul 25, 2023 at 4:37=E2=80=AFPM Haibo Xu <haibo1.xu@intel.com> =
wrote:
> > >
> > > From: Andrew Jones <ajones@ventanamicro.com>
> > >
> > > Split the arch-neutral test code out of aarch64/get-reg-list.c into
> > > get-reg-list.c. To do this we invent a new make variable
> > > $(SPLIT_TESTS) which expects common parts to be in the KVM selftests
> > > root and the counterparts to have the same name, but be in
> > > $(ARCH_DIR).
> > >
> > > There's still some work to be done to de-aarch64 the common
> > > get-reg-list.c, but we leave that to the next patch to avoid
> > > modifying too much code while moving it.
> > >
> > > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > ---
> > >  tools/testing/selftests/kvm/Makefile          |  12 +-
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 367 +---------------=
-
> > >  tools/testing/selftests/kvm/get-reg-list.c    | 377 ++++++++++++++++=
++
> > >  3 files changed, 398 insertions(+), 358 deletions(-)
> > >  create mode 100644 tools/testing/selftests/kvm/get-reg-list.c
> > >
> > > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/sel=
ftests/kvm/Makefile
> > > index c692cc86e7da..95f180e711d5 100644
> > > --- a/tools/testing/selftests/kvm/Makefile
> > > +++ b/tools/testing/selftests/kvm/Makefile
> > > @@ -140,7 +140,6 @@ TEST_GEN_PROGS_EXTENDED_x86_64 +=3D x86_64/nx_hug=
e_pages_test
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/aarch32_id_regs
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/arch_timer
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/debug-exceptions
> > > -TEST_GEN_PROGS_aarch64 +=3D aarch64/get-reg-list
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/hypercalls
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/page_fault_test
> > >  TEST_GEN_PROGS_aarch64 +=3D aarch64/psci_test
> > > @@ -152,6 +151,7 @@ TEST_GEN_PROGS_aarch64 +=3D access_tracking_perf_=
test
> > >  TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
> > >  TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
> > >  TEST_GEN_PROGS_aarch64 +=3D dirty_log_perf_test
> > > +TEST_GEN_PROGS_aarch64 +=3D get-reg-list
> > >  TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
> > >  TEST_GEN_PROGS_aarch64 +=3D kvm_page_table_test
> > >  TEST_GEN_PROGS_aarch64 +=3D memslot_modification_stress_test
> > > @@ -181,6 +181,8 @@ TEST_GEN_PROGS_riscv +=3D kvm_page_table_test
> > >  TEST_GEN_PROGS_riscv +=3D set_memory_region_test
> > >  TEST_GEN_PROGS_riscv +=3D kvm_binary_stats_test
> > >
> > > +SPLIT_TESTS +=3D get-reg-list
> > > +
> > >  TEST_PROGS +=3D $(TEST_PROGS_$(ARCH_DIR))
> > >  TEST_GEN_PROGS +=3D $(TEST_GEN_PROGS_$(ARCH_DIR))
> > >  TEST_GEN_PROGS_EXTENDED +=3D $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
> > > @@ -228,11 +230,14 @@ LIBKVM_C_OBJ :=3D $(patsubst %.c, $(OUTPUT)/%.o=
, $(LIBKVM_C))
> > >  LIBKVM_S_OBJ :=3D $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
> > >  LIBKVM_STRING_OBJ :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRIN=
G))
> > >  LIBKVM_OBJS =3D $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
> > > +SPLIT_TESTS_TARGETS :=3D $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
> > > +SPLIT_TESTS_OBJS :=3D $(patsubst %, $(ARCH_DIR)/%.o, $(SPLIT_TESTS))
> > >
> > >  TEST_GEN_OBJ =3D $(patsubst %, %.o, $(TEST_GEN_PROGS))
> > >  TEST_GEN_OBJ +=3D $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
> > >  TEST_DEP_FILES =3D $(patsubst %.o, %.d, $(TEST_GEN_OBJ))
> > >  TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(LIBKVM_OBJS))
> > > +TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(SPLIT_TESTS_OBJS))
> > >  -include $(TEST_DEP_FILES)
> > >
> > >  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
> > > @@ -240,7 +245,10 @@ $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %:=
 %.o
> > >  $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
> > >         $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> > >
> > > -EXTRA_CLEAN +=3D $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) cs=
cope.*
> > > +$(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
> > > +       $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LD=
LIBS) -o $@
> > > +
> > > +EXTRA_CLEAN +=3D $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(=
SPLIT_TESTS_OBJS) cscope.*
> > >
> > >  x :=3D $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)=
)))
> > >  $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> >
> > Hi @Andrew Jones,
> >
> > After rebasing to v6.5-rc3, some changes are needed to the SPLIT_TESTS
> > target, or the make would fail.
> > Please help have a look.
> >
>
> I took a look and then remembered why I hate looking at Makefiles... I
> guess it's fine, but it's a pity we need to repeat the $(CC) line.
>

Yes, I can't figure out a way to avoid the repeat $(CC) line.
Let's see whether there is any suggestion from the community that can
optimize this.

> Thanks,
> drew
