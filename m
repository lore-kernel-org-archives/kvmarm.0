Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645E7848C
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 14:00:23 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA629139F;
	Tue,  6 Dec 2022 06:00:29 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91E293F73D;
	Tue,  6 Dec 2022 06:00:21 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 11/12] KVM: arm64: Support upto 5 levels of translation in kvm_pgtable
Date: Tue,  6 Dec 2022 13:59:29 +0000
Message-ID: <20221206135930.3277585-12-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221206135929.4vxwdzl9FROg7CURvJAIVmX3QkY1wXAoYwXGs4kzQP4@z>

FEAT_LPA2 increases the maximum levels of translation from 4 to 5 for
the 4KB page case, when IA is >48 bits. While we can still use 4 levels
for stage2 translation in this case (due to stage2 allowing concatenated
page tables for first level lookup), the same kvm_pgtable library is
used for the hyp stage1 page tables and stage1 does not support
concatenation.

Therefore, modify the library to support upto 5 levels. Previous patches
already laid the groundwork for this by refactoring code to work in
terms of KVM_PGTABLE_FIRST_LEVEL and KVM_PGTABLE_LAST_LEVEL. So we just
need to change these macros.

The hardware sometimes encodes the new level differently from the
others: One such place is when reading the level from the FSC field in
the ESR_EL2 register. We never expect to see the lowest level (-1) here
since the stage 2 page tables always use concatenated tables for first
level lookup and therefore only use 4 levels of lookup. So we get away
with just adding a comment to explain why we are not being careful about
decoding level -1.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 arch/arm64/include/asm/kvm_pgtable.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 270f49e7f29a..6f68febfb214 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -343,6 +343,16 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
 
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
index 3e0b64052c51..3655279e6a7d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -11,7 +11,7 @@
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 
-#define KVM_PGTABLE_FIRST_LEVEL		0
+#define KVM_PGTABLE_FIRST_LEVEL		-1
 #define KVM_PGTABLE_LAST_LEVEL		3
 
 /*
-- 
2.25.1

