From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/11] arm/pci: Device tree PCI probing
Date: Fri, 5 Feb 2016 13:18:43 +0100
Message-ID: <20160205121843.GF3873@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <06ff365af0d7579d0e4e431fad2492379533c290.1452341807.git.agordeev@redhat.com>
 <20160113151307.GA10709@hawk.localdomain>
 <20160205114850.GA10781@agordeev.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2E5496E4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 07:13:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNkDtN6DU8Nz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 07:13:15 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0D084969A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 07:13:15 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id 8D4B97AEA7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 12:18:47 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20160205114850.GA10781@agordeev.lab.eng.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Gordeev <agordeev@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 05, 2016 at 12:48:50PM +0100, Alexander Gordeev wrote:
> On Wed, Jan 13, 2016 at 04:13:07PM +0100, Andrew Jones wrote:
> > > diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> > > new file mode 100644
> > > index 0000000..097ac2d
> > > --- /dev/null
> > > +++ b/lib/pci-host-generic.h
> > > @@ -0,0 +1,26 @@
> > > +#ifndef PCI_HOST_GENERIC_H
> > > +#define PCI_HOST_GENERIC_H
> > > +
> > > +struct pci_addr_range {
> > > +	phys_addr_t			start;
> > > +	phys_addr_t			size;
> > > +};
> > > +
> > > +struct pci_addr_space {
> > > +	struct pci_addr_range		cpu_range;
> > > +	struct pci_addr_range		pci_range;
> > > +	phys_addr_t			alloc;
> > 
> > alloc isn't used in this patch, but guess it will be later
> > 
> > > +	u32				of_flags;
> > > +};
> > > +
> > > +struct pci_host_bridge {
> > > +	struct pci_addr_range		cpu_range;
> > > +	int				bus;
> > > +	int				bus_max;
> > > +	int				nr_addr_spaces;
> > > +	struct pci_addr_space		addr_space[];
> > > +};
> > > +
> > > +#define PCI_ECAM_BUS_SIZE		(1 << 20)
> > 
> > Why not put this struct declaration (and supporting structs) in pci.h?
> > Linux has struct pci_host_bridge in include/linux/pci.h
> 
> I think we do not need any of these structures to get public.
> 
> My initial attempt was also an assessment of an idea to
> generalize PCI code across architectures. But my current
> judgement - an outcome is not worth it. With x86 PCI access
> so much different and only bus 0 function 0 "hierarchy" we
> only need the simplest required routines.
> 
> Hence, I would leave these in pci-host-generic.h (just not
> to blow pci-host-generic.c too big).
> 
> As result, just these routines would end up in pci.h:
> 
> 	bool pci_probe(void);
> 	void pci_free(void);	/* pci_shutdown() ? */ 
> 	int pci_bus_scan(void);
> 	int pci_testdev(void);
> 
> Thoughts?

Whichever you prefer. We either "bloat" pci.h or we "bloat" the lib
directory with another file :-) Actually, I still prefer pci.h, because
if arm unit tests will always need both of them, then they'll always
need two #include lines... OTOH, if you don't think unit tests will
need these structures, then they could just be defined right in
pci-host-generic.c (or pci.c if you consolidate the source files).

Thanks,
drew

> 
> > > +
> > > +#endif
> > > diff --git a/lib/pci.h b/lib/pci.h
> > > new file mode 100644
> > > index 0000000..22b8e31
> > > --- /dev/null
> > > +++ b/lib/pci.h
> > > @@ -0,0 +1,13 @@
> > > +#ifndef PCI_H
> > > +#define PCI_H
> > 
> > This file needs its copyright/gpl header. I also like to document
> > the lib here in the header file, e.g. see lib/devicetree.h and
> > lib/alloc.h
> > 
> > > +
> > > +#include "alloc.h"
> > > +
> > > +struct pci {
> > > +	void *sysdata;
> > 
> > The choice of sysdata for the name appears to come from the Linux
> > kernel. Why not also call 'struct pci' 'struct pci_dev' for full
> > consistency?
> > 
> > > +};
> > > +
> > > +extern struct pci *pci_dt_probe(void);
> > > +extern void pci_shutdown(struct pci *pci);
> > > +
> > > +#endif
> > > -- 
> > > 1.8.3.1
> > > 
