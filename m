From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 01/11] KVM: arm64: Store vcpu on the stack during
 __guest_enter()
Date: Tue, 08 Aug 2017 17:48:29 +0100
Message-ID: <5989EB5D.6@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-2-james.morse@arm.com> <20170606195951.GN9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8650940CE0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:48:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id egmgctB-yg8L for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 12:48:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CEB140C5A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:48:11 -0400 (EDT)
In-Reply-To: <20170606195951.GN9464@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 06/06/17 20:59, Christoffer Dall wrote:
> On Mon, May 15, 2017 at 06:43:49PM +0100, James Morse wrote:
>> KVM uses tpidr_el2 as its private vcpu register, which makes sense for
>> non-vhe world switch as only KVM can access this register. This means
>> vhe Linux has to use tpidr_el1, which KVM has to save/restore as part
>> of the host context.
>>
>> __guest_enter() stores the host_ctxt on the stack, do the same with
>> the vcpu.

>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>> index 12ee62d6d410..113735df7d01 100644
>> --- a/arch/arm64/kvm/hyp/entry.S
>> +++ b/arch/arm64/kvm/hyp/entry.S
>> @@ -159,9 +159,15 @@ abort_guest_exit_end:
>>  ENDPROC(__guest_exit)
>>  
>>  ENTRY(__fpsimd_guest_restore)
>> +	// x0: esr
>> +	// x1: vcpu
>> +	// x2-x29,lr: vcpu regs
>> +	// vcpu x0-x1 on the stack
>>  	stp	x2, x3, [sp, #-16]!
>>  	stp	x4, lr, [sp, #-16]!
>>  
>> +	mov	x3, x1
>> +
> 
> nit: can you avoid this by using x1 for the vcpu pointer in this routine
> instead?

Unfortunately x1 is clobbered by the __fpsimd_{save,restore}_state() macros that
are called further down this function.

(its a bit obscure:
> fpsimd_save	x0, 1
that '1' is used to generate 'x1' or 'w1' in includes/asm/fpsimdmacros.h)



Thanks,

James
