From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 47/54] KVM: arm/arm64: vgic-new: vgic_init: implement
 kvm_vgic_hyp_init
Date: Tue, 3 May 2016 16:35:49 +0100
Message-ID: <5728C555.3080008@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-48-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 313F049BC1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 11:33:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dkh7i1nhIczZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 11:33:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 474E949B93
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 11:33:16 -0400 (EDT)
In-Reply-To: <1461861973-26464-48-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:46, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Implements kvm_vgic_hyp_init and vgic_probe function.
> 
> The vgic_global struct is enriched with new fields populated
> by those functions.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - rename vgic_init.c to vgic-init.c
> 
>  include/kvm/vgic/vgic.h       |   1 +
>  virt/kvm/arm/vgic/vgic-init.c | 122 ++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c   |  90 +++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c   |  74 +++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      |   6 +++
>  5 files changed, 293 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-init.c
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index cfc3640..d144e3d 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -202,6 +202,7 @@ struct vgic_cpu {
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> +int kvm_vgic_hyp_init(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> new file mode 100644
> index 0000000..d7c50bb
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -0,0 +1,122 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/uaccess.h>
> +#include <linux/interrupt.h>
> +#include <linux/cpu.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/vgic/vgic.h>

Same issue here as well.

	M.
-- 
Jazz is not dead. It just smells funny...
