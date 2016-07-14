From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 14/17] KVM: arm64: allow updates of LPI configuration
 table
Date: Thu, 14 Jul 2016 11:10:50 +0100
Message-ID: <5787652A.4040102@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-15-andre.przywara@arm.com> <57875F8A.2070009@arm.com>
 <478c84bd-46e8-5f73-45d1-82d8c6bf38c1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <478c84bd-46e8-5f73-45d1-82d8c6bf38c1@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/16 11:00, Andre Przywara wrote:
> Hi,
> 
> On 14/07/16 10:46, Marc Zyngier wrote:
>> On 13/07/16 02:59, Andre Przywara wrote:
>>> The (system-wide) LPI configuration table is held in a table in
>>> (guest) memory. To achieve reasonable performance, we cache this data
>>> in our struct vgic_irq. If the guest updates the configuration data
>>> (which consists of the enable bit and the priority value), it issues
>>> an INV or INVALL command to allow us to update our information.
>>> Provide functions that update that information for one LPI or all LPIs
>>> mapped to a specific collection.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 39 +++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 39 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index f400ef1..60108f8 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -64,6 +64,45 @@ struct its_itte {
>>>  
>>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>>>  #define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
>>> +#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>>
>> Again, these masks are wrong as we limit the ITS to 48 bits PA.
> 
> Those masks match the architecture description of the register. We limit
> to 48 bits of PA when the guest writes to those registers. I'd like to
> keep this limitation in one place only.

Which makes it hard to understand for everyone. If you want something
truly generic, assign proper names to these defines:

#define CBASER_ARCHITECTURAL_PA_BITS	52
#define CBASER_IMPLEMENTATION_PA_BITS	48

and repaint all your defines to use macros along those lines. If not,
just change everything to 48 and let's be done with it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
