From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 48/55] KVM: arm64: vgic-its: Fix misleading nr_entries in
 vgic_its_check_device_id
Date: Fri, 22 Jul 2016 18:29:05 +0100
Message-ID: <1469208552-4155-49-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A884C49B50
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ChoVGi3o5MJ2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5AEC49BD4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:05 -0400 (EDT)
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
2.8.1
