From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 03/12] arm64: Remove the ability to build a kernel
 without ssbd
Date: Fri, 15 Feb 2019 18:20:38 +0000
Message-ID: <20190215182037.GI100037@arrakis.emea.arm.com>
References: <20190125180711.1970973-1-jeremy.linton@arm.com>
 <20190125180711.1970973-4-jeremy.linton@arm.com>
 <20190130180415.0cab24e0@donnerap.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D60A4A320
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 13:20:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CfwawmYb8ncQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Feb 2019 13:20:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43D8340493
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 13:20:44 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190130180415.0cab24e0@donnerap.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: stefan.wahren@i2se.com, mlangsdo@redhat.com, marc.zyngier@arm.com, ykaukab@suse.de, will.deacon@arm.com, linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, steven.price@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 30, 2019 at 06:04:15PM +0000, Andre Przywara wrote:
> On Fri, 25 Jan 2019 12:07:02 -0600
> Jeremy Linton <jeremy.linton@arm.com> wrote:
> > Buried behind EXPERT is the ability to build a kernel without
> > SSBD, this needlessly clutters up the code as well as creates
> > the opportunity for bugs. It also removes the kernel's ability
> > to determine if the machine its running on is vulnerable.
> 
> I don't know the original motivation for this config option, typically
> they are not around for no reason.
> I see the benefit of dropping those config options, but we want to make
> sure that people don't start hacking around to remove them again.
> 
> > Since its also possible to disable it at boot time, lets remove
> > the config option.
> 
> Given the level of optimisation a compiler can do with the state being
> known at compile time, I would imagine that it's not the same (though
> probably very close).
> 
> But that's not my call, it would be good to hear some maintainer's
> opinion on this.

Having spoken to Will, we'd rather keep the config options if possible.
Even if they are behind EXPERT and default y, they come in handy when
debugging.

Can we still have the sysfs information regardless of whether the config
is enabled or not? IOW, move the #ifdefs around to always have the
detection while being able to disable the actual workarounds via config?

Are the code paths between config and cmdline disabling identical? At a
quick look I got the impression they are not exactly the same.

-- 
Catalin
