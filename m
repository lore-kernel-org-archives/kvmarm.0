Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74E37F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 07:01:11 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 028441FB;
	Wed, 14 Jun 2023 00:01:56 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.46.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 75AE43F663;
	Wed, 14 Jun 2023 00:01:07 -0700 (PDT)
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
Subject: [PATCH V3 13/14] arm64/sysreg: Convert TRBTRG_EL1 register to automatic generation
Date: Wed, 14 Jun 2023 12:29:48 +0530
Message-Id: <20230614065949.146187-14-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614065949.146187-1-anshuman.khandual@arm.com>
References: <20230614065949.146187-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This converts TRBTRG_EL1 register to automatic generation without
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
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 3 ---
 arch/arm64/tools/sysreg         | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1d87de37364a..088831b6cf6c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -241,13 +241,10 @@
 
 /*** End of Statistical Profiling Extension ***/
 
-#define SYS_TRBTRG_EL1			sys_reg(3, 0, 9, 11, 6)
 #define SYS_TRBIDR_EL1			sys_reg(3, 0, 9, 11, 7)
 
 #define TRBSR_EL1_BSC_MASK		GENMASK(5, 0)
 #define TRBSR_EL1_BSC_SHIFT		0
-#define TRBTRG_EL1_TRG_MASK		GENMASK(31, 0)
-#define TRBTRG_EL1_TRG_SHIFT		0
 #define TRBIDR_EL1_F			BIT(5)
 #define TRBIDR_EL1_P			BIT(4)
 #define TRBIDR_EL1_Align_MASK		GENMASK(3, 0)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index ef2cea2aa037..4292e6014d2e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2259,3 +2259,8 @@ Enum	9:8	SH
 EndEnum
 Field	7:0	Attr
 EndSysreg
+
+Sysreg	TRBTRG_EL1	3	0	9	11	6
+Res0	63:32
+Field	31:0	TRG
+EndSysreg
-- 
2.25.1

