Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409108;
	b=uq9IjcpUX+NphNDnlHW4lZXdkwFkqbKfCrvV301epFgBBWx8gjXUSfk2B5Zg09iIWPsr
	 ZdEZksLc//XvplQydA9dNLh0hGMdPL4g7LTXm4P0QqdeVTv9/IFGg5Zg0EM2g9LHZ+dkt
	 svCw8DxdFr4nYCiGviGOe+GFOovBC8g5tV46pTofIzq5GLo1kw4EEQxKeoodnLmv8J7Jg
	 qfA4eIDTPagPgRZj/DLdJxu8B4WbpIG/mZFuV4/QnbQ4UEiP1kPui1nXpdgCULnyiDfbU
	 +rNKniywBFL1wr25G8g4ciIcamQOhIFnMIievF4tgDencobfrQcoM5CjvNx5BtMhqTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409108;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3wZldY8TGi8AJ527yYqycAAeEXCSVzFKqfOkFGMxedY=;
	b=HIWT/AjY6HyLFBGCFo8SYNpsclXCgF71cWzo/EnRTN4kMeLal23upLN3N4NbP+Ih/eYp
	 JNDZv47+7VMBRUUHweg3vAv7BfV9qbzCaT9P/xhqTvv3sn4wiLbz4AlRNEzDWYK3imPFu
	 Kj3MrIgat2Ix+0XYdNhi0WLCC0heXi7bjA6eCxFtKEarEQHu4VttRoNQ/r3/xWtYiBX7i
	 7jXv+gZGoBfLpE1iBAE+NoERZ3tTOJwV1SI0RzHT256l1mM3Tc2zarLQAV101Lox/I8nQ
	 RWOnPgZPkhdsqspwLo/w/0MuJBClGxncBsxGX37RxLivRsbif+zU3WRz9J8NW6kh3eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a5qrX9RD;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F8D606A331;
	Wed, 11 Nov 2026 14:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63F8D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a5qrX9RD
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1A8E1682;
	Wed, 11 Nov 2026 06:58:23 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.58.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94DF43F632;
	Wed, 11 Nov 2026 06:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794409106; bh=ZFd9ksdGmZkOcpIvHNVizs6hvp5chDoMStATqAMb0r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5qrX9RD/gGukkHvaoaOWJ4sfDZQLQ/cBmzTsxQCarY9ZY/o76NFS6mNzNxSwbImW
	 +b2JXrhc1q6K13WtFrzOWbI9quycLO0mA80FBwkApuMY0qRHSj1b4YYv4nah55s5sc
	 81LxMimfoEVsAEUZY4/8s6euQjJ9NYumttwZqJEU=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	Kohei Enju <enju.kohei@fujitsu.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 03/12] KVM: arm64: CCA: Introduce Realms
Date: Wed, 11 Nov 2026 14:57:47 +0000
Message-ID: <20261111145758.217946-4-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Introduce the Realm VM flavor and per-VM state tracking. Realm and
protected pKVM states are mutually exclusive, so share their storage
in kvm_arch. Adjust the protected VM helpers for the new flavor.

Realm VMs cannot be created yet; RMI initialization and the creation
UABI follow in later patches.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v1:
- Move RMI initialization to the RMI checks patch and Realm vCPU
  feature restrictions to the follow-on integration series. Keep
  this patch focused on the Realm VM flavor and per-VM state.
- Limit pKVM power state handling to pKVM vCPUs.
---
 arch/arm64/include/asm/kvm_emulate.h   | 16 +++++++
 arch/arm64/include/asm/kvm_host.h      | 47 ++++++++++++--------
 arch/arm64/include/asm/kvm_rmi.h       | 59 ++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c                   |  7 ++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
 arch/arm64/kvm/mmu.c                   |  1 +
 arch/arm64/kvm/pkvm.c                  |  2 +-
 arch/arm64/kvm/psci.c                  |  2 +-
 10 files changed, 117 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_rmi.h

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 334211b8b2ee..32021bdf2610 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -831,4 +831,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
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
index ccd2dc8f73c3..7948b177bf13 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -29,6 +29,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hcall.h>
+#include <asm/kvm_rmi.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -409,6 +410,7 @@ enum kvm_arm_vm_flavor {
 	VM_PKVM,		/* Normal guests on pKVM */
 	MARKER(__VM_PROTECTED),
 	VM_PROTECTED_PKVM,	/* Protected VM */
+	VM_REALM,		/* CCA */
 	VM_FLAVOR_MAX
 };
 
@@ -502,11 +504,14 @@ struct kvm_arch {
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
@@ -1572,31 +1577,39 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#ifdef __KVM_NVHE_HYPERVISOR__
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
 
-#define kvm_vm_is_protected(kvm)			\
-	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
+#ifdef __KVM_NVHE_HYPERVISOR__
 /*
  * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
  * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
- * which is populated correctly and is gated on is_protected_kvm_enabled().
+ * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
+ * gated on is_protected_kvm_enabled().
  */
-#define vcpu_is_protected(vcpu)						\
+#define vcpu_is_protected(vcpu)		BUILD_BUG_ON(1)
+#else
+#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
+#endif
+
+#define kvm_vm_is_protected_pkvm(kvm)					\
+	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
+
+/*
+ * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
+ * make sure the vcpu->kvm is always valid VA in the context
+ */
+#define vcpu_is_protected_pkvm(vcpu)					\
 	({								\
 		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
 									\
-		(__kvm && kvm_vm_is_protected(__kvm));			\
+		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
 	})
 
-#else
-
-#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
-#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
+#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
+#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
 
 #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
 
-#endif	/* __KVM_NVHE_HYPERVISOR__ */
-
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
new file mode 100644
index 000000000000..67f16793b4d0
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -0,0 +1,59 @@
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
+	 *      Realm is under construction, Realm Descriptor has been created,
+	 *      but it is not yet activated. Memory may be populated.
+	 */
+	REALM_STATE_NEW,
+	/**
+	 * @REALM_STATE_ACTIVE:
+	 *      Realm has been created and is eligible for execution with
+	 *      rmi_rec_enter(). Memory may no longer be populated with known
+	 *	contents.
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
+#endif /* __ASM_KVM_RMI_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b81202..e06cc390a3d6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -877,7 +877,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu, u32 mp_state)
 /* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	u32 mp_state = vcpu_is_protected(vcpu) ? KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
+	u32 mp_state = vcpu_is_protected_pkvm(vcpu) ?
+		       KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
 
 	spin_lock(&vcpu->arch.mp_state_lock);
 	__kvm_arm_vcpu_power_off(vcpu, mp_state);
@@ -906,7 +907,8 @@ static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
 /* Only the guest's CPU_ON may start a vCPU EL2 holds powered off. */
 bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
+	return vcpu_is_protected_pkvm(vcpu) &&
+		READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
@@ -2312,6 +2314,7 @@ static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
 	KVM_VCPU_OPS(VM_VHE, vhe_vcpu_ops),
 	KVM_VCPU_OPS(VM_PKVM, pkvm_vcpu_ops),
 	KVM_VCPU_OPS(VM_PROTECTED_PKVM, pkvm_vcpu_ops),
+	[VM_REALM] = NULL,
 };
 
 static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 0261b2bc681f..ae6ced6d7b9e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -84,7 +84,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
-	return vcpu_is_protected(&hyp_vcpu->vcpu);
+	return vcpu_is_protected_pkvm(&hyp_vcpu->vcpu);
 }
 
 static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 89fb9dd351ad..6c03f48e6be3 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -238,7 +238,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(vcpu_is_protected(vcpu)))
+	if (unlikely(vcpu_is_protected_pkvm(vcpu)))
 		return pvm_exit_handlers;
 
 	return hyp_exit_handlers;
@@ -259,7 +259,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * it.  The check below is based on the one in
 	 * kvm_arch_vcpu_ioctl_run().
 	 */
-	if (unlikely(vcpu_is_protected(vcpu) && vcpu_mode_is_32bit(vcpu))) {
+	if (unlikely(vcpu_is_protected_pkvm(vcpu) && vcpu_mode_is_32bit(vcpu))) {
 		/*
 		 * As we have caught the guest red-handed, decide that it isn't
 		 * fit for purpose anymore by making the vcpu invalid. The VMM
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 993065716913..17bd1ff621ab 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -48,7 +48,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	 * or running a protected VM (we don't offset anything in this case).
 	 */
 	clr = CNTHCTL_EL1PCEN;
-	if (vcpu_is_protected(vcpu) ||
+	if (vcpu_is_protected_pkvm(vcpu) ||
 	    !timer_get_offset(vcpu_ptimer(vcpu)))
 		set |= CNTHCTL_EL1PCTEN;
 	else
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a146f6cde3d0..434502e8c4f9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -3166,6 +3166,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
+	[VM_REALM] = NULL,
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd2..a5145bd75d0c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -192,7 +192,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	 * Mirror EL2's seeding of power_state from mp_state. The hyp vCPU is
 	 * published, so take mp_state_lock against kvm_psci_vcpu_on().
 	 */
-	if (vcpu_is_protected(vcpu)) {
+	if (vcpu_is_protected_pkvm(vcpu)) {
 		spin_lock(&vcpu->arch.mp_state_lock);
 		if (kvm_arm_vcpu_stopped(vcpu))
 			WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_UNINITIALIZED);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index b01f8d44033f..6674e8d6ff4c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -68,7 +68,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * STOPPED before that is the VMM's pause.
 	 */
 	if (!kvm_arm_vcpu_stopped(vcpu) ||
-	    (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
+	    (vcpu_is_protected_pkvm(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			ret = PSCI_RET_ALREADY_ON;
 		else
-- 
2.43.0

