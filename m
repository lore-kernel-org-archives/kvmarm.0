From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 01/26] irqchip/gic-v3-its: Setup VLPI properties at map time
Date: Fri, 27 Oct 2017 15:28:30 +0100
Message-ID: <20171027142855.21584-2-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we require the hypervisor to update the VLPI properties
once the the VLPI mapping has been established. While this
makes it easy for the ITS driver, it creates a window where
an incoming interrupt can be delivered with an unknown set
of properties. Not very nice.

Instead, let's add a "properties" field to the mapping structure,
and use that to configure the VLPI before it actually gets mapped.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 19 +++++++++++++++++--
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 85f47ef4f1f7..2c4074c97454 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1006,9 +1006,15 @@ static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 	if (irqd_is_forwarded_to_vcpu(d)) {
 		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 		u32 event = its_get_event_id(d);
+		struct its_vlpi_map *map;
 
 		prop_page = its_dev->event_map.vm->vprop_page;
-		hwirq = its_dev->event_map.vlpi_maps[event].vintid;
+		map = &its_dev->event_map.vlpi_maps[event];
+		hwirq = map->vintid;
+
+		/* Remember the updated property */
+		map->properties &= ~clr;
+		map->properties |= set | LPI_PROP_GROUP1;
 	} else {
 		prop_page = gic_rdists->prop_page;
 		hwirq = d->hwirq;
@@ -1018,6 +1024,7 @@ static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 	*cfg &= ~clr;
 	*cfg |= set | LPI_PROP_GROUP1;
 
+
 	/*
 	 * Make the above write visible to the redistributors.
 	 * And yes, we're flushing exactly: One. Single. Byte.
@@ -1238,12 +1245,20 @@ static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
 		/* Ensure all the VPEs are mapped on this ITS */
 		its_map_vm(its_dev->its, info->map->vm);
 
+		/*
+		 * Flag the interrupt as forwarded so that we can
+		 * start poking the virtual property table.
+		 */
+		irqd_set_forwarded_to_vcpu(d);
+
+		/* Write out the property to the prop table */
+		lpi_write_config(d, 0xff, info->map->properties);
+
 		/* Drop the physical mapping */
 		its_send_discard(its_dev, event);
 
 		/* and install the virtual one */
 		its_send_vmapti(its_dev, event);
-		irqd_set_forwarded_to_vcpu(d);
 
 		/* Increment the number of VLPIs */
 		its_dev->event_map.nr_vlpis++;
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 43cde15f221b..447da8ca2156 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -71,12 +71,14 @@ struct its_vpe {
  * @vm:		Pointer to the GICv4 notion of a VM
  * @vpe:	Pointer to the GICv4 notion of a virtual CPU (VPE)
  * @vintid:	Virtual LPI number
+ * @properties:	Priority and enable bits (as written in the prop table)
  * @db_enabled:	Is the VPE doorbell to be generated?
  */
 struct its_vlpi_map {
 	struct its_vm		*vm;
 	struct its_vpe		*vpe;
 	u32			vintid;
+	u8			properties;
 	bool			db_enabled;
 };
 
-- 
2.11.0
