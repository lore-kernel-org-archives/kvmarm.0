From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/37] KVM: arm/arm64: vgic: Return error on incompatible
 uaccess GICD_IIDR writes
Date: Mon, 13 Aug 2018 15:57:36 +0100
Message-ID: <20180813145755.16566-19-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7064A1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6u06jVE4sFj9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91E854A22A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:47 -0400 (EDT)
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

If userspace attempts to write a GICD_IIDR that does not match the
kernel version, return an error to userspace.  The intention is to allow
implementation changes inside KVM while avoiding silently breaking
migration resulting in guests not running without any clear indication
of what went wrong.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 21 ++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 21 ++++++++++++++++++---
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index db646f140e7d..4f0f2c4165ec 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -75,6 +75,20 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len,
+					   unsigned long val)
+{
+	switch (addr & 0x0c) {
+	case GIC_DIST_IIDR:
+		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
+			return -EINVAL;
+	}
+
+	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
+	return 0;
+}
+
 static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 				 gpa_t addr, unsigned int len,
 				 unsigned long val)
@@ -367,9 +381,10 @@ static void vgic_mmio_write_apr(struct kvm_vcpu *vcpu,
 }
 
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
-		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
-		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_DIST_CTRL,
+		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc,
+		NULL, vgic_mmio_uaccess_write_v2_misc,
+		12, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ef57a1aa0b14..abdb0ec77b38 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -113,6 +113,20 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len,
+					   unsigned long val)
+{
+	switch (addr & 0x0c) {
+	case GICD_IIDR:
+		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
+			return -EINVAL;
+	}
+
+	vgic_mmio_write_v3_misc(vcpu, addr, len, val);
+	return 0;
+}
+
 static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -449,9 +463,10 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 	}
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
-		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
-		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICD_CTLR,
+		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc,
+		NULL, vgic_mmio_uaccess_write_v3_misc,
+		16, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-- 
2.18.0
