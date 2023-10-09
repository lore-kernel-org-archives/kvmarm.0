Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6084536B0E
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAB621476;
	Mon,  9 Oct 2023 11:51:06 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A77483F5A1;
	Mon,  9 Oct 2023 11:50:24 -0700 (PDT)
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
Subject: [PATCH v4 05/12] KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
Date: Mon,  9 Oct 2023 19:50:01 +0100
Message-Id: <20231009185008.3803879-6-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009185008.3803879-1-ryan.roberts@arm.com>
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As per Arm ARM (0487I.a), (V)TCR_EL2.DS fields control whether 52 bit
input and output addresses are supported on 4K and 16K page size
configurations when FEAT_LPA2 is known to have been implemented.

This adds these field definitions which will be used by KVM when
FEAT_LPA2 is enabled.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5882b2415596..e370e015d7c8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -106,6 +106,7 @@
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
 
 /* TCR_EL2 Registers bits */
+#define TCR_EL2_DS		(1UL << 32)
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
@@ -120,6 +121,7 @@
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
 
 /* VTCR_EL2 Registers bits */
+#define VTCR_EL2_DS		TCR_EL2_DS
 #define VTCR_EL2_RES1		(1U << 31)
 #define VTCR_EL2_HD		(1 << 22)
 #define VTCR_EL2_HA		(1 << 21)
-- 
2.25.1

