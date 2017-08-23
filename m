From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 1/4] kvm: arm/arm64: vgic: Implement the vGICv2 GICC_APRn
 uaccess interface.
Date: Wed, 23 Aug 2017 09:05:23 +0800
Message-ID: <1503450326-10624-2-git-send-email-wanghaibin.wang@huawei.com>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B10A140D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z8vS6N+9noAn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Aug 2017 21:03:46 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFE1740C5A
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

The SPEC defined GICC_APR<n> (n = 0-3, 32-bit per register) to provide
information about interrupt active priorities for GICv2, and the user
access will traverse all of these registers no matter how many
priority levels we supported.

So we have to implement the uaccess interface cover all of these registers.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 ++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    |  9 +++++++++
 virt/kvm/arm/vgic/vgic.h         |  3 +++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 37522e6..2c1297c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -303,6 +303,23 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	vgic_set_vmcr(vcpu, &vmcr);
 }
 
+static unsigned long vgic_v2_uaccess_read_activeprio(struct kvm_vcpu *vcpu,
+						     gpa_t addr, unsigned int len)
+{
+	u32 idx = (addr & 0x0c) / sizeof(u32);
+
+	return vgic_get_apr(vcpu, idx);
+}
+
+static void vgic_v2_uaccess_write_activeprio(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len,
+					     unsigned long val)
+{
+       u32 idx = (addr & 0x0c) / sizeof(u32);
+
+       return vgic_set_apr(vcpu, idx, val);
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -363,8 +380,9 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GIC_CPU_ACTIVEPRIO,
+		vgic_mmio_read_raz, vgic_mmio_write_wi,
+		vgic_v2_uaccess_read_activeprio, vgic_v2_uaccess_write_activeprio, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index c1e4bdd..fdf9804 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -492,6 +492,15 @@ static int match_region(const void *key, const void *elt)
 		       sizeof(regions[0]), match_region);
 }
 
+void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
+{
+}
+
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
+{
+	return 0;
+}
+
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 	if (kvm_vgic_global_state.type == VGIC_V2)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index bba7fa2..c2be5b7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -209,6 +209,9 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
+
+void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val);
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx);
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
-- 
1.8.3.1
