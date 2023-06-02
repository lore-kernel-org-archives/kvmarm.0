Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE3546A8
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 06:26:59 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DC911063;
	Thu,  1 Jun 2023 23:27:44 -0700 (PDT)
Received: from a077893.blr.arm.com (unknown [10.162.41.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 589B63F67D;
	Thu,  1 Jun 2023 23:26:55 -0700 (PDT)
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
Subject: [PATCH V2 12/14] arm64/sysreg: Convert TRBMAR_EL1 register to automatic generation
Date: Fri,  2 Jun 2023 11:55:50 +0530
Message-Id: <20230602062552.565992-13-anshuman.khandual@arm.com>
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

This converts TRBMAR_EL1 register to automatic generation without
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
 arch/arm64/include/asm/sysreg.h | 5 -----
 arch/arm64/tools/sysreg         | 7 +++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 768d12fc4834..131442f850dd 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -235,16 +235,11 @@
 
 /*** End of Statistical Profiling Extension ***/
 
-#define SYS_TRBMAR_EL1			sys_reg(3, 0, 9, 11, 4)
 #define SYS_TRBTRG_EL1			sys_reg(3, 0, 9, 11, 6)
 #define SYS_TRBIDR_EL1			sys_reg(3, 0, 9, 11, 7)
 
 #define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
 #define TRBSR_EL1_BSC_SHIFT		0
-#define TRBMAR_EL1_SH_MASK		GENMASK(9, 8)
-#define TRBMAR_EL1_SH_SHIFT		8
-#define TRBMAR_EL1_Attr_MASK		GENMASK(7, 0)
-#define TRBMAR_EL1_Attr_SHIFT		0
 #define TRBTRG_EL1_TRG_MASK		GENMASK(31, 0)
 #define TRBTRG_EL1_TRG_SHIFT		0
 #define TRBIDR_EL1_F			BIT(5)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6d12980f01c7..b3f9a545e1e7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2243,3 +2243,10 @@ Field	17	S
 Res0	16
 Field	15:0	MSS
 EndSysreg
+
+Sysreg	TRBMAR_EL1	3	0	9	11	4
+Res0	63:12
+Field	11:10	PAS
+Field	9:8	SH
+Field	7:0	Attr
+EndSysreg
-- 
2.25.1

