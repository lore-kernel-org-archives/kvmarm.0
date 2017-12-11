From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 22/36] KVM: arm64: Prepare to handle traps on deferred
 VM sysregs
Date: Mon, 11 Dec 2017 11:46:12 +0000
Message-ID: <9861466d-d296-8b11-d7da-4c2232c56e9f@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-23-christoffer.dall@linaro.org>
 <7f4ecd66-fca1-4da9-3524-ee64d999a501@arm.com> <20171211112436.GH910@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1FD849D54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 06:42:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mAqlduN0zjFK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 06:42:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B65649D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 06:42:49 -0500 (EST)
In-Reply-To: <20171211112436.GH910@cbox>
Content-Language: en-GB
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
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/12/17 11:24, Christoffer Dall wrote:
> On Mon, Dec 11, 2017 at 11:10:36AM +0000, Marc Zyngier wrote:
>> On 07/12/17 17:06, Christoffer Dall wrote:
>>> When we defer the save/restore of system registers to vcpu_load and
>>> vcpu_put, we need to take care of the emulation code that handles traps
>>> to these registers, since simply reading the memory array will return
>>> stale data.
>>>
>>> Therefore, introduce two functions to directly read/write the registers
>>> from the physical CPU when we're on a VHE system that has loaded the
>>> system registers onto the physical CPU.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>
>>> Notes:
>>>     Changes since v1:
>>>      - Removed spurious white space
>>>
>>>  arch/arm64/include/asm/kvm_host.h |  4 +++
>>>  arch/arm64/kvm/sys_regs.c         | 53 +++++++++++++++++++++++++++++++++++++--
>>>  2 files changed, 55 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index de0d55b30b61..f6afe685a280 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -279,6 +279,10 @@ struct kvm_vcpu_arch {
>>>  
>>>  	/* Detect first run of a vcpu */
>>>  	bool has_run_once;
>>> +
>>> +	/* True when deferrable sysregs are loaded on the physical CPU,
>>> +	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
>>> +	bool sysregs_loaded_on_cpu;
>>>  };
>>>  
>>>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 62c12ab9e6c4..80adbec933de 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -35,6 +35,7 @@
>>>  #include <asm/kvm_coproc.h>
>>>  #include <asm/kvm_emulate.h>
>>>  #include <asm/kvm_host.h>
>>> +#include <asm/kvm_hyp.h>
>>>  #include <asm/kvm_mmu.h>
>>>  #include <asm/perf_event.h>
>>>  #include <asm/sysreg.h>
>>> @@ -111,6 +112,54 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>>>  	return true;
>>>  }
>>>  
>>> +static u64 read_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg)
>>> +{
>>> +	if (vcpu->arch.sysregs_loaded_on_cpu) {
>>> +		switch (reg) {
>>> +		case SCTLR_EL1:		return read_sysreg_el1(sctlr);
>>> +		case TTBR0_EL1:		return read_sysreg_el1(ttbr0);
>>> +		case TTBR1_EL1:		return read_sysreg_el1(ttbr1);
>>> +		case TCR_EL1:		return read_sysreg_el1(tcr);
>>> +		case ESR_EL1:		return read_sysreg_el1(esr);
>>> +		case FAR_EL1:		return read_sysreg_el1(far);
>>> +		case AFSR0_EL1:		return read_sysreg_el1(afsr0);
>>> +		case AFSR1_EL1:		return read_sysreg_el1(afsr1);
>>> +		case MAIR_EL1:		return read_sysreg_el1(mair);
>>> +		case AMAIR_EL1:		return read_sysreg_el1(amair);
>>> +		case CONTEXTIDR_EL1:	return read_sysreg_el1(contextidr);
>>> +		case DACR32_EL2:	return read_sysreg(dacr32_el2);
>>> +		case IFSR32_EL2:	return read_sysreg(ifsr32_el2);
>>> +		default:		BUG();
>>> +		}
>>> +	}
>>> +
>>> +	return vcpu_sys_reg(vcpu, reg);
>>> +}
>>> +
>>> +static void write_deferrable_vm_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
>>> +{
>>> +	if (vcpu->arch.sysregs_loaded_on_cpu) {
>>> +		switch (reg) {
>>> +		case SCTLR_EL1:		write_sysreg_el1(val, sctlr);	return;
>>> +		case TTBR0_EL1:		write_sysreg_el1(val, ttbr0);	return;
>>> +		case TTBR1_EL1:		write_sysreg_el1(val, ttbr1);	return;
>>> +		case TCR_EL1:		write_sysreg_el1(val, tcr);	return;
>>> +		case ESR_EL1:		write_sysreg_el1(val, esr);	return;
>>> +		case FAR_EL1:		write_sysreg_el1(val, far);	return;
>>> +		case AFSR0_EL1:		write_sysreg_el1(val, afsr0);	return;
>>> +		case AFSR1_EL1:		write_sysreg_el1(val, afsr1);	return;
>>> +		case MAIR_EL1:		write_sysreg_el1(val, mair);	return;
>>> +		case AMAIR_EL1:		write_sysreg_el1(val, amair);	return;
>>> +		case CONTEXTIDR_EL1:	write_sysreg_el1(val, contextidr); return;
>>> +		case DACR32_EL2:	write_sysreg(val, dacr32_el2); return;
>>> +		case IFSR32_EL2:	write_sysreg(val, ifsr32_el2); return;
>>> +		default:		BUG();
>>> +		}
>>> +	}
>>> +
>>> +	vcpu_sys_reg(vcpu, reg) = val;
>>> +}
>>> +
>>>  /*
>>>   * Generic accessor for VM registers. Only called as long as HCR_TVM
>>>   * is set. If the guest enables the MMU, we stop trapping the VM
>>> @@ -133,14 +182,14 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>>>  	if (!p->is_aarch32 || !p->is_32bit) {
>>>  		val = p->regval;
>>>  	} else {
>>> -		val = vcpu_sys_reg(vcpu, reg);
>>> +		val = read_deferrable_vm_reg(vcpu, reg);
>>>  		if (r->reg % 2)
>>>  			val = (p->regval << 32) | (u64)lower_32_bits(val);
>>>  		else
>>>  			val = ((u64)upper_32_bits(val) << 32) |
>>>  				(u64)lower_32_bits(p->regval);
>>>  	}
>>> -	vcpu_sys_reg(vcpu, reg) = val;
>>> +	write_deferrable_vm_reg(vcpu, reg, val);
>>>  
>>>  	kvm_toggle_cache(vcpu, was_enabled);
>>>  	return true;
>>>
>>
>> I'm slightly uneasy with this. It means that the rest of the KVM code
>> has to know whether a given register is deferrable or not (or face the
>> wrath of the BUG). I'd be more inclined to hide the "loaded on cpu"
>> magic in the vcpu_sys_reg() accessors.
>>
>> Thoughts?
>>
> 
> Yes, this is the main reservation I also have with the series.
> 
> I did start out with a giant "rewrite everything to vcpu_get_sys_reg and
> vcpu_get_sys_reg" which hides this logic, and we may want to go back to
> that.
> 
> That does mean that we need a giant switch statement which knows how to
> read any deferrable EL1 (and EL0) system register from hardware, and
> still BUG/WARN if someone adds a system register but forgets to add that
> handler and test on VHE.  Unless there's some fantastic auto-gen
> mechanism that can take a hash define and figure out which sysreg
> instruction to use - I couldn't think of that.
> 
> I'm happy to go back to that approach, but I didn't find it that much
> nicer either.
> 
> How about I send you the small handful of patches that implement the
> alternative approach and you have a look at that?
Sure, feel free to post them. I wonder if we can take a similar approach
to the hack I used for the CP15 stuff on 32bit, where read/write_sysreg
are automagically turned into the right type of accessor...

I'll have a try.

	M.
-- 
Jazz is not dead. It just smells funny...
