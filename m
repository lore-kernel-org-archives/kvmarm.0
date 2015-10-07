From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Wed, 07 Oct 2015 16:35:46 +0100
Message-ID: <56153BD2.1050904@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com> <1444229726-31559-13-git-send-email-andre.przywara@arm.com> <026901d10112$4dea39d0$e9bead70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <026901d10112$4dea39d0$e9bead70$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Andre Przywara' <andre.przywara@arm.com>, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/10/15 16:10, Pavel Fedin wrote:
>  Hello!
> 
>> As the actual LPI number in a guest can be quite high, but is mostly
>> assigned using a very sparse allocation scheme, bitmaps and arrays
>> for storing the virtual interrupt status are a waste of memory.
>> We use our equivalent of the "Interrupt Translation Table Entry"
>> (ITTE) to hold this extra status information for a virtual LPI.
> 
> You know, not that i'm strongly against current approach and want you
> to redo everything once again, but... Is it architecturally correct
> to intertwine LPIs and ITS so much? As far as i

Yes it is.

> understand arch manual, it is possible to have LPIs without ITS
> (triggered by something else?). Shouldn't we do the same, and just
> add LPI support to our redistributors, and then proceed with the 
> ITS?

No. We're implementing a monolithic GICv3 that doesn't offer writing to
the redistributors directly from a device. And frankly, that's good enough.

> As to memory consumption, do we really need to store own copy of
> tables? After all, it's just a memory. What if we map a pointer
> directly into guest's memory (which it writes to 
> PROPBASER/PENDBASER), and just keep it? There will be no issues with
> caching and synchronization at all.

Sure. And you then have to parse and validate all the tables each and
every time you're going to inject an interrupt (because the guest can
change the table content behind your back). You are quickly going to
notice that your performance is abysmal.

At that point, you're going to start being clever, and add a cache. And
guess what, that's what the HW does too. And then you'll make your cache
a convenient structure to be able to quickly inject interrupts. And
that's what the HW does too. And finally, you're going to realize that
populating a cache sucks, and you're going to keep all the state where
it is convenient, when it is convenient (and that's basically always).

The HW can't do that, but we can.

	M.
-- 
Jazz is not dead. It just smells funny...
