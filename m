Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0083AAF5C
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352058; cv=none; b=PB1JZqw0nu7tEtu1DR/8rNilGXoTVJaBjcE6EW8NxJH4yMKOjDHToVuOi+Gk+ZM3pWGUMlFvlSBRLobY71gY2/pcSi4bd4ST5Ar0pkWsDTpRGP7UCU+jjcxO4atRPprsKoKL2Cik/sLm9hSuezPPcqxvdHfxK3fSpubUkaJnLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352058; c=relaxed/simple;
	bh=LKYqShh5kW9f4WPAvBmBeOlwPHlAX562WP4sa2zLm6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OEC1DKVfUNlcOgrrh0sugRPR1meHDvNYiFqtViCzVq9i6ZCYQ47fOyb7dqg+v23QE0MJ44827zfNdtVBDswNy9jcTiUrzayzzixD0+12LGbixaHsBjj1o0hTDQK2in/TbLBBgZm/elJ9+5mHoNE/RzVMBr9d2ZSFY+1TQAhIm0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EO1tB6Do; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EO1tB6Do"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e3d575d6eso2338958b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785352056; x=1785956856; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2b3fQxiZ8vmEMZ/LriNEMYs2OUmWmCeVFavLD+6FbmM=;
        b=EO1tB6DoMC+Ub0lKzc2CigA1bgktpauymnXbRByhFFc7WxMy0w13ckmkDjKTc5RW19
         zZ1ouySvg35bEQ5rQ9HxprS+r4oHSDFRBW67zJPajEh0umcKicxLjKRTX6AH0FGk5sAc
         oPPMNqLq32R/Q7bs0o1v8aSgqsbAME7xHzup+Lt7mBfQgDMrdY9eFgdl9FhVTmjrp09G
         /4iCsFTZ2Fw1n7JKqcpqDOjEZaMA0jS1h33xhq18PuXHkZlxRaAM+tKsa8vobJllEfrt
         50b7G1chf9AlWIDVnO56MvWW51vxrpgOpLgndZ653vSAh/a8rKHeZzNAzxO4+44Ashsl
         MkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785352056; x=1785956856;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2b3fQxiZ8vmEMZ/LriNEMYs2OUmWmCeVFavLD+6FbmM=;
        b=ohWKy54zCKH8g+EKK49ovegnjTE7C+CL6xQn1DRImDr5d3ZFC51nmIkHA2Ap86a7Ed
         VN41hcmI+10hz/fy8wlAwAfPTC5m7R8bEvtS8uhPOzqT89hl1squswTiNsWqB+71CS1m
         323uogXsgDLBvEWxIqvuN8jL6LXtG4yVEn4oEELydGWQuP+u349LeF904ChSpeIHAZS/
         qQw+WlORj2ITX2w0aPXU06JGJhPvZXLXsikSL9Mi/eNvbYh3aI7VlV12rjwgp67GDx4h
         G4L5e7AUfKcTDYVU56bhfJtfC/zZk45pM2PZjHPCEtg64pjeB9o4kQ3XAwWr8PXlpZ2u
         82mA==
X-Forwarded-Encrypted: i=1; AHgh+RqjI5cmbxQywtQmD5GgfItaoMQ9tcBnmY3ccQH6x6fGFWxG8IdSc1PZhJlTpyb5N8dyqJ/4XWE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSmXYmuWNntkEfI6/hfp9sFWi1ofZUpwRAKXvPbpaLDSGOM29m
	2Zj0vpc5JxkxUG4N/xDFoguOJYlcHBkNCxcT/mF7BhE4ijAl9VjEjhRYPRtFsEQDNxU9avqT/XD
	9LDw/uA==
X-Received: from pfblc11.prod.google.com ([2002:a05:6a00:4f4b:b0:84a:894f:23e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:391d:b0:848:56d4:3288
 with SMTP id d2e1a72fcca58-84eb9e86fccmr34880b3a.4.1785352055899; Wed, 29 Jul
 2026 12:07:35 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:07:35 -0700
In-Reply-To: <20260331194202.1722082-9-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-9-vipinsh@google.com>
Message-ID: <ampPd9szwRoGKwds@google.com>
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

On Tue, Mar 31, 2026, Vipin Sharma wrote:
> Add 'tests_install' rule in the Makefile.kvm to auto generate default
> testcases for KVM selftests runner. Preserve the hierarchy of test
> executables for autogenerated files. Remove these testcases on
> invocation of 'make clean'.
> 
> Autogeneration of default test files allows runner to execute default
> testcases easily. These default testcases don't need to be checked in as
> they are just executing the test without any command line options.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore   |  1 +
>  tools/testing/selftests/kvm/Makefile.kvm | 26 +++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 95af97b1ff9e..548d435bde2f 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -7,6 +7,7 @@
>  !*.S
>  !*.sh
>  !*.test
> +default.test
>  !.gitignore
>  !config
>  !settings
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 6471fa214a9f..fb9439cb5f3d 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  include ../../../build/Build.include
>  
> -all:
> +all: tests_install
>  
>  LIBKVM += lib/assert.c
>  LIBKVM += lib/elf.c
> @@ -330,11 +330,15 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
>  $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> +# Default testcases for KVM selftests runner will be generated in this directory.
> +DEFAULT_TESTCASES = testcases_default_gen

That's a cumbersome name.  It was also written by Yoda :-) How about default_testcases?

> +
>  EXTRA_CLEAN += $(GEN_HDRS) \
>  	       $(LIBKVM_OBJS) \
>  	       $(SPLIT_TEST_GEN_OBJ) \
>  	       $(TEST_DEP_FILES) \
>  	       $(TEST_GEN_OBJ) \
> +	       $(OUTPUT)/$(DEFAULT_TESTCASES) \
>  	       cscope.*
>  
>  $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
> @@ -363,3 +367,23 @@ cscope:
>  	find . -name '*.c' \
>  		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
>  	cscope -b
> +
> +# Generate runner testcases in DEFAULT_TESTCASES directory.
> +# $(OUTPUT) is either CWD or specified in the make command.
> +tests_install: list_progs = $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS))
> +tests_install:

This is very much *not* an install.  In fact, install is broken, because the
runner isn't added to TEST_FILES.

Another issue with install is that it flattens the directory structures, i.e.
drops the $ARCH/ subdirectories.  That causes issues for the default.test testcases
due to them using partially qualified paths.

And coming back to this with fresh eyes, I don't love generating the testcases
for the "normal" build.  It necessitates adding default.test to .gitignore,
effectively requires copying the runner to the output directory, and is pure
noise for folks that don't want to utilize the runner.

Rather than generate testcases for the default build, what if we make this 100%
opt-in, and take a hard dependency on install?  That should obviate the need for
ignoring default.test, because if someone is silly enough to install testcases
in the source tree, they get to deal with the noise.

And we can commit to having the default testcases provide completely unqualified
paths, so that the Just Work with the flattened output.  If someone wants to run
with an unflattened tree, then we should update the runner itself to handle
multiple paths, a la the actual PATH variable.

The other nice thing is that we can make the runner opt-in, without requiring the
user to run multiple make commands, by chaining testcases => install => all.  If
we try to generate testcases as an optional step to the normal build, then we'll
end up being able to run install without having generated the testcases, which
is "fine", but probably not what we want for people that are trying to use the
runner.

The obvious downside is that it requires doing an install to get the default
testcases, but IMO that's an acceptable tradeoff.

> +	$(foreach tc, $(TEST_PROGS), \
> +		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(patsubst %.sh,%,$(tc))))
> +	$(foreach tc, $(TEST_PROGS), \
> +		$(shell echo $(tc) > $(patsubst %.sh,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> +
> +	$(foreach tc, $(list_progs), \
> +		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(tc)))
> +	$(foreach tc, $(list_progs), \
> +		$(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
> +
> +	@if [ ! -d $(OUTPUT)/runner ]; then             \

This is very wrong, as this will fail to pick up any changes made to the runner.

All in all, this as fixup?

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 83aa2fe01bac..91d2b21d396f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -8,7 +8,6 @@
 !*.S
 !*.sh
 !*.test
-default.test
 !.gitignore
 !config
 !settings
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index c5821d495ea6..fc9dc41fdbeb 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -1,8 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../build/Build.include
 
-all: tests_install
-
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
@@ -347,15 +345,13 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
 $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
        $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-# Default testcases for KVM selftests runner will be generated in this directory.
-DEFAULT_TESTCASES = testcases_default_gen
+TEST_FILES := $(selfdir)/kvm/runner
 
 EXTRA_CLEAN += $(GEN_HDRS) \
               $(LIBKVM_OBJS) \
               $(SPLIT_TEST_GEN_OBJ) \
               $(TEST_DEP_FILES) \
               $(TEST_GEN_OBJ) \
-              $(OUTPUT)/$(DEFAULT_TESTCASES) \
               cscope.*
 
 $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
@@ -386,21 +382,18 @@ cscope:
        cscope -b
 
 # Generate runner testcases in DEFAULT_TESTCASES directory.
-# $(OUTPUT) is either CWD or specified in the make command.
-tests_install: list_progs = $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS))
-tests_install:
-       $(foreach tc, $(TEST_PROGS), \
-               $(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(patsubst %.sh,%,$(tc))))
-       $(foreach tc, $(TEST_PROGS), \
-               $(shell echo $(tc) > $(patsubst %.sh,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
+DEFAULT_TESTCASES = default_testcases
+
+testcases: list_progs = $(notdir $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS)))
+testcases: install
+       $(foreach tc, $(notdir $(TEST_PROGS)), \
+               $(shell mkdir -p $(INSTALL_PATH)/$(DEFAULT_TESTCASES)/$(notdir $(patsubst %.sh,%,$(tc)))))
+       $(foreach tc, $(notdir $(TEST_PROGS)), \
+               $(shell echo $(tc) > $(patsubst %.sh,$(INSTALL_PATH)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
 
        $(foreach tc, $(list_progs), \
-               $(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(tc)))
+               $(shell mkdir -p $(INSTALL_PATH)/$(DEFAULT_TESTCASES)/$(tc)))
        $(foreach tc, $(list_progs), \
-               $(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
-
-       @if [ ! -d $(OUTPUT)/runner ]; then             \
-               cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
-       fi
+               $(shell echo $(tc) > $(patsubst %,$(INSTALL_PATH)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
 
        @:

> +		cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
> +	fi
> +
> +	@:
> -- 
> 2.53.0.1118.gaef5881109-goog
> 
