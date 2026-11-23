Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430592;
	b=FEcsUb2CUnVEi6OxIa9/lAaTwLxV+DLSt0dxaIu8ilUZRFBth3nrnJzk1gGf6EU+1r+j
	 2GkE6UxAqdkWZsi3m/soUPRuBrH6YZgY9rBK/wPBpHgKtyKn9/JG/mfLV9oKE5nc9bYEe
	 MvDWYHjKPAva0vGWvLaqVOzZqGPtErTLTyy3ALWure/7rqmLeKqQhI4SWQJuNckxrI4+j
	 /+YDaeHuWzpFz4WAQ0bp0sEBi+ks8c8HEQF9Y5ldeR69GEgylDZuHW1FHwAQTaaIz3sgP
	 PGqRlgFDm/QTX3R9FLMJ91tak4X8CJyI1iDYt176AciMmCpCpa8ite9M0VI1JR1CTYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430592;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5ovsMQzRol/X1iPsq1cszdC0SEFWLWsESeESwE4NgrE=;
	b=sqwEg8F/Au/6IdriUdkzpfkY2R4VSfv7/qJgF/ldyZ3fZruLJrkkJef5d9Y1HWAeO7aw
	 T+5zBGv4pMmrL4gbMRTn1q33rsjFQZVuoO6KucmzRiMLQQRz9a/99DvNExSZVkIpvVRHb
	 MlIVSKTrLgYGIF9MuUXhRa228MDpbBHiD3t8RkbU7knLZyy1kRERA+CNaDU8zIUm1Nq8d
	 v82cLV1YYk4CsJ+5/ZPiuoOqNjC/2W6BQc/pwPcbUg4Gd6XSMY+ECShxEOBTtfJQVNyx1
	 DkGirqiVLH5e4unJtZbhWHy0XgFg1llb65OJSrTCr2nWoVQc76+/0G1X2e8SBYFpBIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ncNrshYi;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72095606A32D;
	Mon, 23 Nov 2026 10:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72095606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ncNrshYi
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 208261A25;
	Mon, 23 Nov 2026 02:43:09 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C28B3F632;
	Mon, 23 Nov 2026 02:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430592; bh=AWz2lst629eEZ2QMYlUJYNkbosJoCh3LfIL4p0Mt1qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncNrshYiKMGpLQlDU4lPUshtPJW03K+JvwJiNo8t7Yo62y1jf3pkIF1hJEgRcv15K
	 lmMvn2Z5Cba30SkfWHSHwdpqyTENpY0+mub2AgS27p3r/7Y6TthHQqm+6e/mFblLfv
	 EIJcfRT0uMAQiHe24KMkuHBYP1xh49b3P0kJGZZI=
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
Subject: [PATCH v4 05/11] KVM: arm64: CCA: Add basic infrastructure for creating a realm
Date: Mon, 23 Nov 2026 10:42:25 +0000
Message-ID: <20261123104233.95710-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123104233.95710-1-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
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

Introduce the skeleton functions for creating and destroying a realm.
The requested IPA size is checked against both the KVM and RMM limits.

The actual work of constructing the realm will be added in future
patches.

Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Use the preceding destruction dispatch instead of a temporary
  Realm-specific check in kvm_stage2_destroy().

Changes since v2:
- Move ARM_RMM_RMI selection and rmi.o build registration here.
  Store the RD physical address from the outset and free SRO state
  on Realm teardown errors.

Changes since v1:
- Cap the Realm IPA size at the smaller KVM and RMM limit, and record
  the selected IPA size when initializing Realm state.
---
 arch/arm64/include/asm/kvm_rmi.h | 23 ++++++++++++
 arch/arm64/kvm/Kconfig           |  1 +
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/arm.c             |  9 +++++
 arch/arm64/kvm/mmu.c             |  7 +++-
 arch/arm64/kvm/rmi.c             | 63 ++++++++++++++++++++++++++++++++
 6 files changed, 103 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/rmi.c

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 67f16793b4d0..4ac1af622872 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -6,6 +6,9 @@
 #ifndef __ASM_KVM_RMI_H
 #define __ASM_KVM_RMI_H
 
+#include <linux/arm-smccc-rmi.h>
+#include <linux/kvm.h>
+
 /**
  * enum realm_state - State of a Realm
  *
@@ -50,10 +53,30 @@ enum realm_state {
 /**
  * struct realm - Additional per VM data for a Realm
  *
+ * @rd_phys: Physical address of the RMM-managed Realm Descriptor (RD) granule
+ * @sro: Preallocated SRO state context for Realm MMU operations
  * @state: The lifetime state machine for the realm
+ * @ia_bits: Number of valid Input Address bits in the IPA
+ * @start_level: Starting level of the Realm Translation Table
  */
 struct realm {
+	phys_addr_t rd_phys;
+	/*
+	 * Reused by RTT map/unmap SRO commands. Those commands are only
+	 * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
+	 * held for write, including Realm fault handling where
+	 * kvm_fault_lock() takes the write side, so concurrent use is
+	 * serialized.
+	 */
+	struct rmi_sro_state *sro;
 	enum realm_state state;
+	unsigned int ia_bits;
+	int start_level;
 };
 
+u32 kvm_rmm_ipa_limit(void);
+
+int kvm_init_realm(struct kvm *kvm);
+void kvm_destroy_realm(struct kvm *kvm);
+
 #endif /* __ASM_KVM_RMI_H */
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
index d79e5451923d..7c22d9474a38 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -300,6 +300,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	/* Initialise the realm bits after the generic bits are enabled */
+	if (kvm_vm_is_realm(kvm)) {
+		ret = kvm_init_realm(kvm);
+		if (ret)
+			goto err_uninit_mmu;
+	}
+
 	return 0;
 
 err_uninit_mmu:
@@ -364,6 +371,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_destroy_nested(kvm);
 	kvm_arm_teardown_hypercalls(kvm);
+	if (kvm_vm_is_realm(kvm))
+		kvm_destroy_realm(kvm);
 }
 
 static bool kvm_has_full_ptr_auth(void)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fab915ddeaab..84b02699f103 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -981,10 +981,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 
 static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	u32 kvm_ipa_limit = get_kvm_ipa_limit();
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
+	if (kvm_vm_is_realm(kvm))
+		kvm_ipa_limit = min(kvm_ipa_limit, kvm_rmm_ipa_limit());
+
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
@@ -1097,6 +1101,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 	}
 
+	mmu->arch = &kvm->arch;
+
 	err = kvm_init_ipa_range(mmu, type);
 	if (err)
 		return err;
@@ -1105,7 +1111,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	if (!pgt)
 		return -ENOMEM;
 
-	mmu->arch = &kvm->arch;
 	err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
new file mode 100644
index 000000000000..fafca2439c46
--- /dev/null
+++ b/arch/arm64/kvm/rmi.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/arm-rmi-cmds.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/virt.h>
+
+u32 kvm_rmm_ipa_limit(void)
+{
+	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
+}
+
+void kvm_destroy_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+
+	if (!kvm_realm_is_created(kvm))
+		goto out_free_sro;
+
+	kvm_set_realm_state(kvm, REALM_STATE_DYING);
+
+	if (realm->rd_phys) {
+		phys_addr_t rd_phys = realm->rd_phys;
+
+		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
+			goto out_free_sro;
+
+		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
+			goto out_free_sro;
+		rmi_free_delegated_page(rd_phys);
+		realm->rd_phys = 0;
+	}
+
+	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
+					 pgd_size)))
+		goto out_free_sro;
+
+	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
+
+out_free_sro:
+	kfree(realm->sro);
+	realm->sro = NULL;
+}
+
+int kvm_init_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	realm->start_level = 4 - VTCR_EL2_LVLS(kvm->arch.mmu.vtcr);
+	realm->sro = kmalloc_obj(*realm->sro);
+	if (!realm->sro)
+		return -ENOMEM;
+
+	return 0;
+}
-- 
2.43.0

