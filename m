From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 05/12] KVM: arm/arm64: vgic-v2: Reset LRs at boot time
Date: Mon,  7 Mar 2016 09:33:27 +0000
Message-ID: <1457343214-19547-6-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to let make the GICv2 code more lazy in the way it
accesses the LRs, it is necessary to start with a clean slate.

Let's reset the LRs on each CPU when the vgic is probed.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v2.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index ff02f08..67ec334 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -176,6 +176,15 @@ static const struct vgic_ops vgic_v2_ops = {
 
 static struct vgic_params vgic_v2_params;
 
+static void vgic_cpu_init_lrs(void *params)
+{
+	struct vgic_params *vgic = params;
+	int i;
+
+	for (i = 0; i < vgic->nr_lr; i++)
+		writel_relaxed(0, vgic->vctrl_base + GICH_LR0 + (i * 4));
+}
+
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -257,6 +266,9 @@ int vgic_v2_probe(struct device_node *vgic_node,
 
 	vgic->type = VGIC_V2;
 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
+
+	on_each_cpu(vgic_cpu_init_lrs, vgic, 1);
+
 	*ops = &vgic_v2_ops;
 	*params = vgic;
 	goto out;
-- 
2.1.4

