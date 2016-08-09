From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 1/3] KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
Date: Tue,  9 Aug 2016 13:16:04 +0200
Message-ID: <20160809111606.28744-2-christoffer.dall@linaro.org>
References: <20160809111606.28744-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9751949B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:07:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DMmByOVieACU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 07:07:16 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A10749B4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 07:07:15 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id o80so27307314wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 04:14:22 -0700 (PDT)
In-Reply-To: <20160809111606.28744-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

During low memory conditions, we could be dereferencing a NULL pointer
when vgic_add_lpi fails to allocate memory.

Consider for example this call sequence:

  vgic_its_cmd_handle_mapi
      itte->irq = vgic_add_lpi(kvm, lpi_nr);
          update_lpi_config(kvm, itte->irq, NULL);
              ret = kvm_read_guest(kvm, propbase + irq->intid
	                                             ^^^^
						     kaboom?

Instead, return an error pointer from vgic_add_lpi and check the return
value from its single caller.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Stylistic changes
     - Use its_free_itte to free new_itte on error path

 virt/kvm/arm/vgic/vgic-its.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 07411cf..4e16880e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -51,7 +51,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
 
 	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
 	if (!irq)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
@@ -502,7 +502,8 @@ static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 	list_del(&itte->itte_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	vgic_put_irq(kvm, itte->irq);
+	if (itte->irq)
+		vgic_put_irq(kvm, itte->irq);
 
 	kfree(itte);
 }
@@ -693,10 +694,11 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	u32 device_id = its_cmd_get_deviceid(its_cmd);
 	u32 event_id = its_cmd_get_id(its_cmd);
 	u32 coll_id = its_cmd_get_collection(its_cmd);
-	struct its_itte *itte;
+	struct its_itte *itte, *new_itte = NULL;
 	struct its_device *device;
 	struct its_collection *collection, *new_coll = NULL;
 	int lpi_nr;
+	struct vgic_irq *irq;
 
 	device = find_its_device(its, device_id);
 	if (!device)
@@ -727,13 +729,24 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 			return -ENOMEM;
 		}
 
+		new_itte = itte;
 		itte->event_id	= event_id;
 		list_add_tail(&itte->itte_list, &device->itt_head);
 	}
 
 	itte->collection = collection;
 	itte->lpi = lpi_nr;
-	itte->irq = vgic_add_lpi(kvm, lpi_nr);
+
+	irq = vgic_add_lpi(kvm, lpi_nr);
+	if (IS_ERR(irq)) {
+		if (new_coll)
+			vgic_its_free_collection(its, coll_id);
+		if (new_itte)
+			its_free_itte(kvm, new_itte);
+		return PTR_ERR(irq);
+	}
+	itte->irq = irq;
+
 	update_affinity_itte(kvm, itte);
 
 	/*
-- 
2.9.0
