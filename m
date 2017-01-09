From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 21/55] KVM: arm64: Forward HVC instruction to the guest
 hypervisor
Date: Mon,  9 Jan 2017 01:24:17 -0500
Message-ID: <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47BF940539
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6mBsLitGK9-Q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:19 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 581A04069A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:19 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXnp005357
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:00 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id E486C6D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:00 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id CD31E7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:00 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q0xg004964
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:00 -0500
Received: by mail-qk0-f200.google.com with SMTP id a195so63260913qkg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:00 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward exceptions due to hvc instruction to the guest hypervisor.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_nested.h |  5 +++++
 arch/arm64/kvm/Makefile             |  1 +
 arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
 arch/arm64/kvm/handle_exit_nested.c | 27 +++++++++++++++++++++++++++
 4 files changed, 44 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/kvm/handle_exit_nested.c

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
new file mode 100644
index 0000000..620b4d3
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -0,0 +1,5 @@
+#ifndef __ARM64_KVM_NESTED_H__
+#define __ARM64_KVM_NESTED_H__
+
+int handle_hvc_nested(struct kvm_vcpu *vcpu);
+#endif
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index b342bdd..9c35e9a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -35,4 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
+kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += handle_exit_nested.o
 kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a891684..208be16 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -29,6 +29,10 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
 
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+#include <asm/kvm_nested.h>
+#endif
+
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
@@ -42,6 +46,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+	ret = handle_hvc_nested(vcpu);
+	if (ret < 0 && ret != -EINVAL)
+		return ret;
+	else if (ret >= 0)
+		return ret;
+#endif
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
 		kvm_inject_undefined(vcpu);
diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
new file mode 100644
index 0000000..a6ce23b
--- /dev/null
+++ b/arch/arm64/kvm/handle_exit_nested.c
@@ -0,0 +1,27 @@
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
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+
+/* We forward all hvc instruction to the guest hypervisor. */
+int handle_hvc_nested(struct kvm_vcpu *vcpu)
+{
+	return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+}
-- 
1.9.1
