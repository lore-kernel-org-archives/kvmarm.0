From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/8] KVM/ARM: Guest Entry/Exit optimizations
Date: Wed, 10 Feb 2016 21:40:12 +0100
Message-ID: <20160210204012.GS5171@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 11:40:14AM +0000, Marc Zyngier wrote:
> I've recently been looking at our entry/exit costs, and profiling
> figures did show some very low hanging fruits.
> 
> The most obvious cost is that accessing the GIC HW is slow. As in
> "deadly slow", specially when GICv2 is involved. So not hammering the
> HW when there is nothing to write is immediately beneficial, as this
> is the most common cases (whatever people seem to think, interrupts
> are a *rare* event).
> 
> Another easy thing to fix is the way we handle trapped system
> registers. We do insist on (mostly) sorting them, but we do perform a
> linear search on trap. We can switch to a binary search for free, and
> get immediate benefits (the PMU code, being extremely trap-happy,
> benefits immediately from this).
> 
> With these in place, I see an improvement of 20 to 30% (depending on
> the platform) on our world-switch cycle count when running a set of
> hand-crafted guests that are designed to only perform traps.
> 

By the way, I took this whole stack of changes (wsinc, vhe, and
optimizations) and ran it on Mustang and fired up UEFI and did a reboot
and things seem to work, so that's a small shallow
'tested-by-something-else-than-a-linux-guest' statement from me.

-Christoffer
