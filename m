From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [RFC PATCH 2/3] kvm: arm/arm64: vgic-vits: free its resource
 when vm reboot/reset
Date: Thu, 7 Sep 2017 09:32:10 +0800
Message-ID: <59B0A19A.9040407@huawei.com>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-3-git-send-email-wanghaibin.wang@huawei.com>
 <77e9976a-c263-90d5-973d-b0ef9153de82@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6E749C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 21:32:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ot9WRYjVwira for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 21:32:33 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3DDE49C2D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 21:32:32 -0400 (EDT)
In-Reply-To: <77e9976a-c263-90d5-973d-b0ef9153de82@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/9/7 0:20, Auger Eric wrote:

> Hi,
> 
> On 06/09/2017 15:05, wanghaibin wrote:
>> This patch fix the migrate save tables failure.
>>
>> When the virtual machine is in booting and the devices haven't initialized,
>> the all virtual dte/ite may be invalid. If migrate at this moment, the save
>> tables interface traversal device list, and check the dte is valid or not.
>> if not, it will return the -EINVAL.
> 
> The issue on save is less clear to me. We are not checking the "dte" are
> valid as it is said above. We are scrolling the ITS lists - which may be
> empty - and dump them in guest memory.
> 
> On save() there are quite few checks that can cause a failure.
> vgic_its_check_id() can be among them. This typically requires the
> GITS_BASER to have been properly set. Failing on save looks OK to me in
> such situation.
> 
> Sorry but I don't get the purpose of this patch. Does it fix a save failure?


Yes, for save, vgic_its_check_id() func will check the L1 DTE valid or not through
the code like :

	/* Each 1st level entry is represented by a 64-bit value. */
	if (kvm_read_guest(its->dev->kvm,
			   BASER_ADDRESS(baser) + index * sizeof(indirect_ptr),
			   &indirect_ptr, sizeof(indirect_ptr)))
		return false;

	indirect_ptr = le64_to_cpu(indirect_ptr);

	/* check the valid bit of the first level entry */
	if (!(indirect_ptr & BIT_ULL(63)))
		return false;

If invalid , the save will return -EINVAL caused by the vgic_its_check_id() with return the false value.

And form the cover letter, the problem happened when no one pci dev has been probed( guest driver haven't any
mapd, mapti), So the L1 DTEs are all invalid currently. Just like you said, at this moment migrate, we are scrolling
the ITS lists, next time check_id failed and save interface failed.

I think the final reason is the device list free problem, at the reset/reboot, ITS dev/clo/itt lists are not be free
and set NULL. So that, the save interface failed.
This patch try to free the resource when vm reboot/reset.
BTW: these lists will re-bulid when the reboot vm run the probe pci device step.

Thanks

> 
> Thanks
> 
> Eric
> 
> 
>>
>> This patch try to free the its list resource when vm reboot or reset to avoid this.
>>
>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>> ---
>>  virt/kvm/arm/arm.c           |  5 ++++-
>>  virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
>>  virt/kvm/arm/vgic/vgic.h     |  1 +
>>  3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index a39a1e1..db7632d 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -46,6 +46,7 @@
>>  #include <asm/kvm_coproc.h>
>>  #include <asm/kvm_psci.h>
>>  #include <asm/sections.h>
>> +#include "vgic.h"
>>  
>>  #ifdef REQUIRES_VIRT
>>  __asm__(".arch_extension	virt");
>> @@ -901,8 +902,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>>  	 * Ensure a rebooted VM will fault in RAM pages and detect if the
>>  	 * guest MMU is turned off and flush the caches as needed.
>>  	 */
>> -	if (vcpu->arch.has_run_once)
>> +	if (vcpu->arch.has_run_once) {
>>  		stage2_unmap_vm(vcpu->kvm);
>> +		vgic_its_free_resource(vcpu->kvm);
>> +	}
>>  
>>  	vcpu_reset_hcr(vcpu);
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 25d614f..5c20352 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -2467,6 +2467,16 @@ static int vgic_its_get_attr(struct kvm_device *dev,
>>  	.has_attr = vgic_its_has_attr,
>>  };
>>  
>> +void vgic_its_free_resource(struct kvm *kvm)
>> +{
>> +	struct kvm_device *dev, *tmp;
>> +
>> +	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
>> +		if(dev->ops == &kvm_arm_vgic_its_ops)
>> +			vgic_its_free_list(kvm, dev->private);
>> +	}
>> +}
>> +
>>  int kvm_vgic_register_its_device(void)
>>  {
>>  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index c2be5b7..fbcbdfd 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -222,5 +222,6 @@ int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>>  
>>  bool lock_all_vcpus(struct kvm *kvm);
>>  void unlock_all_vcpus(struct kvm *kvm);
>> +void vgic_its_free_resource(struct kvm *kvm);
>>  
>>  #endif
>>
> 
> .
> 
