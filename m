From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v2 3/6] KVM: arm/arm64: vgic: GICv2 IGROUPR should read as zero
Date: Wed,  4 Jul 2018 11:38:17 +0200
Message-ID: <1530697100-22419-4-git-send-email-christoffer.dall@arm.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

We currently don't support grouping in the emulated VGIC, which is a
known defect on KVM (not hurting any currently used guests as far as
we're aware). This is currently handled by treating all interrupts as
group 0 interrupts for an emulated GICv2 and always signaling interrupts
as group 0 to the virtual CPU interface.

However, when reading which group interrupts belongs to in the guest
from the emulated VGIC, the VGIC currently reports group 1 instead of
group 0, which is misleading.  Fix this temporarily before introducing
full group support by changing the hander to _raz instead of _rao.

Fixes: fb848db39661a "KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework"
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c    | 2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8b6fc45..230c922 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -298,7 +298,7 @@ int vgic_init(struct kvm *kvm)

        vgic_debug_init(kvm);

-       dist->implementation_rev = 0;
+       dist->implementation_rev = 1;
        dist->initialized = true;

 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index f0c5351..db646f1 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -22,6 +22,12 @@
 #include "vgic.h"
 #include "vgic-mmio.h"

+/*
+ * The Revision field in the IIDR have the following meanings:
+ *
+ * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
+ */
+
 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
                                            gpa_t addr, unsigned int len)
 {
@@ -365,7 +371,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
                vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
-               vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
+               vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
                vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
