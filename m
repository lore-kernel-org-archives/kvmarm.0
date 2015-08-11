From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 0/6] irqchip: GICv2/v3: Add support for irq_vcpu_affinity
Date: Tue, 11 Aug 2015 12:06:49 +0200
Message-ID: <55C9C939.2020408@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57A1B5A675
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:54:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0sWzFzMxakrh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 05:54:29 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12CF35A585
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 05:54:29 -0400 (EDT)
Received: by wijp15 with SMTP id p15so169423623wij.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 03:07:31 -0700 (PDT)
In-Reply-To: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

The series works fine with KVM platform device passthrough use case
(Calxeda Midway, GICv2, SPI assignment with VFIO). My integration branch
can be found at
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc6-irq-forward-v3
if useful.

Tested-by: Eric Auger <eric.auger@linaro.org>

Best Regards

Eric
On 07/09/2015 03:19 PM, Marc Zyngier wrote:
> The GICv2 and GICv3 architectures allow an active physical interrupt
> to be forwarded to a guest, and the guest to indirectly perform the
> deactivation of the interrupt by performing an EOI on the virtual
> interrupt (see for example the GICv2 spec, 3.2.1).
> 
> This allows some substantial performance improvement for level
> triggered interrupts that otherwise have to be masked/unmasked in
> VFIO, not to mention the required trap back to KVM when the guest
> performs an EOI.
> 
> To enable this, the GICs need to be switched to a different EOImode,
> where a taken interrupt can be left "active" (which prevents the same
> interrupt from being taken again), while other interrupts are still
> being processed normally.
> 
> We also use the new irq_set_vcpu_affinity hook that was introduced for
> Intel's "Posted Interrupts" to determine whether or not to perform the
> deactivation at EOI-time.
> 
> As all of this only makes sense when the kernel can behave as a
> hypervisor, we only enable this mode on detecting that the kernel was
> actually booted in HYP mode, and that the GIC supports this feature.
> 
> This series is a complete rework of a RFC I sent over a year ago:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266328.html
> 
> Since then, a lot has been either merged (the irqchip_state) or reworked
> (my active-timer series: http://www.spinics.net/lists/kvm/msg118768.html),
> and this implements the last few bits for Eric Auger's series to
> finally make it into the kernel:
> 
> https://lkml.org/lkml/2015/7/2/268
> https://lkml.org/lkml/2015/7/6/291
> 
> With all these patches combined, physical interrupt routing from the
> kernel into a VM becomes possible.
> 
> This has been tested on Juno (GICv2) and FastModel (GICv3). A branch
> is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/gic-irq-vcpu-affinity
> 
> Marc Zyngier (6):
>   irqchip: GICv3: Convert to EOImode == 1
>   irqchip: GIC: Convert to EOImode == 1
>   irqchip: GICv3: Skip LPI deactivation
>   irqchip: GIC: Use chip_data instead of handler_data for cascaded
>     interrupts
>   irqchip: GICv3: Don't deactivate interrupts forwarded to a guest
>   irqchip: GIC: Don't deactivate interrupts forwarded to a guest
> 
>  drivers/irqchip/irq-gic-v3.c       | 57 +++++++++++++++++++++++++++++++--
>  drivers/irqchip/irq-gic.c          | 64 +++++++++++++++++++++++++++++++++++---
>  include/linux/irqchip/arm-gic-v3.h |  9 ++++++
>  include/linux/irqchip/arm-gic.h    |  4 +++
>  4 files changed, 126 insertions(+), 8 deletions(-)
> 
