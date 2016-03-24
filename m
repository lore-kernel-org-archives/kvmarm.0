From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v4 0/9] arm64: Add support for KVM with ACPI
Date: Thu, 24 Mar 2016 17:53:34 +0000
Message-ID: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This patch series allows KVM to work with ACPI on ARM64.

Currently, the firmware tables are parsed by the virtual timer and virtual GIC
code in order to configure them correctly.

However, the parsing of those tables is already done in the GIC and arch
timer drivers. This patch series introduces new helpers to retrieve the
information from the different drivers in order to avoid duplication of the
parsing code.

To make the merge easier via the different trees, each patch modifies
a single subsystem.

For all the changes see the different patches.

Yours sincerely,

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

 drivers/clocksource/arm_arch_timer.c   |  11 +-
 drivers/irqchip/irq-gic-common.c       |  13 +++
 drivers/irqchip/irq-gic-common.h       |   3 +
 drivers/irqchip/irq-gic-v3.c           | 183 ++++++++++++++++++++++++++++-----
 drivers/irqchip/irq-gic.c              |  87 +++++++++++++++-
 include/clocksource/arm_arch_timer.h   |  12 +--
 include/kvm/arm_vgic.h                 |   7 +-
 include/linux/irqchip/arm-gic-common.h |  34 ++++++
 virt/kvm/arm/arch_timer.c              |  40 ++-----
 virt/kvm/arm/vgic-v2.c                 |  61 +++++------
 virt/kvm/arm/vgic-v3.c                 |  47 +++------
 virt/kvm/arm/vgic.c                    |  50 ++++-----
 12 files changed, 384 insertions(+), 164 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-common.h

-- 
1.9.1

