Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630F01E485
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600654; cv=none; b=mFjW3vrrkhinjfMXf0+D4K2M159c2pW2L2ZKtbFVCVPnQ93zTb9YSo4rnwBnrgsl6bGN9mbl6PfD4a9ur+Z3KWADFcvBKCk757yEL5dKtnECZcRL7D6oeUULJw1bZocMEWjK5/c0HdSQN3rrcx6zylkoIB2veWQ890GRDKv1ABs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600654; c=relaxed/simple;
	bh=ul+BqD3/UAqkxf/sHfpARJUGF1v8V5p1dbDDJToOT0s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ByE1/tHoKqs8GkFG3n4cNx55WJJIiD1sHuKjcwqxlOfgTfmNu0Q2occ0ObEMCJEOudjv6LkEKpNOW/D4WuFeJ6eCpdeoqrNgUcnmzAe1D6cqfbdzJ8QVbfTBMiDOkbmy7VEmVLRLl+V08NkIrQEaWsE4OOQ/f0yDjhl1CTVCQ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mv/f2+ao; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mv/f2+ao"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747af0bf0ebso4641479b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600650; x=1750205450; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Epbf5uosqx6jz5XzFrguC8xd0TfTxmvXTHNlC1WjEX8=;
        b=Mv/f2+aozcZ+uVA1ujDnVDx9Ys8us6Sc5cw3mWYyMyBlvsx6vG0G4gxDIswiPAXxY5
         mn1/sUpiulKFs0RVU5LzNJKwZ9duKLflYwNF+p3OXOMnvz0M5QPEzRHR+OLfH58tLZQ+
         Y31Y9kmWJTxeL7pFO4S1hPhuuZYn+6YKotxS49RuoyIPNxO/u7BDLAOHBZHMJa+/k8yB
         Ee/xw8N6KBw69KWE9x1fJlILx0AbZiLvrLmL8DLVjPGdP8obTTZwgTSzzKhwsHnt1x2Y
         IWNQFj1fFwAJVnfWNa7Xq1Lx26Qselgm4lMHUToNuRpZUDnSKKXECXzcNzlBv0Ao4WQd
         fKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600650; x=1750205450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Epbf5uosqx6jz5XzFrguC8xd0TfTxmvXTHNlC1WjEX8=;
        b=Zi1arZnlhjIM8jBZzDMgxOSAKRxmcr9yuONQoRCV38XQxCnC50Ig4SpB23iOiL2Xis
         TjQX9kq+toFh3jL89KvKJWMexbhqCTzOqvwpc2Jslyt+jTPQqTxKtrRRFV70puwx8FLm
         3DnPCdT8N3uImvPI6cXyatGpjc1h+DS9kRKUzy2cuoWasL86eJI3VfCN4XsKc0dOWhs5
         oRX2J8zk1lQ+xXzRr88UwjgItGWHsXCYhZAgfHpWK6U5eVjNb+VcGzOn++SdBlrOroaS
         NNFRCHNGsTZFVdyETPnmF/DQNjidq/51RisBko9Hx66PDAoC0Ipb3qgUPGMdmvk8Fz2/
         5ExQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Wg4QszAzCbq6BvMLrF7hRi1yDXxlPcor/e6r28m6dW4bq99HzjLsEO+og5KptSFfA0JOBoM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+aPfJl8UHlj4LT/MeKnuoOjp2iXePuLRGy1eWze/SZMv7kLqe
	rhWtW66ESNmD01KVtupGWao+2PfNARUNgQ9Ll9P+Dt3S5CT0//Xd5wRDKM49RiYeftkJCWIAwbb
	U3qDwvg==
X-Google-Smtp-Source: AGHT+IEhyHjusvTVUOtqS0yfSdyCwB4Bf/WQ+mHd5WIpUrUJN5V4Vw3g9p2jvZWjX31+M9mXEgcJGfWPdog=
X-Received: from pfbhj1.prod.google.com ([2002:a05:6a00:8701:b0:747:b76c:ab92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c8e:b0:742:a0cf:7753
 with SMTP id d2e1a72fcca58-7486cb59a9amr2115667b3a.3.1749600650364; Tue, 10
 Jun 2025 17:10:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:37 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-4-seanjc@google.com>
Subject: [PATCH 3/8] KVM: arm64: Move ARM specific headers in include/kvm to
 arch directory
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

Move kvm/arm_{arch_timer,pmu,vgic}.h to arch/arm64/include/asm and drop
the "arm" prefix from all file names.  Now that KVM no longer supports
32-bit ARM, there is no reason to expose ARM specific headers to other
architectures beyond arm64.

Cc: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../arm64/include/asm/kvm_arch_timer.h                     | 0
 arch/arm64/include/asm/kvm_host.h                          | 7 +++----
 include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h  | 0
 .../kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h    | 0
 arch/arm64/kvm/arch_timer.c                                | 5 ++---
 arch/arm64/kvm/arm.c                                       | 3 +--
 arch/arm64/kvm/pmu-emul.c                                  | 4 ++--
 arch/arm64/kvm/reset.c                                     | 3 +--
 arch/arm64/kvm/trace_arm.h                                 | 2 +-
 arch/arm64/kvm/vgic/vgic-debug.c                           | 2 +-
 arch/arm64/kvm/vgic/vgic-init.c                            | 2 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                           | 2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c                      | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                            | 4 ++--
 arch/arm64/kvm/vgic/vgic-v2.c                              | 2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c                       | 3 +--
 arch/arm64/kvm/vgic/vgic-v3.c                              | 2 +-
 19 files changed, 21 insertions(+), 26 deletions(-)
 rename include/kvm/arm_arch_timer.h => arch/arm64/include/asm/kvm_arch_timer.h (100%)
 rename include/kvm/arm_pmu.h => arch/arm64/include/asm/kvm_pmu.h (100%)
 rename include/kvm/arm_vgic.h => arch/arm64/include/asm/kvm_vgic.h (100%)

diff --git a/include/kvm/arm_arch_timer.h b/arch/arm64/include/asm/kvm_arch_timer.h
similarity index 100%
rename from include/kvm/arm_arch_timer.h
rename to arch/arm64/include/asm/kvm_arch_timer.h
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6ce2c5173482..b8f910d5bdfa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,17 +26,16 @@
 #include <asm/daifflags.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
+#include <asm/kvm_arch_timer.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_pmu.h>
+#include <asm/kvm_vgic.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-#include <kvm/arm_vgic.h>
-#include <kvm/arm_arch_timer.h>
-#include <kvm/arm_pmu.h>
-
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
 #define KVM_VCPU_MAX_FEATURES 9
diff --git a/include/kvm/arm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
similarity index 100%
rename from include/kvm/arm_pmu.h
rename to arch/arm64/include/asm/kvm_pmu.h
diff --git a/include/kvm/arm_vgic.h b/arch/arm64/include/asm/kvm_vgic.h
similarity index 100%
rename from include/kvm/arm_vgic.h
rename to arch/arm64/include/asm/kvm_vgic.h
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index fdbc8beec930..d61b0450cbf9 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -14,12 +14,11 @@
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/arch_timer.h>
+#include <asm/kvm_arch_timer.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_nested.h>
-
-#include <kvm/arm_vgic.h>
-#include <kvm/arm_arch_timer.h>
+#include <asm/kvm_vgic.h>
 
 #include "trace.h"
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 017c95c7bd03..e452aba1a3b2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -39,11 +39,10 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
+#include <asm/kvm_pmu.h>
 #include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
 
-#include <kvm/arm_pmu.h>
-
 #include "arm_hypercalls.h"
 #include "arm_psci.h"
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 25c29107f13f..47a518f6a393 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -12,8 +12,8 @@
 #include <linux/perf/arm_pmu.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
-#include <kvm/arm_pmu.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_pmu.h>
+#include <asm/kvm_vgic.h>
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..bae367638741 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -17,12 +17,11 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
-#include <kvm/arm_arch_timer.h>
-
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/fpsimd.h>
 #include <asm/ptrace.h>
+#include <asm/kvm_arch_timer.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 9c60f6465c78..8fc8178e21a7 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -3,7 +3,7 @@
 #define _TRACE_ARM_ARM64_KVM_H
 
 #include <asm/kvm_emulate.h>
-#include <kvm/arm_arch_timer.h>
+#include <asm/kvm_arch_timer.h>
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 2684f273d9e1..0eba9dc78e6f 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -9,7 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/kvm_host.h>
 #include <linux/seq_file.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..5a4205fd78b2 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -7,7 +7,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index c314c016659a..b73401c34f29 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -6,7 +6,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 #include "vgic.h"
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f9ae790163fb..f542479ceb11 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -6,7 +6,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 #include <linux/kvm_host.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_mmu.h>
 #include <asm/cputype.h>
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index f25fccb1f8e6..d00c8a74fad6 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -9,7 +9,7 @@
 #include <linux/nospec.h>
 
 #include <kvm/iodev.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..505d4e389885 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -9,11 +9,11 @@
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
 #include <kvm/iodev.h>
-#include <kvm/arm_vgic.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_vgic.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index e416e433baff..ec1b13abc728 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -10,8 +10,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/iodev.h>
-#include <kvm/arm_arch_timer.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_arch_timer.h>
+#include <asm/kvm_vgic.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 381673f03c39..780afb7aad06 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -6,7 +6,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <kvm/arm_vgic.h>
+#include <asm/kvm_vgic.h>
 #include <asm/kvm_mmu.h>
 
 #include "vgic.h"
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 4f6954c30674..bdee42a8be17 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -7,11 +7,10 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <kvm/arm_vgic.h>
-
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_vgic.h>
 
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..a22fe73ca538 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -7,10 +7,10 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/string_choices.h>
-#include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_vgic.h>
 
 #include "vgic.h"
 
-- 
2.50.0.rc0.642.g800a2b2222-goog

