From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: stop propagating DAIF flags between kernel
 and VHE's world switch
Date: Tue, 29 Aug 2017 18:10:57 +0100
Message-ID: <59A5A021.1090102@arm.com>
References: <20170810113021.1110-1-james.morse@arm.com>
 <20170824152304.GB2150@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3F2549C25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 13:10:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id luGClgLSRckr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Aug 2017 13:10:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D30740D17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 13:10:07 -0400 (EDT)
In-Reply-To: <20170824152304.GB2150@lvm>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,


(I suspect I'm using some term differently here ...)

On 24/08/17 16:23, Christoffer Dall wrote:
> On Thu, Aug 10, 2017 at 12:30:21PM +0100, James Morse wrote:
>> KVM calls __kvm_vcpu_run() in a loop with interrupts masked for the
>> duration of the call. On a non-vhe system we HVC to EL2 and the
>> host DAIF flags are save/restored via the SPSR.
>>
>> On a system with vhe, we branch to the EL2 code because the kernel
>> also runs at EL2. This means the other kernel DAIF flags propagate into
>> KVMs EL2 code.
>>
>> The same happens in reverse, we take an exception to exit the guest
>> and all the flags are masked. __guest_exit() unmasks SError, and we
>> return with these flags through world switch and back into the host
>> kernel. KVM unmasks interrupts as part of its __kvm_vcpu_run(), but
> 
> when does KVM unmask interrupts as part of the __kvm_vcpu_run()?  Do you
> mean kvm_arch_vcpu_ioctl_run() ?

Oops, yes, I meant kvm_arch_vcpu_ioctl_run().


>> debug exceptions remain disabled due to the guest exit exception,
>> (as does SError: today this is the only time SError is unmasked in the
>> kernel). The flags stay in this state until we return to userspace.
>>
>> We have a __vhe_hyp_call() function that does the isb that we implicitly
>> have on non-vhe systems, add the DAIF save/restore here, instead of in
>> __sysreg_{save,restore}_host_state() which would require an extra isb()
>> between the hosts VBAR_EL1 being restored and DAIF being restored.

> This also means that anyone else calling kvm_call_hyp(), which we are
> beginning to do more often, would also do this save/restore which
> shouldn't really be necessary, doesn't it?

I think it is, its done implicitly via SPSR_EL2 by the HVC/ERET on non-VHE.
Does the HYP code on the other end of kvm_call_hyp() expect to be called with
DAIF masked? What about the other way, if the HYP code modifies the DAIF flags
should that spread back into the kernel?

Today this behaviour differs depending on whether we have VHE.

I think KVM expects its HYP code to be called with DAIF masked, (e.g. there is
no explicit mask of debug before save/restoring MDSCR_EL1).

I'll argue all kvm_call_hyp() users expect the code be called at HYP with DAIF
masked, as if we just took an HVC. On return the flags should be restored as
they would with an ERET.

On VHE we are already at EL2 so we don't have HVC's DAIF-masking behaviour.


> Also, I can't really see why we need to save/restore this.  We are
> 'entering the kernel' similarly to entering the kernel from user space.

(I'm lost here, entering KVM's HYP code from a guest, or returning to the kernel
from KVM?)


> Does the kernel/userspace boundry preserve kernel state or can we simply
> set what the wanted state of the flags should be upon having entered the
> kernel from EL2?

Entering KVM's HYP code from a guest is an exception so the CPU masks DAIF, KVM
unmasks SError, world-switches back to the host and on VHE: 'ret's to the kernel.

On VHE before kvm_call_hyp() SError was masked and Debug was enabled, on return
SError is unmasked and Debug disabled. We can then re-schedule to some other
task with Debug disabled.

(I'll have another go at the commit message)


Thanks,

James
