From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/5] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Tue, 03 Mar 2015 18:46:38 +0100
Message-ID: <54F5F37E.2070002@linaro.org>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425315507-29661-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
Cc: tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Baptiste,

In "vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag" you still
kept domain->caps |= IOMMU_CAP_NOEXEC so potentially overwriting 1<<
IOMMU_CAP_CACHE_COHERENCY I guess.

Sorry I do not have this 4th patch file in my mailbox.

Best Regards

Eric

	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
		domain->caps |= (1 << IOMMU_CAP_CACHE_COHERENCY);

	if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
		domain->caps |= IOMMU_CAP_NOEXEC;

On 03/02/2015 05:58 PM, Baptiste Reynal wrote:
> This patch series makes the VFIO_IOMMU_TYPE1 driver buildable on ARM, so it
> may be used with ARM SMMUs. It also adds support for the IOMMU_NOEXEC flag
> supported by SMMUs adhering to the ARM SMMU specification so the VFIO user can
> specify whether the target memory can be executed by the device behind the
> SMMU.
> 
> Changes from v3:
>  - Rebased on linux v4.0-rc1
>  - Use bit shifting for domain->caps
>  - Baptiste Reynal is the new maintainer of this serie
> Changes from v2:
>  - Rebased on latest iommu/next branch by Joerg Roedel
> Changes from v1:
>  - Bugfixes and corrected some typos
>  - Use enum for VFIO IOMMU driver capabilities
> 
> Antonios Motakis (5):
>   vfio: implement iommu driver capabilities with an enum
>   vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
>   vfio: type1: replace domain wide protection flags with supported
>     capabilities
>   vfio: type1: replace vfio_domains_have_iommu_cache with generic
>     function
>   vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
> 
>  drivers/vfio/vfio_iommu_type1.c | 91 +++++++++++++++++++++++++++++------------
>  include/uapi/linux/vfio.h       | 30 ++++++++------
>  2 files changed, 81 insertions(+), 40 deletions(-)
> 
