Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E037A848D
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 14:00:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E279412FC;
	Tue,  6 Dec 2022 06:00:14 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87D623F73D;
	Tue,  6 Dec 2022 06:00:06 -0800 (PST)
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
Subject: [PATCH v1 03/12] KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
Date: Tue,  6 Dec 2022 13:59:21 +0000
Message-ID: <20221206135930.3277585-4-ryan.roberts@arm.com>
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
Message-ID: <20221206135921.uWLDbSMK7doRStFEDCUCyIrFPRKAkdMHmYw_RKQF_LA@z>

As per Arm ARM (0487I.a), (V)TCR_EL2.DS fields control whether 52 bit
input and output addresses are supported on 4K and 16K page size
configurations when FEAT_LPA2 is known to have been implemented.
Additionally, VTCR_EL2.SL2 field is added to enable encoding of a 5th
starting level of translation, which is required with 4KB IPA size of
49-52 bits if concatenated first level page tables are not used.

This adds these field definitions which will be used by KVM when
FEAT_LPA2 is enabled.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a82f2493a72b..f9619a10d5d9 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -92,6 +92,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
+#define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
@@ -106,6 +107,9 @@
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
 
 /* VTCR_EL2 Registers bits */
+#define VTCR_EL2_SL2_SHIFT	33
+#define VTCR_EL2_SL2_MASK	(1UL << VTCR_EL2_SL2_SHIFT)
+#define VTCR_EL2_DS		TCR_EL2_DS
 #define VTCR_EL2_RES1		(1U << 31)
 #define VTCR_EL2_HD		(1 << 22)
 #define VTCR_EL2_HA		(1 << 21)
-- 
2.25.1

