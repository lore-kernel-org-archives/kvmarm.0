From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 07/18] arm64: KVM/mm: Move SEA handling behind a single
 'claim' interface
Date: Fri, 12 Oct 2018 18:18:28 +0100
Message-ID: <6cd00d26-df00-b5d9-5144-073672efe87a@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-8-james.morse@arm.com> <20181012100212.GA580@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 523A44A20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 13:18:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wKC3zBKn-H-t for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 13:18:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26D9749E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 13:18:33 -0400 (EDT)
In-Reply-To: <20181012100212.GA580@zn.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 12/10/2018 11:02, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 11:16:54PM +0100, James Morse wrote:
>> To split up APEIs in_nmi() path, we need the nmi-like callers to always
>> be in_nmi(). Add a helper to do the work and claim the notification.
>>
>> When KVM or the arch code takes an exception that might be a RAS
>> notification, it asks the APEI firmware-first code whether it wants
>> to claim the exception. We can then go on to see if (a future)
>> kernel-first mechanism wants to claim the notification, before
>> falling through to the existing default behaviour.
>>
>> The NOTIFY_SEA code was merged before we had multiple, possibly
>> interacting, NMI-like notifications and the need to consider kernel
>> first in the future. Make the 'claiming' behaviour explicit.
>>
>> As we're restructuring the APEI code to allow multiple NMI-like
>> notifications, any notification that might interrupt interrupts-masked
>> code must always be wrapped in nmi_enter()/nmi_exit(). This allows APEI
>> to use in_nmi() to use the right fixmap entries.
>>
>> We mask SError over this window to prevent an asynchronous RAS error
>> arriving and tripping 'nmi_enter()'s BUG_ON(in_nmi()).

>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index ed46dc188b22..a9b8bba014b5 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -257,3 +259,30 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
>>  		return __pgprot(PROT_NORMAL_NC);
>>  	return __pgprot(PROT_DEVICE_nGnRnE);
>>  }
>> +
>> +/*
>> + * Claim Synchronous External Aborts as a firmware first notification.
>> + *
>> + * Used by KVM and the arch do_sea handler.
>> + * @regs may be NULL when called from process context.
>> + */
>> +int apei_claim_sea(struct pt_regs *regs)
>> +{
>> +	int err = -ENOENT;
>> +	unsigned long current_flags = arch_local_save_flags();
>> +
>> +	if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA))
>> +		return err;
> 
> I don't know what side effects arch_local_save_flags() has on ARM but if

It reads the current 'masked' state for IRQs, debug exceptions and 'SError'.


> we return here, it looks to me like useless work.

Yes. I lazily assume the compiler will rip that out as the value is never used.
But in this case it can't, because its wrapped in asm-volatile, so it doesn't
know it has no side-effects.

I'll move it further down.

Thanks!

James
