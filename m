Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACCD841A4E7;
	Mon,  3 Aug 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764809; cv=none; b=uThud77Fu8D2NPggH0WzX4a/jlSR9iob5+pq0zAhae4z8V8uLZ5AMKAPmj7gcA9C5RkICcxl5n9mDqUuGB5y647JSjvy741r/erzXnfY+OKzJisgkW9WRBEyvksDkNO+H4loSFe86cR+dxPaJBZEqTkCHyzBwbmw03gFfrLQwMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764809; c=relaxed/simple;
	bh=rE5FH9m6cgbxv4oXJ1XSPENbjK143njy6sCuV+SL+fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2nqoy++/pqkO//rJf4WtcA0B88ffMRd263qsQTSgMKKMfXP314xbF1nJOvbQKNWosIPXDey0iSKWXtcD3X918w+gh1H6BLrVsrKnP2jVDbp/qqFU245u5Jt6J8EZA2CDfhFg3KEMIq/iBImKWl4XnI+iPAh8ccpfJ5bI/OBRTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ckVzX19e; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ckVzX19e"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0C2F1476;
	Mon,  3 Aug 2026 06:46:42 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBB873F66F;
	Mon,  3 Aug 2026 06:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764807; bh=rE5FH9m6cgbxv4oXJ1XSPENbjK143njy6sCuV+SL+fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckVzX19es7E2Ac9HZIzWyIGBb0UzHKb0HeLvoqyl/wXBsBzXU7/zUXzLh4mmsAvX4
	 Wm246oY5mYIzCBXgMKG4ozQJ5tKXpAHRkweVj+5xPjNI/WM94dTBtrdz7+yvWPt5v8
	 PyzLiCgxjHUyFZW2jNGDGl+CiSG8LmHDkA3EOOhQ=
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
Subject: [PATCH v16 32/45] KVM: arm64: CCA: Handle Realm PSCI requests
Date: Mon,  3 Aug 2026 14:43:48 +0100
Message-ID: <20260803134403.80630-33-steven.price@arm.com>
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

Some PSCI commands cause a REC exit and the host has to call
RMI_PSCI_COMPLETE to provide the status value to return to the guest.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Adapt to new exit handling.
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
 arch/arm64/kvm/rmi.c             | 38 ++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 967c0a6e8e9c..0fb685004d5c 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -123,6 +123,8 @@ int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
 		  enum kvm_pgtable_prot prot,
 		  struct kvm_mmu_memory_cache *memcache);
 
+int realm_psci_complete(struct kvm_vcpu *source, unsigned long status);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 3ef185bc8210..3f31ad25680f 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2023-2026 ARM Ltd.
  */
 
+#include <uapi/linux/psci.h>
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
@@ -120,6 +121,17 @@ static void free_rtt(phys_addr_t phys)
 	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
 }
 
+int realm_psci_complete(struct kvm_vcpu *source, unsigned long status)
+{
+	long ret;
+
+	ret = rmi_psci_complete(source->arch.rec.rec_phys, status);
+	if (ret)
+		return -ENXIO;
+
+	return 0;
+}
+
 static long realm_rtt_create(struct realm *realm,
 			     unsigned long addr,
 			     int level,
@@ -1145,6 +1157,30 @@ static int kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int kvm_rec_complete_psci(struct kvm_vcpu *vcpu)
+{
+	struct rec_run *run = vcpu->arch.rec.run;
+	unsigned long status = PSCI_RET_DENIED;
+	unsigned long ret = vcpu_get_reg(vcpu, 0);
+	int r;
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
+		return 1;
+	}
+
+	r = realm_psci_complete(vcpu, status);
+	return r ?: 1;
+}
+
 int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -1163,6 +1199,8 @@ int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
 					vcpu_get_reg(vcpu, rt);
 		}
 		break;
+	case RMI_EXIT_PSCI:
+		return kvm_rec_complete_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return kvm_complete_ripas_change(vcpu);
 	default:
-- 
2.43.0

