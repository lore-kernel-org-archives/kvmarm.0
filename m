Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11E7188
	for <kvmarm@lists.linux.dev>; Sun,  8 Oct 2023 02:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZsnKe0r"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50433d8385cso4576980e87.0
        for <kvmarm@lists.linux.dev>; Sat, 07 Oct 2023 19:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696733949; x=1697338749; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScEsw5kRuBSyCrQaTmCBYUka5dQTvwb6RwilZml22rc=;
        b=iZsnKe0rH5UPUZGjoao8AONFmeLV5vUxpLtZvdArIQaDY2JgZfVADwEttZDPh9iiEn
         ul1ypaiycmX9myXSFZhWFXQgmf1aak1YfuOKlTOAX495UPrduOJ/IxR1pAINcsFwGlOb
         r4Dmmfqud12AMc3TaDxsNx13PLz/F6gS4Es8bYCp8TmlspLqRxk1D+/SyvgdurWLBmCj
         oUf0HJySPiHOvt5mx2PmTyxLAmfTS5eISfDvMJM/F1nPeo97mU3LZDLrcsd4CyYthOsq
         YrEhNj7jcAN5v9F2rgF2PDMvZKnSXjrkqesmcuO6cFZCHwPQWr4dl79QLAv0fh9x0T3F
         pnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696733949; x=1697338749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScEsw5kRuBSyCrQaTmCBYUka5dQTvwb6RwilZml22rc=;
        b=TvRBsBcvee+noARi3Ux50w2j6k8PcowyO6MyOPVmkMiDCyN+C99FJZ697JWXpwkdPi
         EYF7nkV9+Uv5SxjqDdBCIY2cXsXTs+uVSei0qp9ghfb6VrNLfKbsRHCNrEZGO0zxovrC
         +ZRFvU6DF8bCbSu2oS6J261HJpzFOdElyROrW4j3jHnRn2rBXuATSXXNFIvecQNJMXOW
         s6JFrh7qF02xB0lWvJyN1ftozMVTCtMPcn/wYWyPdvcujlD9YKpj9Pf5CMCZiGXX/deD
         9/uiGag1UuKHPlgozTJthtVGSgN6ezmAy1jtw2Tji7bpe+3FMLfXHUgx5S7JRb52Fm0o
         4BNA==
X-Gm-Message-State: AOJu0Yx6KnAhI21jZwtFqbCTx5X5eWcEmn7W1W2pASYTD9G+5Uwq+AkG
	mprnovZ546UDFoAwE6qVcPRW3R/9qwXqndqVNY8=
X-Google-Smtp-Source: AGHT+IEpb2yeFTzMhQ8mODQ9bJzzgKP4xcGT3Fdr1mnHynSEwgLk6lyxwCFHJcwsd6qGQGzx5r8I8XmeCKBxhv85QXI=
X-Received: by 2002:a05:6512:1154:b0:501:bd43:3b9c with SMTP id
 m20-20020a056512115400b00501bd433b9cmr11192604lfg.23.1696733948681; Sat, 07
 Oct 2023 19:59:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <cda6cc71c9bdde87fe87f6c2dec4f03ca249dd62.1694421911.git.haibo1.xu@intel.com>
 <20231003-d44206f71d0b22e539833697@orel>
In-Reply-To: <20231003-d44206f71d0b22e539833697@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Sun, 8 Oct 2023 10:58:57 +0800
Message-ID: <CAJve8o=Q74U0Z3PayrzY7heNc0qeTw5VYS+tdkpm=aJdefQEbQ@mail.gmail.com>
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

On Tue, Oct 3, 2023 at 6:28=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Thu, Sep 14, 2023 at 09:36:56AM +0800, Haibo Xu wrote:
> > A separate makefile rule was used for split targets which was added
> > in patch(KVM: arm64: selftests: Split get-reg-list test code). This
> > could be avoided by minor changes to the recipes of current rule.
> >
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index a3bb36fb3cfc..7972269e8c5f 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -249,13 +249,10 @@ TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(SPLIT_=
TESTS_OBJS))
> >  -include $(TEST_DEP_FILES)
> >
> >  $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o
> > -     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBKVM=
_OBJS) $(LDLIBS) -o $@
> > +     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS=
) -o $@
> >  $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
> >       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >
> > -$(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
> > -     $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS=
) -o $@
> > -
> >  EXTRA_CLEAN +=3D $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SP=
LIT_TESTS_OBJS) cscope.*
> >
> >  x :=3D $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)))=
)
> > @@ -274,6 +271,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
> >  x :=3D $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> >  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> >  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> > +$(SPLIT_TESTS_TARGETS): $(OUTPUT)/%: $(ARCH_DIR)/%.o
> >
> >  cscope: include_paths =3D $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) incl=
ude lib ..
> >  cscope:
> > --
> > 2.34.1
> >
>
> I just noticed that with and without this patch we're building the
> arch-specific part in tools/testing/selftests/kvm/riscv even when we have
> an $(OUTPUT) directory (e.g. O=3Dbuild). Those build artifacts should be =
in
> build/kselftest/kvm/riscv instead.
>

Thanks for pointing it out. I will have a look in next week!

> Thanks,
> drew
