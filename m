From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool hack 2/3] kvmtool: arm64: Add support for guest physical
 address size
Date: Tue,  9 Jan 2018 19:04:13 +0000
Message-ID: <20180109190414.4017-19-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ACB649DAA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y9WjHVh+wm8x for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jan 2018 14:00:56 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ACB649DA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jan 2018 14:00:56 -0500 (EST)
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add an option to specify the physical address size used by this
VM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm.c                                 | 30 ++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..c4bb207 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,7 +8,10 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
+			"Layout Randomization (KASLR)"),		\
+	OPT_UINTEGER('\0', "phys-shift", &(cfg)->phys_shift,		\
+			"Specify maximum physical address size (not "	\
+			"the amount of memory)"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6a196f1..d841b0b 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -11,6 +11,7 @@ struct kvm_config_arch {
 	bool		has_pmuv3;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
+	unsigned int	phys_shift;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
diff --git a/arm/kvm.c b/arm/kvm.c
index 2ab436e..7573391 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -18,6 +18,14 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+#ifndef KVM_CAP_ARM_CONFIG_PHYS_SHIFT
+#define KVM_CAP_ARM_CONFIG_PHYS_SHIFT	151
+#endif
+
+#ifndef KVM_ARM_SET_PHYS_SIZE
+#define KVM_ARM_SET_PHYS_SIZE		_IOW(KVMIO, 0xb2, __u32)
+#endif
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
@@ -57,8 +65,30 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
 }
 
+static void kvm__init_phys_size(struct kvm *kvm)
+{
+	if (!kvm->cfg.arch.phys_shift)
+		goto default_phys_size;
+	if (kvm->cfg.arch.phys_shift > 48)
+		die("Physical memory size is limited to 48bits, %d\n",
+			kvm->cfg.arch.phys_shift);
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_CONFIG_PHYS_SHIFT)) {
+		pr_warning("System doesn't support phys size configuration\n");
+		goto default_phys_size;
+	}
+	if (ioctl(kvm->vm_fd, KVM_ARM_SET_PHYS_SIZE, &kvm->cfg.arch.phys_shift))
+		die("Failed to set physical memory size to %dbits\n",
+			kvm->cfg.arch.phys_shift);
+	return;
+default_phys_size:
+	kvm->cfg.arch.phys_shift = 40;
+	return;
+}
+
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
+	kvm__init_phys_size(kvm);
 	/*
 	 * Allocate guest memory. We must align our buffer to 64K to
 	 * correlate with the maximum guest page size for virtio-mmio.
-- 
2.13.6
