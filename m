From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 4/4] kvm: arm/arm64: vgic: clean up vGICv3 ICC_APRn sysreg
 uaccess
Date: Wed, 23 Aug 2017 09:05:26 +0800
Message-ID: <1503450326-10624-5-git-send-email-wanghaibin.wang@huawei.com>
References: <1503450326-10624-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D1EE49C42
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Aug 2017 21:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UQiVwFhGpo4T for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Aug 2017 21:03:46 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2262049C0C
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

It will be better that hide the underlying implementation for emulated GIC.
This patch extend the vgic_set/get_apr func (with group parameter) more general,
so that, the vGICv3 ICC_APRn sysreg uaccess can call this general interface
for GICv3 on GICv3.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 25 +++++--------------------
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 10 ++++++----
 virt/kvm/arm/vgic/vgic.h         |  4 ++--
 4 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 116786d..f0d8d36 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -188,23 +188,6 @@ static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
-static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
-				   struct sys_reg_params *p, u8 apr, u8 idx)
-{
-	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
-	uint32_t *ap_reg;
-
-	if (apr)
-		ap_reg = &vgicv3->vgic_ap1r[idx];
-	else
-		ap_reg = &vgicv3->vgic_ap0r[idx];
-
-	if (p->is_write)
-		*ap_reg = p->regval;
-	else
-		p->regval = *ap_reg;
-}
-
 static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r, u8 apr)
 {
@@ -218,19 +201,21 @@ static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 */
 	switch (vgic_v3_cpu->num_pri_bits) {
 	case 7:
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 		break;
 	case 6:
 		if (idx > 1)
 			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 		break;
 	default:
 		if (idx > 0)
 			goto err;
-		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
 	}
 
+	if (p->is_write)
+		vgic_set_apr(vcpu, apr, idx, p->regval);
+	else
+		p->regval = vgic_get_apr(vcpu, apr, idx);
+
 	return true;
 err:
 	if (!p->is_write)
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 2c1297c..373e69f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -308,7 +308,7 @@ static unsigned long vgic_v2_uaccess_read_activeprio(struct kvm_vcpu *vcpu,
 {
 	u32 idx = (addr & 0x0c) / sizeof(u32);
 
-	return vgic_get_apr(vcpu, idx);
+	return vgic_get_apr(vcpu, 0, idx);
 }
 
 static void vgic_v2_uaccess_write_activeprio(struct kvm_vcpu *vcpu,
@@ -317,7 +317,7 @@ static void vgic_v2_uaccess_write_activeprio(struct kvm_vcpu *vcpu,
 {
        u32 idx = (addr & 0x0c) / sizeof(u32);
 
-       return vgic_set_apr(vcpu, idx, val);
+       return vgic_set_apr(vcpu, 0, idx, val);
 }
 
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 738d800..2cc64e4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -492,7 +492,7 @@ static int match_region(const void *key, const void *elt)
 		       sizeof(regions[0]), match_region);
 }
 
-void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
+void vgic_set_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx, u32 val)
 {
 	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
 
@@ -501,10 +501,12 @@ void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
 	} else {
 		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
 			vgic_v3_set_apr(vcpu, 1, idx, val);
+		else
+			vgic_v3_set_apr(vcpu, group, idx, val);
 	}
 }
 
-u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx)
 {
 	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
 
@@ -513,9 +515,9 @@ u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
 	} else {
 		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
 			return vgic_v3_get_apr(vcpu, 1, idx);
+		else
+			return vgic_v3_get_apr(vcpu, group, idx);
 	}
-
-	return 0;
 }
 
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 19b0f8b..eb1cd73 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -214,8 +214,8 @@ int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u64 *val);
 int kvm_register_vgic_device(unsigned long type);
 
-void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val);
-u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx);
+void vgic_set_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx, u32 val);
+u32 vgic_get_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx);
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_lazy_init(struct kvm *kvm);
-- 
1.8.3.1
