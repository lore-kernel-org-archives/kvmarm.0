From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 14/37] KVM: arm64: vgic-its: Interpret MAPD ITT_addr field
Date: Tue,  9 May 2017 12:44:43 +0200
Message-ID: <20170509104506.30929-15-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5AD40CE0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MRg+frFjDEG9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:14 -0400 (EDT)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com
 [209.85.220.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 881DB40B3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:11 -0400 (EDT)
Received: by mail-qk0-f176.google.com with SMTP id k74so75279937qke.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:26 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

Up to now the MAPD ITT_addr had been ignored. We will need it
for save/restore. Let's record it in the its_device struct.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 031f6ab..7b95b73 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -104,6 +104,7 @@ struct its_device {
 	/* the head for the list of ITTEs */
 	struct list_head itt_head;
 	u32 num_eventid_bits;
+	gpa_t itt_addr;
 	u32 device_id;
 };
 
@@ -602,6 +603,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
 #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
 #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
 #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
+#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 44) << 8)
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
 
@@ -873,6 +875,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
+	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
 
 	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
@@ -904,6 +907,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 
 	device->device_id = device_id;
 	device->num_eventid_bits = num_eventid_bits;
+	device->itt_addr = itt_addr;
 
 	INIT_LIST_HEAD(&device->itt_head);
 
-- 
2.9.0
