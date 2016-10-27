From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: Perform local TLB invalidation when
 multiplexing vcpus on a single CPU
Date: Thu, 27 Oct 2016 12:04:28 +0200
Message-ID: <20161027100428.GA17829@cbox>
References: <1477323088-18768-1-git-send-email-marc.zyngier@arm.com>
 <20161027091906.GA14734@cbox>
 <7541af85-05c4-25f9-2fa8-2eb7a0afbe84@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1701240421
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 06:04:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a3VhNkgXi6XB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2016 06:04:28 -0400 (EDT)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A28454041B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 06:04:28 -0400 (EDT)
Received: by mail-lf0-f47.google.com with SMTP id x79so26518838lff.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 03:04:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <7541af85-05c4-25f9-2fa8-2eb7a0afbe84@arm.com>
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
Cc: Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 27, 2016 at 10:49:00AM +0100, Marc Zyngier wrote:
> Hi Christoffer,
> 
> On 27/10/16 10:19, Christoffer Dall wrote:
> > On Mon, Oct 24, 2016 at 04:31:28PM +0100, Marc Zyngier wrote:
> >> Architecturally, TLBs are private to the (physical) CPU they're
> >> associated with. But when multiple vcpus from the same VM are
> >> being multiplexed on the same CPU, the TLBs are not private
> >> to the vcpus (and are actually shared across the VMID).
> >>
> >> Let's consider the following scenario:
> >>
> >> - vcpu-0 maps PA to VA
> >> - vcpu-1 maps PA' to VA
> >>
> >> If run on the same physical CPU, vcpu-1 can hit TLB entries generated
> >> by vcpu-0 accesses, and access the wrong physical page.
> >>
> >> The solution to this is to keep a per-VM map of which vcpu ran last
> >> on each given physical CPU, and invalidate local TLBs when switching
> >> to a different vcpu from the same VM.
> > 
> > Just making sure I understand this:  The reason you cannot rely on the
> > guest doing the necessary distinction with ASIDs or invalidating the TLB
> > is that a guest (which assumes it's running on hardware) can validly
> > defer any neccessary invalidation until it starts running on other
> > physical CPUs, but we do this transparently in KVM?
> 
> The guest wouldn't have to do any invalidation at all on real HW,
> because the TLBs are strictly private to a physical CPU (only the
> invalidation can be broadcast to the Inner Shareable domain). But when
> we multiplex two vcpus on the same physical CPU, we break the private
> semantics, and a vcpu could hit in the TLB entries populated by the
> another one.

Such a guest would be using a mapping of the same VA with the same ASID
on two separate CPUs, each pointing to a separate PA.  If it ever were
to, say, migrate a task, it would have to do invalidations then.  Right?

Does Linux or other guests actually do this?

I would suspect Linux has to eventually invalidate those mappins if it
wants the scheduler to be allowed to freely move things around.

> 
> As we cannot segregate the TLB entries per vcpu (but only per VMID), the
> workaround is to nuke all the TLBs for this VMID (locally only - no
> broadcast) each time we find that two vcpus are sharing the same
> physical CPU.
> 
> Is that clearer?

Yes, the fix is clear, just want to make sure I understand that it's a
valid circumstance where this actually happens.  But in either case, we
probably have to fix this to emulate the hardware correctly.

Another fix would be to allocate a VMID per VCPU I suppose, just to
introduce a terrible TLB hit ratio :)

Thanks,
-Christoffer
