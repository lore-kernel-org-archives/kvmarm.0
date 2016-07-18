From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/13] KVM: arm64: vgic-its: Add pointer to corresponding
 kvm_device
Date: Mon, 18 Jul 2016 16:54:12 +0100
Message-ID: <1468857255-9543-11-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2EF48531
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6DOpHUe-28Zm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A2B849B45
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:28 -0400 (EDT)
In-Reply-To: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Going from the ITS structure to the corresponding KVM structure
would be quite handy at times. The kvm_device pointer that is
passed at create time is quite convenient for this, so let's
keep a copy of it in the vgic_its structure.

This will be put to a good use in subsequent patches.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h       | 1 +
 virt/kvm/arm/vgic/vgic-its.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4e63a07..540da51 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -138,6 +138,7 @@ struct vgic_its {
 	bool			enabled;
 	bool			initialized;
 	struct vgic_io_device	iodev;
+	struct kvm_device	*dev;
 
 	/* These registers correspond to GITS_BASER{0,1} */
 	u64			baser_device_table;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d6f68e9..dcae567 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1368,6 +1368,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	dev->kvm->arch.vgic.has_its = true;
 	its->initialized = false;
 	its->enabled = false;
+	its->dev = dev;
 
 	its->baser_device_table = INITIAL_BASER_VALUE			|
 		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT);
-- 
2.1.4
