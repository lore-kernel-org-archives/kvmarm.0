Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE53C352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4736121D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qUM6fvRw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4736121D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F37EA4B27A;
	Fri, 17 Apr 2020 09:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id doJlWgU0yJKN; Fri, 17 Apr 2020 09:58:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8DFB4B27C;
	Fri, 17 Apr 2020 09:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A67B64B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAjbjwgv13Hu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:58:09 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C56E84B270
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:08 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id j16so1025470wrw.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KxdS+Gin+xlLIt6J3jqgXAHdoNsNBHclzeEq82JqKkE=;
 b=qUM6fvRw0EFUnsS26O4AOXtabO3J0z7IQbLsEEFxrRMoslEYdUMIkOSp3jY0KTgLBz
 ZT9FYuxqAv/kWtV9cqM3L8VtvyduDbs5FyG+Wxva8cwBvxqdETB4F8WwMuJqsIVMH0s9
 m2tXUG5uQ/8pBeLDeLivmAEetyYujTNsUDUvMIeWyglaaq5BbBzpgUD/2eosI8mrxiMX
 Sd2nrzEALzNeIhYnC54zDjeE1DFwnhZwijClhxl8CSP3DbizjQrHeynXdb1beRakv+OK
 9HDbFcgW2R3ZPGREztR1kvubm/bBO46/fptCYDeTUPqXP/uvZd5abXxpsPN9+cM/FhFi
 lCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KxdS+Gin+xlLIt6J3jqgXAHdoNsNBHclzeEq82JqKkE=;
 b=WhpvGUMXYiukI4sJE0lO6g/V3IJ+NsLYx0vhvjhEs0NajCc+GARRRsvhfXnEdJFeUv
 7M+F9lg3fL7EA8ccYyb0/Q7Gp8KMxGbhiHPfRE9b8qpZMNwekqjGxuLdn4YzcDbT4leY
 3RkpBftddeRbMEpgvzL6snGO6OuMcEmfissj8k9C703YsXUzkgsADqEQ8SAurlAcYlLT
 U1iCtBkjITbNTxeV4yaAwbbwqtQsPbBkzEfrSLyn8xXPjHpzX6nHzQ1WAQTbwoX/djuS
 2DGXCpVvAMnc8vysPmf0KxW9QF1xGReHz5fl9uNsHM9oyDbUi/mV+Qz52bx8czWdGgGY
 TaZw==
X-Gm-Message-State: AGi0Pub2XjJQUMONn+PFkEpaMjM/oN++qc9y4vx1GxQNvR+eX5I/P5BU
 o49gpUp7SeEFOeGmoWmx3SnqnR33fA==
X-Google-Smtp-Source: APiQypI26ftNXHSek15KJ7VzsyLErbt0jL9/f/qdrP2vjPg1ospz/Y7sG5cr+Vv6xhcZ+wYcG6a3DjK0bw==
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr4021109wro.259.1587131887621; 
 Fri, 17 Apr 2020 06:58:07 -0700 (PDT)
Date: Fri, 17 Apr 2020 14:57:58 +0100
In-Reply-To: <20200417135801.82871-1-tabba@google.com>
Message-Id: <20200417135801.82871-2-tabba@google.com>
Mime-Version: 1.0
References: <20200417135801.82871-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
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

From: Will Deacon <will@kernel.org>

CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in favour
of the latter.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/asm-offsets.c |  2 +-
 arch/arm64/kernel/smp.c         |  2 +-
 arch/arm64/kvm/Kconfig          |  6 ----
 arch/arm64/kvm/Makefile         | 54 ++++++++++++++++-----------------
 arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
 5 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9981a0a5a87f..a27e0cd731e9 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -96,7 +96,7 @@ int main(void)
   DEFINE(CPU_BOOT_PTRAUTH_KEY,	offsetof(struct secondary_data, ptrauth_key));
 #endif
   BLANK();
-#ifdef CONFIG_KVM_ARM_HOST
+#ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 061f60fe452f..0a3045d9f33f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -430,7 +430,7 @@ static void __init hyp_mode_check(void)
 			   "CPU: CPUs started in inconsistent modes");
 	else
 		pr_info("CPU: All CPU(s) started at EL1\n");
-	if (IS_ENABLED(CONFIG_KVM_ARM_HOST))
+	if (IS_ENABLED(CONFIG_KVM))
 		kvm_compute_layout();
 }
 
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449386d76441..ce724e526689 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -28,7 +28,6 @@ config KVM
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
-	select KVM_ARM_HOST
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
 	select KVM_VFIO
@@ -50,11 +49,6 @@ config KVM
 
 	  If unsure, say N.
 
-config KVM_ARM_HOST
-	bool
-	---help---
-	  Provides host support for ARM processors.
-
 config KVM_ARM_PMU
 	bool
 	---help---
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7a3768538343..a5334b91729a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -7,33 +7,33 @@ ccflags-y += -I $(srctree)/$(src)
 
 KVM=../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp/
+obj-$(CONFIG_KVM) += kvm.o
+obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM_ARM_HOST) += arm.o mmu.o mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += psci.o perf.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hypercalls.o
-kvm-$(CONFIG_KVM_ARM_HOST) += pvtime.o
+kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
+kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
+kvm-$(CONFIG_KVM) += psci.o perf.o
+kvm-$(CONFIG_KVM) += hypercalls.o
+kvm-$(CONFIG_KVM) += pvtime.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM_ARM_HOST) += aarch32.o
-kvm-$(CONFIG_KVM_ARM_HOST) += arch_timer.o
-kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
+kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
+kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
+kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
+kvm-$(CONFIG_KVM) += aarch32.o
+kvm-$(CONFIG_KVM) += arch_timer.o
+kvm-$(CONFIG_KVM)  += pmu-emul.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-init.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v4.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-its.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-debug.o
+kvm-$(CONFIG_KVM) += vgic/vgic.o
+kvm-$(CONFIG_KVM) += vgic/vgic-init.o
+kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
+kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
+kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
+kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM) += vgic/vgic-its.o
+kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index dc18274a6826..8229e47ba870 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -6,17 +6,17 @@
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 		$(DISABLE_STACKLEAK_PLUGIN)
 
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += aarch32.o
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += entry.o
-obj-$(CONFIG_KVM_ARM_HOST) += switch.o
-obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
-obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
+obj-$(CONFIG_KVM) += vgic-v3-sr.o
+obj-$(CONFIG_KVM) += timer-sr.o
+obj-$(CONFIG_KVM) += aarch32.o
+obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
+obj-$(CONFIG_KVM) += sysreg-sr.o
+obj-$(CONFIG_KVM) += debug-sr.o
+obj-$(CONFIG_KVM) += entry.o
+obj-$(CONFIG_KVM) += switch.o
+obj-$(CONFIG_KVM) += fpsimd.o
+obj-$(CONFIG_KVM) += tlb.o
+obj-$(CONFIG_KVM) += hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
