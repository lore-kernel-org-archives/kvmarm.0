From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v5 0/4] vfio: type1: support for ARM SMMUS with
	VFIO_IOMMU_TYPE1
Date: Thu, 5 Mar 2015 18:09:21 +0000
Message-ID: <20150305180921.GD8163@arm.com>
References: <1425485274-5709-1-git-send-email-b.reynal@virtualopensystems.com>
	<1425491104.5200.268.camel@redhat.com>
	<54F893C3.6020006@linaro.org>
	<1425578066.5200.331.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425578066.5200.331.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 05, 2015 at 05:54:26PM +0000, Alex Williamson wrote:
> On Thu, 2015-03-05 at 18:34 +0100, Eric Auger wrote:
> > Ironically, since the correction of the IOMMU_CAP_CACHE_COHERENCY bug
> > (https://lkml.org/lkml/2015/1/29/514) in vfio_iommu_type1.c, my Calxeda
> > Midway VFIO use case is not working anymore. This is also observable
> > when I do not apply at all the whole [PATCH v5 0/4] vfio: type1: support
> > for ARM SMMUS with VFIO_IOMMU_TYPE1 series.
> > 
> > My understanding is this series should not be requested for me since my
> > xgmac device does not care about the XN attribute.
> > 
> > My understanding is that without the bug or the series, the IOMMU_CACHE
> > flag is set whereas before it was not. Patching vfio_iommu_type1.c
> > vfio_iommu_type1_attach_group and unsetting IOMMU_CAP_CACHE_COHERENCY
> > makes the use case functional again.
> > 
> > I do not understand the exact semantic of IOMMU_CAP_CACHE_COHERENCY. I
> > see the arm smmu always returns true, and if my understanding is correct
> > the vfio_iommu_type1 sets the IOMMU_CACHE attribute which eventually
> > make the ARM SMMU sets the memory attribute to cacheable in the PTE. But
> > naively I would say the interco used in Midway may not be cache coherent
> > capability (ARM ACE, ACE-lite), hence the issue.
> > 
> > Please could you share your knowledge/understanding about this topic.
> > Adding Will in to ;-)
> 
> This patch series should change nothing about how the IOMMU_CACHE
> mapping flag is used, it was a bug in the enum to bitmap translation
> that broke/fixed your use case.  VFIO type1 IOMMU always uses
> IOMMU_CACHE when available.  On x86 the effect is that DMA is coherent
> with the processor cache (ie. the PCIe NoSnoop attribute is ignored).
> This means that KVM can continue to ignore certain cache operations,
> like writeback-invalidate (WBINVD), that would otherwise need to be
> emulated.  We may need a separate flag and capability if ARM SMMU is
> doing something different with the flag.  Thanks,

On ARM, coherency isn't really a property of the SMMU. Sure, the SMMU can
emit cacheable transactions (which is what the capability basically means),
but whether or not they snoop the CPU caches depends on the system
configuration. I'd expect the "dma-coherent" property of the *master* to
indicate whether that is the case.

Will
