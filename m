From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 0/7] Add RAS virtualization support for SEA/SEI notification
 type in KVM
Date: Thu, 07 Sep 2017 17:32:53 +0100
Message-ID: <59B174B5.20807@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <59A84ACB.7030808@arm.com> <61d15c7d-803b-15b2-78e1-637fdb9396d6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <61d15c7d-803b-15b2-78e1-637fdb9396d6@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

(I've re-ordered some of the hunks here:)

On 04/09/17 12:10, gengdongjiu wrote:
> On 2017/9/1 1:43, James Morse wrote:
>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>> Not call memory_failure() to handle it. Because the error address recorded
>>> by APEI is not accurated, so can not identify the address to hwpoison
>>> memory.
>>
>> This looks like a firmware bug, what address do you get in your CPER
>> records? It should be a physical address.

> No, not firmware bug. At least in the armv8.0 CPU and huawei's armv8.2 CPU,
> the architecture decided it is not accurate, this abort is asynchronous not
> synchronous.

This is going to be a problem. (I'm chasing Achin to find out when this is
allowed to happen and what we're expected to do about it!)

I hope this isn't the default behaviour, but only happens in exceptionally rare
circumstances.


>> To report a memory-error you must have an address.
> maybe we can not get the accurate error address, can you get it in your armv8
> platform?

I only have software-models, they only generate the errors you tell them to.


I think I see why you're taking this approach with the series, the scenario is:
1. Firmware takes an SError due to a bad memory location from guest EL0.
2. The CPU doesn't provide the address of the memory location.

You want to confine this error as much as possible, in particular to the context
it came from (e.g. guest EL0). CPU context isn't something the CPER records can
describe (they describe failures in system components), hence your hybrid
{kernel,firmware}-first code.

I don't think its safe to kill guest-EL0 and hope this confined the error.

If the affected page of guest memory has never been written to by the guest, the
host will map in the global zero-page, (made read-only at stage2). If the
corruption is in this page it affects the host kernel, guests and user-space
processes. Just because the error came from guest-EL0 doesn't mean
kernel/hypervisor memory isn't affected.

This doesn't just affect that one page: KSM may have merged every copy of every
guest user-space's libc, which has subsequently become corrupt. The first
guest-EL0 to step in this triggers the fault, but it affects all the guests.
With the address all the guests can fix this error, and KSM will re-merge the
pages. Without the address every user-space process in every guest will
eventually be killed.

We aren't even guaranteed that the access that caused the fault came from your
guest EL0. The fault may be in the page tables belonging to the guest kernel,
even worse they may belong to they hypervisor's stage2 page tables.

(Thanks to Mark and Robin for these examples)


I think in this scenario your firmware should describe a memory-error with an
unknown address. (i.e. don't set the 'physical address valid' bit in CPER's
'Table 275 Memory Error Record'). When Linux gets one of these, it should
panic(): We know some memory is corrupt, we don't know where it is.


>> User-space may be signalled by the memory_failure() helper, and user-space >>
may choose to notify the guest about the memory-failure, but this would be a
>> new error.

> For the SError, it is asynchronous abort. so it is not better to call
> memory_failure() helper, because the error address is not accurate.
> memory_failure() will offline or poison the address, but the address is not
> accurate. so it is dangerous

By 'not accurate' do you mean the CPU provides an address, and its wrong.
(surely this is a CPU bug), or just no address is provided. (i.e. the
ERR<n>ADDR.AI 'address incorrect' bit is set).


>>> Because the error was taken from a lower Exception level, if the
>>> exception is SEA/SEI and HCR_EL2.TEA/HCR_EL2.AMO is 1, firmware
>>> sets ESR_EL2/FAR_EL2 to fake a exception trap to EL2, then
>>> transfers to hypervisor.
>>
>> What happens if you took an SError from EL2 and EL2 has PSTATE.A set masking
>> SError? (this is very common today: all kernel code runs like this).

> Firstly, the guest OS usually runs in the El1 or El0, not El2.
> if El2 happens an SError, it will trap to EL3 firmware even though the PSTATE.A is set.
> Because the PSTATE.A can not mask it if the SError is trapped to EL3.

Sure, we agree that from the CPU's view when SCR_EL3.EA is set physical-SError
can't be masked when executing any EL below EL3.

My question was about the 'firmware sets ESR_EL2/FAR_EL2 to fake an exception
trap to EL2' step. While EL3 can take the physical-SError at any time the
normal-world is running, it can't always deliver a fake-SError to EL2, because
EL2 believes it has masked physical-SError.

With the SError rework this should only be masked while we are in entry.S
preparing to handle an exception, receiving an unexpected asynchronous exception
at this point would overwrite ELR/ESR, meaning we could never handle the
original exception.


>> What happens if the hypervisor then executes an ESB with PSTATE.A set? It
>> expects to see any pending SError deferred and its syndrome written to DISR_EL1,
>> but this register is RAZ/WI when you set SCR_EL3.EA. '4.4.2' of [0]

> From my understand, if the SCR_EL3.EA is set, the Abort can not mask, it always happen and
> take to EL3, DISR_El1 can not record the syndrome. DISR_El1 is only recorded when
> the External Abort is masked, but when SCR_EL3.EA is set, the pstate.A can not mask the Error.

But once EL3 wants to notify EL2, and EL2 believes it has SError masked, (even
if the CPU knows its going route physical-SError to EL3) what do you do?

(The best I can think of is that if firmware has to deliver a RAS Error as a
fake-SError, and the target exception-level has SError masked, then firmware
should reboot normal-world and deliver the error via the BERT. To support
NOTIFY_SEI the OS should aim to mask SError as little as possible.)


>>> For the synchronous external abort(SEA), Hypervisor calls the
>>> ghes_handle_memory_failure() to deal with this error,
>>> ghes_handle_memory_failure() function reads the APEI table and 
>>> callls memory_failure() to decide whether it needs to deliver
>>> SIGBUS signal to user space, the advantage of using SIGBUS signal
>>> to notify user space is that it can be compatible with Non-Kvm users.
>>>
>>> For the SError Interrupt(SEI),KVM firstly classified the error.
>>
>> KVM can't parse the CPER records, nor does it know where to look to find them.
>> KVM should call out to the APEI code so the host kernel can handle the error.

> KVM does not parse the CPER records, I mean KVM classified the error according to the esr_el2.AET.

Decoding the AET bits in KVM is stub code for systems without firmware-first.
This will eventually be a call-out to some arm64 arch code to decode the RAS ERR
records and do kernel-first handling.

All the GHES notification methods mean 'go read the CPER records'. The CPER
records then contain all the information, including severities. The SError ESR
value should be irrelevant if the host supports firmware-first.

Without firmware-first or kernel-first we decode the SError ESR to know whether
or not to panic(). This is the minimum-work to avoid data corruption while Linux
only supports firmware-first and the platform expects kernel-first.



Thanks,

James

