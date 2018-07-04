From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [kvmtool test PATCH 24/24] kvmtool: arm: Add support for creating
 VM with PA size
Date: Wed, 4 Jul 2018 16:58:12 +0100
Message-ID: <66e93016-91bd-5fbb-2479-9f1d87795e5e@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-25-git-send-email-suzuki.poulose@arm.com>
 <20180704142241.GG4828@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704142241.GG4828@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 07/04/2018 03:22 PM, Will Deacon wrote:
> On Fri, Jun 29, 2018 at 12:15:44PM +0100, Suzuki K Poulose wrote:
>> diff --git a/arm/kvm.c b/arm/kvm.c
>> index 5701d41..b1969be 100644
>> --- a/arm/kvm.c
>> +++ b/arm/kvm.c
>> @@ -11,6 +11,8 @@
>>   #include <linux/kvm.h>
>>   #include <linux/sizes.h>
>>   
>> +unsigned long kvm_arm_type;
>> +
>>   struct kvm_ext kvm_req_ext[] = {
>>   	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
>>   	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
>> @@ -18,6 +20,26 @@ struct kvm_ext kvm_req_ext[] = {
>>   	{ 0, 0 },
>>   };
>>   
>> +#ifndef KVM_ARM_GET_MAX_VM_PHYS_SHIFT
>> +#define KVM_ARM_GET_MAX_VM_PHYS_SHIFT		_IO(KVMIO, 0x0b)
>> +#endif
>> +
>> +void kvm__arch_init_hyp(struct kvm *kvm)
>> +{
>> +	int max_ipa;
>> +
>> +	max_ipa = ioctl(kvm->sys_fd, KVM_ARM_GET_MAX_VM_PHYS_SHIFT);
>> +	if (max_ipa < 0)
>> +		max_ipa = 40;
>> +	if (!kvm->cfg.arch.phys_shift)
>> +		kvm->cfg.arch.phys_shift = 40;
>> +	if (kvm->cfg.arch.phys_shift > max_ipa)
>> +		die("Requested PA size (%u) is not supported by the host (%ubits)\n",
>> +		    kvm->cfg.arch.phys_shift, max_ipa);
>> +	if (kvm->cfg.arch.phys_shift != 40)
>> +		kvm_arm_type = kvm->cfg.arch.phys_shift;
>> +}
> 
> Seems a bit weird that the "machine type identifier" to KVM_CREATE_VM is
> dedicated entirely to holding the physical address shift verbatim. Is this
> really the ABI?

The bits[7:0] of the machine type has been reserved for the IPA shift.
This version is missing the updates to the ABI documentation, I have it
for the next version.

> 
> Also, couldn't KVM figure it out automatically if you add memslots at high
> addresses, making this a niche tunable outside of testing?

The stage2 pgd size is really dependent on the max IPA. Also, unlike the 
stage1 (where the maximum size will be 1 page), the size can go upto 16
pages (and different number of levels due to concatenation), so we need
to finalize this at least before the first memory gets mapped (RAM or 
Device). That implies, we cannot wait until all the memory slots are
created.

The first version of the series added a separate ioctl for specifying
the limit, which had its own complexities. So, this ABI was suggested
to keep things simpler.


Suzuki
