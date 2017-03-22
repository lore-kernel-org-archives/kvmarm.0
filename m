From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Wed, 22 Mar 2017 18:56:44 +0000
Message-ID: <58D2C8EC.5090100@arm.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com> <58CFF058.8020205@arm.com>
 <76795e20-2f20-1e54-cfa5-7444f28b18ee@huawei.com> <58D1263E.90800@arm.com>
 <39832689-89a6-49a3-be59-b4a1203c2486@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 095B340948
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 14:55:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USDHyJ63axbx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 14:55:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3AB40905
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 14:55:16 -0400 (EDT)
In-Reply-To: <39832689-89a6-49a3-be59-b4a1203c2486@huawei.com>
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

Hi gengdongjiu

On 22/03/17 13:37, gengdongjiu wrote:
> On 2017/3/21 21:10, James Morse wrote:
>> On 21/03/17 06:32, gengdongjiu wrote:
>>> so for both SEA and SEI, do you prefer to below steps?
>>> EL0/EL1 SEI/SEA ---> EL3 firmware first handle ------> EL2 hypervisor notify >
>> the Qemu to inject SEI/SEA------>Qemu call KVM API to inject SEA/SEI---->KVM >
>> inject SEA/SEI to guest OS
>>
>> Yes, to expand your EL2 hypervisor notify Qemu step:
>> 1 The host should call its APEI code to parse the CPER records.
>> 2 User space processes are then notified via SIGBUS (or for rasdaemon, trace
>>   points).
>> 3 Qemu can take the address delivered via SIGBUS and generate CPER records for
>>   the guest. It knows how to convert host addresses to guest IPAs, and it knows
>>   where in guest memory to write the CPER records.
>> 4 Qemu can then notify the guest via whatever mechanism it advertised via the
>>   HEST/GHES table. It might not be the same mechanism that the host received
>>   the notification through.
>>
>> Steps 1 and 2 are the same even if no guest is running, so we don't have to add
>> any special case for KVM. This is existing code that x86 uses.
>> We can test the Qemu parts without any firmware support and the APEI path in the
>> host and guest is the same.

>    here do you mean map host APEI table to guest for steps 1 and 2 test? so that the APEI path in the
>   host and guest is the same.

No, the hosts ACPI/APEI tables describe host physical addresses, the guest can't
access these.

Instead we can use Linux's hwpoison mechanism to call memory_failure() and if we
pick the address carefully, signal Qemu. From there we can test Qemu's
generation of CPER records and signalling the guest.

When a host and a guest both use APEI the HEST tables will be different because
the memory layout is different, but the path through APEI and the kernel's error
handling code would be the same.


>>>> How does this work with firmware first?
>>
>>> when the Guest OS triggers an SEI, it will firstly trap to EL3 firmware, El3 firmware records the error
>>> info to the APEI table, 
>>
>> These are CPER records in a memory area pointed to by one of HEST's GHES entries?
>>
>>
>>> then copy the ESR_EL3 ELR_EL3 to ESR_EL2 ELR_EL2 and transfers control to the
>>> hypervisor, hypervisor delegates the error exception to EL1 guest
>>
>> This is a problem, just because the error occurred while the guest was running
>> doesn't mean we should deliver it directly to the guest. Some of these errors
>> will be fatal for the CPU and the host should try and power it off to contain

> yes, some of error does not need to deliver to guest OS directly. for example if the error is guest kernel fault error,
> hypervisor can directly power off the whole guest OS

I agree, Qemu should make that decision, depending on the users choice it can
print a helpful error message and exit, or try and restart the guest.


>> the fault. For example: CPER's 'micro-architectural error', should the guest
>> power-off the vCPU? All that really does is return to the hypervisor, the error

> for this example, I think it is better hypervisor directly close the whole guest OS, instead of
> guest power-off the vCPU.

I picked this as an example because its not clear what it means and it probably
affects the host as well as the guest. We need to do the host error containment
first.


>>>> If we took a Physical SError Interrupt the CPER records are in the hosts memory.
>>>> To deliver a RAS event to the guest something needs to generate CPER records and
>>>> put them in the guest memory. Only Qemu knows where these memory regions are.
>>>>
>>>> Put another way, what is the guest expected to do with this SError interrupt?
>>>
>>> No, we do not only panic,if it is EL0 application SEI. the OS error recovery
>>> agent will terminate the EL0 application to isolate the error; If it is EL1 guest
>>> OS SError, guest OS can see whether it can recover. if the error was in a read-only file cache buffer, guest OS
>>> can invalidate the page and reload the data from disk.
>>
>> How do we get an address for memory failure? SError is asynchronous, I don't
>> think it sets the FAR. (SEA is synchronous and its not guaranteed to set the

> Thank you to point that. sorry, my answer is not right. in fact, I think the FAR and
> CPER are both not accurate for the  asynchronous SError. so guest OS can not try to recover.

My point was only that the architecture doesn't tell us the FAR is always set,
so we have to find out from somewhere else, like the host's CPER records.

SError Interrupt is one of the notification types for GHES which may be
triggered by firmware. Firmware should generate the CPER records before
triggering the SEI notification. When the host gets an SEI it can parse the list
of GHES addresses looking for CPER records. The asynchronous delay doesn't
affect the CPER records from firmware.

Qemu can do the same for a guest before it pends an SError.


> but it can still know which application create this SError which is deferred by ESB, then guest OS close the APP.

Once the host has done its error containment, yes. If the SError interrupted a
vcpu and the host signalled Qemu the signal will be delivered before the vcpu is
run again, (if (signal_pending(current))... in kvm_arch_vcpu_ioctl_run()).

If Qemu does its work and decides to pend an SError before running the vcpu
again then it will be as if the guest isn't running under a hypervisor.


> by the way, for the synchronous SEA, do you think which address should be used? FAR or CPER that record come from ERR<n>ADDR?
> I see Qualcomm series patches mainly use FAR not CPER record that come from ERR<n>ADDR for SEA.
> so for the SEA case, I do not know which address is more accurate for FAR and CPER record

It uses both. The FAR may get copied to the signal address if the ESR says the
FAR is valid. This works on systems that don't have APEI SEA.
Systems that do have APEI SEA will parse the CPER records as well to find the
physical address and do the memory_failure() routine to signal all the affected
processes, not just the one that was running.



Thanks,

James
