Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661C23CB91F
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103178; cv=none; b=alxlGaNe9xShnH+Qn+yCGQCeLxS5w+m0LpfWtMJBzDEg4Q/0M9oXYVOU2Z8lgQL9561efvd+hrxl4auGg+gC/Xjha9RTJsIzVbEXcVANbtnrfrWDkQMzDMLda9AZNWLZm9TdIP00Ydw4ZZeXwXOjgKepdLge+eWDN3NO8PR0ML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103178; c=relaxed/simple;
	bh=seU745NFUCu9ykrsy0Mp34nXJ0y0BN2RmeJoWPkFp7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lz1AG7PRHQBOnTEEnTOuGFm5FGLNPTMVTCPuGE9hcjQLAfUKkfFT5sOvMZD3HnS2xluwhL8YZSfW4cBEfR+4LZyPLrt+0mLtKR6fphoPaLFDRQoPETr7UEkISFggBLsEz4R9VTJCs4XBecP/ba81lmx9QiCvs/18Z7TMxo2M/e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eCIhHM65; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eCIhHM65"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784103173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4y4UR4PmK16GfMJFUFQ14Kb30LFrA+TnM7Dyu73NEs=;
	b=eCIhHM65MbQw+PZahy14nRS+hR64MQRXwB4ghUY27ZkOfk22bJZr79jUu40oFbPbs+Zyaa
	QE5DgXtE0MY4OOR3QLR7p2g1lmN2S+8258uwlwEd0MrtxMrQlqSKPUGGWDy1rVCB8hRSAc
	wZoxbNNETjYjprjLj3+g3+ocWEfIYbU=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v6 4/8] KVM: arm64: Move PSCI helper functions to a shared header
Date: Wed, 15 Jul 2026 09:12:34 +0100
Message-Id: <20260715081238.1891918-5-fuad.tabba@linux.dev>
In-Reply-To: <20260715081238.1891918-1-fuad.tabba@linux.dev>
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move kvm_psci_valid_affinity() and kvm_psci_narrow_to_32bit() from
psci.c to include/kvm/arm_psci.h, and move psci_affinity_mask() there
too, renaming it kvm_psci_affinity_mask() now that it is no longer
file-local. A follow-up series handles some protected-guest PSCI calls
at EL2 using these helpers.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/psci.c  | 30 +-----------------------------
 include/kvm/arm_psci.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0ea..e3db84400d1f8 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -21,16 +21,6 @@
  * as described in ARM document number ARM DEN 0022A.
  */
 
-#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
-
-static unsigned long psci_affinity_mask(unsigned long affinity_level)
-{
-	if (affinity_level <= 3)
-		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
-
-	return 0;
-}
-
 static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -51,12 +41,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
-{
-	return !(affinity & ~MPIDR_HWID_BITMASK);
-}
-
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -135,7 +119,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
+	target_affinity_mask = kvm_psci_affinity_mask(lowest_affinity_level);
 	if (!target_affinity_mask)
 		return PSCI_RET_INVALID_PARAMS;
 
@@ -220,18 +204,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
-static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	/*
-	 * Zero the input registers' upper 32 bits. They will be fully
-	 * zeroed on exit, so we're fine changing them in place.
-	 */
-	for (i = 1; i < 4; i++)
-		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
-}
-
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
 	/*
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index cbaec804eb839..f86a006d67136 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -38,6 +38,33 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 	return KVM_ARM_PSCI_0_1;
 }
 
+/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
+static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	/*
+	 * Zero the input registers' upper 32 bits. They will be fully
+	 * zeroed on exit, so we're fine changing them in place.
+	 */
+	for (i = 1; i < 4; i++)
+		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
+}
+
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
+static inline unsigned long kvm_psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return MPIDR_HWID_BITMASK &
+			~((0x1UL << (affinity_level * MPIDR_LEVEL_BITS)) - 1);
+
+	return 0;
+}
 
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-- 
2.39.5

