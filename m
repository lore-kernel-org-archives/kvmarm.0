From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 03/11] KVM: arm64: Change hyp_panic()s dependency on
 tpidr_el2
Date: Thu, 08 Jun 2017 11:23:55 +0100
Message-ID: <593925BB.30503@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-4-james.morse@arm.com> <20170606194525.GK9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D472C40969
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 06:20:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AFssXkUchOK2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 06:20:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 056E340430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 06:20:33 -0400 (EDT)
In-Reply-To: <20170606194525.GK9464@cbox>
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

On 06/06/17 20:45, Christoffer Dall wrote:
> On Mon, May 15, 2017 at 06:43:51PM +0100, James Morse wrote:
>> KVM calls hyp_panic() when anything unexpected happens. This may occur
>> while a guest owns the EL1 registers. KVM stashes the vcpu pointer in
>> tpidr_el2, which it uses to find the host context in order to restore
>> the host EL1 registers before parachuting into the host's panic().
>>
>> The host context is a struct kvm_cpu_context allocated in the per-cpu
>> area, and mapped to hyp. Given the per-cpu offset for this CPU, this is
>> easy to find. Change hyp_panic() to take a pointer to the
>> struct kvm_cpu_context. Wrap these calls with an asm function that
>> retrieves the struct kvm_cpu_context from the host's per-cpu area.
>>
>> Copy the per-cpu offset from the hosts tpidr_el1 into tpidr_el2 during
>> kvm init. (Later patches will make this unnecessary for VHE hosts)
>>
>> We print out the vcpu pointer as part of the panic message. Add a back
>> reference to the 'running vcpu' in the host cpu context to preserve this.

>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>> index fce7cc507e0a..0f83e7e402ad 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -163,6 +163,13 @@ ENTRY(__hyp_do_panic)
>>  	eret
>>  ENDPROC(__hyp_do_panic)
>>  
>> +ENTRY(__hyp_panic)
>> +	ldr	x0, =kvm_host_cpu_state
> 
> Why is this guaranteed to give us a valid EL2 address?

... it doesn't. Its a host address from the constant pool which is used by
hyp-panic as __host_ctxt:
> void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt);

and fixed up with:
> host_ctxt = kern_hyp_va(__host_ctxt);

to give us the EL2 address before we access it.
For VHE the last step is a nop as the host address can be accessed directly.

I will add a comment here explaining this.


Thanks!

James
