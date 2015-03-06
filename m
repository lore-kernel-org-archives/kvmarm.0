From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Fri, 06 Mar 2015 10:04:22 +0100
Message-ID: <54F96D96.8040207@linaro.org>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>	
	<1425491104.5200.268.camel@redhat.com>
	<54F893C3.6020006@linaro.org>
	<1425589915.5200.336.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425589915.5200.336.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/2015 10:11 PM, Alex Williamson wrote:
> On Thu, 2015-03-05 at 18:34 +0100, Eric Auger wrote:
>> Hi All,
>>
>> Ironically, since the correction of the IOMMU_CAP_CACHE_COHERENCY bug
>> (https://lkml.org/lkml/2015/1/29/514) in vfio_iommu_type1.c, my Calxeda
>> Midway VFIO use case is not working anymore. This is also observable
>> when I do not apply at all the whole [PATCH v5 0/4] vfio: type1: support
>> for ARM SMMUS with VFIO_IOMMU_TYPE1 series.
>>
>> My understanding is this series should not be requested for me since my
>> xgmac device does not care about the XN attribute.
> 
> This also raises the concern that we're continuing to put optional
> features as prerequisites to base vfio-platform support and creating
> self-induced stalls at getting anything upstream :-\  Thanks,
Dear all,

Thanks Alex, Will for your inputs on this topic.

Yes to me "vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1" is
not a direct dependency of vfio-platform driver although I understand
Baptiste needs it to test with PL330 device. On my side I can test
vfio-platform driver without it, assigning the Midway Calxeda xgmac.

Also if I am not wrong the title of the series now does not really
reflect anymore what the series aims at. since "[PATCH v3 2/6] vfio:
type1: support for ARM SMMUs"  withdrawal, the series now "only" aims at
supporting the VFIO_DMA_MAP_FLAG_NOEXEC flag.

However with this issue of IOMMU_CACHE always set along with arm-smmu,
there is a need for an adaptation of either vfio_iommu_type1 or arm-smmu
since the integrated pieces are not functional.

On top of the dma-coherent property of the *master*, should not we also
query the cache-coherent property of the interconnect downstream to the
smmu?

How can we progress quickly on this topic? is it acceptable to return
false on arm_smmu_capable(IOMMU_CAP_CACHE_COHERENCY) as a quick hack? As
a longer term solution, would it make sense to add a user flag at VFIO
user API level to turn the IOMMU_CACHE on?

Best Regards

Eric


Best Regards

Eric

Best Regards

Eric
> 
> Alex
> 
