Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD44B3FDB
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 06:26:15 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45EA11474;
	Thu,  1 Jun 2023 23:27:00 -0700 (PDT)
Received: from a077893.blr.arm.com (unknown [10.162.41.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A2AB33F67D;
	Thu,  1 Jun 2023 23:26:10 -0700 (PDT)
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
Subject: [PATCH V2 02/14] arm64/sysreg: Rename TRBPTR_EL1 fields per auto-gen tools format
Date: Fri,  2 Jun 2023 11:55:40 +0530
Message-Id: <20230602062552.565992-3-anshuman.khandual@arm.com>
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

This renames TRBPTR_EL1 register fields per auto-gen tools format without
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
 arch/arm64/include/asm/sysreg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b2b67ae7525b..2cb1078bc67f 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -254,8 +254,8 @@
 #define TRBLIMITR_EL1_FM_MASK		GENMASK(2, 1)
 #define TRBLIMITR_EL1_FM_SHIFT		1
 #define TRBLIMITR_EL1_E			BIT(0)
-#define TRBPTR_PTR_MASK			GENMASK_ULL(63, 0)
-#define TRBPTR_PTR_SHIFT		0
+#define TRBPTR_EL1_PTR_MASK		GENMASK_ULL(63, 0)
+#define TRBPTR_EL1_PTR_SHIFT		0
 #define TRBBASER_BASE_MASK		GENMASK_ULL(51, 0)
 #define TRBBASER_BASE_SHIFT		12
 #define TRBSR_EC_MASK			GENMASK(5, 0)
-- 
2.25.1

