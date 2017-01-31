From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 6/9] KVM: arm/arm64: Add support for tracking guest TLB
 operations
Date: Tue, 31 Jan 2017 17:16:27 +0000
Message-ID: <20170131171630.26898-7-punit.agrawal@arm.com>
References: <20170131171630.26898-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CF940296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WmF8nrjsjAjG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 12:17:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4A7401A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:17:22 -0500 (EST)
In-Reply-To: <20170131171630.26898-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

The host pmu supports monitoring of VM operations. Register a host pmu
and provide the necessary callbacks to enable monitoring TLB operations.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/host_pmu_events.c | 82 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 virt/kvm/arm/host_pmu_events.c

diff --git a/virt/kvm/arm/host_pmu_events.c b/virt/kvm/arm/host_pmu_events.c
new file mode 100644
index 000000000000..a5f097a6fb21
--- /dev/null
+++ b/virt/kvm/arm/host_pmu_events.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
+ * Author: Punit Agrawal <punit.agrawal@arm.com>
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
+#include <kvm/host_pmu.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include <asm/kvm_emulate.h>
+
+enum host_pmu_events {
+	tlb_invalidate,
+	MAX_EVENTS,
+};
+
+static u64 get_tlb_invalidate_count(struct kvm_vcpu *vcpu)
+{
+	return vcpu->stat.tlb_invalidate;
+}
+
+static void configure_tlb_invalidate(struct kvm_vcpu *vcpu, bool enable)
+{
+	unsigned long hcr;
+
+	hcr = vcpu_get_hcr(vcpu);
+
+	if (enable)
+		hcr |= HCR_TTLB;
+	else
+		hcr &= ~HCR_TTLB;
+
+	vcpu_set_hcr(vcpu, hcr);
+}
+
+static ssize_t events_sysfs_show(struct device *dev,
+				 struct device_attribute *attr, char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr;
+
+	pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
+
+	return sprintf(page, "event=0x%03llx\n", pmu_attr->id);
+}
+PMU_EVENT_ATTR(tlb_invalidate, event_attr_tlb_invalidate, tlb_invalidate,
+	       events_sysfs_show);
+
+static struct attribute *event_attrs[] = {
+	&event_attr_tlb_invalidate.attr.attr,
+	NULL,
+};
+
+static struct kvm_event_cb event_callbacks[] = {
+	{
+		.get_event_count = get_tlb_invalidate_count,
+		.configure_event = configure_tlb_invalidate,
+	},
+};
+
+int arm_host_pmu_init(void)
+{
+	return kvm_host_pmu_register(MAX_EVENTS, event_callbacks, event_attrs);
+}
+
+void arm_host_pmu_teardown(void)
+{
+	kvm_host_pmu_unregister();
+}
-- 
2.11.0
