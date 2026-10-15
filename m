Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A48348C3FB
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094962; cv=none; b=br4Ct4Vu9gSW4GxZxGHrAWL+TmXK8OhNIMDMDrZ2zY8/sRwYOnJoOPLgNhlvld+ghG6wP0mb5LIx+F46BH0/+Jl+jPVckEy9pY+m8ePqi3aT69Ahe6GtQMOdHno6HphV4mljzLOKjEdWMpQwMt3mTDBdQ4JsQ8iXLiv5JofR1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094962; c=relaxed/simple;
	bh=fUgza7SLLFb5anuHt2xluUBMUoBTWGDhr1TBJyyaCbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GrFsPFBorg42f4gYheNLe4jjC1GCDtiYHVCiua8RK/eyPfJfYK05I7Ya1bKBm2yHl4QF9S07sdqzVM0EERvRnMmMaOr1wJgPFk1AbtTJ+WaC2Fk/MdsSTgQsQZCo/LURleou2wOrO8rvjIAoa7KBZhuxg4Ni6X+Mdb5ScOuCwEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E6kzhojT; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E6kzhojT"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c3f8e149ccfso110090066b.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094956; x=1792699756; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wic91XhpkzCA7vTTouSB42jSaYhrjWojUPYtPDmPpuk=;
        b=E6kzhojTKBqvZszZSE6mQwPnMpDqcAwavHF1Ccrs+k4lnSZRJoKV/pqv/lh3X7FUJo
         vg9hwTaB77fhdxjKa8zxl6Y3YEtcNK1pd5PZLHNIY24aRnQW5f3gH6ssr5B/ZfkIq3ZI
         GSp2JqaZXZk8u/gaRHpFS4fzKY1jOZl7rnYhpt5Vy4/RjUuhZ8VataqRZzslswIwtyq9
         pwberGQFLkyQTlR35V+BLqdBPANwSgPIVJlmz1l20U4lzp3eWUs+G6px2gGZreKg8ic6
         uuR7SithFx5mAMb2cGglydZG9o3wy4j7QBshP1/rI/4URK8GCthmtgMmHg/0BuhC0Zzx
         RJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094956; x=1792699756;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wic91XhpkzCA7vTTouSB42jSaYhrjWojUPYtPDmPpuk=;
        b=sdZVG+Ys0c0alcSNbtwZB+Acw1TKkW5H0zTbxz4og1jt03eVxdhedB5VgifR0IaMFF
         /qPRCfLEFn3FN4y/r4voJuhtoN9qQzGZPFgRRKEEcYGgf0gVPr8cKjusfY3+XnKXIRBK
         tnF//sQAdlbSk1nMF268bzHHNxUqQil69yPXlk8xKGIvd7UxX7xiqmBAjp0WQYkpwFbd
         rcFy5nDf5GkQukpw7szaWkZmlwh5XaAOOkOBuhyYBbTiV5YOa9tCh0BlxNORVfGScXaH
         ybBUCr7msjlT8hQKjcSHJeD6bdy8BQ2Ml+jIA7Jb2pQGK7l/P5QcbIcseERwWAqal6f2
         f4qA==
X-Forwarded-Encrypted: i=1; AKwUvBzTlVkUB2D06E1j4Qf/wji7424PPJoRrsMYRKG/4I1T3blu6jFsMLiTWObsgveVi3cxxASaaUA=@lists.linux.dev
X-Gm-Message-State: AFq9FYLitiQt0bunwNRg9Y1z5apIO3sblyeJiFoclRMN2rCbSEzJOH9x
	qL074Vj/aoEz0s0Mp5kdPZpmpu+ECTC78lO1kKyX35Zemg0fmV3OFrS6/ySCVir4DL16rPuKuaC
	b49nRklZCl/Ah0w==
X-Received: from ejcb24.prod.google.com ([2002:a17:906:36d8:b0:c3f:7f5a:30f9])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:c106:b0:c2d:bf61:24d1 with SMTP id a640c23a62f3a-c31a9a2919bmr1774150966b.1.1792094955429;
 Thu, 15 Oct 2026 13:09:15 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:35 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-5-smostafa@google.com>
Subject: [PATCH v9 04/25] iommu/arm-smmu-v3: Move hitless machinery to common code
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the hitless STE functions to the common file so they can be
reused by the hypervisor.

No functional change.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 246 +++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.h  |   6 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 249 ------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +-
 5 files changed, 254 insertions(+), 255 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
index 22467aaca191..cf9287cdbd19 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
@@ -5,6 +5,7 @@
  */
 
 #include <asm/cpufeature.h>
+#include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
 #include "arm-smmu-v3-common-lib.h"
@@ -238,3 +239,248 @@ u32 arm_smmu_device_idr5_probe(ARM_SMMU_OBJ *smmu)
 
 	return reg;
 }
+
+/*
+ * Based on the value of ent report which bits of the STE the HW will access. It
+ * would be nice if this was complete according to the spec, but minimally it
+ * has to capture the bits this driver uses.
+ */
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
+				    STRTAB_STE_1_EATS | STRTAB_STE_1_MEV |
+				    STRTAB_STE_1_INSTCFG);
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
+				    STRTAB_STE_1_SHCFG | STRTAB_STE_1_MEV |
+				    STRTAB_STE_1_INSTCFG);
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
index 926a84b11a82..55ffa880b093 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
@@ -36,4 +36,10 @@ int arm_smmu_device_idr1_probe(ARM_SMMU_OBJ *smmu, u32 *idr1);
 void arm_smmu_device_idr3_probe(ARM_SMMU_OBJ *smmu);
 u32 arm_smmu_device_idr5_probe(ARM_SMMU_OBJ *smmu);
 
+void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
+void arm_smmu_get_ste_update_safe(const __le64 *cur, const __le64 *target,
+				  __le64 *safe_bits);
+void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
+			  const __le64 *target);
+
 #endif /* __ARM_SMMU_V3_COMMON_LIB_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 5a4e45e15125..d9df9adc14ea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -6,6 +6,7 @@
 #include <linux/io-pgtable.h>
 
 #include "arm-smmu-v3.h"
+#include "arm-smmu-v3-common-lib.h"
 
 struct arm_smmu_test_writer {
 	struct arm_smmu_entry_writer writer;
@@ -18,7 +19,6 @@ struct arm_smmu_test_writer {
 	unsigned int num_syncs;
 };
 
-#define NUM_ENTRY_QWORDS 8
 #define NUM_EXPECTED_SYNCS(x) x
 
 static struct arm_smmu_ste bypass_ste;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8cbf1e7354e2..5d7de893865e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -64,7 +64,6 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-#define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
@@ -1216,254 +1215,6 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_purge);
 
 /* Context descriptor manipulation functions */
 
-/*
- * Based on the value of ent report which bits of the STE the HW will access. It
- * would be nice if this was complete according to the spec, but minimally it
- * has to capture the bits this driver uses.
- */
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
-				    STRTAB_STE_1_EATS | STRTAB_STE_1_MEV |
-				    STRTAB_STE_1_INSTCFG);
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
-				    STRTAB_STE_1_SHCFG | STRTAB_STE_1_MEV |
-				    STRTAB_STE_1_INSTCFG);
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
-
 static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 			     int ssid, bool leaf)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bc4c25421835..d07fca3d1cf5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -226,6 +226,7 @@ struct arm_vsmmu;
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
 #define STRTAB_STE_DWORDS		8
+#define NUM_ENTRY_QWORDS		8
 
 struct arm_smmu_ste {
 	__le64 data[STRTAB_STE_DWORDS];
@@ -1140,11 +1141,6 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
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
-- 
2.56.0.176.g3575e65682-goog

