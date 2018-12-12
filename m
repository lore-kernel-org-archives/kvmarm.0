From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] KVM: arm/arm64: vgic: fix off-by-one bug in vgic_get_irq()
Date: Wed, 12 Dec 2018 14:11:23 -0600
Message-ID: <20181212201123.GA26674@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When using the nospec API, it should be taken into account that:

"...if the CPU speculates past the bounds check then
 * array_index_nospec() will clamp the index within the range of [0,
 * size)."

The above is part of the header for macro array_index_nospec() in
linux/nospec.h

Now, in this particular case, if intid evaluates to exactly VGIC_MAX_SPI
or to exaclty VGIC_MAX_PRIVATE, the array_index_nospec() macro ends up
returning VGIC_MAX_SPI - 1 or VGIC_MAX_PRIVATE - 1 respectively, instead
of VGIC_MAX_SPI or VGIC_MAX_PRIVATE, which, based on the original logic:

	/* SGIs and PPIs */
	if (intid <= VGIC_MAX_PRIVATE)
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];

 	/* SPIs */
	if (intid <= VGIC_MAX_SPI)
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];

are valid values for intid.

Fix this by calling array_index_nospec() macro with VGIC_MAX_PRIVATE + 1
and VGIC_MAX_SPI + 1 as arguments for its parameter size.

Fixes: 41b87599c743 ("KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_get_irq()")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 virt/kvm/arm/vgic/vgic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 50e25438fb3c..5db40696055a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -103,13 +103,13 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 {
 	/* SGIs and PPIs */
 	if (intid <= VGIC_MAX_PRIVATE) {
-		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE);
+		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE + 1);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
 	}
 
 	/* SPIs */
 	if (intid <= VGIC_MAX_SPI) {
-		intid = array_index_nospec(intid, VGIC_MAX_SPI);
+		intid = array_index_nospec(intid, VGIC_MAX_SPI + 1);
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
 	}
 
-- 
2.17.1
