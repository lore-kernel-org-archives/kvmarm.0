From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 4/7] KVM: arm/arm64: Check that system supports split
 eoi/deactivate
Date: Sat, 10 Dec 2016 21:47:09 +0100
Message-ID: <20161210204712.21830-5-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E7040598
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gNPVs+bU4-+O for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0C2E40194
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:06 -0500 (EST)
Received: by mail-lf0-f43.google.com with SMTP id y21so21797225lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:47:10 -0800 (PST)
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Some systems without proper firmware and/or hardware description data
don't support the split EOI and deactivate operation and therefore
don't provide an irq_set_vcpu_affinity implementation.  On such
systems, we cannot leave the physical interrupt active after the timer
handler on the host has run, so we cannot support KVM with the timer
changes we about to introduce.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index c7c3bfd..f27a086 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -418,6 +418,31 @@ static int kvm_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+static bool has_split_eoi_deactivate_support(void)
+{
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct irq_chip *chip;
+
+	/*
+	 * Check if split EOI and deactivate is supported on this machine.
+	 */
+	desc = irq_to_desc(host_vtimer_irq);
+	if (!desc) {
+		kvm_err("kvm_arch_timer: no host_vtimer_irq descriptor\n");
+		return false;
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	chip = irq_data_get_irq_chip(data);
+	if (!chip || !chip->irq_set_vcpu_affinity) {
+		kvm_err("kvm_arch_timer: no split EOI/deactivate; abort\n");
+		return false;
+	}
+
+	return true;
+}
+
 int kvm_timer_hyp_init(void)
 {
 	struct arch_timer_kvm_info *info;
@@ -449,6 +474,11 @@ int kvm_timer_hyp_init(void)
 		return err;
 	}
 
+	if (!has_split_eoi_deactivate_support()) {
+		disable_percpu_irq(host_vtimer_irq);
+		return -ENODEV;
+	}
+
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
 
 	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
-- 
2.9.0
