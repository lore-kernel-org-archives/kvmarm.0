From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/8] KVM/ARM: Guest Entry/Exit optimizations
Date: Tue, 16 Feb 2016 20:05:29 +0000
Message-ID: <56C38109.3020501@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <20160210204012.GS5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160210204012.GS5171@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 20:40, Christoffer Dall wrote:
> On Mon, Feb 08, 2016 at 11:40:14AM +0000, Marc Zyngier wrote:
>> I've recently been looking at our entry/exit costs, and profiling
>> figures did show some very low hanging fruits.
>>
>> The most obvious cost is that accessing the GIC HW is slow. As in
>> "deadly slow", specially when GICv2 is involved. So not hammering the
>> HW when there is nothing to write is immediately beneficial, as this
>> is the most common cases (whatever people seem to think, interrupts
>> are a *rare* event).
>>
>> Another easy thing to fix is the way we handle trapped system
>> registers. We do insist on (mostly) sorting them, but we do perform a
>> linear search on trap. We can switch to a binary search for free, and
>> get immediate benefits (the PMU code, being extremely trap-happy,
>> benefits immediately from this).
>>
>> With these in place, I see an improvement of 20 to 30% (depending on
>> the platform) on our world-switch cycle count when running a set of
>> hand-crafted guests that are designed to only perform traps.
>>
> 
> By the way, I took this whole stack of changes (wsinc, vhe, and
> optimizations) and ran it on Mustang and fired up UEFI and did a reboot
> and things seem to work, so that's a small shallow
> 'tested-by-something-else-than-a-linux-guest' statement from me.

I've ran a slightly heavier set of tests, and the infamous reboot loop
broke, thanks to patch #7.

Notice how we fail to wipe the vgic_apr copy on the "light" exit path?
If you're unlucky (and odds are that you will be), you will inject an
interrupt while its active priority bit is set, and the new interrupt
won't be delivered. Bah.

With that fixed, the reboot loop has been going strong for a few hours.
I'll leave my Seattle cooking overnight and if everything looks good in
the morning, I'll repost a new set of patches.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
