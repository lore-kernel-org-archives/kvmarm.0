From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 0/9] KVM: arm/arm64: race fixes and vcpu requests
Date: Tue, 4 Apr 2017 09:27:46 +0200
Message-ID: <20170404072746.psxsrjstgv6qwyvp@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170403152845.GB11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB31040064
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 03:25:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w47ObS1X8O28 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 03:25:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5259E40A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 03:25:40 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170403152845.GB11752@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 03, 2017 at 05:28:45PM +0200, Christoffer Dall wrote:
> Hi Drew,
> 
> On Fri, Mar 31, 2017 at 06:06:49PM +0200, Andrew Jones wrote:
> > This series fixes some hard to produce races by introducing the use of
> > vcpu requests.  It also fixes a couple easier to produce races, ones
> > that have been produced with the PSCI kvm-unit-test test.  The easy two
> > are addressed in two different ways: the first takes advantage of
> > power_off having been changed to a vcpu request, the second caches vcpu
> > MPIDRs in order to avoid extracting them from sys_regs.  I've tested the
> > series on a Mustang and a ThunderX and compile-tested the ARM bits.
> > 
> > Patch 2/9 adds documentation, as, at least for me, understanding vcpu
> > request interplay with vcpu kicks and vcpu mode and the memory barriers
> > that interplay implies, is exhausting.  Hopefully the document is useful
> > to others.  I'm not married to it though, so it can be deferred/dropped
> > as people like...
> 
> Sounds helpful, I'll have a look.
> 
> > 
> > v2:
> >   - No longer based on Radim's vcpu request API rework[1], except for
> >     including "add kvm_request_pending" as patch 1/9 [drew]
> 
> I lost track here; did those patches get merged or dropped and why are
> we not basing this work on them anymore, and should patch 1/9 be applied
> here or is it expected to land in the KVM tree via some other path?

I think Radim still wants to rework the API, but, as his work doesn't
provide fixes or functional changes, his timeline may not be the same
as for this series.  He also wants to expand his rework to add API
that includes kicking with requesting.  I'm not sure how all that will
look yet, so, in the end, I decided I might as well just use the current
API for now.  kvm_request_pending() was too nice an addition to drop
though.

> 
> >   - Added vcpu request documentation [drew]
> >   - Dropped the introduction of user settable MPIDRs [Christoffer]
> >   - Added vcpu requests to all request-less vcpu kicks [Christoffer]
> > 
> 
> Didn't we also have an issue with a missing barrier if the cmpxchg
> operation doesn't succeed?  Did that fall though the cracks or is it
> just missing in the changelog?

Just missing from the changelog. Sorry about that.

  - Ensure we have a read barrier (or equivalent) prior to issuing the
    cmpxchg in kvm_vcpu_exiting_guest_mode(), as a failed cmpxchg does
    not guarantee any barrier [Christoffer]

Thanks,
drew
