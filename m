Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33F37F
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 00:17:17 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id pi14-20020a17090b1e4e00b0021d20da7a51so1046781pjb.2
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=UpbEJSktVlV8WtdGkznxg9KVtEAY0X8w+HMZHsYA3UJ55rHAcrGkWvyqU0URE4tegs
         pqei/fesVjAgDSktGnykSXau5Dyjj2bg129MyYC9AT4nRCvbiqv+irRZKViNvkDZbUfP
         N4nhkwgMOpH8n0zy7S+eW/fN/6nBMucAoCH0XHeuv5CdYPpuRKpQz0eTcVh3BgGgugs4
         TD1mZk0sMU/f4x4f/59yHNEroTrnc6UN4uIWPpZxQhHP03+BhOd2qoN/KPGJ7if4epUE
         c4rYFg2yOmMLXV+qy7YXdyRnvxlXB9VX91pJvA9O6woZGtG3BVeVzLCFzlm1XhmFq6y4
         CnYA==
X-Gm-Message-State: ANoB5pl2ozYiep0/8ZasmYxfK/W0ieKczaqgiZmZv4/8FZ6ghTdBwxu8
	dPaU0+YKOzSNeRjHjls2y1u5upsXh2E=
X-Google-Smtp-Source: AA0mqf7B6mgUqxDLQ3i89LPKmIpCGPzYFo4QfxqabC4YmJpdYxUAVEO/jE0NsIR7MXoyw3EdaxVTTeKRQcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1b21:b0:218:e3e8:c024 with SMTP id
 q30-20020a17090a1b2100b00218e3e8c024mr75063pjq.125.1670890637231; Mon, 12 Dec
 2022 16:17:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 00:16:51 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-13-seanjc@google.com>
Subject: [PATCH 12/14] KVM: selftests: Use wildcards to find library source files
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
Message-ID: <20221213001651.XoIn6WI5ZLutweUia3yKCISjsNdrd4gc1yVqKZQ14oc@z>

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

