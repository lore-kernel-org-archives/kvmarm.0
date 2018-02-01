From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 16/16] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP
 hardening support
Date: Thu, 1 Feb 2018 08:53:08 +0000
Message-ID: <8183e28a-39e7-e4f0-d704-35a0beb14ef0@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-17-marc.zyngier@arm.com>
 <476d111e-6fb0-9bef-2448-a94d0cc03f45@huawei.com>
 <49853e5e-f093-2e79-1cfb-182f51fcd6a0@arm.com>
 <CAKv+Gu-XidYPh0hi1nzG5m0AO7EfRE6bnKfxCToG+9zsmvzmNg@mail.gmail.com>
 <CAKv+Gu-L0WOLSUbcHSTQ_FVDNSJoXQv25ExUmtv8ZEYhkCSQ-Q@mail.gmail.com>
 <501451b6-cc84-e8d3-b7b6-49a7de953976@arm.com>
 <f6579ab5-8d52-3f62-e538-515b28376d59@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6579ab5-8d52-3f62-e538-515b28376d59@huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Hanjun Guo <guohanjun@huawei.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/18 02:40, Hanjun Guo wrote:
> On 2018/1/31 23:05, Marc Zyngier wrote:
>> On 31/01/18 14:38, Ard Biesheuvel wrote:
>>> On 31 January 2018 at 14:35, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>> On 31 January 2018 at 14:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>> On 31/01/18 13:56, Hanjun Guo wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 2018/1/30 1:45, Marc Zyngier wrote:
>>>>>>>  static int enable_psci_bp_hardening(void *data)
>>>>>>>  {
>>>>>>>      const struct arm64_cpu_capabilities *entry = data;
>>>>>>>
>>>>>>> -    if (psci_ops.get_version)
>>>>>>> +    if (psci_ops.get_version) {
>>>>>>> +            if (check_smccc_arch_workaround_1(entry))
>>>>>>> +                    return 0;
>>>>>>
>>>>>> If I'm using the new version SMCCC, the firmware have the choicARM_SMCCC_ARCH_WORKAROUND_1e to decide
>>>>>> whether this machine needs the workaround, even if the CPU is vulnerable
>>>>>> for CVE-2017-5715, but..
>>>>>>
>>>>>>> +
>>>>>>>              install_bp_hardening_cb(entry,
>>>>>>>                                     (bp_hardening_cb_t)psci_ops.get_version,
>>>>>>>                                     __psci_hyp_bp_inval_start,
>>>>>>>                                     __psci_hyp_bp_inval_end);
>>>>>>
>>>>>> ..the code above seems will enable get_psci_version() for CPU and will
>>>>>> trap to trust firmware even the new version of firmware didn't say
>>>>>> we need the workaround, did I understand it correctly?
>>>>>
>>>>> Well, you only get there if we've established that your CPU is affected
>>>>> (it has an entry matching its MIDR with the HARDEN_BRANCH_PREDICTOR
>>>>> capability), and that entry points to enable_psci_bp_hardening. It is
> 
> I understand, but A53, A57, A72 and etc are always in the list :)
> 
>>>>> not the firmware that decides whether we need hardening, but the kernel.
>>>>> The firmware merely provides a facility to apply the hardening.
>>>>>
>>>>>> I'm ask this because some platform will not expose to users to
>>>>>> take advantage of CVE-2017-5715, and we can use different firmware
>>>>>> to report we need such workaround or not, then use a single kernel
>>>>>> image for both vulnerable platforms and no vulnerable ones.
>>>>>
>>>>> You cannot have your cake and eat it. If you don't want to workaround
>>>>> the issue, you can disable the hardening. But asking for the same kernel
>>>>> to do both depending on what the firmware reports doesn't make much
>>>>> sense to me.
>>>>
>>>> The SMCCC v1.1. document does appear to imply that systems that
>>>> implement SMCCC v1.1 but don't implement ARM_SMCCC_ARCH_WORKAROUND_1
>>>> should be assumed to be unaffected.
>>>>
>>>> """
>>>> If the discovery call returns NOT_SUPPORTED:
>>>> • SMCCC_ARCH_WORKAROUND_1 must not be invoked on any PE in the system, and
>>>> • none of the PEs in the system require firmware mitigation for CVE-2017-5715.
>>>> """
>>>>
>>>> How to deal with conflicting information in this regard (quirk table
>>>> vs firmware implementation) is a matter of policy, of course.
>>
>> Yup. And the current approach fits the spec, I believe. The
> 
> Yes, approach in this patch set fits the spec, it just conflicts with
> MIDR based approach.

No it doesn't. We know that A72 is affected. However you look at it,
there is no way around that fact. So if you have an affected CPU *and*
you implement SMCCC 1.1 with WORKAROUND_1, you get the mitigation.

If your firmware doesn't implement it, blame your provider for supplying
you with an outdated firmware.

>> PSCI_GET_VERSION band-aid should normally be removed shortly after these
>> patches hit mainline.
> 
> I'm a big fan of this :)
> 
>>
>>>
>>> ... and actually, perhaps it makes sense for the
>>> SMCCC_ARCH_WORKAROUND_1 check to be completely independent of MIDR
>>> based errata matching?
>>>
>>> I.e., if SMCCC v1.1 and SMCCC_ARCH_WORKAROUND_1 are both implemented,
>>> we should probably invoke it even if the MIDR is not known to belong
>>> to an affected implementation.
>>
>> This would have an impact on big-little systems, for which there is
>> often a bunch of unaffected CPUs.
> 
> I think it's what we are doing now, SMCCC v1.1 didn't provide the ability
> to report per-cpu SMCCC_ARCH_WORKAROUND_1, and it said:
>  - The discovery call must return the same result on all PEs in the system.
>  - In heterogeneous systems with some PEs that require mitigation and others
>    that do not, the firmware must provide a safe implementation of this
>    function on all PEs.
> 
> So from the spec that it's the firmware to take care of unaffected CPUs,
> to the kernel it's the same.

The spec makes it safe. The MIDR list makes it fast.

	M.
-- 
Jazz is not dead. It just smells funny...
