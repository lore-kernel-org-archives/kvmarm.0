From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 10/17] KVM: arm64: introduce new KVM ITS device
Date: Fri, 15 Jul 2016 10:33:44 +0100
Message-ID: <68082207-2b52-e825-cfe3-cb97cbe94186@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-11-andre.przywara@arm.com> <57874F1E.3000202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09CDC49AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 05:27:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YoVl0CBFa3Hp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2016 05:26:57 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8447C413E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2016 05:26:57 -0400 (EDT)
In-Reply-To: <57874F1E.3000202@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 14/07/16 09:36, Marc Zyngier wrote:
> On 13/07/16 02:59, Andre Przywara wrote:

....

>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 06ad94d..393ad3a 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c

...

>> +static int vgic_its_set_attr(struct kvm_device *dev,
>> +			     struct kvm_device_attr *attr)
>> +{
>> +	struct vgic_its *its = dev->private;
>> +	int ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
>> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>> +		unsigned long type = (unsigned long)attr->attr;
>> +		u64 addr;
>> +
>> +		if (type != KVM_VGIC_ITS_ADDR_TYPE)
>> +			return -ENODEV;
>> +
>> +		if (its->initialized)
>> +			return -EBUSY;
>> +
>> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>> +			return -EFAULT;
>> +
>> +		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
>> +					addr, SZ_64K);
> 
> Shouldn't that be the ITS size (128kB)?

No, this is the alignment requirement. See here:

...

>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index 2f24f13..1813f93 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -21,8 +21,8 @@
>>  
>>  /* common helpers */
>>  
>> -static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>> -			     phys_addr_t addr, phys_addr_t alignment)
>> +int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
>> +		      phys_addr_t addr, phys_addr_t alignment)
>>  {
>>  	if (addr & ~KVM_PHYS_MASK)
>>  		return -E2BIG;

Fixed the rest.

Cheers,
Andre.
