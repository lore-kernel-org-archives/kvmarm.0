From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Mon, 28 Nov 2016 11:46:10 -0500
Message-ID: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F255C405B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:45:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9X8GJHw6i536 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 11:45:35 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13BC440537
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:45:34 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGk5EP010714
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:46:22 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 85EC583
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:46:22 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 6323285
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:46:22 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uASGkMd0057247
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:46:22 -0500
Received: by mail-qk0-f198.google.com with SMTP id q128so114877458qkd.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 08:46:22 -0800 (PST)
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
are 11th and 10th bits respectively when E2H is set.  Current code is
unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set, which
may allow guest OS to access physical timer. So, fix it.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_timer.h     | 33 +++++++++++++++++++
 arch/arm64/include/asm/kvm_timer.h   | 62 ++++++++++++++++++++++++++++++++++++
 include/clocksource/arm_arch_timer.h |  6 ++--
 virt/kvm/arm/hyp/timer-sr.c          |  8 ++---
 4 files changed, 103 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_timer.h
 create mode 100644 arch/arm64/include/asm/kvm_timer.h

diff --git a/arch/arm/include/asm/kvm_timer.h b/arch/arm/include/asm/kvm_timer.h
new file mode 100644
index 0000000..d19d4b3
--- /dev/null
+++ b/arch/arm/include/asm/kvm_timer.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2016 - Columbia University
+ * Author: Jintack Lim <jintack@cs.columbia.edu>
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
+#ifndef __ARM_KVM_TIMER_H__
+#define __ARM_KVM_TIMER_H__
+
+#include <clocksource/arm_arch_timer.h>
+
+static inline u32 __hyp_text get_el1pcten(void)
+{
+	return CNTHCTL_EL1PCTEN_NVHE;
+}
+
+static inline u32 __hyp_text get_el1pcen(void)
+{
+	return CNTHCTL_EL1PCEN_NVHE;
+}
+
+#endif	/* __ARM_KVM_TIMER_H__ */
diff --git a/arch/arm64/include/asm/kvm_timer.h b/arch/arm64/include/asm/kvm_timer.h
new file mode 100644
index 0000000..153f3da
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_timer.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2016 - Columbia University
+ * Author: Jintack Lim <jintack@cs.columbia.edu>
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
+#ifndef __ARM64_KVM_TIMER_H__
+#define __ARM64_KVM_TIMER_H__
+
+#include <asm/kvm_hyp.h>
+#include <clocksource/arm_arch_timer.h>
+
+static inline u32 __hyp_text get_el1pcten_vhe(void)
+{
+	return CNTHCTL_EL1PCTEN_VHE;
+}
+
+static inline u32 __hyp_text get_el1pcten_nvhe(void)
+{
+	return CNTHCTL_EL1PCTEN_NVHE;
+}
+
+static hyp_alternate_select(get_el1pcten_arch,
+			    get_el1pcten_nvhe, get_el1pcten_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static inline u32 __hyp_text get_el1pten_vhe(void)
+{
+	return CNTHCTL_EL1PTEN_VHE;
+}
+
+static inline u32 __hyp_text get_el1pcen_nvhe(void)
+{
+	return CNTHCTL_EL1PCEN_NVHE;
+}
+
+static hyp_alternate_select(get_el1pcen_arch,
+			    get_el1pcen_nvhe, get_el1pten_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static inline u32 __hyp_text get_el1pcten(void)
+{
+	return get_el1pcten_arch()();
+}
+
+static inline u32 __hyp_text get_el1pcen(void)
+{
+	return get_el1pcen_arch()();
+}
+
+#endif	/* __ARM64_KVM_TIMER_H__ */
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index caedb74..4094529 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -23,8 +23,10 @@
 #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
 #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
 
-#define CNTHCTL_EL1PCTEN		(1 << 0)
-#define CNTHCTL_EL1PCEN			(1 << 1)
+#define CNTHCTL_EL1PCTEN_NVHE		(1 << 0)
+#define CNTHCTL_EL1PCEN_NVHE		(1 << 1)
+#define CNTHCTL_EL1PCTEN_VHE		(1 << 10)
+#define CNTHCTL_EL1PTEN_VHE		(1 << 11)
 #define CNTHCTL_EVNTEN			(1 << 2)
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 798866a..f3feee0 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -15,11 +15,11 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <clocksource/arm_arch_timer.h>
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_timer.h>
 
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
@@ -37,7 +37,7 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 
 	/* Allow physical timer/counter access for the host */
 	val = read_sysreg(cnthctl_el2);
-	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	val |= get_el1pcten() | get_el1pcen();
 	write_sysreg(val, cnthctl_el2);
 
 	/* Clear cntvoff for the host */
@@ -55,8 +55,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	 * Physical counter access is allowed
 	 */
 	val = read_sysreg(cnthctl_el2);
-	val &= ~CNTHCTL_EL1PCEN;
-	val |= CNTHCTL_EL1PCTEN;
+	val &= ~get_el1pcen();
+	val |= get_el1pcten();
 	write_sysreg(val, cnthctl_el2);
 
 	if (timer->enabled) {
-- 
1.9.1
