From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v2 3/6] irqchip/gic-v2: Gather ACPI specific data in a single
 structure
Date: Thu, 11 Feb 2016 15:33:21 +0000
Message-ID: <1455204804-31830-4-git-send-email-julien.grall@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A751049BF7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmPL1czQl9CM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 10:27:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0C449BEF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:43 -0500 (EST)
In-Reply-To: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

For now, there is only one member. More member will be added later.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>

    Changes in v2:
        - Patch added
---
 drivers/irqchip/irq-gic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 911758c..d6131c4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1246,7 +1246,10 @@ IRQCHIP_DECLARE(pl390, "arm,pl390", gic_of_init);
 #endif
 
 #ifdef CONFIG_ACPI
-static phys_addr_t cpu_phy_base __initdata;
+static struct
+{
+	phys_addr_t cpu_phy_base;
+} acpi_data __initdata;
 
 static int __init
 gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
@@ -1266,10 +1269,10 @@ gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
 	 * All CPU interface addresses have to be the same.
 	 */
 	gic_cpu_base = processor->base_address;
-	if (cpu_base_assigned && gic_cpu_base != cpu_phy_base)
+	if (cpu_base_assigned && gic_cpu_base != acpi_data.cpu_phy_base)
 		return -EINVAL;
 
-	cpu_phy_base = gic_cpu_base;
+	acpi_data.cpu_phy_base = gic_cpu_base;
 	cpu_base_assigned = 1;
 	return 0;
 }
@@ -1317,7 +1320,7 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
 		return -EINVAL;
 	}
 
-	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
+	cpu_base = ioremap(acpi_data.cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
 	if (!cpu_base) {
 		pr_err("Unable to map GICC registers\n");
 		return -ENOMEM;
-- 
1.9.1
