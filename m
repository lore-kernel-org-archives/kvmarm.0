From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 4/7] PCI: OF: Initialize dev->fwnode appropriately
Date: Fri, 12 Oct 2018 14:44:01 -0500
Message-ID: <20181012194401.GY5906@bhelgaas-glaptop.roam.corp.google.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
	<20181012145917.6840-5-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181012145917.6840-5-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 12, 2018 at 03:59:14PM +0100, Jean-Philippe Brucker wrote:
> For PCI devices that have an OF node, set the fwnode as well. This way
> drivers that rely on fwnode don't need the special case described by
> commit f94277af03ea ("of/platform: Initialise dev->fwnode appropriately").
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>

Acked-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/pci/of.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> index 2f5015bdb256..8026417fab38 100644
> --- a/drivers/pci/of.c
> +++ b/drivers/pci/of.c
> @@ -21,12 +21,15 @@ void pci_set_of_node(struct pci_dev *dev)
>  		return;
>  	dev->dev.of_node = of_pci_find_child_device(dev->bus->dev.of_node,
>  						    dev->devfn);
> +	if (dev->dev.of_node)
> +		dev->dev.fwnode = &dev->dev.of_node->fwnode;
>  }
>  
>  void pci_release_of_node(struct pci_dev *dev)
>  {
>  	of_node_put(dev->dev.of_node);
>  	dev->dev.of_node = NULL;
> +	dev->dev.fwnode = NULL;
>  }
>  
>  void pci_set_bus_of_node(struct pci_bus *bus)
> @@ -35,12 +38,16 @@ void pci_set_bus_of_node(struct pci_bus *bus)
>  		bus->dev.of_node = pcibios_get_phb_of_node(bus);
>  	else
>  		bus->dev.of_node = of_node_get(bus->self->dev.of_node);
> +
> +	if (bus->dev.of_node)
> +		bus->dev.fwnode = &bus->dev.of_node->fwnode;
>  }
>  
>  void pci_release_bus_of_node(struct pci_bus *bus)
>  {
>  	of_node_put(bus->dev.of_node);
>  	bus->dev.of_node = NULL;
> +	bus->dev.fwnode = NULL;
>  }
>  
>  struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
> -- 
> 2.19.1
> 
