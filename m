From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/59] KVM: arm/arm64: vgic-new: Add acccessor to new struct
 vgic_irq instance
Date: Tue, 24 May 2016 11:09:11 +0200
Message-ID: <1464080993-10884-18-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 920B949BC8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3SOKv9gPkn71 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:42 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAE4949B9F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:39 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id s131so7238548wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:13 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The new VGIC implementation centers around a struct vgic_irq instance
per virtual IRQ.
Provide a function to retrieve the right instance for a given IRQ
number and (in case of private interrupts) the right VCPU.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 41 +++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h | 22 ++++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic.c
 create mode 100644 virt/kvm/arm/vgic/vgic.h

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
new file mode 100644
index 0000000..fb45537
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
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
+#include "vgic.h"
+
+struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
+
+struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			      u32 intid)
+{
+	/* SGIs and PPIs */
+	if (intid <= VGIC_MAX_PRIVATE)
+		return &vcpu->arch.vgic_cpu.private_irqs[intid];
+
+	/* SPIs */
+	if (intid <= VGIC_MAX_SPI)
+		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+
+	/* LPIs are not yet covered */
+	if (intid >= VGIC_MIN_LPI)
+		return NULL;
+
+	WARN(1, "Looking up struct vgic_irq for reserved INTID");
+	return NULL;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
new file mode 100644
index 0000000..61b8d22
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
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
+#ifndef __KVM_ARM_VGIC_NEW_H__
+#define __KVM_ARM_VGIC_NEW_H__
+
+struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			      u32 intid);
+
+#endif
-- 
2.1.2.330.g565301e.dirty
