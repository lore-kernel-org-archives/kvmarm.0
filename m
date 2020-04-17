Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E2AC2BB55
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF6A220857
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="YNDcCkzR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF6A220857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F654B128;
	Fri, 17 Apr 2020 04:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kfXAphYEUYl2; Fri, 17 Apr 2020 04:55:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58BDB4B18F;
	Fri, 17 Apr 2020 04:55:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0204B18D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p0TiofgPUEyJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 04:55:42 -0400 (EDT)
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com
 [209.85.222.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA76C4B138
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:41 -0400 (EDT)
Received: by mail-ua1-f73.google.com with SMTP id r5so641277uad.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=reAFpj/ZVfR9iBZoEXBZoev+Oei9De+sJnJIQwU4W2Y=;
 b=YNDcCkzR8XrXgK5VB2bnEKEPxfzqAcGQzwf4B3WXIyyZTU+u0pYGD3z89EwP1yuYts
 ncDTgiUlxNT0trohyV5XVrE9eT72SieFn3nCCLH4Q1QrEvAd0epRnKcgQI9zjylNVe/M
 KLY2BfpIqeltvwVbEsWIzEZ9fZyzsl2BiIairVYOba35HO0srPRJ/LGX0x5VW9N8nvuW
 2q8Eo67NCnHWlJHLNOwIy54aWyrWxI+whpG5o3gYq6Ld5PlLmvZg6/s/AYhYShpBJEGx
 I/Mkoo7J/3aiu659+yVnP+fLXiZAC4Zw00F3J5FuREKzvSKHoya52ftuCExxDxi7krCz
 99KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=reAFpj/ZVfR9iBZoEXBZoev+Oei9De+sJnJIQwU4W2Y=;
 b=GdOq8X8BnenBgPc2X8/30oegRPglyAPB+x6i7NqexCKE5U5p2Id/jCfA+BgevkIpkg
 jYAc8AGikA8SCR3MVtO7KlNKVfI1q4msFgYzyqxqhTVFrCTm3iHP2CYu/NytkyURq40w
 s2X6SNKmnV55SPm4FDG8ZrGMDCw8940JRRBSOSaRQuVf8IEEXRBLJIuy5j0R/6Vd17Md
 7LjoVYWIxmauZ0tkDmDGiFlLd2F8Zxl1jHQiIHmTnoiYm4HFgPDatxrumVcvClcsCX2C
 bwqmKUYMXR8mYnbv9r/jjYXuwQz/aAYlJ2BiX05/u6PYhrf1HYOkX/Y3sZndN1r4pgaf
 WJEg==
X-Gm-Message-State: AGi0PubqsjUj8L5VwkSeyfXqLMx0b3gkqO3BjZINohmVJRsmuFFBN54R
 16FzRLhfBiJDSg8J8ZO41brNSk8f0g==
X-Google-Smtp-Source: APiQypJ9uNuavt6HuR/7GjYYmL60UePINLAPVZUCVh9xUhpMY7nxkh28eg8I7aUV4Rd1CQyNMyZE/uZBag==
X-Received: by 2002:a1f:2c50:: with SMTP id s77mr1668306vks.14.1587113741191; 
 Fri, 17 Apr 2020 01:55:41 -0700 (PDT)
Date: Fri, 17 Apr 2020 09:55:22 +0100
In-Reply-To: <20200417085522.150701-1-tabba@google.com>
Message-Id: <20200417085522.150701-5-tabba@google.com>
Mime-Version: 1.0
References: <20200417085522.150701-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH 4/4] KVM: arm64: Clean up kvm makefiles
From: Fuad Tabba <tabba@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Cc: will@kernel.org
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

Consolidate references to the CONFIG_KVM configuration item to encompass
entire folders rather than per line.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Makefile     | 41 +++++++++++++++----------------------
 arch/arm64/kvm/hyp/Makefile | 16 +++++----------
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 2d968e9ac792..a5eab7fe11a8 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -10,30 +10,21 @@ KVM=../../../virt/kvm
 obj-$(CONFIG_KVM) += kvm.o
 obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/hypercalls.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/pvtime.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
+	 $(KVM)/vfio.o \
+	 $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o $(KVM)/arm/psci.o \
+	 $(KVM)/arm/perf.o $(KVM)/arm/hypercalls.o $(KVM)/arm/pvtime.o \
+	 inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o \
+	 guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
+	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
+	 $(KVM)/arm/aarch32.o \
+	 $(KVM)/arm/vgic/vgic.o $(KVM)/arm/vgic/vgic-init.o \
+	 $(KVM)/arm/vgic/vgic-irqfd.o $(KVM)/arm/vgic/vgic-v2.o \
+	 $(KVM)/arm/vgic/vgic-v3.o $(KVM)/arm/vgic/vgic-v4.o \
+	 $(KVM)/arm/vgic/vgic-mmio.o $(KVM)/arm/vgic/vgic-mmio-v2.o \
+	 $(KVM)/arm/vgic/vgic-mmio-v3.o $(KVM)/arm/vgic/vgic-kvm-device.o \
+	 $(KVM)/arm/vgic/vgic-its.o $(KVM)/arm/vgic/vgic-debug.o \
+	 $(KVM)/irqchip.o \
+	 $(KVM)/arm/arch_timer.o
 
-kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/aarch32.o
-
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-init.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v2.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v3.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v4.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-its.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-debug.o
-kvm-$(CONFIG_KVM) += $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ad4c173ed036..9358fbd123c0 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -8,18 +8,12 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 
 KVM=../../../../virt/kvm
 
-obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/vgic-v3-sr.o
-obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/timer-sr.o
-obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/aarch32.o
+obj-$(CONFIG_KVM) += hyp.o
 
-obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM) += sysreg-sr.o
-obj-$(CONFIG_KVM) += debug-sr.o
-obj-$(CONFIG_KVM) += entry.o
-obj-$(CONFIG_KVM) += switch.o
-obj-$(CONFIG_KVM) += fpsimd.o
-obj-$(CONFIG_KVM) += tlb.o
-obj-$(CONFIG_KVM) += hyp-entry.o
+hyp-y := $(KVM)/arm/hyp/vgic-v3-sr.o $(KVM)/arm/hyp/timer-sr.o \
+	 $(KVM)/arm/hyp/aarch32.o \
+	 vgic-v2-cpuif-proxy.o sysreg-sr.o debug-sr.o entry.o switch.o \
+	 fpsimd.o tlb.o hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
