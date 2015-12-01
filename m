From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 02/21] arm64: KVM: Add a HYP-specific header file
Date: Tue, 01 Dec 2015 11:41:08 +0000
Message-ID: <565D8754.4030703@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-3-git-send-email-marc.zyngier@arm.com> <20151130200016.GG11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151130200016.GG11704@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/11/15 20:00, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:49:56PM +0000, Marc Zyngier wrote:
>> In order to expose the various EL2 services that are private to
>> the hypervisor, add a new hyp.h file.
>>
>> So far, it only contains mundane things such as section annotation
>> and VA manipulation.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/hyp.h | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>  create mode 100644 arch/arm64/kvm/hyp/hyp.h
>>
>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> new file mode 100644
>> index 0000000..dac843e
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -0,0 +1,31 @@
>> +/*
>> + * Copyright (C) 2015 - ARM Ltd
>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
>> +#ifndef __ARM64_KVM_HYP_H__
>> +#define __ARM64_KVM_HYP_H__
>> +
>> +#include <linux/compiler.h>
>> +#include <linux/kvm_host.h>
>> +#include <asm/kvm_mmu.h>
>> +#include <asm/sysreg.h>
>> +
>> +#define __hyp_text __section(.hyp.text) notrace
> 
> why notrace?

Because you'd end with calls to mcount in each function prologue, and
that doesn't really well for stuff that is not executed in the kernel
address space.

>> +
>> +#define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
> 
> should you have parenthesis around 'v' ?

Yup.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
