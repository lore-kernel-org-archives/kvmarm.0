From: Andrew Jones <drjones@redhat.com>
Subject: Re: MPIDR Aff0 question
Date: Fri, 5 Feb 2016 13:08:50 +0100
Message-ID: <20160205120850.GE3873@hawk.localdomain>
References: <20160204183801.GF3890@hawk.localdomain> <56B39D9A.7000008@arm.com>
 <20160205092353.GA3873@hawk.localdomain>
 <20160205110032.GA19614@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB3A49680
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 07:03:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H0HByTj9nTvJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 07:03:23 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75B5E49616
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 07:03:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20160205110032.GA19614@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 05, 2016 at 11:00:33AM +0000, Mark Rutland wrote:
> On Fri, Feb 05, 2016 at 10:23:53AM +0100, Andrew Jones wrote:
> > On Thu, Feb 04, 2016 at 06:51:06PM +0000, Marc Zyngier wrote:
>  > What would the benefit of defining a "socket"?
> > 
> > That's a good lead in for my next question. While I don't believe
> > there needs to be any relationship between socket and numa node, I
> > suspect on real machines there is, and quite possibly socket == node.
> > Shannon is adding numa support to QEMU right now. Without special
> > configuration there's no gain other than illusion, but with pinning,
> > etc. the guest numa nodes will map to host nodes, and thus passing
> > that information on to the guest's kernel is useful. Populating a
> > socket/node affinity field seems to me like a needed step. But,
> > question time, is it? Maybe not. 
> 
> I don't think it's necessary.
> 
> When using ACPI, NUMA info comes from SRAT+SLIT, and the MPIDR.Aff*
> fields do not provide NUMA topology info. I expect the same to be true
> with DT using something like numa-distance-map [1].

Thanks Mark. So it appears my NUMA connection was just muddying the
water. Modeling sockets may or may not have any value to a guest,
but in any case it's a separate issue.

> 
> > Also, the way Linux currently handles non-thread using MPIDRs
> > (Aff1:socket, Aff0:core) throws a wrench at the Aff2:socket,
> > Aff1:"cluster", Aff0:core(max 16) plan.  Either the plan or Linux
> > would need to be changed.
> 
> The topology can be explicitly overridden in DT using cpu-map [2]. I
> don't know what the story for ACPI is.

Thanks for the cpu-map pointer. That was indeed the piece I'd missed
that allows me to make sense of MPIDR affinity level use. I think I'll
still look into modeling sockets/cores/threads with QEMU, by also
adding cpu-map generation. I'll look into what the ACPI equivalent is
as well.

drew

> 
> Mark.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-February/404057.html
> [2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/arm/topology.txt?h=v4.5-rc2&id=36f90b0a2ddd60823fe193a85e60ff1906c2a9b3
