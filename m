From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] arm64: KVM: Allow unaligned accesses at EL2
Date: Wed, 7 Jun 2017 11:11:30 +0100
Message-ID: <72fb1aed-b99e-27e1-5940-ec160163aef3@arm.com>
References: <20170606180835.14421-1-marc.zyngier@arm.com>
 <20170606180835.14421-3-marc.zyngier@arm.com> <20170606200912.GQ9464@cbox>
 <73f039f7-7597-fd34-367c-1cc6fdda3673@arm.com> <20170607095646.GD24481@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170607095646.GD24481@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/06/17 10:56, Christoffer Dall wrote:
> On Wed, Jun 07, 2017 at 10:16:29AM +0100, Marc Zyngier wrote:
>> On 06/06/17 21:09, Christoffer Dall wrote:
>>> On Tue, Jun 06, 2017 at 07:08:34PM +0100, Marc Zyngier wrote:
>>>> We currently have the SCTLR_EL2.A bit set, trapping unaligned accesses
>>>> at EL2, but we're not really prepared to deal with it. So far, this
>>>> has been unnoticed, until GCC 7 started emitting those (in particular
>>>> 64bit writes on a 32bit boundary).
>>>>
>>>> Since the rest of the kernel is pretty happy about that, let's follow
>>>> its example and set SCTLR_EL2.A to zero. Modern CPUs don't really
>>>> care.
>>>
>>> Why do we set the A flag via SCTLR_ELx_FLAGS in the first place, only to
>>> drop that flag later on for both EL1 and EL2 ?
>>
>> That flag is always cleared at EL1, never set. Actually, only EL2 uses
>> that macro to *set* flags. An alternative would be to do away with the
>> macro and use the individual flags, like the 32bit side does.
>>
>> What do you think?
>>
> I don't understand why the A bit is part of SCTLR_ELx_FLAGS then?  Is it
> used as a mask, is that why?

Yes. See arch/arm64/kernel/cpu-reset.S for example, where the macro is
used to clear all these flags in one go. SCTLR_EL1.A was never set the
first place (it was cleared at boot time in __cpu_setup).

We could remove the A bit from SCTLR_ELx_FLAGS altogether, and it
wouldn't have any observable effect (or so I believe). This would be
another way to fix this problem.

> In terms of these patches, I think we should apply these, because they
> solve the problem and do the same thing.

OK.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
