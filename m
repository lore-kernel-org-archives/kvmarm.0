Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D68CA9EB7
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 10:06:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41DA92089C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 10:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41DA92089C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7931B4A81C;
	Mon, 21 Oct 2019 06:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 21RlU+M930t7; Mon, 21 Oct 2019 06:06:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6834A9A1;
	Mon, 21 Oct 2019 06:06:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50A9B4AC18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 01:01:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CDHQo9VBERbN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 01:01:25 -0400 (EDT)
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C7F74AC14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 01:01:25 -0400 (EDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
 by mx1.suse.de (Postfix) with ESMTP id BB36EB236;
 Mon, 21 Oct 2019 05:01:23 +0000 (UTC)
Subject: Re: [PATCH v6 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-11-steven.price@arm.com> <86a79wzdhk.wl-maz@kernel.org>
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <237a3457-bcb3-c9b7-11ef-241b7ccc370e@suse.com>
Date: Mon, 21 Oct 2019 07:01:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <86a79wzdhk.wl-maz@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Mon, 21 Oct 2019 06:06:11 -0400
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 19.10.19 22:28, Marc Zyngier wrote:
> On Fri, 11 Oct 2019 13:59:30 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Enable paravirtualization features when running under a hypervisor
>> supporting the PV_TIME_ST hypercall.
>>
>> For each (v)CPU, we ask the hypervisor for the location of a shared
>> page which the hypervisor will use to report stolen time to us. We set
>> pv_time_ops to the stolen time function which simply reads the stolen
>> value from the shared page for a VCPU. We guarantee single-copy
>> atomicity using READ_ONCE which means we can also read the stolen
>> time for another VCPU than the currently running one while it is
>> potentially being updated by the hypervisor.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   .../admin-guide/kernel-parameters.txt         |   6 +-
>>   arch/arm64/include/asm/paravirt.h             |   9 +-
>>   arch/arm64/kernel/paravirt.c                  | 148 ++++++++++++++++++
>>   arch/arm64/kernel/time.c                      |   3 +
>>   include/linux/cpuhotplug.h                    |   1 +
>>   5 files changed, 163 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index c7ac2f3ac99f..346b1c7a4afb 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -3083,9 +3083,9 @@
>>   			[X86,PV_OPS] Disable paravirtualized VMware scheduler
>>   			clock and use the default one.
>>   
>> -	no-steal-acc	[X86,KVM] Disable paravirtualized steal time accounting.
>> -			steal time is computed, but won't influence scheduler
>> -			behaviour
>> +	no-steal-acc	[X86,KVM,ARM64] Disable paravirtualized steal time
>> +			accounting. steal time is computed, but won't
>> +			influence scheduler behaviour
>>   
>>   	nolapic		[X86-32,APIC] Do not enable or use the local APIC.
>>   
>> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
>> index 799d9dd6f7cc..125c26c42902 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
>>   {
>>   	return pv_ops.time.steal_clock(cpu);
>>   }
>> -#endif
>> +
>> +int __init kvm_guest_init(void);
>> +
>> +#else
>> +
>> +#define kvm_guest_init()
>> +
>> +#endif // CONFIG_PARAVIRT
>>   
>>   #endif
>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index 4cfed91fe256..de73dbec238c 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -6,13 +6,161 @@
>>    * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>    */
>>   
>> +#define pr_fmt(fmt) "kvmarm-pv: " fmt
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/cpuhotplug.h>
>>   #include <linux/export.h>
>> +#include <linux/io.h>
>>   #include <linux/jump_label.h>
>> +#include <linux/printk.h>
>> +#include <linux/psci.h>
>> +#include <linux/reboot.h>
>> +#include <linux/slab.h>
>>   #include <linux/types.h>
>> +
>>   #include <asm/paravirt.h>
>> +#include <asm/pvclock-abi.h>
>> +#include <asm/smp_plat.h>
>>   
>>   struct static_key paravirt_steal_enabled;
>>   struct static_key paravirt_steal_rq_enabled;
>>   
>>   struct paravirt_patch_template pv_ops;
>>   EXPORT_SYMBOL_GPL(pv_ops);
>> +
>> +struct kvmarm_stolen_time_region {
>> +	struct pvclock_vcpu_stolen_time *kaddr;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
>> +
>> +static bool steal_acc = true;
>> +static int __init parse_no_stealacc(char *arg)
>> +{
>> +	steal_acc = false;
>> +	return 0;
>> +}
>> +
>> +early_param("no-steal-acc", parse_no_stealacc);
>> +
>> +/* return stolen time in ns by asking the hypervisor */
>> +static u64 kvm_steal_clock(int cpu)
> 
> This isn't KVM specific.
> 
>> +{
>> +	struct kvmarm_stolen_time_region *reg;
>> +
>> +	reg = per_cpu_ptr(&stolen_time_region, cpu);
>> +	if (!reg->kaddr) {
>> +		pr_warn_once("stolen time enabled but not configured for cpu %d\n",
>> +			     cpu);
>> +		return 0;
>> +	}
>> +
>> +	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
>> +}
>> +
>> +static int disable_stolen_time_current_cpu(void)
>> +{
>> +	struct kvmarm_stolen_time_region *reg;
>> +
>> +	reg = this_cpu_ptr(&stolen_time_region);
>> +	if (!reg->kaddr)
>> +		return 0;
>> +
>> +	memunmap(reg->kaddr);
>> +	memset(reg, 0, sizeof(*reg));
>> +
>> +	return 0;
>> +}
>> +
>> +static int stolen_time_dying_cpu(unsigned int cpu)
>> +{
>> +	return disable_stolen_time_current_cpu();
>> +}
> 
> You can merge these two functions, as there is no other caller.
> 
>> +
>> +static int init_stolen_time_cpu(unsigned int cpu)
>> +{
>> +	struct kvmarm_stolen_time_region *reg;
>> +	struct arm_smccc_res res;
>> +
>> +	reg = this_cpu_ptr(&stolen_time_region);
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_ST, &res);
>> +
>> +	if ((long)res.a0 < 0)
>> +		return -EINVAL;
> 
> I'd rather you check an actual error code, just in case the memory map
> starts growing to a point where we have 64bit (I)PAs...
> 
>> +
>> +	reg->kaddr = memremap(res.a0,
>> +			      sizeof(struct pvclock_vcpu_stolen_time),
>> +			      MEMREMAP_WB);
>> +
>> +	if (!reg->kaddr) {
>> +		pr_warn("Failed to map stolen time data structure\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (le32_to_cpu(reg->kaddr->revision) != 0 ||
>> +	    le32_to_cpu(reg->kaddr->attributes) != 0) {
>> +		pr_warn("Unexpected revision or attributes in stolen time data\n");
> 
> WARN_ONCE instead? You probably don't want to scream for each and
> every CPU that boots...
> 
>> +		return -ENXIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kvm_arm_init_stolen_time(void)
>> +{
>> +	int ret;
>> +
>> +	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
>> +				"hypervisor/kvmarm/pv:starting",
>> +				init_stolen_time_cpu, stolen_time_dying_cpu);
>> +	if (ret < 0)
>> +		return ret;
>> +	return 0;
>> +}
>> +
>> +static bool has_kvm_steal_clock(void)
> 
> This is not KVM specific either.
> 
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	/* To detect the presence of PV time support we require SMCCC 1.1+ */
>> +	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
>> +		return false;
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>> +			     ARM_SMCCC_HV_PV_TIME_FEATURES, &res);
>> +
>> +	if (res.a0 != SMCCC_RET_SUCCESS)
>> +		return false;
>> +
>> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_FEATURES,
>> +			     ARM_SMCCC_HV_PV_TIME_ST, &res);
>> +
>> +	if (res.a0 != SMCCC_RET_SUCCESS)
>> +		return false;
>> +
>> +	return true;
> 
> 	return (res.a0 == SMCCC_RET_SUCCESS);
> 
>> +}
>> +
>> +int __init kvm_guest_init(void)
> 
> How about something like pv_time_init() instead? In the guest, this is
> no way KVM specific, and I still hope for this to work on things like
> Xen/HyperV/VMware (yeah, I'm foolishly optimistic). All the references
> to KVM should go, and be replaced by something more generic (after
> all, you're only implementing the spec, so feel free to call it
> den0057_* if you really want).

Xen guests already have the needed functionality. On ARM this just needs
to be hooked up.


Juergen
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
