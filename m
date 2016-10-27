From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Perform local TLB invalidation when
 multiplexing vcpus on a single CPU
Date: Thu, 27 Oct 2016 11:51:26 +0100
Message-ID: <20161027104925.GC27135@leverpostej>
References: <1477323088-18768-1-git-send-email-marc.zyngier@arm.com>
 <20161027091906.GA14734@cbox>
 <7541af85-05c4-25f9-2fa8-2eb7a0afbe84@arm.com>
 <20161027100428.GA17829@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA074025C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 06:51:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 47LHvOgVYkhl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2016 06:51:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48FC74022C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 06:51:54 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20161027100428.GA17829@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Thu, Oct 27, 2016 at 12:04:28PM +0200, Christoffer Dall wrote:
> On Thu, Oct 27, 2016 at 10:49:00AM +0100, Marc Zyngier wrote:
> > The guest wouldn't have to do any invalidation at all on real HW,
> > because the TLBs are strictly private to a physical CPU (only the
> > invalidation can be broadcast to the Inner Shareable domain). But when
> > we multiplex two vcpus on the same physical CPU, we break the private
> > semantics, and a vcpu could hit in the TLB entries populated by the
> > another one.
> 
> Such a guest would be using a mapping of the same VA with the same ASID
> on two separate CPUs, each pointing to a separate PA.  If it ever were
> to, say, migrate a task, it would have to do invalidations then.  Right?

An OS (not Linux) could use a different ASID space per-cpu.

e.g. with two single-threaded tasks A and B, you could have ASIDS:

	cpu0	cpu1
A	0	1
B	1	0

... and this would not be a problem, so long as when mappings changed
maintenance were performed appropriately (e.g. perhaps it uses IPIs to
trigger the relevant local TLB invlidation, rather than using broadcast
ops).

> Does Linux or other guests actually do this?

Linux currently doesn't use ASIDs that way, but does use global mappings
in a potentially-confliciting way in the cold-return paths (hotplug-on
and return from idle). With two vCPUs, you could have a sequence like:

	cpu0				cpu1
	Task with ASID x started
					hotplug on
					install global TTBR0 mapping
					global entry allocated into TLB
	Task hits cpu1's global entry

... which cannot happen bare-metal, and there's no point at which the
guest can perform suitable maintenance.

> Another fix would be to allocate a VMID per VCPU I suppose, just to
> introduce a terrible TLB hit ratio :)

That would break broadcast invalidation within the guest, no?

... unless you also trapped all TLB maintenance, and did the IPI-based
broadcast in SW.

Thanks,
Mark.
