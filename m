From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Wed, 6 Mar 2019 09:42:59 +0100
Message-ID: <20190306084259.GE551@e113682-lin.lund.arm.com>
References: <1547482308-29839-1-git-send-email-andrew.murray@arm.com>
 <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
 <20190218215307.GA28113@e113682-lin.lund.arm.com>
 <20190220161539.GA2055@e119886-lin.cambridge.arm.com>
 <20190226124459.GB551@e113682-lin.lund.arm.com>
 <20190304111424.GC40984@e119886-lin.cambridge.arm.com>
 <20190305114551.GG40984@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8821F4A432
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 03:43:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kmYYWfBRKROY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Mar 2019 03:43:02 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 194DD4A41A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Mar 2019 03:43:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190305114551.GG40984@e119886-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 05, 2019 at 11:45:52AM +0000, Andrew Murray wrote:
> On Mon, Mar 04, 2019 at 11:14:24AM +0000, Andrew Murray wrote:
> > On Tue, Feb 26, 2019 at 01:44:59PM +0100, Christoffer Dall wrote:
> > > On Wed, Feb 20, 2019 at 04:15:40PM +0000, Andrew Murray wrote:
> > > > On Mon, Feb 18, 2019 at 10:53:07PM +0100, Christoffer Dall wrote:
> > > > > On Mon, Jan 14, 2019 at 04:11:47PM +0000, Andrew Murray wrote:
> > > > > > Add support for the :G and :H attributes in perf by handling the
> > > > > > exclude_host/exclude_guest event attributes.
> > > > > > 
> > > > > > We notify KVM of counters that we wish to be enabled or disabled on
> > > > > > guest entry/exit and thus defer from starting or stopping :G events
> > > > > > as per the events exclude_host attribute.
> > > > > > 
> > > > > > With both VHE and non-VHE we switch the counters between host/guest
> > > > > > at EL2. We are able to eliminate counters counting host events on
> > > > > > the boundaries of guest entry/exit when using :G by filtering out
> > > > > > EL2 for exclude_host. However when using :H unless exclude_hv is set
> > > > > > on non-VHE then there is a small blackout window at the guest
> > > > > > entry/exit where host events are not captured.
> > > > > > 
> > > > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > > ---
> 
> > > > > 
> > > > > Let me see if I get this right:
> > > > > 
> > > > > 	exclude_user:	VHE: Don't count EL0
> > > > > 			Non-VHE: Don't count EL0
> > > > > 
> > > > > 	exclude_kernel: VHE: Don't count EL2 and don't count EL1
> > > > > 			Non-VHE: Don't count EL1
> > > > > 
> > > > > 	exclude_hv:	VHE: No effect
> > > > > 			Non-VHE: Don't count EL2
> > > > > 
> > > > > 	exclude_host:	VHE: Don't count EL2 + enable/disable on guest entry/exit
> > > > > 			Non-VHE: disable on guest entry/disable on guest entry/exit
> > > > > 
> > > > > And the logic I extract is that _user applies across both guest and
> > > > > host, as does _kernel (regardless of the mode the kernel on the current
> > > > > system runs in, might be only EL1, might be EL1 and EL2), and _hv is
> > > > > specific to non-VHE systems to measure events in a specific piece of KVM
> > > > > code that runs at EL2.
> > > > > 
> > > > > As I expressed before, that doesn't seem to be the intent behind the
> > > > > exclude_hv flag, but I'm not sure how other architectures actually
> > > > > implement things today, and even if it's a curiosity of the Arm
> > > > > architecture and has value to non-VHE hypervisor hackers, and we don't
> > > > > really have to care about uniformity with the other architectures, then
> > > > > fine.
> > > > > 
> > > > > It has taken me a while to make sense of this code change, so I really
> > > > > wish we can find a suitable place to document the semantics clearly for
> > > > > perf users on arm64.
> > > > > 
> > > > > Now, another thing comes to mind:  Do we really need to enable and
> > > > > disable anything on a VHE system on entry/exit to/from a guest?  Can we
> > > > > instead do the following:
> > > > > 
> > > > > 	exclude_host:	Disable EL2 counting
> > > > > 		     	Disable EL0 counting
> > > > > 		     	Enable EL0 counting on vcpu_load
> > > > > 		     	  (unless exclude_user is also set)
> > > > > 		     	Disable EL0 counting on vcpu_put
> > > > > 
> > > > > 	exclude_guest:	Disable EL1 counting
> > > > > 		      	Disable EL0 counting on vcpu_load
> > > > > 		      	Enable EL0 counting on vcpu_put
> > > > > 			  (unless exclude_user is also set)
> > > > > 
> > > > > If that works, we can avoid the overhead in the critical path on VHE
> > > > > systems and actually have slightly more accurate counting, leaving the
> > > > > entry/exit operations to be specific to non-VHE.
> > > > 
> > > > This all makes sense.
> > > > 
> > > > At present on VHE, for host only events, there is a small blackout window
> > > > at the guest entry/exit - this is where we turn off/on host counting before
> > > > entering/exiting the guest. (This blackout window also exists on !VHE unless
> > > > exclude_hv is set).
> > > > 
> > > > To mitigate against this the PMU switching code was brought as close to the
> > > > guest entry/exit as possible - but as you point out at this point in
> > > > kvm_arch_vcpu_ioctl_run we're running without interrupts/preemption and so
> > > > on the critical path. I believe we add about 11 instructions when there are
> > > > no PMU counters enabled and about 23 when they are enabled. I suppose it
> > > > would be possible to use static keys to reduce the overhead when counters
> > > > are not enabled...
> > > > 
> > > > Your suggestion provides an optimal solution, however it adds some
> > > > complexity - here is a rough attempt at implementing it...
> > > > 
> 
> > > > 
> > > > Do you think this is worth developing further?
> > > > 
> > > 
> > > Yes, I think it's worth going to fairly great lengths to keep the
> > > critical path on VHE systems lean, and I suspect if we take the easy way
> > > to add functionality first, it will only be harder to factor things out
> > > later.
> 
> It looks like we can also apply this same approach on !VHE. For the sole
> use-case where a user wishes to count only for a host or guest EL0, then we
> switch the counter at EL1 in vcpu_load instead of the switch code.
> 

ok, even better then.  Looking forward to seeing the patches.

Thanks,

    Christoffer
