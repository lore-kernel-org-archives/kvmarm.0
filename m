From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH RFC 6/7] ARM64: KVM: Support heterogeneous system
Date: Thu, 9 Mar 2017 15:21:44 +0000
Message-ID: <ee72bba1-65a6-d0c4-7f71-79d707a62ed2@arm.com>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-7-git-send-email-zhaoshenglong@huawei.com>
 <20170128145551.sknp447ieue56xgo@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B57C40AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 10:20:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id plKLfi+m5rtn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 10:20:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B804C40AE8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 10:20:22 -0500 (EST)
In-Reply-To: <20170128145551.sknp447ieue56xgo@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 28/01/17 14:55, Andrew Jones wrote:
> On Mon, Jan 16, 2017 at 05:33:33PM +0800, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When initializing KVM, check whether physical hardware is a
>> heterogeneous system through the MIDR values. If so, force userspace to
>> set the KVM_ARM_VCPU_CROSS feature bit. Otherwise, it should fail to
>> initialize VCPUs.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm/kvm/arm.c       | 26 ++++++++++++++++++++++++++
>>  include/uapi/linux/kvm.h |  1 +
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index bdceb19..21ec070 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -46,6 +46,7 @@
>>  #include <asm/kvm_coproc.h>
>>  #include <asm/kvm_psci.h>
>>  #include <asm/sections.h>
>> +#include <asm/cputype.h>
>>
>>  #ifdef REQUIRES_VIRT
>>  __asm__(".arch_extension	virt");
>> @@ -65,6 +66,7 @@ static unsigned int kvm_vmid_bits __read_mostly;
>>  static DEFINE_SPINLOCK(kvm_vmid_lock);
>>
>>  static bool vgic_present;
>> +static bool heterogeneous_system;
>>
>>  static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
>>
>> @@ -210,6 +212,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_CROSS_VCPU:
>>  		r = 1;
>>  		break;
>> +	case KVM_CAP_ARM_HETEROGENEOUS:
>> +		r = heterogeneous_system;
>> +		break;
>
> What's this for? When/why would usespace check it?
>
>>  	case KVM_CAP_COALESCED_MMIO:
>>  		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
>>  		break;
>> @@ -812,6 +817,12 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>>  	int phys_target = kvm_target_cpu();
>>  	bool cross_vcpu = kvm_vcpu_has_feature_cross_cpu(init);
>>
>> +	if (heterogeneous_system && !cross_vcpu) {
>> +		kvm_err("%s:Host is a heterogeneous system, set KVM_ARM_VCPU_CROSS bit\n",
>> +			__func__);
>> +		return -EINVAL;
>> +	}
>
> Instead of forcing userspace to set a bit, why not just confirm the
> target selected will work? E.g. if only generic works on a heterogeneous
> system then just
>
>  if (heterogeneous_system && init->target != GENERIC)
>     return -EINVAL
>
> should work
>
>> +
>>  	if (!cross_vcpu && init->target != phys_target)
>>  		return -EINVAL;
>>
>> @@ -1397,6 +1408,11 @@ static void check_kvm_target_cpu(void *ret)
>>  	*(int *)ret = kvm_target_cpu();
>>  }
>>
>> +static void get_physical_cpu_midr(void *midr)
>> +{
>> +	*(u32 *)midr = read_cpuid_id();
>> +}
>> +
>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>>  {
>>  	struct kvm_vcpu *vcpu;
>> @@ -1417,6 +1433,7 @@ int kvm_arch_init(void *opaque)
>>  {
>>  	int err;
>>  	int ret, cpu;
>> +	u32 current_midr, midr;
>>
>>  	if (!is_hyp_mode_available()) {
>>  		kvm_err("HYP mode not available\n");
>> @@ -1431,6 +1448,15 @@ int kvm_arch_init(void *opaque)
>>  		}
>>  	}
>>
>> +	current_midr = read_cpuid_id();
>> +	for_each_online_cpu(cpu) {
>> +		smp_call_function_single(cpu, get_physical_cpu_midr, &midr, 1);
>> +		if (current_midr != midr) {
>> +			heterogeneous_system = true;
>> +			break;
>> +		}
>> +	}
>
> Is there no core kernel API that provides this?

On arm64, there is a per-cpu cpuinfo structure kept for each online CPU, which keeps
cached values of the ID registers. May be we could use that here.
See arch/arm64/kernel/cpuinfo.c::__cpuinfo_store_cpu()

Suzuki
