Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794562727;
	b=ba61NWR5gOxUzcwZcI2QULqDbXV327EzcuY73Y47ZcwOxHxU4qe6j5k1ux2mu6/Gbgq0
	 ptxtfsuv/LvpzF3qMR3+ebLCib8zj5ipFtJqGCpT8DiyK5XgPLJsCisRuc1Ksv//ccq8C
	 AN6hUr8/nhmupxM5lryDMLwVUJEDIgJKfT5G3Nx1h3Bz+0Ay7sf0FJwH3SscGdWHoheSr
	 DUpP94SvpTPZViQJyXFfxi73u19WjcNKIPCQAe5pU2unR7XUH1qoCvQizphRT3/UQH1J+
	 i4IwNL63NE7p2ZqjXMso+cyh92Uc3430U5myW9dQ6sM3Q0ftOBfDQ5qcjk5/riGysKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794562727;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=lIuV6FUuCmbku+6c3MP0BacKv5OXTGUjdv/prBUucwQ=;
	b=QE+45dtA6vja87A7FXU3w/Ws59SmbY6z0FOJwajxSHOM2rytZcVsGzBcd367H3laiDVe
	 YiBrO20sAV2skcdmLSQU5xpe1WHZvBZde+6VokcQtbAPJrd1NeQeiSiy7PJeJtDnGiesC
	 frEd03WPUAWJWZEp+7teMNhFYo+Rax74uzI8agWBb0OY+CeVTc7CDvphuHq4xcg/gIQ0p
	 6XUCvZI3THjvHS2gHAEI9/LaUVJgyg6UjDZdZF29J3UOaj8ifPo3GUp9ie7jt4jOKJWM1
	 yYPatN2Ew/xqzmLZ1DPNHUlclROrHHVJwI6eHN8hIBtBPRRgzlYQPupUm0Kprr+Opvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="S/aXOX9r";
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FD5606A889
	for <kvmarm@lists.linux.dev>; Fri, 13 Nov 2026 09:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2FD5606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=S/aXOX9r
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lIuV6FUuCmbku+6c3MP0BacKv5OXTGUjdv/prBUucwQ=;
	b=S/aXOX9r9n9WEKK0m+2dsd4BkY5a453lC7zFvvCFk6fU7g/tug8D05gyvGxBq0vGKDEYPwpEg
	CjxCEk2WXr4RQILCWUCtd2cRdIiAkyPn6Vrin93dYMc4Kt+LKoMesVQmN/O1Eet9MONTgOlBgtF
	mQYJ3N3z57lsE/IlFn/QxHg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jQsdg3pqFz12LJw;
	Fri, 13 Nov 2026 17:38:47 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 7241640561;
	Fri, 13 Nov 2026 17:38:41 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemk300013.china.huawei.com
 (7.202.194.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 13 Nov
 2026 17:38:40 +0800
From: Jinqian Yang <yangjinqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>
CC: <maz@kernel.org>, <oupton@kernel.org>, <fuad.tabba@linux.dev>,
	<yuzenghui@huawei.com>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yangjinqian1@huawei.com>,
	<liuyonglong@huawei.com>, <wangzhou1@hisilicon.com>,
	<prime.zeng@hisilicon.com>, <tangchengchang@huawei.com>,
	<zhengtian10@huawei.com>, <linuxarm@huawei.com>, <liujian222@huawei.com>
Subject: [PATCH v2] KVM: arm64: Register irq_bypass consumers only when direct MSIs are possible
Date: Fri, 13 Nov 2026 17:38:40 +0800
Message-ID: <20261113093840.1034795-1-yangjinqian1@huawei.com>
X-Mailer: git-send-email 2.33.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300013.china.huawei.com (7.202.194.231)

kvm_arch_has_irq_bypass() on arm64 returns true unconditionally, so
every irqfd assignment registers an irq_bypass consumer even when KVM
cannot do direct MSI forwarding for the VM. In that case
kvm_vgic_v4_set_forwarding() bails out at its very first check, since
vgic_supports_direct_msis() is false, and the registration becomes pure
overhead: every KVM_IRQFD ioctl takes the global irq_bypass mutex, which
becomes a contention point when many VMs boot concurrently.

Pass struct kvm to kvm_arch_has_irq_bypass() and gate the registration
on vgic_supports_direct_msis(kvm), like x86 gates on
enable_device_posted_irqs. Reading the per-VM vgic state is safe here,
as kvm_irqfd_assign() requires an initialized irqchip.

Functionally this is a no-op: without direct MSI support the consumer
registration never did anything beyond acquiring the lock. On a
GICv3-only host booting 100 microVMs concurrently this cuts the average
boot time by ~5 ms, matching the gain observed with
CONFIG_HAVE_KVM_IRQ_BYPASS=n.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
---
v1 -> v2:
 - Gate on vgic_supports_direct_msis(kvm) instead of the global
   kvm_vgic_global_state.has_gicv4 flag, This requires passing struct
   kvm to kvm_arch_has_irq_bypass() and updating the x86 and PPC callers.

v1: https://lore.kernel.org/linux-arm-kernel/20261109112018.241298-1-yangjinqian1@huawei.com/

 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/vgic/vgic.h        | 1 -
 arch/powerpc/kvm/powerpc.c        | 2 +-
 arch/x86/include/asm/kvm_host.h   | 2 +-
 arch/x86/kvm/irq.c                | 2 +-
 arch/x86/kvm/vmx/posted_intr.c    | 2 +-
 include/kvm/arm_vgic.h            | 1 +
 include/linux/kvm_host.h          | 2 +-
 virt/kvm/eventfd.c                | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb130..da86646b6709 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1742,9 +1742,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_sctlr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
 
-static inline bool kvm_arch_has_irq_bypass(void)
+static inline bool kvm_arch_has_irq_bypass(struct kvm *kvm)
 {
-	return true;
+	return vgic_supports_direct_msis(kvm);
 }
 
 void kvm_idregs_enforce_dependencies(struct kvm *kvm);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 97fc3bdf520e..3c128e4d9afa 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -521,7 +521,6 @@ static inline bool vgic_host_has_gicv5(void)
 }
 
 bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
 bool vgic_supports_direct_sgis(struct kvm *kvm);
 
 static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 9194cf492d1c..74c0d457f4ca 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -875,7 +875,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
  * irq_bypass_stop and irq_bypass_start are not needed and so
  * kvm_ops are not defined for them.
  */
-bool kvm_arch_has_irq_bypass(void)
+bool kvm_arch_has_irq_bypass(struct kvm *kvm)
 {
 	return ((kvmppc_hv_ops && kvmppc_hv_ops->irq_bypass_add_producer) ||
 		(kvmppc_pr_ops && kvmppc_pr_ops->irq_bypass_add_producer));
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ee4b127004d..8b6f5b72fea5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1919,7 +1919,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	kvm_x86_call(vcpu_unblocking)(vcpu);
 }
 
-static inline bool kvm_arch_has_irq_bypass(void)
+static inline bool kvm_arch_has_irq_bypass(struct kvm *kvm)
 {
 	return enable_device_posted_irqs;
 }
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 871977288272..81eeecc614ef 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -439,7 +439,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 	struct kvm_lapic_irq irq;
 	int r;
 
-	if (WARN_ON_ONCE(!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass()))
+	if (WARN_ON_ONCE(!irqchip_in_kernel(kvm) || !kvm_arch_has_irq_bypass(kvm)))
 		return -EINVAL;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 2644add54b76..15d7a97fd7f6 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -153,7 +153,7 @@ static bool vt_can_use_vtd_pi(struct kvm *kvm)
 	 * bypass IRQ being attached to the VM.  vt_pi_start_bypass() ensures
 	 * blockng vCPUs will see an elevated count or get KVM_REQ_UNBLOCK.
 	 */
-	return irqchip_in_kernel(kvm) && kvm_arch_has_irq_bypass() &&
+	return irqchip_in_kernel(kvm) && kvm_arch_has_irq_bypass(kvm) &&
 	       READ_ONCE(kvm->arch.nr_possible_bypass_irqs);
 }
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4b2c41917b77..39c69d861060 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -215,6 +215,7 @@ struct vgic_global {
 };
 
 extern struct vgic_global kvm_vgic_global_state;
+bool vgic_supports_direct_msis(struct kvm *kvm);
 
 #define VGIC_V2_MAX_LRS		(1 << 6)
 #define VGIC_V3_MAX_LRS		16
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..bdf002a62686 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2458,7 +2458,7 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
 struct kvm_kernel_irqfd;
 
-bool kvm_arch_has_irq_bypass(void);
+bool kvm_arch_has_irq_bypass(struct kvm *kvm);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
 			   struct irq_bypass_producer *);
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f43b8b25bc85..07a7c8fc3bbe 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -488,7 +488,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		schedule_work(&irqfd->inject);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-	if (kvm_arch_has_irq_bypass()) {
+	if (kvm_arch_has_irq_bypass(kvm)) {
 		irqfd->consumer.add_producer = kvm_arch_irq_bypass_add_producer;
 		irqfd->consumer.del_producer = kvm_arch_irq_bypass_del_producer;
 		irqfd->consumer.stop = kvm_arch_irq_bypass_stop;
-- 
2.33.0

