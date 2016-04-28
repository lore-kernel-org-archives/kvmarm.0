From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 00/10] arm64: Add support for KVM with ACPI
Date: Thu, 28 Apr 2016 14:13:23 +0100
Message-ID: <57220C73.7010900@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: christoffer.dall@linaro.org, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

[+ Thomas, Jason]

Do you have any objection against this going through the KVM tree? The
dependencies are rather intricate, and Daniel gave us his green light
already for the clocksource part.

If you'd rather maintain the usual flow, please let us know and we'll
deal with it.

Thanks,

	M.

On 11/04/16 16:32, Julien Grall wrote:
> Hello,
> 
> This patch series allows KVM to work with ACPI on ARM64.
> 
> Currently, the firmware tables are parsed by the the virtual timer and virtual
> GIC code in order to configure them correctly.
> 
> However the parsing of these tables is already done in the GIC and arch timer
> drivers. This patch series introduces new helpers to retrieve the information
> from the different drivers in order to avoid duplication of the parsing code.
> 
> To make the merge easier via the different trees, each patch modifies a single
> subsystem. The suggested plan to merge the series is divided in 3 steps:
> 
> 1) Patches #1-#2 are merged via the clocksource tree
>    Patches #2-#7 are merged via the irqchip tree
> 2) Patches #8-#9 are merge via the KVM tree
> 3) Patch #10 is merged via the clocksource tree.
> 
> For all the changes see in each patch.
> 
> Regards,
> 
> 
> Julien Grall (10):
>   clocksource: arm_arch_timer: Gather KVM specific information in a
>     structure
>   clocksource: arm_arch_timer: Extend arch_timer_kvm_info to get the
>     virtual IRQ
>   irqchip/gic-v2: Gather ACPI specific data in a single structure
>   irqchip/gic-v2: Parse and export virtual GIC information
>   irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
>   irqchip/gic-v3: Gather all ACPI specific data in a single structure
>   irqchip/gic-v3: Parse and export virtual GIC information
>   KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the
>     firmware tables
>   KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware
>     tables
>   clocksource: arm_arch_timer: Remove arch_timer_get_timecounter
> 
>  drivers/clocksource/arm_arch_timer.c   |  11 ++-
>  drivers/irqchip/irq-gic-common.c       |  13 +++
>  drivers/irqchip/irq-gic-common.h       |   3 +
>  drivers/irqchip/irq-gic-v3.c           | 176 +++++++++++++++++++++++++++------
>  drivers/irqchip/irq-gic.c              |  87 +++++++++++++++-
>  include/clocksource/arm_arch_timer.h   |  12 +--
>  include/kvm/arm_vgic.h                 |   7 +-
>  include/linux/irqchip/arm-gic-common.h |  34 +++++++
>  virt/kvm/arm/arch_timer.c              |  40 +++-----
>  virt/kvm/arm/vgic-v2.c                 |  61 +++++-------
>  virt/kvm/arm/vgic-v3.c                 |  47 +++------
>  virt/kvm/arm/vgic.c                    |  50 +++++-----
>  12 files changed, 377 insertions(+), 164 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-gic-common.h
> 


-- 
Jazz is not dead. It just smells funny...
