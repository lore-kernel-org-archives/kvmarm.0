From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Fix AArch64 guest userspace exception
 injection
Date: Mon, 11 Jan 2016 10:06:16 +0000
Message-ID: <56937E98.9090200@arm.com>
References: <1452157416-9435-1-git-send-email-marc.zyngier@arm.com>
 <20160110194526.GB13541@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A80349B91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2016 05:02:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HwpGRDNkwPFO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2016 05:02:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE8249B86
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2016 05:02:21 -0500 (EST)
In-Reply-To: <20160110194526.GB13541@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/01/16 19:45, Christoffer Dall wrote:
> On Thu, Jan 07, 2016 at 09:03:36AM +0000, Marc Zyngier wrote:
>> At the moment, our fault injection is pretty limited. We always
>> generate a SYNC exception into EL1, as if the fault was actually
>> from EL1h, no matter how it was generated.
>>
>> This is obviously wrong, as EL0 can generate faults of its own
>> (not to mention the pretty-much unused EL1t mode).
>>
>> This patch fixes it by implementing section D1.10.2 of the ARMv8 ARM,
>> and in particular table D1-7 ("Vector offsets from vector table base
>> address"), which describes which vector to use depending on the source
>> exception level and type (synchronous, IRQ, FIQ or SError).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/inject_fault.c | 38 +++++++++++++++++++++++++++++++++++---
>>  1 file changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>> index 648112e..4d1ac81 100644
>> --- a/arch/arm64/kvm/inject_fault.c
>> +++ b/arch/arm64/kvm/inject_fault.c
>> @@ -27,7 +27,11 @@
>>  
>>  #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
>>  				 PSR_I_BIT | PSR_D_BIT)
>> -#define EL1_EXCEPT_SYNC_OFFSET	0x200
>> +
>> +#define CURRENT_EL_SP_EL0_VECTOR	0x0
>> +#define CURRENT_EL_SP_ELx_VECTOR	0x200
>> +#define LOWER_EL_AArch64_VECTOR		0x400
>> +#define LOWER_EL_AArch32_VECTOR		0x600
>>  
>>  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
>>  {
>> @@ -97,6 +101,34 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
>>  		*fsr = 0x14;
>>  }
>>  
>> +enum exception_type {
>> +	except_type_sync	= 0,
>> +	except_type_irq		= 0x80,
>> +	except_type_fiq		= 0x100,
>> +	except_type_serror	= 0x180,
>> +};
>> +
>> +static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
>> +{
>> +	u64 exc_offset;
>> +
>> +	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
>> +	case PSR_MODE_EL1t:
>> +		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
>> +		break;
>> +	case PSR_MODE_EL1h:
>> +		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
>> +		break;
>> +	case PSR_MODE_EL0t:
>> +		exc_offset = LOWER_EL_AArch64_VECTOR;
>> +		break;
>> +	default:
>> +		exc_offset = LOWER_EL_AArch32_VECTOR;
> 
> so this catches any EL0 32-bit state, right?

Indeed.

> 
> If so:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
