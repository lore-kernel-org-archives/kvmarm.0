From: Tomasz Nowicki <tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Mon, 19 Feb 2018 13:23:55 +0100
Message-ID: <417e1617-e5ff-7b13-64e3-a8a98d30bcb9@semihalf.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
	<20180214145340.1223-2-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180214145340.1223-2-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
Cc: jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,

On 14.02.2018 15:53, Jean-Philippe Brucker wrote:
> The virtio IOMMU is a para-virtualized device, allowing to send IOMMU
> requests such as map/unmap over virtio-mmio transport without emulating
> page tables. This implementation handles ATTACH, DETACH, MAP and UNMAP
> requests.
> 
> The bulk of the code transforms calls coming from the IOMMU API into
> corresponding virtio requests. Mappings are kept in an interval tree
> instead of page tables.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
> ---
>   MAINTAINERS                       |   6 +
>   drivers/iommu/Kconfig             |  11 +
>   drivers/iommu/Makefile            |   1 +
>   drivers/iommu/virtio-iommu.c      | 960 ++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/virtio_ids.h   |   1 +
>   include/uapi/linux/virtio_iommu.h | 116 +++++
>   6 files changed, 1095 insertions(+)
>   create mode 100644 drivers/iommu/virtio-iommu.c
>   create mode 100644 include/uapi/linux/virtio_iommu.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3bdc260e36b7..2a181924d420 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14818,6 +14818,12 @@ S:	Maintained
>   F:	drivers/virtio/virtio_input.c
>   F:	include/uapi/linux/virtio_input.h
>   
> +VIRTIO IOMMU DRIVER
> +M:	Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
> +S:	Maintained
> +F:	drivers/iommu/virtio-iommu.c
> +F:	include/uapi/linux/virtio_iommu.h
> +
>   VIRTUAL BOX GUEST DEVICE DRIVER
>   M:	Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>   M:	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index f3a21343e636..1ea0ec74524f 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -381,4 +381,15 @@ config QCOM_IOMMU
>   	help
>   	  Support for IOMMU on certain Qualcomm SoCs.
>   
> +config VIRTIO_IOMMU
> +	bool "Virtio IOMMU driver"
> +	depends on VIRTIO_MMIO
> +	select IOMMU_API
> +	select INTERVAL_TREE
> +	select ARM_DMA_USE_IOMMU if ARM
> +	help
> +	  Para-virtualised IOMMU driver with virtio.
> +
> +	  Say Y here if you intend to run this kernel as a guest.
> +
>   endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 1fb695854809..9c68be1365e1 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
>   obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
>   obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
>   obj-$(CONFIG_QCOM_IOMMU) += qcom_iommu.o
> +obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> new file mode 100644
> index 000000000000..a9c9245e8ba2
> --- /dev/null
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -0,0 +1,960 @@
> +/*
> + * Virtio driver for the paravirtualized IOMMU
> + *
> + * Copyright (C) 2018 ARM Limited
> + * Author: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
> + *
> + * SPDX-License-Identifier: GPL-2.0
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/amba/bus.h>
> +#include <linux/delay.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/freezer.h>
> +#include <linux/interval_tree.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/of_iommu.h>
> +#include <linux/of_platform.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/wait.h>
> +
> +#include <uapi/linux/virtio_iommu.h>
> +
> +#define MSI_IOVA_BASE			0x8000000
> +#define MSI_IOVA_LENGTH			0x100000
> +
> +struct viommu_dev {
> +	struct iommu_device		iommu;
> +	struct device			*dev;
> +	struct virtio_device		*vdev;
> +
> +	struct ida			domain_ids;
> +
> +	struct virtqueue		*vq;
> +	/* Serialize anything touching the request queue */
> +	spinlock_t			request_lock;
> +
> +	/* Device configuration */
> +	struct iommu_domain_geometry	geometry;
> +	u64				pgsize_bitmap;
> +	u8				domain_bits;
> +};
> +
> +struct viommu_mapping {
> +	phys_addr_t			paddr;
> +	struct interval_tree_node	iova;
> +	union {
> +		struct virtio_iommu_req_map map;
> +		struct virtio_iommu_req_unmap unmap;
> +	} req;
> +};
> +
> +struct viommu_domain {
> +	struct iommu_domain		domain;
> +	struct viommu_dev		*viommu;
> +	struct mutex			mutex;
> +	unsigned int			id;
> +
> +	spinlock_t			mappings_lock;
> +	struct rb_root_cached		mappings;
> +
> +	/* Number of endpoints attached to this domain */
> +	unsigned long			endpoints;
> +};
> +
> +struct viommu_endpoint {
> +	struct viommu_dev		*viommu;
> +	struct viommu_domain		*vdomain;
> +};
> +
> +struct viommu_request {
> +	struct scatterlist		top;
> +	struct scatterlist		bottom;
> +
> +	int				written;
> +	struct list_head		list;
> +};
> +
> +#define to_viommu_domain(domain)	\
> +	container_of(domain, struct viommu_domain, domain)
> +
> +/* Virtio transport */
> +
> +static int viommu_status_to_errno(u8 status)
> +{
> +	switch (status) {
> +	case VIRTIO_IOMMU_S_OK:
> +		return 0;
> +	case VIRTIO_IOMMU_S_UNSUPP:
> +		return -ENOSYS;
> +	case VIRTIO_IOMMU_S_INVAL:
> +		return -EINVAL;
> +	case VIRTIO_IOMMU_S_RANGE:
> +		return -ERANGE;
> +	case VIRTIO_IOMMU_S_NOENT:
> +		return -ENOENT;
> +	case VIRTIO_IOMMU_S_FAULT:
> +		return -EFAULT;
> +	case VIRTIO_IOMMU_S_IOERR:
> +	case VIRTIO_IOMMU_S_DEVERR:
> +	default:
> +		return -EIO;
> +	}
> +}
> +
> +/*
> + * viommu_get_req_size - compute request size
> + *
> + * A virtio-iommu request is split into one device-read-only part (top) and one
> + * device-write-only part (bottom). Given a request, return the sizes of the two
> + * parts in @top and @bottom.
> + *
> + * Return 0 on success, or an error when the request seems invalid.
> + */
> +static int viommu_get_req_size(struct viommu_dev *viommu,
> +			       struct virtio_iommu_req_head *req, size_t *top,
> +			       size_t *bottom)
> +{
> +	size_t size;
> +	union virtio_iommu_req *r = (void *)req;
> +
> +	*bottom = sizeof(struct virtio_iommu_req_tail);
> +
> +	switch (req->type) {
> +	case VIRTIO_IOMMU_T_ATTACH:
> +		size = sizeof(r->attach);
> +		break;
> +	case VIRTIO_IOMMU_T_DETACH:
> +		size = sizeof(r->detach);
> +		break;
> +	case VIRTIO_IOMMU_T_MAP:
> +		size = sizeof(r->map);
> +		break;
> +	case VIRTIO_IOMMU_T_UNMAP:
> +		size = sizeof(r->unmap);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	*top = size - *bottom;
> +	return 0;
> +}
> +
> +static int viommu_receive_resp(struct viommu_dev *viommu, int nr_sent,
> +			       struct list_head *sent)
> +{
> +
> +	unsigned int len;
> +	int nr_received = 0;
> +	struct viommu_request *req, *pending;
> +
> +	pending = list_first_entry_or_null(sent, struct viommu_request, list);
> +	if (WARN_ON(!pending))
> +		return 0;
> +
> +	while ((req = virtqueue_get_buf(viommu->vq, &len)) != NULL) {
> +		if (req != pending) {
> +			dev_warn(viommu->dev, "discarding stale request\n");
> +			continue;
> +		}
> +
> +		pending->written = len;
> +
> +		if (++nr_received == nr_sent) {
> +			WARN_ON(!list_is_last(&pending->list, sent));
> +			break;
> +		} else if (WARN_ON(list_is_last(&pending->list, sent))) {
> +			break;
> +		}
> +
> +		pending = list_next_entry(pending, list);

We should remove current element from the pending list. There is no 
guarantee we get response for each while loop so when we get back for 
more the _viommu_send_reqs_sync() caller will pass pointer to the out of 
date head next time.

> +	}
> +
> +	return nr_received;
> +}
> +
> +static int _viommu_send_reqs_sync(struct viommu_dev *viommu,
> +				  struct viommu_request *req, int nr,
> +				  int *nr_sent)
> +{
> +	int i, ret;
> +	ktime_t timeout;
> +	LIST_HEAD(pending);
> +	int nr_received = 0;
> +	struct scatterlist *sg[2];
> +	/*
> +	 * The timeout is chosen arbitrarily. It's only here to prevent locking
> +	 * up the CPU in case of a device bug.
> +	 */
> +	unsigned long timeout_ms = 1000;
> +
> +	*nr_sent = 0;
> +
> +	for (i = 0; i < nr; i++, req++) {
> +		req->written = 0;
> +
> +		sg[0] = &req->top;
> +		sg[1] = &req->bottom;
> +
> +		ret = virtqueue_add_sgs(viommu->vq, sg, 1, 1, req,
> +					GFP_ATOMIC);
> +		if (ret)
> +			break;
> +
> +		list_add_tail(&req->list, &pending);
> +	}
> +
> +	if (i && !virtqueue_kick(viommu->vq))
> +		return -EPIPE;
> +
> +	timeout = ktime_add_ms(ktime_get(), timeout_ms * i);
> +	while (nr_received < i && ktime_before(ktime_get(), timeout)) {
> +		nr_received += viommu_receive_resp(viommu, i - nr_received,
> +						   &pending);
> +		if (nr_received < i)
> +			cpu_relax();
> +	}
> +
> +	if (nr_received != i)
> +		ret = -ETIMEDOUT;
> +
> +	if (ret == -ENOSPC && nr_received)
> +		/*
> +		 * We've freed some space since virtio told us that the ring is
> +		 * full, tell the caller to come back for more.
> +		 */
> +		ret = -EAGAIN;
> +
> +	*nr_sent = nr_received;
> +
> +	return ret;
> +}

Thanks,
Tomasz
