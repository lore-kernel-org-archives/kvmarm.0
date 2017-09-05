From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 4/7] arm64: kvm: support user space to query RAS
 extension feature
Date: Tue, 5 Sep 2017 15:18:19 +0800
Message-ID: <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com>
 <59A84F9D.8030309@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22AD249C28
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 03:20:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eTIGc7wqx6-s for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Sep 2017 03:19:55 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3475E40D17
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 03:19:54 -0400 (EDT)
In-Reply-To: <59A84F9D.8030309@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, tbaicar@codeaurora.org, will.deacon@arm.com, linuxarm@huawei.com, robert.moore@intel.com, lv.zheng@intel.com, zjzhang@codeaurora.org, mingo@kernel.org, stefan@hello-penguin.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, huangdaode@hisilicon.com, bp@suse.de, Dave.Martin@arm.com, lenb@kernel.org, wuquanming@huawei.com, marc.zyngier@arm.com, john.garry@huawei.com, kristina.martsenko@arm.com, cov@codeaurora.org, jonathan.cameron@huawei.com, zhengqiang10@huawei.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com, mst@redhat.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

James,

On 2017/9/1 2:04, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 28/08/17 11:38, Dongjiu Geng wrote:
>> In ARMV8.2 RAS extension, a virtual SError exception syndrome
>> register(VSESR_EL2) is added.  This value may be specified from
>> userspace.
> 
> I agree that the CPU support for injecting SErrors with a specified ESR should
> be exposed to KVM's user space...
Ok, thanks.

> 
> 
>> Userspace will want to check if the CPU has the RAS
>> extension. 
> 
> ... but user-space wants to know if it can inject SErrors with a specified ESR.
> 
> What if we gain another way of doing this that isn't via the RAS-extensions, now
> user-space has to check for two capabilities.
> 
> 
>> If it has, it wil specify the virtual SError syndrome
>> value, otherwise it will not be set. This patch adds support for
>> querying the availability of this extension.
> 
> I'm against telling user-space what features the CPU has unless it can use them
> directly. In this case we are talking about a KVM API, so we should describe the
> API not the CPU.

shenglong (zhaoshenglong@huawei.com) who is Qemu maintainer suggested checking the CPU RAS-extensions
to decide whether generate the APEI table and record CPER for the guest OS in the user space.
he means if the host does not support RAS, user space may also not support RAS.

> 
> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 3256b9228e75..b7313ee028e9 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_PMU_V3:
>>  		r = kvm_arm_support_pmu_v3();
>>  		break;
>> +	case KVM_CAP_ARM_RAS_EXTENSION:
> 
> This should be called something more like 'KVM_CAP_ARM_INJECT_SERROR_ESR'
I understand your suggestion.

> 
> 
>> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>> +		break;
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>>  		r = 1;
> 
> 
> We can inject SError on systems without the RAS extensions using just the
> HCR_EL2.VSE bit. We may want to make the 'ESR' part of the API optional, or
> expose '1' for the without-ESR version and '2 for with-ESR, (however we choose
> to implement that).
> 
> The risk is if we want to add a without-ESR version later, and the name we make
> ABI now turned out to be a mistake. Marc or Christoffer probably have the best
> view of this. (no-one has needed it so far...)
> 
> 
> Thanks,
> 
> James
> 
> 
> .
> 
