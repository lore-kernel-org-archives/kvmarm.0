From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v6 0/2] support exception state migration and set VSESR_EL2 by user space
Date: Mon, 2 Jul 2018 21:40:13 +0800
Message-ID: <1530538815-3847-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: gengdongjiu@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This series patch is separated from https://www.spinics.net/lists/kvm/msg168917.html

1. Detect whether KVM can set set guest SError syndrome
2. Support to Set VSESR_EL2 and inject SError by user space.
3. Support live migration to keep SError pending state and VSESR_EL2 value

The user space patch is here: https://www.mail-archive.com/qemu-devel@nongnu.org/msg539534.html
BTW: The user space patch is needed to rebase


Dongjiu Geng (2):
  arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
  arm64: KVM: export the capability to set guest SError syndrome

 Documentation/virtual/kvm/api.txt    | 44 ++++++++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_emulate.h |  5 ++++
 arch/arm64/include/asm/kvm_host.h    |  7 ++++++
 arch/arm64/include/uapi/asm/kvm.h    | 13 ++++++++++
 arch/arm64/kvm/guest.c               | 46 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        |  6 ++---
 arch/arm64/kvm/reset.c               |  4 ++++
 include/uapi/linux/kvm.h             |  1 +
 virt/kvm/arm/arm.c                   | 21 ++++++++++++++++
 9 files changed, 140 insertions(+), 7 deletions(-)

-- 
2.7.4
