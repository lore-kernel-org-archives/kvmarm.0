From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 00/12] arm64: Paravirtualized time support
Date: Tue, 8 Jan 2019 11:36:37 +0100
Message-ID: <20190108103637.GI10769@e113682-lin.lund.arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 806DA4A41D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:36:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5s1xbv1OVrpx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jan 2019 05:36:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F784A3F9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:36:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 11:40:47AM +0000, Mark Rutland wrote:
> On Wed, Nov 28, 2018 at 02:45:15PM +0000, Steven Price wrote:
> > This series add support for paravirtualized time for Arm64 guests and
> > KVM hosts following the specification in Arm's document DEN 0057A:
> > 
> > https://developer.arm.com/docs/den0057/a
> > 
> > It implements support for Live Physical Time (LPT) which provides the
> > guest with a method to derive a stable counter of time during which the
> > guest is executing even when the guest is being migrated between hosts
> > with different physical counter frequencies.
> > 
> > It also implements support for stolen time, allowing the guest to
> > identify time when it is forcibly not executing.
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

Is this necessarily true?

As I understood the intention of the spec, there would be no change to
behavior of the timers as exposed by the hypervisor unless a software
agent specifically ops-int to LPT and pv-freq.

In a scenario with Linux and UEFI running, they must clearly agree on
using functionality that changes the underlying behavior.  For
kdump/kexec scenarios, the OS would have to tear down the functionality
to work across migration after loading a secondary SW agent, which
probably needs adding to the spec.

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

I think we'd definitely need to limit the exposure of pv-freq to Linux
and (if necessary) UEFI runtime services.  Do you see scenarios where
this would not be possible?


[...]

> 
> I understand that LPT is supposed to account for time lost during the
> migration. Can we account for this without pv-freq? e.g. is it possible
> to account for this in the same way as stolen time?
> 

I think we can indeed account for lost time during migration or host
system suspend by simply adjusting CNTVOFF_EL2 (as Steve points out, KVM
already supports this, but QEMU doesn't make use of that today -- there
were some patches attempting to address that recently).


Thanks,

    Christoffer
