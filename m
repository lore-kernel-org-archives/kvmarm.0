Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F8935C6B7;
	Mon,  3 Aug 2026 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764711; cv=none; b=gqSlvrXD94zjf6SyboEAeZY/oBxg5De55p8Np6wzF8H1O5yQg8AAJTw6b6p1nrOa17b57n380UfP6dKxG40Z2UNdvwemNvJCbGR/NXmcNV/sM1MJ6YcvujLD46hk0T3b85Yq6KZIg/h9wWiremgbe+Avjnv49gkaBU2KI9HsKg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764711; c=relaxed/simple;
	bh=YLMzS57B0Blt2+xGLVJcY5KsMCzwEAb8VT/RdBje/y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rx+R548Sswo4WfyxNtIgbicFBP6ez464PYmH6jCqKOgW5bJS/7rcO6B4UIQbh82hBzwFLUwruZtOoPpDu8KtE7ppLu9EDAU4bnHPFBz6v8Ri/gROorZcOaUuzSDatZ+WDO0K9V4CqLWFFiXt7raObo014KGmwlAnCDXOjZ8FmiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mnBB10PY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mnBB10PY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 548D1143D;
	Mon,  3 Aug 2026 06:45:05 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D1033F66F;
	Mon,  3 Aug 2026 06:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764709; bh=YLMzS57B0Blt2+xGLVJcY5KsMCzwEAb8VT/RdBje/y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnBB10PYXt0wMv0qsGnPZYXiSsv0pxi0j3Mjma4uUeMcqS84WE4KGuon2AuO/f7Vo
	 HgzRHGl2kcN6V0LSlqjaBkVNyDLBSCS2eNXZwlDDWI4a7LqcY++bzm1H9e4PnC5/Lj
	 VpMGSU1hfn3SFINbVa4szKaui/Bo5r4HZxGQpDQw=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 11/45] KVM: arm64: CCA: Check for RMI support at KVM init
Date: Mon,  3 Aug 2026 14:43:27 +0100
Message-ID: <20260803134403.80630-12-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if the RMI support is sufficient for using in KVM. Specifically, we
currently only support creating realm VMs when KVM is running in VHE mode.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v13:
 * Most of the init has been moved out of the 'kvm' directory so this is
   much more basic now.
Changes since v12:
 * Drop check for 4k page size.
Changes since v11:
 * Reword slightly the comments on the realm states.
Changes since v10:
 * kvm_is_realm() no longer has a NULL check.
 * Rename from "rme" to "rmi" when referring to the RMM interface.
 * Check for RME (hardware) support before probing for RMI support.
Changes since v8:
 * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
Changes since v6:
 * Improved message for an unsupported RMI ABI version.
Changes since v5:
 * Reword "unsupported" message from "host supports" to "we want" to
   clarify that 'we' are the 'host'.
Changes since v2:
 * Drop return value from kvm_init_rme(), it was always 0.
 * Rely on the RMM return value to identify whether the RSI ABI is
   compatible.
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/include/asm/kvm_rmi.h  | 17 +++++++++++++++++
 arch/arm64/include/asm/virt.h     |  1 +
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/rmi.c              | 24 ++++++++++++++++++++++++
 7 files changed, 53 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..1a5e15040111 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_rmi.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -424,6 +425,9 @@ struct kvm_arch {
 	/* Nested virtualization info */
 	struct dentry *debugfs_nv_dentry;
 #endif
+
+	bool is_realm;
+	struct realm realm;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
new file mode 100644
index 000000000000..57d24b244c95
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#ifndef __ASM_KVM_RMI_H
+#define __ASM_KVM_RMI_H
+
+/**
+ * struct realm - Additional per VM data for a Realm
+ */
+struct realm {
+};
+
+void kvm_init_rmi(void);
+
+#endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b546703c3ab9..92cec42952f4 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -87,6 +87,7 @@ void __hyp_reset_vectors(void);
 bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+DECLARE_STATIC_KEY_FALSE(kvm_rmi_is_available);
 
 static inline bool is_pkvm_initialized(void)
 {
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..189e8ad78b22 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
+	select ARM_RMM
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..ed3cf30eb06e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o config.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
-	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
+	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..b961c22fce3d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -42,6 +42,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/kvm_rmi.h>
 #include <asm/sections.h>
 #include <asm/stacktrace/nvhe.h>
 
@@ -111,6 +112,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
 	return -EINVAL;
 }
 
+DEFINE_STATIC_KEY_FALSE(kvm_rmi_is_available);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
@@ -3019,6 +3022,8 @@ static __init int kvm_arm_init(void)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
+	kvm_init_rmi();
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
new file mode 100644
index 000000000000..384991d69f78
--- /dev/null
+++ b/arch/arm64/kvm/rmi.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/rmi_cmds.h>
+#include <asm/virt.h>
+
+void kvm_init_rmi(void)
+{
+	/*
+	 * TODO: Support Realm guests in nVHE mode, this will require adding
+	 * EL2 stub(s) for REC entry and possibly other things.
+	 */
+	if (!is_kernel_in_hyp_mode())
+		return;
+
+	if (!is_rmi_available())
+		return;
+
+	/* Future patch will enable static branch kvm_rmi_is_available */
+}
-- 
2.43.0

