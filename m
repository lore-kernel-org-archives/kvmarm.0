From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 21 Mar 2017 13:10:22 +0000
Message-ID: <58D1263E.90800@arm.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC9240C44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 09:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hqdw8NPx80nl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 09:08:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BD7540960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 09:08:55 -0400 (EDT)
In-Reply-To: <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>, xiexiuqi@huawei.com
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 21/03/17 06:32, gengdongjiu wrote:
> On 2017/3/20 23:08, James Morse wrote:
>> On 20/03/17 13:58, Marc Zyngier wrote:
>>> On 20/03/17 12:28, gengdongjiu wrote:
>>>> On 2017/3/20 19:24, Marc Zyngier wrote:
>>>>> On 20/03/17 07:55, Dongjiu Geng wrote:
>>>>>> In the RAS implementation, hardware pass the virtual SEI
>>>>>> syndrome information through the VSESR_EL2, so set the virtual
>>>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
>>>>>> the guest OS

(I've juggled the order of your replies:)

> so for both SEA and SEI, do you prefer to below steps?
> EL0/EL1 SEI/SEA ---> EL3 firmware first handle ------> EL2 hypervisor notify >
the Qemu to inject SEI/SEA------>Qemu call KVM API to inject SEA/SEI---->KVM >
inject SEA/SEI to guest OS

Yes, to expand your EL2 hypervisor notify Qemu step:
1 The host should call its APEI code to parse the CPER records.
2 User space processes are then notified via SIGBUS (or for rasdaemon, trace
  points).
3 Qemu can take the address delivered via SIGBUS and generate CPER records for
  the guest. It knows how to convert host addresses to guest IPAs, and it knows
  where in guest memory to write the CPER records.
4 Qemu can then notify the guest via whatever mechanism it advertised via the
  HEST/GHES table. It might not be the same mechanism that the host received
  the notification through.

Steps 1 and 2 are the same even if no guest is running, so we don't have to add
any special case for KVM. This is existing code that x86 uses.
We can test the Qemu parts without any firmware support and the APEI path in the
host and guest is the same.


>> Is anyone from Huawei looking at adding RAS support for Qemu?
>  yes, I am looking at Qemu and want to add RAS support.

Great, support in Qemu is one of the missing pieces. On x86 it looks like it
emulates machine-check-exceptions, which is how x86 did this before
firmware-first and APEI became the standard.


>  do you mean let Qemu inject both the SEA and SEI?

To do the notification, yes. It needs to happen after the CPER records have been
written, and the mechanism and CPER memory location need to match what the guest
was told via the HEST/GHES table.

If Qemu didn't tell the guest about firmware-first, it can still deliver the
guest an SError Interrupt.


SEA should be possible to do with the KVM_SET_REG API, GPIO/GSIV and the other
kind of interrupts can use irqfd. For SEI we may need to add an API call to KVM
to let it pend SError with a specific ESR.



>> How does this work with firmware first?

> when the Guest OS triggers an SEI, it will firstly trap to EL3 firmware, El3 firmware records the error
> info to the APEI table, 

These are CPER records in a memory area pointed to by one of HEST's GHES entries?


> then copy the ESR_EL3 ELR_EL3 to ESR_EL2 ELR_EL2 and transfers control to the
> hypervisor, hypervisor delegates the error exception to EL1 guest

This is a problem, just because the error occurred while the guest was running
doesn't mean we should deliver it directly to the guest. Some of these errors
will be fatal for the CPU and the host should try and power it off to contain
the fault. For example: CPER's 'micro-architectural error', should the guest
power-off the vCPU? All that really does is return to the hypervisor, the error
hasn't been contained.

Firmware should handle the error first, then the host, finally the guest via Qemu.


> OS by setting HCR_EL2.VSE to 1 and pass the virtual SEI syndrome through vsesr_el2. 
> The EL1 guest OS check the DISR_EL1 syndrome information to decide to
> terminate the application, or do some other recovery action. because the HCR_EL2.AMO is set, so in fact, read
> DISR_EL1, it returns the VDISR_EL2. and VDISR_EL2 is loaded from VSESR_EL2, so here I pass the virtual SEI
> syndrome vsesr_el2.

So this is how an SError Interrupt's ESR gets into a guest. How does it get hold
of the CPER records?


>> If we took a Physical SError Interrupt the CPER records are in the hosts memory.
>> To deliver a RAS event to the guest something needs to generate CPER records and
>> put them in the guest memory. Only Qemu knows where these memory regions are.
>>
>> Put another way, what is the guest expected to do with this SError interrupt?
>
> No, we do not only panic,if it is EL0 application SEI. the OS error recovery
> agent will terminate the EL0 application to isolate the error; If it is EL1 guest
> OS SError, guest OS can see whether it can recover. if the error was in a read-only file cache buffer, guest OS
> can invalidate the page and reload the data from disk.

How do we get an address for memory failure? SError is asynchronous, I don't
think it sets the FAR. (SEA is synchronous and its not guaranteed to set the
FAR..). As far as I understand this information is in the CPER records in host
memory.

If we did have an address it would be a host address, how is it converted to a
guest IPA? I think Qemu should do this as part of its CPER record generation,
once the host has decided the error wasn't catastrophic.


Thanks,

James
