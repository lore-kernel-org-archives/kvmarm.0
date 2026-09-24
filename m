Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C8E4BE436;
	Thu, 24 Sep 2026 16:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265998; cv=none; b=lwM79sZkqA+jSvdXjubQhaumuqC4ZQTy5/OM18KP5mTY+c3rkqS9L3Q41KUkiaH6jT9mPuNRX84UV6ghNOCT2f6uBV0pd0HuA18wgwecfqMWRZ1k+tZgxg//62jxPcDeJWfxoMrNtACkAnetw6ACjkAfsBoxOU19qSGBQdIxJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265998; c=relaxed/simple;
	bh=BM89Q9V6ocI5DXYHAW82EU89jCBnsdhkyTNrWtCCZCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7nzSRzEFx+K5HqKgJFHxHzbihfyygQTR8kGBpJv4FiN+mDeZEB5SF1Q03Ax8wkvGfm4H/vdcNRNcDmsrKVizh1AVtDQe1HMp1tmUcSq59FDN2PqD7BwNOxALNS46/AlF8SJJHIdAeZuV6viwP+f7X1CA+BZZPWZ3+CnszYGNFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WtqhBJeq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WtqhBJeq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 832F51EA6;
	Thu, 24 Sep 2026 09:06:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F20F83F86C;
	Thu, 24 Sep 2026 09:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265996; bh=BM89Q9V6ocI5DXYHAW82EU89jCBnsdhkyTNrWtCCZCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtqhBJeq3NM182+Wl9zn6MmWbh5D/c18CDNgFixTtrt0fkbueLz53dgq8Fq+/zWlb
	 zaitDW+WCEtacy4cEwbRd3ILU+yoxos8Gh7tuGc5lx8Axy/ng4AdST421AKup+vsnx
	 12/dqb++iDxXsbEDmXjF4q6M/ziwrNcxzB76EnEM=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v20 17/22] KVM: arm64: CCA: Introduce Realms
Date: Thu, 24 Sep 2026 17:04:59 +0100
Message-ID: <20260924160504.853911-18-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

Add foundational work for supporting Realms.
 - Add a new VM flavor.
 - At KVM init, check if the KVM can support Realms (though not functional yet)
   and will be advertised by static key kvm_rmi_is_available. This will be
   turned on in a later patches, once we have all the bits and pieces ready.
   For now check if we are blessed with KVM_MODE_RMM.
 - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
   states are mutually exclusive, move them into a union.

Please note that we cannot create Realm VMs yet. This requires further changes
to the UABI and core RMI driver support, which will come later.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v16:
 * Share mutually exclusive pKVM and Realm per-VM storage in a union.
 * Move to the new VM flavor infrastructure, split bits out. Trimmed down
 * Move in Realm state and basic boiler plates
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
 arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++
 arch/arm64/include/asm/kvm_host.h    | 18 +++++---
 arch/arm64/include/asm/kvm_rmi.h     | 61 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/virt.h        |  1 +
 arch/arm64/kvm/Makefile              |  2 +-
 arch/arm64/kvm/arm.c                 |  6 +++
 arch/arm64/kvm/mmu.c                 |  1 +
 arch/arm64/kvm/rmi.c                 | 18 ++++++++
 8 files changed, 117 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h
 create mode 100644 arch/arm64/kvm/rmi.c

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a3c1928bdf743..d360a8b05b8bf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -793,4 +793,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, 0, reset_state->r0);
 }
 
+static inline enum realm_state kvm_realm_state(struct kvm *kvm)
+{
+	return READ_ONCE(kvm->arch.realm.state);
+}
+
+static inline void kvm_set_realm_state(struct kvm *kvm,
+				       enum realm_state new_state)
+{
+	WRITE_ONCE(kvm->arch.realm.state, new_state);
+}
+
+static inline bool kvm_realm_is_created(struct kvm *kvm)
+{
+	return kvm_vm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4516594d90462..c60e1ee8d1644 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_rmi.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -334,6 +335,7 @@ enum kvm_arm_vm_flavor {
 	VM_PKVM,		/* Normal guests on pKVM */
 	MARKER(__VM_PROTECTED),
 	VM_PROTECTED_PKVM,	/* Protected VM */
+	VM_REALM,		/* CCA */
 	VM_FLAVOR_MAX
 };
 
@@ -451,11 +453,14 @@ struct kvm_arch {
 	/* Count the number of VNCR_EL2 TLBs */
 	atomic_t vncr_tlb_count;
 
-	/*
-	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
-	 * the associated pKVM instance in the hypervisor.
-	 */
-	struct kvm_protected_vm pkvm;
+	union {
+		/*
+		 * For an untrusted host VM, 'pkvm.handle' is used to lookup
+		 * the associated pKVM instance in the hypervisor.
+		 */
+		struct kvm_protected_vm pkvm;
+		struct realm realm;
+	};
 
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	/* Nested virtualization info */
@@ -1578,6 +1583,9 @@ struct kvm *kvm_arch_alloc_vm(void);
 #define kvm_vm_is_unprotected_pkvm(kvm)		\
 	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PKVM))
 
+#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
+#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
+
 #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
new file mode 100644
index 0000000000000..44f5c75a27b5b
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#ifndef __ASM_KVM_RMI_H
+#define __ASM_KVM_RMI_H
+
+/**
+ * enum realm_state - State of a Realm
+ *
+ * Mirrors the RMM's Realm lifecycle states where they are meaningful to KVM,
+ * with REALM_STATE_DYING being a KVM-internal state used to prevent further
+ * requests while teardown is in progress. KVM does not track REALM_SYSTEM_OFF
+ * or REALM_ZOMBIE separately as they naturally lead to teardown.
+ */
+enum realm_state {
+	/**
+	 * @REALM_STATE_NONE:
+	 *      Realm has not yet been created. rmi_realm_create() has not
+	 *      yet been called.
+	 */
+	REALM_STATE_NONE,
+	/**
+	 * @REALM_STATE_NEW:
+	 *      Realm is under construction, rmi_realm_create() has been
+	 *      called, but it is not yet activated. Pages may be populated.
+	 */
+	REALM_STATE_NEW,
+	/**
+	 * @REALM_STATE_ACTIVE:
+	 *      Realm has been created and is eligible for execution with
+	 *      rmi_rec_enter(). Pages may no longer be populated with
+	 *      rmi_data_create().
+	 */
+	REALM_STATE_ACTIVE,
+	/**
+	 * @REALM_STATE_DYING:
+	 *      Realm is in the process of being destroyed or has already been
+	 *      destroyed.
+	 */
+	REALM_STATE_DYING,
+	/**
+	 * @REALM_STATE_DEAD:
+	 *      Realm has been destroyed.
+	 */
+	REALM_STATE_DEAD
+};
+
+/**
+ * struct realm - Additional per VM data for a Realm
+ *
+ * @state: The lifetime state machine for the realm
+ */
+struct realm {
+	enum realm_state state;
+};
+
+void kvm_init_rmi(void);
+
+#endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index b546703c3ab9a..92cec42952f42 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -87,6 +87,7 @@ void __hyp_reset_vectors(void);
 bool is_kvm_arm_initialised(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+DECLARE_STATIC_KEY_FALSE(kvm_rmi_is_available);
 
 static inline bool is_pkvm_initialized(void)
 {
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..ed3cf30eb06e7 100644
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
index 8b1beddd80ea5..0e77f59ded6d9 100644
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
@@ -2237,6 +2240,7 @@ static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
 	KVM_VCPU_OPS(VM_VHE, &vhe_vcpu_ops),
 	KVM_VCPU_OPS(VM_PKVM, &pkvm_vcpu_ops),
 	KVM_VCPU_OPS(VM_PROTECTED_PKVM, &pkvm_vcpu_ops),
+	KVM_VCPU_OPS(VM_REALM, &realm_vcpu_ops),
 };
 
 static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
@@ -3190,6 +3194,8 @@ static __init int kvm_arm_init(void)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
+	kvm_init_rmi();
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1d2265801e7aa..bea252bf49f6a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2911,6 +2911,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, &kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, &pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, &protected_pkvm_vm_s2_ops),
+	KVM_VM_S2_OPS(VM_REALM, &realm_vm_s2_ops),
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
new file mode 100644
index 0000000000000..5ecc8b3498698
--- /dev/null
+++ b/arch/arm64/kvm/rmi.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/virt.h>
+
+void kvm_init_rmi(void)
+{
+	if (kvm_get_mode() != KVM_MODE_RMM)
+		return;
+
+	/* TODO: Check if the RMI is available */
+
+	/* Future patch will enable static branch kvm_rmi_is_available */
+}
-- 
2.43.0

