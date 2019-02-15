From: Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH v4 03/12] arm64: Remove the ability to build a kernel
 without ssbd
Date: Fri, 15 Feb 2019 12:54:22 -0600
Message-ID: <7fa79e1a-3b35-520a-676b-031030108c50@arm.com>
References: <20190125180711.1970973-1-jeremy.linton@arm.com>
 <20190125180711.1970973-4-jeremy.linton@arm.com>
 <20190130180415.0cab24e0@donnerap.cambridge.arm.com>
 <20190215182037.GI100037@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190215182037.GI100037@arrakis.emea.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, stefan.wahren@i2se.com, mlangsdo@redhat.com, suzuki.poulose@arm.com, marc.zyngier@arm.com, julien.thierry@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, steven.price@arm.com, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, ykaukab@suse.de, dave.martin@arm.com, shankerd@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,


Thanks for taking a look at this:

On 2/15/19 12:20 PM, Catalin Marinas wrote:
> On Wed, Jan 30, 2019 at 06:04:15PM +0000, Andre Przywara wrote:
>> On Fri, 25 Jan 2019 12:07:02 -0600
>> Jeremy Linton <jeremy.linton@arm.com> wrote:
>>> Buried behind EXPERT is the ability to build a kernel without
>>> SSBD, this needlessly clutters up the code as well as creates
>>> the opportunity for bugs. It also removes the kernel's ability
>>> to determine if the machine its running on is vulnerable.
>>
>> I don't know the original motivation for this config option, typically
>> they are not around for no reason.
>> I see the benefit of dropping those config options, but we want to make
>> sure that people don't start hacking around to remove them again.
>>
>>> Since its also possible to disable it at boot time, lets remove
>>> the config option.
>>
>> Given the level of optimisation a compiler can do with the state being
>> known at compile time, I would imagine that it's not the same (though
>> probably very close).
>>
>> But that's not my call, it would be good to hear some maintainer's
>> opinion on this.
> 
> Having spoken to Will, we'd rather keep the config options if possible.
> Even if they are behind EXPERT and default y, they come in handy when
> debugging.
> 
> Can we still have the sysfs information regardless of whether the config
> is enabled or not? IOW, move the #ifdefs around to always have the
> detection while being able to disable the actual workarounds via config?

Yes, that is possible, but the ifdef'ing gets even worse. (see v3).

> Are the code paths between config and cmdline disabling identical? At a
> quick look I got the impression they are not exactly the same.

No, they do vary slightly. For debugging I would expect that the CONFIG 
disabled code paths to be the one that accumulates bugs over time. The 
command line options just force the runtime vulnerable/not-vulnerable 
decision, which should be the code paths in general use. For benchmark 
the run-time options are also a better choice because they don't have 
any 2nd order affects caused by code alignment/etc changes.

Maybe your implying the CONFIG_ options should basically force the 
command line? That both reduces the code paths, and simplifies the 
ifdef'ing.
