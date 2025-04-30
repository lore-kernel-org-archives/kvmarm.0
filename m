Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C5A264FB5
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030453; cv=none; b=IkKyDk30RuDgH6VJmHMc2D01pJ/uLVC3cAaVpqdPzMs5zSkBlTpqGAGsXkjtbD7RC7/eoAFm2QcaEmGddBWXQ9uF7R+TQVBBecWMFXi3GPdZIRxR6e4+yDix5JIhIYeYV1NkyalBfOnEI04hQo59aFA2DhbE3hVn6L6rO/LnO+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030453; c=relaxed/simple;
	bh=esaH8w+qP4dacyJDOuK09lepOX2rSwpGvRjGWl+rkdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MUlMbcf/Led1c91b67N9m5Bdiq5g+MPhN+suotT7SqN4JMiTKZogXPeVDZTBZfiraEszyUoWkAfLuZOFmsajh1weYXYwUZVgypENnNmck9pNwnsWPtP4JbmBgZnhd6+QZRFopm56B0LPgOCU37dkdltDF0RclDHsUOpJ0w6wwYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=id2BWPQz; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="id2BWPQz"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-39ac9b0cb6aso3197231f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 09:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746030450; x=1746635250; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V1qsu6fkrd6uduOladyyR4ZyoWD5vL8Q+jaWgw+feE0=;
        b=id2BWPQz9/H9u/3FzldqFHw1EGuo0Jup6hXkhvizYvM2xS8GMCSETXNtBXfpGEFqiD
         ofp5UhxNGPtZOm6bfHW+VAXm2RgHLdzu2OheRudV/4caqf32oEgQ3aVNtjdTCrH1EvQ4
         GjsjsKvw+4FGMafoHWdGc6SlIxu2zqaG9HYP5FByzhUk5mrvITZOG9qaF01LIsdwn/qE
         8dVUcvOrCVyas4Q0Ieygd/eLxZO52aO7NZfEI34EloouSNusOrFfs2aSFdgxvCOX+Rl5
         4X9X6LihgK0kaPFuY/Hq5GwVeX9UjZHyUNQVszn62QjqkKpqcKKF0J5X9U9gdmVUafj+
         /U7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030450; x=1746635250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1qsu6fkrd6uduOladyyR4ZyoWD5vL8Q+jaWgw+feE0=;
        b=fh9COjFgO7+jxsBIvUntmuT4Eewy0UU/PEYpkAEvA+uolGKgbV8Q+U+XmqFIeUWxyh
         6TqDDJ7+qq003ECAgoTqw+Yx0ESX5lhe3tWjElRg4OFaUGEifs5CFhkZo/SLpLtOylTT
         9PGY3qeJM9HRSsAlsC+cjwTuW8lN65QT3ueLoWSPSZ/INdi359ohO9nKuDc9Lg0d/60o
         AEyitzIq5mK9CXQcAEy+GiLgaM2SV1qdJkLwBdwB8roJEZ08kFa3WlefgXPQ/6muvsOv
         zoRgV4Lku6liGEzVTNPnEntt0Z3OzU0IXsIM1qYcmDCzUyHJNdl5WAjo8oXN3QDoaXZR
         lqqQ==
X-Gm-Message-State: AOJu0YyrgWHtYaKVikle24ZBsNtXWokXQvlFhlVP+MHqlKcWnQYfLMNu
	+9AvoDn8qMxYJXBJxNLBqNUfALZIdlbeAYYsD0IxxtvdSnWM+1EFBvkQSIknpnchDxRHuy7bJhv
	KFbxp9UHJVTunPM9DMJXxRzUQitVs9ZXeJeN5lLP/lPEWIfFvYGuKkAE6YV6Zoi4s3BotzbYSfB
	B3dvEGfK3xF8dfA/RsTF9SFsUmH2vesi6mUZcY2sXF1C4=
X-Google-Smtp-Source: AGHT+IG4BlUgz6HW2Kxnd0khlJFiLyO62h9ryy5TwZM3R2e0jq/UJyUCK2ECwVgEFsDnoXM94u24uHZ/XOF4Lw==
X-Received: from wrbbh10.prod.google.com ([2002:a05:6000:5ca:b0:391:434a:b7c9])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:fbc4:0:b0:3a0:7fd4:2848 with SMTP id ffacd0b85a97d-3a08f7a4abamr2805108f8f.52.1746030450479;
 Wed, 30 Apr 2025 09:27:30 -0700 (PDT)
Date: Wed, 30 Apr 2025 16:27:10 +0000
In-Reply-To: <20250430162713.1997569-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430162713.1997569-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430162713.1997569-4-smostafa@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Introduce CONFIG_UBSAN_KVM_EL2
From: Mostafa Saleh <smostafa@google.com>
To: kvmarm@lists.linux.dev, kasan-dev@googlegroups.com, 
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kees@kernel.org, elver@google.com, andreyknvl@gmail.com, 
	ryabinin.a.a@gmail.com, akpm@linux-foundation.org, yuzenghui@huawei.com, 
	suzuki.poulose@arm.com, joey.gouly@arm.com, masahiroy@kernel.org, 
	nathan@kernel.org, nicolas.schier@linux.dev, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new Kconfig CONFIG_UBSAN_KVM_EL2 for KVM which enables
UBSAN for EL2 code (in protected/nvhe/hvhe) modes.
This will re-use the same checks enabled for the kernel for
the hypervisor. The only difference is that for EL2 it always
emits a "brk" instead of implementing hooks as the hypervisor
can't print reports.

The KVM code will re-use the same code for the kernel
"report_ubsan_failure()" so #ifdefs are changed to also have this
code for CONFIG_UBSAN_KVM_EL2

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 6 ++++++
 include/linux/ubsan.h            | 2 +-
 lib/Kconfig.ubsan                | 9 +++++++++
 lib/ubsan.c                      | 6 ++++--
 scripts/Makefile.ubsan           | 5 ++++-
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b43426a493df..a76522d63c3e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -99,3 +99,9 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAG
 # causes a build failure. Remove profile optimization flags.
 KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
+
+ifeq ($(CONFIG_UBSAN_KVM_EL2),y)
+UBSAN_SANITIZE := y
+# Always use brk and not hooks
+ccflags-y += $(CFLAGS_UBSAN_TRAP)
+endif
diff --git a/include/linux/ubsan.h b/include/linux/ubsan.h
index c843816f5f68..3ab8d38aedb8 100644
--- a/include/linux/ubsan.h
+++ b/include/linux/ubsan.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_UBSAN_H
 #define _LINUX_UBSAN_H
 
-#ifdef CONFIG_UBSAN_TRAP
+#if defined(CONFIG_UBSAN_TRAP) || defined(CONFIG_UBSAN_KVM_EL2)
 const char *report_ubsan_failure(u32 check_type);
 #else
 static inline const char *report_ubsan_failure(u32 check_type)
diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index f6ea0c5b5da3..42ed41804644 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -165,4 +165,13 @@ config TEST_UBSAN
 	  This is a test module for UBSAN.
 	  It triggers various undefined behavior, and detect it.
 
+config UBSAN_KVM_EL2
+	bool "UBSAN for KVM code at EL2"
+	depends on ARM64
+	help
+	  Enable UBSAN when running on ARM64 with KVM in a split mode
+	  (nvhe/hvhe/protected) for the hypervisor code running in EL2.
+	  In this mode, any UBSAN violation in EL2 would panic the kernel
+	  and information similar to UBSAN_TRAP would be printed.
+
 endif	# if UBSAN
diff --git a/lib/ubsan.c b/lib/ubsan.c
index 17993727fc96..a6ca235dd714 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -19,7 +19,7 @@
 
 #include "ubsan.h"
 
-#ifdef CONFIG_UBSAN_TRAP
+#if defined(CONFIG_UBSAN_TRAP) || defined(CONFIG_UBSAN_KVM_EL2)
 /*
  * Only include matches for UBSAN checks that are actually compiled in.
  * The mappings of struct SanitizerKind (the -fsanitize=xxx args) to
@@ -97,7 +97,9 @@ const char *report_ubsan_failure(u32 check_type)
 	}
 }
 
-#else
+#endif
+
+#ifndef CONFIG_UBSAN_TRAP
 static const char * const type_check_kinds[] = {
 	"load of",
 	"store to",
diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
index 9e35198edbf0..73c7a9be0796 100644
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
+# Shared with KVM/arm64.
+export CFLAGS_UBSAN_TRAP := $(call cc-option,-fsanitize-trap=undefined,-fsanitize-undefined-trap-on-error)
+
 # Enable available and selected UBSAN features.
 ubsan-cflags-$(CONFIG_UBSAN_ALIGNMENT)		+= -fsanitize=alignment
 ubsan-cflags-$(CONFIG_UBSAN_BOUNDS_STRICT)	+= -fsanitize=bounds-strict
@@ -10,7 +13,7 @@ ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
 ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
 ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
 ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
-ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= $(call cc-option,-fsanitize-trap=undefined,-fsanitize-undefined-trap-on-error)
+ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= $(CFLAGS_UBSAN_TRAP)
 
 export CFLAGS_UBSAN := $(ubsan-cflags-y)
 
-- 
2.49.0.967.g6a0df3ecc3-goog

