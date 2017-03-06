From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [kvm-unit-tests PATCH] arm/arm64: gic: Test changing active state of interrupts
Date: Mon,  6 Mar 2017 07:16:09 -0800
Message-ID: <1488813369-87368-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We found a deadlock when changing the active state of an interrupt while
the interrupt is queued on the LR of the running VCPU.

Defend KVM against this bug in the future now when we've introduced a
fix.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Sending with the right subject prefix this time.

 arm/gic.c         | 43 +++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg | 14 +++++++++++++-
 lib/arm/asm/gic.h |  2 ++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index 3054d45..82f6632 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -254,6 +254,47 @@ static struct gic gicv3 = {
 	},
 };
 
+static void ipi_clear_active_handler(struct pt_regs *regs __unused)
+{
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr != GICC_INT_SPURIOUS) {
+		void *base;
+		u32 val = 1 << IPI_IRQ;
+
+		if (gic_version() == 2)
+			base = gicv2_dist_base();
+		else
+			base = gicv3_redist_base();
+
+		writel(val, base + GICD_ICACTIVER);
+
+		smp_rmb(); /* pairs with wmb in stats_reset */
+		++acked[smp_processor_id()];
+		check_irqnr(irqnr);
+		smp_wmb(); /* pairs with rmb in check_acked */
+	} else {
+		++spurious[smp_processor_id()];
+		smp_wmb();
+	}
+}
+
+static void run_active_clear_test(void)
+{
+	report_prefix_push("active");
+	gic_enable_defaults();
+#ifdef __arm__
+	install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
+#else
+	install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
+#endif
+	local_irq_enable();
+
+	ipi_test_self();
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 	char pfx[8];
@@ -290,6 +331,8 @@ int main(int argc, char **argv)
 				cpu == IPI_SENDER ? ipi_send : ipi_recv);
 		}
 		ipi_recv();
+	} else if (strcmp(argv[1], "active") == 0) {
+		run_active_clear_test();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index c98658f..32d9858 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -26,7 +26,7 @@
 ##############################################################################
 
 #
-# Test that the configured number of processors (smp = <num>), and
+/# Test that the configured number of processors (smp = <num>), and
 # that the configured amount of memory (-m <MB>) are correctly setup
 # by the framework.
 #
@@ -92,6 +92,18 @@ smp = $MAX_SMP
 extra_params = -machine gic-version=3 -append 'ipi'
 groups = gic
 
+[gicv2-active]
+file = gic.flat
+smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
+extra_params = -machine gic-version=2 -append 'active'
+groups = gic
+
+[gicv3-active]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'active'
+groups = gic
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index c8186f2..c688ccc 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -12,6 +12,8 @@
 #define GICD_TYPER			0x0004
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ISACTIVER			0x0300
+#define GICD_ICACTIVER			0x0380
 #define GICD_IPRIORITYR			0x0400
 #define GICD_SGIR			0x0f00
 
-- 
2.5.0
