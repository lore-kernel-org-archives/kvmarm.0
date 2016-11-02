From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH] kvmtool/arm: add support for vGICv3 and vITS
Date: Wed, 2 Nov 2016 13:16:06 +0000
Message-ID: <5819E716.3070808@arm.com>
References: <1478087780-19697-1-git-send-email-vladimir.murzin@arm.com>
 <ac31697f-5228-67f7-1d36-03a0bd848272@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31CC4025C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 09:15:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aIPDUZ01-rQO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2016 09:15:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79209401D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 09:15:56 -0400 (EDT)
In-Reply-To: <ac31697f-5228-67f7-1d36-03a0bd848272@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 02/11/16 12:18, Andre Przywara wrote:
> Hi Vladimir,
> 
> thanks for looking at this.
> 
> ....
> 
> On 02/11/16 11:56, Vladimir Murzin wrote:
>> KVM/arm got support for vGICv3 and vITS recently, so make use of it.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>
>> This patch is against its/v8 branch at [1]
>>
>> [1] git://www.linux-arm.org/kvmtool.git
>>
>>  arm/aarch32/arm-cpu.c              |    2 +-
>>  arm/aarch32/include/kvm/kvm-arch.h |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
>> index 27a8e17..16bba55 100644
>> --- a/arm/aarch32/arm-cpu.c
>> +++ b/arm/aarch32/arm-cpu.c
>> @@ -12,7 +12,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>>  {
>>  	int timer_interrupts[4] = {13, 14, 11, 10};
>>  
>> -	gic__generate_fdt_nodes(fdt, IRQCHIP_GICV2);
>> +	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
>>  	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>>  }
>>  
>> diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
>> index 1632e3c..99231f6 100644
>> --- a/arm/aarch32/include/kvm/kvm-arch.h
>> +++ b/arm/aarch32/include/kvm/kvm-arch.h
>> @@ -1,8 +1,8 @@
>>  #ifndef KVM__KVM_ARCH_H
>>  #define KVM__KVM_ARCH_H
>>  
>> -#define ARM_GIC_DIST_SIZE	0x1000
>> -#define ARM_GIC_CPUI_SIZE	0x2000
>> +#define ARM_GIC_DIST_SIZE	0x100000
>> +#define ARM_GIC_CPUI_SIZE	0x200000
> 
> Is there a spare 0 in there? I guess 64K & 128K are sufficient and we
> don't need 1MB and 2MB, respectively?

Fat fingers :( Thanks for spotting this!

> 
> Given that you meant this the #define's for both aarch32 and aarch64 are
> now the same, so we can remove the definition above and in the
> respective aarch64 header file and put them into arm-common/kvm-arch.h
> instead.

Sending v2 shortly.

Cheers
Vladimir

> 
> Cheers,
> Andre.
> 
>>  
>>  #define ARM_KERN_OFFSET(...)	0x8000
>>  
>>
> 
