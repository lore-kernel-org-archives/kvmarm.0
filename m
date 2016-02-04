From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: MPIDR Aff0 question
Date: Thu, 4 Feb 2016 18:51:06 +0000
Message-ID: <56B39D9A.7000008@arm.com>
References: <20160204183801.GF3890@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 025DC48529
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 13:45:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b3ICkhWNL882 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 13:45:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9392D419D1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 13:45:39 -0500 (EST)
In-Reply-To: <20160204183801.GF3890@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, andre.przywara@arm.com
Cc: qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 04/02/16 18:38, Andrew Jones wrote:
> 
> Hi Marc and Andre,
> 
> I completely understand why reset_mpidr() limits Aff0 to 16, thanks
> to Andre's nice comment about ICC_SGIxR. Now, here's my question;
> it seems that the Cortex-A{53,57,72} manuals want to further limit
> Aff0 to 4, going so far as to say bits 7:2 are RES0. I'm looking
> at userspace dictating the MPIDR for KVM. QEMU tries to model the
> A57 right now, so to be true to the manual, Aff0 should only address
> four PEs, but that would generate a higher trap cost for SGI broadcasts
> when using KVM. Sigh... what to do?

There are two things to consider:

- The GICv3 architecture is perfectly happy to address 16 CPUs at Aff0.
- ARM cores are designed to be grouped in clusters of at most 4, but
other implementations may have very different layouts.

If you want to model something matches reality, then you have to follow
what Cortex-A cores do, assuming you are exposing Cortex-A cores. But
absolutely nothing forces you to (after all, we're not exposing the
intricacies of L2 caches, which is the actual reason why we have
clusters of 4 cores).

> Additionally I'm looking at adding support to represent more complex
> topologies in the guest MPIDR (sockets/cores/threads). I see Linux
> currently expects Aff2:socket, Aff1:core, Aff0:thread when threads
> are in use, and Aff1:socket, Aff0:core, when they're not. Assuming
> there are never more than 4 threads to a core makes the first
> expectation fine, but the second one would easily blow the 2 Aff0
> bits alloted, and maybe even a 4 Aff0 bit allotment.
> 
> So my current thinking is that always using Aff2:socket, Aff1:cluster,
> Aff0:core (no threads allowed) would be nice for KVM, and allowing up
> to 16 cores to be addressed in Aff0. As it seems there's no standard
> for MPIDR, then that could be the KVM guest "standard".
> 
> TCG note: I suppose threads could be allowed there, using
> Aff2:socket, Aff1:core, Aff0:thread (no more than 4 threads)

I'm not sure why you'd want to map a given topology to a guest (other
than to give the illusion of a particular system). The affinity register
does not define any of this (as you noticed). And what would Aff3 be in
your design? Shelve? Rack? ;-)

What would the benefit of defining a "socket"?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
