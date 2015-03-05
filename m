From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Thu, 05 Mar 2015 14:11:55 -0700
Message-ID: <1425589915.5200.336.camel@redhat.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
	<1425491104.5200.268.camel@redhat.com> <54F893C3.6020006@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <54F893C3.6020006-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-03-05 at 18:34 +0100, Eric Auger wrote:
> Hi All,
> 
> Ironically, since the correction of the IOMMU_CAP_CACHE_COHERENCY bug
> (https://lkml.org/lkml/2015/1/29/514) in vfio_iommu_type1.c, my Calxeda
> Midway VFIO use case is not working anymore. This is also observable
> when I do not apply at all the whole [PATCH v5 0/4] vfio: type1: support
> for ARM SMMUS with VFIO_IOMMU_TYPE1 series.
> 
> My understanding is this series should not be requested for me since my
> xgmac device does not care about the XN attribute.

This also raises the concern that we're continuing to put optional
features as prerequisites to base vfio-platform support and creating
self-induced stalls at getting anything upstream :-\  Thanks,

Alex
