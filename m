From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 00/11] KVM: arm/arm64: race fixes and vcpu requests
Date: Sun,  4 Jun 2017 14:43:50 +0200
Message-ID: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This series fixes some hard to produce races by introducing the use of
vcpu requests. I've tested the series on a Mustang and ThunderX and
compile-tested the ARM bits.

Patch 3/11 adds documentation, as, at least for me, understanding vcpu
request interplay with vcpu kicks and vcpu mode and the memory barriers
that interplay implies, is exhausting.

v5:
  - Christoffer's doc clarification suggestions
  - Use kvm_vcpu_wake_up() [Christoffer]

v4:
  - Rebase on latest kvmarm/queue. No more kvm_arm_halt/resume_vcpu
  - Documentation additions/clarifications [Paolo]
  - go back to sleep after getting a signal [Christoffer]
  - timer doesn't need a vcpu request, just a wake up [Christoffer]
  - patch dropping/adding/reshuffling for above changes

v3:
  - The easier to reproduce PSCI races previously fixed with this
    series were fixed independently with a different approach suggested
    by Christoffer[1].
  - Based on Radim's latest vcpu request rework series[2]
  - Rewrote the documentation adding much more information and
    incorporating Christoffer's comments from v2.
  - Reworked the approach to controlling pause and power_off by
    requests.
  - Clear request for pending irq injection in the correct place, as
    pointed out by Christoffer.
  - Rebase required some simple changes to the PMU code patch.

v2:
  - No longer based on Radim's vcpu request API rework[3], except for
    including "add kvm_request_pending" as patch 1/10 [drew]
  - Added vcpu request documentation [drew]
  - Dropped the introduction of user settable MPIDRs [Christoffer]
  - Added vcpu requests to all request-less vcpu kicks [Christoffer]

[1] https://www.spinics.net/lists/arm-kernel/msg577630.html
[2] http://www.spinics.net/lists/kvm/msg148890.html
[3] https://www.spinics.net/lists/kvm/msg145588.html


Andrew Jones (10):
  KVM: improve arch vcpu request defining
  KVM: Add documentation for VCPU requests
  KVM: arm/arm64: properly use vcpu requests
  KVM: arm/arm64: replace pause checks with vcpu request checks
  KVM: arm/arm64: use vcpu requests for power_off
  KVM: arm/arm64: optimize VCPU RUN
  KVM: arm/arm64: change exit request to sleep request
  KVM: arm/arm64: use vcpu requests for irq injection
  KVM: arm/arm64: PMU: remove request-less vcpu kick
  KVM: arm/arm64: timer: remove request-less vcpu kick

Radim Krčmář (1):
  KVM: add kvm_request_pending

 Documentation/virtual/kvm/vcpu-requests.rst | 307 ++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_host.h             |   4 +-
 arch/arm/kvm/handle_exit.c                  |   1 +
 arch/arm64/include/asm/kvm_host.h           |   4 +-
 arch/arm64/kvm/handle_exit.c                |   1 +
 arch/mips/kvm/trap_emul.c                   |   2 +-
 arch/mips/kvm/vz.c                          |   2 +-
 arch/powerpc/include/asm/kvm_host.h         |   4 +-
 arch/powerpc/kvm/booke.c                    |   2 +-
 arch/powerpc/kvm/powerpc.c                  |   5 +-
 arch/s390/include/asm/kvm_host.h            |   6 +-
 arch/s390/kvm/kvm-s390.c                    |   2 +-
 arch/x86/include/asm/kvm_host.h             |  47 +++--
 arch/x86/kvm/x86.c                          |   4 +-
 include/linux/kvm_host.h                    |  12 ++
 virt/kvm/arm/arch_timer.c                   |   2 +-
 virt/kvm/arm/arm.c                          |  50 ++++-
 virt/kvm/arm/pmu.c                          |  40 ++--
 virt/kvm/arm/psci.c                         |   8 +-
 virt/kvm/arm/vgic/vgic.c                    |   9 +-
 20 files changed, 439 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst

-- 
2.9.4
