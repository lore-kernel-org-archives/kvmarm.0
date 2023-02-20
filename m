Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1576663BB
	for <kvmarm@lists.linux.dev>; Mon, 20 Feb 2023 14:17:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF41FFEC;
	Mon, 20 Feb 2023 06:18:15 -0800 (PST)
Received: from [10.57.75.211] (unknown [10.57.75.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D89583F881;
	Mon, 20 Feb 2023 06:17:31 -0800 (PST)
Message-ID: <e16ec8cd-3b00-0b64-8a44-7cf8f34c771a@arm.com>
Date: Mon, 20 Feb 2023 14:17:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <Y5pvzKYdZK79nyZw@google.com> <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
 <Y5tjfmJRFY2pFlr4@google.com> <Y6H+uXrIrQjdntA4@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <Y6H+uXrIrQjdntA4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

Apologies for having gone quiet on this. I came back to this work today only to
notice that you sent the below response on the 20th Dec but it did not get
picked up by my mail client somehow (although I'm sure it was operator error). I
just spotted it on lore.kernel.org.

I'm planning to post a second version soon-ish, with all your comments
addressed. I think everything except the below is pretty clear and straight forward.


On 20/12/2022 18:28, Oliver Upton wrote:
> On Thu, Dec 15, 2022 at 06:12:14PM +0000, Oliver Upton wrote:
>> On Thu, Dec 15, 2022 at 09:33:17AM +0000, Ryan Roberts wrote:
>>> On 15/12/2022 00:52, Oliver Upton wrote:
>>>> On Tue, Dec 06, 2022 at 01:59:18PM +0000, Ryan Roberts wrote:
>>>>> (appologies, I'm resending this series as I managed to send the cover letter to
>>>>> all but the following patches only to myself on first attempt).
>>>>>
>>>>> This is my first upstream feature submission so please go easy ;-)
>>>>
>>>> Welcome :)
>>>>
>>>>> Support 52-bit Output Addresses: FEAT_LPA2 changes the format of the PTEs. The
>>>>> HW advertises support for LPA2 independently for stage 1 and stage 2, and
>>>>> therefore its possible to have it for one and not the other. I've assumed that
>>>>> there is a valid case for this if stage 1 is not supported but stage 2 is, KVM
>>>>> could still then use LPA2 at stage 2 to create a 52 bit IPA space (which could
>>>>> then be consumed by a 64KB page guest kernel with the help of FEAT_LPA). Because
>>>>> of this independence and the fact that the kvm pgtable library is used for both
>>>>> stage 1 and stage 2 tables, this means the library now has to remember the
>>>>> in-use format on a per-page-table basis. To do this, I had to rework some
>>>>> functions to take a `struct kvm_pgtable *` parameter, and as a result, there is
>>>>> a noisy patch to add this parameter.
>>>>
>>>> Mismatch between the translation stages is an interesting problem...
>>>>
>>>> Given that userspace is responsible for setting up the IPA space, I
>>>> can't really think of a strong use case for 52 bit IPAs with a 48 bit
>>>> VA. Sure, the VMM could construct a sparse IPA space or remap the same
>>>> HVA at multiple IPAs to artificially saturate the address space, but
>>>> neither seems terribly compelling.
>>>>
>>>> Nonetheless, AFAICT we already allow this sort of mismatch on LPA &&
>>>> !LVA systems. A 48 bit userspace could construct a 52 bit IPA space for
>>>> its guest.
>>>
>>> I guess a simpler approach would be to only use LPA2 if its supported by both
>>> stage1 and stage2. Then the code could just use a static key in the few required
>>> places.
>>
>> Ah, you caught on quick to what I was thinking :-)
> 
> Just wanted to revisit this...
> 
> Ryan, you say that it is possible for hardware to support LPA2 for a
> single stage of translation. Are you basing that statement on something
> in the Arm ARM or the fact that there are two different enumerations
> for stage-1 and stage-2?

Its based on there being 2 separate enumerations. I've dug into this with our
architecture folks; while it is clearly possible that the HW (or L0 hyp) to
present an ID register that says one stage supports LPA2 and the other doesn't,
the real intention behind having the 2 fields separated out is for an L0 hyp to
be able to limit the stage2 granule sizes that it advertises to guest
hypervisors. There are no anticipated use cases where HW or L0 hypervisor might
want to advertise support for LPA2 in one stage and not the other.

So on that basis, it sounds to me like we should just test for LPA2 support in
both stages and require both to be supported. That simplifies things
significantly - I can just use a static key to globally flip between pte
formats, and a bunch of the noisy refactoring disappears.

> 
> In my cursory search I wasn't able to find anything that would suggest
> it is possible for only a single stage to implement the feature. The one
> possibility I can think of is the NV case, where the L0 hypervisor for
> some reason does not support LPA2 in its emulated stage-2 but still
> advertises support for LPA2 at stage-1. I'd say that's quite a stupid
> L0, but I should really hold my tongue until KVM actually does NV ;-)
> 
> I want to make sure there is a strong sense of what LPA2 means in terms
> of the architecture to inform how we use it in KVM.
> 
> --
> Thanks,
> Oliver
> 

Thanks,
Ryan


