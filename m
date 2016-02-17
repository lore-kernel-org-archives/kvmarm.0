From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/8] KVM/ARM: Guest Entry/Exit optimizations
Date: Wed, 17 Feb 2016 10:15:49 +0100
Message-ID: <20160217091549.GB6696@cbox>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <20160210204012.GS5171@cbox> <56C38109.3020501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 292A349947
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 04:08:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GdhuBpq1Akq9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 04:08:44 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3840C49936
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 04:08:44 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id c200so202436299wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 01:15:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56C38109.3020501@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 16, 2016 at 08:05:29PM +0000, Marc Zyngier wrote:
> On 10/02/16 20:40, Christoffer Dall wrote:
> > On Mon, Feb 08, 2016 at 11:40:14AM +0000, Marc Zyngier wrote:
> >> I've recently been looking at our entry/exit costs, and profiling
> >> figures did show some very low hanging fruits.
> >>
> >> The most obvious cost is that accessing the GIC HW is slow. As in
> >> "deadly slow", specially when GICv2 is involved. So not hammering the
> >> HW when there is nothing to write is immediately beneficial, as this
> >> is the most common cases (whatever people seem to think, interrupts
> >> are a *rare* event).
> >>
> >> Another easy thing to fix is the way we handle trapped system
> >> registers. We do insist on (mostly) sorting them, but we do perform a
> >> linear search on trap. We can switch to a binary search for free, and
> >> get immediate benefits (the PMU code, being extremely trap-happy,
> >> benefits immediately from this).
> >>
> >> With these in place, I see an improvement of 20 to 30% (depending on
> >> the platform) on our world-switch cycle count when running a set of
> >> hand-crafted guests that are designed to only perform traps.
> >>
> > 
> > By the way, I took this whole stack of changes (wsinc, vhe, and
> > optimizations) and ran it on Mustang and fired up UEFI and did a reboot
> > and things seem to work, so that's a small shallow
> > 'tested-by-something-else-than-a-linux-guest' statement from me.
> 
> I've ran a slightly heavier set of tests, and the infamous reboot loop
> broke, thanks to patch #7.
> 
> Notice how we fail to wipe the vgic_apr copy on the "light" exit path?
> If you're unlucky (and odds are that you will be), you will inject an
> interrupt while its active priority bit is set, and the new interrupt
> won't be delivered. Bah.
> 
> With that fixed, the reboot loop has been going strong for a few hours.
> I'll leave my Seattle cooking overnight and if everything looks good in
> the morning, I'll repost a new set of patches.
> 
Good that you caught this one then!

-Christoffer
