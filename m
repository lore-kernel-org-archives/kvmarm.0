From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/58] KVM: arm/arm64: Separate guest and uaccess writes to
 dist {sc}active
Date: Fri, 30 Jun 2017 09:44:20 +0100
Message-ID: <20170630084514.6779-5-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB954408EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:45:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KEwIv8ujZ9aN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:45:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E0240E24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:45:44 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

Factor out the core register modifier functionality from the entry
points from the register description table, and only call the
prepare/finish functions from the guest path, not the uaccess path.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 +++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  8 ++++---
 virt/kvm/arm/vgic/vgic-mmio.c    | 50 ++++++++++++++++++++++++++++++++++------
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 +++++++
 4 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 95543a20513a..8bafe9af3205 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -311,10 +311,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive,
+		NULL, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_cactive,
+		NULL, vgic_mmio_uaccess_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 99da1a207c19..23c0d56436a7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -456,11 +456,13 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive,
+		NULL, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
-		VGIC_ACCESS_32bit),
+		vgic_mmio_read_active, vgic_mmio_write_cactive,
+		NULL, vgic_mmio_uaccess_write_cactive,
+		1, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
 		8, VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 1c17b2a2f105..64cbcb4c47d0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -251,38 +251,74 @@ static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
 		kvm_arm_resume_guest(vcpu->kvm);
 }
 
-void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
-			     gpa_t addr, unsigned int len,
-			     unsigned long val)
+static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len,
+				      unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 
-	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, false);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
-	vgic_change_active_finish(vcpu, intid);
 }
 
-void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
-	int i;
 
 	vgic_change_active_prepare(vcpu, intid);
+
+	__vgic_mmio_write_cactive(vcpu, addr, len, val);
+
+	vgic_change_active_finish(vcpu, intid);
+}
+
+void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	__vgic_mmio_write_cactive(vcpu, addr, len, val);
+}
+
+static void __vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len,
+				      unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		vgic_mmio_change_active(vcpu, irq, true);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+}
+
+void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+
+	vgic_change_active_prepare(vcpu, intid);
+
+	__vgic_mmio_write_sactive(vcpu, addr, len, val);
+
 	vgic_change_active_finish(vcpu, intid);
 }
 
+void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	__vgic_mmio_write_sactive(vcpu, addr, len, val);
+}
+
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len)
 {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 27924a3d8769..5693f6df45ec 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -167,6 +167,14 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
+void vgic_mmio_uaccess_write_cactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val);
+
+void vgic_mmio_uaccess_write_sactive(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val);
+
 unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len);
 
-- 
2.11.0
