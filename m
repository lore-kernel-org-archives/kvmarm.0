Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E14EC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5429F4B95C;
	Mon, 12 Dec 2022 19:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s2xukrcTrzWA; Mon, 12 Dec 2022 19:17:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1CA4B96A;
	Mon, 12 Dec 2022 19:17:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373214B93C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wAhHTprrgZKJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:09 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37D404B942
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:07 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 f8-20020a170902ce8800b00190c6518e21so122910plg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=D3yaa5g0NwvoDvpQDylnRiNRa9Y4EAt+LrRkX+7F7+YmH44+rWEpJb8iHDHtMMe6oP
 Is2tHGfvLglA53BKU3LqyI6YsfeYw8+ERYyz4qghWYKdCtAPPI4SVdqs5nVpNFcAJ6jX
 8s5i4ZWxkThtZUzQg8MjjpxK1UXcY1tfTFCpzulER9mNGw55813/bgw4Anzx86z3zyjd
 V6lKC1L8sfLS5c9+d8nDwKolgcZYP/GxfiPC3UhCOFMdVCCXiIuOiKtr5xeUON3I2YgE
 u5/DYUWe0it2XuG+X9KQMu+gN60O/bC5S1nXHhr0yAQF86fP93f5b+UNrG7LxqKOQ5Ar
 Flxg==
X-Gm-Message-State: ANoB5pk2LYxdcDEGZl1ak4p2V68dGfG98dLsSBPf76bchNAPst8fFE0r
 sMF+C/jUgymhvGaNyeuXKYNZDLaXJSk=
X-Google-Smtp-Source: AA0mqf6x4MZJ4SJmtkdTS02X8t4NKcxtNfIcDJg0D7JOLNgsuOwcq0N0mfjb/DHFRBiMDDUKbvP/3oiNhVU=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3556:b0:219:f1a2:b641 with SMTP id
 lt22-20020a17090b355600b00219f1a2b641mr97398pjb.97.1670890626870; Mon, 12 Dec
 2022 16:17:06 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:45 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
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
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
