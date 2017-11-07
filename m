From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 22/26] KVM: arm/arm64: vgic-its: Free caches when GITS_BASER
 Valid bit is cleared
Date: Tue,  7 Nov 2017 11:47:55 +0100
Message-ID: <20171107104800.30021-23-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1234D49DA3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EfJqsTh1JhRQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:55 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 504CF49D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:48 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id r68so12479224wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:43 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

When the GITS_BASER<n>.Valid gets cleared, the data structures in
guest RAM are not valid anymore. The device, collection
and LPI lists stored in the in-kernel ITS represent the same
information in some form of cache. So let's void the cache.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d46256c07ba5..1732e08a4375 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1431,7 +1431,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      unsigned long val)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	u64 entry_size, device_type;
+	u64 entry_size, table_type;
 	u64 reg, *regptr, clearbits = 0;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
@@ -1442,12 +1442,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	case 0:
 		regptr = &its->baser_device_table;
 		entry_size = abi->dte_esz;
-		device_type = GITS_BASER_TYPE_DEVICE;
+		table_type = GITS_BASER_TYPE_DEVICE;
 		break;
 	case 1:
 		regptr = &its->baser_coll_table;
 		entry_size = abi->cte_esz;
-		device_type = GITS_BASER_TYPE_COLLECTION;
+		table_type = GITS_BASER_TYPE_COLLECTION;
 		clearbits = GITS_BASER_INDIRECT;
 		break;
 	default:
@@ -1459,10 +1459,24 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	reg &= ~clearbits;
 
 	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
-	reg |= device_type << GITS_BASER_TYPE_SHIFT;
+	reg |= table_type << GITS_BASER_TYPE_SHIFT;
 	reg = vgic_sanitise_its_baser(reg);
 
 	*regptr = reg;
+
+	if (!(reg & GITS_BASER_VALID)) {
+		/* Take the its_lock to prevent a race with a save/restore */
+		mutex_lock(&its->its_lock);
+		switch (table_type) {
+		case GITS_BASER_TYPE_DEVICE:
+			vgic_its_free_device_list(kvm, its);
+			break;
+		case GITS_BASER_TYPE_COLLECTION:
+			vgic_its_free_collection_list(kvm, its);
+			break;
+		}
+		mutex_unlock(&its->its_lock);
+	}
 }
 
 static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
-- 
2.14.2
