From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 05/11] arm/pci: Add pci_find_dev() and
 pci_bar_addr() functions
Date: Fri, 15 Jan 2016 16:17:33 +0100
Message-ID: <20160115151733.GJ3915@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <306d836398fe72935b25068bb9df58f1fa8deec4.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E000049A34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:13:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJkaCU3MOr7O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:13:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42EBC49A11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:13:24 -0500 (EST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
 (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
 by mx1.redhat.com (Postfix) with ESMTPS id 841BF3BF55D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 15:17:37 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <306d836398fe72935b25068bb9df58f1fa8deec4.1452341807.git.agordeev@redhat.com>
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

On Sat, Jan 09, 2016 at 01:22:52PM +0100, Alexander Gordeev wrote:
> This updat is a reminiscence of x86 implementation - to
> provision a possible future common PCI interface.

This comment inspired me to refactor the x86 code into common code.
I'll post that series in a few minutes for you to review. If x86
people are OK with it, then I think we should rebase your series on
it. I'm particular interested in learning if the last two patches
of this series can be greatly simplified by pretty much just
implementing the DT pcie-host-bridge discovery and a
lib/arm/asm/pci.h:pci_config_read() function.

> 
> Make pcidevaddr_t as int, not u16. There is no good reason
> to limit it to u16 while omitting properly adjusted bit fields.

pcidevaddr_t is OK as a u16, afaict it's just a device index
for a single bus (bus=0). So it has a max of 256. You could
redefine it to include the bus number too, but I'm not sure it's
necessary for simple kvm-unit-tests.

> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  lib/pci-host-generic.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  lib/pci.h              | 18 +++++++++++++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> index f3161f8..3d9c271 100644
> --- a/lib/pci-host-generic.c
> +++ b/lib/pci-host-generic.c
> @@ -29,6 +29,11 @@ static u8 pci_config_readb(const void *conf, int off)
>  	return readb(conf + off);
>  }
>  
> +static u16 pci_config_readw(const void *conf, int off)
> +{
> +	return readw(conf + off);
> +}
> +
>  static u32 pci_config_readl(const void *conf, int off)
>  {
>  	return readl(conf + off);
> @@ -351,6 +356,55 @@ int pci_bus_scan(struct pci *pci)
>  	return nr_dev;
>  }
>  
> +static pcidevaddr_t encode_addr(int bus, int dev, int fn)
> +{
> +	assert(bus < 256 && dev < 32 && fn < 8);
> +	return bus << 16 | dev << 11 | fn;
> +}
> +
> +static void decode_addr(pcidevaddr_t bdf, int *bus, int *dev, int *fn)
> +{
> +	*bus = (bdf >> 16) & 0xff;
> +	*dev = (bdf >> 11) & 0x1f;
> +	*fn  = (bdf >>  8) & 0x03;
> +}
> +
> +pcidevaddr_t pci_find_dev(struct pci *pci, u16 vendor_id, u16 device_id)
> +{
> +	void *conf;
> +	int dev;
> +
> +	for_each_pci_dev(pci, dev, conf) {
> +		if (vendor_id == pci_config_readw(conf, PCI_VENDOR_ID) &&
> +		    device_id == pci_config_readw(conf, PCI_DEVICE_ID))
> +			return encode_addr(0, dev, 0);
> +	}
> +
> +	return PCIDEVADDR_INVALID;
> +}
> +
> +phys_addr_t pci_bar_addr(struct pci *pci, pcidevaddr_t bdf, int bar)
> +{
> +	void *conf;
> +	struct pci_addr_space *res;
> +	pci_res_type_t type;
> +	phys_addr_t addr;
> +	bool is64;
> +	int bus, dev, fn;
> +
> +	decode_addr(bdf, &bus, &dev, &fn);
> +	assert(!bus && !fn);	/* We support bus 0 and function 0 only */
> +
> +	conf = dev_conf(pci, dev);
> +	assert(pci_config_readb(conf, PCI_HEADER_TYPE) ==
> +				      PCI_HEADER_TYPE_NORMAL);
> +
> +	assert(pci_get_bar(conf, bar, &type, &addr, NULL, &is64));
> +	assert(res = pci_find_res(pci->sysdata, type));
> +
> +	return res->cpu_range.start + (addr - res->pci_range.start);
> +}
> +
>  struct pci *pci_dt_probe(void)
>  {
>  	struct pci_host_bridge *host;
> diff --git a/lib/pci.h b/lib/pci.h
> index bc4f2d2..7d9baad 100644
> --- a/lib/pci.h
> +++ b/lib/pci.h
> @@ -7,8 +7,26 @@ struct pci {
>  	void *sysdata;
>  };
>  
> +/*
> + * Make it a reminiscence of x86 implementation - to provision a possible
> + * future merge.
> + *
> + * Unlike x86, PCIDEVADDR_INVALID is -1, not 0. PCI bus-device-function
> + * of 00.00:0 is a legitimate PCI address, so x86 needs a fix.

x86 gets away with this because the pci-testdev is never at addr 00.0,
that's where its host bridge is. I agree that it would be cleaner to use
an invalid dev-addr (unsigned > 255) for "INVALID" though. How about 0xffff?

> + *
> + * Also, make pcidevaddr_t int, not u16. There is no good reason to limit
> + * it to u16 while omitting properly adjusted bit fields.
> + *
> + */
> +typedef enum {
> +	PCIDEVADDR_INVALID = -1
> +} pcidevaddr_t;
> +
>  extern struct pci *pci_dt_probe(void);
>  extern int pci_bus_scan(struct pci *pci);
>  extern void pci_shutdown(struct pci *pci);
>  
> +extern pcidevaddr_t pci_find_dev(struct pci *pci, u16 vendor_id, u16 device_id);
> +extern phys_addr_t pci_bar_addr(struct pci *pci, pcidevaddr_t bdf, int bar_nr);
> +
>  #endif
> -- 
> 1.8.3.1
> 
