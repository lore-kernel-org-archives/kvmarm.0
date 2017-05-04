From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 11/24] KVM: arm64: vgic-its: Interpret MAPD Size field and check related errors
Date: Thu,  4 May 2017 13:44:31 +0200
Message-ID: <1493898284-29504-12-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Up to now the MAPD's ITT size field has been ignored. It encodes
the number of eventid bit minus 1. It should be used to check
the eventid when a MAPTI command is issued on a device. Let's
store the number of eventid bits in the its_device and do the
check on MAPTI. Also make sure the ITT size field does
not exceed the GITS_TYPER IDBITS field.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>

---
v5 -> v6:
- add Christoffer's R-b
- rename nb_eventid_bits into num_eventid_bits

v4 -> v5:
- its_cmd_get_size macro now returns the actual number of eventid bits
- use GIC_ENCODE_SZ macro to encode ID_bits

v3 -> v4:
- VITS_TYPER_IDBITS set to 16 to be homogeneous with VITS_ESZ definition
  and correct users
- nb_eventid_bits correspond to the actual number of eventid bits
---
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 virt/kvm/arm/vgic/vgic-its.c       | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 59f1abd..9519c7b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -346,9 +346,11 @@
 #define E_ITS_INT_UNMAPPED_INTERRUPT		0x010307
 #define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
 #define E_ITS_MAPD_DEVICE_OOR			0x010801
+#define E_ITS_MAPD_ITTSIZE_OOR			0x010802
 #define E_ITS_MAPC_PROCNUM_OOR			0x010902
 #define E_ITS_MAPC_COLLECTION_OOR		0x010903
 #define E_ITS_MAPTI_UNMAPPED_DEVICE		0x010a04
+#define E_ITS_MAPTI_ID_OOR			0x010a05
 #define E_ITS_MAPTI_PHYSICALID_OOR		0x010a06
 #define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
 #define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 072efbd..06e01d1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -105,6 +105,7 @@ struct its_device {
 
 	/* the head for the list of ITTEs */
 	struct list_head itt_head;
+	u32 num_eventid_bits;
 	u32 device_id;
 };
 
@@ -201,6 +202,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 
 #define GIC_LPI_OFFSET 8192
 
+#define VITS_TYPER_IDBITS 16
+
 /*
  * Finds and returns a collection in the ITS collection table.
  * Must be called with the its_lock mutex held.
@@ -401,7 +404,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 	 * DevBits low - as least for the time being.
 	 */
 	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
-	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
+	reg |= GIC_ENCODE_SZ(VITS_TYPER_IDBITS, 5) << GITS_TYPER_IDBITS_SHIFT;
 	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
 
 	return extract_bytes(reg, addr & 7, len);
@@ -569,6 +572,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 
 #define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
 #define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
+#define its_cmd_get_size(cmd)		(its_cmd_mask_field(cmd, 1,  0,  5) + 1)
 #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
 #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
 #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
@@ -759,6 +763,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return E_ITS_MAPTI_ID_OOR;
+
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
@@ -839,11 +846,15 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	bool valid = its_cmd_get_validbit(its_cmd);
+	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	struct its_device *device;
 
 	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
 		return E_ITS_MAPD_DEVICE_OOR;
 
+	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
+		return E_ITS_MAPD_ITTSIZE_OOR;
+
 	device = find_its_device(its, device_id);
 
 	/*
@@ -866,6 +877,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 		return -ENOMEM;
 
 	device->device_id = device_id;
+	device->num_eventid_bits = num_eventid_bits;
+
 	INIT_LIST_HEAD(&device->itt_head);
 
 	list_add_tail(&device->dev_list, &its->device_list);
-- 
2.5.5
