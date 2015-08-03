From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 0/5] KVM: irqfd consumer based on IRQ bypass manager
Date: Mon,  3 Aug 2015 19:20:39 +0200
Message-ID: <1438622444-25444-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, feng.wu@intel.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, joro@8bytes.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series transforms irqfd into an IRQ bypass consumer and
introduce the infrastructure shared by Intel posted-interrupts
and ARM forwarded IRQ series.

The bypass manager gets compiled for x86 and arm/arm64 when
KVM is used. A new kvm_irqfd.h header is created to externalize
some irqfd declarations going to be used by architecture specific
code. A new CONFIG_HAVE_KVM_IRQ_BYPASS option is introduced
to enable architecture specific IRQ manager hooks.

the series depends on the IRQ bypass manager:
- [PATCH v2] virt: IRQ bypass manager
  (https://lkml.org/lkml/2015/7/16/810)

can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc5-irqfd-consumer-v4

Best Regards

Eric

History:

v3 -> v4:
- fix compilation for arm/arm64
- rearrange signoffs/history on some patch files

v2 -> v3 (Feng Wu):
- rebase on IRQ bypass manager [PATCH v2] virt: IRQ bypass manager:
  https://lkml.org/lkml/2015/7/16/810
- Correct some minor errors and typo
- Add something needed for posted-interrupts

v1 -> v2:
- isolate the bypass manager and irqfd consumer in this series
- take into account Paolo's comments and use container_of strategy and
  remove additional fields introduced in v1.
- create kvm_irqfd.h
- add unregistration in irqfd_shutdown

v1: originally part of [RFC 00/17] ARM IRQ forward control based on IRQ
    bypass manager (https://lkml.org/lkml/2015/7/2/268)


Eric Auger (4):
  KVM: arm/arm64: select IRQ_BYPASS_MANAGER
  KVM: create kvm_irqfd.h
  KVM: introduce kvm_arch functions for IRQ bypass
  KVM: eventfd: add irq bypass consumer management

Feng Wu (1):
  KVM: x86: select IRQ_BYPASS_MANAGER

 arch/arm/kvm/Kconfig      |   2 +
 arch/arm/kvm/Makefile     |   1 +
 arch/arm64/kvm/Kconfig    |   2 +
 arch/arm64/kvm/Makefile   |   1 +
 arch/x86/kvm/Kconfig      |   2 +
 arch/x86/kvm/Makefile     |   3 ++
 include/linux/kvm_host.h  |  33 +++++++++++++++
 include/linux/kvm_irqfd.h |  71 +++++++++++++++++++++++++++++++
 virt/kvm/Kconfig          |   3 ++
 virt/kvm/eventfd.c        | 105 +++++++++++++++-------------------------------
 10 files changed, 151 insertions(+), 72 deletions(-)
 create mode 100644 include/linux/kvm_irqfd.h

-- 
1.9.1
