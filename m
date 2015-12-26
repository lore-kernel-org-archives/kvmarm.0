From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v6 2/6] arm: KVM: Introduce host fp/simd context switch
 function
Date: Sat, 26 Dec 2015 13:54:56 -0800
Message-ID: <1451166900-3711-3-git-send-email-m.smarduch@samsung.com>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAEA4409A2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kFujr1Jq0QvS for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Dec 2015 16:52:29 -0500 (EST)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49080407A6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Dec 2015 16:52:29 -0500 (EST)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZZ00CQYJKH1T20@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 26 Dec 2015 16:55:29 -0500 (EST)
In-reply-to: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add fp/simd context switch function callable from host kernel mode.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/Makefile        |  2 +-
 arch/arm/kvm/fpsimd_switch.S | 47 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kvm/fpsimd_switch.S

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index c5eef02c..411b3e4 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o fpsimd_switch.o
 obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
 obj-y += $(KVM)/arm/vgic-v2-emul.o
diff --git a/arch/arm/kvm/fpsimd_switch.S b/arch/arm/kvm/fpsimd_switch.S
new file mode 100644
index 0000000..7e48c16
--- /dev/null
+++ b/arch/arm/kvm/fpsimd_switch.S
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2015 - Samsung - Open Source Group
+ * Author: Mario Smarduch <m.smarduch@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/unified.h>
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_arm.h>
+#include <asm/vfpmacros.h>
+#include "interrupts_head.S"
+
+	.text
+/**
+  * void vcpu_restore_host_vfp_state(struct vcpu *vcpu) -
+  * 	This function is called from host to save the guest, and restore host
+  *     fp/simd hardware context.
+  */
+ENTRY(vcpu_restore_host_vfp_state)
+#ifdef CONFIG_VFPv3
+	push	{r4-r7}
+
+	add	r7, r0, #VCPU_VFP_GUEST
+	store_vfp_state r7
+
+	add	r7, r0, #VCPU_VFP_HOST
+	ldr	r7, [r7]
+	restore_vfp_state r7
+
+	pop	{r4-r7}
+#endif
+	bx	lr
+ENDPROC(vcpu_restore_host_vfp_state)
-- 
1.9.1
