From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Thu, 02 Jul 2015 17:22:16 +0200
Message-ID: <55955728.3080506@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org> <1435592237-17924-2-git-send-email-eric.auger@linaro.org> <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <55954F6E.5030008@linaro.org> <55955542.6000809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55955542.6000809@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Pavel Fedin <p.fedin@samsung.com>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 07/02/2015 05:14 PM, Andre Przywara wrote:
> Hi Eric,
>=20
> On 02/07/15 15:49, Eric Auger wrote:
>> Hi Pavel,
>> On 07/02/2015 09:26 AM, Pavel Fedin wrote:
>>>  Hello!
>>>
>>>> -----Original Message-----
>>>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]=
 On Behalf Of Eric Auger
>>>> Sent: Monday, June 29, 2015 6:37 PM
>>>> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lis=
ts.infradead.org;
>>>> marc.zyngier@arm.com; christoffer.dall@linaro.org; andre.przywara@=
arm.com;
>>>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; p.fedin@sams=
ung.com; pbonzini@redhat.com
>>>> Subject: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
>>>>
>>>> On ARM, the MSI msg (address and data) comes along with
>>>> out-of-band device ID information. The device ID encodes the devic=
e
>>>> that composes the MSI msg. Let's create a new routing entry type,
>>>> dubbed KVM_IRQ_ROUTING_EXTENDED_MSI and use the __u32 pad space
>>>> to convey the device ID.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>>
>>>> ---
>>>>
>>>> RFC -> PATCH
>>>> - remove kvm_irq_routing_extended_msi and use union instead
>>>> ---
>>>>  Documentation/virtual/kvm/api.txt | 9 ++++++++-
>>>>  include/uapi/linux/kvm.h          | 6 +++++-
>>>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/vir=
tual/kvm/api.txt
>>>> index d20fd94..6426ae9 100644
>>>> --- a/Documentation/virtual/kvm/api.txt
>>>> +++ b/Documentation/virtual/kvm/api.txt
>>>> @@ -1414,7 +1414,10 @@ struct kvm_irq_routing_entry {
>>>>  	__u32 gsi;
>>>>  	__u32 type;
>>>>  	__u32 flags;
>>>> -	__u32 pad;
>>>> +	union {
>>>> +		__u32 pad;
>>>> +		__u32 devid;
>>>> +	};
>>>>  	union {
>>>>  		struct kvm_irq_routing_irqchip irqchip;
>>>>  		struct kvm_irq_routing_msi msi;
>>>
>>>  devid is actually a part of MSI bunch. Shouldn't it be a part of s=
truct kvm_irq_routing_msi then?
>>> It also has reserved pad.
>> Well this makes sense to me to associate the devid to the msi and pu=
t
>> devid in the pad field of struct kvm_irq_routing_msi.
>>
>> Andr=E9, Christoffer, would you agree on this change? - I would like=
 to
>> avoid doing/undoing things ;-) -
>=20
> Yes, that makes sense to me. TBH I haven't had a closer look at the
> patches yet, but clearly devid belongs into struct kvm_irq_routing_ms=
i.
thanks for your quick reply.
OK so let's go with that change.
>=20
>>>
>>>> @@ -1427,6 +1430,10 @@ struct kvm_irq_routing_entry {
>>>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>>>  #define KVM_IRQ_ROUTING_MSI 2
>>>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>>>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>>>> +
>>>> +In case of KVM_IRQ_ROUTING_EXTENDED_MSI routing type, devid is us=
ed to convey
>>>> +the device ID.
>>>>
>>>>  No flags are specified so far, the corresponding field must be se=
t to zero.
>>>
>>> What if we use KVM_MSI_VALID_DEVID flag instead of new KVM_IRQ_ROUT=
ING_EXTENDED_MSI definition? I
>>> believe this would make an API more consistent and introduce less n=
ew definitions.
>> do you mean using type =3D=3D KVM_IRQ_ROUTING_MSI and flag =3D=3D
>> KVM_MSI_VALID_DEVID? Not sure this is simpler/clearer. s390 paved th=
e
>> way for new routing entry types. I add a new one here.
>=20
> I tend to agree with Pavel's solution. When hacking IRQ routing suppo=
rt
> into kvmtool I saw that it's nasty being forced to differentiate betw=
een
> the two MSI routing types. Actually userland should be able to query =
the
> kernel about what kind of routing it requires. Also there is the issu=
e
> that we must _not_ set the flag on x86, since that breaks older kerne=
ls
> (due to that check that Eric removes in 3/7).
> So from my point of view the cleanest solution would be to always use
> KVM_IRQ_ROUTING_MSI, and add the device ID if the kernel needs it (tr=
ue
> for ITS guests, false for GICv2M, x86, ...)
> I am looking for a clever solution for this now.
OK thanks for sharing. I need some more time to study qemu code too.

- Eric

>=20
> Cheers,
> Andre.
>=20
>>
>> Another solution may be to use new KVM_IRQ_ROUTING_EXTENDED_MSI type=
 and
>> add struct kvm_msi ext_msi in kvm_irq_routing_entry union. It is 8 w=
ords
>> as well. But most probably this is even uglier.
>=20
>>
>> Let's see if this thread is heading to a consensus...
>>
>> Best Regards
>>
>> Eric
>>>
>>>>
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index 2a23705..8484681 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -841,12 +841,16 @@ struct kvm_irq_routing_s390_adapter {
>>>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>>>  #define KVM_IRQ_ROUTING_MSI 2
>>>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>>>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>>>>
>>>>  struct kvm_irq_routing_entry {
>>>>  	__u32 gsi;
>>>>  	__u32 type;
>>>>  	__u32 flags;
>>>> -	__u32 pad;
>>>> +	union {
>>>> +		__u32 pad;
>>>> +		__u32 devid;
>>>> +	};
>>>>  	union {
>>>>  		struct kvm_irq_routing_irqchip irqchip;
>>>>  		struct kvm_irq_routing_msi msi;
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> Kind regards,
>>> Pavel Fedin
>>> Expert Engineer
>>> Samsung Electronics Research center Russia
>>>
>>

