From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v4 0/7] KVM: arm/arm64: gsi routing support
Date: Thu, 14 Apr 2016 14:04:54 +0200
Message-ID: <20160414120454.GE30804@cbox>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C7B49B63
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 08:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5VkA6VGKCVAQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 08:02:50 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49E3649B82
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 08:02:49 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id u206so122276625wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 05:04:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 10:47:30AM +0200, Eric Auger wrote:
> With the advent of GICv3 ITS in-kernel emulation, KVM MSI routing
> becomes mandated for proper VIRTIO-PCI vhost integration.
> 
> In QEMU, when the VIRTIO-PCI device is programmed with the MSI message,
> we previously used direct_mapping trick: this consists in extracting the
> SPI ID found in the MSI message and associating an irqfd to that SPI ID.
> When vhost worker thread gets a new buffer it signals the irqfd and kvm
> then injects this SPI ID on guest. That way although the guest uses MSIs,
> no MSI emulation is used.
> 
> This worked fine with GICv2m but does not work anymore with GICV3 ITS.
> Indeed this latter implements IRQ translation: what is found in the MSI
> message no more is the target SPI ID but is an intermediate event ID used
> in the translation process.
> 
> Hence true MSI routing is needed so that the vhost back channel irqfd is
> associated to a dummy gsi ID, routed towards the programmed MSI. When KVM

Doesn't the guest have to program the device with some ID?  So how is
this dummy GSI ID assigned?

> injects the MSI through the in-kernel ITS emulation, the MSI is properly
> translated and eventually the SPI ID associated to the event ID is injected
> on guest.

Isn't it an LPI that is injected to the guest when you have an emulated
ITS then?

> 
> irqchip routing does not sound to be really useful on arm but usage of

Is this also true if you had multiple emulated ITS devices?

(I just don't want to block our options of doing this in the future if
ever required.)

> MSI routing also mandates to integrate irqchip routing. The initial
> implementation of irqfd on arm must be upgraded with the integration
> of kvm irqchip.c code and the implementation of its standard hooks
> in the architecture specific part.
> 
> In case KVM_SET_GSI_ROUTING ioctl is not called, a default routing
> table with flat irqchip routing entries is built enabling to inject gsi
> corresponding to the SPI indexes seen by the guest.
> 
> As soon as KVM_SET_GSI_ROUTING is called, user-space overwrites this
> default routing table and is responsible for building the whole routing
> table.
> 
> for arm/arm64 KVM_SET_GSI_ROUTING has a limited support:
> - only applies to KVM_IRQFD and not to KVM_IRQ_LINE
> 
> - irqchip routing was tested on Calxeda midway (VFIO with irqfd)
>   with and without explicit routing
> - MSI routing without GICv3 ITS was tested using APM Xgene-I
>   (qemu VIRTIO-PCI vhost-net without gsi_direct_mapping).
> - MSI routing with GICv3 ITS is *NOT* tested.
> 
> Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.5-rc6-its-emul-v4-gsi-routing-v4
> 
> The series applies on top of Andre's branch featuring NEW-VGIC and in-kernel
> ITS emulation series:
> http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v4
> 
> [1]: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
>      http://www.spinics.net/lists/arm-kernel/msg492770.html
> [2]: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
>      http://www.spinics.net/lists/arm-kernel/msg492639.html
> 
> GSI flat routing setup on QEMU can be found at:
> https://lists.nongnu.org/archive/html/qemu-devel/2015-07/msg06262.html
> 
> History:
> v3 -> v4:
> - rebase on top of NEW-VGIC RFC and ITS emulation series v4. This is not
>   a stable foundation yet. Hence the revert to RFC. This v4 mostly is a
>   reflesh/reminder.
> - rewrite the cover letter
> 
> v2 -> v3:
> - don't use KVM_IRQ_ROUTING_EXTENDED_MSI type at uapi and kernel level anymore;
>   use KVM_MSI_VALID_DEVID flag instead
> - propagate user flags downto the kernel to make sure the userspace
>   correctly set devid in GICv3 ITS case (still under discussion)
> 
> v1 -> v2:
> - user API changed:
>   x devid id passed in kvm_irq_routing_msi
>   x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI
> - kvm_host.h: adopt Andre's proposal to replace the msi_msg by a struct
>   composed of the msi_msg and devid in kvm_kernel_irq_routing_entry
> - Fix bug reported by Pavel: Added KVM_IRQ_ROUTING_EXTENDED_MSI handling
>   in eventfd.c
> - added vgic_v2m_inject_msi in vgic-v2-emul.c as suggested by Andre
> - fix bug reported by Andre: bad setting of msi.flags and msi.devid
>   in kvm_send_userspace_msi
> - avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq
> 
> RFC -> PATCH:
> - clearly state limited support on arm/arm64:
>   KVM_IRQ_LINE not impacted by GSI routing
> - add default routing table feature (new patch file)
> - changed uapi to use padding field area
> - reword api.txt
> 
> 
> 
> Eric Auger (7):
>   KVM: api: pass the devid in the msi routing entry
>   KVM: kvm_host: add devid in kvm_kernel_irq_routing_entry
>   KVM: irqchip: convey devid to kvm_set_msi
>   KVM: arm/arm64: enable irqchip routing
>   KVM: arm/arm64: build a default routing table
>   KVM: arm/arm64: enable MSI routing
>   KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
> 
>  Documentation/virtual/kvm/api.txt | 35 ++++++++++++---
>  arch/arm/include/asm/kvm_host.h   |  2 +
>  arch/arm/kvm/Kconfig              |  3 ++
>  arch/arm/kvm/Makefile             |  1 +
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/Kconfig            |  3 ++
>  arch/arm64/kvm/Makefile           |  1 +
>  include/kvm/vgic/vgic.h           |  2 -
>  include/linux/kvm_host.h          |  8 +++-
>  include/uapi/linux/kvm.h          |  5 ++-
>  virt/kvm/arm/vgic/vgic-v2.c       | 15 +++++++
>  virt/kvm/arm/vgic/vgic.c          |  7 ---
>  virt/kvm/arm/vgic/vgic.h          |  1 +
>  virt/kvm/arm/vgic/vgic_init.c     | 24 +++++++++++
>  virt/kvm/arm/vgic/vgic_irqfd.c    | 91 +++++++++++++++++++++++++++++++--------
>  virt/kvm/irqchip.c                |  8 +++-
>  16 files changed, 170 insertions(+), 37 deletions(-)
> 
> -- 
> 1.9.1
> 
