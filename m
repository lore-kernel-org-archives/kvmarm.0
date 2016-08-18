From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL 00/12] KVM/ARM Fixes for v4.8-rc3
Date: Thu, 18 Aug 2016 12:19:41 +0200
Message-ID: <3b5c3520-da99-e255-6961-2d2706f39c81@redhat.com>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 288AF40C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 06:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mgteIQKBIs2A for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2016 06:12:14 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3A6C40C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 06:12:13 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id o80so4754204wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2016 03:19:45 -0700 (PDT)
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 17/08/2016 21:38, Christoffer Dall wrote:
> Hi Paolo and Radim,
> 
> Here's a set of KVM/ARM fixes for v4.8-rc3 or as soon as you can make
> it.  They address:
>  - ITS init issues
>  - ITS error handling issues
>  - ITS IRQ leakage fix
>  - Plug a couple of ITS race conditions
>  - An erratum workaround for timers
>  - Some removal of misleading use of errors and comments
>  - A fix for GICv3 on 32-bit guests
> 
> Note that the patch previously submitted 'KVM: arm64: vgic-its: Grab
> kvm->lock when reading kvm->devices', was dropped from this series
> because we were already holding the kvm->lock in the call path to the
> ITS code.
> 
> The following changes since commit 29b4817d4018df78086157ea3a55c1d9424a7cfc:
> 
>   Linux 4.8-rc1 (2016-08-07 18:18:00 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.8-rc3
> 
> for you to fetch changes up to f7f6f2d94f0027242ddfd665289b107a873fde43:
> 
>   arm64: KVM: report configured SRE value to 32-bit world (2016-08-17 12:46:23 +0200)
> 
> Thanks,
> -Christoffer
> 
> ----------------------------------------------------------------
> Andre Przywara (4):
>       KVM: arm64: ITS: return 1 on successful MSI injection
>       KVM: arm64: ITS: move ITS registration into first VCPU run
>       KVM: arm64: check for ITS device on MSI injection
>       KVM: arm64: ITS: avoid re-mapping LPIs
> 
> Christoffer Dall (4):
>       KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
>       KVM: arm64: vgic-its: Plug race in vgic_put_irq
>       KVM: arm64: vgic-its: Make updates to propbaser/pendbaser atomic
>       KVM: arm/arm64: Change misleading use of is_error_pfn
> 
> Marc Zyngier (2):
>       arm64: Document workaround for Cortex-A72 erratum #853709
>       KVM: arm/arm64: timer: Workaround misconfigured timer interrupt
> 
> Vladimir Murzin (2):
>       arm64: KVM: remove misleading comment on pmu status
>       arm64: KVM: report configured SRE value to 32-bit world
> 
>  Documentation/arm64/silicon-errata.txt |   1 +
>  arch/arm/kvm/mmu.c                     |   2 +-
>  arch/arm64/kvm/hyp/switch.c            |   2 +-
>  arch/arm64/kvm/sys_regs.c              |  10 +--
>  include/linux/irqchip/arm-gic-v3.h     |   1 +
>  virt/kvm/arm/arch_timer.c              |  11 ++-
>  virt/kvm/arm/vgic/vgic-its.c           | 158 ++++++++++++++++++++++++---------
>  virt/kvm/arm/vgic/vgic-mmio-v3.c       |  26 +++---
>  virt/kvm/arm/vgic/vgic-v3.c            |   8 ++
>  virt/kvm/arm/vgic/vgic.c               |  10 +--
>  virt/kvm/arm/vgic/vgic.h               |   6 ++
>  11 files changed, 164 insertions(+), 71 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Pulled, thanks.

Paolo
