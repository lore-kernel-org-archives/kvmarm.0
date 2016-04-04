From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v5 0/9] arm64: Add support for KVM with ACPI
Date: Mon,  4 Apr 2016 12:37:31 +0100
Message-ID: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F078C40402
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 07:36:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jO9eRNQ-9zbJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 07:36:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A38DC400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 07:36:46 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This patch series allows KVM to work with ACPI on ARM64.

Currently, the firmware tables are parsed by the the virtual timer and virtual
GIC code in order to configure them correctly.

However the parsing of these tables is already done in the GIC and arch timer
drivers. This patch series introduces new helpers to retrieve the information
from the different drivers in order to avoid duplication of the parsing code.

To make the merge easier via the different trees, each patch modifies a single
subsystem. The suggested plan to merge the series is divided in 3 steps:

1) Patches #1-#2 are merged via the clocksource tree
   Patches #2-#6 are merged via the irqchip tree
2) Patches #7-#8 are merge via the KVM tree
3) Patch #9 is merged via the clocksource tree.

For all the changes see in each patch.

Regards,

Cc: daniel.lezcano@linaro.org

Julien Grall (9):
  clocksource: arm_arch_timer: Gather KVM specific information in a
    structure
  clocksource: arm_arch_timer: Extend arch_timer_kvm_info to get the
    virtual IRQ
  irqchip/gic-v2: Gather ACPI specific data in a single structure
  irqchip/gic-v2: Parse and export virtual GIC information
  irqchip/gic-v3: Gather all ACPI specific data in a single structure
  irqchip/gic-v3: Parse and export virtual GIC information
  KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the
    firmware tables
  KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware
    tables
  clocksource: arm_arch_timer: Remove arch_timer_get_timecounter

 drivers/clocksource/arm_arch_timer.c   |  11 ++-
 drivers/irqchip/irq-gic-common.c       |  13 +++
 drivers/irqchip/irq-gic-common.h       |   3 +
 drivers/irqchip/irq-gic-v3.c           | 170 +++++++++++++++++++++++++++------
 drivers/irqchip/irq-gic.c              |  87 ++++++++++++++++-
 include/clocksource/arm_arch_timer.h   |  12 +--
 include/kvm/arm_vgic.h                 |   7 +-
 include/linux/irqchip/arm-gic-common.h |  34 +++++++
 virt/kvm/arm/arch_timer.c              |  40 +++-----
 virt/kvm/arm/vgic-v2.c                 |  61 +++++-------
 virt/kvm/arm/vgic-v3.c                 |  47 ++++-----
 virt/kvm/arm/vgic.c                    |  50 +++++-----
 12 files changed, 371 insertions(+), 164 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-common.h

-- 
1.9.1
