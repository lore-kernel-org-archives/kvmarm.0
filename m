From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/10] KVM: arm: vgic: Fix compiler warnings when built
 for 32-bit
Date: Thu, 22 Sep 2016 11:01:40 +0100
Message-ID: <57E3AC04.1070101@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-6-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138E449B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:52:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ocJfVqEy37vS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 05:52:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A54F40F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 05:52:34 -0400 (EDT)
In-Reply-To: <1473691764-29424-6-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/09/16 15:49, Vladimir Murzin wrote:
> Well, this patch is looking ahead of time, but we'll get following
> compiler warnings as soon as we introduce vgic-v3 to 32-bit world
> 
>   CC      arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.o
> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c: In function 'vgic_mmio_read_v3r_typer':
> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:184:35: warning: left shift count >= width of type [-Wshift-count-overflow]
>   value = (mpidr & GENMASK(23, 0)) << 32;
>                                    ^
> In file included from ./include/linux/kernel.h:10:0,
>                  from ./include/asm-generic/bug.h:13,
>                  from ./arch/arm/include/asm/bug.h:59,
>                  from ./include/linux/bug.h:4,
>                  from ./include/linux/io.h:23,
>                  from ./arch/arm/include/asm/arch_gicv3.h:23,
>                  from ./include/linux/irqchip/arm-gic-v3.h:411,
>                  from arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:14:
> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c: In function 'vgic_v3_dispatch_sgi':
> ./include/linux/bitops.h:6:24: warning: left shift count >= width of type [-Wshift-count-overflow]
>  #define BIT(nr)   (1UL << (nr))
>                         ^
> arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:614:20: note: in expansion of macro 'BIT'
>   broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
>                     ^
> Let's fix them now.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
