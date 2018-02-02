From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 04/18] arm/arm64: KVM: Consolidate the PSCI include
 files
Date: Fri, 2 Feb 2018 13:33:09 +0100
Message-ID: <20180202123309.GG21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-5-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:43AM +0000, Marc Zyngier wrote:
> As we're about to update the PSCI support, and because I'm lazy,
> let's move the PSCI include file to include/kvm so that both
> ARM architectures can find it.
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_psci.h                    | 27 ----------------------
>  arch/arm/kvm/handle_exit.c                         |  2 +-
>  arch/arm64/kvm/handle_exit.c                       |  3 ++-
>  .../asm/kvm_psci.h => include/kvm/arm_psci.h       |  6 ++---
>  virt/kvm/arm/arm.c                                 |  2 +-
>  virt/kvm/arm/psci.c                                |  3 ++-
>  6 files changed, 9 insertions(+), 34 deletions(-)
>  delete mode 100644 arch/arm/include/asm/kvm_psci.h
>  rename arch/arm64/include/asm/kvm_psci.h => include/kvm/arm_psci.h (89%)
> 
> diff --git a/arch/arm/include/asm/kvm_psci.h b/arch/arm/include/asm/kvm_psci.h
> deleted file mode 100644
> index 6bda945d31fa..000000000000
> --- a/arch/arm/include/asm/kvm_psci.h
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -/*
> - * Copyright (C) 2012 - ARM Ltd
> - * Author: Marc Zyngier <marc.zyngier@arm.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -
> -#ifndef __ARM_KVM_PSCI_H__
> -#define __ARM_KVM_PSCI_H__
> -
> -#define KVM_ARM_PSCI_0_1	1
> -#define KVM_ARM_PSCI_0_2	2
> -
> -int kvm_psci_version(struct kvm_vcpu *vcpu);
> -int kvm_psci_call(struct kvm_vcpu *vcpu);
> -
> -#endif /* __ARM_KVM_PSCI_H__ */
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index a4bf0f6f024a..230ae4079108 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -21,7 +21,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_mmu.h>
> -#include <asm/kvm_psci.h>
> +#include <kvm/arm_psci.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 5493bbefbd0d..588f910632a7 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -22,13 +22,14 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  
> +#include <kvm/arm_psci.h>
> +
>  #include <asm/esr.h>
>  #include <asm/exception.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> -#include <asm/kvm_psci.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/traps.h>
>  
> diff --git a/arch/arm64/include/asm/kvm_psci.h b/include/kvm/arm_psci.h
> similarity index 89%
> rename from arch/arm64/include/asm/kvm_psci.h
> rename to include/kvm/arm_psci.h
> index bc39e557c56c..2042bb909474 100644
> --- a/arch/arm64/include/asm/kvm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -15,8 +15,8 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> -#ifndef __ARM64_KVM_PSCI_H__
> -#define __ARM64_KVM_PSCI_H__
> +#ifndef __KVM_ARM_PSCI_H__
> +#define __KVM_ARM_PSCI_H__
>  
>  #define KVM_ARM_PSCI_0_1	1
>  #define KVM_ARM_PSCI_0_2	2
> @@ -24,4 +24,4 @@
>  int kvm_psci_version(struct kvm_vcpu *vcpu);
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
>  
> -#endif /* __ARM64_KVM_PSCI_H__ */
> +#endif /* __KVM_ARM_PSCI_H__ */
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 15bf026eb182..af3e98fc377e 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -31,6 +31,7 @@
>  #include <linux/irqbypass.h>
>  #include <trace/events/kvm.h>
>  #include <kvm/arm_pmu.h>
> +#include <kvm/arm_psci.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -46,7 +47,6 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_coproc.h>
> -#include <asm/kvm_psci.h>
>  #include <asm/sections.h>
>  
>  #ifdef REQUIRES_VIRT
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index f1e363bab5e8..b322e46fd142 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -21,9 +21,10 @@
>  
>  #include <asm/cputype.h>
>  #include <asm/kvm_emulate.h>
> -#include <asm/kvm_psci.h>
>  #include <asm/kvm_host.h>
>  
> +#include <kvm/arm_psci.h>
> +
>  #include <uapi/linux/psci.h>
>  
>  /*
> -- 
> 2.14.2
> 
