From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 88/95] KVM: arm/arm64: vgic-v2: Reset LRs at boot time
Date: Wed,  9 Mar 2016 07:31:22 +0000
Message-ID: <1457508689-19672-89-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C89A249B6B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gsKfVIDNFb3W for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0F2C49BDD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:55 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to let make the GICv2 code more lazy in the way it
accesses the LRs, it is necessary to start with a clean slate.

Let's reset the LRs on each CPU when the vgic is probed.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
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
