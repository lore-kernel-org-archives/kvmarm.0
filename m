From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 19/23] arm64: KVM: Allow far branches from vector slots
 to the main vectors
Date: Mon, 12 Mar 2018 19:43:30 +0000
Message-ID: <5f76d3c3-ab68-8f46-7ffe-b3dea21c123c@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-20-marc.zyngier@arm.com> <5AA6C674.90607@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AA6C674.90607@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 12/03/18 18:27, James Morse wrote:
> Hi Marc,
> 
> On 01/03/18 15:55, Marc Zyngier wrote:
>> So far, the branch from the vector slots to the main vectors can at
>> most be 4GB from the main vectors (the reach of ADRP), and this
>> distance is known at compile time. If we were to remap the slots
>> to an unrelated VA, things would break badly.
>>
>> A way to achieve VA independence would be to load the absolute
>> address of the vectors (__kvm_hyp_vector), either using a constant
>> pool or a series of movs, followed by an indirect branch.
>>
>> This patches implements the latter solution, using another instance
>> of a patching callback.
> 
>> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
>> index e000cb390618..e8d997788ad0 100644
>> --- a/arch/arm64/kernel/bpi.S
>> +++ b/arch/arm64/kernel/bpi.S
>> @@ -19,6 +19,9 @@
>>  #include <linux/linkage.h>
>>  #include <linux/arm-smccc.h>
>>  
>> +#include <asm/alternative.h>
>> +#include <asm/kvm_mmu.h>
>> +
>>  .macro hyp_ventry offset
>>  	.align 7
>>  	.rept 29
>> @@ -64,9 +67,15 @@ ENTRY(__bp_harden_hyp_vecs_start)
>>  	.endr
>>  
>>  __kvm_enter_vectors:
>> +alternative_cb	kvm_patch_vector_branch
>> +	movz	x1, #0
>> +	movk	x1, #0, lsl #16
>> +	movk	x1, #0, lsl #32
>> +	movk	x1, #0, lsl #48
>> +alternative_cb_end
>>  
>> -	adr_l	x1, __kvm_hyp_vector
>>  	add	x0, x1, x0
>> +	kern_hyp_va x0
> 
> Can't you patch the kern_hyp_va address into the movk block directly?
> Obviously you can't call kern_hyp_va, but you could generate the layout and have
> some slow __kern_hyp_va() to generate the value. This would avoid generating a
> value, to then throw half of it away and patch something else in.

Hmmm. That's pretty twisted. Actually, this is utterly terrifying. And
thus absolutely mandatory. Irk. I really like it.

> Does this code run for VHE systems too? (it not, is the x<<48 movk needed?)

This is indeed VHE only, and if/when I adopt your suggestion, we'll be
able to drop the last movk, effectively getting rid of 6 instructions on
the exception path. Awesome!

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
