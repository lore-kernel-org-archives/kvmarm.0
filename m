From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC 21/55] KVM: arm64: Forward HVC instruction to the guest
 hypervisor
Date: Mon, 26 Jun 2017 11:21:25 -0400
Message-ID: <CAHyh4xjG8_dOOe-eqQmAogDHDnQPCUQ-2Kccz9=6NmL0_+9TAA@mail.gmail.com>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-22-git-send-email-jintack@cs.columbia.edu>
 <20170222114758.GM26976@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170222114758.GM26976@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@linaro.org>
Cc: mark.rutland@arm.com, KVM General <kvm@vger.kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, vladimir.murzin@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kevin.brodsky@arm.com, Eric Auger <eric.auger@redhat.com>, wcohen@redhat.com, anna-maria@linutronix.de, shankerd@codeaurora.org, geoff@infradead.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, james.morse@arm.com, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 22, 2017 at 6:47 AM, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Jan 09, 2017 at 01:24:17AM -0500, Jintack Lim wrote:
>> Forward exceptions due to hvc instruction to the guest hypervisor.
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> ---
>>  arch/arm64/include/asm/kvm_nested.h |  5 +++++
>>  arch/arm64/kvm/Makefile             |  1 +
>>  arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
>>  arch/arm64/kvm/handle_exit_nested.c | 27 +++++++++++++++++++++++++++
>>  4 files changed, 44 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
>>  create mode 100644 arch/arm64/kvm/handle_exit_nested.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>> new file mode 100644
>> index 0000000..620b4d3
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_nested.h
>> @@ -0,0 +1,5 @@
>> +#ifndef __ARM64_KVM_NESTED_H__
>> +#define __ARM64_KVM_NESTED_H__
>> +
>> +int handle_hvc_nested(struct kvm_vcpu *vcpu);
>> +#endif
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index b342bdd..9c35e9a 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -35,4 +35,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>>
>> +kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += handle_exit_nested.o
>>  kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index a891684..208be16 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -29,6 +29,10 @@
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/kvm_psci.h>
>>
>> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
>> +#include <asm/kvm_nested.h>
>> +#endif
>> +
>>  #define CREATE_TRACE_POINTS
>>  #include "trace.h"
>>
>> @@ -42,6 +46,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>                           kvm_vcpu_hvc_get_imm(vcpu));
>>       vcpu->stat.hvc_exit_stat++;
>>
>> +#ifdef CONFIG_KVM_ARM_NESTED_HYP
>> +     ret = handle_hvc_nested(vcpu);
>> +     if (ret < 0 && ret != -EINVAL)
>> +             return ret;
>> +     else if (ret >= 0)
>> +             return ret;
>> +#endif
>>       ret = kvm_psci_call(vcpu);
>>       if (ret < 0) {
>>               kvm_inject_undefined(vcpu);
>> diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
>> new file mode 100644
>> index 0000000..a6ce23b
>> --- /dev/null
>> +++ b/arch/arm64/kvm/handle_exit_nested.c
>> @@ -0,0 +1,27 @@
>> +/*
>> + * Copyright (C) 2016 - Columbia University
>> + * Author: Jintack Lim <jintack@cs.columbia.edu>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +
>> +/* We forward all hvc instruction to the guest hypervisor. */
>> +int handle_hvc_nested(struct kvm_vcpu *vcpu)
>> +{
>> +     return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +}
>
> I don't understand the logic here or in the caller above.  Do we really
> forward *all" hvc calls to the guest hypervisor now, so that we no
> longer support any hypercalls from the VM?  That seems a little rough
> and probably requires some more discussions.

So I think if we run a VM with the EL2 support, then all hvc calls
from the VM should be forwarded to the virtual EL2.

I may miss something obvious, so can you (or anyone) come up with some
cases that the host hypervisor needs to directly handle hvc from the
VM with the EL2 support?

Thanks,
Jintack

>
> Thanks,
> -Christoffer
>
