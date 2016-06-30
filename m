From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 15/15] arm/arm64: KVM: Check that IDMAP doesn't intersect
 with VA range
Date: Thu, 30 Jun 2016 13:51:00 +0100
Message-ID: <577515B4.1080301@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-16-git-send-email-marc.zyngier@arm.com>
 <20160628220101.GT26498@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160628220101.GT26498@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/06/16 23:01, Christoffer Dall wrote:
> On Tue, Jun 07, 2016 at 11:58:35AM +0100, Marc Zyngier wrote:
>> This is more of a safety measure than anything else: If we end-up
>> with an idmap page that intersect with the range picked for the
>> the HYP VA space, abort the KVM setup, as it is unsafe to go
>> further.
>>
>> I cannot imagine it happening on 64bit (we have a mechanism to
>> work around it), but could potentially occur on a 32bit system with
>> the kernel loaded high enough in memory so that in conflicts with
>> the kernel VA.
> 
> ah, you had a patch for this...
> 
> does this even work for enabling the MMU during kernel boot or how do
> they deal with it?

As I said in a reply to an earlier patch, this must already taken care
of by the bootloader, making sure that the kernel physical memory does
not alias with the VAs. Pretty scary.

> 
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/mmu.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 46b8604..819517d 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -1708,6 +1708,21 @@ int kvm_mmu_init(void)
>>  	 */
>>  	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
>>  
>> +	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
>> +	kvm_info("HYP VA range: %lx:%lx\n",
>> +		 KERN_TO_HYP(PAGE_OFFSET), KERN_TO_HYP(~0UL));
>> +
>> +	if (hyp_idmap_start >= KERN_TO_HYP(PAGE_OFFSET) &&
>> +	    hyp_idmap_start <  KERN_TO_HYP(~0UL)) {
> 
> why is the second part of this clause necessary?

We want to check that our clash avoiding mechanism works.

Since we're translating the kernel VA downwards (by clearing the top
bits), we can definitely end-up in a situation where the idmap is above
the translated "top of the kernel" (that's the "low mask" option). So it
is definitely worth checking that we really don't get any aliasing. This
has been quite useful when debugging this code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
