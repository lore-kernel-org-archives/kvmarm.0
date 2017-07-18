From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 02/38] KVM: arm/arm64: Enable nested virtualization via
 command-line
Date: Tue, 18 Jul 2017 11:58:28 -0500
Message-ID: <1500397144-16232-3-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1D249BFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e6XMy-bqxzgf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:58:50 -0400 (EDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
 [209.85.223.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8E4F40CE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:58:49 -0400 (EDT)
Received: by mail-io0-f181.google.com with SMTP id z62so17063735ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:38 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new kernel parameter(kvm-arm.nested) to enable KVM/ARM nested
virtualization support. This kernel parameter on arm architecture is
ignored since nested virtualization is not supported on arm.

Note that this kernel parameter will not have any impact until nested
virtualization support is completed. Just add this parameter first to
use it when implementing nested virtualization support.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 arch/arm/include/asm/kvm_host.h                 |  4 ++++
 arch/arm64/include/asm/kvm_host.h               |  2 ++
 arch/arm64/kvm/Makefile                         |  2 ++
 arch/arm64/kvm/nested.c                         | 26 +++++++++++++++++++++++++
 virt/kvm/arm/arm.c                              |  2 ++
 6 files changed, 40 insertions(+)
 create mode 100644 arch/arm64/kvm/nested.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index aa8341e..8fb152d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1841,6 +1841,10 @@
 			[KVM,ARM] Trap guest accesses to GICv3 common
 			system registers
 
+	kvm-arm.nested=
+			[KVM,ARM] Allow nested virtualization in KVM/ARM.
+			Default is 0 (disabled)
+
 	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 127e2dd..00b0f97 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -299,4 +299,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
+static inline int __init kvmarm_nested_cfg(char *buf)
+{
+	return 0;
+}
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c4fd1f..dcc4df8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -386,4 +386,6 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+int __init kvmarm_nested_cfg(char *buf);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5d98100..f513047 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -35,3 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-debug.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
+
+kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
new file mode 100644
index 0000000..79f38da
--- /dev/null
+++ b/arch/arm64/kvm/nested.c
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2017 - Columbia University and Linaro Ltd.
+ * Author: Jintack Lim <jintack.lim@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+static bool nested_param;
+
+int __init kvmarm_nested_cfg(char *buf)
+{
+	return strtobool(buf, &nested_param);
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e1..1c1c772 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -67,6 +67,8 @@
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 
+early_param("kvm-arm.nested", kvmarm_nested_cfg);
+
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(preemptible());
-- 
1.9.1
