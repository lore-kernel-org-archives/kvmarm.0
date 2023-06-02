Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9005B46A8
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 06:26:28 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BFA11063;
	Thu,  1 Jun 2023 23:27:13 -0700 (PDT)
Received: from a077893.blr.arm.com (unknown [10.162.41.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E3913F67D;
	Thu,  1 Jun 2023 23:26:24 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	broonie@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.linux.dev,
	coresight@lists.linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 05/14] arm64/sysreg: Rename TRBMAR_EL1 fields per auto-gen tools format
Date: Fri,  2 Jun 2023 11:55:43 +0530
Message-Id: <20230602062552.565992-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230602062552.565992-1-anshuman.khandual@arm.com>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This renames TRBMAR_EL1 register fields per auto-gen tools format without
causing any functional change in the TRBE driver.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: coresight@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index af9e93ca1905..58cc9fd1935e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -271,12 +271,10 @@
 #define TRBSR_EL1_BSC_SHIFT		0
 #define TRBSR_EL1_FSC_MASK		GENMASK(5, 0)
 #define TRBSR_EL1_FSC_SHIFT		0
-#define TRBMAR_SHARE_MASK		GENMASK(1, 0)
-#define TRBMAR_SHARE_SHIFT		8
-#define TRBMAR_OUTER_MASK		GENMASK(3, 0)
-#define TRBMAR_OUTER_SHIFT		4
-#define TRBMAR_INNER_MASK		GENMASK(3, 0)
-#define TRBMAR_INNER_SHIFT		0
+#define TRBMAR_EL1_SH_MASK		GENMASK(9, 8)
+#define TRBMAR_EL1_SH_SHIFT		8
+#define TRBMAR_EL1_Attr_MASK		GENMASK(7, 0)
+#define TRBMAR_EL1_Attr_SHIFT		0
 #define TRBTRG_TRG_MASK			GENMASK(31, 0)
 #define TRBTRG_TRG_SHIFT		0
 #define TRBIDR_FLAG			BIT(5)
-- 
2.25.1

