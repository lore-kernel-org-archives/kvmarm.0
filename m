From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/13] KVM: arm64: vgic-its: Fix misleading nr_entries in
 vgic_its_check_device_id
Date: Mon, 18 Jul 2016 16:54:08 +0100
Message-ID: <1468857255-9543-7-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F22AA49B59
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H4+tfpkJmBXH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 534AB49B62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:23 -0400 (EDT)
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

The nr_entries variable in vgic_its_check_device_id actually
describe the size of the L1 table, and not the number of
entries in this table.

Rename it to l1_tbl_size, so that we can now change the code
with a better understanding of what is what.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2ac5927..268a0c7 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -687,18 +687,18 @@ static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
 				     int device_id)
 {
 	u64 r = its->baser_device_table;
-	int nr_entries = GITS_BASER_NR_PAGES(r) * SZ_64K;
+	int l1_tbl_size = GITS_BASER_NR_PAGES(r) * SZ_64K;
 	int index;
 	u64 indirect_ptr;
 	gfn_t gfn;
 
 
 	if (!(r & GITS_BASER_INDIRECT))
-		return device_id < (nr_entries / GITS_BASER_ENTRY_SIZE(r));
+		return device_id < (l1_tbl_size / GITS_BASER_ENTRY_SIZE(r));
 
 	/* calculate and check the index into the 1st level */
 	index = device_id / (SZ_64K / GITS_BASER_ENTRY_SIZE(r));
-	if (index >= (nr_entries / sizeof(u64)))
+	if (index >= (l1_tbl_size / sizeof(u64)))
 		return false;
 
 	/* Each 1st level entry is represented by a 64-bit value. */
-- 
2.1.4
