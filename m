From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Fri, 3 Jul 2015 10:05:02 +0100
Message-ID: <5596503E.6040902@arm.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B506F578C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 04:53:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z+peDrBAf86W for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 04:53:48 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77781578BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 04:53:47 -0400 (EDT)
In-Reply-To: <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Eric Auger' <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 02/07/15 08:26, Pavel Fedin wrote:
>  Hello!
> 
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Eric Auger
>> Sent: Monday, June 29, 2015 6:37 PM
>> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lists.infradead.org;
>> marc.zyngier@arm.com; christoffer.dall@linaro.org; andre.przywara@arm.com;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; p.fedin@samsung.com; pbonzini@redhat.com
>> Subject: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
>>
>> On ARM, the MSI msg (address and data) comes along with
>> out-of-band device ID information. The device ID encodes the device
>> that composes the MSI msg. Let's create a new routing entry type,
>> dubbed KVM_IRQ_ROUTING_EXTENDED_MSI and use the __u32 pad space
>> to convey the device ID.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> RFC -> PATCH
>> - remove kvm_irq_routing_extended_msi and use union instead
>> ---
>>  Documentation/virtual/kvm/api.txt | 9 ++++++++-
>>  include/uapi/linux/kvm.h          | 6 +++++-
>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index d20fd94..6426ae9 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -1414,7 +1414,10 @@ struct kvm_irq_routing_entry {
>>  	__u32 gsi;
>>  	__u32 type;
>>  	__u32 flags;
>> -	__u32 pad;
>> +	union {
>> +		__u32 pad;
>> +		__u32 devid;
>> +	};
>>  	union {
>>  		struct kvm_irq_routing_irqchip irqchip;
>>  		struct kvm_irq_routing_msi msi;
> 
>  devid is actually a part of MSI bunch. Shouldn't it be a part of struct kvm_irq_routing_msi then?
> It also has reserved pad.
> 
>> @@ -1427,6 +1430,10 @@ struct kvm_irq_routing_entry {
>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>  #define KVM_IRQ_ROUTING_MSI 2
>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>> +
>> +In case of KVM_IRQ_ROUTING_EXTENDED_MSI routing type, devid is used to convey
>> +the device ID.
>>
>>  No flags are specified so far, the corresponding field must be set to zero.
> 
> What if we use KVM_MSI_VALID_DEVID flag instead of new KVM_IRQ_ROUTING_EXTENDED_MSI definition? I
> believe this would make an API more consistent and introduce less new definitions.

I like this approach, but it runs into problems:
As you read above the current documentation says that the flags field
must be zero and the current KVM_SET_GSI_ROUTING handler bails out if it
isn't. So userland would need to know whether it's safe to set that
field. Introducing a new KVM_CAP_... value seems overkill if we could
just have a new routing entry type. So we could still reuse the existing
struct kvm_irq_routing_msi (and extend that with the devid field), but
we would have to add a new routing type number.
Maybe we could collapse this into the existing MSI type + flag when
handing it further down the kernel?

Cheers,
Andre.

> 
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 2a23705..8484681 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -841,12 +841,16 @@ struct kvm_irq_routing_s390_adapter {
>>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>>  #define KVM_IRQ_ROUTING_MSI 2
>>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
>> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>>
>>  struct kvm_irq_routing_entry {
>>  	__u32 gsi;
>>  	__u32 type;
>>  	__u32 flags;
>> -	__u32 pad;
>> +	union {
>> +		__u32 pad;
>> +		__u32 devid;
>> +	};
>>  	union {
>>  		struct kvm_irq_routing_irqchip irqchip;
>>  		struct kvm_irq_routing_msi msi;
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
