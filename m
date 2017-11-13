From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 24/27] KVM: arm/arm64: GICv4: Enable VLPI support
Date: Mon, 13 Nov 2017 10:17:49 +0100
Message-ID: <20171113091752.10663-25-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0074A49DAC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KsjurN2uNk93 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:22 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1444949DC6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:22 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id v186so4793944wma.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:32 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

All it takes is the has_v4 flag to be set in gic_kvm_info
as well as "kvm-arm.vgic_v4_enable=1" being passed on the
command line for GICv4 to be enabled in KVM.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 virt/kvm/arm/vgic/vgic-v3.c                     | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3daa0a590236..6f897a4c8281 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1881,6 +1881,10 @@
 			[KVM,ARM] Trap guest accesses to GICv3 common
 			system registers
 
+	kvm-arm.vgic_v4_enable=
+			[KVM,ARM] Allow use of GICv4 for direct injection of
+			LPIs.
+
 	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 863351c090d8..2f05f732d3fd 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -24,6 +24,7 @@
 static bool group0_trap;
 static bool group1_trap;
 static bool common_trap;
+static bool gicv4_enable;
 
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
@@ -461,6 +462,12 @@ static int __init early_common_trap_cfg(char *buf)
 }
 early_param("kvm-arm.vgic_v3_common_trap", early_common_trap_cfg);
 
+static int __init early_gicv4_enable(char *buf)
+{
+	return strtobool(buf, &gicv4_enable);
+}
+early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -480,6 +487,13 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.can_emulate_gicv2 = false;
 	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
 
+	/* GICv4 support? */
+	if (info->has_v4) {
+		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
+		kvm_info("GICv4 support %sabled\n",
+			 gicv4_enable ? "en" : "dis");
+	}
+
 	if (!info->vcpu.start) {
 		kvm_info("GICv3: no GICV resource entry\n");
 		kvm_vgic_global_state.vcpu_base = 0;
-- 
2.14.2
