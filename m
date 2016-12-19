From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v8 01/16] FDT: introduce global phandle allocation
Date: Mon, 19 Dec 2016 18:43:29 +0000
Message-ID: <80430161-b363-4740-0eef-8cb73bc2ecbd@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
 <20161104173203.21168-2-andre.przywara@arm.com>
 <be44a9ad-f820-9a62-9a5d-682867674e91@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B23340295
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 13:41:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id skwmuyjYOu30 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2016 13:41:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FCCA4028D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 13:41:17 -0500 (EST)
In-Reply-To: <be44a9ad-f820-9a62-9a5d-682867674e91@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 09/12/16 11:55, Marc Zyngier wrote:
> Hi Andre,
> 
> On 04/11/16 17:31, Andre Przywara wrote:
>> Allocating an FDT phandle (a unique identifier) using a static
>> variable in a static inline function defined in a header file works
>> only if all users are in the same source file. So trying to allocate
>> a handle from two different compilation units fails.
>> Introduce global phandle allocation and reference code to properly
>> allocate unique phandles.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  Makefile          |  1 +
>>  arm/fdt.c         |  2 +-
>>  arm/gic.c         |  2 +-
>>  include/kvm/fdt.h | 10 +++++-----
>>  kvm-fdt.c         | 26 ++++++++++++++++++++++++++
>>  5 files changed, 34 insertions(+), 7 deletions(-)
>>  create mode 100644 kvm-fdt.c
>>
>> diff --git a/Makefile b/Makefile
>> index 1f0196f..e4a4002 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -98,6 +98,7 @@ OBJS	+= kvm-ipc.o
>>  OBJS	+= builtin-sandbox.o
>>  OBJS	+= virtio/mmio.o
>>  OBJS	+= hw/i8042.o
>> +OBJS	+= kvm-fdt.o
>>  
>>  # Translate uname -m into ARCH string
>>  ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
>> diff --git a/arm/fdt.c b/arm/fdt.c
>> index 381d48f..8bcfffb 100644
>> --- a/arm/fdt.c
>> +++ b/arm/fdt.c
>> @@ -114,7 +114,7 @@ static int setup_fdt(struct kvm *kvm)
>>  {
>>  	struct device_header *dev_hdr;
>>  	u8 staging_fdt[FDT_MAX_SIZE];
>> -	u32 gic_phandle		= fdt__alloc_phandle();
>> +	u32 gic_phandle		= fdt__get_phandle(PHANDLE_GIC);
>>  	u64 mem_reg_prop[]	= {
>>  		cpu_to_fdt64(kvm->arch.memory_guest_start),
>>  		cpu_to_fdt64(kvm->ram_size),
>> diff --git a/arm/gic.c b/arm/gic.c
>> index d6d6dd0..b60437e 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -222,7 +222,7 @@ void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
>>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
>>  	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
>>  	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
>> -	_FDT(fdt_property_cell(fdt, "phandle", phandle));
>> +	_FDT(fdt_property_cell(fdt, "phandle", fdt__get_phandle(PHANDLE_GIC)));
>>  	_FDT(fdt_end_node(fdt));
>>  }
>>  
>> diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
>> index 53d85a4..cd2bb72 100644
>> --- a/include/kvm/fdt.h
>> +++ b/include/kvm/fdt.h
>> @@ -8,6 +8,10 @@
>>  #include <linux/types.h>
>>  
>>  #define FDT_MAX_SIZE	0x10000
>> +#define FDT_INVALID_PHANDLE 0
>> +#define FDT_IS_VALID_PHANDLE(phandle) ((phandle) != FDT_INVALID_PHANDLE)
>> +
>> +enum phandles {PHANDLE_GIC, PHANDLES_MAX};
>>  
>>  /* Those definitions are generic FDT values for specifying IRQ
>>   * types and are used in the Linux kernel internally as well as in
>> @@ -33,10 +37,6 @@ enum irq_type {
>>  		}							\
>>  	} while (0)
>>  
>> -static inline u32 fdt__alloc_phandle(void)
>> -{
>> -	static u32 phandle = 0;
>> -	return ++phandle;
>> -}
>> +u32 fdt__get_phandle(enum phandles phandle);
>>  
>>  #endif /* KVM__FDT_H */
>> diff --git a/kvm-fdt.c b/kvm-fdt.c
>> new file mode 100644
>> index 0000000..d05f3fe
>> --- /dev/null
>> +++ b/kvm-fdt.c
>> @@ -0,0 +1,26 @@
>> +/*
>> + * Commonly used FDT functions.
>> + */
>> +
>> +#include <stdio.h>
>> +#include "kvm/fdt.h"
>> +#include "kvm/util.h"
>> +
>> +u32 phandles[PHANDLES_MAX] = {};
> 
> It is a bit weird that you're initializing this to zero...
> 
>> +u32 next_phandle = 1;
>> +
>> +u32 fdt__get_phandle(enum phandles phandle)
>> +{
>> +	u32 ret;
>> +
>> +	if (phandle >= PHANDLES_MAX)
>> +		return FDT_INVALID_PHANDLE;
>> +
>> +	ret = phandles[phandle];
>> +	if (ret == FDT_INVALID_PHANDLE) {
> 
> and yet test against a #define that isn't the initializer.

Well, yes. The problem is that AFAIK you cannot initialize an array
easily with all the values getting set to something other than zero.
So I could write
	u32 phandles[PHANDLES_MAX] = {FDT_INVALID_PHANDLE};
above, but as that would only set the first member to
FDT_INVALID_PHANDLE (and all the others to 0), so it would rely on the
define actually being zero to work reliably. So my thought was to avoid
readers falling into this trap by not specifying the reset value
explicitly. Also that's the reason that 0 is the invalid value, which I
don't like too much, tbh.

So shall I make this a comment then?

Or do I miss something here?

> Also, given that fdt__get_phandle() can now fail by returning
> FDT_INVALID_HANDLE, maybe we should abort instead of returning something
> that is definitely wrong and use it blindly (which is going to be fun to
> debug...).

Yes, good point. Given that this hints at an internal error, die() seems
to be the appropriate action here.

Cheers,
Andre.

> 
> 
>> +		ret = next_phandle++;
>> +		phandles[phandle] = ret;
>> +	}
>> +
>> +	return ret;
>> +}
>>
> 
> Thanks,
> 
> 	M.
> 
