From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v3 00/11] KVM: arm: debug infrastructure support
Date: Mon, 22 Jun 2015 18:41:23 +0800
Message-ID: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F52256261
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:30:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y+oIydPTc5TE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 06:30:52 -0400 (EDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
 [209.85.220.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D94215625F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:30:51 -0400 (EDT)
Received: by paceq1 with SMTP id eq1so107067436pac.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 03:41:41 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch series adds debug support, a key feature missing from the
KVM/armv7 port.

The main idea is borrowed from ARM64, which is to keep track of whether 
the debug registers are "dirty" (changed by the guest) or not. In this 
case, perform the usual save/restore dance, for one run only. It means 
we only have a penalty if a guest is actively using the debug registers.

The amount of registers is properly frightening, but CPUs actually
only implement a subset of them. Also, there is a number of registers
we don't bother emulating (things having to do with external debug and
OSlock).

External debug is when you actually plug a physical JTAG into the CPU.
OSlock is a way to prevent "other software" to play with the debug
registers. My understanding is that it is only useful in combination
with the external debug. In both case, implementing support for this
is probably not worth the effort, at least for the time being.

This has been tested on a Cortex-A15 platform, running 32bit guests.

The patches for this series are based off v4.1-rc8 and can be found
at:

https://git.linaro.org/people/zhichao.huang/linux.git
branch: guest-debug/4.1-rc8-v3

>From v2 [2]:
- Delete the debug mode enabling/disabling strategy
- Add missing cp14/cp15 trace events

>From v1 [1]:
- Added missing cp14 reset functions
- Disable debug mode if we don't need it to reduce unnecessary switch

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-May/014729.html
[2]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-May/014847.html

Zhichao Huang (11):
  KVM: arm: plug guest debug exploit
  KVM: arm: rename pm_fake handler to trap_raz_wi
  KVM: arm: enable to use the ARM_DSCR_MDBGEN macro from KVM assembly
    code
  KVM: arm: common infrastructure for handling AArch32 CP14/CP15
  KVM: arm: check ordering of all system register tables
  KVM: arm: add trap handlers for 32-bit debug registers
  KVM: arm: add trap handlers for 64-bit debug registers
  KVM: arm: implement dirty bit mechanism for debug registers
  KVM: arm: implement lazy world switch for debug registers
  KVM: arm: add a trace event for cp14 traps
  KVM: arm: enable trapping of all debug registers

 arch/arm/include/asm/hw_breakpoint.h |  54 ++---
 arch/arm/include/asm/kvm_asm.h       |  15 ++
 arch/arm/include/asm/kvm_coproc.h    |   3 +-
 arch/arm/include/asm/kvm_host.h      |   6 +
 arch/arm/kernel/asm-offsets.c        |   2 +
 arch/arm/kvm/coproc.c                | 407 ++++++++++++++++++++++++++++++-----
 arch/arm/kvm/handle_exit.c           |   4 +-
 arch/arm/kvm/interrupts.S            |  16 ++
 arch/arm/kvm/interrupts_head.S       | 313 ++++++++++++++++++++++++++-
 arch/arm/kvm/trace.h                 |  30 +++
 10 files changed, 762 insertions(+), 88 deletions(-)

-- 
1.7.12.4
