From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 0/6] IRQ bypass manager and irqfd consumer
Date: Mon,  6 Jul 2015 14:11:26 +0200
Message-ID: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D9E578B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:00:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svd-nDKfEZX3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 08:00:31 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2701A57861
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:00:30 -0400 (EDT)
Received: by wibdq8 with SMTP id dq8so151296863wib.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 05:11:57 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series introduces and extends the IRQ bypass manager written
by Alex and transforms irqfd into an IRQ bypass manager consumer.
The producer part, in my case the VFIO platform driver will be introduced
separately. That code should be usable by both ARM IRQ forwarding
and Intel Posted Interrupts.

The IRQ bypass manager enables to setup a negotiated link between an
IRQ producer and an IRQ consumer (typically the VFIO driver and KVM irqfd).

The series currently includes Alex's code which was sent my email.
Its structure obvioulsy will adapt to Alex's will.

Also the irq bypass manager gets compiled/linked on arm/arm64 along
with KVM and VFIO platform driver.

can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc1-bypass-fwd-v2

Best Regards

Eric

History:
v1 -> v2:
- isolate the bypass manager and irqfd consumer in this series
- take into account Paolo's comments and use container_of strategy and
  remove additional fields introduced in v1.
- create kvm_irqfd.h
- add unregistration in irqfd_shutdown

v1: originally part of [RFC 00/17] ARM IRQ forward control based on IRQ
    bypass manager (https://lkml.org/lkml/2015/7/2/268)


Eric Auger (6):
  KVM: arm/arm64: select IRQ_BYPASS_MANAGER
  VFIO: platform: select IRQ_BYPASS_MANAGER
  irq: bypass: Extend skeleton for ARM forwarding control
  KVM: create kvm_irqfd.h
  KVM: introduce kvm_arch functions for IRQ bypass
  KVM: eventfd: add irq bypass consumer management

 arch/arm/kvm/Kconfig          |   1 +
 arch/arm64/kvm/Kconfig        |   1 +
 drivers/vfio/platform/Kconfig |   1 +
 include/linux/irqbypass.h     |  19 ++++++--
 include/linux/kvm_host.h      |  37 ++++++++++++++
 include/linux/kvm_irqfd.h     |  70 +++++++++++++++++++++++++++
 kernel/irq/bypass.c           |  44 +++++++++++++++--
 virt/kvm/Kconfig              |   3 ++
 virt/kvm/eventfd.c            | 109 +++++++++++++-----------------------------
 9 files changed, 203 insertions(+), 82 deletions(-)
 create mode 100644 include/linux/kvm_irqfd.h

-- 
1.9.1
