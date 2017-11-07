From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 05/26] KVM: arm/arm64: Check that system supports split
 eoi/deactivate
Date: Tue,  7 Nov 2017 11:47:38 +0100
Message-ID: <20171107104800.30021-6-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B383B49D8B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w0N3780+j6Nh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:23 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFB1049D76
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:23 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id p75so2736564wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:18 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

Some systems without proper firmware and/or hardware description data
don't support the split EOI and deactivate operation.

On such systems, we cannot leave the physical interrupt active after the
timer handler on the host has run, so we cannot support KVM with an
in-kernel GIC with the timer changes we are about to introduce.

This patch makes sure that trying to initialize the KVM GIC code will
fail on such systems.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++++--
 drivers/irqchip/irq-gic.c    | 6 ++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index b5df99c6f680..854334a6f225 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1228,7 +1228,9 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 		goto out_unmap_rdist;
 
 	gic_populate_ppi_partitions(node);
-	gic_of_setup_kvm_info(node);
+
+	if (static_key_true(&supports_deactivate))
+		gic_of_setup_kvm_info(node);
 	return 0;
 
 out_unmap_rdist:
@@ -1517,7 +1519,9 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 		goto out_fwhandle_free;
 
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC, domain_handle);
-	gic_acpi_setup_kvm_info();
+
+	if (static_key_true(&supports_deactivate))
+		gic_acpi_setup_kvm_info();
 
 	return 0;
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 651d726e8b12..cd9371b749c2 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1367,7 +1367,8 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 	if (ret)
 		return;
 
-	gic_set_kvm_info(&gic_v2_kvm_info);
+	if (static_key_true(&supports_deactivate))
+		gic_set_kvm_info(&gic_v2_kvm_info);
 }
 
 int __init
@@ -1599,7 +1600,8 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
 	if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
 		gicv2m_init(NULL, gic_data[0].domain);
 
-	gic_acpi_setup_kvm_info();
+	if (static_key_true(&supports_deactivate))
+		gic_acpi_setup_kvm_info();
 
 	return 0;
 }
-- 
2.14.2
