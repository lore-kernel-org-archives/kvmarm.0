From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v8 01/16] FDT: introduce global phandle allocation
Date: Thu, 2 Feb 2017 16:31:26 +0000
Message-ID: <a139b765-90eb-ce19-dc54-213c777e4a3e@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
 <20161104173203.21168-2-andre.przywara@arm.com>
 <d1dc4e68-66e1-85d1-f5d1-5743e5172409@arm.com>
 <4c43b500-c0c8-cb25-27f4-f6d24233c088@arm.com>
 <878tppkf5v.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <878tppkf5v.fsf@on-the-bus.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Vladimir Murzin <vladimir.murzin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 01/02/17 17:13, Marc Zyngier wrote:
> On Wed, Feb 01 2017 at  4:44:19 pm GMT, André Przywara <andre.przywara@arm.com> wrote:
> 
> Hi Andre,
> 
>> Hi Marc, Will,
>>
>> On 09/12/16 12:03, Marc Zyngier wrote:
>>> On 04/11/16 17:31, Andre Przywara wrote:
>>>> Allocating an FDT phandle (a unique identifier) using a static
>>>> variable in a static inline function defined in a header file works
>>>> only if all users are in the same source file. So trying to allocate
>>>> a handle from two different compilation units fails.
>>>> Introduce global phandle allocation and reference code to properly
>>>> allocate unique phandles.
>>>>
>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>> ---
>>>>  Makefile          |  1 +
>>>>  arm/fdt.c         |  2 +-
>>>>  arm/gic.c         |  2 +-
>>>>  include/kvm/fdt.h | 10 +++++-----
>>>>  kvm-fdt.c         | 26 ++++++++++++++++++++++++++
>>>>  5 files changed, 34 insertions(+), 7 deletions(-)
>>>>  create mode 100644 kvm-fdt.c
>>>>
>>>> diff --git a/Makefile b/Makefile
>>>> index 1f0196f..e4a4002 100644
>>>> --- a/Makefile
>>>> +++ b/Makefile
>>>> @@ -98,6 +98,7 @@ OBJS	+= kvm-ipc.o
>>>>  OBJS	+= builtin-sandbox.o
>>>>  OBJS	+= virtio/mmio.o
>>>>  OBJS	+= hw/i8042.o
>>>> +OBJS	+= kvm-fdt.o
>>>>  
>>>>  # Translate uname -m into ARCH string
>>>>  ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
>>>> diff --git a/arm/fdt.c b/arm/fdt.c
>>>> index 381d48f..8bcfffb 100644
>>>> --- a/arm/fdt.c
>>>> +++ b/arm/fdt.c
>>>> @@ -114,7 +114,7 @@ static int setup_fdt(struct kvm *kvm)
>>>>  {
>>>>  	struct device_header *dev_hdr;
>>>>  	u8 staging_fdt[FDT_MAX_SIZE];
>>>> -	u32 gic_phandle		= fdt__alloc_phandle();
>>>> +	u32 gic_phandle		= fdt__get_phandle(PHANDLE_GIC);
>>>>  	u64 mem_reg_prop[]	= {
>>>>  		cpu_to_fdt64(kvm->arch.memory_guest_start),
>>>>  		cpu_to_fdt64(kvm->ram_size),
>>>> diff --git a/arm/gic.c b/arm/gic.c
>>>> index d6d6dd0..b60437e 100644
>>>> --- a/arm/gic.c
>>>> +++ b/arm/gic.c
>>>> @@ -222,7 +222,7 @@ void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
>>>>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
>>>>  	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
>>>>  	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
>>>> -	_FDT(fdt_property_cell(fdt, "phandle", phandle));
>>>> +	_FDT(fdt_property_cell(fdt, "phandle", fdt__get_phandle(PHANDLE_GIC)));
>>>>  	_FDT(fdt_end_node(fdt));
>>>>  }
>>>>  
>>>> diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
>>>> index 53d85a4..cd2bb72 100644
>>>> --- a/include/kvm/fdt.h
>>>> +++ b/include/kvm/fdt.h
>>>> @@ -8,6 +8,10 @@
>>>>  #include <linux/types.h>
>>>>  
>>>>  #define FDT_MAX_SIZE	0x10000
>>>> +#define FDT_INVALID_PHANDLE 0
>>>> +#define FDT_IS_VALID_PHANDLE(phandle) ((phandle) != FDT_INVALID_PHANDLE)
>>>> +
>>>> +enum phandles {PHANDLE_GIC, PHANDLES_MAX};
>>>
>>> Another nit here: PHANDLE_GIC is pretty much ARM-specific, while FDT is
>>> supposed to be generic. Can't we move the enum to be architecture
>>> specific and not put this in an architecture agnostic one?
>>
>> So while trying to find the best possible solution for this seemingly
>> simple problem, I was wondering why we had this allocation function in
>> the first place?
>> It seems a bit overkill to allocate a handle if we could just go with
>> static values.
>> I changed the first two patches now to have an enum per architecture to
>> list all possible handles and then just using those values directly
>> instead of going through another layer of indirection.
> 
> Yes, that probably make sense, at least for the time being.
> 
>> So is there anything that will require dynamic phandles in the future?
>> This version proposed here can't really cope with them anyway and in the
>> moment it's just about _one_ GIC phandle and _one_ ITS phandle, so a
>> static assignment is much simpler.
>>
>> Will we need multiple ITSes for device passthrough? Or would it just be
>> one ITS for all hardware devices and one for emulated virtio?
> 
> Having multiple ITSes is definitely on the cards (pass-through and
> emulated devices are one case, where once of them would be driven using
> GICv4 and the other be purely virtual). This probably would translate
> into having multiple PCIe host controllers.

OK, I see. At the moment the kvmtool code seems to rely on having only a
single PCI controller using a static setup. As changing this would
require some rework (for instance to allow dynamic MMIO allocation), I
would like to refrain from adding multiple ITS support prematurely now.
We should do this later in conjunction with multiple PCI controller
support, I believe.

> So maybe we don't need the full breath of an allocator yet, but I reckon
> that we shouldn't pretend that there is no use for it, forever.

OK, got it.

I will post my version with the static phandle setup, feel free to shoot
it down if this is too much of a simplification or if you have the
feeling that removing the allocation will bite us later.

Cheers,
Andre.
