From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 05/10] KVM: arm: vgic: Fix compiler warnings when
 built for 32-bit
Date: Tue, 13 Sep 2016 10:51:53 +0200
Message-ID: <20160913085153.GF5680@cbox>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-6-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BCF749B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8uxX8U8yNRnw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 04:40:33 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1A9649B71
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 04:40:31 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id i130so19720578wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 01:49:15 -0700 (PDT)
Content-Disposition: inline
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
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 12, 2016 at 03:49:19PM +0100, Vladimir Murzin wrote:
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

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
