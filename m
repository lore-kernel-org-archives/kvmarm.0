From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 00/11] arm64/firmware: Software Delegated Exception
 Interface
Date: Wed, 7 Jun 2017 11:53:26 +0200
Message-ID: <20170607095326.GC24481@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170606195944.GM9464@cbox> <5937CB3C.6040800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55F1A40A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:49:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4MYRUNXh1r9d for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Jun 2017 05:49:33 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A7BB40905
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:49:32 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id x70so54067093wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Jun 2017 02:53:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5937CB3C.6040800@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 07, 2017 at 10:45:32AM +0100, James Morse wrote:
> Hi Christoffer,
> 
> On 06/06/17 20:59, Christoffer Dall wrote:
> > On Mon, May 15, 2017 at 06:43:48PM +0100, James Morse wrote:
> >> Running the event handler behind VHE-KVM's back has some side effects: The
> >> event handler will blindly use any registers that are shared between the host
> >> and guest. The two that I think matter are TPIDR_EL1, and the debug state. The
> >> guest may have set MDSCR_EL1 so debug exceptions must remain masked. The
> >> guest's TPIDR_EL1 will be used by the event handler if it accesses per-cpu
> >> variables. This needs fixing. The first part of this series juggles KVMs use
> >> of TPIDR_EL2 so that we share it with the host on VHE systems. An equivalent
> >> change for 32bit is on my todo list. (one alternative to this is to have a
> >> parody world switch in the SDEI event handler, but this would mean special
> >> casing interrupted guests, and be an ABI link to KVM.)
> >>
> >> Causing a synchronous exception from an event handler will cause KVM to
> >> hyp-panic, but may silently succeed if the event didn't interrupt a guest.
> >> (I may WARN_ON() if this happens in a later patch). You because of this you
> > 
> > The last sentence here doesn't make much sense to me.
> 
> If this interrupts a VHE-guest, KVM's hyp-vectors remain in vbar_el2. If we then
> take a synchronous exception, KVM will assume this happened during world switch
> and panic.
> In contrast if you didn't interrupt a guest, the kernel vectors are in vbar_el2,
> so the fault will be handled.

Sorry, I actually just meant the grammar... "You because of this you..."

> 
> This 'silently succeed' only occurred to me when writing the cover-letter,
> (hence its probably worded badly). I plan to catch it by save-restoring the
> exception registers, and warning if they've changed as this would hyp-panic if
> you interrupted a guest.
> 

But I didn't understand that before, and didn't realize that 'silently
succeed' may not be what you want.

Thanks for the explanation.

-Christoffer
