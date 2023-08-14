Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B0CC120
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 14:06:54 +0000 (UTC)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RPbjR1MM7zFqVF;
	Mon, 14 Aug 2023 22:03:55 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 14 Aug
 2023 22:06:50 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <gshan@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] KVM: arm64: Remove unused declarations
Date: Mon, 14 Aug 2023 22:06:36 +0800
Message-ID: <20230814140636.45988-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected

Commit 53692908b0f5 ("KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI")
removed vgic_v2_set_npie()/vgic_v3_set_npie() but not the declarations.
Commit 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early") left behind
kvm_arm_vcpu_ptrauth_trap(), remove it.
Commit 2a0c343386ae ("KVM: arm64: Initialize trap registers for protected VMs")
declared but never implemented kvm_init_protected_traps() and
commit cf5d318865e2 ("arm/arm64: KVM: Turn off vcpus on PSCI shutdown/reboot")
declared but never implemented force_vm_exit().

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ------
 arch/arm64/kvm/vgic/vgic.h        | 2 --
 2 files changed, 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d7b1403a3fb2..7dbcee57f565 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -967,8 +967,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 #define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
 #endif /* __KVM_NVHE_HYPERVISOR__ */
 
-void force_vm_exit(const cpumask_t *mask);
-
 int handle_exit(struct kvm_vcpu *vcpu, int exception_index);
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index);
 
@@ -1049,8 +1047,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 	return cpus_have_const_cap(ARM64_SPECTRE_V3A);
 }
 
-void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
-
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
@@ -1118,8 +1114,6 @@ static inline bool kvm_vm_is_protected(struct kvm *kvm)
 	return false;
 }
 
-void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
-
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f9923beedd27..0ab09b0d4440 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -199,7 +199,6 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
-void vgic_v2_set_npie(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
@@ -233,7 +232,6 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
-void vgic_v3_set_npie(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-- 
2.34.1

