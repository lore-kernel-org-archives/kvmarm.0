From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 50/58] KVM: arm64: Enable GICv3 common sysreg trapping via
 command-line
Date: Fri, 30 Jun 2017 09:45:06 +0100
Message-ID: <20170630084514.6779-51-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD3F40D38
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQzBcr-aoh3d for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D289840DB8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:39 -0400 (EDT)
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

Now that we're able to safely handle common sysreg access, let's
give the user the opportunity to enable it by passing a specific
command-line option (vgic_v3.common_trap).

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 include/linux/irqchip/arm-gic-v3.h              |  1 +
 virt/kvm/arm/vgic/vgic-v3.c                     | 11 ++++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 88bdc421351f..aa8341e73b35 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1837,6 +1837,10 @@
 			[KVM,ARM] Trap guest accesses to GICv3 group-1
 			system registers
 
+	kvm-arm.vgic_v3_common_trap=
+			[KVM,ARM] Trap guest accesses to GICv3 common
+			system registers
+
 	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c7f31a962cfc..6a1f87ff94e2 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -417,6 +417,7 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_TC			(1 << 10)
 #define ICH_HCR_TALL0			(1 << 11)
 #define ICH_HCR_TALL1			(1 << 12)
 #define ICH_HCR_EOIcount_SHIFT		27
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 35c00efc110b..91cf8b4f01f1 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -23,6 +23,7 @@
 
 static bool group0_trap;
 static bool group1_trap;
+static bool common_trap;
 
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
@@ -265,6 +266,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
 	if (group1_trap)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
+	if (common_trap)
+		vgic_v3->vgic_hcr |= ICH_HCR_TC;
 }
 
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
@@ -450,6 +453,12 @@ static int __init early_group1_trap_cfg(char *buf)
 }
 early_param("kvm-arm.vgic_v3_group1_trap", early_group1_trap_cfg);
 
+static int __init early_common_trap_cfg(char *buf)
+{
+	return strtobool(buf, &common_trap);
+}
+early_param("kvm-arm.vgic_v3_common_trap", early_common_trap_cfg);
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -508,7 +517,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	}
 #endif
 
-	if (group0_trap || group1_trap) {
+	if (group0_trap || group1_trap || common_trap) {
 		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
 		static_branch_enable(&vgic_v3_cpuif_trap);
 	}
-- 
2.11.0
