Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430578;
	b=YRfgfWWDYXlEU1U0ZcSn/xSU7TefoKe2bFP+sXvbfKYOeUVd9cS5jDc6KA2ngYTRBI9u
	 VZaRlH721VXyq4FLi4KS8mrrK9OzejC7smrH1czS5OVxpvZmLY8ihTBHlBd/5DHWSFpin
	 xRVW1EVGsIbNprfmkDRvviH/hBSgQ0jKO/K+MuIM2iq3lY/LR7lswFOHcGrXOJFpFxKNv
	 nJtXf/AlLVhrpRZS/pfA9iUc7svF4y8v2p6t98curw8SnaDgxONqeOEBIut/Dvo6tBi5Q
	 eB09QMWIRp18JxdbsGA5kDL1T8dPlOR06TGnZMKMN/fIXkP+VtK/fcSqN0dbKHyY8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430578;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RWpf4+3aFRTKLrtwC63Q3FVYCEhNaAVx46mJIxGLJ+4=;
	b=FAgNvLJRuyrgqhMMQkpVQ8AqfeL7kjRjbctCt0HlWhxabL0EpDOCEXGsQE0Tl80uD/H6
	 auTa6LvkcTUsvoy4UgFQPszkS4CPZgjbZyS0gEbQFOse8rrVdkPLToHTNFZyCXumTbn7Z
	 Wdkd1AmBPR2Yd8vXAnlVX6zJuKXJPhLtKiASOyIpIHA5BTf+Jzt27RRb7dSmnws2LjW8K
	 mX4yZH1lXDxQfJ0nWr1AR5YCrMFSMlV3Gq2PtmkdLFJdNKu47HZssLrsIiT6OknOt+Ido
	 FmGsb5JO1UXERewbpE2TwFVEOiRiVB3phzxB7Vc/XG5a1j1AglTDBaifVencvHbRFtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GJTzoALo;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3096D606A31E;
	Mon, 23 Nov 2026 10:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3096D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=GJTzoALo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE6BB19F0;
	Mon, 23 Nov 2026 02:42:54 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.63.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0D2F3F632;
	Mon, 23 Nov 2026 02:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795430577; bh=0FTVzsFRGJOaxYgVsmTgMD6lxZNDN3sZ+e8XuRIcfG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJTzoALof2M6AlymKZWGn3X4MidqpHBDFPhzDypnFis5/XGj4E2p7THOYPKEnMn1V
	 y3BEVOBHNUkqtpESUM3/VgRlIzmH/66xoyObQFPsq8Ces/kQIU0iEClTqkysu3JomE
	 6esz0BbKSAkeKS1ShYpib2F0MMASdYMvmeAXjtBM=
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
Subject: [PATCH v4 02/11] KVM: arm64: CCA: Introduce Realms
Date: Mon, 23 Nov 2026 10:42:22 +0000
Message-ID: <20261123104233.95710-3-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Introduce the Realm VM flavor and per-VM state tracking. Realm and
protected pKVM states are mutually exclusive, so share their storage
in kvm_arch. Adjust the protected VM helpers for the new flavor.

Realm VMs cannot be created yet; RMI initialization and the creation
UABI follow in later patches.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>

---
Changes since v3:
- Keep protected-VM helper semantics specific to pKVM in nVHE,
  and use VM flavor checks for pKVM power-state handling.

Changes since v1:
- Move RMI initialization to the RMI checks patch and Realm vCPU
  feature restrictions to the follow-on integration series. Keep
  this patch focused on the Realm VM flavor and per-VM state.
- Limit pKVM power state handling to pKVM vCPUs.
---
 arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++
 arch/arm64/include/asm/kvm_host.h    | 17 +++++---
 arch/arm64/include/asm/kvm_rmi.h     | 59 ++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c                 |  4 +-
 arch/arm64/kvm/mmu.c                 |  1 +
 arch/arm64/kvm/pkvm.c                |  2 +-
 arch/arm64/kvm/psci.c                |  3 +-
 7 files changed, 94 insertions(+), 8 deletions(-)
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
index 97332ffcb130..8438251e1d1b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -29,6 +29,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hcall.h>
+#include <asm/kvm_rmi.h>
 #include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -408,6 +409,7 @@ enum kvm_arm_vm_flavor {
 	VM_PKVM,		/* Normal guests on pKVM */
 	MARKER(__VM_PROTECTED),
 	VM_PROTECTED_PKVM,	/* Protected VM */
+	VM_REALM,		/* CCA */
 	VM_FLAVOR_MAX
 };
 
@@ -501,11 +503,14 @@ struct kvm_arch {
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
@@ -1596,6 +1601,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #endif	/* __KVM_NVHE_HYPERVISOR__ */
 
+#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
+
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
index 157bf4b81202..d79e5451923d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -877,7 +877,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu, u32 mp_state)
 /* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	u32 mp_state = vcpu_is_protected(vcpu) ? KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
+	u32 mp_state = vcpu->kvm->arch.vm_flavor == VM_PROTECTED_PKVM ?
+		       KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
 
 	spin_lock(&vcpu->arch.mp_state_lock);
 	__kvm_arm_vcpu_power_off(vcpu, mp_state);
@@ -2312,6 +2313,7 @@ static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
 	KVM_VCPU_OPS(VM_VHE, vhe_vcpu_ops),
 	KVM_VCPU_OPS(VM_PKVM, pkvm_vcpu_ops),
 	KVM_VCPU_OPS(VM_PROTECTED_PKVM, pkvm_vcpu_ops),
+	[VM_REALM] = NULL,
 };
 
 static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2825fccd2a19..09c831a49ed3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -3165,6 +3165,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
 	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
 	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
+	[VM_REALM] = NULL,
 };
 
 static int kvm_vm_init_vm_s2_ops(struct kvm *kvm)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 016997288fd2..8241a05e25d1 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -192,7 +192,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	 * Mirror EL2's seeding of power_state from mp_state. The hyp vCPU is
 	 * published, so take mp_state_lock against kvm_psci_vcpu_on().
 	 */
-	if (vcpu_is_protected(vcpu)) {
+	if (vcpu->kvm->arch.vm_flavor == VM_PROTECTED_PKVM) {
 		spin_lock(&vcpu->arch.mp_state_lock);
 		if (kvm_arm_vcpu_stopped(vcpu))
 			WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_UNINITIALIZED);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index b01f8d44033f..d14414d66dd5 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -68,7 +68,8 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 * STOPPED before that is the VMM's pause.
 	 */
 	if (!kvm_arm_vcpu_stopped(vcpu) ||
-	    (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
+	    (vcpu->kvm->arch.vm_flavor == VM_PROTECTED_PKVM &&
+	     !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			ret = PSCI_RET_ALREADY_ON;
 		else
-- 
2.43.0

