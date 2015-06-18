From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 00/10] arm/arm64: KVM: Active interrupt state switching
 for shared devices
Date: Thu, 18 Jun 2015 08:51:06 +0200
Message-ID: <55826A5A.3010204@linaro.org>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 382FB55F25
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 02:40:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+PnHyLU6hIl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 02:40:44 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25AC755E34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 02:40:44 -0400 (EDT)
Received: by wicnd19 with SMTP id nd19so12684540wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 23:51:23 -0700 (PDT)
In-Reply-To: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

I tested your series on Calxeda Midway (shared device path)
Tested-by: Eric Auger <eric.auger@linaro.org>. No exotic migration use
case though.

I also exercised the non-shared device path. As already discussed some
adaptations where needed in vgic state machine.

If anyone is interested, the rebase with EOIMode == 1 + vgic/irqchip
adaptations + kvm-vfio series can be found at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.1-rc6-state-switch-forward.
Tested with Calxeda midway xgmac passthrough.

Eric

On 06/08/2015 07:03 PM, Marc Zyngier wrote:
> From day 1, our timer code has been using a terrible hack: whenever
> the guest is scheduled with a timer interrupt pending (i.e. the HW
> timer has expired), we restore the timer state with the MASK bit set,
> in order to avoid the physical interrupt to fire again. And again. And
> again...
> 
> This is absolutely silly, for at least two reasons:
> 
> - This relies on the device (the timer) having a mask bit that we can
>   play with. Not all devices are built like this.
> 
> - This expects some behaviour of the guest that only works because the
>   both the kernel timer code and the KVM counterpart have been written
>   by the same idiot (the idiot being me).
> 
> The One True Way is to set the GIC active bit when injecting the
> interrupt, and to context-switch across the world switch. This is what
> this series implements.
> 
> We introduce a relatively simple infrastructure enabling the mapping
> of a virtual interrupt with its physical counterpart:
> 
> - Whenever an virtual interrupt is injected, we look it up in an
>   rbtree. If we have a match, the interrupt is injected with the HW
>   bit set in the LR, together with the physical interrupt.
> 
> - Across the world switch, we save/restore the active state for these
>   interrupts using the irqchip_state API.
> 
> - On guest EOI, the HW interrupt is automagically deactivated by the
>   GIC, allowing the interrupt to be resampled.
> 
> The timer code is slightly modified to set the active state at the
> same time as the injection.
> 
> The last patch also allows non-shared devices to have their interrupt
> deactivated the same way (in this case we do not context-switch the
> active state). This is the first step in the long overdue direction of
> the mythical IRQ forwarding thing...
> 
> This series is based on v4.1-rc7, and has been tested on Juno (GICv2)
> and the FVP Base model (GICv3 host, both GICv2 and GICv3 guests). I'd
> appreciate any form of testing, specially in the context of guest
> migration (there is obviously some interesting stuff there...).
> 
> The code is otherwise available at
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/active-timer
> 
> Marc Zyngier (10):
>   arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
>   arm/arm64: KVM: Move vgic handling to a non-preemptible section
>   KVM: arm/arm64: vgic: Convert struct vgic_lr to use bitfields
>   KVM: arm/arm64: vgic: Allow HW irq to be encoded in LR
>   KVM: arm/arm64: vgic: Relax vgic_can_sample_irq for edge IRQs
>   KVM: arm/arm64: vgic: Allow dynamic mapping of physical/virtual
>     interrupts
>   KVM: arm/arm64: vgic: Allow HW interrupts to be queued to a guest
>   KVM: arm/arm64: vgic: Add vgic_{get,set}_phys_irq_active
>   KVM: arm/arm64: timer: Allow the timer to control the active state
>   KVM: arm/arm64: vgic: Allow non-shared device HW interrupts
> 
>  arch/arm/kvm/arm.c                 |  21 +++-
>  include/kvm/arm_arch_timer.h       |   3 +
>  include/kvm/arm_vgic.h             |  31 +++++-
>  include/linux/irqchip/arm-gic-v3.h |   3 +
>  include/linux/irqchip/arm-gic.h    |   3 +-
>  virt/kvm/arm/arch_timer.c          |  13 ++-
>  virt/kvm/arm/vgic-v2.c             |  16 ++-
>  virt/kvm/arm/vgic-v3.c             |  21 +++-
>  virt/kvm/arm/vgic.c                | 206 ++++++++++++++++++++++++++++++++++++-
>  9 files changed, 300 insertions(+), 17 deletions(-)
> 
