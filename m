From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 0/5] KVM: irqfd consumer based on IRQ bypass manager
Date: Mon, 10 Aug 2015 15:31:02 +0200
Message-ID: <1439213467-13668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A697D5A7B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:18:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s71e1Zi7R1Rg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:18:54 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63C9D5A702
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:18:53 -0400 (EDT)
Received: by wibhh20 with SMTP id hh20so150959243wib.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:31:53 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
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
- [PATCH v4] virt: IRQ bypass manager (https://lkml.org/lkml/2015/8/6/526)

can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc6-irq-forward-v3

Best Regards

Eric

History:

v4 -> v5:
- remove kvm_arch static inline stubs
- add pr_info on registration failure

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
 include/linux/kvm_host.h  |  10 +++++
 include/linux/kvm_irqfd.h |  71 ++++++++++++++++++++++++++++++
 virt/kvm/Kconfig          |   3 ++
 virt/kvm/eventfd.c        | 110 ++++++++++++++++------------------------------
 10 files changed, 133 insertions(+), 72 deletions(-)
 create mode 100644 include/linux/kvm_irqfd.h

-- 
1.9.1
