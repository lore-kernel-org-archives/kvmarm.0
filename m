From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 02/11] arm/pci: PCI bus scanning
Date: Tue, 2 Feb 2016 10:34:01 +0100
Message-ID: <20160202093400.GA27102@dhcp-27-118.brq.redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
 <c135546bfd13a2e7655cf10a68181503ec9f5ee5.1452341807.git.agordeev@redhat.com>
 <20160113155846.GB10709@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D880C40F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 04:28:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kIb1Zpd-D1xD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2016 04:28:45 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B61A40BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 04:28:45 -0500 (EST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
 (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
 by mx1.redhat.com (Postfix) with ESMTPS id 3F9C070D74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2016 09:34:05 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20160113155846.GB10709@hawk.localdomain>
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

On Wed, Jan 13, 2016 at 04:58:46PM +0100, Andrew Jones wrote:
> On Sat, Jan 09, 2016 at 01:22:49PM +0100, Alexander Gordeev wrote:
> > Scan bus 0 and function 0 only for now
> > 
> > Cc: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  arm/pci-test.c         |  4 +++
> >  lib/pci-host-generic.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/pci-host-generic.h |  1 +
> >  lib/pci.h              |  1 +
> >  4 files changed, 73 insertions(+)
> > 
> > diff --git a/arm/pci-test.c b/arm/pci-test.c
> > index 8629c89..1539d3e 100644
> > --- a/arm/pci-test.c
> > +++ b/arm/pci-test.c
> > @@ -11,6 +11,7 @@
> >  int main(void)
> >  {
> >  	struct pci *pci;
> > +	int ret;
> >  
> >  	pci = pci_dt_probe();
> >  
> > @@ -18,6 +19,9 @@ int main(void)
> >  	if (!pci)
> >  		goto done;
> >  
> > +	ret = pci_bus_scan(pci);
> > +	report("PCI bus scanning detected %d devices", true, ret);
> 
> How many devices are expected in this test? You can pass the expected
> number in on the command line, and then make this a "real" test report
> with
> 
>   report(..., ret == atol(argv[0]), ret)

What if a machine's PCI hierarchy changed? Such test would break then.

Also, this report is not entirely dummy. It ensures PCI configuration
space access operates, devices do respond and generally the bus is fine.

> > +
> >  	pci_shutdown(pci);
> >  
> >  done:
> > diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> > index 62b5662..e479989 100644
> > --- a/lib/pci-host-generic.c
> > +++ b/lib/pci-host-generic.c
> > @@ -14,6 +14,49 @@
> >  #include "pci-host-generic.h"
> >  #include <linux/pci_regs.h>
> >  
> > +#define for_each_pci_dev(pci, dev, conf)		\
> > +	for (dev = find_next_dev(pci, -1, &conf);	\
> > +	     dev >= 0;					\
> > +	     dev = find_next_dev(pci, dev, &conf))
> 
> Why do we need to pass both a dev index and a conf
> pointer? I see below you can get the later from the
> former easily enough.

No particular reason apart from the fact each for_each_pci_dev()
would be followed by dev_conf() call - so I paired it to save
few lines. I have no preference here, though.

> > +
> > +static u8 pci_config_readb(const void *conf, int off)
> > +{
> > +	return readb(conf + off);
> > +}
> > +
> > +static u32 pci_config_readl(const void *conf, int off)
> > +{
> > +	return readl(conf + off);
> > +}
> > +
> > +static void pci_config_writel(u32 val, void *conf, int off)
> > +{
> > +	writel(val, conf + off);
> > +}
> 
> These read/write wrappers don't look all that useful to me. They would
> be more useful if they took a 'struct pci[_dev] like Linux's
> pci_read_config_byte/word/dword do. In fact, stealing those from Linux
> makes sense.

I put those ones only to emphasize PCI reads/writes as opposed to
direct read*/write* accesses. Matching the Linux names is probably
confusing.

Bringing Linux-like pci_read_config_byte/word/dword seems as an
overkill to me as it entails pulling the whole data hierarchy
pci_host_bridge->pci_bus->pci_dev.

By contrast, if we do not pull the whole hierarchy then we could
introduce our own minimalistic data structure(s) and get off with
it easily.

> > +
> > +static void* dev_conf(struct pci *pci, int dev)
> > +{
> > +	struct pci_host_bridge *host = pci->sysdata;
> > +	return (void*)host->cpu_range.start + (dev * 8) * PCI_ECAM_CONFIG_SIZE;
> > +}
> > +
> > +/* We scan bus 0 only for now */
> > +static int find_next_dev(struct pci *pci, int dev, void **pconf)
> > +{
> > +	struct pci_host_bridge *host = pci->sysdata;
> > +	int limit = MIN(32u, host->cpu_range.size / PCI_ECAM_CONFIG_SIZE);
> 
> 32 is the pci max devices per bus limit, right? Assuming a sane DT, is it
> possible to have host->cpu_range.size/PCI_ECAM_CONFIG_SIZE > 32?

The point here is not host->cpu_range.size/PCI_ECAM_CONFIG_SIZE > 32
but rather host->cpu_range.size/PCI_ECAM_CONFIG_SIZE < 32.

But you are right - a bus with less than 32 device slots is likely
insane.

> > +
> > +	for (dev++; dev < limit; dev++) {
> > +		void *conf = dev_conf(pci, dev);
> > +		if (pci_config_readl(conf, PCI_VENDOR_ID) != ((u32)~0)) {
> > +			*pconf = conf;
> > +			return dev;
> > +		}
> > +	}
> > +
> > +	return -1;
> > +}
> > +
> >  static void pci_host_addr_space_init(struct pci_addr_space as[], int nr_as,
> >  				     u32 cells[], int nr_range_cells)
> >  {
> > @@ -133,6 +176,24 @@ static struct pci_host_bridge *pci_host_bridge_probe(void)
> >  	return host;
> >  }
> >  
> > +int pci_bus_scan(struct pci *pci)
> > +{
> > +	void *conf;
> > +	int dev;
> > +	int nr_dev = 0;
> > +
> > +	for_each_pci_dev(pci, dev, conf) {
> > +		/* We are only interested in normal PCI devices */
> > +		if (pci_config_readb(conf, PCI_HEADER_TYPE) !=
> > +					   PCI_HEADER_TYPE_NORMAL)
> > +			continue;
> > +		pci_config_writel(PCI_COMMAND_SERR, conf, PCI_COMMAND);
> 
> Shouldn't the driver (unit test) be the one that writes SERR? Also,
> doesn't this clear everything in the Command register except SERR?

I do not thing a driver is in charge. It is a minimal devices
initialization that is expected from firmware/BIOS AFAICT. A driver
should inherit the properly initialized bus with allocated io/memory
buffers to use.

> If a scan gets run again after driver/unittest has started using a device
> then this write may mess things up.

PCI bus scan is normally done once to initialize hierarchy. I am
struggling to imagine a usecase when it is called repeatedly,
especially in such a small framework.

> > +		nr_dev++;
> > +	}
> > +
> > +	return nr_dev;
> > +}
> > +
> >  struct pci *pci_dt_probe(void)
> >  {
> >  	struct pci_host_bridge *host;
> > @@ -150,6 +211,12 @@ struct pci *pci_dt_probe(void)
> >  
> >  void pci_shutdown(struct pci *pci)
> >  {
> > +	void *conf;
> > +	int dev;
> > +
> > +	for_each_pci_dev(pci, dev, conf)
> > +		pci_config_writel(PCI_COMMAND_INTX_DISABLE, conf, PCI_COMMAND);
> 
> I think I know why this is here, but I don't think that kvm-unit-tests
> needs to bother with it.

Well, it is not about interrupts, rather about disabling devices
access to access io/memory buffers, which is writing 0 to the
command regiester. PCI_COMMAND_INTX_DISABLE is just a good one
to write as well.

BTW, this is the reason I named this routine pci_shutdown(), not
pci_free().

> > +
> >  	free(pci->sysdata);
> >  	free(pci);
> >  }
> > diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> > index 097ac2d..c14d32d 100644
> > --- a/lib/pci-host-generic.h
> > +++ b/lib/pci-host-generic.h
> > @@ -22,5 +22,6 @@ struct pci_host_bridge {
> >  };
> >  
> >  #define PCI_ECAM_BUS_SIZE		(1 << 20)
> > +#define PCI_ECAM_CONFIG_SIZE		(1 << 12)
> 
> Are these also defined in the Linux kernel? I'm too lazy to pull up the
> PCI spec right now, so I'd rather confirm the sizes by looking them up
> in Linux. If they are defined there somewhere, then please use the same
> names here. Otherwise, I guess references to some documentation or
> something would be nice for pci dummies like me.
> 
> >  
> >  #endif
> > diff --git a/lib/pci.h b/lib/pci.h
> > index 22b8e31..bc4f2d2 100644
> > --- a/lib/pci.h
> > +++ b/lib/pci.h
> > @@ -8,6 +8,7 @@ struct pci {
> >  };
> >  
> >  extern struct pci *pci_dt_probe(void);
> > +extern int pci_bus_scan(struct pci *pci);
> >  extern void pci_shutdown(struct pci *pci);
> >  
> >  #endif
> > -- 
> > 1.8.3.1
> > 
