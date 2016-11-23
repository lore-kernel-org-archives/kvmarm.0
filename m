From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH 2/4] arm/arm64: GICv2: add
 GICD_IPRIORITYR testing
Date: Wed, 23 Nov 2016 14:09:52 +0100
Message-ID: <52223ba0-9036-b4f2-ed70-04bf7a5e12e7@redhat.com>
References: <20161117175752.16475-1-andre.przywara@arm.com>
 <20161117175752.16475-3-andre.przywara@arm.com>
 <20161118140237.7dhjk5222ffdrqde@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161118140237.7dhjk5222ffdrqde@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 18/11/2016 15:02, Andrew Jones wrote:
> On Thu, Nov 17, 2016 at 05:57:50PM +0000, Andre Przywara wrote:
>> Some tests for the IPRIORITY registers. The significant number of bits
>> is IMPLEMENTATION DEFINED, but should be the same for every IRQ.
>> Also these registers must be byte-accessible.
>> Check that accesses beyond the implemented IRQ limit are actually
>> read-as-zero/write-ignore.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arm/gic.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 72 insertions(+)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index ba2585b..a27da2c 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -327,6 +327,76 @@ static bool test_typer_v2(uint32_t reg)
>>  	return true;
>>  }
>>  
>> +#define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
>> +#define REPLACE_BYTE(reg32, byte, new) (((reg32) & ~(0xff << ((byte) * 8))) |\
>> +					((new) << ((byte) * 8)))
>> +
>> +static bool test_priorities(int nr_irqs, void *priptr)
>> +{
>> +	u32 orig_prio, reg, pri_bits;
>> +	u32 pri_mask, pattern;
>> +
>> +	orig_prio = readl(priptr + 32);
>> +	report_prefix_push("IPRIORITYR");
>> +
>> +	/*
>> +	 * Determine implemented number of priority bits by writing all 1's
>> +	 * and checking the number of cleared bits in the value read back.
>> +	 */
>> +	writel(0xffffffff, priptr + 32);
>> +	pri_mask = readl(priptr + 32);
>> +
>> +	reg = ~pri_mask;
>> +	report("consistent priority masking (0x%08x)",
>> +	       (((reg >> 16) == (reg & 0xffff)) &&
>> +	        ((reg & 0xff) == ((reg >> 8) & 0xff))), pri_mask);
>> +
>> +	reg = reg & 0xff;
>> +	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
>> +		;
>> +	report("implements at least 4 priority bits (%d)",
>> +	       pri_bits >= 4, pri_bits);
>> +
>> +	pattern = 0;
>> +	writel(pattern, priptr + 32);
>> +	report("clearing priorities", readl(priptr + 32) == pattern);
>> +
>> +	pattern = 0xffffffff;
>> +	writel(pattern, priptr + 32);
>> +	report("filling priorities",
>> +	       readl(priptr + 32) == (pattern & pri_mask));
what's the point to re-do that check?
>> +
>> +	report("accesses beyond limit RAZ/WI",
>> +	       test_readonly_32(priptr + nr_irqs, true));
>> +
>> +	writel(pattern, priptr + nr_irqs - 4);
>> +	report("accessing last SPIs",
>> +	       readl(priptr + nr_irqs - 4) == (pattern & pri_mask));
>> +
>> +	pattern = 0xff7fbf3f;
>> +	writel(pattern, priptr + 32);
>> +	report("priorities are preserved",
>> +	       readl(priptr + 32) == (pattern & pri_mask));
>> +
>> +	/*
>> +	 * The PRIORITY registers are byte accessible, do a byte-wide
>> +	 * read and write of known content to check for this.
>> +	 */
>> +	reg = readb(priptr + 33);
>> +	report("byte reads successful (0x%08x => 0x%02x)",
>> +	       reg == (BYTE(pattern, 1) & pri_mask), pattern & pri_mask, reg);
>> +
>> +	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
>> +	writeb(BYTE(pattern, 2), priptr + 34);
>> +	reg = readl(priptr + 32);
>> +	report("byte writes successful (0x%02x => 0x%08x)",
>> +	       reg == (pattern & pri_mask), BYTE(pattern, 2) & pri_mask, reg);
>> +
>> +	report_prefix_pop();
>> +	writel(orig_prio, priptr + 32);
>> +	return true;
> 
> Might be nice to have FIRST_SPI and maybe LAST_SPI macros to avoid all
> the +32's
> 
> This function always returns true, so it can be a void.
> 
>> +}
>> +
>>  static int gic_test_mmio(int gic_version)
>>  {
>>  	u32 reg;
>> @@ -364,6 +434,8 @@ static int gic_test_mmio(int gic_version)
>>  	       test_readonly_32(idreg, false),
>>  	       reg);
>>  
>> +	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
> 
> Feel free to add state like nr_irqs and dist_base to the gic struct
> defined in arm/gic.c. That struct should provide the abstraction
> needed to handle both gicv2 and gicv3 and contain anything that the
> test functions need to refer to frequently. Using it should help
> reduce the amount of parameters passed around.
> 
>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 2.9.0
> 
> Otherwise looks good to me
same: Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>
>>
> 
