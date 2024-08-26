Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE051993B0
	for <kvmarm@lists.linux.dev>; Mon, 26 Aug 2024 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698890; cv=none; b=DGD3Dnc2+1k6kPHGdD425+kEsmqKfvy2Tj2s6hGf9NVeLdIJUrWFxZRr4iOWJh8jZ2QtajlOZ8rXWpm58sMktX0AllGfj5t2dfmQVjyToNyz7gqN/hQogn0I8Kl/JvfblVgPgvcb3VTfmSIeTy4THyr5pVAgtlxLchIooHpHlrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698890; c=relaxed/simple;
	bh=Lk53fKPoiIBMswuBHQk1iCnTGbDOOstP2qQpL1OIsUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=undZbaUMSDd1qn7qCnzNF/ARrjseb9ijOxCZaV94CeY/5QOklTyqwtuWaa5yV9vKKb2x/eJ7np3oazzacaFU3WDuiKtf0O86YDtGsUMAbpUAbKYxVP78TCJhDwvtaxEKJqkZTP4/SRytZAYy7ik1mqjhV2EDk2xn4+ZuBymUXLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQFyj6Zy; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQFyj6Zy"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e164ceba5ffso7783031276.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Aug 2024 12:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724698887; x=1725303687; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wlfMvk8YP/kQvzhrtnMiI9Fgfb/TBne1V0LIqcoAt2M=;
        b=kQFyj6ZyMlq48beOywqgEgt7J7oLUYOK3A31fovgY12vZjwCrRi7mNLnb4xGoq4ph5
         2eSMJzd+6yoTYyx7CzfenVWNeGB7UonjwLTeXi1J71wTm6HMRxCn4pCY8dL9YnSMTCEz
         hBrce0xBiyeVN+3YhKL4X5WAE8PEG3/r7jkBpEXFnP0tje+uOp///KYwbOL+JufRVZ+o
         BrWPTkTLJgedUU+ptHK7t5NQr/msSKUBlsY0B6xy/9lhVe8igv3HK0C6Jpe0B5Rxovcf
         QvNW3THHVmRAw71WsdPkUocWYduGtRgXclQQnx3udEoTX/FScBR/bmoMcSyUeUdvtusR
         Yt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724698887; x=1725303687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wlfMvk8YP/kQvzhrtnMiI9Fgfb/TBne1V0LIqcoAt2M=;
        b=i7mxpqcZ9qNPnNCFwRIYVVWB1uyIZorAaB5KWwY6OJSH78d4Ndkv8n1wPPJp7mFLpQ
         TasvEHxNnTGb/VX3pDjMeMljKFr0BLXU69EmRn+vx2yOCweccRom3vYK8IguOl8vUCxG
         jHTMfxzRq8REaioWilYfYmAhKAOn7tNETfOFh+lgOqkEQdwKuVSK1ufrbKmDl9VbG5Ii
         9NBufqR04OtMBXd1XIXrV6nDQjyuQg76QyVXPTgnV5ZDlbrixSiI2t5hfeR1XQZEOnm+
         KOStIbNFbMkiF5nQgwRDQDUI4rZVyhW8Betbw6BHmx6tyzT2VouGt0zz+7bXYnoNSdLo
         /qOA==
X-Forwarded-Encrypted: i=1; AJvYcCWTMDvTWeXi0uNmNo8TT0JCoxcakT8mADk04iXp/vEuOnmodvAlfHco2oqfee3d9IGyEe+W7Bc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhtloddSwj6pvMcNbmTS8+wxsB9Moihy4u+AsaU3tvQ9i4ZRko
	AuoR6eRhh/HTpmP5zCvEkqXCxU0Joknl4zYMnssnWqoIGPOUT8bdSdNYT/x/y99qhpvQ37rePXy
	kug==
X-Google-Smtp-Source: AGHT+IEBA6sQPWzAdi8CzCDBzNF24Q7LCGUPm+EBp+JckJEMXbI5RjdBt7EA/qQscaFI/JvHbD6L23p5ztg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fc0d:0:b0:e0b:f69b:da30 with SMTP id
 3f1490d57ef6-e1a2a9430d2mr615276.9.1724698887108; Mon, 26 Aug 2024 12:01:27
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 26 Aug 2024 12:01:16 -0700
In-Reply-To: <20240826190116.145945-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240826190116.145945-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826190116.145945-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM selftests uses the kernel's canonical arch paths, directly
override ARCH to 'x86' when targeting x86_64 instead of defining ARCH_DIR
to redirect to appropriate paths.  ARCH_DIR was originally added to deal
with KVM selftests using the target triple ARCH for directories, e.g.
s390x and aarch64; keeping it around just to deal with the one-off alias
from x86_64=>x86 is unnecessary and confusing.

Note, even when selftests are built from the top-level Makefile, ARCH is
scoped to KVM's makefiles, i.e. overriding ARCH won't trip up some other
selftests that (somehow) expects x86_64 and can't work with x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile     |  4 +---
 tools/testing/selftests/kvm/Makefile.kvm | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a9c1d85905d8..30b1a88aea2e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -6,9 +6,7 @@ ARCH            ?= $(SUBARCH)
 ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
 # Top-level selftests allows ARCH=x86_64 :-(
 ifeq ($(ARCH),x86_64)
-	ARCH_DIR := x86
-else
-	ARCH_DIR := $(ARCH)
+	ARCH := x86
 endif
 include Makefile.kvm
 else
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 27f4e100c6ac..c8bfd0815a57 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -197,10 +197,10 @@ TEST_GEN_PROGS_riscv += steal_time
 SPLIT_TESTS += arch_timer
 SPLIT_TESTS += get-reg-list
 
-TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
-LIBKVM += $(LIBKVM_$(ARCH_DIR))
+TEST_PROGS += $(TEST_PROGS_$(ARCH))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
+LIBKVM += $(LIBKVM_$(ARCH))
 
 OVERRIDE_TARGETS = 1
 
@@ -212,14 +212,14 @@ include ../lib.mk
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH_DIR)/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
+	-I$(<D) -Iinclude/$(ARCH) -I ../rseq -I.. $(EXTRA_CFLAGS) \
 	$(KHDR_INCLUDES)
 ifeq ($(ARCH),s390)
 	CFLAGS += -march=z10
@@ -258,7 +258,7 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
-SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
+SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
 TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
@@ -267,7 +267,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
 -include $(TEST_DEP_FILES)
 
-$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 
 $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
 $(TEST_GEN_PROGS_EXTENDED): %: %.o
@@ -275,9 +275,9 @@ $(TEST_GEN_PROGS_EXTENDED): %: %.o
 $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
+$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
+$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(GEN_HDRS) \
-- 
2.46.0.295.g3b9ea8a38a-goog

