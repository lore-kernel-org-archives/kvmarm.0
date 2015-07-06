From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 0/9] ARM IRQ forward control based on IRQ bypass manager
Date: Mon,  6 Jul 2015 15:24:34 +0200
Message-ID: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A06BA57BA7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Tlf8+QNDfbn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:13:42 -0400 (EDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E00F57B8F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:41 -0400 (EDT)
Received: by wgqq4 with SMTP id q4so140432601wgq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:08 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series allows to set ARM IRQ forwarding between a VFIO platform
device physical IRQ and a guest virtual IRQ. the link now is coordinated
by the IRQ bypass manager. This kernel integration deprecates kvm-vfio
approach (https://lkml.org/lkml/2015/4/13/353).

Some rationale about that change can be found in IRQ bypass manager thread:
https://lkml.org/lkml/2015/6/29/268

The principle is the VFIO platform driver registers an IRQ bypass producer
struct on VFIO_IRQ_SET_ACTION_TRIGGER while KVM irqfd registers a consumer
struct on the irqfd assignment. This leads to a handshake based on the
eventfd context (used as token) match.

When either of the producer/consumer module disappears, this leads to
an unregistration and the link is disconnected.

The series transforms the vfio platform driver into an IRQ bypass manager
producer and implements the KVM IRQ bypass callbacks.

Dependencies:
1- [PATCH 00/10] arm/arm64: KVM: Active interrupt state switching for
   shared devices (http://www.spinics.net/lists/kvm/msg117411.html)
2- RFC "ARM: Forwarding physical interrupts to a guest VM"
   (http://lwn.net/Articles/603514/)
3- [RFC v2 0/6] IRQ bypass manager and irqfd consumer
   including Alex's IRQ bypass manager sent by email
   (https://lkml.org/lkml/2015/6/29/268)
   http://www.spinics.net/lists/kernel/msg2026011.html
4- [RFC v2 0/4] chip/vgic adaptations for forwarded irq
   http://lists.infradead.org/pipermail/linux-arm-kernel/2015-February/323183.html

All those pieces can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc1-bypass-fwd-v2.1

More backgroung on ARM IRQ forwarding in the text below and at
http://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf.

A forwarded IRQ is deactivated by the guest and not by the host.
When the guest deactivates the associated virtual IRQ, the interrupt
controller automatically completes the physical IRQ. Obviously
this requires some HW support in the interrupt controller. This is
the case for ARM GICv2.

The direct benefit is that, for a level sensitive IRQ, a VM exit
can be avoided on forwarded IRQ completion.

When the IRQ is forwarded, the VFIO platform driver does not need to
mask the physical IRQ anymore before signaling the eventfd. Indeed
genirq lowers the running priority, enabling other physical IRQ to hit
except that one.

Besides, the injection still is based on irqfd triggering. The only
impact on irqfd process is resamplefd is not called anymore on
virtual IRQ completion since deactivation is not trapped by KVM.

This was tested on Calxeda Midway, assigning the xgmac main IRQ

History:

v1 -> v2:
- irq bypass manager and irqfd consumer moved in a separate patch
- kvm_arm_[halt,resume]_guest moved in a separate patch
- remove VFIO external functions since we do not need them anymore
- apply container_of strategy advised by Paolo. Only active field
  remains and discussions will tell whether we get rid of it.
- renamed kvm_arch functions

- kvm-vfio v6 -> RFC v1 based on IRQ bypass manager
  see previous history in https://lkml.org/lkml/2015/4/13/353).

Best Regards

Eric


Eric Auger (9):
  VFIO: platform: registration of a dummy IRQ bypass producer
  VFIO: platform: test forwarded state when selecting IRQ handler
  VFIO: platform: single handler using function pointer
  VFIO: platform: add vfio_platform_set_automasked
  VFIO: platform: add vfio_platform_is_active
  irq: bypass: add active field on producer side
  VFIO: platform: add irq bypass producer management
  KVM: arm/arm64: vgic: forwarding control
  KVM: arm/arm64: implement IRQ bypass consumer functions

 arch/arm/kvm/Kconfig                          |   1 +
 arch/arm/kvm/arm.c                            |  40 ++++++
 arch/arm64/kvm/Kconfig                        |   1 +
 drivers/vfio/platform/vfio_platform_irq.c     | 120 +++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   3 +
 include/kvm/arm_vgic.h                        |   7 +
 include/linux/irqbypass.h                     |   2 +
 virt/kvm/arm/vgic.c                           | 195 ++++++++++++++++++++++++++
 8 files changed, 362 insertions(+), 7 deletions(-)

-- 
1.9.1
