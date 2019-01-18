From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 07/12] arm64: [HACK] Add option to show the kernel's KVM
 register ID list
Date: Fri, 18 Jan 2019 16:14:16 +0000
Message-ID: <1547828061-20462-8-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 643934A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U9xkCHIK5Z2f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFF264A39C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:30 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

To assist with testing and debugging the behaviour of
KVM_GET_REG_LIST, this patch adds a crude option --show-reg-list to
print out the list of register IDs reported by the kernel on vcpu
startup.

This is a development hack only and not currently friendly (or
useful) for users.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 ++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm-cpu.c                             | 50 +++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..cb3f8bc 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "show-reg-list", &(cfg)->show_reg_list,	\
+		    "Show the list of KVM register IDs on startup"),	\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6a196f1..f18bfd4 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		show_reg_list;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 };
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..38a071b 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -1,6 +1,53 @@
+#include <errno.h>
+#include <stddef.h>
+#include <stdio.h>
+
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 
+static int kvm_show_reg_list(struct kvm_cpu const *vcpu)
+{
+	int ret = -1;
+	struct kvm_reg_list regs, *pregs = NULL;
+	u64 i;
+
+	regs.n = 0;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_REG_LIST, &regs) && errno != E2BIG) {
+		perror("KVM_GET_REG_LIST");
+		goto error;
+	}
+
+	pregs = malloc(((char *)&pregs->reg[0] - (char *)pregs) +
+		       regs.n * sizeof(pregs->reg[0]));
+	if (!pregs) {
+		errno = ENOMEM;
+		perror(NULL);
+		goto error;
+	}
+
+	pregs->n = regs.n;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_REG_LIST, pregs)) {
+		perror("KVM_GET_REG_LIST");
+		goto error;
+	}
+
+	fflush(stdout);
+
+	printf("Register list for cpu 0x%lx:\n", vcpu->cpu_id);
+
+	for (i = 0; i < pregs->n; ++i)
+		printf("\treg[%lu]:\t0x%.16lx\n",
+		       (unsigned long)i, (unsigned long)pregs->reg[i]);
+
+	putchar('\n');
+
+	fflush(stdout);
+
+error:
+	free(pregs);
+	return ret;
+}
+
 static int debug_fd;
 
 void kvm_cpu__set_debug_fd(int fd)
@@ -109,6 +156,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	if (kvm->cfg.arch.show_reg_list)
+		kvm_show_reg_list(vcpu);
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
-- 
2.1.4
