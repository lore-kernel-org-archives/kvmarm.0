From: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 00/12] arm64: Paravirtualized time support
Date: Mon, 10 Dec 2018 16:08:56 +0000
Message-ID: <3a859c39-572f-450e-5e43-d0cab54048ac@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CF5D4A361
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 11:09:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M2-HUCoWPsB2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 11:08:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927634A211
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 11:08:59 -0500 (EST)
In-Reply-To: <20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/12/2018 11:40, Mark Rutland wrote:
> On Wed, Nov 28, 2018 at 02:45:15PM +0000, Steven Price wrote:
>> This series add support for paravirtualized time for Arm64 guests and
>> KVM hosts following the specification in Arm's document DEN 0057A:
>>
>> https://developer.arm.com/docs/den0057/a
>>
>> It implements support for Live Physical Time (LPT) which provides the
>> guest with a method to derive a stable counter of time during which the
>> guest is executing even when the guest is being migrated between hosts
>> with different physical counter frequencies.
>>
>> It also implements support for stolen time, allowing the guest to
>> identify time when it is forcibly not executing.
> 
> I know that stolen time reporting is important, and I think that we
> definitely want to pick up that part of the spec (once it is published
> in some non-draft form).
> 
> However, I am very concerned with the pv-freq part of LPT, and I'd like
> to avoid that if at all possible. I say that because:
> 
> * By design, it breaks architectural guarantees from the PoV of SW in
>   the guest.
> 
>   A VM may host multiple SW agents serially (e.g. when booting, or
>   across kexec), or concurrently (e.g. Linux w/ EFI runtime services),
>   and the host has no way to tell whether all software in the guest will
>   function correctly. Due to this, it's not possible to have a guest
>   opt-in to the architecturally-broken timekeeping.
> 
>   Existing guests will not work correctly once pv-freq is in use, and if
>   configured without pv-freq (or if the guest fails to discover pv-freq
>   for any reason), the administrator may encounter anything between
>   subtle breakage or fatally incorrect timekeeping.
> 
>   There's plenty of SW agents other than Linux which runs in a guest,
>   which would need to be updated to handle pv-freq, e.g. GRUB, *BSD,
>   iPXE.
> 
>   Given this, I think that this is going to lead to subtle breakage in
>   real-world scenarios. 

LPT only changes things on migration. Up until migration the
(architectural) clocks still behave perfectly normally. A guest which
opts in to LPT can derive a clock with a different frequency, but the
underlying clock doesn't change.

When migration happens it's a different story.

If the frequency of the new host matches the old host then again the
clocks behave 'normally': CNTVOFF is used to hide the change in offset
such that the guest at worst sees time pause during the actual migration.

But the whole point of LPT is to deal with the situation if the clock
frequency has changed. A guest (or SW agent) which doesn't know about PV
will experience one of two things:

* Without LPT: the clock frequency will suddenly change without warning,
but the virtual counter is monotonically increasing.

* With LPT: the clock frequency will suddenly change and the virtual
counter will jump (it won't be monotonically increasing).

So I agree the situation with LPT is worse (we lose the monotonicity),
but any guest/agent which didn't understand about the migration is in
trouble if it cares about time.

> * It is (necessarily) invasive to the low-level arch timer code. This is
>   unfortunate, and I strongly suspect this is going to be an area with
>   long-term subtle breakage.

I can't argue against that - I've tried to limit how invasive the code
changes are, but ultimately we're changing the interpretation of
low-level timers.

> * It's not clear to me how strongly people need this. My understanding
>   is that datacenters would run largely homogeneous platforms. I suspect
>   large datacenters which would use migration are in a position to
>   mandate a standard timer frequency from their OEMs or SiPs.
> 
>   I strongly believe that an architectural fix (e.g. in-hw scaling)
>   would be the better solution.

An architectural fix in hardware is clearly the best solution. The
question is whether we want to support the use-case with today's
hardware. While mandating a particular 'standard' timer frequency is a
good idea, there's currently no standard. Large datacenters might be
able to mandate that, and maybe there'll be sufficient consensus that
this doesn't matter. But I seem to have misplaced my crystal ball...

> I understand that LPT is supposed to account for time lost during the
> migration. Can we account for this without pv-freq? e.g. is it possible
> to account for this in the same way as stolen time?

LPT isn't really about accounting for the time lost (to some extent this
is already done by saving/restoring the "KVM_REG_ARM_TIMER_CNT"
register) but about ensuring that the guest can derive a monotonically
increasing counter which maintains a stable frequency when migrated.

I'm going to respin the series with the LPT parts split out to the end,
that way we can (hopefully) agree on the stolen time parts and can defer
the LPT part if necessary.

Thanks,

Steve

> Thanks,
> Mark.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
