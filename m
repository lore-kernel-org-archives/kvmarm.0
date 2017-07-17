From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 11/19] genirq: Document vcpu_info usage for per-CPU
 interrupts
Date: Mon, 17 Jul 2017 16:27:10 +0200
Message-ID: <20170717142718.13853-12-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E126349C0C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LvTivUMA+ykk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jul 2017 10:26:54 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F67E49C26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 10:26:50 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id b134so49978706wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jul 2017 07:27:36 -0700 (PDT)
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

It is currently unclear how to set the VCPU affinity for an interrupt
which is of the per-CPU kind, since the Linux irq_data structure
describes the state for multiple interrupts when the interrupt is a
per-CPU interrupt, one for each physical CPU on the system.  Since each
such interrupt can be associated with different VCPUs or none at all,
associating a single VCPU state with such an interrupt does not capture
the necessary semantics.

The implementers of irq_set_affinity are the Intel and AMD IOMMUs, and
the ARM GIC irqchip.  The Intel and AMD callers do not appear to use
per-CPU interrupts, and the ARM GIC implementation only checks the
pointer against NULL vs. non-NULL.

Therefore, simply update the function documentation to explain the
expected use in the context of per-CPU interrupts, allowing future
changes or additions to irqchip implementers to do the right thing.

This allows us to set the VCPU affinity for the virtual timer interrupt
in KVM/ARM, which is a per-CPU (PPI) interrupt.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 kernel/irq/manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5624b2d..050b9f6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -381,7 +381,8 @@ int irq_select_affinity_usr(unsigned int irq)
 /**
  *	irq_set_vcpu_affinity - Set vcpu affinity for the interrupt
  *	@irq: interrupt number to set affinity
- *	@vcpu_info: vCPU specific data
+ *	@vcpu_info: vCPU specific data or pointer to a percpu array of vCPU
+ *	            specific data for per-CPU interrupts
  *
  *	This function uses the vCPU specific data to set the vCPU
  *	affinity for an irq. The vCPU specific data is passed from
-- 
2.9.0
