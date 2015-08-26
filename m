From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/4] irqchip: GICv3: Convert to EOImode == 1
Date: Wed, 26 Aug 2015 11:09:58 +0100
Message-ID: <55DD9076.7080000@arm.com>
References: <1440503605-10185-1-git-send-email-marc.zyngier@arm.com> <1440503605-10185-2-git-send-email-marc.zyngier@arm.com> <55DD7EDB.7010208@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55DD7EDB.7010208@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 26/08/15 09:54, Eric Auger wrote:
> Hi Marc,
> On 08/25/2015 01:53 PM, Marc Zyngier wrote:
>> So far, GICv3 has been used in with EOImode == 0. The effect of this
>> mode is to perform the priority drop and the deactivation of the
>> interrupt at the same time.
>>
>> While this works perfectly for Linux (we only have a single priority),
>> it causes issues when an interrupt is forwarded to a guest, and when
>> we want the guest to perform the EOI itself.
>>
>> For this case, the GIC architecture provides EOImode == 1, where:
>> - A write to ICC_EOIR1_EL1 drops the priority of the interrupt and
>>   leaves it active. Other interrupts at the same priority level can
>>   now be taken, but the active interrupt cannot be taken again
>> - A write to ICC_DIR_EL1 marks the interrupt as inactive, meaning
>>   it can now be taken again.
>>
>> This patch converts the driver to be able to use this new mode,
>> depending on whether or not the kernel can behave as a hypervisor.
>> No feature change.
>>
>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic-v3.c       | 39 ++++++++++++++++++++++++++++++++++----
>>  include/linux/irqchip/arm-gic-v3.h |  9 +++++++++
>>  2 files changed, 44 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index c52f7ba..addd2ee 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -30,6 +30,7 @@
>>  #include <asm/cputype.h>
>>  #include <asm/exception.h>
>>  #include <asm/smp_plat.h>
>> +#include <asm/virt.h>
>>  
>>  #include "irq-gic-common.h"
>>  #include "irqchip.h"
>> @@ -50,6 +51,7 @@ struct gic_chip_data {
>>  };
>>  
>>  static struct gic_chip_data gic_data __read_mostly;
>> +static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
> 
> in http://www.spinics.net/lists/arm-kernel/msg439813.html, Catalin
> reported the direct usage of static_key was deprecated. Sorry I learned
> that after my last review.
> 
> see https://lkml.org/lkml/2015/8/3/539

Hi Eric,

I'm aware of Peter's work to rework static keys, but that code is not
merged yet (though I believe it is on its way to 4.3). I have an
additional patch that repaints the code to use static_key_likely() all
over the place, but I keep it separate for the time being.

If this series makes it in for 4.3, I'll post the repainting patch after
-rc1. Otherwise, I'll just update it in my tree.

I'm about to post v4 anyway, and I'll mention this in the cover letter.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
