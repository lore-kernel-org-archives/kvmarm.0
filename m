From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 08:26:25 +0200
Message-ID: <1474007187-18673-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Some systems out there (well, one type in particular - the Raspberry Pi series)
do have virtualization capabilities in the core, but no ARM GIC interrupt
controller.

To run on these systems, the cleanest route is to just handle all
interrupt delivery in user space and only deal with IRQ pins in the core
side in KVM.

This works pretty well already, but breaks when the guest starts to use
architected timers, as these are handled straight inside kernel space today.

This patch set allows user space to receive vtimer events as well as mask
them, so that we can handle all vtimer related interrupt injection from user
space, enabling us to use architected timer with user space gic emulation.

I have successfully run edk2 as well as Linux using these patches on a
Raspberry Pi 3 system with acceptable speed.

A branch with WIP QEMU code can be found here:

  https://github.com/agraf/qemu.git no-kvm-irqchip

To use the user space irqchip, just run it with

  $ qemu-system-aarch64 -M virt,kernel-irqchip=off

v1 -> v2:

  - Add back curly brace that got lost

v2 -> v3:

  - Fix "only only" in documentation
  - Split patches
  - Remove kvm_emulate.h include

Alexander Graf (2):
  KVM: arm/arm64: Add vcpu ENABLE_CAP functionality
  KVM: arm/arm64: Route vtimer events to user space

 Documentation/virtual/kvm/api.txt |  28 ++++++++-
 arch/arm/include/asm/kvm_host.h   |   3 +
 arch/arm/kvm/arm.c                |  47 +++++++++++---
 arch/arm64/include/asm/kvm_host.h |   3 +
 include/uapi/linux/kvm.h          |  14 +++++
 virt/kvm/arm/arch_timer.c         | 125 +++++++++++++++++++++++++++-----------
 6 files changed, 177 insertions(+), 43 deletions(-)

-- 
2.6.6

