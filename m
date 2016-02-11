From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v2 0/6] arm64: Add support of KVM with ACPI
Date: Thu, 11 Feb 2016 15:33:18 +0000
Message-ID: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5A749BDB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZ2Aq5c+gn6c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 10:27:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBC3549BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:36 -0500 (EST)
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

See the changes since v1 in the different patches.

Regards,

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018482.html
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018355.html

Julien Grall (6):
  KVM: arm/arm64: arch_timer: Gather KVM specific information in a
    structure
  KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the
    firmware tables
  irqchip/gic-v2: Gather ACPI specific data in a single structure
  irqchip/gic-v2: Parse and export virtual GIC information
  irqchip/gic-v3: Parse and export virtual GIC information
  KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware
    tables

 drivers/clocksource/arm_arch_timer.c   | 11 ++--
 drivers/irqchip/irq-gic-common.c       | 13 +++++
 drivers/irqchip/irq-gic-common.h       |  3 ++
 drivers/irqchip/irq-gic-v3.c           | 36 ++++++++++++++
 drivers/irqchip/irq-gic.c              | 91 ++++++++++++++++++++++++++++++++--
 include/clocksource/arm_arch_timer.h   | 13 ++---
 include/kvm/arm_vgic.h                 |  7 +--
 include/linux/irqchip/arm-gic-common.h | 34 +++++++++++++
 virt/kvm/arm/arch_timer.c              | 39 ++++-----------
 virt/kvm/arm/vgic-v2.c                 | 67 +++++++++----------------
 virt/kvm/arm/vgic-v3.c                 | 45 +++++------------
 virt/kvm/arm/vgic.c                    | 50 ++++++++++---------
 12 files changed, 264 insertions(+), 145 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-common.h

-- 
1.9.1
