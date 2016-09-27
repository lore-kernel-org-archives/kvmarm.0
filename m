From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 16/50] arm64: KVM: vgic-v2: Enable GICV access from HYP if
 access from guest is unsafe
Date: Tue, 27 Sep 2016 20:05:24 +0200
Message-ID: <20160927180558.14699-17-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82EE849B82
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o2ARUMOEaoam for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:42 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F047C49B85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:38 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id l132so26939394wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:02 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

So far, we've been disabling KVM on systems where the GICV region couldn't
be safely given to a guest. Now that we're able to handle this access
safely by emulating it in HYP, we can enable this feature when we detect
an unsafe configuration.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 69 +++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b8da901..0a063af 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -278,12 +278,14 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
-	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
-				    kvm_vgic_global_state.vcpu_base,
-				    KVM_VGIC_V2_CPU_SIZE, true);
-	if (ret) {
-		kvm_err("Unable to remap VGIC CPU to VCPU\n");
-		goto out;
+	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
+		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
+					    kvm_vgic_global_state.vcpu_base,
+					    KVM_VGIC_V2_CPU_SIZE, true);
+		if (ret) {
+			kvm_err("Unable to remap VGIC CPU to VCPU\n");
+			goto out;
+		}
 	}
 
 	dist->ready = true;
@@ -312,45 +314,51 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 		return -ENXIO;
 	}
 
-	if (!PAGE_ALIGNED(info->vcpu.start)) {
-		kvm_err("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)info->vcpu.start);
-		return -ENXIO;
-	}
+	if (!PAGE_ALIGNED(info->vcpu.start) ||
+	    !PAGE_ALIGNED(resource_size(&info->vcpu))) {
+		kvm_info("GICV region size/alignment is unsafe, using trapping (reduced performance)\n");
+		kvm_vgic_global_state.vcpu_base_va = ioremap(info->vcpu.start,
+							     resource_size(&info->vcpu));
+		if (!kvm_vgic_global_state.vcpu_base_va) {
+			kvm_err("Cannot ioremap GICV\n");
+			return -ENOMEM;
+		}
 
-	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
-		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&info->vcpu),
-			PAGE_SIZE);
-		return -ENXIO;
+		ret = create_hyp_io_mappings(kvm_vgic_global_state.vcpu_base_va,
+					     kvm_vgic_global_state.vcpu_base_va + resource_size(&info->vcpu),
+					     info->vcpu.start);
+		if (ret) {
+			kvm_err("Cannot map GICV into hyp\n");
+			goto out;
+		}
+
+		static_branch_enable(&vgic_v2_cpuif_trap);
 	}
 
 	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
 						   resource_size(&info->vctrl));
 	if (!kvm_vgic_global_state.vctrl_base) {
 		kvm_err("Cannot ioremap GICH\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	vtr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
 	kvm_vgic_global_state.nr_lr = (vtr & 0x3f) + 1;
 
-	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
-	if (ret) {
-		kvm_err("Cannot register GICv2 KVM device\n");
-		iounmap(kvm_vgic_global_state.vctrl_base);
-		return ret;
-	}
-
 	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
 				     kvm_vgic_global_state.vctrl_base +
 					 resource_size(&info->vctrl),
 				     info->vctrl.start);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
-		kvm_unregister_device_ops(KVM_DEV_TYPE_ARM_VGIC_V2);
-		iounmap(kvm_vgic_global_state.vctrl_base);
-		return ret;
+		goto out;
+	}
+
+	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (ret) {
+		kvm_err("Cannot register GICv2 KVM device\n");
+		goto out;
 	}
 
 	kvm_vgic_global_state.can_emulate_gicv2 = true;
@@ -361,4 +369,11 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
 
 	return 0;
+out:
+	if (kvm_vgic_global_state.vctrl_base)
+		iounmap(kvm_vgic_global_state.vctrl_base);
+	if (kvm_vgic_global_state.vcpu_base_va)
+		iounmap(kvm_vgic_global_state.vcpu_base_va);
+
+	return ret;
 }
-- 
2.9.0
