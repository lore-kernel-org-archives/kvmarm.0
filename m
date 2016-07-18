From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/13] KVM: arm64: vgic-its: Fix L2 entry validation for
 indirect tables
Date: Mon, 18 Jul 2016 16:54:10 +0100
Message-ID: <1468857255-9543-9-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02C9C49B7C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3q1fboiGqYkL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF95249B1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:25 -0400 (EDT)
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

When checking that the storage address of a device entry is valid,
it is critical to compute the actual address of the entry, rather
than relying on the beginning of the page to match a CPU page of
the same size: for example, if the guest places the table at the
last 64kB boundary of RAM, but RAM size isn't a multiple of 64kB...

Fix this by computing the actual offset of the device ID in the
L2 page, and check the corresponding GFN.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4943d6a..2faf1f4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -727,7 +727,12 @@ static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
 	 * Any address beyond our supported 48 bits of PA will be caught
 	 * by the actual check in the final step.
 	 */
-	gfn = (indirect_ptr & GENMASK_ULL(51, 16)) >> PAGE_SHIFT;
+	indirect_ptr &= GENMASK_ULL(51, 16);
+
+	/* Find the address of the actual entry */
+	index = device_id % (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
+	indirect_ptr += index * GITS_BASER_ENTRY_SIZE(r);
+	gfn = indirect_ptr >> PAGE_SHIFT;
 
 	return kvm_is_visible_gfn(kvm, gfn);
 }
-- 
2.1.4
