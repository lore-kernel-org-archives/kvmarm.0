From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/21] arm64: KVM: Add a HYP-specific header file
Date: Mon, 16 Nov 2015 13:11:40 +0000
Message-ID: <1447679519-17888-3-git-send-email-marc.zyngier@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to expose the various EL2 services that are private to
the hypervisor, add a new hyp.h file.

So far, it only contains mundane things such as section annotation
and VA manipulation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/hyp.h

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
new file mode 100644
index 0000000..dac843e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
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
+#ifndef __ARM64_KVM_HYP_H__
+#define __ARM64_KVM_HYP_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+#include <asm/sysreg.h>
+
+#define __hyp_text __section(.hyp.text) notrace
+
+#define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
+
+#endif /* __ARM64_KVM_HYP_H__ */
+
-- 
2.1.4

