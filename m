Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A442576
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600649; cv=none; b=AxSrrbmHhDehVaPkol+fk6/d5hwNitWofMlr7mVw5DBth3H97scgKILfPxJVZZLqoQBBgY6qw5CddPN4libceiMtZdFp5Ykn2VKgKalhDJ9QZSkV6ICoromq3HIo6GjdjBBrat7jQff+nviXUgiLt+0RUsnJ3xbuZIJTiG6qiLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600649; c=relaxed/simple;
	bh=cgO6vD3DDYOorXGrSYxtut2nAefUtVb1kMw8GMCdCTU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rrc6aVtY9Z3xRXGBA4T82nIGQxW0E7/Ctq3OlshAYKjhFXaPfMUCLkJZ4T0OJkpy3bzcDmlYstQmkY9ZMnxUbSxL6MGyywSoEeQQ4BE+rEtzz/86UO2xI1nphQYA+MYuaFZ45+CISso2nusRWT4C5iirCfkrj5vbXbmJ3b6wk+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J0bNPbVj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J0bNPbVj"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311b6d25278so5805759a91.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600647; x=1750205447; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T9v9a40eFZn9R1EW7cZiJp8oFw/IePLxWs4fhJywAPc=;
        b=J0bNPbVj8vqZd9s4fGMqoLVPhVn71s+tWKuiq9ir2KZDS1g7t3Za/a6Hbk02DTerNJ
         HhNIfK86fzS0gB9CwOIaf4fH03lL1z8X/OyrWTDFzpkwyuSzfXU/gbIYeBoZ5gBJyC1M
         aVdvNEdggXrP8FW2YjjKWvmoPDC+KKN9evjnB7h/BGBhKtDn4ZYLLT9eIGkYq8YHAoX7
         t5xjGbLjFLJKhZUQDj1HJnKDR9/muLkTQ7CnTCaKaoLsk1WwkgkSXlfe+NTRX3b8wJ9E
         GF3LfWF9pIpjUTWVlmgBOZjUnTEOlOUgDPr778Ku23luTsc033u5ElcFViEcOoI1FFA5
         UZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600647; x=1750205447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9v9a40eFZn9R1EW7cZiJp8oFw/IePLxWs4fhJywAPc=;
        b=bs4e2E+iSKZheNKVZA3lqdCaZktF2fnT4y0e+H7LcCDxcYTxwJkFqcNgXjmAqONFfd
         gAxYEfpNzAYAyptb1s6/O8CefZPdgbuBAN4vxA3GcB64gosbj5xhYgXvhpkqQ0knDHti
         AjbzblDQIPW4p8XMHeDBPyEk4XC+poQTtAZNpf+tFm4gyQsdo8W+/SCjDBtVc3iJ3lxw
         XYAoaJ3Zg4DblKs+af2ojQBusYIcz5xcPF/YNA2QdSUiwM8wfyAj/Hp2iQ2Jn+K35cRb
         4C24cVaKxoN56G73U4zGz86V5TIEIM6Ukb8gCroDGOtUCmbwb4t+ajCv1VWD8HyrBynQ
         VWJw==
X-Forwarded-Encrypted: i=1; AJvYcCXYpYFay11pOn9ANEmsaTbIfNy0MV1jv01W4UNerrjmPJk3GLdSrul6L0oktvMiR9zXHxwxNfM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdEryW5ANvYvD5egLf6fhJAl0Gq8C3/LmCsm0QLtD9NLemQnI1
	YJQYjUx3/315/8EdktFB43KlU8CqUrZ2KDBTweKNwFSTJsQaw411P56bdnVDLhe5unheZJ2xP9y
	Gh0dnVw==
X-Google-Smtp-Source: AGHT+IEV2ehh3DZ0P6laELJQUxxjOzAbGJYmk59KPIK2LrFdETO4qOTGt38spkCAI0j7nNaUnHVLjxXIt54=
X-Received: from pjbpl16.prod.google.com ([2002:a17:90b:2690:b0:311:e9bb:f8d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a86:b0:311:df4b:4b7a
 with SMTP id 98e67ed59e1d1-313af23ff12mr1868472a91.29.1749600646996; Tue, 10
 Jun 2025 17:10:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:35 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-2-seanjc@google.com>
Subject: [PATCH 1/8] KVM: arm64: Move arm_{psci,hypercalls}.h to an internal
 KVM path
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Anish Ghulati <aghulati@google.com>

Move arm_hypercalls.h and arm_psci.h into arch/arm64/kvm now that KVM
no longer supports 32-bit ARM, i.e. now that there's no reason to make
the hypercall and PSCI APIs "public".

Signed-off-by: Anish Ghulati <aghulati@google.com>
[sean: squash into one patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c                         | 5 +++--
 {include => arch/arm64}/kvm/arm_hypercalls.h | 0
 {include => arch/arm64}/kvm/arm_psci.h       | 0
 arch/arm64/kvm/guest.c                       | 2 +-
 arch/arm64/kvm/handle_exit.c                 | 2 +-
 arch/arm64/kvm/hyp/Makefile                  | 6 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h      | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c             | 4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c              | 4 ++--
 arch/arm64/kvm/hypercalls.c                  | 4 ++--
 arch/arm64/kvm/psci.c                        | 4 ++--
 arch/arm64/kvm/pvtime.c                      | 2 +-
 arch/arm64/kvm/trng.c                        | 2 +-
 13 files changed, 20 insertions(+), 19 deletions(-)
 rename {include => arch/arm64}/kvm/arm_hypercalls.h (100%)
 rename {include => arch/arm64}/kvm/arm_psci.h (100%)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de2b4e9c9f9f..017c95c7bd03 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -42,9 +42,10 @@
 #include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
 
-#include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
-#include <kvm/arm_psci.h>
+
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 #include "sys_regs.h"
 
diff --git a/include/kvm/arm_hypercalls.h b/arch/arm64/kvm/arm_hypercalls.h
similarity index 100%
rename from include/kvm/arm_hypercalls.h
rename to arch/arm64/kvm/arm_hypercalls.h
diff --git a/include/kvm/arm_psci.h b/arch/arm64/kvm/arm_psci.h
similarity index 100%
rename from include/kvm/arm_psci.h
rename to arch/arm64/kvm/arm_psci.h
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2196979a24a3..699a2f975350 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
-#include <kvm/arm_hypercalls.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/fpsimd.h>
@@ -27,6 +26,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
 
+#include "arm_hypercalls.h"
 #include "trace.h"
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 453266c96481..32a7b7c22924 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -22,7 +22,7 @@
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index d61e44642f98..b1a4884446c6 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -3,8 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP part
 #
 
-incdir := $(src)/include
-subdir-asflags-y := -I$(incdir)
-subdir-ccflags-y := -I$(incdir)
+hyp_includes := -I$(src)/include -I$(srctree)/arch/arm64/kvm
+subdir-asflags-y := $(hyp_includes)
+subdir-ccflags-y := $(hyp_includes)
 
 obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index bb9f2eecfb67..340a57e0ed7c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -16,8 +16,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/extable.h>
@@ -32,6 +30,8 @@
 #include <asm/processor.h>
 #include <asm/traps.h>
 
+#include "arm_psci.h"
+
 struct kvm_exception_table_entry {
 	int insn, fixup;
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 73affe1333a4..e0610cf683ab 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -28,6 +26,8 @@
 
 #include <nvhe/mem_protect.h>
 
+#include "arm_psci.h"
+
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c9b330dc2066..96be652caf3a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/percpu.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -28,6 +26,8 @@
 #include <asm/thread_info.h>
 #include <asm/vectors.h>
 
+#include "arm_psci.h"
+
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 569941eeb3fe..002f4c593e90 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -6,8 +6,8 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
-#include <kvm/arm_psci.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 #define KVM_ARM_SMCCC_STD_FEATURES				\
 	GENMASK(KVM_REG_ARM_STD_BMAP_BIT_COUNT - 1, 0)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..0566b5907497 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -13,8 +13,8 @@
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_psci.h>
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 /*
  * This is an implementation of the Power State Coordination Interface
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30b..b07d250d223c 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -8,7 +8,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
index 99bdd7103c9c..b5dc0f09797a 100644
--- a/arch/arm64/kvm/trng.c
+++ b/arch/arm64/kvm/trng.c
@@ -6,7 +6,7 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define ARM_SMCCC_TRNG_VERSION_1_0	0x10000UL
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

