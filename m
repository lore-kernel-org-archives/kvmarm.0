From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm64: ITS: avoid re-mapping LPIs
Date: Wed, 17 Aug 2016 00:45:17 +0100
Message-ID: <a291bbd7-d8b4-2841-669b-721985eab81b@arm.com>
References: <20160816165106.25057-1-andre.przywara@arm.com>
 <20160816173038.GF14088@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160816173038.GF14088@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/08/16 18:30, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 05:51:06PM +0100, Andre Przywara wrote:
>> When a guest wants to map a device-ID/event-ID combination that is
>> already mapped, we may end up in a situation where an LPI is never
>> "put", thus never being freed.
>> Since the GICv3 spec says that mapping an already mapped LPI is
>> UNPREDICTABLE, lets just bail out early in this situation to avoid
>> any potential leaks.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++--------------
>>  1 file changed, 13 insertions(+), 14 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 9533080..4660a7d 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -731,7 +731,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>>  	u32 event_id = its_cmd_get_id(its_cmd);
>>  	u32 coll_id = its_cmd_get_collection(its_cmd);
>> -	struct its_itte *itte, *new_itte = NULL;
>> +	struct its_itte *itte;
>>  	struct its_device *device;
>>  	struct its_collection *collection, *new_coll = NULL;
>>  	int lpi_nr;
>> @@ -749,6 +749,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>>  	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
>>  		return E_ITS_MAPTI_PHYSICALID_OOR;
>>  
>> +	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
>> +	if (find_itte(its, device_id, event_id))
>> +		return 0;
>> +
> 
> By the way, this made me think how these errors are handled, and unless
> I'm mistaken, the return value from vgic_its_handle_command() is simply
> discarded, so even when we return things like -ENOMEM, this is just
> ignored?  Is this really the intention?

Yes, at least at the moment. The spec does not specify how ITS errors
should be communicated (IMPLEMENTATION DEFINED), only that an error
condition itself can be signaled via an SError - for which atm we lack
any code to inject, if I am not mistaken.
Still I wanted to assign those error codes: IMHO it improves readability
and simplifies any later extension in that respect.

For the Linux errors (like -ENOMEM): Due to the asynchronous nature of
the ITS command handling and also the guest triggering the commands,
there is really no better way to report those OoM conditions, for
instance, so I treated them the same as "proper" ITS errors.

Hope that helps.
Cheers,
Andre.

