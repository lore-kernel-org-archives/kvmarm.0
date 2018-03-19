From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 02/12] KVM: arm/arm64: Document
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Mon, 19 Mar 2018 21:56:06 +0100
Message-ID: <93b3cb3b-6ceb-0277-154e-14bfa5b8f0e6@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
 <1521451220-27754-3-git-send-email-eric.auger@redhat.com>
 <f00d314f-7f16-1785-b0e2-6d4d815514dc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f00d314f-7f16-1785-b0e2-6d4d815514dc@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 19/03/18 15:15, Marc Zyngier wrote:
> On 19/03/18 09:20, Eric Auger wrote:
>> We introduce a new KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attribute in
>> KVM_DEV_ARM_VGIC_GRP_ADDR group. It allows userspace to provide the
>> base address and size of a redistributor region
>>
>> Compared to KVM_VGIC_V3_ADDR_TYPE_REDIST, this new attribute allows
>> to declare several separate redistributor regions.
>>
>> So the whole redist space does not need to be contiguous anymore.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> index 9293b45..2c0bedf 100644
>> --- a/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> +++ b/Documentation/virtual/kvm/devices/arm-vgic-v3.txt
>> @@ -27,6 +27,18 @@ Groups:
>>        VCPU and all of the redistributor pages are contiguous.
>>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>>        This address needs to be 64K aligned.
>> +
>> +    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION (rw, 64-bit)
>> +      The attr field of kvm_device_attr encodes 3 values:
>> +      bits:     | 63   ....  52  |  51   ....   12 |11 - 0
>> +      values:   |     pfns       |       base      | index
>> +      - index encodes the unique redistibutor region index
>> +      - base field encodes bits [51:12] the guest physical base address
>> +        of the first redistributor in the region. There are two 64K pages
>> +        for each VCPU and all of the redistributor pages are contiguous
>> +        within the redistributor region.
> 
> Why does base have to include bits [15:12] of the IPA? If it is 64kB
> aligned (as it should), these bits are guaranteed to be 0. This also
> avoid having to return -EINVAL in case of alignment problems.
Agreed. I hesitated but saw addresses were generally described  with
bits[51:12] in regs such as PROPBASER/PENDBASER and I did not really
need the spare bits.
> 
>> +      - pfns encodes the size of the region in 64kB pages.
>> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> 
> "pfns" a bit of an odd name, and is a bit unnatural. Why don't we
> instead encode the number of redistributors? You've already imposed that
> a redistributor has 2 64kB pages,
I copied the description in KVM_VGIC_V3_ADDR_TYPE_REDIST ;-) I knew that
for GICv4 the number of 64kB pages per redist is different so I thought
it was more generic. But I don't have a strong opinion.
 so let's take advantage of this by
> saving yet another bit.
> 
> You could dedicate a couple of these bits as a selector for the ITS
> version (v3, v4 or whatever comes after that, if ever...). Just make 0
> the only valid version for the time being.
OK

Thanks

Eric
> 
>>    Errors:
>>      -E2BIG:  Address outside of addressable IPA range
>>      -EINVAL: Incorrectly aligned address
>>
> 
> Thanks,
> 
> 	M.
> 
