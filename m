From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: Re: [PATCH v14 19/20] vfio: initialize the virqfd workqueue in VFIO
	generic code
Date: Wed, 18 Mar 2015 14:39:06 +0100
Message-ID: <CAN9JPjHt1W09PyiM6OUWjJs+NqW44vOyXqaq+QH7rE1cv1LvKQ@mail.gmail.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
	<1425315600-29761-20-git-send-email-b.reynal@virtualopensystems.com>
	<1426631368.3643.348.camel@redhat.com>
	<1426633482.3643.354.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1426633482.3643.354.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux IOMMU <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, VirtualOpenSystems Technical Team <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, kvm-arm <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hello Alex,

The module solution seems fine for me, I have no argument against it.
I used your patch on my tests, they are running ok.

Regards,
Baptiste

On Wed, Mar 18, 2015 at 12:04 AM, Alex Williamson
<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2015-03-17 at 16:29 -0600, Alex Williamson wrote:
>> On Mon, 2015-03-02 at 17:59 +0100, Baptiste Reynal wrote:
>> > From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
>> >
>> > Now we have finally completely decoupled virqfd from VFIO_PCI. We can
>> > initialize it from the VFIO generic code, in order to safely use it from
>> > multiple independent VFIO bus drivers.
>> >
>> > Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
>> > Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
>> > ---
>> >  drivers/vfio/Makefile       | 4 +++-
>> >  drivers/vfio/pci/Makefile   | 3 +--
>> >  drivers/vfio/pci/vfio_pci.c | 8 --------
>> >  drivers/vfio/vfio.c         | 8 ++++++++
>> >  4 files changed, 12 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> > index dadf0ca..d798b09 100644
>> > --- a/drivers/vfio/Makefile
>> > +++ b/drivers/vfio/Makefile
>> > @@ -1,4 +1,6 @@
>> > -obj-$(CONFIG_VFIO) += vfio.o
>> > +vfio_core-y := vfio.o virqfd.o
>> > +
>> > +obj-$(CONFIG_VFIO) += vfio_core.o
>> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> >  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
>>
>> This inadvertently (I assume) renames the main vfio module to vfio_core.
>> That potentially breaks numerous userspace scripts that might try to
>> load the "vfio" module.  I don't think that's acceptable.  A brute force
>> way to fix this would be to rename vfio.c to vfio_core.c and change the
>> Makefile to:
>>
>> vfio-y := vfio_core.o virqfd.o
>> obj-$(CONFIG_VFIO) += vfio.o
>>
>> Is there any other trickery available to us that could include virqfd.o
>> in vfio.o w/o source file renaming?  Thanks,
>
> Maybe a better option, we could let virqfd be it's own support module
> for bus drivers that need it.  Then we keep it out of vfio "core".
> Something like this:
>
> commit f4d91ec4b72ce11e9dba861d6bf2dba93b72f0ba
> Author: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Tue Mar 17 08:33:38 2015 -0600
>
>     vfio: Split virqfd into a separate module for vfio bus drivers
>
>     An unintended consequence of splittng virqfd support to be shared
>     by bus drivers is renaming the core vfio module to vfio_core.  This
>     is not very friendly to user scripts that may try to load the vfio
>     module.  To resolve that and to make it clear that virqfd is a bus
>     driver service and not a dependency of vfio core, move this to a
>     separate module on which the bus drivers will depend.
>
>     Signed-off-by: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index d5322a4..7d092dd 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -13,6 +13,11 @@ config VFIO_SPAPR_EEH
>         depends on EEH && VFIO_IOMMU_SPAPR_TCE
>         default n
>
> +config VFIO_VIRQFD
> +       tristate
> +       depends on VFIO && EVENTFD
> +       default n
> +
>  menuconfig VFIO
>         tristate "VFIO Non-Privileged userspace driver framework"
>         depends on IOMMU_API
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index d798b09..7b8a31f 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,6 +1,7 @@
> -vfio_core-y := vfio.o virqfd.o
> +vfio_virqfd-y := virqfd.o
>
> -obj-$(CONFIG_VFIO) += vfio_core.o
> +obj-$(CONFIG_VFIO) += vfio.o
> +obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index c6bb5da..579d83b 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,6 +1,7 @@
>  config VFIO_PCI
>         tristate "VFIO support for PCI devices"
>         depends on VFIO && PCI && EVENTFD
> +       select VFIO_VIRQFD
>         help
>           Support for the PCI VFIO bus driver.  This is required to make
>           use of PCI drivers using the VFIO framework.
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index c0a3bff..4ec14af 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,6 +1,7 @@
>  config VFIO_PLATFORM
>         tristate "VFIO support for platform devices"
>         depends on VFIO && EVENTFD && ARM
> +       select VFIO_VIRQFD
>         help
>           Support for platform devices with VFIO. This is required to make
>           use of platform devices present on the system using the VFIO
> @@ -11,6 +12,7 @@ config VFIO_PLATFORM
>  config VFIO_AMBA
>         tristate "VFIO support for AMBA devices"
>         depends on VFIO_PLATFORM && ARM_AMBA
> +       select VFIO_VIRQFD
>         help
>           Support for ARM AMBA devices with VFIO. This is required to make
>           use of ARM AMBA devices present on the system using the VFIO
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 86aac7e..0d33662 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1552,11 +1552,6 @@ static int __init vfio_init(void)
>         if (ret)
>                 goto err_cdev_add;
>
> -       /* Start the virqfd cleanup handler used by some VFIO bus drivers */
> -       ret = vfio_virqfd_init();
> -       if (ret)
> -               goto err_virqfd;
> -
>         pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>
>         /*
> @@ -1569,8 +1564,6 @@ static int __init vfio_init(void)
>
>         return 0;
>
> -err_virqfd:
> -       cdev_del(&vfio.group_cdev);
>  err_cdev_add:
>         unregister_chrdev_region(vfio.group_devt, MINORMASK);
>  err_alloc_chrdev:
> @@ -1585,7 +1578,6 @@ static void __exit vfio_cleanup(void)
>  {
>         WARN_ON(!list_empty(&vfio.group_list));
>
> -       vfio_virqfd_exit();
>         idr_destroy(&vfio.group_idr);
>         cdev_del(&vfio.group_cdev);
>         unregister_chrdev_region(vfio.group_devt, MINORMASK);
> diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
> index 3d19aaf..ede0ca1 100644
> --- a/drivers/vfio/virqfd.c
> +++ b/drivers/vfio/virqfd.c
> @@ -13,12 +13,17 @@
>  #include <linux/vfio.h>
>  #include <linux/eventfd.h>
>  #include <linux/file.h>
> +#include <linux/module.h>
>  #include <linux/slab.h>
>
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"
> +#define DRIVER_DESC     "VFIO virqfd"
> +
>  static struct workqueue_struct *vfio_irqfd_cleanup_wq;
>  static DEFINE_SPINLOCK(virqfd_lock);
>
> -int __init vfio_virqfd_init(void)
> +static int __init vfio_virqfd_init(void)
>  {
>         vfio_irqfd_cleanup_wq =
>                 create_singlethread_workqueue("vfio-irqfd-cleanup");
> @@ -28,7 +33,7 @@ int __init vfio_virqfd_init(void)
>         return 0;
>  }
>
> -void vfio_virqfd_exit(void)
> +static void __exit vfio_virqfd_exit(void)
>  {
>         destroy_workqueue(vfio_irqfd_cleanup_wq);
>  }
> @@ -211,3 +216,11 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
>         flush_workqueue(vfio_irqfd_cleanup_wq);
>  }
>  EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
> +
> +module_init(vfio_virqfd_init);
> +module_exit(vfio_virqfd_exit);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 683b514..cbed15f 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -142,8 +142,6 @@ struct virqfd {
>         struct virqfd           **pvirqfd;
>  };
>
> -extern int vfio_virqfd_init(void);
> -extern void vfio_virqfd_exit(void);
>  extern int vfio_virqfd_enable(void *opaque,
>                               int (*handler)(void *, void *),
>                               void (*thread)(void *, void *),
>
>
