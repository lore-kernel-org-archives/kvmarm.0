From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v3 13/13] firmware: arm_sdei: Discover SDEI support via ACPI
Date: Fri, 22 Sep 2017 19:26:14 +0100
Message-ID: <20170922182614.27885-14-james.morse@arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170922182614.27885-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

SDEI defines a new ACPI table to indicate the presence of the interface.
The conduit is discovered in the same way as PSCI.

For ACPI we need to create the platform device ourselves as SDEI doesn't
have an entry in the DSDT.

The SDEI platform device should be created after ACPI has been initialised
so that we can parse the table, but before GHES devices are created, which
may register SDE events if they use SDEI as their notification type.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 drivers/firmware/arm_sdei.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 3bee2719d6f4..50b6b1d0fe72 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -912,6 +912,14 @@ static int sdei_get_conduit(struct platform_device *pdev)
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
@@ -1025,14 +1033,45 @@ static bool __init sdei_present_dt(void)
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
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
