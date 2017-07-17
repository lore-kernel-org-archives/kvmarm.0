From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 05/19] KVM: arm/arm64: Check that system supports split
 eoi/deactivate
Date: Mon, 17 Jul 2017 16:27:04 +0200
Message-ID: <20170717142718.13853-6-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 337F040D16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lY4VnTI6JKCH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:44 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 574F649C09
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:44 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w126so77795299wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:30 -0700 (PDT)
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Some systems without proper firmware and/or hardware description data
don't support the split EOI and deactivate operation.

On such systems, we cannot leave the physical interrupt active after the
timer handler on the host has run, so we cannot support KVM with an
in-kernel GIC with the timer changes we about to introduce.

This patch makes sure that trying to initialize the KVM GIC code will
fail on such systems.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 drivers/irqchip/irq-gic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 090991f..b7e4fed 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1391,7 +1391,8 @@ int gic_of_init_child(struct device *dev, struct gic_chip_data **gic, int irq)
 	return 0;
 }
 
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static void __init gic_of_setup_kvm_info(struct device_node *node,
+					 bool supports_deactivate)
 {
 	int ret;
 	struct resource *vctrl_res = &gic_v2_kvm_info.vctrl;
@@ -1411,6 +1412,9 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 	if (ret)
 		return;
 
+	if (!supports_deactivate)
+		return;
+
 	gic_set_kvm_info(&gic_v2_kvm_info);
 }
 
@@ -1419,6 +1423,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	struct gic_chip_data *gic;
 	int irq, ret;
+	bool has_eoimode;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -1436,7 +1441,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	 * Disable split EOI/Deactivate if either HYP is not available
 	 * or the CPU interface is too small.
 	 */
-	if (gic_cnt == 0 && !gic_check_eoimode(node, &gic->raw_cpu_base))
+	has_eoimode = gic_check_eoimode(node, &gic->raw_cpu_base);
+	if (gic_cnt == 0 && !has_eoimode)
 		static_key_slow_dec(&supports_deactivate);
 
 	ret = __gic_init_bases(gic, -1, &node->fwnode);
@@ -1447,7 +1453,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 
 	if (!gic_cnt) {
 		gic_init_physaddr(node);
-		gic_of_setup_kvm_info(node);
+		gic_of_setup_kvm_info(node, has_eoimode);
 	}
 
 	if (parent) {
-- 
2.9.0
