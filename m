From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 01/20] irqchip/gic: Deal with broken firmware exposing only 4kB of GICv2 CPU interface
Date: Fri, 27 Oct 2017 10:34:22 +0200
Message-ID: <1509093281-15225-2-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

There is a lot of broken firmware out there that don't really
expose the information the kernel requires when it comes with dealing
with GICv2:

(1) Firmware that only describes the first 4kB of GICv2
(2) Firmware that describe 128kB of CPU interface, while
    the usable portion of the address space is between
    60 and 68kB

So far, we only deal with (2). But we have platforms exhibiting
behaviour (1), resulting in two sub-cases:
(a) The GIC is occupying 8kB, as required by the GICv2 architecture
(b) It is actually spread 128kB, and this is likely to be a version
    of (2)

This patch tries to work around both (a) and (b) by poking at
the outside of the described memory region, and try to work out
what is actually there. This is of course unsafe, and should
only be enabled if there is no way to otherwise fix the DT provided
by the firmware (we provide a "irqchip.gicv2_force_probe" option
to that effect).

Note that for the time being, we restrict ourselves to GICv2
implementations provided by ARM, since there I have no knowledge
of an alternative implementations. This could be relaxed if such
an implementation comes to light on a broken platform.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 +++
 drivers/irqchip/irq-gic.c                       | 71 +++++++++++++++++++++----
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0549662..3daa0a5 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1713,6 +1713,13 @@
 	irqaffinity=	[SMP] Set the default irq affinity mask
 			The argument is a cpu list, as described above.
 
+	irqchip.gicv2_force_probe=
+			[ARM, ARM64]
+			Format: <bool>
+			Force the kernel to look for the second 4kB page
+			of a GICv2 controller even if the memory range
+			exposed by the device tree is too small.
+
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 651d726..f641e8e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1256,6 +1256,19 @@ static void gic_teardown(struct gic_chip_data *gic)
 
 #ifdef CONFIG_OF
 static int gic_cnt __initdata;
+static bool gicv2_force_probe;
+
+static int __init gicv2_force_probe_cfg(char *buf)
+{
+	return strtobool(buf, &gicv2_force_probe);
+}
+early_param("irqchip.gicv2_force_probe", gicv2_force_probe_cfg);
+
+static bool gic_check_gicv2(void __iomem *base)
+{
+	u32 val = readl_relaxed(base + GIC_CPU_IDENT);
+	return (val & 0xff0fff) == 0x02043B;
+}
 
 static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
 {
@@ -1265,20 +1278,60 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
 
 	if (!is_hyp_mode_available())
 		return false;
-	if (resource_size(&cpuif_res) < SZ_8K)
-		return false;
-	if (resource_size(&cpuif_res) == SZ_128K) {
-		u32 val_low, val_high;
+	if (resource_size(&cpuif_res) < SZ_8K) {
+		void __iomem *alt;
+		/*
+		 * Check for a stupid firmware that only exposes the
+		 * first page of a GICv2.
+		 */
+		if (!gic_check_gicv2(*base))
+			return false;
 
+		if (!gicv2_force_probe) {
+			pr_warn("GIC: GICv2 detected, but range too small and irqchip.gicv2_force_probe not set\n");
+			return false;
+		}
+
+		alt = ioremap(cpuif_res.start, SZ_8K);
+		if (!alt)
+			return false;
+		if (!gic_check_gicv2(alt + SZ_4K)) {
+			/*
+			 * The first page was that of a GICv2, and
+			 * the second was *something*. Let's trust it
+			 * to be a GICv2, and update the mapping.
+			 */
+			pr_warn("GIC: GICv2 at %pa, but range is too small (broken DT?), assuming 8kB\n",
+				&cpuif_res.start);
+			iounmap(*base);
+			*base = alt;
+			return true;
+		}
+
+		/*
+		 * We detected *two* initial GICv2 pages in a
+		 * row. Could be a GICv2 aliased over two 64kB
+		 * pages. Update the resource, map the iospace, and
+		 * pray.
+		 */
+		iounmap(alt);
+		alt = ioremap(cpuif_res.start, SZ_128K);
+		if (!alt)
+			return false;
+		pr_warn("GIC: Aliased GICv2 at %pa, trying to find the canonical range over 128kB\n",
+			&cpuif_res.start);
+		cpuif_res.end = cpuif_res.start + SZ_128K -1;
+		iounmap(*base);
+		*base = alt;
+	}
+	if (resource_size(&cpuif_res) == SZ_128K) {
 		/*
-		 * Verify that we have the first 4kB of a GIC400
+		 * Verify that we have the first 4kB of a GICv2
 		 * aliased over the first 64kB by checking the
 		 * GICC_IIDR register on both ends.
 		 */
-		val_low = readl_relaxed(*base + GIC_CPU_IDENT);
-		val_high = readl_relaxed(*base + GIC_CPU_IDENT + 0xf000);
-		if ((val_low & 0xffff0fff) != 0x0202043B ||
-		    val_low != val_high)
+		if (!gic_check_gicv2(*base) ||
+		    !gic_check_gicv2(*base + 0xf000))
 			return false;
 
 		/*
-- 
2.7.4
