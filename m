From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v3 0/9] arm64: Add support of KVM with ACPI
Date: Tue,  8 Mar 2016 11:29:24 +0000
Message-ID: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6F749B21
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 06:30:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pr1Mb3W3mrc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2016 06:30:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DACA49AF5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 06:30:14 -0500 (EST)
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This patch series allows an ARM64 ACPI based platform to use KVM.

Currently the KVM code has to parse the firmware table to get the necessary
information to setup the virtual timer and virtual GIC.

However the parsing of those tables are already done in the GIC and arch
timer drivers.

This patch series introduces different helpers to retrieve the information
from different drivers avoiding the duplication of the parsing code.

Compare to v2, the serie has been reworked to allow easy merge via the
different trees.

For the other changes see the different patches.

Sincerely yours,

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
 drivers/irqchip/irq-gic-v3.c           | 145 ++++++++++++++++++++++++++-------
 drivers/irqchip/irq-gic.c              |  91 +++++++++++++++++++--
 include/clocksource/arm_arch_timer.h   |  12 +--
 include/kvm/arm_vgic.h                 |   7 +-
 include/linux/irqchip/arm-gic-common.h |  34 ++++++++
 virt/kvm/arm/arch_timer.c              |  40 +++------
 virt/kvm/arm/vgic-v2.c                 |  67 ++++++---------
 virt/kvm/arm/vgic-v3.c                 |  45 +++-------
 virt/kvm/arm/vgic.c                    |  50 ++++++------
 12 files changed, 345 insertions(+), 173 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-common.h

-- 
1.9.1
