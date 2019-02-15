From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v5 2/5] arm64/kvm: preserve host HCR_EL2/MDCR_EL2 value
Date: Fri, 15 Feb 2019 15:50:21 +0000
Message-ID: <7ec2f950-7587-5ecd-6caa-c2fd091ad22c@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-3-git-send-email-amit.kachhap@arm.com>
 <8de32a89-4aa1-bffb-78dd-45feddc9216e@arm.com>
 <1a2534b9-6d3b-caac-ff05-7795b7a2d725@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a2534b9-6d3b-caac-ff05-7795b7a2d725@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/02/2019 11:03, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 2/13/19 11:04 PM, Kristina Martsenko wrote:
>> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>>> is a constant value. This works today, as the host HCR_EL2 value is
>>> always the same, but this will get in the way of supporting extensions
>>> that require HCR_EL2 bits to be set conditionally for the host.
>>>
>>> To allow such features to work without KVM having to explicitly handle
>>> every possible host feature combination, this patch has KVM save/restore
>>> the host HCR when switching to/from a guest HCR. The saving of the
>>> register is done once during cpu hypervisor initialization state and is
>>> just restored after switch from guest.
>>
>> Why is this patch needed? I couldn't find anything in this series that
>> sets HCR_EL2 conditionally for the host. It seems like the kernel still
>> always sets it to HCR_HOST_VHE_FLAGS/HCR_HOST_NVHE_FLAGS.
> 
> This patch is not directly related to pointer authentication but just a
> helper to optimize save/restore. In this way save may be avoided for
> each switch and only restore is done. Patch 3 does sets HCR_EL2 in VHE_RUN.

Patch 3 sets the HCR_EL2.{API,APK} bits for the *guest*, not the host.
This patch here adds saving/restoring for the *host* HCR_EL2. As far as
I can tell, the value of the host HCR_EL2 never changes.

Regarding save/restore, currently the kernel never saves the host
HCR_EL2, because it always restores HCR_EL2 to HCR_HOST_{,N}VHE_FLAGS (a
constant value!) when returning to the host. With this patch, we
effectively just save HCR_HOST_{,N}VHE_FLAGS into kvm_host_cpu_state,
and restore it from there when returning to the host.

Unless we actually change the host HCR_EL2 value to something other than
HCR_HOST_{,N}VHE_FLAGS somewhere in this series, this patch is unnecessary.

>>
>> Looking back at v2 of the userspace pointer auth series, it seems that
>> the API/APK bits were set conditionally [1], so this patch would have
>> been needed to preserve HCR_EL2. But as of v3 of that series, the bits
>> have been set unconditionally through HCR_HOST_NVHE_FLAGS [2].
>>
>> Is there something else I've missed?
> Now HCR_EL2 is modified during switch time and NHVE doesnt support
> ptrauth so [2] doesn't makes sense.

In case of NVHE, we do support pointer auth in the *host* userspace, so
the patch [2] is necessary. In case of NVHE we do not support pointer
auth for KVM *guests*.

Thanks,
Kristina

>> [1] https://lore.kernel.org/linux-arm-kernel/20171127163806.31435-6-mark.rutland@arm.com/
>> [2] https://lore.kernel.org/linux-arm-kernel/20180417183735.56985-5-mark.rutland@arm.com/
