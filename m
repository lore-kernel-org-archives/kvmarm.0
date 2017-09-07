From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 4/7] arm64: kvm: support user space to query RAS extension
 feature
Date: Thu, 07 Sep 2017 17:31:54 +0100
Message-ID: <59B1747A.5030909@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com> <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com> <59A84F9D.8030309@arm.com> <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 05/09/17 08:18, gengdongjiu wrote:
> On 2017/9/1 2:04, James Morse wrote:
>> On 28/08/17 11:38, Dongjiu Geng wrote:
>>> Userspace will want to check if the CPU has the RAS
>>> extension. 
>>
>> ... but user-space wants to know if it can inject SErrors with a specified ESR.
>>
>> What if we gain another way of doing this that isn't via the RAS-extensions, now
>> user-space has to check for two capabilities.
>>
>>
>>> If it has, it wil specify the virtual SError syndrome
>>> value, otherwise it will not be set. This patch adds support for
>>> querying the availability of this extension.
>>
>> I'm against telling user-space what features the CPU has unless it can use them
>> directly. In this case we are talking about a KVM API, so we should describe the
>> API not the CPU.
> 
> shenglong (zhaoshenglong@huawei.com) who is Qemu maintainer suggested checking the CPU RAS-extensions
> to decide whether generate the APEI table and record CPER for the guest OS in the user space.
> he means if the host does not support RAS, user space may also not support RAS.

The code to signal memory-failure to user-space doesn't depend on the CPU's
RAS-extensions.

If Qemu supports notifying the guest about RAS errors using CPER records, it
should generate a HEST describing firmware first. It can then choose the
notification methods, some of which may require optional KVM APIs to support.

Seattle has a HEST, it doesn't support the CPU RAS-extensions. The kernel can
notify user-space about memory_failure() on this machine. I would expect Qemu to
be able to receive signals and describe memory errors to a guest (1).

The question should be: 'How can Qemu know it can use SEI as a firmware-first
notification?' It needs a KVM API to trigger an SError in the guest with a
specified ESR. The name of the KVM CAP needs to reflect the API (2).

Just because this is the first KVM API that needs the CPU to have the RAS
extensions doesn't mean we should call it 'has RAS' and be done with it.

We will eventually need another KVM API to configure trapping and emulating
values in the RAS ERR registers so that Qemu can emulate a machine without
firmware-first. (This is likely to be a page of memory that backs the registers,
there will need to be another KVM CAP to describe this support (3)).


Exposing the CPUs support for RAS-extensions to support (2) means having
per-platform support for (1). This is either creating extra work, or not
supporting as many platforms as we could. Both are bad.
Once we have (3) as well, any developer needs to know that 'has RAS' just meant
the first API KVM implemented using RAS, and doesn't mean later APIs also using
RAS are supported by the kernel.


Thanks,

James
