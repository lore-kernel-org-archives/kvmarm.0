From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 0/5] KVM: arm64: Implement API for vGICv3 live migration
Date: Fri, 04 Sep 2015 15:40:14 +0300
Message-ID: <cover.1441370053.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E2D241978
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 08:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id beexcnnxjukW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 08:39:59 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 412C441049
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 08:39:58 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NU50052XKJB2UA0@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 04 Sep 2015 13:40:23 +0100 (BST)
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

V2 => V3:
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

Pavel Fedin (5):
  KVM: arm/arm64: Refactor vGIC attributes handling code
  KVM: arm64: Implement vGICv3 distributor and redistributor access from
    userspace
  KVM: arm64: Refactor system register handlers
  KVM: arm64: Introduce find_reg_by_id()
  KVM: arm64: Implement vGICv3 CPU interface access

 Documentation/virtual/kvm/devices/arm-vgic.txt |  73 +++++-
 arch/arm64/include/uapi/asm/kvm.h              |  11 +-
 arch/arm64/kvm/sys_regs.c                      |  83 +++---
 arch/arm64/kvm/sys_regs.h                      |   8 +-
 arch/arm64/kvm/sys_regs_generic_v8.c           |   2 +-
 include/linux/irqchip/arm-gic-v3.h             |  18 +-
 virt/kvm/arm/vgic-v2-emul.c                    | 126 ++-------
 virt/kvm/arm/vgic-v3-emul.c                    | 339 ++++++++++++++++++++++++-
 virt/kvm/arm/vgic.c                            |  78 ++++++
 virt/kvm/arm/vgic.h                            |   4 +
 10 files changed, 577 insertions(+), 165 deletions(-)

-- 
2.4.4
