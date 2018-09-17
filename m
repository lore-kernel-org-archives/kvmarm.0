From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 22/18] kvmtool: arm: Add support for creating VM
 with PA size
Date: Mon, 17 Sep 2018 11:41:44 +0100
Message-ID: <20180917104144.19188-23-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0FD4A1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUn6KCRkDhX7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 06:43:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6911E4A230
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:24 -0400 (EDT)
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Specify the physical size for the VM encoded in the vm type.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/include/arm-common/kvm-arch.h |  6 +++++-
 arm/kvm.c                         | 27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b29b4b1..d77f3ac 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -44,7 +44,11 @@
 
 #define KVM_IRQ_OFFSET		GIC_SPI_IRQ_BASE
 
-#define KVM_VM_TYPE		0
+extern unsigned long		kvm_arm_type;
+extern void kvm__arch_init_hyp(struct kvm *kvm);
+
+#define KVM_VM_TYPE		kvm_arm_type
+#define kvm__arch_init_hyp	kvm__arch_init_hyp
 
 #define VIRTIO_DEFAULT_TRANS(kvm)	\
 	((kvm)->cfg.arch.virtio_trans_pci ? VIRTIO_PCI : VIRTIO_MMIO)
diff --git a/arm/kvm.c b/arm/kvm.c
index eac2ad2..6c19dd0 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -11,6 +11,8 @@
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 
+unsigned long kvm_arm_type;
+
 struct kvm_ext kvm_req_ext[] = {
 	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
 	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
@@ -18,6 +20,31 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+#ifndef KVM_CAP_ARM_VM_PHYS_SHIFT
+#define KVM_CAP_ARM_VM_PHYS_SHIFT	159
+#endif
+
+void kvm__arch_init_hyp(struct kvm *kvm)
+{
+	int max_ipa;
+
+	if (!kvm->cfg.arch.phys_shift)
+		kvm->cfg.arch.phys_shift = 40;
+	if (kvm->cfg.arch.phys_shift == 40)
+		return;
+	max_ipa = ioctl(kvm->sys_fd,
+			KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_PHYS_SHIFT);
+	if (!max_ipa)
+		die("Kernel doesn't support IPA size configuration\n");
+	if ((kvm->cfg.arch.phys_shift > max_ipa) ||
+	    (kvm->cfg.arch.phys_shift < 32))
+		die("Requested PA size (%u) is not supported by the host"
+		    " [32 - %u]bit\n",
+		    kvm->cfg.arch.phys_shift, max_ipa);
+	if (kvm->cfg.arch.phys_shift < 32)
+	kvm_arm_type = kvm->cfg.arch.phys_shift;
+}
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
-- 
2.19.0
