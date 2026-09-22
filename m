Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E170654A7CC
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082795; cv=none; b=N4aQDEIWHuAugaFa/TrIOYuJ84ZLMjX9HVqe74RGD7dN9SxJy+ONtUx6RPl5bBLsff2ko6OG7xPm8Glx219ubM9VYmoD0H2hvL7fgPq45tS5flgBk3ct+Rhte5K/kHvyHwIdFbrlQILtZEodD1TUcYMlDdfFT8EX7Hqn+ntdrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082795; c=relaxed/simple;
	bh=PTK4YXh+2Xkcihw7j2fVk0vYmA1hUxUq+OB8m6leNLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IGBv5UU1q2rHzPab1t/hDoq/Kwsf5S1wE9NdGbcBa9SGCR5iKn6haQqCtn2OxIeMtT0cujkUtXFRGM88GPTg2fuGRgPvoG0qAOwgxbeXps1gs79GJVKTci0nIiN/E1mUhvuH9C3SnQgqWMa9Klbh7QgTUcfgsThK/c97Srs/OQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0iy54gm; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0iy54gm"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e65f2f1baso46857335e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082789; x=1790687589; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H8Yd2L6uyVN4DO7DhBa4AXAuURlSm6f75FoRRfv89Eg=;
        b=h0iy54gmbQ+lMl72ABKVwqO3bGzZXSkVmowFnA9nC00JE/r2Bf/XgPH+oCuPkAcVuP
         FbV/aVIwh7/zOILaxtujOBJ+LD34MT0XeZB9gQ/8l3uoGNULj+std+BmHP1azkzuVuhG
         nQ87cs3b+J0R19y7eYaVU7zbr1r70Tr5AzHSXfRI4pYle58GyiHW4v5bTtvsIL2unJqn
         DQbhqQHCth1DPko6kueo13LZsgu8F7U2tHL8u+PWI1Rs7jg/CY20H48y3eIwqfbCMCII
         tt1TLDSo2pE1ZYhK2GIbl3hDIPcZicpj41oxOVVmzxuJE3QxYoTpnzc3hXVvKfS/fVhn
         VCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082789; x=1790687589;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H8Yd2L6uyVN4DO7DhBa4AXAuURlSm6f75FoRRfv89Eg=;
        b=Q19+dxwqkPsOdOQiUnTBluXkp6FIsAWSVo4bv+P5XPjfT0I0MqCgcB7PH3jWrOdTf6
         Z7qkniR370kRjBz2wZitLdiWAhb5pKnBOuzhzCqU3DKlXWkNcA3Pa7oJXGIqplhixCBq
         yYu0d8gRcG27JD31EyvqdWND1ituHcsuJMmaltAW11nmWFYHlmgF6oNel9TdRn/MgCh4
         6gRJaN1yTurv+jmCBDz5uRoPQtIdaf5g0DH7cX+v2vIy9+PaBgNxIyvb+EpqPRMM4oJn
         EKN45Ue3glJFAyesE0cNLxS1nNRyRhuamqjTh0F7UsIgyx9i8celXZeeqKKV58gKBtPc
         ndpA==
X-Forwarded-Encrypted: i=1; AKwUvBwDeGNFZdBDWmTXCuQ5ibhThmE+jPScvlKxbpn0NbctW878z/3ugTRM67TTWUX2yFVchNV8yxQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kzXCUQsn4TYFM3lDqP0MSkScCdyo5tpD1OhKpOHIoxG5HTL0U0
	uDrB7t1JvfV3fOJuHIVp+b6HH+PZ6xcM75dU8vj/WBb1TTnuYhZ0uxoeYPBCJ/xweeSDXTRPF6S
	0ya/ziJhSX3gn5w==
X-Received: from wmbdx16.prod.google.com ([2002:a05:600c:63d0:b0:499:b6c1:bd20])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f8c:b0:49f:c18a:61c8 with SMTP id 5b1f17b1804b1-49fc573f858mr202308695e9.29.1790082788690;
 Tue, 22 Sep 2026 06:13:08 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:38 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-6-smostafa@google.com>
Subject: [PATCH v8 05/25] iommu/arm-smmu-v3: Move hitless machinery to common code
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the hitless STE functions to the common file so it can be
reused by the hypervisor.

No functional change.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 240 +++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.h  |   6 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 242 ------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
 5 files changed, 249 insertions(+), 247 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
index a341974e7aaf..39b3cde9f5d2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
@@ -4,6 +4,8 @@
  * Arm SMMUv3 driver functions shared with hypervisor.
  */
 
+#include <kunit/visibility.h>
+
 #include "arm-smmu-v3.h"
 #include "arm-smmu-v3-common-lib.h"
 
@@ -174,3 +176,241 @@ u32 arm_smmu_idr5_probe(ARM_SMMU_OBJ *smmu)
 
 	return reg;
 }
+
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
+{
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
+
+	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		return;
+
+	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+
+	/* S1 translates */
+	if (cfg & BIT(0)) {
+		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+					    STRTAB_STE_0_S1CTXPTR_MASK |
+					    STRTAB_STE_0_S1CDMAX);
+		used_bits[1] |=
+			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
+				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
+				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
+				    STRTAB_STE_1_EATS | STRTAB_STE_1_MEV);
+		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+
+		/*
+		 * See 13.5 Summary of attribute/permission configuration fields
+		 * for the SHCFG behavior.
+		 */
+		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		    STRTAB_STE_1_S1DSS_BYPASS)
+			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+	}
+
+	/* S2 translates */
+	if (cfg & BIT(1)) {
+		used_bits[1] |=
+			cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
+				    STRTAB_STE_1_SHCFG | STRTAB_STE_1_MEV);
+		used_bits[2] |=
+			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
+				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
+				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2S |
+				    STRTAB_STE_2_S2R);
+		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+	}
+
+	if (cfg == STRTAB_STE_0_CFG_BYPASS)
+		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_ste_used);
+
+void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
+				  __le64 *safe_bits)
+{
+	const u64 eats_s1chk =
+		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_S1CHK);
+	const u64 eats_trans =
+		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_TRANS);
+
+	/*
+	 * When an STE changes EATS_TRANS, the sequencing code in the attach
+	 * logic already will have the PCI cap for ATS disabled. Thus at this
+	 * moment we can expect that the device will not generate ATS queries
+	 * and so we don't care about the sequencing of EATS. The purpose of
+	 * EATS_TRANS is to protect the system from hostile untrusted devices
+	 * that issue ATS when the PCI config space is disabled. However, if
+	 * EATS_TRANS is being changed, then we must have already trusted the
+	 * device as the EATS_TRANS security block is being disabled.
+	 *
+	 *  Note: now the EATS_TRANS update is moved to the first entry_set().
+	 *  Changing S2S and EATS might transiently result in S2S=1 and EATS=1
+	 *  which is a bad STE (see "5.2 Stream Table Entry"). In such a case,
+	 *  we can't do a hitless update. Also, it should not be added to the
+	 *  safe bits with STRTAB_STE_1_EATS_S1CHK, because EATS=0b11 would be
+	 *  effectively an errant 0b00 configuration.
+	 */
+	if (!((cur[1] | target[1]) & cpu_to_le64(eats_s1chk)) &&
+	    !((cur[2] | target[2]) & cpu_to_le64(STRTAB_STE_2_S2S)))
+		safe_bits[1] |= cpu_to_le64(eats_trans);
+
+	/*
+	 * MEV does not meaningfully impact the operation of the HW, it only
+	 * changes how many fault events are generated, thus we can relax it
+	 * when computing the ordering. The spec notes the device can act like
+	 * MEV=1 anyhow:
+	 *
+	 *  Note: Software must expect, and be able to deal with, coalesced
+	 *  fault records even when MEV == 0.
+	 */
+	safe_bits[1] |= cpu_to_le64(STRTAB_STE_1_MEV);
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_ste_update_safe);
+
+/*
+ * Figure out if we can do a hitless update of entry to become target. Returns a
+ * bit mask where 1 indicates that qword needs to be set disruptively.
+ * unused_update is an intermediate value of entry that has unused bits set to
+ * their new values.
+ */
+static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
+				    const __le64 *entry, const __le64 *target,
+				    __le64 *unused_update)
+{
+	__le64 target_used[NUM_ENTRY_QWORDS] = {};
+	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
+	__le64 safe[NUM_ENTRY_QWORDS] = {};
+	u8 used_qword_diff = 0;
+	unsigned int i;
+
+	writer->ops->get_used(entry, cur_used);
+	writer->ops->get_used(target, target_used);
+	if (writer->ops->get_update_safe)
+		writer->ops->get_update_safe(entry, target, safe);
+
+	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
+		/*
+		 * Safe is only used for bits that are used by both entries,
+		 * otherwise it is sequenced according to the unused entry.
+		 */
+		safe[i] &= target_used[i] & cur_used[i];
+
+		/*
+		 * Check that masks are up to date, the make functions are not
+		 * allowed to set a bit to 1 if the used function doesn't say it
+		 * is used.
+		 */
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
+
+		/* Bits can change because they are not currently being used */
+		cur_used[i] &= ~safe[i];
+		unused_update[i] = (entry[i] & cur_used[i]) |
+				   (target[i] & ~cur_used[i]);
+		/*
+		 * Each bit indicates that a used bit in a qword needs to be
+		 * changed after unused_update is applied.
+		 */
+		if ((unused_update[i] & target_used[i]) != target[i])
+			used_qword_diff |= 1 << i;
+	}
+	return used_qword_diff;
+}
+
+static void entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
+		      const __le64 *target, unsigned int start,
+		      unsigned int len)
+{
+	bool changed = false;
+	unsigned int i;
+
+	for (i = start; len != 0; len--, i++) {
+		if (entry[i] != target[i]) {
+			WRITE_ONCE(entry[i], target[i]);
+			changed = true;
+		}
+	}
+
+	if (changed)
+		writer->ops->sync(writer);
+}
+
+/*
+ * Update the STE/CD to the target configuration. The transition from the
+ * current entry to the target entry takes place over multiple steps that
+ * attempts to make the transition hitless if possible. This function takes care
+ * not to create a situation where the HW can perceive a corrupted entry. HW is
+ * only required to have a 64 bit atomicity with stores from the CPU, while
+ * entries are many 64 bit values big.
+ *
+ * The difference between the current value and the target value is analyzed to
+ * determine which of three updates are required - disruptive, hitless or no
+ * change.
+ *
+ * In the most general disruptive case we can make any update in three steps:
+ *  - Disrupting the entry (V=0)
+ *  - Fill now unused qwords, execpt qword 0 which contains V
+ *  - Make qword 0 have the final value and valid (V=1) with a single 64
+ *    bit store
+ *
+ * However this disrupts the HW while it is happening. There are several
+ * interesting cases where a STE/CD can be updated without disturbing the HW
+ * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
+ * because the used bits don't intersect. We can detect this by calculating how
+ * many 64 bit values need update after adjusting the unused bits and skip the
+ * V=0 process. This relies on the IGNORED behavior described in the
+ * specification.
+ */
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
+			  const __le64 *target)
+{
+	__le64 unused_update[NUM_ENTRY_QWORDS];
+	u8 used_qword_diff;
+
+	/*
+	 * Many of the entry structures have pointers to other structures that
+	 * need to have their updates be visible before any writes of the entry
+	 * happen.
+	 */
+	dma_wmb();
+
+	used_qword_diff =
+		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
+	if (hweight8(used_qword_diff) == 1) {
+		/*
+		 * Only one qword needs its used bits to be changed. This is a
+		 * hitless update, update all bits the current STE/CD is
+		 * ignoring to their new values, then update a single "critical
+		 * qword" to change the STE/CD and finally 0 out any bits that
+		 * are now unused in the target configuration.
+		 */
+		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
+
+		/*
+		 * Skip writing unused bits in the critical qword since we'll be
+		 * writing it in the next step anyways. This can save a sync
+		 * when the only change is in that qword.
+		 */
+		unused_update[critical_qword_index] =
+			entry[critical_qword_index];
+		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
+		entry_set(writer, entry, target, critical_qword_index, 1);
+		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
+	} else if (used_qword_diff) {
+		/*
+		 * At least two qwords need their inuse bits to be changed. This
+		 * requires a breaking update, zero the V bit, write all qwords
+		 * but 0, then set qword 0
+		 */
+		unused_update[0] = 0;
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
+		entry_set(writer, entry, target, 0, 1);
+	} else {
+		/*
+		 * No inuse bit changed, though safe bits may have changed.
+		 */
+		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
+	}
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_write_entry);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
index e736b6a8c78c..9a7064c8e879 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
@@ -28,4 +28,10 @@ u32 arm_smmu_idr0_probe(ARM_SMMU_OBJ *smmu);
 void arm_smmu_idr3_probe(ARM_SMMU_OBJ *smmu);
 u32 arm_smmu_idr5_probe(ARM_SMMU_OBJ *smmu);
 
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
+void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
+				  __le64 *safe_bits);
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
+			  const __le64 *target);
+
 #endif /* __ARM_SMMU_V3_COMMON_LIB_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c82..ea9c85d2c7f0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -6,6 +6,7 @@
 #include <linux/io-pgtable.h>
 
 #include "arm-smmu-v3.h"
+#include "arm-smmu-v3-common-lib.h"
 
 struct arm_smmu_test_writer {
 	struct arm_smmu_entry_writer writer;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c4c652431ee0..2043c6dc1bdf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -59,10 +59,8 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-#define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
-
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
 		ARM_SMMU_EVTQ_IRQ_CFG0,
@@ -1205,246 +1203,6 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_purge);
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-VISIBLE_IF_KUNIT
-void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
-{
-	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
-
-	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
-	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
-		return;
-
-	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
-
-	/* S1 translates */
-	if (cfg & BIT(0)) {
-		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
-					    STRTAB_STE_0_S1CTXPTR_MASK |
-					    STRTAB_STE_0_S1CDMAX);
-		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
-				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
-				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
-				    STRTAB_STE_1_EATS | STRTAB_STE_1_MEV);
-		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
-
-		/*
-		 * See 13.5 Summary of attribute/permission configuration fields
-		 * for the SHCFG behavior.
-		 */
-		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
-		    STRTAB_STE_1_S1DSS_BYPASS)
-			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
-	}
-
-	/* S2 translates */
-	if (cfg & BIT(1)) {
-		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
-				    STRTAB_STE_1_SHCFG | STRTAB_STE_1_MEV);
-		used_bits[2] |=
-			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
-				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
-				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2S |
-				    STRTAB_STE_2_S2R);
-		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
-	}
-
-	if (cfg == STRTAB_STE_0_CFG_BYPASS)
-		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
-}
-EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_ste_used);
-
-VISIBLE_IF_KUNIT
-void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
-				  __le64 *safe_bits)
-{
-	const u64 eats_s1chk =
-		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_S1CHK);
-	const u64 eats_trans =
-		FIELD_PREP(STRTAB_STE_1_EATS, STRTAB_STE_1_EATS_TRANS);
-
-	/*
-	 * When an STE changes EATS_TRANS, the sequencing code in the attach
-	 * logic already will have the PCI cap for ATS disabled. Thus at this
-	 * moment we can expect that the device will not generate ATS queries
-	 * and so we don't care about the sequencing of EATS. The purpose of
-	 * EATS_TRANS is to protect the system from hostile untrusted devices
-	 * that issue ATS when the PCI config space is disabled. However, if
-	 * EATS_TRANS is being changed, then we must have already trusted the
-	 * device as the EATS_TRANS security block is being disabled.
-	 *
-	 *  Note: now the EATS_TRANS update is moved to the first entry_set().
-	 *  Changing S2S and EATS might transiently result in S2S=1 and EATS=1
-	 *  which is a bad STE (see "5.2 Stream Table Entry"). In such a case,
-	 *  we can't do a hitless update. Also, it should not be added to the
-	 *  safe bits with STRTAB_STE_1_EATS_S1CHK, because EATS=0b11 would be
-	 *  effectively an errant 0b00 configuration.
-	 */
-	if (!((cur[1] | target[1]) & cpu_to_le64(eats_s1chk)) &&
-	    !((cur[2] | target[2]) & cpu_to_le64(STRTAB_STE_2_S2S)))
-		safe_bits[1] |= cpu_to_le64(eats_trans);
-
-	/*
-	 * MEV does not meaningfully impact the operation of the HW, it only
-	 * changes how many fault events are generated, thus we can relax it
-	 * when computing the ordering. The spec notes the device can act like
-	 * MEV=1 anyhow:
-	 *
-	 *  Note: Software must expect, and be able to deal with, coalesced
-	 *  fault records even when MEV == 0.
-	 */
-	safe_bits[1] |= cpu_to_le64(STRTAB_STE_1_MEV);
-}
-EXPORT_SYMBOL_IF_KUNIT(arm_smmu_get_ste_update_safe);
-
-/*
- * Figure out if we can do a hitless update of entry to become target. Returns a
- * bit mask where 1 indicates that qword needs to be set disruptively.
- * unused_update is an intermediate value of entry that has unused bits set to
- * their new values.
- */
-static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
-				    const __le64 *entry, const __le64 *target,
-				    __le64 *unused_update)
-{
-	__le64 target_used[NUM_ENTRY_QWORDS] = {};
-	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
-	__le64 safe[NUM_ENTRY_QWORDS] = {};
-	u8 used_qword_diff = 0;
-	unsigned int i;
-
-	writer->ops->get_used(entry, cur_used);
-	writer->ops->get_used(target, target_used);
-	if (writer->ops->get_update_safe)
-		writer->ops->get_update_safe(entry, target, safe);
-
-	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
-		/*
-		 * Safe is only used for bits that are used by both entries,
-		 * otherwise it is sequenced according to the unused entry.
-		 */
-		safe[i] &= target_used[i] & cur_used[i];
-
-		/*
-		 * Check that masks are up to date, the make functions are not
-		 * allowed to set a bit to 1 if the used function doesn't say it
-		 * is used.
-		 */
-		WARN_ON_ONCE(target[i] & ~target_used[i]);
-
-		/* Bits can change because they are not currently being used */
-		cur_used[i] &= ~safe[i];
-		unused_update[i] = (entry[i] & cur_used[i]) |
-				   (target[i] & ~cur_used[i]);
-		/*
-		 * Each bit indicates that a used bit in a qword needs to be
-		 * changed after unused_update is applied.
-		 */
-		if ((unused_update[i] & target_used[i]) != target[i])
-			used_qword_diff |= 1 << i;
-	}
-	return used_qword_diff;
-}
-
-static void entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
-		      const __le64 *target, unsigned int start,
-		      unsigned int len)
-{
-	bool changed = false;
-	unsigned int i;
-
-	for (i = start; len != 0; len--, i++) {
-		if (entry[i] != target[i]) {
-			WRITE_ONCE(entry[i], target[i]);
-			changed = true;
-		}
-	}
-
-	if (changed)
-		writer->ops->sync(writer);
-}
-
-/*
- * Update the STE/CD to the target configuration. The transition from the
- * current entry to the target entry takes place over multiple steps that
- * attempts to make the transition hitless if possible. This function takes care
- * not to create a situation where the HW can perceive a corrupted entry. HW is
- * only required to have a 64 bit atomicity with stores from the CPU, while
- * entries are many 64 bit values big.
- *
- * The difference between the current value and the target value is analyzed to
- * determine which of three updates are required - disruptive, hitless or no
- * change.
- *
- * In the most general disruptive case we can make any update in three steps:
- *  - Disrupting the entry (V=0)
- *  - Fill now unused qwords, execpt qword 0 which contains V
- *  - Make qword 0 have the final value and valid (V=1) with a single 64
- *    bit store
- *
- * However this disrupts the HW while it is happening. There are several
- * interesting cases where a STE/CD can be updated without disturbing the HW
- * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
- * because the used bits don't intersect. We can detect this by calculating how
- * many 64 bit values need update after adjusting the unused bits and skip the
- * V=0 process. This relies on the IGNORED behavior described in the
- * specification.
- */
-VISIBLE_IF_KUNIT
-void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
-			  const __le64 *target)
-{
-	__le64 unused_update[NUM_ENTRY_QWORDS];
-	u8 used_qword_diff;
-
-	/*
-	 * Many of the entry structures have pointers to other structures that
-	 * need to have their updates be visible before any writes of the entry
-	 * happen.
-	 */
-	dma_wmb();
-
-	used_qword_diff =
-		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
-	if (hweight8(used_qword_diff) == 1) {
-		/*
-		 * Only one qword needs its used bits to be changed. This is a
-		 * hitless update, update all bits the current STE/CD is
-		 * ignoring to their new values, then update a single "critical
-		 * qword" to change the STE/CD and finally 0 out any bits that
-		 * are now unused in the target configuration.
-		 */
-		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
-
-		/*
-		 * Skip writing unused bits in the critical qword since we'll be
-		 * writing it in the next step anyways. This can save a sync
-		 * when the only change is in that qword.
-		 */
-		unused_update[critical_qword_index] =
-			entry[critical_qword_index];
-		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
-		entry_set(writer, entry, target, critical_qword_index, 1);
-		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
-	} else if (used_qword_diff) {
-		/*
-		 * At least two qwords need their inuse bits to be changed. This
-		 * requires a breaking update, zero the V bit, write all qwords
-		 * but 0, then set qword 0
-		 */
-		unused_update[0] = 0;
-		entry_set(writer, entry, unused_update, 0, 1);
-		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
-		entry_set(writer, entry, target, 0, 1);
-	} else {
-		/*
-		 * No inuse bit changed, though safe bits may have changed.
-		 */
-		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
-	}
-}
-EXPORT_SYMBOL_IF_KUNIT(arm_smmu_write_entry);
 
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d5963a01452f..28efa733e796 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1088,11 +1088,6 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 bool ats_enabled);
 
 #if IS_ENABLED(CONFIG_KUNIT)
-void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
-void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
-				  __le64 *safe_bits);
-void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
-			  const __le64 *target);
 void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
@@ -1321,6 +1316,8 @@ static inline u64 arm_smmu_tlb_inv_range_enc(u8 num, u8 scale)
 		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
 }
 
+#define NUM_ENTRY_QWORDS 8
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 void arm_smmu_sva_notifier_synchronize(void);
-- 
2.55.0.1082.g2b9226bbc0-goog

