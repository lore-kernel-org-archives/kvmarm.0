Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151AB36B0E
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72882143D;
	Mon,  9 Oct 2023 11:51:03 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F5EB3F5A1;
	Mon,  9 Oct 2023 11:50:21 -0700 (PDT)
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
Subject: [PATCH v4 03/12] arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]
Date: Mon,  9 Oct 2023 19:49:59 +0100
Message-Id: <20231009185008.3803879-4-ryan.roberts@arm.com>
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

From: Anshuman Khandual <anshuman.khandual@arm.com>

PAGE_SIZE support is tested against possible minimum and maximum values for
its respective ID_AA64MMFR0.TGRAN field, depending on whether it is signed
or unsigned. But then FEAT_LPA2 implementation needs to be validated for 4K
and 16K page sizes via feature specific ID_AA64MMFR0.TGRAN values. Hence it
adds FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2] values per ARM ARM (0487G.A).

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 38296579a4fd..bc782116315a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -826,10 +826,12 @@
 
 /* id_aa64mmfr0 */
 #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_EL1_TGRAN4_LPA2		ID_AA64MMFR0_EL1_TGRAN4_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX	0x7
 #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MIN	0x0
 #define ID_AA64MMFR0_EL1_TGRAN64_SUPPORTED_MAX	0x7
 #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN	0x1
+#define ID_AA64MMFR0_EL1_TGRAN16_LPA2		ID_AA64MMFR0_EL1_TGRAN16_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX	0xf
 
 #define ARM64_MIN_PARANGE_BITS		32
@@ -837,6 +839,7 @@
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_DEFAULT	0x0
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_NONE		0x1
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MIN		0x2
+#define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2		0x3
 #define ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_MAX		0x7
 
 #ifdef CONFIG_ARM64_PA_BITS_52
@@ -847,11 +850,13 @@
 
 #if defined(CONFIG_ARM64_4K_PAGES)
 #define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_LPA2		ID_AA64MMFR0_EL1_TGRAN4_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MIN
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN4_SUPPORTED_MAX
 #define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN4_2_SHIFT
 #elif defined(CONFIG_ARM64_16K_PAGES)
 #define ID_AA64MMFR0_EL1_TGRAN_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_SHIFT
+#define ID_AA64MMFR0_EL1_TGRAN_LPA2		ID_AA64MMFR0_EL1_TGRAN16_52_BIT
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MIN
 #define ID_AA64MMFR0_EL1_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_EL1_TGRAN16_SUPPORTED_MAX
 #define ID_AA64MMFR0_EL1_TGRAN_2_SHIFT		ID_AA64MMFR0_EL1_TGRAN16_2_SHIFT
-- 
2.25.1

