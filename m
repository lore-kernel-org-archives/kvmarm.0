From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 21/55] KVM: arm64: Forward HVC instruction to the guest
 hypervisor
Date: Wed, 22 Feb 2017 12:47:58 +0100
Message-ID: <20170222114758.GM26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E127D40C22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:47:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AVk3SIzbxnGy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 06:47:14 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2529C40BE9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:47:13 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id v77so95274wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 03:48:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:17AM -0500, Jintack Lim wrote:
> Forward exceptions due to hvc instruction to the guest hypervisor.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  5 +++++
>  arch/arm64/kvm/Makefile             |  1 +
>  arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
>  arch/arm64/kvm/handle_exit_nested.c | 27 +++++++++++++++++++++++++++
>  4 files changed, 44 insertions(+)
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/kvm/handle_exit_nested.c
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> new file mode 100644
> index 0000000..620b4d3
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -0,0 +1,5 @@
> +#ifndef __ARM64_KVM_NESTED_H__
> +#define __ARM64_KVM_NESTED_H__
> +
> +int handle_hvc_nested(struct kvm_vcpu *vcpu);
> +#endif
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index b342bdd..9c35e9a 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -35,4 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>  
> +kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += handle_exit_nested.o
>  kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index a891684..208be16 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -29,6 +29,10 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_psci.h>
>  
> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
> +#include <asm/kvm_nested.h>
> +#endif
> +
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>  
> @@ -42,6 +46,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			    kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
> +	ret = handle_hvc_nested(vcpu);
> +	if (ret < 0 && ret != -EINVAL)
> +		return ret;
> +	else if (ret >= 0)
> +		return ret;
> +#endif
>  	ret = kvm_psci_call(vcpu);
>  	if (ret < 0) {
>  		kvm_inject_undefined(vcpu);
> diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
> new file mode 100644
> index 0000000..a6ce23b
> --- /dev/null
> +++ b/arch/arm64/kvm/handle_exit_nested.c
> @@ -0,0 +1,27 @@
> +/*
> + * Copyright (C) 2016 - Columbia University
> + * Author: Jintack Lim <jintack@cs.columbia.edu>
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
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +
> +/* We forward all hvc instruction to the guest hypervisor. */
> +int handle_hvc_nested(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +}

I don't understand the logic here or in the caller above.  Do we really
forward *all" hvc calls to the guest hypervisor now, so that we no
longer support any hypercalls from the VM?  That seems a little rough
and probably requires some more discussions.

Thanks,
-Christoffer
