Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76566C433E5
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20D9220709
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 10:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NlJH/3MR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20D9220709
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C48714B4FF;
	Fri, 15 May 2020 06:59:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 78wt3YJafvkG; Fri, 15 May 2020 06:59:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAEC64B4F8;
	Fri, 15 May 2020 06:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13FD24B4D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kn7J0dOQQ96l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 06:59:24 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCA9D4B4CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 06:59:14 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id l11so3077863wru.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 03:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=qUYKxeqFmugL2ekLV39MyViS4NNaUTmppS2gbMRIELI=;
 b=NlJH/3MRJY49M/3njTipBUXnGPJGLor527gHDg7Ccbfp6Fy+WbyyqOQux9LQtXFqP6
 +oSKoPOyU8TkDXeD4ohbnat4X3fD0ifjlwT/6b7bMW4Z7dwlwet6iUbspgUkU5VP8uu2
 c+yGDkq/0oAX6eNc4t/tj0WGGKVHcYZc5/Fk/Dp+2w4TwIGz0hpXuE+zo3jr0qax3Jo6
 BQWs4nyy81XP6sDDH7Of0C+ZjxK4D1s5M2fVlcRgwle4R6ERlMq1VzSWUK6yCsXYVI4f
 EaffBugUsGqlLdrNSED7kS8Sblh2cnzWxmpvDpQGgqYe3P+4fote97V9Y2vYkCEO07it
 /AFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=qUYKxeqFmugL2ekLV39MyViS4NNaUTmppS2gbMRIELI=;
 b=BIZQoxJ4VyGjaQ7P0Stg+24Q+IM70bsRei0G+cbqma80bi3oQ+ih6SxbsWnwrogHq7
 sdbp0+sG9Osfv65v5CduLTm2xcGOVDgdlG18IYtF1ix6qVDCY2h4t7elZkVZjz4KJr03
 d7cYltRso/y60dD/eKnOO5qXBE8hTeWAdP9Sj87nIgKmE6Y19CcKUvafNbzJATX2l3kX
 RE4SKDYXHDWSMTpjoeoimcuQVGBtfvscsgBLWB6Iz2UsjkKwzaibeoXbI0dnVCmCXyxX
 zVnFc18L2VnJ2T4h6SgbYCWtfyix5ZDGyjM23KpUBq901ViwZN0sjDeOxxdHEqDUSx/h
 utqQ==
X-Gm-Message-State: AOAM532MCY4MumTG00R8wgzBVI83lRTl+BLxD316j0gXxiwSN0GY1oKD
 Rq31nUW+U6xlpszLhuaIAQxHaA==
X-Google-Smtp-Source: ABdhPJz8L+oLnstInjy+qRVkjsl3lHqBMGwOF6aiH2Z0N+sa1ULlAqHKHHZdf97y1h4INqINWTTXqA==
X-Received: by 2002:a5d:5686:: with SMTP id f6mr3723358wrv.168.1589540353667; 
 Fri, 15 May 2020 03:59:13 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id r2sm3034272wrg.84.2020.05.15.03.59.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 03:59:12 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 10/14] arm64: kvm: Split hyp/timer-sr.c to VHE/nVHE
Date: Fri, 15 May 2020 11:58:37 +0100
Message-Id: <20200515105841.73532-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515105841.73532-1-dbrazdil@google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

This patch is part of a series which builds KVM's non-VHE hyp code separately
from VHE and the rest of the kernel.

timer-sr.c contains a HVC handler for setting CNTVOFF_EL2 and two helper
functions for controlling access to physical counter. The former is shared
between VHE/nVHE and is kept in timer-sr.c but compiled under both configs.
The latter are nVHE-specific and are moved to nvhe/timer-sr.c.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kernel/image-vars.h     |  3 ---
 arch/arm64/kvm/hyp/nvhe/Makefile   |  3 ++-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 43 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/timer-sr.c      | 36 -------------------------
 5 files changed, 47 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/timer-sr.c

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2084fd3186a7..f9fa7fd7a0f3 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -64,8 +64,10 @@ void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
+#endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index bf9053d65ad7..c16cf4e2cd8b 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -67,9 +67,6 @@ __kvm_nvhe___guest_enter = __guest_enter;
 __kvm_nvhe___guest_exit = __guest_exit;
 __kvm_nvhe___icache_flags = __icache_flags;
 __kvm_nvhe___kvm_handle_stub_hvc = __kvm_handle_stub_hvc;
-__kvm_nvhe___kvm_timer_set_cntvoff = __kvm_timer_set_cntvoff;
-__kvm_nvhe___timer_disable_traps = __timer_disable_traps;
-__kvm_nvhe___timer_enable_traps = __timer_enable_traps;
 __kvm_nvhe___vgic_v2_perform_cpuif_access = __vgic_v2_perform_cpuif_access;
 __kvm_nvhe___vgic_v3_activate_traps = __vgic_v3_activate_traps;
 __kvm_nvhe___vgic_v3_deactivate_traps = __vgic_v3_deactivate_traps;
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8157f6fa4c99..a67958f29fd7 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -7,7 +7,8 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -fno-stack-protector \
 	     -DDISABLE_BRANCH_PROFILING $(DISABLE_STACKLEAK_PLUGIN)
 
-obj-y := sysreg-sr.o debug-sr.o switch.o tlb.o ../hyp-entry.o
+obj-y := ../timer-sr.o timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o \
+	 ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
new file mode 100644
index 000000000000..f0e694743883
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2012-2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <clocksource/arm_arch_timer.h>
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_hyp.h>
+
+/*
+ * Should only be called on non-VHE systems.
+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
+ */
+void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	/* Allow physical timer/counter access for the host */
+	val = read_sysreg(cnthctl_el2);
+	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	write_sysreg(val, cnthctl_el2);
+}
+
+/*
+ * Should only be called on non-VHE systems.
+ * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
+ */
+void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	/*
+	 * Disallow physical timer access for the guest
+	 * Physical counter access is allowed
+	 */
+	val = read_sysreg(cnthctl_el2);
+	val &= ~CNTHCTL_EL1PCEN;
+	val |= CNTHCTL_EL1PCTEN;
+	write_sysreg(val, cnthctl_el2);
+}
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
index ff76e6845fe4..46e303281a2c 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/timer-sr.c
@@ -4,10 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <clocksource/arm_arch_timer.h>
-#include <linux/compiler.h>
-#include <linux/kvm_host.h>
-
 #include <asm/kvm_hyp.h>
 
 void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
@@ -15,35 +11,3 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
 	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
 	write_sysreg(cntvoff, cntvoff_el2);
 }
-
-/*
- * Should only be called on non-VHE systems.
- * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
- */
-void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
-{
-	u64 val;
-
-	/* Allow physical timer/counter access for the host */
-	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
-	write_sysreg(val, cnthctl_el2);
-}
-
-/*
- * Should only be called on non-VHE systems.
- * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
- */
-void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
-{
-	u64 val;
-
-	/*
-	 * Disallow physical timer access for the guest
-	 * Physical counter access is allowed
-	 */
-	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
-	write_sysreg(val, cnthctl_el2);
-}
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
