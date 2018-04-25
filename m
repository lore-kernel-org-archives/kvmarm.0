From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/3] KVM: arm/arm64: vgic: fix possible spectre-v1 in
 vgic_get_irq()
Date: Wed, 25 Apr 2018 17:13:41 +0100
Message-ID: <20180425161342.38133-3-mark.rutland@arm.com>
References: <20180425161342.38133-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 828B949FD1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 12:04:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QA7o+p5MiIMW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 12:04:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 065D949FDF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 12:04:35 -0400 (EDT)
In-Reply-To: <20180425161342.38133-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It's possible for userspace to control intid. Sanitize intid when using
it as an array index.

At the same time, sort the includes when adding <linux/nospec.h>.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 virt/kvm/arm/vgic/vgic.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e74baec76361..bd125563b15b 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -14,11 +14,13 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/list_sort.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
+#include <linux/nospec.h>
+
 #include <asm/kvm_hyp.h>
 
 #include "vgic.h"
@@ -101,12 +103,16 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid)
 {
 	/* SGIs and PPIs */
-	if (intid <= VGIC_MAX_PRIVATE)
+	if (intid <= VGIC_MAX_PRIVATE) {
+		intid = array_index_nospec(intid, VGIC_MAX_PRIVATE);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
+	}
 
 	/* SPIs */
-	if (intid <= VGIC_MAX_SPI)
+	if (intid <= VGIC_MAX_SPI) {
+		intid = array_index_nospec(intid, VGIC_MAX_SPI);
 		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	}
 
 	/* LPIs */
 	if (intid >= VGIC_MIN_LPI)
-- 
2.11.0
