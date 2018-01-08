From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 14/16] firmware: arm_sdei: Discover SDEI support via ACPI
Date: Mon,  8 Jan 2018 15:38:16 +0000
Message-ID: <20180108153818.22743-15-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E11B949DB5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7B4ReXnmbJ51 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 10:36:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F087349E13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:43 -0500 (EST)
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

SDEI defines a new ACPI table to indicate the presence of the interface.
The conduit is discovered in the same way as PSCI.

For ACPI we need to create the platform device ourselves as SDEI doesn't
have an entry in the DSDT.

The SDEI platform device should be created after ACPI has been initialised
so that we can parse the table, but before GHES devices are created, which
may register SDE events if they use SDEI as their notification type.

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/firmware/arm_sdei.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 10a8bfa7339a..fb7caa3628b9 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -907,6 +907,14 @@ static int sdei_get_conduit(struct platform_device *pdev)
 		}
 
 		pr_warn("invalid \"method\" property: %s\n", method);
+	} else if (IS_ENABLED(CONFIG_ACPI) && !acpi_disabled) {
+		if (acpi_psci_use_hvc()) {
+			sdei_firmware_call = &sdei_smccc_hvc;
+			return CONDUIT_HVC;
+		} else {
+			sdei_firmware_call = &sdei_smccc_smc;
+			return CONDUIT_SMC;
+		}
 	}
 
 	return CONDUIT_INVALID;
@@ -1020,14 +1028,45 @@ static bool __init sdei_present_dt(void)
 	return true;
 }
 
+static bool __init sdei_present_acpi(void)
+{
+	acpi_status status;
+	struct platform_device *pdev;
+	struct acpi_table_header *sdei_table_header;
+
+	if (acpi_disabled)
+		return false;
+
+	status = acpi_get_table(ACPI_SIG_SDEI, 0, &sdei_table_header);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		const char *msg = acpi_format_exception(status);
+
+		pr_info("Failed to get ACPI:SDEI table, %s\n", msg);
+	}
+	if (ACPI_FAILURE(status))
+		return false;
+
+	pdev = platform_device_register_simple(sdei_driver.driver.name, 0, NULL,
+					       0);
+	if (IS_ERR(pdev))
+		return false;
+
+	return true;
+}
+
 static int __init sdei_init(void)
 {
-	if (sdei_present_dt())
+	if (sdei_present_dt() || sdei_present_acpi())
 		platform_driver_register(&sdei_driver);
 
 	return 0;
 }
 
+/*
+ * On an ACPI system SDEI needs to be ready before HEST:GHES tries to register
+ * its events. ACPI is initialised from a subsys_initcall(), GHES is initialised
+ * by device_initcall(). We want to be called in the middle.
+ */
 subsys_initcall_sync(sdei_init);
 
 int sdei_event_handler(struct pt_regs *regs,
-- 
2.15.0
