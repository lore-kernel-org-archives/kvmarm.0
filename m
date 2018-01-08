From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 13/16] arm64: acpi: Remove __init from acpi_psci_use_hvc()
 for use by SDEI
Date: Mon,  8 Jan 2018 15:38:15 +0000
Message-ID: <20180108153818.22743-14-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE2C49DB6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WbJyVKvzjKFc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 10:36:41 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECFE49DDB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:41 -0500 (EST)
In-Reply-To: <20180108153818.22743-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SDEI inherits the 'use hvc' bit that is also used by PSCI. PSCI does all
its initialisation early, SDEI does its late.

Remove the __init annotation from acpi_psci_use_hvc().

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
The function name is unchanged as this bit is named 'PSCI_USE_HVC'
in table 5-37 of ACPIv6.2.

 arch/arm64/kernel/acpi.c | 2 +-
 include/linux/psci.h     | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index b3162715ed78..252396a96c78 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -117,7 +117,7 @@ bool __init acpi_psci_present(void)
 }
 
 /* Whether HVC must be used instead of SMC as the PSCI conduit */
-bool __init acpi_psci_use_hvc(void)
+bool acpi_psci_use_hvc(void)
 {
 	return acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC;
 }
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 6306ab10af18..f724fd8c78e8 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -47,10 +47,11 @@ static inline int psci_dt_init(void) { return 0; }
 #if defined(CONFIG_ARM_PSCI_FW) && defined(CONFIG_ACPI)
 int __init psci_acpi_init(void);
 bool __init acpi_psci_present(void);
-bool __init acpi_psci_use_hvc(void);
+bool acpi_psci_use_hvc(void);
 #else
 static inline int psci_acpi_init(void) { return 0; }
 static inline bool acpi_psci_present(void) { return false; }
+static inline bool acpi_psci_use_hvc(void) {return false; }
 #endif
 
 #endif /* __LINUX_PSCI_H */
-- 
2.15.0
