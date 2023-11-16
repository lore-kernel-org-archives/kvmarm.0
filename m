Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9847D30F91
	for <kvmarm@lists.linux.dev>; Thu, 16 Nov 2023 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8466D1650;
	Thu, 16 Nov 2023 06:30:46 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAF3C3F73F;
	Thu, 16 Nov 2023 06:29:58 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v5 09/12] KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
Date: Thu, 16 Nov 2023 14:29:28 +0000
Message-Id: <20231116142931.1675485-10-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231116142931.1675485-1-ryan.roberts@arm.com>
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_LPA2 increases the maximum levels of translation from 4 to 5 for
the 4KB page case, when IA is >48 bits. While we can still use 4 levels
for stage2 translation in this case (due to stage2 allowing concatenated
page tables for first level lookup), the same kvm_pgtable library is
used for the hyp stage1 page tables and stage1 does not support
concatenation.

Therefore, modify the library to support up to 5 levels. Previous
patches already laid the groundwork for this by refactoring code to work
in terms of KVM_PGTABLE_FIRST_LEVEL and KVM_PGTABLE_LAST_LEVEL. So we
just need to change these macros.

The hardware sometimes encodes the new level differently from the
others: One such place is when reading the level from the FSC field in
the ESR_EL2 register. We never expect to see the lowest level (-1) here
since the stage 2 page tables always use concatenated tables for first
level lookup and therefore only use 4 levels of lookup. So we get away
with just adding a comment to explain why we are not being careful about
decoding level -1.

For stage2 VTCR_EL2.SL2 is introduced to encode the new start level.
However, since we always use concatenated page tables for first level
look up at stage2 (and therefore we will never need the new extra level)
we never touch this new field.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 arch/arm64/include/asm/kvm_pgtable.h |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         |  9 +++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 13fd9dbf2d1d..d4f1e9cdd554 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -411,6 +411,16 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
 
 static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Note: With the introduction of FEAT_LPA2 an extra level of
+	 * translation (level -1) is added. This level (obviously) doesn't
+	 * follow the previous convention of encoding the 4 levels in the 2 LSBs
+	 * of the FSC so this function breaks if the fault is for level -1.
+	 *
+	 * However, stage2 tables always use concatenated tables for first level
+	 * lookup and therefore it is guaranteed that the level will be between
+	 * 0 and 3, and this function continues to work.
+	 */
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
 }
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 89eb648c40f3..f036ee861675 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -11,7 +11,7 @@
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 
-#define KVM_PGTABLE_FIRST_LEVEL		0
+#define KVM_PGTABLE_FIRST_LEVEL		-1
 #define KVM_PGTABLE_LAST_LEVEL		3
 
 /*
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8f42c6f80c9c..cccea87556e0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -645,6 +645,15 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	lvls = stage2_pgtable_levels(phys_shift);
 	if (lvls < 2)
 		lvls = 2;
+
+	/*
+	 * When LPA2 is enabled, the HW supports an extra level of translation
+	 * (for 5 in total) when using 4K pages. It also introduces VTCR_EL2.SL2
+	 * to as an addition to SL0 to enable encoding this extra start level.
+	 * However, since we always use concatenated pages for the first level
+	 * lookup, we will never need this extra level and therefore do not need
+	 * to touch SL2.
+	 */
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
 #ifdef CONFIG_ARM64_HW_AFDBM
-- 
2.25.1

