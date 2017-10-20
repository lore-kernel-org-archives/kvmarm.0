From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 12/20] genirq: Document vcpu_info usage for percpu_devid
 interrupts
Date: Fri, 20 Oct 2017 13:49:31 +0200
Message-ID: <20171020114939.12554-13-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F63A49D50
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hUv7g1XIgRp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:48:54 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 013CB49D1F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:54 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id l68so21955771wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 04:50:00 -0700 (PDT)
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

It is currently unclear how to set the VCPU affinity for a percpu_devid
interrupt , since the Linux irq_data structure describes the state for
multiple interrupts, one for each physical CPU on the system.  Since
each such interrupt can be associated with different VCPUs or none at
all, associating a single VCPU state with such an interrupt does not
capture the necessary semantics.

The implementers of irq_set_affinity are the Intel and AMD IOMMUs, and
the ARM GIC irqchip.  The Intel and AMD callers do not appear to use
percpu_devid interrupts, and the ARM GIC implementation only checks the
pointer against NULL vs. non-NULL.

Therefore, simply update the function documentation to explain the
expected use in the context of percpu_devid interrupts, allowing future
changes or additions to irqchip implementers to do the right thing.

This allows us to set the VCPU affinity for the virtual timer interrupt
in KVM/ARM, which is a percpu_devid (PPI) interrupt.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 kernel/irq/manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d00132b5c325..38ec7a83bf56 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -381,7 +381,8 @@ int irq_select_affinity_usr(unsigned int irq)
 /**
  *	irq_set_vcpu_affinity - Set vcpu affinity for the interrupt
  *	@irq: interrupt number to set affinity
- *	@vcpu_info: vCPU specific data
+ *	@vcpu_info: vCPU specific data or pointer to a percpu array of vCPU
+ *	            specific data for percpu_devid interrupts
  *
  *	This function uses the vCPU specific data to set the vCPU
  *	affinity for an irq. The vCPU specific data is passed from
-- 
2.14.2
