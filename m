From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH 0/5] arm64: Add support of KVM with ACPI
Date: Mon,  8 Feb 2016 16:47:24 +0000
Message-ID: <1454950049-741-1-git-send-email-julien.grall@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This small series allows an ARM64 ACPI based platform to use KVM.

Currently the KVM code has to parse the firmware table to get the necessary
information to setup the virtual timer and virtual GIC.

However the parsing of those tables are already done in the GIC and arch
timer drivers.

This patch series introduces different helpers to retrieve the information
from different drivers avoiding to duplicate the parsing code.

Note there is patch series ([1] and [2]) adding support of KVM on ACPI,
although the approach chosen is completely different. The code to parse
the firmware tables are duplicated which I think make more complex to
support new firmware tables.

Regards,

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018482.html
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018355.html

Julien Grall (5):
  KVM: arm/arm64: arch_timer: Gather KVM specific information in a
    structure
  KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the
    firmware tables
  irqchip/gic-v2: Parse and export virtual GIC information
  irqchip/gic-v3: Parse and export virtual GIC information
  KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware
    tables

 drivers/clocksource/arm_arch_timer.c   | 11 +++--
 drivers/irqchip/irq-gic-common.c       | 13 ++++++
 drivers/irqchip/irq-gic-common.h       |  3 ++
 drivers/irqchip/irq-gic-v3.c           | 43 +++++++++++++++++++
 drivers/irqchip/irq-gic.c              | 78 +++++++++++++++++++++++++++++++++-
 include/clocksource/arm_arch_timer.h   | 13 +++---
 include/kvm/arm_vgic.h                 |  7 +--
 include/linux/irqchip/arm-gic-common.h | 35 +++++++++++++++
 virt/kvm/arm/arch_timer.c              | 39 +++++------------
 virt/kvm/arm/vgic-v2.c                 | 66 ++++++++++------------------
 virt/kvm/arm/vgic-v3.c                 | 45 ++++++--------------
 virt/kvm/arm/vgic.c                    | 50 ++++++++++++----------
 12 files changed, 262 insertions(+), 141 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-common.h

-- 
1.9.1
