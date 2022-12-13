Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641B15B0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:07 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id u10-20020a17090341ca00b001897a151311so11550410ple.8
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aL+0YmMhUjGpxjB47w5qgiiQkK7wv4sJmU0mewoCPIk=;
        b=lXE9d6/lTyMaKAp9TWJ0VTH9OHNc6LWhK3blKtxoKuILCiWADb0CbU6Rsydob/gcil
         wHxIvfaDWuGlNvVquRWIv4yx5W+yznz7XM7a86CW8GDjqkZqbRCaIw2dz/EezUpsk1tU
         yj25I60njVb9EbdEvsJxtZS9+k7pDY33PzcH/LvsH4P5XlXsQXH7IoqjcG6Ie7dJ8g9T
         bujmb8hmgj/76jRObLTv9oiy9I32bf42pKVaFt8Dttopr1DOXN3wMxL93QijMNc8Zro1
         fKhDmxLqJgYkJDp2BLZwakAToojNx+YfT0/EJedWbNtVv2az4c/koY91ZlwuaKe+3P20
         zbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aL+0YmMhUjGpxjB47w5qgiiQkK7wv4sJmU0mewoCPIk=;
        b=XaVIxtQOp62YpP6W4HkiA9qdwx9eggeUFBLzgrKva6/otZgOOmzk5ihQfQgSKCKAZm
         C1eGVX+EnLhSX5PYfixevMS0M/SWEMKHXkMF87hyAH7i8Ow9Z0ocdDEfCy7grPK6xDlR
         Vqwpd6pKCu5+X820kfzJQzWFUIh1PtruOWjlwiOXaHz33Owc0MidCg8hqWu8sKYIgYv4
         jyE9Z5sverfRF9TfG/TZtwTdQCuIp42suguMZG+YdX8Whg5JFk56Y2DW77EMf7GJ8E8C
         8fBcevYa9YOacahluDdMqd8k0L0s8xIOr/0rlyOt54OiAnycCKM5T72HW4GaFSdVQfIr
         Udqg==
X-Gm-Message-State: ANoB5pkbcu8MUOm5cBD8uC638vhlIOCZYrgFQoXJKNeeCdMsBxm4dlNq
	+nZB40oTWlldrVMCs+399rfKxtbqh6M=
X-Google-Smtp-Source: AA0mqf6x4MZJ4SJmtkdTS02X8t4NKcxtNfIcDJg0D7JOLNgsuOwcq0N0mfjb/DHFRBiMDDUKbvP/3oiNhVU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3556:b0:219:f1a2:b641 with SMTP id
 lt22-20020a17090b355600b00219f1a2b641mr97398pjb.97.1670890626870; Mon, 12 Dec
 2022 16:17:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:45 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-7-seanjc@google.com>
Subject: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Tom Rix <trix@redhat.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>, 
	Sean Christopherson <seanjc@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221213001645.PiwHKNnjhFwU6NGUyXJjSqEuyzD3Ud9kzxlSzni_37g@z>

Rename UNAME_M to ARCH_DIR and explicitly set it directly for x86.  At
this point, the name of the arch directory really doesn't have anything
to do with `uname -m`, and UNAME_M is unnecessarily confusing given that
its purpose is purely to identify the arch specific directory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 49 +++++++++-------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 947676983da1..d761a77c3a80 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -7,35 +7,16 @@ top_srcdir = ../../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH            ?= $(SUBARCH)
 
-# For cross-builds to work, UNAME_M has to map to ARCH and arch specific
-# directories and targets in this Makefile. "uname -m" doesn't map to
-# arch specific sub-directory names.
-#
-# UNAME_M variable to used to run the compiles pointing to the right arch
-# directories and build the right targets for these supported architectures.
-#
-# TEST_GEN_PROGS and LIBKVM are set using UNAME_M variable.
-# LINUX_TOOL_ARCH_INCLUDE is set using ARCH variable.
-#
-# x86_64 targets are named to include x86_64 as a suffix and directories
-# for includes are in x86_64 sub-directory. s390x and aarch64 follow the
-# same convention. "uname -m" doesn't result in the correct mapping for
-# s390x and aarch64.
-#
-# No change necessary for x86_64
-UNAME_M := $(shell uname -m)
-
-# Set UNAME_M for arm64 compile/install to work
-ifeq ($(ARCH),arm64)
-	UNAME_M := aarch64
-endif
-# Set UNAME_M s390x compile/install to work
-ifeq ($(ARCH),s390)
-	UNAME_M := s390x
-endif
-# Set UNAME_M riscv compile/install to work
-ifeq ($(ARCH),riscv)
-	UNAME_M := riscv
+ifeq ($(ARCH),x86)
+	ARCH_DIR := x86_64
+else ifeq ($(ARCH),arm64)
+	ARCH_DIR := aarch64
+else ifeq ($(ARCH),s390)
+	ARCH_DIR := s390x
+else ifeq ($(ARCH),riscv)
+	ARCH_DIR := riscv
+else
+$(error Unknown architecture '$(ARCH)')
 endif
 
 LIBKVM += lib/assert.c
@@ -196,10 +177,10 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
-TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
-LIBKVM += $(LIBKVM_$(UNAME_M))
+TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
+LIBKVM += $(LIBKVM_$(ARCH_DIR))
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -212,7 +193,7 @@ endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(UNAME_M) -I ../rseq -I.. $(EXTRA_CFLAGS) \
+	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
 	$(KHDR_INCLUDES)
 
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
-- 
2.39.0.rc1.256.g54fd8350bd-goog

