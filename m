From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v6 0/7] KVM: arm64: Implement API for vGICv3 live migration
Date: Tue, 24 Nov 2015 12:14:34 +0300
Message-ID: <cover.1448356282.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 643FC4965E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 04:13:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a2GGeszkb8AG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 04:13:51 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 828F948531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 04:13:50 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00CUQB0M9R50@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 09:14:46 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patchset adds necessary userspace API in order to support vGICv3 live
migration. GICv3 registers are accessed using device attribute ioctls,
similar to GICv2.

v5 => v6:
- Rebased on top of linux-next of 23.11.2015
- Use original API documentation patch, with minor changes only.
- Quit reusing KVM_DEV_ARM_VGIC_CPUID_MASK, do not touch vGICv2 API at all.
- Fixed some issues reported by the new checkpatch

v4 => v5:
- Adapted to new API by Peter Maydell, Marc Zyngier and Christoffer Dall.
  Acked-by's on the documentation were dropped, just in case, because i
  slightly adjusted it. Additionally, i merged all doc updates into one
  patch.

v3 => v4:
- Split pure refactoring from anything else
- Documentation brought up to date
- Cleaned up 'mmio' structure usage in vgic_attr_regs_access(),
  use call_range_handler() for 64-bit access handling
- Rebased on new linux-next

v2 => v3:
- KVM_DEV_ARM_VGIC_CPUID_MASK enlarged to 20 bits, allowing more than 256
  CPUs.
- Bug fix: Correctly set mmio->private, necessary for redistributor access.
- Added accessors for ICC_AP0R and ICC_AP1R registers
- Rebased on new linux-next

v1 => v2:
- Do not use generic register get/set API for CPU interface, use only
  device attributes.
- Introduce size specifier for distributor and redistributor register
  accesses, do not assume size any more.
- Lots of refactor and reusable code extraction.
- Added forgotten documentation

Christoffer Dall (1):
  KVM: arm/arm64: Add VGICv3 save/restore API documentation

Pavel Fedin (6):
  KVM: arm/arm64: Move endianness conversion out of
    vgic_attr_regs_access()
  KVM: arm/arm64: Refactor vGIC attributes handling code
  KVM: arm64: Implement vGICv3 distributor and redistributor access from
    userspace
  KVM: arm64: Refactor system register handlers
  KVM: arm64: Introduce find_reg_by_id()
  KVM: arm64: Implement vGICv3 CPU interface access

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 116 ++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt    |  21 +-
 arch/arm64/include/uapi/asm/kvm.h                 |  15 +-
 arch/arm64/kvm/sys_regs.c                         |  83 +++---
 arch/arm64/kvm/sys_regs.h                         |   8 +-
 arch/arm64/kvm/sys_regs_generic_v8.c              |   2 +-
 include/linux/irqchip/arm-gic-v3.h                |  19 +-
 virt/kvm/arm/vgic-v2-emul.c                       | 124 ++------
 virt/kvm/arm/vgic-v3-emul.c                       | 342 +++++++++++++++++++++-
 virt/kvm/arm/vgic.c                               |  57 ++++
 virt/kvm/arm/vgic.h                               |   3 +
 11 files changed, 616 insertions(+), 174 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt

-- 
2.4.4
