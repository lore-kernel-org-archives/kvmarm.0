From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH v2 0/6] arm64: Add support of KVM with ACPI
Date: Fri, 19 Feb 2016 00:36:15 -0600
Message-ID: <56C6B7DF.4090606@redhat.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2FC49731
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 01:29:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uVFIAaEqGSjM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2016 01:29:55 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70125496F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2016 01:29:55 -0500 (EST)
In-Reply-To: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 02/11/2016 09:33 AM, Julien Grall wrote:
> Hello,
> 
> This small series allows an ARM64 ACPI based platform to use KVM.
> 
> Currently the KVM code has to parse the firmware table to get the necessary
> information to setup the virtual timer and virtual GIC.
> 
> However the parsing of those tables are already done in the GIC and arch
> timer drivers.
> 
> This patch series introduces different helpers to retrieve the information
> from different drivers avoiding to duplicate the parsing code.
> 
> Note there is patch series ([1] and [2]) adding support of KVM on ACPI,
> although the approach chosen is completely different. The code to parse
> the firmware tables are duplicated which I think make more complex to
> support new firmware tables.

I backported these patches to my internal tree. It booted on an ARM64
machine. Even though I haven't got the chance to test it on an GICv3
machine (will update later), I think you can add my name as Tested-by if
needed.

-Wei

> 
> See the changes since v1 in the different patches.
> 
> Regards,
> 
> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018482.html
> [2] https://lists.cs.columbia.edu/pipermail/kvmarm/2016-February/018355.html
> 
> Julien Grall (6):
>   KVM: arm/arm64: arch_timer: Gather KVM specific information in a
>     structure
>   KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the
>     firmware tables
>   irqchip/gic-v2: Gather ACPI specific data in a single structure
>   irqchip/gic-v2: Parse and export virtual GIC information
>   irqchip/gic-v3: Parse and export virtual GIC information
>   KVM: arm/arm64: vgic: Rely on the GIC driver to parse the firmware
>     tables
> 
>  drivers/clocksource/arm_arch_timer.c   | 11 ++--
>  drivers/irqchip/irq-gic-common.c       | 13 +++++
>  drivers/irqchip/irq-gic-common.h       |  3 ++
>  drivers/irqchip/irq-gic-v3.c           | 36 ++++++++++++++
>  drivers/irqchip/irq-gic.c              | 91 ++++++++++++++++++++++++++++++++--
>  include/clocksource/arm_arch_timer.h   | 13 ++---
>  include/kvm/arm_vgic.h                 |  7 +--
>  include/linux/irqchip/arm-gic-common.h | 34 +++++++++++++
>  virt/kvm/arm/arch_timer.c              | 39 ++++-----------
>  virt/kvm/arm/vgic-v2.c                 | 67 +++++++++----------------
>  virt/kvm/arm/vgic-v3.c                 | 45 +++++------------
>  virt/kvm/arm/vgic.c                    | 50 ++++++++++---------
>  12 files changed, 264 insertions(+), 145 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-gic-common.h
> 
