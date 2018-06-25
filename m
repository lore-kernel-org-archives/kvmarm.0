From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: vgic: Virtual interrupt grouping
 support
Date: Mon, 25 Jun 2018 10:59:06 +0100
Message-ID: <16588d45-5f24-90ff-57ca-6c670cc2c96c@arm.com>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180624221103.15055-1-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/06/18 23:10, Christoffer Dall wrote:
> This small series addresses a peculiarity of the current VGIC
> implementation, namely that we don't support interrupt grouping.

Nice one and seems straight forward enough.
Just curious: Were there any complaints or even users of FIQs and/or
interrupt grouping?

> KVM either implements a GICv2 without support for the security
> extensions, or a GICv3 with DS=1.  For GICv2, on systems without the
> security extensions, group 0 interrupts can be configured to be either
> signalled as FIQs or as IRQs by the VM, whereas group 1 interrupts are
> always IRQs.  For GICv3, with DS=1, group 1 interrupts are always IRQs
> and group 0 interrupts are always FIQs, and there is no concept of
> secure vs. non-secure group 1 interrupts when DS=1.
> 
> We were treating all interrupts on GICv2 as group 0, but yet telling the
> geust that they were group 1.  The first patch changes this behavior,
> which seems to have no effect on no known guests, but still.
> 
> The remaining patches introduce proper interrupt grouping support, along
> with MMIO accessors for the VM and userspace to retrieve and set the
> which group SGIs, PPIs, and SPIs belong to.  LPIs are always group 1
> interrupts as per the architecture, and there is no way to modify this
> configuration (no IGROUPR registers for LPIs or equivalent ITS
> commands).
> 
> Lightly tested on Seattle, TX1, and the foundation model.  I've run a
> GICv2 guest on a GICv3 host on the foundation model.

I take it those were regression tests with Linux guests?
Do we have any means of testing this with guests which actually use
different groups or FIQs? Does kvm-unit-tests cover this?

Did you do any tests on 32 bit? I am going to fire up something on my
Midway later today ...

Cheers,
Andre.

> Applies to v4.18-rc1.
> 
> Christoffer Dall (4):
>   KVM: arm/arm64: GICv2 IGROUPR should read as zero
>   KVM: arm/arm64: vgic: Add group field to struct irq
>   KVM: arm/arm64: Signal IRQs using their configured group
>   KVM: arm/arm64: vgic: Allow VMs to configure interrupt groups
> 
>  include/kvm/arm_vgic.h           |  1 +
>  include/linux/irqchip/arm-gic.h  |  1 +
>  virt/kvm/arm/vgic/vgic-debug.c   |  8 ++++---
>  virt/kvm/arm/vgic/vgic-init.c    | 11 +++++++--
>  virt/kvm/arm/vgic/vgic-its.c     |  1 +
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  6 +++++
>  virt/kvm/arm/vgic/vgic-v2.c      |  3 +++
>  virt/kvm/arm/vgic/vgic-v3.c      |  6 +----
>  11 files changed, 67 insertions(+), 12 deletions(-)
> 
