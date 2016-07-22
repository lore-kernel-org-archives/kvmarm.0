From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 54/55] KVM: arm64: vgic-its: Make vgic_its_cmd_handle_mapi
 similar to other handlers
Date: Fri, 22 Jul 2016 18:29:11 +0100
Message-ID: <1469208552-4155-55-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A948849BA9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2DGtNrb+o94C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D130049BD4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:17 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

vgic_its_cmd_handle_mapi has an extra "subcmd" argument, which is
already contained in the command buffer that all command handlers
obtain from the command queue. Let's drop it, as it is not that
useful.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 996e3e1..ec7e07b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -688,7 +688,7 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
  * Must be called with its_lock mutex held.
  */
 static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
-				    u64 *its_cmd, u8 subcmd)
+				    u64 *its_cmd)
 {
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
@@ -711,7 +711,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 		new_coll = collection;
 	}
 
-	if (subcmd == GITS_CMD_MAPTI)
+	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
 		lpi_nr = event_id;
@@ -999,11 +999,10 @@ static int vgic_its_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
 				   u64 *its_cmd)
 {
-	u8 cmd = its_cmd_get_command(its_cmd);
 	int ret = -ENODEV;
 
 	mutex_lock(&its->its_lock);
-	switch (cmd) {
+	switch (its_cmd_get_command(its_cmd)) {
 	case GITS_CMD_MAPD:
 		ret = vgic_its_cmd_handle_mapd(kvm, its, its_cmd);
 		break;
@@ -1011,10 +1010,10 @@ static int vgic_its_handle_command(struct kvm *kvm, struct vgic_its *its,
 		ret = vgic_its_cmd_handle_mapc(kvm, its, its_cmd);
 		break;
 	case GITS_CMD_MAPI:
-		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd, cmd);
+		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd);
 		break;
 	case GITS_CMD_MAPTI:
-		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd, cmd);
+		ret = vgic_its_cmd_handle_mapi(kvm, its, its_cmd);
 		break;
 	case GITS_CMD_MOVI:
 		ret = vgic_its_cmd_handle_movi(kvm, its, its_cmd);
-- 
2.8.1
