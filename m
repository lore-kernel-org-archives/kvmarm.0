From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/7] KVM: arm/arm64: vgic-its: Preserve the revious read from
 the pending table
Date: Thu, 16 Nov 2017 17:58:17 +0000
Message-ID: <20171116175821.26544-4-marc.zyngier@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2727E49D14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 89G1B0qHBC95 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97FAD49D5E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:19 -0500 (EST)
In-Reply-To: <20171116175821.26544-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The current pending table parsing code assumes that we keep the
previous read of the pending bits, but keep that variable in
the current block, making sure it is discarded on each loop.

We end-up using whatever is on the stack. Who knows, it might
just be the right thing...

Fixes: 33d3bc9556a7d ("KVM: arm64: vgic-its: Read initial LPI pending table")
Cc: stable@vger.kernel.org # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index a3754ec719c4..370086006838 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -421,6 +421,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	u32 *intids;
 	int nr_irqs, i;
 	unsigned long flags;
+	u8 pendmask;
 
 	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
 	if (nr_irqs < 0)
@@ -428,7 +429,6 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < nr_irqs; i++) {
 		int byte_offset, bit_nr;
-		u8 pendmask;
 
 		byte_offset = intids[i] / BITS_PER_BYTE;
 		bit_nr = intids[i] % BITS_PER_BYTE;
-- 
2.14.2
