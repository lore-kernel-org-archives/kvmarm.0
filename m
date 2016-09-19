From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v4 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Mon, 19 Sep 2016 13:14:53 +0200
Message-ID: <1474283695-212421-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC58499A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 07:05:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id URzlFTEvjH5n for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2016 07:05:52 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A45E412D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 07:05:51 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com
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

  $ qemu-system-aarch64 -M virt ...

if you're on a non-vgic host system. Or -M virt,kernel-irqchip=off if your
host system has vgic support.

v1 -> v2:

  - Add back curly brace that got lost

v2 -> v3:

  - Fix "only only" in documentation
  - Split patches
  - Remove kvm_emulate.h include

v3 -> v4:

  - Improve documentation

Alexander Graf (2):
  KVM: arm/arm64: Add vcpu ENABLE_CAP functionality
  KVM: arm/arm64: Route vtimer events to user space

 Documentation/virtual/kvm/api.txt |  34 ++++++++++-
 arch/arm/include/asm/kvm_host.h   |   3 +
 arch/arm/kvm/arm.c                |  47 +++++++++++---
 arch/arm64/include/asm/kvm_host.h |   3 +
 include/uapi/linux/kvm.h          |  14 +++++
 virt/kvm/arm/arch_timer.c         | 125 +++++++++++++++++++++++++++-----------
 6 files changed, 183 insertions(+), 43 deletions(-)

-- 
1.8.5.6
