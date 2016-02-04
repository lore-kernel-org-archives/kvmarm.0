From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 08/11] arm/pci: PCI device read/write test
Date: Thu, 4 Feb 2016 13:03:13 +0100
Message-ID: <20160204120313.GA15617@dhcp-27-118.brq.redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
 <9da79ee47b7ad328c9ba04af0a2ff4697555b007.1452341807.git.agordeev@redhat.com>
 <20160115153350.GM3915@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D9C412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 06:57:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P0AbmUwG4H7R for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2016 06:57:49 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80C73412DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 06:57:49 -0500 (EST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
 (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
 by mx1.redhat.com (Postfix) with ESMTPS id 515E63C88E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2016 12:03:17 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20160115153350.GM3915@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 15, 2016 at 04:33:50PM +0100, Andrew Jones wrote:
> On Sat, Jan 09, 2016 at 01:22:55PM +0100, Alexander Gordeev wrote:
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  lib/pci-testdev.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> > index de97f82..dd6a5ac 100644
> > --- a/lib/pci-testdev.c
> > +++ b/lib/pci-testdev.c
> > @@ -113,6 +113,9 @@ static bool pci_testdev_one(struct pci_test_dev_hdr *test,
> >  			    struct pci_testdev_ops *ops)
> >  {
> >  	u8 width;
> > +	u32 sig, off;
> > +	const int nr_writes = 16;
> > +	int i;
> >  
> >  	ops->write8(test_nr, &test->test);
> >  	assert(ops->read32(&test->count) == 0);
> > @@ -121,6 +124,19 @@ static bool pci_testdev_one(struct pci_test_dev_hdr *test,
> >  	if ((width != 1) && (width != 2) && (width != 4))
> >  		return false;
> >  
> > +	sig = ops->read32(&test->data);
> > +	off = ops->read32(&test->offset);
> > +
> > +	for (i = 0; i < nr_writes; i++) {
> > +		switch (width) {
> > +			case 1: ops->write8 (sig, (void*)test + off); break;
> > +			case 2: ops->write16(sig, (void*)test + off); break;
> > +			case 4: ops->write32(sig, (void*)test + off); break;
> > +		}
> > +	}
> > +
> > +	assert((int)ops->read32(&test->count) == nr_writes);
> 
> Are you sure we want to assert here? What about outputting a message and
> then returning false instead?

Nice catch.

> > +
> >  	return true;
> >  }
> >  
> > -- 
> > 1.8.3.1
> > 
