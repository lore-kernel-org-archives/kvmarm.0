From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/14] arm/arm64: KVM: Consolidate the PSCI include files
Date: Fri, 26 Jan 2018 18:10:23 +0000
Message-ID: <94c9a057-cb41-a92a-aaca-8b8e95676a32@arm.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com>
 <20180126142847.31240-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BFF949DB5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 13:05:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uAUBoRY2vuXS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jan 2018 13:04:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7FD49D66
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 13:04:59 -0500 (EST)
In-Reply-To: <20180126142847.31240-4-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/01/18 14:28, Marc Zyngier wrote:
> As we're about to update the PSCI support, and because I'm lazy,
> let's move the PSCI include file to include/kvm so that both
> ARM architectures can find it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/psci.h                        | 25 ----------------------
>  arch/arm/kvm/handle_exit.c                         |  2 +-
>  arch/arm64/kvm/handle_exit.c                       |  3 ++-
>  .../asm/kvm_psci.h => include/kvm/arm_psci.h       |  6 +++---
>  virt/kvm/arm/arm.c                                 |  2 +-
>  virt/kvm/arm/psci.c                                |  3 ++-
>  6 files changed, 9 insertions(+), 32 deletions(-)
>  delete mode 100644 arch/arm/include/asm/psci.h
>  rename arch/arm64/include/asm/kvm_psci.h => include/kvm/arm_psci.h (89%)
> 
> diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
> deleted file mode 100644
> index e1b825dfab23..000000000000
> --- a/arch/arm/include/asm/psci.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -/*
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * Copyright (C) 2012 ARM Limited
> - */
> -
> -#ifndef __ASM_ARM_PSCI_H
> -#define __ASM_ARM_PSCI_H
> -
> -extern const struct smp_operations psci_smp_ops;
> -
> -#if defined(CONFIG_SMP) && defined(CONFIG_ARM_PSCI)
> -bool psci_smp_available(void);
> -#else
> -static inline bool psci_smp_available(void) { return false; }
> -#endif
> -
> -#endif /* __ASM_ARM_PSCI_H */

Doh. I deleted the wrong file. That was supposed to be kvm_psci.h, and
not psci.h. Not sure how I managed that one...

	M.
-- 
Jazz is not dead. It just smells funny...
