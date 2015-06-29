From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/7] KVM: arm/arm64: gsi routing support
Date: Mon, 29 Jun 2015 17:37:10 +0200
Message-ID: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78590569D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zZ4hqB6yqBI5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:37 -0400 (EDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77CC0569D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:37 -0400 (EDT)
Received: by wguu7 with SMTP id u7so144735752wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:46 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
appears to be requested. More specifically MSI routing is needed.
irqchip routing does not sound to be really useful on arm but usage of
MSI routing also mandates to integrate irqchip routing. The initial
implementation of irqfd on arm must be upgraded with the integration
of kvm irqchip.c code and the implementation of its standard hooks
in the architecture specific part.

In case KVM_SET_GSI_ROUTING ioctl is not called, a default routing
table with flat irqchip routing entries is built enabling to inject gsi
corresponding to the SPI indexes seen by the guest.

As soon as KVM_SET_GSI_ROUTING is called, user-space overwrites this
default routing table and is responsible for building the whole routing
table.

for arm/arm64 KVM_SET_GSI_ROUTING has a limited support:
- only applies to KVM_IRQFD and not to KVM_IRQ_LINE

- irqchip routing was tested on Calxeda midway (VFIO with irqfd)
- MSI routing without GICv3 ITS was tested using APM Xgene-I
  (qemu VIRTIO-PCI vhost net without gsi_direct_mapping).
- MSI routing with GICv2 ITS is NOT yet tested.

Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-gsi-routing-patch

It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
(http://www.spinics.net/lists/kvm/msg117402.html)

History:

RFC -> PATCH:
- clearly state limited support on arm/arm64:
  KVM_IRQ_LINE not impacted by GSI routing
- add default routing table feature (new patch file)
- changed uapi to use padding field area
- reword api.txt


Eric Auger (7):
  KVM: api: add kvm_irq_routing_extended_msi
  KVM: kvm_host: add kvm_extended_msi
  KVM: irqchip: convey devid to kvm_set_msi
  KVM: arm/arm64: enable irqchip routing
  KVM: arm/arm64: build a default routing table
  KVM: arm/arm64: enable MSI routing
  KVM: arm: implement kvm_set_msi by gsi direct mapping

 Documentation/virtual/kvm/api.txt |  30 ++++++++--
 arch/arm/include/asm/kvm_host.h   |   2 +
 arch/arm/kvm/Kconfig              |   3 +
 arch/arm/kvm/Makefile             |   2 +-
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/Kconfig            |   2 +
 arch/arm64/kvm/Makefile           |   2 +-
 include/kvm/arm_vgic.h            |   9 ---
 include/linux/kvm_host.h          |  10 ++++
 include/uapi/linux/kvm.h          |   6 +-
 virt/kvm/arm/vgic.c               | 117 ++++++++++++++++++++++++++++----------
 virt/kvm/irqchip.c                |  20 +++++--
 12 files changed, 154 insertions(+), 50 deletions(-)

-- 
1.9.1
