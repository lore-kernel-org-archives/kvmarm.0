From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/3] KVM: arm64: Implement API for vGICv3 live migration
Date: Fri, 28 Aug 2015 15:56:09 +0300
Message-ID: <cover.1440766141.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patchset adds necessary userspace API in order to support vGICv3 live
migration. This includes accessing GIC distributor and redistributor memory
regions using device attribute ioctls, and system registers of
CPU interface using register get/set ioctls.

Pavel Fedin (3):
  KVM: arm64: Implement vGICv3 distributor and redistributor access from
    userspace
  KVM: arm64: Allow to use accessors in KVM_SET_ONE_REG and
    KVM_GET_ONE_REG
  KVM: arm64: Implement accessors for vGIC CPU interface registers

 arch/arm64/include/uapi/asm/kvm.h  |   1 +
 arch/arm64/kvm/sys_regs.c          | 223 ++++++++++++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-v3.h |  18 ++-
 virt/kvm/arm/vgic-v3-emul.c        | 186 ++++++++++++++++++++++++++++---
 4 files changed, 405 insertions(+), 23 deletions(-)

-- 
2.4.4

