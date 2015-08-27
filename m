From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 0/4] irqchip: GICv2/v3: Add support for irq_vcpu_affinity
Date: Thu, 27 Aug 2015 15:03:12 +0200
Message-ID: <55DF0A90.9010407@linaro.org>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

I tested the series on Calxeda Midway with VFIO use case. Also reviewed
it again without finding anything new.

Tested-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Eric Auger <eric.auger@linaro.org>

Best Regards

Eric


On 08/26/2015 06:00 PM, Marc Zyngier wrote:
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
> Note that the implementation makes use of the static_key mechanism,
> which is undergoing an extensive rework in 4.3. I intend to convert
> this code once both are in mainline.
> 
> This has been tested on Juno (GICv2) and FastModel (GICv3). A branch
> is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/gic-irq-vcpu-affinity-v4
> 
> * From v3:
>   - Use separate irq_chip structures, leading to much nicer code (tglx)
>   - Dropped Eric's Tested/Reviewed-by as there is significant changes
> 
> * From v2:
>   - Another small fix from Eric
>   - Some commit message cleanups
> 
> * From v1:
>   - Fixes after review from Eric
>   - Got rid of the cascaded GICv2 hack (it was broken anyway)
>   - Folded the LPI deactivation patch (it makes more sense as part of
>     the main one.
>   - Some clarifying comments about the "deactivate on mask"
>   - I haven't retained Eric's Reviewed/Tested-by, as the code as
>     significantly changed on GICv2
> 
> Marc Zyngier (4):
>   irqchip: GICv3: Convert to EOImode == 1
>   irqchip: GICv3: Don't deactivate interrupts forwarded to a guest
>   irqchip: GIC: Convert to EOImode == 1
>   irqchip: GIC: Don't deactivate interrupts forwarded to a guest
> 
>  drivers/irqchip/irq-gic-v3.c       |  70 +++++++++++++++++++++--
>  drivers/irqchip/irq-gic.c          | 111 ++++++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-v3.h |   9 +++
>  include/linux/irqchip/arm-gic.h    |   4 ++
>  4 files changed, 188 insertions(+), 6 deletions(-)
> 
