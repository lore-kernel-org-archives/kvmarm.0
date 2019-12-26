Return-Path: <SRS0=3oJT=2Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B06C2D0DB
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 08:34:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64C8B2071E
	for <kvmarm@archiver.kernel.org>; Thu, 26 Dec 2019 08:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64C8B2071E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3E94ACBE;
	Thu, 26 Dec 2019 03:34:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yvgt5-rkH5t8; Thu, 26 Dec 2019 03:34:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F514AC87;
	Thu, 26 Dec 2019 03:34:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2566A4A95D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 03:34:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3zEKA-WWjUx0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Dec 2019 03:34:46 -0500 (EST)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88A9E4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Dec 2019 03:34:45 -0500 (EST)
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
 by Forcepoint Email with ESMTP id 7577A6BC005611B887E2;
 Thu, 26 Dec 2019 16:34:42 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Dec 2019 16:34:41 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 26
 Dec 2019 16:34:41 +0800
Subject: Re: [PATCH 5/5] KVM: arm64: Support the vcpu preemption check
To: Steven Price <steven.price@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-6-yezengruan@huawei.com>
 <20191217144032.GD38811@arm.com>
From: yezengruan <yezengruan@huawei.com>
Message-ID: <eab5db1c-84d1-5160-3d29-33bbb72f328a@huawei.com>
Date: Thu, 26 Dec 2019 16:34:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217144032.GD38811@arm.com>
Content-Language: en-US
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Catalin
 Marinas <Catalin.Marinas@arm.com>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Steve,

On 2019/12/17 22:40, Steven Price wrote:
> On Tue, Dec 17, 2019 at 01:55:49PM +0000, yezengruan@huawei.com wrote:
>> From: Zengruan Ye <yezengruan@huawei.com>
>>
>> Support the vcpu_is_preempted() functionality under KVM/arm64. This will
>> enhance lock performance on overcommitted hosts (more runnable vcpus
>> than physical cpus in the system) as doing busy waits for preempted
>> vcpus will hurt system performance far worse than early yielding.
>>
>> unix benchmark result:
>>   host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 cpus
>>   guest: kernel 5.5.0-rc1, 16 vcpus
>>
>>                test-case                |    after-patch    |   before-patch
>> ----------------------------------------+-------------------+------------------
>>  Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
>>  Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
>>  Execl Throughput                       |      3662.1 lps   |      2718.0 lps
>>  File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
>>  File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
>>  File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
>>  Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
>>  Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
>>  Process Creation                       |      4025.7 lps   |      3706.6 lps
>>  Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
>>  Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
>>  System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
>> ----------------------------------------+-------------------+------------------
>>  System Benchmarks Index Score          |      1835.1       |      1327.6
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>  arch/arm64/include/asm/paravirt.h |  3 +
>>  arch/arm64/kernel/paravirt.c      | 91 +++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/setup.c         |  2 +
>>  include/linux/cpuhotplug.h        |  1 +
>>  4 files changed, 97 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
>> index 7b1c81b544bb..a2cd0183bbef 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -29,6 +29,8 @@ static inline u64 paravirt_steal_clock(int cpu)
>>  
>>  int __init pv_time_init(void);
>>  
>> +int __init kvm_guest_init(void);
>> +
> 
> This is a *very* generic name - I suggest something like pv_lock_init()
> so it's clear what the function actually does.
> 
>>  __visible bool __native_vcpu_is_preempted(int cpu);
>>  
>>  static inline bool pv_vcpu_is_preempted(int cpu)
>> @@ -39,6 +41,7 @@ static inline bool pv_vcpu_is_preempted(int cpu)
>>  #else
>>  
>>  #define pv_time_init() do {} while (0)
>> +#define kvm_guest_init() do {} while (0)
>>  
>>  #endif // CONFIG_PARAVIRT
>>  
>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index d8f1ba8c22ce..a86dead40473 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -22,6 +22,7 @@
>>  #include <asm/paravirt.h>
>>  #include <asm/pvclock-abi.h>
>>  #include <asm/smp_plat.h>
>> +#include <asm/pvlock-abi.h>
>>  
>>  struct static_key paravirt_steal_enabled;
>>  struct static_key paravirt_steal_rq_enabled;
>> @@ -158,3 +159,93 @@ int __init pv_time_init(void)
>>  
>>  	return 0;
>>  }
>> +
>> +DEFINE_PER_CPU(struct pvlock_vcpu_state, pvlock_vcpu_region) __aligned(64);
>> +EXPORT_PER_CPU_SYMBOL(pvlock_vcpu_region);
>> +
>> +static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
>> +{
>> +	struct pvlock_vcpu_state *reg;
>> +
>> +	reg = this_cpu_ptr(&pvlock_vcpu_region);
>> +	if (!reg)
>> +		return -EFAULT;
>> +
>> +	memset(reg, 0, sizeof(*reg));
> 
> I might be missing something obvious here - but I don't see the point of
> this. The hypervisor might immediately overwrite the structure again.
> Indeed you should conside a mechanism for the guest to "unregister" the
> region - otherwise you will face issues with the likes of kexec.
> 
> For pv_time the memory is allocated by the hypervisor not the guest to
> avoid lifetime issues about kexec.


Thanks for pointing it out to me! I'll update the memory allocation
mechanism of the PV lock structure to avoid lifetime issues about
kexec.

> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int init_pvlock_vcpu_state(unsigned int cpu)
>> +{
>> +	struct pvlock_vcpu_state *reg;
>> +	struct arm_smccc_res res;
>> +
>> +	reg = this_cpu_ptr(&pvlock_vcpu_region);
>> +	if (!reg)
>> +		return -EFAULT;
>> +
>> +	/* Pass the memory address to host via hypercall */
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_LOCK_PREEMPTED,
>> +			     virt_to_phys(reg), &res);
>> +
>> +	return 0;
>> +}
>> +
>> +static bool kvm_vcpu_is_preempted(int cpu)
>> +{
>> +	struct pvlock_vcpu_state *reg = &per_cpu(pvlock_vcpu_region, cpu);
>> +
>> +	if (reg)
>> +		return !!(reg->preempted & 1);
>> +
>> +	return false;
>> +}
>> +
>> +static int kvm_arm_init_pvlock(void)
>> +{
>> +	int ret;
>> +
>> +	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>> +				"hypervisor/arm/pvlock:starting",
>> +				init_pvlock_vcpu_state,
>> +				pvlock_vcpu_state_dying_cpu);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	pv_ops.lock.vcpu_is_preempted = kvm_vcpu_is_preempted;
>> +
>> +	pr_info("using PV-lock preempted\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static bool has_kvm_pvlock(void)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	/* To detect the presence of PV lock support we require SMCCC 1.1+ */
>> +	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
>> +		return false;
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>> +			     ARM_SMCCC_HV_PV_LOCK_FEATURES, &res);
>> +
>> +	if (res.a0 != SMCCC_RET_SUCCESS)
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +int __init kvm_guest_init(void)
>> +{
>> +	if (is_hyp_mode_available())
>> +		return 0;
>> +
>> +	if (!has_kvm_pvlock())
>> +		return 0;
>> +
>> +	kvm_arm_init_pvlock();
> 
> Consider reporting errors from kvm_arm_init_pvlock()? At the moment
> it's impossible to tell the difference between pvlock not being
> supported and something failing in the setup.

Good point, I'll update the code.

> 
> Steve
> 
>> +
>> +	return 0;
>> +}
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 56f664561754..64c4d515ba2d 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -341,6 +341,8 @@ void __init setup_arch(char **cmdline_p)
>>  	smp_init_cpus();
>>  	smp_build_mpidr_hash();
>>  
>> +	kvm_guest_init();
>> +
>>  	/* Init percpu seeds for random tags after cpus are set up. */
>>  	kasan_init_tags();
>>  
>> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> index e51ee772b9f5..f72ff95ab63a 100644
>> --- a/include/linux/cpuhotplug.h
>> +++ b/include/linux/cpuhotplug.h
>> @@ -138,6 +138,7 @@ enum cpuhp_state {
>>  	CPUHP_AP_DUMMY_TIMER_STARTING,
>>  	CPUHP_AP_ARM_XEN_STARTING,
>>  	CPUHP_AP_ARM_KVMPV_STARTING,
>> +	CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>>  	CPUHP_AP_ARM_CORESIGHT_STARTING,
>>  	CPUHP_AP_ARM64_ISNDEP_STARTING,
>>  	CPUHP_AP_SMPCFD_DYING,
>> -- 
>> 2.19.1
>>
>>
> 
> .
> 

Thanks,

Zengruan

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
