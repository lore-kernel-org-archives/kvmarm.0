From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 2/2] arm64: add micro-bench
Date: Mon, 3 Sep 2018 16:59:40 +0200
Message-ID: <20180903145940.7dbpbooniudx3zpg@kamzik.brq.redhat.com>
References: <20180830141733.21725-1-drjones@redhat.com>
 <20180830141733.21725-3-drjones@redhat.com>
 <20180903111236.GH4029@e113682-lin.lund.arm.com>
 <20180903121130.uhkkz2avwknhxobs@kamzik.brq.redhat.com>
 <20180903131431.GL4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6C34A1D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 10:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vi4FKj4w0mYq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 10:59:45 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 229A64A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 10:59:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180903131431.GL4029@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, marc.zyngier@arm.com, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 03, 2018 at 03:14:31PM +0200, Christoffer Dall wrote:
> On Mon, Sep 03, 2018 at 02:11:30PM +0200, Andrew Jones wrote:
> > On Mon, Sep 03, 2018 at 01:12:36PM +0200, Christoffer Dall wrote:
> > > On Thu, Aug 30, 2018 at 04:17:33PM +0200, Andrew Jones wrote:
> > > > From: Shih-Wei Li <shihwei@cs.columbia.edu>
> > > > 
> > > > Here we provide the support for measuring various micro level
> > > > operations on arm64. Measurements are currently obtained using
> > > > timer counters. Further modifications in KVM will be required
> > > > to support timestamping using cycle counters, as KVM now disables
> > > > accesses to the PMU counters from the VM.
> > > > 
> > > > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> > > > Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > 
> > > Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> > 
> > Thanks Christoffer! While running this I just noticed a bug though.
> > It seemed my hardware was super-duper fast, because I was missing...
> > 
> > > > +#define PS_PER_SEC (1000 * 1000 * 1000 * 1000U)
> >                                     ...an 'L' here ^
> > 
> > I'll send a v2 with that fix now and also add your acked-by.
> > 
> 
> I didn't verify the numeric aspects of the test this time around, but
> looked at what the tests do and ran this on a couple of platforms.
> 
> I figured we should merge this and we can fix small issues later if they
> appear.

Yeah, I agree. We should get it merged and then as people use it, we'll
be able to better see what's wrong or how it can be improved. I think
v2 is in decent shape now. Hopefully those that run these types of
benchmarks will try it out and suggest/post improvements.

Thanks,
drew
