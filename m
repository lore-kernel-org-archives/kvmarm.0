From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 0/7] Support RAS virtualization in KVM
Date: Wed, 15 Nov 2017 19:06:33 +0800
Message-ID: <18af7014-abcd-4593-cd56-208a446ca7c0@huawei.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <5A0B132C.6070400@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5A0B132C.6070400@arm.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, bp@alien8.de, rjw@rjwysocki.net, pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
   Thank you very much for your comments and review.

On 2017/11/15 0:00, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 10/11/17 19:54, Dongjiu Geng wrote:
>> This series patches mainly do below things:
>>
>> 1. Trap RAS ERR* registers Accesses to EL2 from Non-secure EL1,
>>    KVM will will do a minimum simulation, there registers are simulated
>>    to RAZ/WI in KVM.
>> 2. Route synchronous External Abort exceptions from Non-secure EL0
>>    and EL1 to EL2. When exception EL3 routing is enabled by firmware,
>>    system will trap to EL3 firmware instead of EL2 KVM, then firmware
>>    judges whether El2 routing is enabled, if enabled, jump to EL2 KVM, 
>>    otherwise jump to EL1 host kernel.
>> 3. Enable APEI ARv8 SEI notification to parse the CPER records for SError
>>    in the ACPI GHES driver, KVM will call handle_guest_sei() to let ACPI
>>    driver to parse the CPER record for SError which happened in the guest
>> 4. Although we can use APEI driver to handle the guest SError, but not all
>>    system support SEI notification, such as kernel-first. So here KVM will
>>    also classify the Error through Exception Syndrome Register and do different
>>    approaches according to Asynchronous Error Type
> 
>> 5. If the guest SError error is not propagated and not consumed, then KVM return
>>    recoverable error status to user-space, user-space will specify the guest ESR
> 
> I thought we'd gone over this. There should be no RAS errors/notifications in
> user space. Only the symptoms should be sent, using the SIGBUS_MCEERR_A{O,R} if
> the kernel has handled as much as it can. This hides the actual mechanisms the
> kernel and firmware used.

Yes, I understand it.
For guest SError, if it is not  propagated and not consumed by PE, and the error address recorded by firmware is not accurate,
what is your suggestion about this scenario ?

I check again the comments in [0](as shown below), you ever suggest system panic.

-----------------------------------------------------------------
"I think in this scenario your firmware should describe a memory-error with an
unknown address. (i.e. don't set the 'physical address valid' bit in CPER's
'Table 275 Memory Error Record'). When Linux gets one of these, it should
panic(): We know some memory is corrupt, we don't know where it is"
----------------------------------------------------------------

but I think it is not better, you ever have below concern in [0]
"The fault may be in the page tables belonging to the guest kernel,
even worse they may belong to they hypervisor's stage2 page tables"

If it is in the page tables, killing the APP, the memory will be free. if there is another application
will use this error address again, trigger another SError?


you know the error still not consumed by PE , so we can isolated it by killing it.
lets discuses the host EL0, if host El0 APP happen SError and error not consumed by the PE.
do you mean we also panic host OS?


> 
> User-space should not have to know how to handle RAS errors directly. This is a
> service the operating system provides for it. This abstraction means the smae
> user-space code is portable between x86, arm64, powerpc etc.
> 
> What if the firmware uses another notification method? User space should expect
> the kernel to hide things like this from it.
> 
> If the kernel has no information to interpret a notification, how is user space
> supposed to know?
> 
> I understand you are trying to work around your 'memory corruption at an unknown
> address'[0] problem, but if the kernel can't know where this corrupt memory is
> it should really reboot. What stops this corrupt data being swapped to disk?
> 
> Killing 'the thing' that was running at the time is not sufficient because we
> don't know that this 'got' all the users of the corrupt memory. KSM can merge

I think if we better using the ESB to isolate the error between EL0 and EL1, isolate the error between different guest.
then the error will be isolate to El0 application if it happen in El0. When KSM running, the ESB can synchronize
the error out instead of spread the error to other guests.



> pages between guests. This is the difference between the error persisting
> forever killing off all the VMs one by one, and the corrupt page being silently
> re-read from disk clearing the error.
> 
> 
>>    and inject a virtual SError. For other Asynchronous Error Type, KVM directly
>>    injects virtual SError with IMPLEMENTATION DEFINED ESR or KVM is panic if the
>>    error is fatal. In the RAS extension, guest virtual ESR must be set, because
>>    all-zero  means 'RAS error: Uncategorized' instead of 'no valid ISS', so set
>>    this ESR to IMPLEMENTATION DEFINED by default if user space does not specify it.
> 
> 
> Thanks,
> 
> James
> 
> 
> [0] https://www.spinics.net/lists/arm-kernel/msg605345.html
> 
> .
> 

