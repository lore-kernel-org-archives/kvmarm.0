From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v12 1/9] linux-headers: update VFIO header
 for VFIO platform/amba drivers
Date: Thu, 16 Apr 2015 16:03:54 -0600
Message-ID: <1429221834.10086.36.camel@redhat.com>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
	<1426785402-2091-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1426785402-2091-2-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>
Cc: b.reynal@virtualopensystems.com, peter.maydell@linaro.org, kim.phillips@freescale.com, eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, a.rigo@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-03-19 at 17:16 +0000, Eric Auger wrote:
> Update according to the vfio.h header found in
> ssh://git@git.linaro.org/people/eric.auger/linux.git
> branch 4.0-rc3-v14

A Sign-off is still needed here.

> ---
> 
> v10 -> v11:
> - only includes header modifications related to vfio platform
>   driver v14 and not those related to
>   "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1"
> ---
>  linux-headers/linux/vfio.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
> index 95ba870..b57b750 100644
> --- a/linux-headers/linux/vfio.h
> +++ b/linux-headers/linux/vfio.h
> @@ -8,8 +8,8 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> -#ifndef VFIO_H
> -#define VFIO_H
> +#ifndef _UAPIVFIO_H
> +#define _UAPIVFIO_H
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> @@ -160,6 +160,8 @@ struct vfio_device_info {
>  	__u32	flags;
>  #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
>  #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
> +#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
> +#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  };
> @@ -495,4 +497,4 @@ struct vfio_eeh_pe_op {
>  
>  /* ***************************************************************** */
>  
> -#endif /* VFIO_H */
> +#endif /* _UAPIVFIO_H */
