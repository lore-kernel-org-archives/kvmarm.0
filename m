Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CBC46A8
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 06:26:55 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45EF212FC;
	Thu,  1 Jun 2023 23:27:40 -0700 (PDT)
Received: from a077893.blr.arm.com (unknown [10.162.41.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1B08D3F67D;
	Thu,  1 Jun 2023 23:26:50 -0700 (PDT)
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
Subject: [PATCH V2 11/14] arm64/sysreg: Convert TRBSR_EL1 register to automatic generation
Date: Fri,  2 Jun 2023 11:55:49 +0530
Message-Id: <20230602062552.565992-12-anshuman.khandual@arm.com>
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

This converts TRBSR_EL1 register to automatic generation without
causing any functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 12 ------------
 arch/arm64/tools/sysreg         | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 27d89b7ea0fa..768d12fc4834 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -235,24 +235,12 @@
 
 /*** End of Statistical Profiling Extension ***/
 
-#define SYS_TRBSR_EL1			sys_reg(3, 0, 9, 11, 3)
 #define SYS_TRBMAR_EL1			sys_reg(3, 0, 9, 11, 4)
 #define SYS_TRBTRG_EL1			sys_reg(3, 0, 9, 11, 6)
 #define SYS_TRBIDR_EL1			sys_reg(3, 0, 9, 11, 7)
 
-#define TRBSR_EL1_EC_MASK		GENMASK(31, 26)
-#define TRBSR_EL1_EC_SHIFT		26
-#define TRBSR_EL1_IRQ			BIT(22)
-#define TRBSR_EL1_TRG			BIT(21)
-#define TRBSR_EL1_WRAP			BIT(20)
-#define TRBSR_EL1_EA			BIT(18)
-#define TRBSR_EL1_S			BIT(17)
-#define TRBSR_EL1_MSS_MASK		GENMASK(15, 0)
-#define TRBSR_EL1_MSS_SHIFT		0
 #define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
 #define TRBSR_EL1_BSC_SHIFT		0
-#define TRBSR_EL1_FSC_MASK		GENMASK(5, 0)
-#define TRBSR_EL1_FSC_SHIFT		0
 #define TRBMAR_EL1_SH_MASK		GENMASK(9, 8)
 #define TRBMAR_EL1_SH_SHIFT		8
 #define TRBMAR_EL1_Attr_MASK		GENMASK(7, 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index c58731f69467..6d12980f01c7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2227,3 +2227,19 @@ Sysreg	TRBBASER_EL1	3	0	9	11	2
 Field	63:12	BASE
 Res0	11:0
 EndSysreg
+
+Sysreg	TRBSR_EL1	3	0	9	11	3
+Res0	63:56
+Field	55:32	MSS2
+Field	31:26	EC
+Res0	25:24
+Field	23	DAT
+Field	22	IRQ
+Field	21	TRG
+Field	20	WRAP
+Res0	19
+Field	18	EA
+Field	17	S
+Res0	16
+Field	15:0	MSS
+EndSysreg
-- 
2.25.1

