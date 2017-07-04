From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 2/2] arm64: timer: check for vtimer interrupt
Date: Tue,  4 Jul 2017 15:58:38 +0200
Message-ID: <20170704135838.9061-3-drjones@redhat.com>
References: <20170704135838.9061-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170704135838.9061-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: agraf@suse.de, cdall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index ec110ee08d97..89f4c9400ab6 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,6 +17,21 @@
 
 static u32 vtimer_irq, vtimer_irq_flags;
 static void *gic_ispendr;
+static bool vtimer_irq_received;
+
+static void irq_handler(struct pt_regs *regs)
+{
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr != GICC_INT_SPURIOUS)
+		gic_write_eoir(irqstat);
+
+	if (irqnr == PPI(vtimer_irq)) {
+		write_sysreg(CNTV_CTL_IMASK, cntv_ctl_el0);
+		++vtimer_irq_received;
+	}
+}
 
 static bool gic_vtimer_pending(void)
 {
@@ -64,7 +79,7 @@ static void test_vtimer(void)
 
 	report("not pending before", !gic_vtimer_pending());
 	report("latency within 10 ms", test_cval_10msec());
-	report("pending after", gic_vtimer_pending());
+	report("interrupt received", vtimer_irq_received);
 
 	/* Disable the timer again */
 	write_sysreg(0, cntv_ctl_el0);
@@ -92,12 +107,17 @@ static void test_init(void)
 
 	switch (gic_version()) {
 	case 2:
+		writel(1 << PPI(vtimer_irq), gicv2_dist_base() + GICD_ISENABLER + 0);
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
 		break;
 	case 3:
+		writel(1 << PPI(vtimer_irq), gicv3_sgi_base() + GICR_ISENABLER0);
 		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
 		break;
 	}
+
+	install_irq_handler(EL1H_IRQ, irq_handler);
+	local_irq_enable();
 }
 
 int main(void)
-- 
2.9.4
