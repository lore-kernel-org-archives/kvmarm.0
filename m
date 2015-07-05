From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/7] KVM: arm/arm64: gsi routing support
Date: Sun, 5 Jul 2015 21:40:42 +0200
Message-ID: <20150705194042.GE3869@cbox>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B8057A59
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:29:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GyDDUmgP-L0y for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 15:29:16 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB9AF57A55
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:29:16 -0400 (EDT)
Received: by lagx9 with SMTP id x9so132145023lag.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 12:40:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 29, 2015 at 05:37:10PM +0200, Eric Auger wrote:
> With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
> appears to be requested. More specifically MSI routing is needed.
> irqchip routing does not sound to be really useful on arm but usage of
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
> - MSI routing without GICv3 ITS was tested using APM Xgene-I
>   (qemu VIRTIO-PCI vhost net without gsi_direct_mapping).
> - MSI routing with GICv2 ITS is NOT yet tested.

Do you mean GICv3 ITS here?

> 
> Code can be found at https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-gsi-routing-patch
> 
> It applies on Andre's [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
> (http://www.spinics.net/lists/kvm/msg117402.html)
> 
> History:
> 
> RFC -> PATCH:
> - clearly state limited support on arm/arm64:
>   KVM_IRQ_LINE not impacted by GSI routing
> - add default routing table feature (new patch file)
> - changed uapi to use padding field area
> - reword api.txt
> 
> 
> Eric Auger (7):
>   KVM: api: add kvm_irq_routing_extended_msi
>   KVM: kvm_host: add kvm_extended_msi
>   KVM: irqchip: convey devid to kvm_set_msi
>   KVM: arm/arm64: enable irqchip routing
>   KVM: arm/arm64: build a default routing table
>   KVM: arm/arm64: enable MSI routing
>   KVM: arm: implement kvm_set_msi by gsi direct mapping
> 
>  Documentation/virtual/kvm/api.txt |  30 ++++++++--
>  arch/arm/include/asm/kvm_host.h   |   2 +
>  arch/arm/kvm/Kconfig              |   3 +
>  arch/arm/kvm/Makefile             |   2 +-
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/kvm/Kconfig            |   2 +
>  arch/arm64/kvm/Makefile           |   2 +-
>  include/kvm/arm_vgic.h            |   9 ---
>  include/linux/kvm_host.h          |  10 ++++
>  include/uapi/linux/kvm.h          |   6 +-
>  virt/kvm/arm/vgic.c               | 117 ++++++++++++++++++++++++++++----------
>  virt/kvm/irqchip.c                |  20 +++++--
>  12 files changed, 154 insertions(+), 50 deletions(-)
> 
> -- 
> 1.9.1
> 
