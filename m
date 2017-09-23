From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 12/20] genirq: Document vcpu_info usage for percpu_devid
 interrupts
Date: Sat, 23 Sep 2017 02:41:59 +0200
Message-ID: <20170923004207.22356-13-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F9F49C76
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d4x5LpsuzQ1O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Sep 2017 20:42:12 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A426E49C90
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:11 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id r136so7639811wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 17:42:23 -0700 (PDT)
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

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
index 573dc52..2b2c94f 100644
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
2.9.0
