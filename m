Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F879266A4
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98A1114BF;
	Thu, 12 Oct 2023 05:35:50 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15AF73F5A1;
	Thu, 12 Oct 2023 05:35:08 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 1/2] KVM: arm64: add nPIR{E0}_EL1 to HFG traps
Date: Thu, 12 Oct 2023 13:34:58 +0100
Message-Id: <20231012123459.2820835-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231012123459.2820835-1-joey.gouly@arm.com>
References: <20231012123459.2820835-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nPIR_EL1 and nPIREO_EL1 are part of the 'reverse polarity' set of bits, set
them so that we disable the traps for a guest.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Fixes: e930694e6145 ("KVM: arm64: Restructure FGT register switching")
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5882b2415596..1095c6647e96 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -344,14 +344,14 @@
  */
 #define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGRTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
+#define __HFGRTR_EL2_nMASK	(GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
 
 #define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
 				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
 				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
 				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
 #define __HFGWTR_EL2_MASK	GENMASK(49, 0)
-#define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
+#define __HFGWTR_EL2_nMASK	(GENMASK(58, 57) | GENMASK(55, 54) | BIT(50))
 
 #define __HFGITR_EL2_RES0	GENMASK(63, 57)
 #define __HFGITR_EL2_MASK	GENMASK(54, 0)
-- 
2.25.1

