From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v5 4/7] support user space to query RAS extension feature
Date: Tue, 22 Aug 2017 09:20:20 +0800
Message-ID: <1d75940a-dd1f-6349-a65a-adbbd221f41f@huawei.com>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
 <1503065517-7920-5-git-send-email-gengdongjiu@huawei.com>
 <20170821210824.GC20436@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170821210824.GC20436@cbox>
Sender: linux-acpi-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer,
   Thanks for the review.

On 2017/8/22 5:08, Christoffer Dall wrote:
> On Fri, Aug 18, 2017 at 10:11:54PM +0800, Dongjiu Geng wrote:
> 
> You should put KVM and arm64 in the subject here.
I will update it in the next version.


> 
>> In armv8.2 RAS extension, it adds virtual SError exception
>> syndrome registeri(VSESR_EL2), user space will specify that
>> value. so user space will check whether CPU feature has RAS
>> extension. if has, it will specify the virtual SError syndrome
>> value. Otherwise, it will not set. This patch adds this support
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>>  arch/arm64/kvm/reset.c   | 3 +++
>>  include/uapi/linux/kvm.h | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 3256b9228e75..b7313ee028e9 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_PMU_V3:
>>  		r = kvm_arm_support_pmu_v3();
>>  		break;
>> +	case KVM_CAP_ARM_RAS_EXTENSION:
>> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>> +		break;
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>>  		r = 1;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6cd63c18708a..5a2a338cae57 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -929,6 +929,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_SMT_POSSIBLE 147
>>  #define KVM_CAP_HYPERV_SYNIC2 148
>>  #define KVM_CAP_HYPERV_VP_INDEX 149
>> +#define KVM_CAP_ARM_RAS_EXTENSION 150
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> -- 
>> 2.14.0
>>
> 
> Thanks,
> -Christoffer
> 
> .
> 

