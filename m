Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC748C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C004B985;
	Mon, 12 Dec 2022 19:17:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p1PyQ1SVd1Ag; Mon, 12 Dec 2022 19:17:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 225304B966;
	Mon, 12 Dec 2022 19:17:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4213E4B92A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gWdNFXP2y7OE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:18 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 123B54B960
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:18 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 m16-20020a170902db1000b0018fa0de6aa6so2674583plx.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=xj/6XiZ0FcL9g/cIOTUKNxH2a5zHGMGnhonaffOKQyU=;
 b=Ynr5HNzm6tcPWug6yfLA7uxzPSFdxsDbFS0g0RKFnUjDpg1KpLtNRGj/Gf5/eVmZS7
 /E+4Syq2m0k2o5pz9jJkKOO6Sj8cSiSA59XiRJyOIRS4qCG3ooDGOujDsXFak0y3HWEH
 JVE64IrNpMB7KkNprBOvUTG/cEurYq5To2UJjMVj8f7IjF8u6mpzW6rAt4PhQmyqLhQB
 1i18xIcii3lgptRuB9CPP2XNPfFgre8ZBl8B6sbn4hkuTa1njt/nq23+dRz4CjgSzC33
 AdeV5GwIU5qK4qiw325lbgQvG6tA0I6pTb5gl4H3ZodnnRxzTiH/D2U7oooCiaGH4QZQ
 TQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=xj/6XiZ0FcL9g/cIOTUKNxH2a5zHGMGnhonaffOKQyU=;
 b=GyQDR347uxrkD131P3WFD4EipLA/EsCzDP1Jhg3BTRiwye/5cVyd35SVai8LhQkxB0
 rISE4vKP4kBrRfoP8hpLQdd7+MgGF0zaB9wfp1o7I7FNKP4hXebUlPtWORflBz9+bwW/
 +PjEmpgDj0JuQQwTXtNx+matzcEhtpcMzH6jX6dYLe+FwcJhxa+cC6FHMK/xQPmTdIuj
 9iOwshwK0/SzwBuTGzp8tuYHrqACUdb8gU7Yzgn+Uat9xFAAby5SK0s+0EuyjsGVfefi
 WsbnTxvzAlrg1W4Us2B9MAt/dg+CifyL/6Ax7tP0N6jvpMwEf37jtbPlaVrzHw2imox8
 xHEQ==
X-Gm-Message-State: ANoB5pn95INOtnTT4gjFaiYxBdLCGA0vQtaIYkbREEzqb5Js5r4LLO8t
 ikA/eyZ/QKRGBEXmhsG+G/ujxwQCd5s=
X-Google-Smtp-Source: AA0mqf7B6mgUqxDLQ3i89LPKmIpCGPzYFo4QfxqabC4YmJpdYxUAVEO/jE0NsIR7MXoyw3EdaxVTTeKRQcw=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1b21:b0:218:e3e8:c024 with SMTP id
 q30-20020a17090a1b2100b00218e3e8c024mr75063pjq.125.1670890637231; Mon, 12 Dec
 2022 16:17:17 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:51 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-13-seanjc@google.com>
Subject: [PATCH 12/14] KVM: selftests: Use wildcards to find library source
 files
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

Use $(wildcard ...) to find the library source files instead of manually
defining the inputs, which is a maintenance burden and error prone.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 45 ++++------------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 9cff99a1cb2e..a9930e9197da 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -19,44 +19,6 @@ else
 $(error Unknown architecture '$(ARCH)')
 endif
 
-LIBKVM += lib/assert.c
-LIBKVM += lib/elf.c
-LIBKVM += lib/guest_modes.c
-LIBKVM += lib/io.c
-LIBKVM += lib/kvm_util.c
-LIBKVM += lib/memstress.c
-LIBKVM += lib/rbtree.c
-LIBKVM += lib/sparsebit.c
-LIBKVM += lib/test_util.c
-LIBKVM += lib/ucall_common.c
-LIBKVM += lib/userfaultfd_util.c
-
-LIBKVM_STRING += lib/string_override.c
-
-LIBKVM_x86_64 += lib/x86_64/apic.c
-LIBKVM_x86_64 += lib/x86_64/handlers.S
-LIBKVM_x86_64 += lib/x86_64/hyperv.c
-LIBKVM_x86_64 += lib/x86_64/memstress.c
-LIBKVM_x86_64 += lib/x86_64/processor.c
-LIBKVM_x86_64 += lib/x86_64/svm.c
-LIBKVM_x86_64 += lib/x86_64/ucall.c
-LIBKVM_x86_64 += lib/x86_64/vmx.c
-
-LIBKVM_aarch64 += lib/aarch64/gic.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3.c
-LIBKVM_aarch64 += lib/aarch64/handlers.S
-LIBKVM_aarch64 += lib/aarch64/processor.c
-LIBKVM_aarch64 += lib/aarch64/spinlock.c
-LIBKVM_aarch64 += lib/aarch64/ucall.c
-LIBKVM_aarch64 += lib/aarch64/vgic.c
-
-LIBKVM_s390x += lib/s390x/diag318_test_handler.c
-LIBKVM_s390x += lib/s390x/processor.c
-LIBKVM_s390x += lib/s390x/ucall.c
-
-LIBKVM_riscv += lib/riscv/processor.c
-LIBKVM_riscv += lib/riscv/ucall.c
-
 # Non-compiled test targets
 TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 
@@ -213,10 +175,13 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 LDLIBS += -ldl
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
-LIBKVM_C := $(filter %.c,$(LIBKVM))
-LIBKVM_S := $(filter %.S,$(LIBKVM))
+LIBKVM_C := $(filter-out lib/string_override.c,$(wildcard lib/*.c))
+LIBKVM_C += $(wildcard lib/$(ARCH_DIR)/*.c)
+LIBKVM_S := $(wildcard lib/*.S)
+LIBKVM_S += $(wildcard lib/$(ARCH_DIR)/*.S)
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
+LIBKVM_STRING := lib/string_override.c
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
