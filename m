Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83B38A73F
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787606497; cv=none; b=olwScYINAhJmJiCKE1CuUA7jl/zHKhJv4yTSieAzTVGefApk4cpzGTsF0BmY1DbfVxgF6eBjA4YJ/jYSVwPe5SnH2T9ZJ7sUmSsTXlntUNDzKMJ628gZm//yHrIG8T6Wkup629XPra5jHRf0r0HQAE74OzPqnqNPBCWa1oS9K8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787606497; c=relaxed/simple;
	bh=Z+nC9E/REizDaGM/y1Zfk8lEpjdNkyuISxRBXNgQRvw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qzgR/QvZTFbChI3rimKfyiifjmC3HtSDnk7p0Gn0YuaWYTcGMxQSC5uYhDhUi6SY128OsLGXR+l3K5HVbmc1IJCqsEjgcYR3+WWmHnRdB00YKU6etmB3PHNWyNO5iG6gRxyrM2H7/KMsLR5MLJD5is6AEgo88OT2HJW0HlP6U1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J3w4mfEN; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J3w4mfEN"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848d21bbb55so6002357b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 14:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787606495; x=1788211295; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NU4DYUq1t/9abu87crupOiETuM25Ll46MNDzgrp8Cdg=;
        b=J3w4mfENTvmgBR7jre6FMU8DBouPiEx7rVM+F2t/so5LKamafwkQWwS/Vtj9OplgyJ
         DgF1YE4bdVoVMdsNIfJTWU1J9j3Pm8F4TV+o/lNp3LShIhZUewqFwSv7ZY9ynVhpTuUl
         /nc55/HOuv7GYBHFsxoMGlIPPLGg01Pi0gHNCZZF8Sudyvsf772RnHZnGJUpsOgy8Ewg
         +B+vfYpxku50DnOR2wkwd3XI9w2D1TRLqH12brwGYt1+GGJXZKIG7rkcJvc3oeb9i57j
         N7r5Lr9MHtniLgTybWQOMsQZFMURANZlOgwJjDFQZmOuMAZ4V09zYFqPPgJxvZ9yEnfK
         7Brw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787606495; x=1788211295;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NU4DYUq1t/9abu87crupOiETuM25Ll46MNDzgrp8Cdg=;
        b=tUpDpTelWCFKfyPDMvAR4b5Jg+fj3P++ALhpxjRvS8vBBKutGf8E10UlI0oqFBF141
         W9QlPvzn0shth+ysPDP/+fRMylO32XRoAaetPfjNCDj1WAn1MwnSrL38TBV9+ZhAbkBM
         NecvGnQgkj42FAgOC+7zlrrsCYLGiZmFdDtqJneQX5UEi9cD/+tRRVuNUtoSvXuqO98z
         CT2K3tJUYtc/ZHcnvedqPx6YAhr/6QAN76AwW200eMue9MxlO2xcivAolWr+BX+qtjo3
         Kj9eyFSXkCRHGmfaz6BWxhMcml9HwWxQlp7FNpZ4qDnYmV9Sw3phh77vL2cQzp6e5XBT
         nM9g==
X-Forwarded-Encrypted: i=1; AHgh+RrI2aeqw9K74E6FQm/IEpyXebgYNbZmqb8COQjk5N3rhy47zmaVpHSlbSz6D+TFg7tnTiZ1h0w=@lists.linux.dev
X-Gm-Message-State: AFuF++m+3kFMMh9OM8Z/Ll2ceFgNz5TrJSPGwmcGA31dLxUQacoMLGjP
	ogkUlbX4vtO7hA0mjJ02cOjqlV+4g1rmXNJuG1Ae11UZ4i8xoopUPzOQaYoYJIMQSpGC2T5Y46x
	UvrjgTw==
X-Received: from pfoi3.prod.google.com ([2002:aa7:87c3:0:b0:847:9805:8254])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:398a:b0:84e:2722:5d9e
 with SMTP id d2e1a72fcca58-851f9bb5de5mr47827595b3a.1.1787606494792; Mon, 24
 Aug 2026 14:21:34 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:21:34 -0700
In-Reply-To: <20260820220340.GC618052.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-9-vipinsh@google.com>
 <ampPd9szwRoGKwds@google.com> <20260820220340.GC618052.vipinsh@google.com>
Message-ID: <aoy13na7ceOOeh0K@google.com>
Subject: Re: [PATCH v4 8/9] KVM: selftests: Add rule to generate default tests
 for KVM selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev, 
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 20, 2026, Vipin Sharma wrote:
> On Wed, Jul 29, 2026 at 12:07:35PM -0700, Sean Christopherson wrote:
> > @@ -347,15 +345,13 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
> >  $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
> >         $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >  
> > -# Default testcases for KVM selftests runner will be generated in this directory.
> > -DEFAULT_TESTCASES = testcases_default_gen
> > +TEST_FILES := $(selfdir)/kvm/runner
> 
> Downside of this one is that if someone is not planning to use runner they
> will still get this directory copied.
> 
> Should we instead add 'rsync -u' in 'testcases' rule below which can copy
> runner only when it is updated or not present? This would be similar to
> original patch but instead of 'cp' it will be 'rsync' command. This will
> also copy runner when someone is explicitly using it.

Hmm, but someone could be using the runner without (re)generating the default
testcases.  We could add a "runner" target, but that seems like overkill.

I'm good with either option, but I think my vote would be have the runner get
copied on install, i.e. just do the "TEST_FILES := $(selfdir)/kvm/runner" above.
But again, either way works for me.

> I think we should also include 'tests' directory which we are using for
> custom testcases and they also .

Heh, they also what?

> >  EXTRA_CLEAN += $(GEN_HDRS) \
> >                $(LIBKVM_OBJS) \
> >                $(SPLIT_TEST_GEN_OBJ) \
> >                $(TEST_DEP_FILES) \
> >                $(TEST_GEN_OBJ) \
> > -              $(OUTPUT)/$(DEFAULT_TESTCASES) \
> >                cscope.*
> >  
> >  $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
> > @@ -386,21 +382,18 @@ cscope:
> >         cscope -b
> >  
> >  # Generate runner testcases in DEFAULT_TESTCASES directory.
> > -# $(OUTPUT) is either CWD or specified in the make command.
> > -tests_install: list_progs = $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS))
> > -tests_install:
> > -       $(foreach tc, $(TEST_PROGS), \
> > -               $(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(patsubst %.sh,%,$(tc))))
> > -       $(foreach tc, $(TEST_PROGS), \
> > -               $(shell echo $(tc) > $(patsubst %.sh,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> > +DEFAULT_TESTCASES = default_testcases
> > +
> > +testcases: list_progs = $(notdir $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS)))
> > +testcases: install
> > +       $(foreach tc, $(notdir $(TEST_PROGS)), \
> > +               $(shell mkdir -p $(INSTALL_PATH)/$(DEFAULT_TESTCASES)/$(notdir $(patsubst %.sh,%,$(tc)))))
> > +       $(foreach tc, $(notdir $(TEST_PROGS)), \
> > +               $(shell echo $(tc) > $(patsubst %.sh,$(INSTALL_PATH)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> >  
> >         $(foreach tc, $(list_progs), \
> > -               $(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(tc)))
> > +               $(shell mkdir -p $(INSTALL_PATH)/$(DEFAULT_TESTCASES)/$(tc)))
> >         $(foreach tc, $(list_progs), \
> > -               $(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> > -
> > -       @if [ ! -d $(OUTPUT)/runner ]; then             \
> > -               cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
> > -       fi
> > +               $(shell echo $(tc) > $(patsubst %,$(INSTALL_PATH)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> 
> All looks good here.
> 
> Should I send a next version of this series with the changes you have
> suggested or you wanna take the diff you created and apply before merge?

Go ahead and send the next version.  Given the number of tweaks, it'd be helpful
to be closer to WYSIWYG.  My changes are at:

  https://github.com/sean-jc/linux slf/runner

if you want to use that as a reference and/or grab changes directly.
