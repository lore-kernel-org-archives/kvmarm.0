From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 35/45] KVM: arm/arm64: vgic-new: Add userland access to
 VGIC dist registers
Date: Fri, 25 Mar 2016 02:04:58 +0000
Message-ID: <1458871508-17279-36-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 726BD411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KZ2fmRlCtECC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975E849B3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:17 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_kvm_device.c | 50 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic_kvm_device.c b/virt/kvm/arm/vgic/vgic_kvm_device.c
index d9f2383..2e2f8b6 100644
--- a/virt/kvm/arm/vgic/vgic_kvm_device.c
+++ b/virt/kvm/arm/vgic/vgic_kvm_device.c
@@ -264,7 +264,55 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u32 *reg, bool is_write)
 {
-	return -ENXIO;
+	gpa_t addr;
+	int cpuid, ret, c;
+	struct kvm_vcpu *vcpu, *tmp_vcpu;
+
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	mutex_lock(&dev->kvm->lock);
+
+	ret = vgic_init(dev->kvm);
+	if (ret)
+		goto out;
+
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Ensure that no other VCPU is running by checking the vcpu->cpu
+	 * field.  If no other VPCUs are running we can safely access the VGIC
+	 * state, because even if another VPU is run after this point, that
+	 * VCPU will not touch the vgic state, because it will block on
+	 * getting the vgic->lock in kvm_vgic_sync_hwstate().
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
+		if (unlikely(tmp_vcpu->cpu != -1)) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
+		ret = -EINVAL;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		ret = vgic_v2_dist_access(vcpu, is_write, addr, 4, reg);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
 }
 
 /* V2 ops */
-- 
2.7.3
