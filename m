From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Wed, 21 Mar 2018 06:43:35 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19108B0FE@SHSMSX101.ccr.corp.intel.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
	<20180214145340.1223-2-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180214145340.1223-2-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org" <virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
Cc: "jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "marc.zyngier-5wv7dgnIgG8@public.gmane.org" <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org" <jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, "eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

> From: Jean-Philippe Brucker [mailto:jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org]
> Sent: Wednesday, February 14, 2018 10:54 PM
> 
> The virtio IOMMU is a para-virtualized device, allowing to send IOMMU
> requests such as map/unmap over virtio-mmio transport without
> emulating
> page tables. This implementation handles ATTACH, DETACH, MAP and
> UNMAP
> requests.
> 
> The bulk of the code transforms calls coming from the IOMMU API into
> corresponding virtio requests. Mappings are kept in an interval tree
> instead of page tables.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>

[...]
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

this is ARM specific, and according to virtio-iommu spec isn't it
better probed on the endpoint instead of hard-coding here?

Thanks
Kevin
