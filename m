From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/37] KVM: arm/arm64: vgic: GICv2 IGROUPR should read as zero
Date: Mon, 13 Aug 2018 15:57:32 +0100
Message-ID: <20180813145755.16566-15-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAD494A20C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjeD1zYV2c-Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:34 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DDC4A224
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:34 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

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
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c    | 2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8b6fc45c42fe..230c9221fe70 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -298,7 +298,7 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
-	dist->implementation_rev = 0;
+	dist->implementation_rev = 1;
 	dist->initialized = true;
 
 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index f0c5351805b6..db646f140e7d 100644
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
-		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
-- 
2.18.0
