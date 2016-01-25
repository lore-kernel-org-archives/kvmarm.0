From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/27] ARM: KVM: Add a HYP-specific header file
Date: Mon, 25 Jan 2016 16:38:22 +0000
Message-ID: <1453739923-17846-7-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 284634130B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 64lZ5wo7Z6B8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 11:34:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CDB4419D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:05 -0500 (EST)
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to expose the various HYP services that are private to
the hypervisor, add a new hyp.h file.

So far, it only contains mundane things such as section annotation
and VA manipulation.

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
