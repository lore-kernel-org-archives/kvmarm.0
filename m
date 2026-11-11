Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409112;
	b=TceLpcQ0x/Y/yLO67lRoF7MVKsRMHCOS2yfDSEyk8MkjU4sgZWuLdDcsUjezgwZEJp/f
	 wgT/lsSgBP1mhvDptGZ9JmyZ10c87Oxp1KghxIyYyFJgaZrJvsra/Y2zJTeiMWNjnQ8Ix
	 Nw0mwGWclKiguVqdDNqVFdKkSXL+LkVYuGOPZEAh7W8NTwxlj3a5ATJdWlhoAedZjxFUF
	 YTk0BOBqS9nzrURgiPMrQoBmxagh/T9vljsQSNOf3rW7KsbdEjYMhH8iuGCGcz9r87kxP
	 8ELlQNo9FcJpvtCjqdVQjEcOOavi0Y+nBV5h/eS4xikGy/DsSJCF8NKj5Vmf1PNCh1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409112;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c6yV9q1Iw5MMcvKrmrnLR6tmlXeGeurNYp/FDUg+qMQ=;
	b=P4TklB1QzhgBDlpsalBljNCWh0g55DI/oObdl7Eo5G6vrnvZ3xrOSf8D8EPivTM+SjIg
	 X923kkkT/TcvribxekheeLXhr4jAeBEKYhPpjjv2BnSFdgTzxBeJzvS5Yk79Cp+S5+YAM
	 aee5jf+qqKI8eqSS5J9TSmvK95habU/AI/H89flz7x+Poyqt0509jtnflFrzxQD1lcKvR
	 3liknHLbsoxkDnwphIqJqvVEIZk7WuxHQHTsOjiK/b1hrlO2MFEKlD7D63RaXhuea2k4x
	 GKyBNp4FWT1pO7sl6rBJV9vp8UqYXC3eKkLRCMlJxVbxjM1FQFNFzNKxEqkivefMfAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=c7JEytPg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3474960A6F46;
	Wed, 11 Nov 2026 14:58:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3474960A6F46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=c7JEytPg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8347F1576;
	Wed, 11 Nov 2026 06:58:28 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 266C53F632;
	Wed, 11 Nov 2026 06:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409111; bh=CGXh5SkCpanBdfAOOkNZ1WjJ8mfPhaQnibXz7Ha7tws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7JEytPg6T2HmROMXoHdpDFHgKUNqxqjpysOzPJ/X0a88+p1iXtltFZKOrZVIhFsS
	 J+86QFjhZIXAOwDPVmfjFNc5DRCyLJCfGTOxo1RNHqwnBRwAcI+ViQyERe/272UqMz
	 3igbcqFU5LyPEaa6nOJmAHp+BXz+GqpOWHDvEeHU=
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH v2 04/12] KVM: arm64: CCA: Check RMI support and features at init
Date: Wed, 11 Nov 2026 14:57:48 +0000
Message-ID: <20261111145758.217946-5-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>
References: <20261111145758.217946-1-steven.price@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wire RMI initialization into KVM startup and select ARM_RMM_RMI.
Proceed only when RMM mode is selected and RMI is available. If
KVM uses LPA2, require RMM LPA2 support. Also require SHA-256
measurement support.

Define a disabled kvm_rmi_is_available static key for later Realm
capability checks. The key is enabled after the remaining Realm
support is in place.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Combine the separate v1 RMI availability and LPA2/SHA-256 feature
  check patches into one initialization patch.
---
 arch/arm64/include/asm/kvm_rmi.h |  2 ++
 arch/arm64/include/asm/virt.h    |  1 +
 arch/arm64/kvm/Kconfig           |  1 +
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/arm.c             |  5 ++++
 arch/arm64/kvm/rmi.c             | 42 ++++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h     |  5 ++++
 7 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/rmi.c

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 67f16793b4d0..3194daaacf2b 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -56,4 +56,6 @@ struct realm {
 	enum realm_state state;
 };
 
+void kvm_init_rmi(void);
+
 #endif /* __ASM_KVM_RMI_H */
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
index cecea0820e52..d067063a3686 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,6 +34,7 @@ menuconfig KVM
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select KVM_GUEST_MEMFD
 	select KVM_GENERIC_PRE_FAULT_MEMORY
+	select ARM_RMM_RMI
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7aaeeb84e788..66a719ab5b6b 100644
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
index e06cc390a3d6..318e8a4b19f8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -42,6 +42,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/kvm_rmi.h>
 #include <asm/sections.h>
 #include <asm/stacktrace/nvhe.h>
 
@@ -112,6 +113,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext)
 	return -EINVAL;
 }
 
+DEFINE_STATIC_KEY_FALSE(kvm_rmi_is_available);
+
 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
 
 DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
@@ -3272,6 +3275,8 @@ static __init int kvm_arm_init(void)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
+	kvm_init_rmi();
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
new file mode 100644
index 000000000000..f4c45021c6f7
--- /dev/null
+++ b/arch/arm64/kvm/rmi.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/arm-rmi-cmds.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_pgtable.h>
+#include <asm/virt.h>
+
+static int rmm_check_features(void)
+{
+	if (kvm_lpa2_is_enabled() &&
+	    !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
+		kvm_err("RMM doesn't support LPA2\n");
+		return -ENXIO;
+	}
+
+	if (!rmi_has_feature(1, RMI_FEATURE_REGISTER_1_HASH_SHA_256)) {
+		kvm_err("RMM doesn't support SHA-256 measurements\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+void kvm_init_rmi(void)
+{
+	if (kvm_get_mode() != KVM_MODE_RMM)
+		return;
+
+	if (!is_rmi_available()) {
+		kvm_info("Realm VM support is disabled because RMI is not available\n");
+		return;
+	}
+
+	if (rmm_check_features())
+		return;
+
+	/* Future patch will enable static branch kvm_rmi_is_available */
+}
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index a84e50ac851c..6f43eac7c7be 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -67,6 +67,11 @@ static __always_inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *reg
 
 unsigned long rmi_feat_reg(unsigned int index);
 
+static inline bool rmi_has_feature(unsigned int index, unsigned long feature)
+{
+	return !!(rmi_feat_reg(index) & feature);
+}
+
 int rmi_delegate_range(phys_addr_t phys, unsigned long size,
 		       phys_addr_t *out_phys);
 int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
-- 
2.43.0

