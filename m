From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH] KVM: arm/armv4 : merge the same case handler
Date: Tue, 27 Mar 2018 01:07:17 +0800
Message-ID: <1522084037-85559-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cdall@kernel.org, marc.zyngier@arm.com
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

The two switch cases have the same handler, so merge them.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4650953..aa41b29 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1242,8 +1242,6 @@ static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
 		ret = vgic_its_cmd_handle_mapc(kvm, its, its_cmd);
 		break;
 	case GITS_CMD_MAPI:
-		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd);
-		break;
 	case GITS_CMD_MAPTI:
 		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd);
 		break;
-- 
1.8.3.1
