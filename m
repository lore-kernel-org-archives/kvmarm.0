Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04993C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF1A720702
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ilTyU0Ag"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF1A720702
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BE74B560;
	Thu, 25 Jun 2020 09:14:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JC7ES1v191wZ; Thu, 25 Jun 2020 09:14:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E424B578;
	Thu, 25 Jun 2020 09:14:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B08AA4B404
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KlRjNg9+rK0O for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:50 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 084F84B4B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:50 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id q5so5786846wru.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=o3YELHjM1BgSWP0+S5toOkAsepEf5nX9XhvGc5i2xbU=;
 b=ilTyU0AgGSK7WeD/FKjM2QHVp2cuKnlScEo1zl+lyPExxPoKPjmWmxrNy9vzUr1mRY
 LzhR1Rh/UrAFo+GhEztERMJc68vpsrQf6W3Yf/nriOW/2dZqo/7DP4Zp4pMQVSBJssi2
 p43nHoW3yDaXkm6m59mcwjp3SWGZzfs5TpMBZ1WnFW1PujxCKDBFsl98R5ZXj7SUpseQ
 7F6DtEC8ATtjrHxUeMEE9knb7uVqie5aq7Z3mAIJnOXwRuR7zRBeibXTuUdRk7JGlIbF
 9tqc0j50JvMD3FZbP/CRI1A4AcSct/0mJ1tdqD0Wix2G1JmGnXnuf3C5/79LgEmNgUD0
 ltPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=o3YELHjM1BgSWP0+S5toOkAsepEf5nX9XhvGc5i2xbU=;
 b=pufL6XsLBx+nq2ZePhKmnWJWpyqIYU26PoiFJE2Oa3rWjcxlHmyY2p8kDH0vtPjjd2
 LGftdHC/xq1jGCs0ouDV/hx/ysZ2hixgGZ8qi+vjTOt0+rvqycZ1rYKSDDSN09QlaKC4
 xWCRDYfcMzHTkGOp7M9i92Vo0IrTgMwVhv9RBJWZOYL8OMQrMlerWkcI9Cyz9x8utLXR
 tMu7fUN7wvjNKFbT2Jflc6IYJ7njYubsUjfgTrn+v8YMwCJRNF6UmO/DT8YzpQB9Pwkx
 CxW3jClTKZEGwestO7d3eIguBg6hqZpPVnfFoVObZPiCnM5ZEyjogHFgkYhamIG2fUPh
 gA9g==
X-Gm-Message-State: AOAM530enPp/s6Lg+4bqUhUPU5C1O8YKHyKl6ArtRW9PUn/f01IbQnkh
 HpiObOMhCPOg+uQ6FJWFI7hMjA==
X-Google-Smtp-Source: ABdhPJyLXF+uU/BlSix30zQts4PivrY6/W4SxO/M5sYmX4ja0Dr3vI+AEEytk5FhJrUCpy+0J45FDw==
X-Received: by 2002:adf:dc90:: with SMTP id r16mr2898229wrj.264.1593090889018; 
 Thu, 25 Jun 2020 06:14:49 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id g13sm5650833wro.84.2020.06.25.06.14.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:48 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 12/15] arm64: kvm: Duplicate hyp/timer-sr.c for VHE/nVHE
Date: Thu, 25 Jun 2020 14:14:17 +0100
Message-Id: <20200625131420.71444-13-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

timer-sr.c contains a HVC handler for setting CNTVOFF_EL2 and two helper
functions for controlling access to physical counter. The former is used by
both VHE/nVHE and is duplicated, the latter are used only by nVHE and moved
to nvhe/timer-sr.c.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h         |  2 ++
 arch/arm64/kernel/image-vars.h           |  5 -----
 arch/arm64/kvm/hyp/Makefile              |  2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile         |  3 ++-
 arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c |  2 +-
 arch/arm64/kvm/hyp/vhe/Makefile          |  2 +-
 arch/arm64/kvm/hyp/vhe/timer-sr.c        | 12 ++++++++++++
 7 files changed, 19 insertions(+), 9 deletions(-)
 rename arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c (95%)
 create mode 100644 arch/arm64/kvm/hyp/vhe/timer-sr.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 997c5bda1ac7..19f8b40fe6cf 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -63,8 +63,10 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
+#endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 05c642621d61..221024e745c9 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -76,11 +76,6 @@ KVM_NVHE_ALIAS(abort_guest_exit_start);
 KVM_NVHE_ALIAS(__fpsimd_restore_state);
 KVM_NVHE_ALIAS(__fpsimd_save_state);
 
-/* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
-KVM_NVHE_ALIAS(__timer_disable_traps);
-KVM_NVHE_ALIAS(__timer_enable_traps);
-
 /* Symbols defined in vgic-v2-cpuif-proxy.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__vgic_v2_perform_cpuif_access);
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index f49797237818..ef1aa7fe8f5a 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -13,7 +13,7 @@ subdir-ccflags-y := -I$(incdir)				\
 obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
-hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
+hyp-y := vgic-v3-sr.o aarch32.o vgic-v2-cpuif-proxy.o entry.o \
 	 fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 61a8160f0dd9..0f4c544f07db 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,8 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o \
+	 ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
similarity index 95%
rename from arch/arm64/kvm/hyp/timer-sr.c
rename to arch/arm64/kvm/hyp/nvhe/timer-sr.c
index fb5c0be33223..42c8ed71d06e 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -10,7 +10,7 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_timer_set_cntvoff(u64 cntvoff)
+void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 2801582a739a..a1dbbc5409bd 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/timer-sr.c b/arch/arm64/kvm/hyp/vhe/timer-sr.c
new file mode 100644
index 000000000000..4cda674a8be6
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/timer-sr.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <asm/kvm_hyp.h>
+
+void __kvm_timer_set_cntvoff(u64 cntvoff)
+{
+	write_sysreg(cntvoff, cntvoff_el2);
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
