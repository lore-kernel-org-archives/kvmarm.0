From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/95] ARM: KVM: Add a HYP-specific header file
Date: Wed,  9 Mar 2016 07:30:01 +0000
Message-ID: <1457508689-19672-8-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to expose the various HYP services that are private to
the hypervisor, add a new hyp.h file.

So far, it only contains mundane things such as section annotation
and VA manipulation.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/hyp.h

diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
new file mode 100644
index 0000000..c723870
--- /dev/null
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -0,0 +1,30 @@
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
+#ifndef __ARM_KVM_HYP_H__
+#define __ARM_KVM_HYP_H__
+
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+
+#define __hyp_text __section(.hyp.text) notrace
+
+#define kern_hyp_va(v) (v)
+#define hyp_kern_va(v) (v)
+
+#endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4

