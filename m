Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030A43E317F
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 19:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986149; cv=none; b=TLyC6wR3ochqkxKoy8zG6pBnvpc434GokG50Q5lVUELZ0UcXwPlXkWG7IAWiKeacFTx4RwUVi5EJGpsaRCbOdn29qbSUSWTh8N6fMHqQUmXHOTBFMhVJ7oeKWz7bionesNwDTLxqXPKY9/2eLLo6gfKsMsah2PbovTTjFCfslPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986149; c=relaxed/simple;
	bh=uI0SPO45nQ55zfm6jOzEO7zUNIVAxE6AaTYr9tc1xrw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OVVUiP5Gc8BgQsft4vIhfQ59S+e7pK+ExAlqK2J4T4gKb3O/pEbsL6IrFfohTv30njYeAmZDszF5B4leRuoPfjLEmRCzcy/HZ8FBNZk7k5vj2uZI1iZf4kflrEiph2hd8fxuB+hXg2HNvhdfp3aiW/uumN6hs+S5VAbTwEFdTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c2q35KoV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c2q35KoV"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35d9e67f6dcso8953104a91.1
        for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 12:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774986147; x=1775590947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EMAEEYc33pbDyh5jLNn4+2ckaUXnuUr3hoaO2wyMBMY=;
        b=c2q35KoVKaczWCz487Y2O6zsnbmqXXAAgZ0NXirV68/p4UkdbhTjofEYT3XoF8sBjG
         BKyE0lOmP9s0hAXvh2nB3rmjZ4DJQXwLzFLX8BpvkGrZ5W4FcqaLuNLVkcFO6JECxerF
         HF3g9xGcyneZ1z/P2efBkQ14P9mr5OKBvO3wQn4AC1WK0PPw3HVbVVdV0TKKaSUVMUuL
         GxZUpHFZ8eligF8UdKP8etWAWwL5gANk7SqOvBU5o13sm3CdLbb5EgauClAWzC/GExnd
         xhs7hBdZBQvoUnO6mvrm5hJFPYNR5/FVD4jQTojnl4q7E/s45nNL+HtF5EV5li2rVmuJ
         vo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986147; x=1775590947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EMAEEYc33pbDyh5jLNn4+2ckaUXnuUr3hoaO2wyMBMY=;
        b=rQGpKIUiqFUtYEvw0SGNJs7oxPsXc7OTY0VY3uvdSqyo0FiSISkkiHwvp/hYTlMQGq
         bCd1BpTz/oed2iK9qpKr90zSl/A/tk56Ba8rnJdS13/Bl8hYcP7WRl3xTTWKNRarMNJV
         gViY1FY+JsFupB0ec9Lnqc2qjYpnpbY4GwgssiV4NkEc7ZYgF1PglGSSeTEpz1PvW4+r
         +USRK/5rTyd/Z6bZr4B1Pz+xdiet63qv3v47DVWB/GgZSl8+sHGYegpHBs6Wa/eI+bWE
         FjKfoIQo3JMOTNiwtqZFKBQme/pymRNGElARik98sUkFhmetpV0LdwkwH4QQubbr9Eo1
         lpdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsxYTOJ7FcgsYnlCs8aBpeyE5waFZxvk6dH2Y9EduspCYJrRBh3sbLOzTcK/YXCQfFSfVaeMg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB6aSJQXvnXknBhmGwe6yQTYfQ89tnAuFaQBXezD8r4TioVf7k
	F/YvOgeZv5Fw33XTN09BNHS/zU339ZJJsmNQFoHi9a+MUutMINQsso+nDQPJ1zD0Z9tO0NefHsK
	YvYgKfniJ1g==
X-Received: from pjpe5.prod.google.com ([2002:a17:90a:9a85:b0:35d:9d42:3153])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1850:b0:359:ff8a:ee4f
 with SMTP id 98e67ed59e1d1-35dc6e9bc88mr571073a91.7.1774986147217; Tue, 31
 Mar 2026 12:42:27 -0700 (PDT)
Date: Tue, 31 Mar 2026 12:42:01 -0700
In-Reply-To: <20260331194202.1722082-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260331194202.1722082-1-vipinsh@google.com>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
Message-ID: <20260331194202.1722082-9-vipinsh@google.com>
Subject: [PATCH v4 8/9] KVM: selftests: Add rule to generate default tests for
 KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add 'tests_install' rule in the Makefile.kvm to auto generate default
testcases for KVM selftests runner. Preserve the hierarchy of test
executables for autogenerated files. Remove these testcases on
invocation of 'make clean'.

Autogeneration of default test files allows runner to execute default
testcases easily. These default testcases don't need to be checked in as
they are just executing the test without any command line options.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore   |  1 +
 tools/testing/selftests/kvm/Makefile.kvm | 26 +++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 95af97b1ff9e..548d435bde2f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 !*.S
 !*.sh
 !*.test
+default.test
 !.gitignore
 !config
 !settings
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6471fa214a9f..fb9439cb5f3d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../build/Build.include
 
-all:
+all: tests_install
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
@@ -330,11 +330,15 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
 $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
+# Default testcases for KVM selftests runner will be generated in this directory.
+DEFAULT_TESTCASES = testcases_default_gen
+
 EXTRA_CLEAN += $(GEN_HDRS) \
 	       $(LIBKVM_OBJS) \
 	       $(SPLIT_TEST_GEN_OBJ) \
 	       $(TEST_DEP_FILES) \
 	       $(TEST_GEN_OBJ) \
+	       $(OUTPUT)/$(DEFAULT_TESTCASES) \
 	       cscope.*
 
 $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
@@ -363,3 +367,23 @@ cscope:
 	find . -name '*.c' \
 		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
 	cscope -b
+
+# Generate runner testcases in DEFAULT_TESTCASES directory.
+# $(OUTPUT) is either CWD or specified in the make command.
+tests_install: list_progs = $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS))
+tests_install:
+	$(foreach tc, $(TEST_PROGS), \
+		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(patsubst %.sh,%,$(tc))))
+	$(foreach tc, $(TEST_PROGS), \
+		$(shell echo $(tc) > $(patsubst %.sh,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
+
+	$(foreach tc, $(list_progs), \
+		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(tc)))
+	$(foreach tc, $(list_progs), \
+		$(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
+
+	@if [ ! -d $(OUTPUT)/runner ]; then             \
+		cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
+	fi
+
+	@:
-- 
2.53.0.1118.gaef5881109-goog

