Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7824C0436;
	Wed, 13 May 2026 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678476; cv=none; b=cwCBD98CPxPwdpsfEkpdDms1kFfJL5Fxq6+iTS4gyV9IIrs53nuXDPqNH8JXoiVJVLKYvQA1Dp0fXOIAC4CmAluyYUC9hCBJnGnktJIpcttQpyeWPWL2RLbC1Hdj8vSrbyKTdtCxvG4LXCQdkxXFqMuD9qcSaqaQV7yLZhKdjBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678476; c=relaxed/simple;
	bh=4ODG+RJ6mRMpfVkQFhDekOIOTPJsfJFUdETkqCGtCq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz/fmp1taFMl8FMT1KR+tyHpKicGF49SpNVN/ZTxfQg4RZoaxP0pM+AhwnR1B2MtH4/ACIGs1krvdpoz5hXvB4e399ci2aG+P3WMLQNwcd3oREIQXowFWp+e1Od2RohsqG6/xhVG1F5YI3A/Rx6EijsdirbZRFOoIe97PokETPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qv7o1D1p; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qv7o1D1p"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 986802720;
	Wed, 13 May 2026 06:21:08 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC1A53F905;
	Wed, 13 May 2026 06:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678473; bh=4ODG+RJ6mRMpfVkQFhDekOIOTPJsfJFUdETkqCGtCq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qv7o1D1pQQMMG4cNvwqQuHPlMFnoHUqBtfHQtBwB2hOztFyfXUK037oSAaWemDM2l
	 1s4tPABJDgfeEMPVhYuaMWe62e0gK4WJoRFC5va0XMNqFn4ZPfXRf/geIh24NExmNc
	 fGn8rpEQ87QicKlpyNjiRjytkr7kRN2wSQhI7GBs=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 32/44] KVM: arm64: Handle Realm PSCI requests
Date: Wed, 13 May 2026 14:17:40 +0100
Message-ID: <20260513131757.116630-33-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM needs to be informed of the target REC when a PSCI call is made
with an MPIDR argument.

This requirement will be removed in a future release of the RMM 2.0
specification but is still required for v2.0-bet1.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Chanegs since v13:
 * The ioctl KVM_ARM_VCPU_RMI_PSCI_COMPLETE has gone. The RMI call is
   made automatically just before entering the REC again.
Changes since v12:
 * Chance return code for non-realms to -ENXIO to better represent that
   the ioctl is invalid for non-realms (checkpatch is insistent that
   "ENOSYS means 'invalid syscall nr' and nothing else").
Changes since v11:
 * RMM->RMI renaming.
Changes since v6:
 * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
 * Minor renaming/formatting fixes.
---
 arch/arm64/include/asm/kvm_rmi.h |  3 ++
 arch/arm64/kvm/psci.c            | 15 ++++++++-
 arch/arm64/kvm/rmi.c             | 58 ++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index b65cfec10dee..eacf82a7467d 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -109,6 +109,9 @@ int realm_map_non_secure(struct realm *realm,
 			 unsigned long size,
 			 enum kvm_pgtable_prot prot,
 			 struct kvm_mmu_memory_cache *memcache);
+int realm_psci_complete(struct kvm_vcpu *source,
+			struct kvm_vcpu *target,
+			unsigned long status);
 
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..a2cd55dc7b5b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -103,7 +103,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	reset_state->reset = true;
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
-
 	/*
 	 * Make sure the reset request is observed if the RUNNABLE mp_state is
 	 * observed.
@@ -142,6 +141,20 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	/* Ignore other bits of target affinity */
 	target_affinity &= target_affinity_mask;
 
+	if (vcpu_is_rec(vcpu)) {
+		struct kvm_vcpu *target_vcpu;
+
+		/* RMM supports only zero affinity level */
+		if (lowest_affinity_level != 0)
+			return PSCI_RET_INVALID_PARAMS;
+
+		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
+		if (!target_vcpu)
+			return PSCI_RET_INVALID_PARAMS;
+
+		return PSCI_RET_SUCCESS;
+	}
+
 	/*
 	 * If one or more VCPU matching target affinity are running
 	 * then ON else OFF
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 761b38a4071c..2b03e962ee41 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2023-2025 ARM Ltd.
  */
 
+#include <uapi/linux/psci.h>
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
@@ -127,6 +128,25 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+int realm_psci_complete(struct kvm_vcpu *source, struct kvm_vcpu *target,
+			unsigned long status)
+{
+	int ret;
+
+	/*
+	 * XXX: RMM-v2.0 doesn't require the target REC address for completing
+	 * PSCI requests. Temporary hack until RMM implementation catches up
+	 * to the full spec.
+	 */
+	ret = rmi_psci_complete(virt_to_phys(source->arch.rec.rec_page),
+				virt_to_phys(target->arch.rec.rec_page),
+				status);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int realm_rtt_create(struct realm *realm,
 			    unsigned long addr,
 			    int level,
@@ -1004,6 +1024,41 @@ static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 	rec->run->exit.ripas_base = base;
 }
 
+static void kvm_rec_complete_psci(struct kvm_vcpu *vcpu)
+{
+	struct rec_run *run = vcpu->arch.rec.run;
+	unsigned long status = PSCI_RET_DENIED;
+	unsigned long ret = vcpu_get_reg(vcpu, 0);
+	struct kvm_vcpu *target;
+
+	switch (run->exit.gprs[0]) {
+	/*
+	 * XXX: RMM-v2.0 doesn't cause RMI_EXIT_PSCI for AFFINITY_INFO
+	 * Temporary hack until tf-RMM gets the REC to MPIDR mapping via
+	 * RD Auxiliary granules.
+	 * For now always report SUCCESS
+	 */
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+		status = PSCI_RET_SUCCESS;
+		break;
+	case PSCI_0_2_FN64_CPU_ON: {
+		if (ret != PSCI_RET_SUCCESS &&
+		    ret != PSCI_RET_ALREADY_ON)
+			status = PSCI_RET_DENIED;
+		else
+			status = PSCI_RET_SUCCESS;
+		break;
+	}
+	default:
+		return;
+	}
+
+	target = kvm_mpidr_to_vcpu(vcpu->kvm, run->exit.gprs[1]);
+	/* RMM makes sure that we don't get RMI_EXIT_PSCI for invalid mpidrs */
+	if (target)
+		realm_psci_complete(vcpu, target, status);
+}
+
 /*
  * kvm_rec_pre_enter - Complete operations before entering a REC
  *
@@ -1028,6 +1083,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
 		for (int i = 0; i < REC_RUN_GPRS; i++)
 			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
 		break;
+	case RMI_EXIT_PSCI:
+		kvm_rec_complete_psci(vcpu);
+		break;
 	case RMI_EXIT_RIPAS_CHANGE:
 		kvm_complete_ripas_change(vcpu);
 		break;
-- 
2.43.0

