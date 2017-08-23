From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 2/4] kvm: arm/arm64: vgic-v2: Add GICH_APRn accessors for
 GICv2
Date: Wed, 23 Aug 2017 09:05:24 +0800
Message-ID: <1503450326-10624-3-git-send-email-wanghaibin.wang@huawei.com>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDA449C3F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NdRUHrLUGAJv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Aug 2017 21:03:46 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2007B40D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:45 -0400 (EDT)
In-Reply-To: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cdall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch is used for GICv2 on GICv2.

About GICV_APRn hardware register access,the SPEC says:
When System register access is disabled for EL2, these registers access
GICH_APRn, and all active priorities for virtual machines are held in
GICH_APRn regardless of interrupt group.

For GICv2 hardware, there are at most 5 priority bits are implemented in
GICH_LRn.Priority, so we only need to be concerned with GICH_APR0.
The other GICH_APRn (n = 1-3) access should be treated as raz/wi.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c |  5 +++++
 virt/kvm/arm/vgic/vgic-v2.c   | 18 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index fdf9804..80261b7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -494,10 +494,15 @@ static int match_region(const void *key, const void *elt)
 
 void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
 {
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_apr(vcpu, idx, val);
 }
 
 u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
 {
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		return vgic_v2_get_apr(vcpu, idx);
+
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index e4187e5..65daf35 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -172,6 +172,24 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
 }
 
+void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	if (idx == 0)
+		cpu_if->vgic_apr = val;
+}
+
+u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	if (idx == 0)
+		return cpu_if->vgic_apr;
+	else
+		return 0;
+}
+
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c2be5b7..441ded7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -155,6 +155,8 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
 int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val);
+void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val);
+u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
-- 
1.8.3.1
