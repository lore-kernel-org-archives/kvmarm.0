From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [REPOST PATCH] arm/arm64: KVM: Add PSCI version selection API
Date: Thu, 15 Mar 2018 19:00:27 +0000
Message-ID: <8042f946-49bf-5fc1-f513-4b76ccd5f7d6@arm.com>
References: <20180215175803.6870-1-marc.zyngier@arm.com>
 <db215c1e-0ce8-32e4-d131-e790bebf353e@redhat.com>
 <86o9k63f7a.wl-marc.zyngier@arm.com>
 <CAFEAcA8XYV=oSX81ON4CGDt0kfG1cgROqj30OC2Ov=bYhLSYig@mail.gmail.com>
 <20180306092134.4bfbz34yhqfrfdlf@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306092134.4bfbz34yhqfrfdlf@kamzik.brq.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/18 09:21, Andrew Jones wrote:
> On Mon, Mar 05, 2018 at 04:47:55PM +0000, Peter Maydell wrote:
>> On 2 March 2018 at 11:11, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On Fri, 02 Mar 2018 10:44:48 +0000,
>>> Auger Eric wrote:
>>>> I understand the get/set is called as part of the migration process.
>>>> So my understanding is the benefit of this series is migration fails in
>>>> those cases:
>>>>
>>>>> =0.2 source -> 0.1 destination
>>>> 0.1 source -> >=0.2 destination
>>>
>>> It also fails in the case where you migrate a 1.0 guest to something
>>> that cannot support it.
>>
>> I think it would be useful if we could write out the various
>> combinations of source, destination and what we expect/want to
>> have happen. My gut feeling here is that we're sacrificing
>> exact migration compatibility in favour of having the guest
>> automatically get the variant-2 mitigations, but it's not clear
>> to me exactly which migration combinations that's intended to
>> happen for. Marc?
>>
>> If this wasn't a mitigation issue the desired behaviour would be
>> straightforward:
>>  * kernel should default to 0.2 on the basis that
>>    that's what it did before
>>  * new QEMU version should enable 1.0 by default for virt-2.12
>>    and 0.2 for virt-2.11 and earlier
>>  * PSCI version info shouldn't appear in migration stream unless
>>    it's something other than 0.2
>> But that would leave some setups (which?) unnecessarily without the
>> mitigation, so we're not doing that. The question is, exactly
>> what *are* we aiming for?
> 
> The reason Marc dropped this patch from the series it was first introduced
> in was because we didn't have the aim 100% understood. We want the
> mitigation by default, but also to have the least chance of migration
> failure, and when we must fail (because we're not doing the
> straightforward approach listed above, which would prevent failures), then
> we want to fail with the least amount of damage to the user.
> 
> I experimented with a couple different approaches and provided tables[1]
> with my results. I even recommended an approach, but I may have changed
> my mind after reading Marc's follow-up[2]. The thread continues from
> there as well with follow-ups from Christoffer, Marc, and myself. Anyway,
> Marc did this repost for us to debate it and work out the best approach
> here.
It doesn't look like we've made much progress on this, which makes me
think that we probably don't need anything of the like.

Going, going... Gone?

	M.
-- 
Jazz is not dead. It just smells funny...
