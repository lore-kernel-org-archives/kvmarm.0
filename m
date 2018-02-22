From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 06/11] ACPI / APEI: Make the fixmap_idx per-ghes to allow
 multiple in_nmi() users
Date: Thu, 22 Feb 2018 17:47:28 +0000
Message-ID: <5A8F0230.1080007@arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-7-james.morse@arm.com>
 <879ab426-c6a9-b881-e3d5-a605cfad5f97@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <879ab426-c6a9-b881-e3d5-a605cfad5f97@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tyler

Thanks for taking a look!


On 20/02/18 21:18, Tyler Baicar wrote:
> On 2/15/2018 1:56 PM, James Morse wrote:
>> Arm64 has multiple NMI-like notifications, but GHES only has one
>> in_nmi() path. The interactions between these multiple NMI-like
>> notifications is, unclear.
>>
>> Split this single path up by moving the fixmap idx and lock into
>> the struct ghes. Each notification's init function can consider
>> which other notifications it masks and can share a fixmap_idx with.
>> This lets us merge the two ghes_ioremap_pfn_* flavours.
>>
>> Two lock pointers are provided, but only one will be used by
>> ghes_copy_tofrom_phys(), depending on in_nmi(). This means any
>> notification that might arrive as an NMI must always be wrapped in
>> nmi_enter()/nmi_exit().
>>
>> The double-underscore version of fix_to_virt() is used because
>> the index to be mapped can't be tested against the end of the
>> enum at compile time.

>> @@ -303,13 +278,11 @@ static void ghes_copy_tofrom_phys(void *buffer, u64
>> paddr, u32 len,
>>         while (len > 0) {
>>           offset = paddr - (paddr & PAGE_MASK);
>> -        if (in_nmi) {
>> -            raw_spin_lock(&ghes_ioremap_lock_nmi);
>> -            vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
>> -        } else {
>> -            spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
>> -            vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
>> -        }
>> +        if (in_nmi)
>> +            raw_spin_lock(ghes->nmi_fixmap_lock);
>> +        else
>> +            spin_lock_irqsave(ghes->fixmap_lock, flags);

> This locking is resulting in a NULL pointer dereference for me during boot time.
> I removed the ghes_proc() call
> from ghes_probe() and then when triggering errors and going through ghes_proc()
> the NULL pointer dereference
> no longer happens. That makes me think that this is dependent on something that
> is not setup before
> ghes_probe() is happening. Any ideas?

Gah, One of the things I've tried to enforce is that notifications that happen
in_nmi() always happen in_nmi(): but that isn't the case for this first
ghes_proc() call, which always happens in process context.

Why didn't this happen to me? I'm assuming your GHES has work to do prior to
probing, but I waited for it to finish booting before generating test events.

The smallest fix is to have an irq/nmi fixmap and lock. This probe time call
would always use the irq fixmap and lock, and can be safely interrupted by an
NMI. Its only the NMI notifications interacting that we need to worry about as
they can't be masked.


Thanks!

James
