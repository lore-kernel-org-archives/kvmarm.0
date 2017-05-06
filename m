From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 11/24] KVM: arm64: vgic-its: Interpret MAPD Size field and
 check related errors
Date: Sat,  6 May 2017 17:24:30 +0200
Message-ID: <1494084283-12723-12-git-send-email-eric.auger@redhat.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 643E940BD8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 May 2017 11:22:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jr47DTO9Osws for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 May 2017 11:22:38 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5711A40187
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 May 2017 11:22:38 -0400 (EDT)
In-Reply-To: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Up to now the MAPD's ITT size field has been ignored. It encodes
the number of eventid bit minus 1. It should be used to check
the eventid when a MAPTI command is issued on a device. Let's
store the number of eventid bits in the its_device and do the
check on MAPTI. Also make sure the ITT size field does
not exceed the GITS_TYPER IDBITS field.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

---
v6 -> v7:
- added Marc's R-b

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
index 2eaea30..be8bad0 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -347,9 +347,11 @@
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
index 9338efb..031f6ab 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -103,6 +103,7 @@ struct its_device {
 
 	/* the head for the list of ITTEs */
 	struct list_head itt_head;
+	u32 num_eventid_bits;
 	u32 device_id;
 };
 
@@ -224,6 +225,8 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
 
 #define GIC_LPI_OFFSET 8192
 
+#define VITS_TYPER_IDBITS 16
+
 /*
  * Finds and returns a collection in the ITS collection table.
  * Must be called with the its_lock mutex held.
@@ -424,7 +427,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 	 * DevBits low - as least for the time being.
 	 */
 	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
-	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
+	reg |= GIC_ENCODE_SZ(VITS_TYPER_IDBITS, 5) << GITS_TYPER_IDBITS_SHIFT;
 	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
 
 	return extract_bytes(reg, addr & 7, len);
@@ -595,6 +598,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 
 #define its_cmd_get_command(cmd)	its_cmd_mask_field(cmd, 0,  0,  8)
 #define its_cmd_get_deviceid(cmd)	its_cmd_mask_field(cmd, 0, 32, 32)
+#define its_cmd_get_size(cmd)		(its_cmd_mask_field(cmd, 1,  0,  5) + 1)
 #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
 #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
 #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
@@ -785,6 +789,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
+	if (event_id >= BIT_ULL(device->num_eventid_bits))
+		return E_ITS_MAPTI_ID_OOR;
+
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
@@ -865,11 +872,15 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
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
@@ -892,6 +903,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 		return -ENOMEM;
 
 	device->device_id = device_id;
+	device->num_eventid_bits = num_eventid_bits;
+
 	INIT_LIST_HEAD(&device->itt_head);
 
 	list_add_tail(&device->dev_list, &its->device_list);
-- 
2.5.5
