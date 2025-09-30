Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14422246BB0
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250224; cv=none; b=SUI7AfqqXeB98RaPi8J42IWcjjdI5v9IguH0DVBi5Dhl3JmKGXw5aPrimzf0Xd1J18Z+DN5U3OvZ2dRlDFW3tFqnr4mLDIigb3Z+o211VxCycT2AfJnqwOC7ZOzAx1kpTk4G+BCLbvoE2y5PuaivnwlFKzcIhU3c6SrhYZl7nwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250224; c=relaxed/simple;
	bh=ht7r0j9TStYFSS39J6A9S6LE0usVn0dEUwTN+cHJek4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nudNNQ3/o2o9oRFl5r6VZsOgUU9Nv7287XPXOYZhckfY82+hnPKL7ZL4l8CxNynanVPrUvg4TvlFa8RBTupoZjyDVbT/1quLGzreJXXEfU1WeRt3qmk5xaYprPLa87PoJaiPNwpm8y1mul/yg4nT1sn2QWijjxiF6gotpyoRyhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3erxs4t+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3erxs4t+"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-335276a711cso5602195a91.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 09:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250222; x=1759855022; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDB4Bxe6YCqhMG0texjm2F7bd+t0DxvCH5y7s56NZ8g=;
        b=3erxs4t+zEG+Sgn0oiwZSv5iCvDdN52IrDblTrMkgvEIZH09x95f5wDCZoW+pzwIZg
         Jiz/SWbTnqzWTAyN6dOaUZ39mf4EaaRyCMA6hJDwcV1wZ0fX9Gio8CNo3Ln703U8ZGaG
         F05mBTX5eBTJ5c06DLNxDkdAXJOpyW3h00gsBpxFpxHata2GD9/YGxwjdAS6PP8qLcs4
         rR69gc9xkse4OK/suG6/gCvDVB/q2ccBdtcMpprPrMY1XOBtaG7Bkssvko8x0jXv3AxE
         StnfO8Wl5fmS5776Nmai3ol2p9qYCL0Mk3ajT12tC9l6NXoVskUAy08SqWM2D94CxOVd
         NfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250222; x=1759855022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDB4Bxe6YCqhMG0texjm2F7bd+t0DxvCH5y7s56NZ8g=;
        b=CmElmVVsmHF/MAC7C5cLJ6ahf3lFaCBelDYozDlIr8WvxpKegoV5o+3t6pGOwAH128
         UAXMcdS0LrWPbskZv0JQkDnFjXZi2tFLcZ7/OffQdUUW27sisy5AuseM9aTFMrEhq8W4
         zHVUzNDXDi9FfXeLMfQD/rKtC5MCWj3aeGAeNRzRI+TnFQTmckycYFjri3UP4kxFo0A3
         viK1Weq2DzTrKyy1F45pchVFeVxFT9HIe2+merfoLw0Cjw0xFCdq8LRH5dgofck+8lvC
         TDnU0MiWtrVuvpTHMlv2ufg2nUHnB/ssDSD+MJfYkhUnst4K6YE/2aYFpHHwVFr7nmY1
         Fslw==
X-Forwarded-Encrypted: i=1; AJvYcCXFiMyPtYa9rgbzCajTiEhtqfGvTGfBE9gy8OSHq1y7XkSgMJF85yftJjhhK4517lea1o+easU=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo6v0Jy7T6/q7GO1CWq9UFm3uCQhKJL30VZi8G2t1NkBXL8KVw
	3d/jmoct1r0Dm7A0XIK9Q4dwg/Db6oR2Y43KBlizlg9Sr4IpOrUdGfPxIvv/LwAhYlDSnT5P5i7
	vtbLDXAyPZw==
X-Google-Smtp-Source: AGHT+IFH7MY9VunA10xfm7S9xXyjqnmpJ9IaA0KI2bTcJ1mC7PTk9P775POawCgRman2ri0lXRnMzI5UF9gA
X-Received: from pjbcz15.prod.google.com ([2002:a17:90a:d44f:b0:327:e021:e61d])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a92:b0:334:29f0:a7e4
 with SMTP id 98e67ed59e1d1-339a6f36cbamr103438a91.21.1759250222318; Tue, 30
 Sep 2025 09:37:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:34 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-9-vipinsh@google.com>
Subject: [PATCH v3 8/9] KVM: selftests: Add rule to generate default tests for
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
 tools/testing/selftests/kvm/Makefile.kvm | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

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
index 41b40c676d7f..6bb63f88c0e6 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -306,11 +306,15 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
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
@@ -339,3 +343,19 @@ cscope:
 	find . -name '*.c' \
 		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
 	cscope -b
+
+# Generate testcases in DEFAULT_TESTCASES directory.
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
+	@:
-- 
2.51.0.618.g983fd99d29-goog

