Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD94C47259
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 751282073B
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VstsnSMm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 751282073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8BA4B33D;
	Tue,  5 May 2020 11:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnk7wxKduzm8; Tue,  5 May 2020 11:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C73D24B36F;
	Tue,  5 May 2020 11:45:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D42914B33D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id snxfZ1bT0ko1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 11:45:25 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B43B54B2D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:45:25 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id f56so2063101qte.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6E728oAuh0fw24Auko8ywQH+Oj/Fu4+95HCtL/JyNN4=;
 b=VstsnSMmyjBnbchIs04xsJJHJ20VSFG76AKeVBP6xHSZNN1Gxq33xBGXaUBsnpEdnt
 cqqv53Dh5NHK/HnJ5umgxjFNVPKicVb6txrGN6BXLelY8z2gcQelG16YJSnBigf0jy3u
 jYpoE91WLXX12b6J26ev19C/3OiXIF36ARyndEaplG5OSwqtV5IBl/e+CB5eP1v+BUtB
 2bePAIzrSJEGP8pmwCuGxB60ACPBVJFOgwpCZAwdhJ6HZv5cIWAp3rz9AAkwDYXf10MF
 REeeOcAy/ekuHV0/hBJTQnSIaD9hIf3zrjeOgOMk6ofKZSq8N3cAuAgiWhS7WPc6MH6E
 30NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6E728oAuh0fw24Auko8ywQH+Oj/Fu4+95HCtL/JyNN4=;
 b=MDnuara6kgnfLlCmszoj0wv4q/qRkjlGeCHiVEwKimgQCQMlT4ge0t+lNue4OpJmCo
 Jjsq7bC5wrAdp/PAeIp/jlRCtbyrn6W8+NZSNx7UWuJ2atZahwebzge1/AjRCPDEKIJW
 fXcQSnYfwdE5sNniKUtEDGtbhsMASbvArs3DagV7ZWgmpjpuA+gxVZxXKkY3/Rg5/Zb8
 uLuMcGqdCsOLI5geq2efo/ig8aFLUuB0I/4CSiYV9mnw+5CQg7u+RGx5Yc5YNRDrk+iA
 ngqvqpGMs7iHc3kJXNYc26MP3WK08l+FiLtrysnUeHzervSOJ8d+fweYbnTxt26ri4IO
 lY9A==
X-Gm-Message-State: AGi0PuZamciXEkULel8n1XeoLlYHtGey5iAvjHHGA9EdkOoic69K396I
 su3Agq90EsxUxEde2jsSLnm5cwd7GA==
X-Google-Smtp-Source: APiQypL4tzeVxT7WYDI2EERjj/SBG3wyxeNgjkfHpNxF+NmQFSK75SAy4wtrKK4cJYT4MVquMUCd8FclOw==
X-Received: by 2002:a0c:ed26:: with SMTP id u6mr3398262qvq.220.1588693525176; 
 Tue, 05 May 2020 08:45:25 -0700 (PDT)
Date: Tue,  5 May 2020 16:45:17 +0100
In-Reply-To: <20200505154520.194120-1-tabba@google.com>
Message-Id: <20200505154520.194120-2-tabba@google.com>
Mime-Version: 1.0
References: <20200505154520.194120-1-tabba@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH v5 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, julien.thierry.kdev@gmail.com, 
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kernel/asm-offsets.c |  2 +-
 arch/arm64/kernel/cpu_errata.c  |  2 +-
 arch/arm64/kernel/smp.c         |  2 +-
 arch/arm64/kvm/Kconfig          |  6 ----
 arch/arm64/kvm/Makefile         | 52 ++++++++++++++++-----------------
 arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
 6 files changed, 40 insertions(+), 46 deletions(-)

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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index df56d2295d16..a102321fc8a2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,7 +234,7 @@ static int detect_harden_bp_fw(void)
 		smccc_end = NULL;
 		break;
 
-#if IS_ENABLED(CONFIG_KVM_ARM_HOST)
+#if IS_ENABLED(CONFIG_KVM)
 	case SMCCC_CONDUIT_SMC:
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc;
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
index 7a3768538343..419696e615b3 100644
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
+kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
+kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
+kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
+kvm-$(CONFIG_KVM) += aarch32.o
+kvm-$(CONFIG_KVM) += arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
 
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
2.26.2.526.g744177e7f7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
