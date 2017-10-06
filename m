From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 23/26] KVM: arm/arm64: GICv4: Prevent a VM using GICv4 from
 being saved
Date: Fri,  6 Oct 2017 16:33:58 +0100
Message-ID: <20171006153401.5481-24-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E55049D15
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hB6uHOwAuOuT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 11:34:24 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F4649C3C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:23 -0400 (EDT)
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The GICv4 architecture doesn't make it easy for save/restore to
work, as it doesn't give any guarantee that the pending state
is written into the pending table.

So let's not take any chance, and let's return an error if
we encounter any LPI that has the HW bit set.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f434748439ee..01aa4d9d405e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1987,6 +1987,15 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 	list_for_each_entry(ite, &device->itt_head, ite_list) {
 		gpa_t gpa = base + ite->event_id * ite_esz;
 
+		/*
+		 * If an LPI carries the HW bit, this means that this
+		 * interrupt is controlled by GICv4, and we do not
+		 * have direct access to that state. Let's simply fail
+		 * the save operation...
+		 */
+		if (ite->irq->hw)
+			return -EINVAL;
+
 		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
 		if (ret)
 			return ret;
-- 
2.14.1
