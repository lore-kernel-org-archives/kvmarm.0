Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1822EC2BB55
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEBA7221EA
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 08:55:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="FWOmCF4o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEBA7221EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69EBA4B18F;
	Fri, 17 Apr 2020 04:55:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+2aSLSCJtBp; Fri, 17 Apr 2020 04:55:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEA614B1F5;
	Fri, 17 Apr 2020 04:55:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F284B18E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ttr5y3eJZI4F for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 04:55:31 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A46544B1F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 04:55:30 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id h184so678350wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 01:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=aZsCkB66MWgB0Uu6l7KPHtYY3D1zXgcjx4uFkOi2b14=;
 b=FWOmCF4owA7wxCqRMJe+bLosN3wGieA7FPWzHaLXtfNKJjgB7LgWALxmMNYNvfKWGO
 kc6c1Fr6onRfAzgu4LHBzQL5Wnwo3tmXxhA4nf4QMBazJrD7aLekocl1lCKE6f3PecFP
 /FRq/w+SOV0J50v8048rlLNdDGliu9JW2m05uPG+3fJebDotPFQ+a8oMsQBu+N4I00Yu
 oOk2BRkKFGvnr/AlpcIoLIG01vooJ7lg5kUp2+wiXA5bG0cRfdM+yyZlBUPAZwFkkDH+
 jR9oxk/QZotdBaOpUuh6fkd0rEM0wGUB6lm4ciuO/fO28zpA2XdqEpVAVq0xSGScMofj
 OJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=aZsCkB66MWgB0Uu6l7KPHtYY3D1zXgcjx4uFkOi2b14=;
 b=XHu+LxBiHB1j1BNXxdDvEKIBUCM0IEMaKAPnyGFZSct+9zX6OMX9NSqa8JiYO4Y2I0
 55V/y3Z+uQbbSJ3K34sJl4e1pn/KtP5BgkpWCiwDilrnm3HNgsJx7Jwa5o3eG3s1gpZy
 LAroQocyCGEceMSOOFnI5HTl2HPSThlxtRW1yIctjgvb5IRfeXGVkS8FcgExPmc1NXGI
 Ij2gOXXVu2BgXhzI3XyvkMo/eG5JA1d0gCrr28QCUtL0Js4U2tPDInbeipiwWY49loKc
 4vAMd8eGMlG5iWXrdU7t0BQIrQ3Te03VZmcPRDQvgz4p+0NzScvn5jGOTMVRjbW21BDX
 brcw==
X-Gm-Message-State: AGi0PuaLYuaityZ44fHZJDXd+ToFcaTm77cMWeFm31fzeiuEF+1yQDCQ
 LNVqTQ2a2OJYkVRLh0zZKbRchAuJyQ==
X-Google-Smtp-Source: APiQypLLR1MhrnANwTWhpy89c7daniFlvHEizy+CL7TtibY57t2Cphb8GWkpCaZQdfPBTETbyf0Kn7/OAw==
X-Received: by 2002:adf:904e:: with SMTP id h72mr2631838wrh.367.1587113729667; 
 Fri, 17 Apr 2020 01:55:29 -0700 (PDT)
Date: Fri, 17 Apr 2020 09:55:19 +0100
In-Reply-To: <20200417085522.150701-1-tabba@google.com>
Message-Id: <20200417085522.150701-2-tabba@google.com>
Mime-Version: 1.0
References: <20200417085522.150701-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
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
 arch/arm64/kvm/Makefile         | 52 ++++++++++++++++-----------------
 arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
 5 files changed, 39 insertions(+), 45 deletions(-)

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
index 5ffbdc39e780..2d968e9ac792 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -7,33 +7,33 @@ ccflags-y += -I $(srctree)/$(src) -I $(srctree)/virt/kvm/arm/vgic
 
 KVM=../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp/
+obj-$(CONFIG_KVM) += kvm.o
+obj-$(CONFIG_KVM) += hyp/
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
+kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/hypercalls.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/pvtime.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
-kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
+kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
+kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
+kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/aarch32.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-irqfd.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v4.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-init.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-irqfd.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v2.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v3.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-v4.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio-v2.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-mmio-v3.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-its.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/vgic/vgic-debug.o
+kvm-$(CONFIG_KVM) += $(KVM)/irqchip.o
+kvm-$(CONFIG_KVM) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..ad4c173ed036 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -8,18 +8,18 @@ ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
 
 KVM=../../../../virt/kvm
 
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/aarch32.o
+obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/vgic-v3-sr.o
+obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/timer-sr.o
+obj-$(CONFIG_KVM) += $(KVM)/arm/hyp/aarch32.o
 
-obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
-obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
-obj-$(CONFIG_KVM_ARM_HOST) += entry.o
-obj-$(CONFIG_KVM_ARM_HOST) += switch.o
-obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
-obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
-obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
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
2.26.0.110.g2183baf09c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
