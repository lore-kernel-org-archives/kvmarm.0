Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E5D481FCA;
	Wed, 15 Jul 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125857; cv=none; b=VQ4gcWtZ4uP/o4E+Hj3JqNqLzVaw/noBPf30h8IniPCqoFoi+UhgDweKFe7wFSYV/h6iCKeTp/KzZLauuf6r/odm7nOMxgTfVqdQDACjcPTnbvsR1U05a1qP+UTbpdeQt+87NShIkWR2GftQXnQzipn1atzyfdUQ1yWTPW+VS3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125857; c=relaxed/simple;
	bh=nJDhPGbO37qxidjuMaydIMpdO+0UJH4FdG/uUVJ/iQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSRhsBYBcGwooADCpqt9vqDYydz1wvDrLl+wzf3ifDQ2F5QEiLFYJmn0dzik7u3iIzoMH+750/g/GrgrAvKpmaDRhAztmP3ODnQsS+deT06Fj4jf/AFPpopoOoheMIfJSs3CWMLMHP9HRl0zxWsGwrrG3T2uGGEVuzpKaiwbGjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kkMgxFhc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kkMgxFhc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43C991691;
	Wed, 15 Jul 2026 07:30:51 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A06E3F7B4;
	Wed, 15 Jul 2026 07:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125855; bh=nJDhPGbO37qxidjuMaydIMpdO+0UJH4FdG/uUVJ/iQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkMgxFhcdIoGgJ9FLKytgljozN3opkd3fAsftszhs3pfxI+DwFaCexKmWPL9xmDGF
	 0mRynr7hhT1rbnV6f/kNsZ5pLsti0bFmXLV1/s6OgZ5Jy1LxblkMhirY5uxT2mBzGi
	 BfWG7UPpdyORiRhcRPdpXUg+3KpffhHAZO3qKJqA=
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
Subject: [PATCH v15 25/37] KVM: arm64: CCA: Handle Realm PSCI requests
Date: Wed, 15 Jul 2026 15:28:27 +0100
Message-ID: <20260715142841.80544-26-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some PSCI commands cause a REC exit and the host has to call
RMI_PSCI_COMPLETE to provide the status value to return to the guest.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v14:
 * Dropped the support for providing the target REC for a PSCI call (as
   per v2.0-bet2 spec).
Changes since v13:
 * The ioctl KVM_ARM_VCPU_RMI_PSCI_COMPLETE has gone. The RMI call is
   made automatically just before entering the REC again.
Changes since v12:
 * Change return code for non-realms to -ENXIO to better represent that
   the ioctl is invalid for non-realms (checkpatch is insistent that
   "ENOSYS means 'invalid syscall nr' and nothing else").
Changes since v11:
 * RMM->RMI renaming.
Changes since v6:
 * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
 * Minor renaming/formatting fixes.
---
 arch/arm64/include/asm/kvm_rmi.h |  2 ++
 arch/arm64/kvm/psci.c            | 14 ++++++++++++
 arch/arm64/kvm/rmi.c             | 38 ++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 718c7128a3c3..a9bb9aabee5d 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -120,6 +120,8 @@ int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
 		  enum kvm_pgtable_prot prot,
 		  struct kvm_mmu_memory_cache *memcache);
 
+int realm_psci_complete(struct kvm_vcpu *source, unsigned long status);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..b0983ee416a2 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -142,6 +142,20 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
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
index 31effae067c8..8fb6403893e8 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2023-2026 ARM Ltd.
  */
 
+#include <uapi/linux/psci.h>
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
@@ -119,6 +120,18 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+int realm_psci_complete(struct kvm_vcpu *source, unsigned long status)
+{
+	int ret;
+
+	ret = rmi_psci_complete(virt_to_phys(source->arch.rec.rec_page),
+				status);
+	if (ret)
+		return -ENXIO;
+
+	return 0;
+}
+
 static int realm_rtt_create(struct realm *realm,
 			    unsigned long addr,
 			    int level,
@@ -1115,6 +1128,28 @@ static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 	rec->run->exit.ripas_base = base;
 }
 
+static void kvm_rec_complete_psci(struct kvm_vcpu *vcpu)
+{
+	struct rec_run *run = vcpu->arch.rec.run;
+	unsigned long status = PSCI_RET_DENIED;
+	unsigned long ret = vcpu_get_reg(vcpu, 0);
+
+	switch (run->exit.gprs[0]) {
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
+	realm_psci_complete(vcpu, status);
+}
+
 /*
  * kvm_rec_pre_enter - Complete operations before entering a REC
  *
@@ -1139,6 +1174,9 @@ int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
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

