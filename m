From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Add support for ARMv8 AArch32 execution
 state
Date: Fri, 23 Sep 2016 10:30:46 +0100
Message-ID: <57E4F646.1000204@arm.com>
References: <1474614805-18629-1-git-send-email-b18965@freescale.com>
 <20160923092550.GG9101@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 488A34998D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:21:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tU7De3ZA7LWM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2016 05:21:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02DA541267
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2016 05:21:38 -0400 (EDT)
In-Reply-To: <20160923092550.GG9101@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Alison Wang <b18965@freescale.com>
Cc: jason.jin@nxp.com, kvm@vger.kernel.org, alison.wang@nxp.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/16 10:25, Christoffer Dall wrote:
> On Fri, Sep 23, 2016 at 03:13:25PM +0800, Alison Wang wrote:
>> The ARMv8 architecture supports two execution state, AArch64 and
>> AArch32. To support KVM in AArch32 execution state for ARMv8, Cortex-A53
>> and Cortex-A72 need to be added for target-specific checks.
>>
>> Signed-off-by: Alison Wang <alison.wang@nxp.com>
>> ---
>>  arch/arm/include/asm/cputype.h | 2 ++
>>  arch/arm/kvm/guest.c           | 2 ++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
>> index 754f86f..4f8c632 100644
>> --- a/arch/arm/include/asm/cputype.h
>> +++ b/arch/arm/include/asm/cputype.h
>> @@ -75,6 +75,8 @@
>>  #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
>>  #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
>>  #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
>> +#define ARM_CPU_PART_CORTEX_A53_AARCH32	0x4100d030
>> +#define ARM_CPU_PART_CORTEX_A72_AARCH32	0x4100d080
>>  #define ARM_CPU_PART_MASK		0xff00fff0
>>  
>>  /* DEC implemented cores */
>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>> index 9aca920..462a099 100644
>> --- a/arch/arm/kvm/guest.c
>> +++ b/arch/arm/kvm/guest.c
>> @@ -252,6 +252,8 @@ int __attribute_const__ kvm_target_cpu(void)
>>  {
>>  	switch (read_cpuid_part()) {
>>  	case ARM_CPU_PART_CORTEX_A7:
>> +	case ARM_CPU_PART_CORTEX_A53_AARCH32:
>> +	case ARM_CPU_PART_CORTEX_A72_AARCH32:
> 
> huh?  why are we mapping A53 and A72 cores to an A7 core?

Yeah, that's absolutely disgusting. The only sensible thing to do would
be to implement something "generic", just like we have on the 64bit side.

As it stands, this patch falls into the "No way" bucket.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
