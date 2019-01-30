From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/5] arm/arm64: KVM: Don't panic on failure to properly
 reset system registers
Date: Wed, 30 Jan 2019 10:56:19 +0000
Message-ID: <b2c0fa37-37ad-3696-e862-5d0434496d1f@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-6-christoffer.dall@arm.com>
 <20190129163337.nbwivspcvlcmzrmo@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 997A24A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 05:56:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efxfo+GfhDLJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 05:56:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 472A040217
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 05:56:23 -0500 (EST)
In-Reply-To: <20190129163337.nbwivspcvlcmzrmo@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/2019 16:33, Andrew Jones wrote:
> On Fri, Jan 25, 2019 at 10:46:56AM +0100, Christoffer Dall wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Failing to properly reset system registers is pretty bad. But not
>> quite as bad as bringing the whole machine down... So warn loudly,
>> but slightly more gracefully.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
>> ---
>>  arch/arm/kvm/coproc.c     | 4 ++--
>>  arch/arm64/kvm/sys_regs.c | 4 ++--
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index 222c1635bc7a..e8bd288fd5be 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -1450,6 +1450,6 @@ void kvm_reset_coprocs(struct kvm_vcpu *vcpu)
>>  	reset_coproc_regs(vcpu, table, num);
>>  
>>  	for (num = 1; num < NR_CP15_REGS; num++)
>> -		if (vcpu_cp15(vcpu, num) == 0x42424242)
>> -			panic("Didn't reset vcpu_cp15(vcpu, %zi)", num);
>> +		WARN(vcpu_cp15(vcpu, num) == 0x42424242,
>> +		     "Didn't reset vcpu_cp15(vcpu, %zi)", num);
>>  }
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 86096774abcd..4f067545c7d2 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2609,6 +2609,6 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>  	reset_sys_reg_descs(vcpu, table, num);
>>  
>>  	for (num = 1; num < NR_SYS_REGS; num++)
>> -		if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
>> -			panic("Didn't reset __vcpu_sys_reg(%zi)", num);
>> +		WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
>> +		     "Didn't reset __vcpu_sys_reg(%zi)\n", num);
>>  }
>> -- 
>> 2.18.0
>>
> 
> If we only get halfway through resetting, then we'll get a warn splat,
> complete with a backtrace, for each register. Should we do something
> like the following instead?
> 
>   for (num = 1; num < NR_SYS_REGS; num++)
>      if (__vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
>         failed++;
>   WARN(failed, "Didn't reset %d system registers", failed);

And doing so we'd loose the important bit of information, which is the
position in the table that doesn't get initialized.

The vcpu reset issue is rare enough that nobody noticed it yet (I only
reproduced it twice), and having it to scream 200 times is not really a
concern. What I want to catch is the case where someone has added a new
sysreg in the table, and has failed to provide a working init function.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
