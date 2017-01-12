From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 08/13] KVM: arm64: ITS: On MAPD interpret and store itt_addr and
 size
Date: Thu, 12 Jan 2017 16:56:48 +0100
Message-ID: <1484236613-24633-9-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EF8C40419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rn9YZaawDMWT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A1140670
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:44 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Up to now the ITT_addr and size fields of the MAPD command were
ignored. We will need them to handle save/restore. Let's record
the reconstructed number of eventid bits, the ITT base gpa and
the size in bytes in the its device struct.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 358ae38..32429fd 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -103,6 +103,9 @@ struct its_device {
 
 	/* the head for the list of ITTEs */
 	struct list_head itt_head;
+	gpa_t itt_addr;
+	size_t itt_size;
+	u32 nb_eventid_bits;
 	u32 device_id;
 };
 
@@ -562,6 +565,8 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
+#define its_cmd_get_ittaddr(cmd)	its_cmd_mask_field(cmd, 2, 8,  44)
+#define its_cmd_get_size(cmd)		its_cmd_mask_field(cmd, 1, 0,  5)
 
 /*
  * The DISCARD command frees an Interrupt Translation Table Entry (ITTE).
@@ -827,6 +832,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	bool valid = its_cmd_get_validbit(its_cmd);
+	size_t size = its_cmd_get_size(its_cmd);
+	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
 	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
@@ -854,6 +861,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 		return -ENOMEM;
 
 	device->device_id = device_id;
+	device->itt_addr = itt_addr << 8;
+	device->nb_eventid_bits = size + 1;
+	device->itt_size = ((2 << (size + 1)) - 1) * 16;
 	INIT_LIST_HEAD(&device->itt_head);
 
 	list_add_tail(&device->dev_list, &its->device_list);
-- 
2.5.5
