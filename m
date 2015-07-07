From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC v2 0/6] IRQ bypass manager and irqfd consumer
Date: Tue, 07 Jul 2015 11:17:48 -0600
Message-ID: <1436289468.1391.89.camel@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D926957F3B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 13:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Z-Xjft5TCei for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 13:06:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CE0457F39
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 13:06:20 -0400 (EDT)
In-Reply-To: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, avi.kivity@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2015-07-06 at 14:11 +0200, Eric Auger wrote:
> This series introduces and extends the IRQ bypass manager written
> by Alex and transforms irqfd into an IRQ bypass manager consumer.
> The producer part, in my case the VFIO platform driver will be introduced
> separately. That code should be usable by both ARM IRQ forwarding
> and Intel Posted Interrupts.
> 
> The IRQ bypass manager enables to setup a negotiated link between an
> IRQ producer and an IRQ consumer (typically the VFIO driver and KVM irqfd).
> 
> The series currently includes Alex's code which was sent my email.
> Its structure obvioulsy will adapt to Alex's will.
> 
> Also the irq bypass manager gets compiled/linked on arm/arm64 along
> with KVM and VFIO platform driver.
> 
> can be found at:
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc1-bypass-fwd-v2


Thanks for taking this from a skeleton to a functional implementation,
Eric!  I'm happy with the way this is progressing.  Once we're confident
Feng can use your extensions, I'd be happy to merge those back into the
irq bypass manager and propose it upstream.

Hosting the bypass manager in kernel/irq seemed appropriate, but really
it could be anywhere.  Does anyone have a different preference or
specifically want it under their scope?  We had originally thought of
this as an IOMMU service, but I think we've generalized it beyond that.
I expect we should also add the necessary hooks to turn it into a
loadable module to keep the tinification folks happy, I'll incorporate
the current working changes and post a version with that.  Thanks,

Alex

> History:
> v1 -> v2:
> - isolate the bypass manager and irqfd consumer in this series
> - take into account Paolo's comments and use container_of strategy and
>   remove additional fields introduced in v1.
> - create kvm_irqfd.h
> - add unregistration in irqfd_shutdown
> 
> v1: originally part of [RFC 00/17] ARM IRQ forward control based on IRQ
>     bypass manager (https://lkml.org/lkml/2015/7/2/268)
> 
> 
> Eric Auger (6):
>   KVM: arm/arm64: select IRQ_BYPASS_MANAGER
>   VFIO: platform: select IRQ_BYPASS_MANAGER
>   irq: bypass: Extend skeleton for ARM forwarding control
>   KVM: create kvm_irqfd.h
>   KVM: introduce kvm_arch functions for IRQ bypass
>   KVM: eventfd: add irq bypass consumer management
> 
>  arch/arm/kvm/Kconfig          |   1 +
>  arch/arm64/kvm/Kconfig        |   1 +
>  drivers/vfio/platform/Kconfig |   1 +
>  include/linux/irqbypass.h     |  19 ++++++--
>  include/linux/kvm_host.h      |  37 ++++++++++++++
>  include/linux/kvm_irqfd.h     |  70 +++++++++++++++++++++++++++
>  kernel/irq/bypass.c           |  44 +++++++++++++++--
>  virt/kvm/Kconfig              |   3 ++
>  virt/kvm/eventfd.c            | 109 +++++++++++++-----------------------------
>  9 files changed, 203 insertions(+), 82 deletions(-)
>  create mode 100644 include/linux/kvm_irqfd.h
> 
