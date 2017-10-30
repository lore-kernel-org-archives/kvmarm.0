From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v4 14/13] firmware: arm_sdei: Move cpuhotplug registration later
Date: Mon, 30 Oct 2017 15:58:35 +0000
Message-ID: <20171030155835.20622-1-james.morse@arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017174432.1684-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Will points out the sdei_probe() code may be pre-empted to bring a CPU
online. If this happens between registering the cpu-hotplug callbacks
and the okay-we're-ready cross call, the new CPU may be left unmasked
even if we failed for some other reason.

Move the cpuhotplug callback registration last and switch to the
vanilla version that makes the call for all online CPUs. Add a call
to forcibly mask CPUs in the error path.

Suggested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 drivers/firmware/arm_sdei.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index f764f48144c2..14b6d170518c 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -964,17 +964,10 @@ static int sdei_probe(struct platform_device *pdev)
 		return 0;
 	}
 
-	err = cpuhp_setup_state_nocalls(CPUHP_AP_ARM_SDEI_STARTING, "SDEI",
-				&sdei_cpuhp_up, &sdei_cpuhp_down);
-	if (err) {
-		pr_warn("Failed to register CPU hotplug notifier...\n");
-		return err;
-	}
-
 	err = cpu_pm_register_notifier(&sdei_pm_nb);
 	if (err) {
 		pr_warn("Failed to register CPU PM notifier...\n");
-		goto remove_cpuhp;
+		goto error;
 	}
 
 	err = register_reboot_notifier(&sdei_reboot_nb);
@@ -983,16 +976,23 @@ static int sdei_probe(struct platform_device *pdev)
 		goto remove_cpupm;
 	}
 
-	on_each_cpu(&_ipi_unmask_cpu, NULL, false);
+	err = cpuhp_setup_state(CPUHP_AP_ARM_SDEI_STARTING, "SDEI",
+				&sdei_cpuhp_up, &sdei_cpuhp_down);
+	if (err) {
+		pr_warn("Failed to register CPU hotplug notifier...\n");
+		goto remove_reboot;
+	}
 
 	return 0;
 
+remove_reboot:
+	unregister_reboot_notifier(&sdei_reboot_nb);
+
 remove_cpupm:
 	cpu_pm_unregister_notifier(&sdei_pm_nb);
 
-remove_cpuhp:
-	cpuhp_remove_state_nocalls(CPUHP_AP_ARM_SDEI_STARTING);
-
+error:
+	sdei_mark_interface_broken();
 	return err;
 }
 
-- 
2.15.0.rc2

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
