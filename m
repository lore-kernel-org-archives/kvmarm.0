From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 0/5]  KVM: arm64: Implement API for vGICv3 live migration
Date: Wed, 02 Sep 2015 11:09:44 +0300
Message-ID: <cover.1441180858.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD7548AB0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:09:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eoZ7x0dIDwUR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 04:09:35 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ACA748A69
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:09:35 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NU100L83IOHBD70@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 02 Sep 2015 09:09:53 +0100 (BST)
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
  Implement vGICv3 CPU interface access

 Documentation/virtual/kvm/devices/arm-vgic.txt |  72 +++++-
 arch/arm64/include/uapi/asm/kvm.h              |   9 +
 arch/arm64/kvm/sys_regs.c                      |  73 +++---
 arch/arm64/kvm/sys_regs.h                      |   8 +-
 arch/arm64/kvm/sys_regs_generic_v8.c           |   2 +-
 include/linux/irqchip/arm-gic-v3.h             |  18 +-
 virt/kvm/arm/vgic-v2-emul.c                    | 126 ++-------
 virt/kvm/arm/vgic-v3-emul.c                    | 342 ++++++++++++++++++++++++-
 virt/kvm/arm/vgic.c                            |  77 ++++++
 virt/kvm/arm/vgic.h                            |   4 +
 10 files changed, 573 insertions(+), 158 deletions(-)

-- 
2.4.4
