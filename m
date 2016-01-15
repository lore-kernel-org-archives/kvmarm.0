From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 09/11] arm/pci: PCI host bridge info
 printing
Date: Fri, 15 Jan 2016 16:35:59 +0100
Message-ID: <20160115153559.GO3915@hawk.localdomain>
References: <cover.1452341807.git.agordeev@redhat.com>
 <c82448afa4642ddb782990d75d0ff14eaff8e804.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F5949A12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:31:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gjyloXd3Kt7b for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:31:49 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABE9C49A11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:31:49 -0500 (EST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
 (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
 by mx1.redhat.com (Postfix) with ESMTPS id 655F3552E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 15:36:03 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <c82448afa4642ddb782990d75d0ff14eaff8e804.1452341807.git.agordeev@redhat.com>
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

On Sat, Jan 09, 2016 at 01:22:56PM +0100, Alexander Gordeev wrote:
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  lib/pci-host-generic.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> index 3d9c271..2d218a4 100644
> --- a/lib/pci-host-generic.c
> +++ b/lib/pci-host-generic.c
> @@ -19,6 +19,15 @@
>  	     dev >= 0;					\
>  	     dev = find_next_dev(pci, dev, &conf))
>  
> +static char *addr_space_desc[] = {
> +	[PCI_RES_TYPE_CONF]		= "CONF",
> +	[PCI_RES_TYPE_IO]		= "IO",
> +	[PCI_RES_TYPE_MEM32]		= "MEM32",
> +	[PCI_RES_TYPE_MEM64]		= "MEM64",
> +	[PCI_RES_TYPE_PREFMEM32]	= "MEM32/p",
> +	[PCI_RES_TYPE_PREFMEM64]	= "MEM64/p"
> +};
> +
>  static pci_res_type_t flags_to_type(u32 of_flags)
>  {
>  	return ((of_flags & 0x40000000) >> 28) | ((of_flags >> 24) & 0x03);
> @@ -105,6 +114,28 @@ static void pci_host_addr_space_init(struct pci_addr_space as[], int nr_as,
>  	}
>  }
>  
> +static void pci_host_bridge_print(struct pci_host_bridge *host)
> +{
> +	printf("PCIe start %016llx size %016llx "
> +	       "bus %02x bus_max %02x #spaces %d\n\n",
> +		host->cpu_range.start, host->cpu_range.size,
> +		host->bus, host->bus_max, host->nr_addr_spaces);
> +}
> +
> +static void pci_address_spaces_print(struct pci_addr_space as[], int nr_as)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_as; i++, as++) {
> +		printf("%s address space:\n"
> +		       "CPU: start %016llx size %016llx\n"
> +		       "PCI: start %016llx size %016llx\n\n",
> +			addr_space_desc[flags_to_type(as->of_flags)],
> +			as->cpu_range.start, as->cpu_range.size,
> +		        as->pci_range.start, as->pci_range.size);
> +	}
> +}
> +
>  /*
>   * Probe DT for a generic PCI host controller
>   * See kernel Documentation/devicetree/bindings/pci/host-generic-pci.txt
> @@ -180,9 +211,13 @@ static struct pci_host_bridge *pci_host_bridge_probe(void)
>  	host->bus_max		= bus_max;
>  	host->nr_addr_spaces	= nr_addr_spaces;
>  
> +	pci_host_bridge_print(host);
> +
>  	pci_host_addr_space_init(&host->addr_space[0], nr_addr_spaces,
>  				 (u32*)prop->data, nr_range_cells);
>  
> +	pci_address_spaces_print(&host->addr_space[0], host->nr_addr_spaces);
> +
>  	return host;
>  }

Looks good

drew
