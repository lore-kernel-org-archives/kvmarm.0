From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v11 0/8] KVM PCIe/MSI passthrough on ARM/ARM64: kernel
	part 1/3: iommu changes
Date: Wed, 20 Jul 2016 19:52:18 +0800
Message-ID: <20160720115217.GC1915@arm.com>
References: <1468932911-23062-1-git-send-email-eric.auger@redhat.com>
	<20160720095624.GA1915@arm.com>
	<27715cdb-9f39-7860-465b-e533f4a5c03c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <27715cdb-9f39-7860-465b-e533f4a5c03c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, nd-5wv7dgnIgG8@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 20, 2016 at 01:03:00PM +0200, Auger Eric wrote:
> Hi Dennis
> On 20/07/2016 11:56, Dennis Chen wrote:
> > Hi Eric,
> > 
> > On Tue, Jul 19, 2016 at 12:55:03PM +0000, Eric Auger wrote:
> >> This series introduces the msi-iommu api used to:
> >>
> >> - allocate/free resources for MSI IOMMU mapping
> >> - set the MSI iova window aperture
> >> - map/unmap physical addresses onto MSI IOVAs.
> >> - determine whether an msi needs to be iommu mapped
> >> - overwrite an msi_msg PA address with its pre-allocated/mapped IOVA
> >>
> >> Also a new iommu domain attribute, DOMAIN_ATTR_MSI_GEOMETRY is introduced
> >> to report the MSI iova window geometry (aperture and iommu-msi API support).
> >>
> >> Currently:
> >> - iommu driver is supposed to allocate/free MSI mapping resources
> >> - VFIO subsystem is supposed to set the MSI IOVA aperture.
> >> - The MSI layer is supposed to allocate/free iova mappings and overwrite
> >>   msi_msg with IOVA at composition time
> >>
> >> More details & context can be found at:
> >> http://www.linaro.org/blog/core-dump/kvm-pciemsi-passthrough-armarm64/
> >>
> >> Best Regards
> >>
> >> Eric
> >>
> >> Git: complete series available at
> >> https://github.com/eauger/linux/tree/v4.7-rc7-passthrough-v11
> >>
> > Why can't I find this new series on your git tree:
> > https://git.linaro.org/people/eric.auger/linux.git
> you are not looking at the right git repo: see github one above.
> > ?
> > Also, do I need to download all the 3-part patches to test the PCIe NIC passthru
> > as I did on your v9 series?
> Yes you need to take the 3 parts. You should have everything that is
> needed on the above branch. In case you do not work on Cavium, you
> should not cherry-pick
> "vfio: pci: HACK! workaround thunderx pci_try_reset_bus crash"
>
Thanks Eric, I've got all the 3 parts from the github git tree in my local repos.
Currently I think the major platform of mine is AMD overdrive. So I will test this patch set
on that platform first.

Thanks,
Dennis
> 
> Thanks
> 
> Eric
> > 
> > Thanks,
> > Dennis 
> >>
> >> see part III for wrap-up details.
> >>
> >> History:
> >> v10 -> v11:
> >> - no change in the series, just incremented for consistency
> >> - added a temporary patch in the branch:
> >>   "iommu/iova: FIXUP! validate iova_domain input to put_iova_domain"
> >>   originally sent by Nate and adapted for this use case. This is currently
> >>   under discussion on the ML. The crash typically occurs in case unsafe
> >>   interrupts are discovered while allow_unsafe_interrupts is not set.
> >>
> >> v9 -> v10:
> >> - split error management in iommu_msi_set_aperture
> >>
> >> v8 -> v9:
> >> - rename iommu_domain_msi_geometry programmable flag into iommu_msi_supported
> >> - introduce msi_apperture_valid helper and use this instead of is_aperture_set
> >>
> >> v7 -> v8:
> >> - The API is retargetted for MSI: renamed msi-iommu
> >>   all "dma-reserved" namings removed
> >> - now implemented upon dma-iommu (get, put, init), ie. reuse iova_cookie,
> >>   and iova API
> >> - msi mapping resources now are guaranteed to exist during the whole iommu
> >>   domain's lifetime. No need to lock to garantee the cookie integrity
> >> - removed alloc/free_reserved_reserved_iova_domain. We now have a single
> >>   function that sets the aperture, looking like iommu_dma_init_domain.
> >> - we now use a list instead of an RB-tree
> >> - prot is not propagated anymore at domain creation due to the retargetting
> >>   for MSI
> >> - iommu_domain pointer removed from doorbell_mapping struct
> >> - replaced DOMAIN_ATTR_MSI_MAPPING by DOMAIN_ATTR_MSI_GEOMETRY
> >>
> >> v6 -> v7:
> >> - fixed known lock bugs and multiple page sized slots matching
> >>   (I only have a single MSI frame made of a single page)
> >> - reserved_iova_cookie now pointing to a struct that encapsulates the
> >>   iova domain handle + protection attribute passed from VFIO (Alex' req)
> >> - 2 new functions exposed: iommu_msi_mapping_translate_msg,
> >>   iommu_msi_mapping_desc_to_domain: not sure this is the right location/proto
> >>   though
> >> - iommu_put_reserved_iova now takes a phys_addr_t
> >> - everything now is cleanup on iommu_domain destruction
> >>
> >> RFC v5 -> patch v6:
> >> - split to ease the review process
> >> - in dma-reserved-api use a spin lock instead of a mutex (reported by
> >>   Jean-Philippe)
> >> - revisit iommu_get_reserved_iova API to pass a size parameter upon
> >>   Marc's request
> >> - Consistently use the page order passed when creating the iova domain.
> >> - init reserved_binding_list (reported by Julien)
> >>
> >> RFC v4 -> RFC v5:
> >> - take into account Thomas' comments on MSI related patches
> >>   - split "msi: IOMMU map the doorbell address when needed"
> >>   - increase readability and add comments
> >>   - fix style issues
> >>  - split "iommu: Add DOMAIN_ATTR_MSI_MAPPING attribute"
> >>  - platform ITS now advertises IOMMU_CAP_INTR_REMAP
> >>  - fix compilation issue with CONFIG_IOMMU API unset
> >>  - arm-smmu-v3 now advertises DOMAIN_ATTR_MSI_MAPPING
> >>
> >> RFC v3 -> v4:
> >> - Move doorbell mapping/unmapping in msi.c
> >> - fix ref count issue on set_affinity: in case of a change in the address
> >>   the previous address is decremented
> >> - doorbell map/unmap now is done on msi composition. Should allow the use
> >>   case for platform MSI controllers
> >> - create dma-reserved-iommu.h/c exposing/implementing a new API dedicated
> >>   to reserved IOVA management (looking like dma-iommu glue)
> >> - series reordering to ease the review:
> >>   - first part is related to IOMMU
> >>   - second related to MSI sub-system
> >>   - third related to VFIO (except arm-smmu IOMMU_CAP_INTR_REMAP removal)
> >> - expose the number of requested IOVA pages through VFIO_IOMMU_GET_INFO
> >>   [this partially addresses Marc's comments on iommu_get/put_single_reserved
> >>    size/alignment problematic - which I did not ignore - but I don't know
> >>    how much I can do at the moment]
> >>
> >> RFC v2 -> RFC v3:
> >> - should fix wrong handling of some CONFIG combinations:
> >>   CONFIG_IOVA, CONFIG_IOMMU_API, CONFIG_PCI_MSI_IRQ_DOMAIN
> >> - fix MSI_FLAG_IRQ_REMAPPING setting in GICv3 ITS (although not tested)
> >>
> >> PATCH v1 -> RFC v2:
> >> - reverted to RFC since it looks more reasonable ;-) the code is split
> >>   between VFIO, IOMMU, MSI controller and I am not sure I did the right
> >>   choices. Also API need to be further discussed.
> >> - iova API usage in arm-smmu.c.
> >> - MSI controller natively programs the MSI addr with either the PA or IOVA.
> >>   This is not done anymore in vfio-pci driver as suggested by Alex.
> >> - check irq remapping capability of the group
> >>
> >> RFC v1 [2] -> PATCH v1:
> >> - use the existing dma map/unmap ioctl interface with a flag to register a
> >>   reserved IOVA range. Use the legacy Rb to store this special vfio_dma.
> >> - a single reserved IOVA contiguous region now is allowed
> >> - use of an RB tree indexed by PA to store allocated reserved slots
> >> - use of a vfio_domain iova_domain to manage iova allocation within the
> >>   window provided by the userspace
> >> - vfio alloc_map/unmap_free take a vfio_group handle
> >> - vfio_group handle is cached in vfio_pci_device
> >> - add ref counting to bindings
> >> - user modality enabled at the end of the series
> >>
> >>
> >> Eric Auger (8):
> >>   iommu: Add iommu_domain_msi_geometry and DOMAIN_ATTR_MSI_GEOMETRY
> >>   iommu/arm-smmu: initialize the msi geometry and advertise iommu-msi
> >>     support
> >>   iommu: introduce an msi cookie
> >>   iommu/msi-iommu: initialization
> >>   iommu/msi-iommu: iommu_msi_[get,put]_doorbell_iova
> >>   iommu/msi-iommu: iommu_msi_domain
> >>   iommu/msi-iommu: iommu_msi_msg_pa_to_va
> >>   iommu/arm-smmu: get/put the msi cookie
> >>
> >>  drivers/iommu/Kconfig       |   7 +
> >>  drivers/iommu/Makefile      |   1 +
> >>  drivers/iommu/arm-smmu-v3.c |  18 ++-
> >>  drivers/iommu/arm-smmu.c    |  18 ++-
> >>  drivers/iommu/iommu.c       |   5 +
> >>  drivers/iommu/msi-iommu.c   | 322 ++++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/iommu.h       |  15 +++
> >>  include/linux/msi-iommu.h   | 144 ++++++++++++++++++++
> >>  8 files changed, 522 insertions(+), 8 deletions(-)
> >>  create mode 100644 drivers/iommu/msi-iommu.c
> >>  create mode 100644 include/linux/msi-iommu.h
> >>
> >> -- 
> >> 1.9.1
> >>
> >> _______________________________________________
> >> kvmarm mailing list
> >> kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >>
> > 
> 
