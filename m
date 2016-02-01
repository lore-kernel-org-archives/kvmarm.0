From: fu.wei@linaro.org
Subject: [PATCH v3 4/6] clocksource: move some enums to arm_arch_timer.h
Date: Tue,  2 Feb 2016 04:26:56 +0800
Message-ID: <1454358418-5157-5-git-send-email-fu.wei@linaro.org>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, al.stone@linaro.org, graeme.gregory@linaro.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, arnd@arndb.de, wim@iguana.be, jcm@redhat.com, leo.duran@amd.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Suravee.Suthikulpanit@amd.com, robherring2@gmail.com, Fu Wei <fu.wei@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Fu Wei <fu.wei@linaro.org>

The patch move enum ppi_nr from arm_arch_timer.c
to arm_arch_timer.h, and add enum spi_nr.

Signed-off-by: Fu Wei <fu.wei@linaro.org>
---
 drivers/clocksource/arm_arch_timer.c | 13 ++-----------
 include/clocksource/arm_arch_timer.h | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 3792fd6..90d17ef 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -52,15 +52,6 @@ struct arch_timer {
 #define to_arch_timer(e) container_of(e, struct arch_timer, evt)
 
 static u32 arch_timer_rate;
-
-enum ppi_nr {
-	PHYS_SECURE_PPI,
-	PHYS_NONSECURE_PPI,
-	VIRT_PPI,
-	HYP_PPI,
-	MAX_TIMER_PPI
-};
-
 static int arch_timer_ppi[MAX_TIMER_PPI];
 
 static struct clock_event_device __percpu *arch_timer_evt;
@@ -798,9 +789,9 @@ static void __init arch_timer_mem_init(struct device_node *np)
 	}
 
 	if (arch_timer_mem_use_virtual)
-		irq = irq_of_parse_and_map(best_frame, 1);
+		irq = irq_of_parse_and_map(best_frame, VIRT_SPI);
 	else
-		irq = irq_of_parse_and_map(best_frame, 0);
+		irq = irq_of_parse_and_map(best_frame, PHYS_SPI);
 	of_node_put(best_frame);
 	if (!irq) {
 		pr_err("arch_timer: Frame missing %s irq",
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 7a6d6dc..7bb5c1e 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -32,6 +32,20 @@ enum arch_timer_reg {
 	ARCH_TIMER_REG_TVAL,
 };
 
+enum ppi_nr {
+	PHYS_SECURE_PPI,
+	PHYS_NONSECURE_PPI,
+	VIRT_PPI,
+	HYP_PPI,
+	MAX_TIMER_PPI
+};
+
+enum spi_nr {
+	PHYS_SPI,
+	VIRT_SPI,
+	MAX_TIMER_SPI
+};
+
 #define ARCH_TIMER_PHYS_ACCESS		0
 #define ARCH_TIMER_VIRT_ACCESS		1
 #define ARCH_TIMER_MEM_PHYS_ACCESS	2
-- 
2.5.0
