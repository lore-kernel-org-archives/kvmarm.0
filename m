From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Fri, 10 Apr 2015 09:53:53 +0100
Message-ID: <55278FA1.8040502@arm.com>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <55273728.6090806@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A410F4C010
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 04:46:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ktYGRiwTmbC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 04:46:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9EE4C00F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 04:46:17 -0400 (EDT)
In-Reply-To: <55273728.6090806@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/15 03:36, Mario Smarduch wrote:
> On 04/09/2015 12:57 AM, Marc Zyngier wrote:
>> On Thu, 9 Apr 2015 02:46:54 +0100
>> Mario Smarduch <m.smarduch@samsung.com> wrote:
>>
>> Hi Mario,
>>
>>> I'm working with AsyncPF, and currently using
>>> hyp call to communicate guest GFN for host to inject
>>> virtual abort - page not available/page available.
>>>
>>> Currently only PSCI makes use of that interface,
>>> (handle_hvc()) can we overload interface with additional
>>> hyp calls in this case pass guest gfn? Set arg0
>>> to some range outside of PSCI use.
>>
>> I can't see a reason why we wouldn't open handle_hvc() to other
>> paravirtualized services. But this has to be done with extreme caution:
>>
>> - This becomes an ABI between host and guest
>> - We need a discovery protocol
>> - We need to make sure other hypervisors don't reuse the same function
>>   number for other purposes
>>
>> Maybe we should adopt Xen's idea of a hypervisor node in DT where we
>> would describe the various services? How will that work with ACPI?
>>
>> Coming back to AsyncPF, and purely out of curiosity: why do you need a
>> HYP entry point? From what I remember, AsyncPF works by injecting a
>> fault in the guest when the page is found not present or made
>> available, with the GFN being stored in a per-vcpu memory location.
>>
>> Am I missing something obvious? Or have I just displayed my ignorance on
>> this subject? ;-)
> Hi Marc,
> 
> Or it might be me :)
> 
> But I'm thinking Guest and host need to agree on some per-vcpu
> guest memory for KVM to write PV-fault type, and Guest to read
> the PV-fault type, ack it, i.e. Having the guest allocate the per-cpu
> PV-fault memory and inform KVM with its GPA via hyp call is one
> approach I was thinking off.

Ah, I see what you mean. I was only looking at the runtime aspect of
things, and didn't consider the (all important) setup stage.

> I was looking through x86 that's based on CPUID extended with
> PV feature support. In the guest if the ASYNC PF feature is enabled
> it writes GPA to ASYNC PF MSR that's resolved in KVM (x86 folks
> can correct if I'm off here).
> 
> I'm wondering if we could build on this concept maybe PV ID_* registers,
> to discover existence of ASYNC PF feature?

I suppose we could do something similar with the ImpDef encoding space
(i.e. what is trapped using HCR_EL2.TIDCP). The main issue with that is
to be able to safely carve out a range that will never be used by any HW
implementation, ever. I can't really see how we enforce this.

Also, it will have the exact same cost as a hypercall, so maybe it is
bit of a moot point. Anyway, this is "just" a matter of being able to
describe the feature to the guest (and it seems like this is the real
controversial aspect)...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
