From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 12/22] KVM: arm64: vgic-its: Interpret MAPD ITT_addr field
Date: Fri, 14 Apr 2017 12:15:24 +0200
Message-ID: <1492164934-988-13-git-send-email-eric.auger@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Up to now the MAPD ITT_addr had been ignored. We will need it
for save/restore. Let's record it in the its_device struct.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v4 -> v5:
- its_cmd_get_ittaddr macro now returns the actual ITT GPA

v3 -> v4:
- in vgic_its_cmd_handle_mapd, itt_addr directly is shifted
- correct ittaddr bitmask to support 48bit GPA
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 0f3c8f3..757598d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -106,6 +106,7 @@ struct its_device {
 	/* the head for the list of ITTEs */
 	struct list_head itt_head;
 	u32 nb_eventid_bits;
+	gpa_t itt_addr;
 	u32 device_id;
 };
 
@@ -569,6 +570,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
 #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
 #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
+#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 47) << 8)
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
 
@@ -840,6 +842,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 nb_eventid_bits = its_cmd_get_size(its_cmd);
+	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
 	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
@@ -871,6 +874,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 
 	device->device_id = device_id;
 	device->nb_eventid_bits = nb_eventid_bits;
+	device->itt_addr = itt_addr;
 
 	INIT_LIST_HEAD(&device->itt_head);
 
-- 
2.5.5
