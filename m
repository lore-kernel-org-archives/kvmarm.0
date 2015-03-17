From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v14 19/20] vfio: initialize the virqfd workqueue in VFIO
 generic code
Date: Tue, 17 Mar 2015 16:29:28 -0600
Message-ID: <1426631368.3643.348.camel@redhat.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
	 <1425315600-29761-20-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1425315600-29761-20-git-send-email-b.reynal@virtualopensystems.com>
Sender: kvm-owner@vger.kernel.org
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu, tech@virtualopensystems.com, Antonios Motakis <a.motakis@virtualopensystems.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alexey Kardashevskiy <aik@ozlabs.ru>, Wei Yang <weiyang@linux.vnet.ibm.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 2015-03-02 at 17:59 +0100, Baptiste Reynal wrote:
> From: Antonios Motakis <a.motakis@virtualopensystems.com>
> 
> Now we have finally completely decoupled virqfd from VFIO_PCI. We can
> initialize it from the VFIO generic code, in order to safely use it from
> multiple independent VFIO bus drivers.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> ---
>  drivers/vfio/Makefile       | 4 +++-
>  drivers/vfio/pci/Makefile   | 3 +--
>  drivers/vfio/pci/vfio_pci.c | 8 --------
>  drivers/vfio/vfio.c         | 8 ++++++++
>  4 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index dadf0ca..d798b09 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,4 +1,6 @@
> -obj-$(CONFIG_VFIO) += vfio.o
> +vfio_core-y := vfio.o virqfd.o
> +
> +obj-$(CONFIG_VFIO) += vfio_core.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o

This inadvertently (I assume) renames the main vfio module to vfio_core.
That potentially breaks numerous userspace scripts that might try to
load the "vfio" module.  I don't think that's acceptable.  A brute force
way to fix this would be to rename vfio.c to vfio_core.c and change the
Makefile to:

vfio-y := vfio_core.o virqfd.o
obj-$(CONFIG_VFIO) += vfio.o

Is there any other trickery available to us that could include virqfd.o
in vfio.o w/o source file renaming?  Thanks,

Alex

