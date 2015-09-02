From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/10] ARM IRQ forward control based on IRQ bypass
 manager
Date: Wed, 2 Sep 2015 21:58:32 +0200
Message-ID: <20150902195832.GX10991@cbox>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98BFC412DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 15:56:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WFosIfU-weB4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 15:56:45 -0400 (EDT)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
 [209.85.217.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CA0B412F2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 15:56:45 -0400 (EDT)
Received: by lbpo4 with SMTP id o4so12660715lbp.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Sep 2015 12:57:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 03:20:54PM +0200, Eric Auger wrote:
> This series allows to set ARM IRQ forwarding between a VFIO platform
> device physical IRQ and a guest virtual IRQ. The link is coordinated
> by the IRQ bypass manager.
> 
> The principle is the VFIO platform driver registers an IRQ bypass producer
> struct on VFIO_IRQ_SET_ACTION_TRIGGER while KVM irqfd registers a consumer
> struct on the irqfd assignment. This leads to a handshake based on the
> eventfd context (used as token) match. When either of the producer/consumer
> disappears, an unregistration occurs and the link is disconnected.
> 
> This kernel integration deprecates the former kvm-vfio approach:
> https://lkml.org/lkml/2015/4/13/353. Some rationale about that change can
> be found in IRQ bypass manager thread: https://lkml.org/lkml/2015/6/29/268
> 
> Dependencies:
> 1- [PATCH v4 00/11] arm/arm64: KVM: Active interrupt state switching
>    for shared devices (http://www.spinics.net/lists/arm-kernel/msg437884.html)
>    except PATCH 11
> 2- [PATCH 0/6] irqchip: GICv2/v3: Add support for irq_vcpu_affinity
> 3- [PATCH v4] virt: IRQ bypass manager (https://lkml.org/lkml/2015/8/6/526)
> 4- [PATCH 0/2] KVM: arm/arm64: Guest synchronous halt/resume
>    (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg950942.html)
> 
> All those pieces can be found at:
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc6-irq-forward-v3
> 
> More backgroung on ARM IRQ forwarding in the text below and at
> http://www.linux-kvm.org/images/a/a8/01x04-ARMdevice.pdf.
> 
> A forwarded IRQ is deactivated by the guest and not by the host.
> When the guest deactivates the associated virtual IRQ, the interrupt
> controller automatically completes the physical IRQ. Obviously
> this requires some HW support in the interrupt controller. This is
> the case for ARM GICv2.
> 
> The direct benefit is that, for a level sensitive IRQ, a VM exit
> can be avoided on forwarded IRQ completion.

Would there be any benefit for edge-triggered IRQs in that another
physical IRQ won't hit before the guest is done processing the original
IRQ, potentially reducing guest interrupt handling latency?

-Christoffer

> 
> When the IRQ is forwarded, the VFIO platform driver does not need to
> mask the physical IRQ anymore before signaling the eventfd. Indeed
> genirq lowers the running priority, enabling other physical IRQ to hit
> except that one.
> 
> Besides, the injection still is based on irqfd triggering. The only
> impact on irqfd process is resamplefd is not called anymore on
> virtual IRQ completion since deactivation is not trapped by KVM.
> 
> This was tested on Calxeda Midway, assigning the xgmac main IRQ
> 
> History:
> 
> v2 (RFC) -> v3(PATCH):
> - all dependencies now have a patch status
> - we dropped the producer active boolean exchanged between the
>   VFIO producer and irqfd arm consumer. As a consequence, on
>   unforward, if the IRQ is active, this latter is deactivated
>   without VFIO-masking it. So we do not exactly come back to the
>   exact state where we would be in unforwarded state. A new
>   physical IRQ can hit while the previous virtual IRQ is under
>   treatment. Its injection in the guest may be rejected thanks
>   to the VGIC state machine. This IRQ will be lost but I don't
>   think this is a severe issue. In case no new IRQ hits, the
>   guest deactivation of the virtual IRQ will trigger the resamplefd
>   which will VFIO unmask the non-masked IRQ. This also has no
>   consequence.
> - VFIO platform driver consumer_add now can fail. It rejects the
>   transition for forwarding state in case the IRQ is active
> - the series is rebased on new irq_vcpu_affinity series
> - no dependency anymore on "chip/vgic adaptations for forwarded irq"
>   which was partially integrated into Marc's series. A fix is still
>   needed through.
> - Guest synchronous halt/resume patch re-integrated into this series
> - integrate a new patch file coming mixing
>   [PATCH v4 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
>                    non-shared devices &
>   [RFC v2 2/4] KVM: arm: vgic: fix state machine for forwarded IRQ
> 
> v1 -> v2:
> - irq bypass manager and irqfd consumer moved in a separate patch
> - kvm_arm_[halt,resume]_guest moved in a separate patch
> - remove VFIO external functions since we do not need them anymore
> - apply container_of strategy advised by Paolo. Only active field
>   remains and discussions will tell whether we get rid of it.
> - renamed kvm_arch functions
> 
> - kvm-vfio v6 -> RFC v1 based on IRQ bypass manager
>   see previous history in https://lkml.org/lkml/2015/4/13/353).
> 
> Best Regards
> 
> Eric
> 
> 
> Eric Auger (9):
>   VFIO: platform: registration of a dummy IRQ bypass producer
>   VFIO: platform: test forwarded state when selecting the IRQ handler
>   VFIO: platform: single handler using function pointer
>   VFIO: platform: add vfio_platform_set_automasked
>   VFIO: platform: add vfio_platform_is_active
>   VFIO: platform: add irq bypass producer management
>   KVM: arm/arm64: vgic: support irqfd injection of a forwarded IRQ
>   KVM: arm/arm64: vgic: forwarding control
>   KVM: arm/arm64: implement IRQ bypass consumer functions
> 
> Marc Zyngier (1):
>   KVM: arm/arm64: vgic: Allow HW interrupts for non-shared devices
> 
>  arch/arm/kvm/Kconfig                          |   1 +
>  arch/arm/kvm/arm.c                            |  35 +++++
>  arch/arm64/kvm/Kconfig                        |   1 +
>  drivers/vfio/platform/vfio_platform_irq.c     | 113 +++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |   4 +
>  include/kvm/arm_vgic.h                        |  12 +-
>  virt/kvm/arm/arch_timer.c                     |   3 +-
>  virt/kvm/arm/vgic.c                           | 215 ++++++++++++++++++++++++--
>  8 files changed, 358 insertions(+), 26 deletions(-)
> 
> -- 
> 1.9.1
> 
