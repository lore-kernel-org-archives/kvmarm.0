From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 00/15] KVM: arm: debug infrastructure support
Date: Mon, 10 Aug 2015 21:25:52 +0800
Message-ID: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch series adds debug support, a key feature missing from the
KVM/armv7 port.

The main idea is to keep track of whether the host and the guest have any
break/watch points enabled or not. We only do the world switch for debug
registers when the host or the guest is actually using it.

We add a function reading the break/watch control variables directly to
indicate whether the host has enabled any break/watch points or not. 
We only call the function upon guest entry, after preempt_disable() and
local_irq_disable(), so there is no race for it.

We also tried implementing this series with trapping host use of debug
registers to hyp mode, and keep track of host/guest use of the debug
hardware in that way. This, however, proved to be very difficult,
because it requires us to: First, we have to add a new mechanism to
support trapping host, jump from EL2 to EL1 to run our host_trap_handlers,
and then jump back to the orginal code which trigger the trap.
Second, we have to take specail care when tearing down KVM to disable
the traps, we also impose an ordering requirement of whether KVM or
the breakpoint functionality gets initialized first. In the end we decided
that this was too difficult and convoluted compared to simply read the
values from variables, so we reverted back to this approach.

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

The patches for this series are based off v4.2-rc6 and can be found
at:

https://git.linaro.org/people/zhichao.huang/linux.git
branch: guest-debug/4.2-rc6-v4

>From v3 [3]:
- Redefine kvm_cpu_context_t as a new struct including the cp14 states
- Save host cp14 states in the vcpu struct intead of memory
- Add a function to keep track of the host use of the debug registers
- Add new lazy world switch mechanism

>From v2 [2]:
- Delete the debug mode enabling/disabling strategy
- Add missing cp14/cp15 trace events

>From v1 [1]:
- Added missing cp14 reset functions
- Disable debug mode if we don't need it to reduce unnecessary switch

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-May/014729.html
[2]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-May/014847.html
[3]: https://lists.cs.columbia.edu/pipermail/kvmarm/2015-June/015167.html

Zhichao Huang (15):
  KVM: arm: plug guest debug exploit
  KVM: arm: rename pm_fake handler to trap_raz_wi
  KVM: arm: enable to use the ARM_DSCR_MDBGEN macro from KVM assembly
    code
  KVM: arm: common infrastructure for handling AArch32 CP14/CP15
  KVM: arm: check ordering of all system register tables
  KVM: arm: add trap handlers for 32-bit debug registers
  KVM: arm: add trap handlers for 64-bit debug registers
  KVM: arm: add a trace event for cp14 traps
  KVM: arm: redefine kvm_cpu_context_t to save the host cp14 states
  KVM: arm: implement world switch for debug registers
  KVM: arm: add a function to keep track of host use of the debug
    registers
  KVM: arm: keep track of host use of the debug registers
  KVM: arm: keep track of guest use of the debug registers
  KVM: arm: implement lazy world switch for debug registers
  KVM: arm: enable trapping of all debug registers

 arch/arm/include/asm/hw_breakpoint.h |  59 +++--
 arch/arm/include/asm/kvm_asm.h       |  17 ++
 arch/arm/include/asm/kvm_coproc.h    |   3 +-
 arch/arm/include/asm/kvm_host.h      |  13 +-
 arch/arm/kernel/asm-offsets.c        |   6 +-
 arch/arm/kernel/hw_breakpoint.c      |  21 ++
 arch/arm/kvm/arm.c                   |   2 +
 arch/arm/kvm/coproc.c                | 445 ++++++++++++++++++++++++++++++-----
 arch/arm/kvm/handle_exit.c           |   4 +-
 arch/arm/kvm/interrupts.S            |  18 +-
 arch/arm/kvm/interrupts_head.S       | 188 ++++++++++++++-
 arch/arm/kvm/trace.h                 |  30 +++
 arch/arm64/include/asm/kvm_host.h    |   1 +
 13 files changed, 707 insertions(+), 100 deletions(-)

-- 
1.7.12.4

