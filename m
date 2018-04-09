From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [REPOST PATCH] arm/arm64: KVM: Add PSCI version selection API
Date: Mon, 9 Apr 2018 13:47:50 +0100
Message-ID: <cf0f94ba-f5b7-79ca-1625-1235a5fec8b5@arm.com>
References: <20180215175803.6870-1-marc.zyngier@arm.com>
 <db215c1e-0ce8-32e4-d131-e790bebf353e@redhat.com>
 <86o9k63f7a.wl-marc.zyngier@arm.com>
 <CAFEAcA8XYV=oSX81ON4CGDt0kfG1cgROqj30OC2Ov=bYhLSYig@mail.gmail.com>
 <20180306092134.4bfbz34yhqfrfdlf@kamzik.brq.redhat.com>
 <8042f946-49bf-5fc1-f513-4b76ccd5f7d6@arm.com>
 <CAFEAcA-t1QvjW6eFQ4U+8odj0p_01F8sktpvN9KrZ1Kc-FhtnQ@mail.gmail.com>
 <86169dc0-b13c-fab9-eaca-363d3873ad10@arm.com> <20180409123042.GD10904@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409123042.GD10904@cbox>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

+Drew, who's look at the whole save/restore thing extensively

On 09/04/18 13:30, Christoffer Dall wrote:
> On Thu, Mar 15, 2018 at 07:26:48PM +0000, Marc Zyngier wrote:
>> On 15/03/18 19:13, Peter Maydell wrote:
>>> On 15 March 2018 at 19:00, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> On 06/03/18 09:21, Andrew Jones wrote:
>>>>> On Mon, Mar 05, 2018 at 04:47:55PM +0000, Peter Maydell wrote:
>>>>>> On 2 March 2018 at 11:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>>>> On Fri, 02 Mar 2018 10:44:48 +0000,
>>>>>>> Auger Eric wrote:
>>>>>>>> I understand the get/set is called as part of the migration process.
>>>>>>>> So my understanding is the benefit of this series is migration fails in
>>>>>>>> those cases:
>>>>>>>>
>>>>>>>>> =0.2 source -> 0.1 destination
>>>>>>>> 0.1 source -> >=0.2 destination
>>>>>>>
>>>>>>> It also fails in the case where you migrate a 1.0 guest to something
>>>>>>> that cannot support it.
>>>>>>
>>>>>> I think it would be useful if we could write out the various
>>>>>> combinations of source, destination and what we expect/want to
>>>>>> have happen. My gut feeling here is that we're sacrificing
>>>>>> exact migration compatibility in favour of having the guest
>>>>>> automatically get the variant-2 mitigations, but it's not clear
>>>>>> to me exactly which migration combinations that's intended to
>>>>>> happen for. Marc?
>>>>>>
>>>>>> If this wasn't a mitigation issue the desired behaviour would be
>>>>>> straightforward:
>>>>>>  * kernel should default to 0.2 on the basis that
>>>>>>    that's what it did before
>>>>>>  * new QEMU version should enable 1.0 by default for virt-2.12
>>>>>>    and 0.2 for virt-2.11 and earlier
>>>>>>  * PSCI version info shouldn't appear in migration stream unless
>>>>>>    it's something other than 0.2
>>>>>> But that would leave some setups (which?) unnecessarily without the
>>>>>> mitigation, so we're not doing that. The question is, exactly
>>>>>> what *are* we aiming for?
>>>>>
>>>>> The reason Marc dropped this patch from the series it was first introduced
>>>>> in was because we didn't have the aim 100% understood. We want the
>>>>> mitigation by default, but also to have the least chance of migration
>>>>> failure, and when we must fail (because we're not doing the
>>>>> straightforward approach listed above, which would prevent failures), then
>>>>> we want to fail with the least amount of damage to the user.
>>>>>
>>>>> I experimented with a couple different approaches and provided tables[1]
>>>>> with my results. I even recommended an approach, but I may have changed
>>>>> my mind after reading Marc's follow-up[2]. The thread continues from
>>>>> there as well with follow-ups from Christoffer, Marc, and myself. Anyway,
>>>>> Marc did this repost for us to debate it and work out the best approach
>>>>> here.
>>>> It doesn't look like we've made much progress on this, which makes me
>>>> think that we probably don't need anything of the like.
>>>
>>> I was waiting for a better explanation from you of what we're trying to
>>> achieve. If you want to take the "do nothing" approach then a list
>>> also of what migrations succeed/fail/break in that case would also
>>> be useful.
>>>
>>> (I am somewhat lazily trying to avoid having to spend time reverse
>>> engineering the "what are we trying to do and what effects are
>>> we accepting" parts from the patch and the code that's already gone
>>> into the kernel.)
>>
>> OK, let me (re)state the problem:
>>
>> For a guest that requests PSCI 0.2 (i.e. all guests from the past 4 or 5
>> years), we now silently upgrade the PSCI version to 1.0 allowing the new
>> SMCCC to be discovered, and the ARCH_WORKAROUND_1 service to be called.
>>
>> Things get funny, specially with migration (and the way QEMU works).
>>
>> If we "do nothing":
>>
>> (1) A guest migrating from an "old" host to a "new" host will silently
>> see its PSCI version upgraded. Not a big deal in my opinion, as 1.0 is a
>> strict superset of 0.2 (apart from the version number...).
>>
>> (2) A guest migrating from a "new" host to an "old" host will silently
>> loose its Spectre v2 mitigation. That's quite a big deal.
>>
>> (3, not related to migration) A guest having a hardcoded knowledge of
>> PSCI 0.2 will se that we've changed something, and may decide to catch
>> fire. Oh well.
>>
>> If we take this patch:
>>
>> (1) still exists
> 
> No problem, IMHO.
> 
>>
>> (2) will now fail to migrate. I see this as a feature.
> 
> Yes, I agree.  This is actually the most important reason for doing
> anything beyond what's already merged.

Indeed, and that's the reason I wrote this patch the first place.

> 
>>
>> (3) can be worked around by setting the "PSCI version pseudo register"
>> to 0.2.
> 
> Nice to have, but we're probably not expecting this to be of major
> concern.  I initially thought it was a nice debugging feature as well,
> but that may be a ridiculous point.
> 
>>
>> These are the main things I can think of at the moment.
> 
> So I think we we should merge this patch.
> 
> If userspace then wants to support "migrate from explicitly set v0.2 new
> kernel to old kernel", then it must add specific support to filter out
> the register from the register list; not that I think anyone will need
> that or bother to implement it.
> 
> In other words, I think you should merge this:
> 
> Reviewed-by: Christoffer Dall <cdall@kernel.org>
> 

Thanks. One issue is that we've now missed the 4.16 train, and that this
effectively is an ABI change (a fairly minor one, but still). Would we
consider slapping this as a retrospective fix to 4.16-stable, or keep it
as a 4.17 feature?

	M.
-- 
Jazz is not dead. It just smells funny...
