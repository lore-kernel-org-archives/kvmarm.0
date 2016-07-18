From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/13] KVM: arm64: vgic-its: Validate the device table L1 entry
Date: Mon, 18 Jul 2016 16:54:09 +0100
Message-ID: <1468857255-9543-8-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13FB449B6F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EPEiGpC5kQ1b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A130849B63
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:24 -0400 (EDT)
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

Checking that the device_id fits if the table, and we must make
sure that the associated memory is also accessible.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 268a0c7..4943d6a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -693,8 +693,17 @@ static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
 	gfn_t gfn;
 
 
-	if (!(r & GITS_BASER_INDIRECT))
-		return device_id < (l1_tbl_size / GITS_BASER_ENTRY_SIZE(r));
+	if (!(r & GITS_BASER_INDIRECT)) {
+		phys_addr_t addr;
+
+		if (device_id >= (l1_tbl_size / GITS_BASER_ENTRY_SIZE(r)))
+			return false;
+
+		addr = BASER_ADDRESS(r) + device_id * GITS_BASER_ENTRY_SIZE(r);
+		gfn = addr >> PAGE_SHIFT;
+
+		return kvm_is_visible_gfn(kvm, gfn);
+	}
 
 	/* calculate and check the index into the 1st level */
 	index = device_id / (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
-- 
2.1.4
