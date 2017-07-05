From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [PATCH 2/4] kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors for
 GICv3
Date: Wed, 5 Jul 2017 19:23:27 +0800
Message-ID: <1499253809-17584-3-git-send-email-wanghaibin.wang@huawei.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C040640D85
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gB1AcjNowuOs for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 07:23:54 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D181E40D59
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 07:23:53 -0400 (EDT)
In-Reply-To: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
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

Compared to GICv2 hardware, GICv3 support ICH_AP[01]Rn for Group [01]
interrupts.

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 20 ++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 030248e..361da71 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -156,6 +156,26 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
 }
 
+void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (apr)
+		cpu_if->vgic_ap1r[idx] = val;
+	else
+		cpu_if->vgic_ap0r[idx] = val;
+}
+
+u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	if (apr)
+		return cpu_if->vgic_ap1r[idx];
+	else
+		return cpu_if->vgic_ap0r[idx];
+}
+
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 8791b9a..91d66ec 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -181,6 +181,8 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val);
+u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-- 
1.8.3.1
