From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 55/55] KVM: arm64: vgic-its: Simplify MAPI error handling
Date: Fri, 22 Jul 2016 18:29:12 +0100
Message-ID: <1469208552-4155-56-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C2C49C0D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uKQVFGwaqhUg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFAA49B72
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:19 -0400 (EDT)
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

If we care to move all the checks that do not involve any memory
allocation, we can simplify the MAPI error handling. Let's do that,
it cannot hurt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index ec7e07b..07411cf 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -697,36 +697,34 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
-	int ret;
 
 	device = find_its_device(its, device_id);
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
 
-	collection = find_collection(its, coll_id);
-	if (!collection) {
-		ret = vgic_its_alloc_collection(its, &collection, coll_id);
-		if (ret)
-			return ret;
-		new_coll = collection;
-	}
-
 	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
 		lpi_nr = its_cmd_get_physical_id(its_cmd);
 	else
 		lpi_nr = event_id;
 	if (lpi_nr < GIC_LPI_OFFSET ||
-	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser)) {
-		ret = E_ITS_MAPTI_PHYSICALID_OOR;
-		goto err;
+	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
+		return E_ITS_MAPTI_PHYSICALID_OOR;
+
+	collection = find_collection(its, coll_id);
+	if (!collection) {
+		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
+		if (ret)
+			return ret;
+		new_coll = collection;
 	}
 
 	itte = find_itte(its, device_id, event_id);
 	if (!itte) {
 		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
 		if (!itte) {
-			ret = -ENOMEM;
-			goto err;
+			if (new_coll)
+				vgic_its_free_collection(its, coll_id);
+			return -ENOMEM;
 		}
 
 		itte->event_id	= event_id;
@@ -746,10 +744,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	update_lpi_config(kvm, itte->irq, NULL);
 
 	return 0;
-err:
-	if (new_coll)
-		vgic_its_free_collection(its, coll_id);
-	return ret;
 }
 
 /* Requires the its_lock to be held. */
-- 
2.8.1
