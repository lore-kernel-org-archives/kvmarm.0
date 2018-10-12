From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] Add virtio-iommu driver
Date: Fri, 12 Oct 2018 13:00:34 -0400
Message-ID: <20181012125443-mutt-send-email-mst@kernel.org>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181012145917.6840-1-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 12, 2018 at 03:59:10PM +0100, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.8 [1].
> Changes since v2 [2]:
> 
> * Patches 2-4 allow virtio-iommu to use the PCI transport, since QEMU
>   would like to phase out the MMIO transport. This produces a complex
>   topology where the programming interface of the IOMMU could appear
>   lower than the endpoints that it translates. It's not unheard of (e.g.
>   AMD IOMMU), and the guest easily copes with this.
>   
>   The "Firmware description" section of the specification has been
>   updated with all combinations of PCI, MMIO and DT, ACPI.
> 
> * Fix structures layout, they don't need the "packed" attribute anymore.
> 
> * While we're at it, add domain parameter to DETACH request, and leave
>   some padding. This way the next version, that adds PASID support,
>   won't have to introduce a "DETACH2" request to stay backward
>   compatible.
> 
> * Require virtio device 1.0+. Remove legacy transport notes from the
>   specification.
> 
> * Request timeout is now only enabled with DEBUG.
> 
> * The patch for VFIO Kconfig (previously patch 5/5) is in next.
> 
> You can find Linux driver and kvmtool device on branches
> virtio-iommu/v0.8 [3] (currently based on 4.19-rc7 but rebasing onto
> next only produced a trivial conflict). Branch virtio-iommu/devel
> contains a few patches that I'd like to send once the base is upstream:
> 
> * virtio-iommu as a module. It got *much* nicer after Rob's probe
>   deferral rework, but I still have a bug to fix when re-loading the
>   virtio-iommu module.
> 
> * ACPI support requires a minor IORT spec update (reservation of node
>   ID). I think it should be easier to obtain once the device and drivers
>   are upstream.
> 
> [1] Virtio-iommu specification v0.8, diff from v0.7, and sources
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.8
>     http://jpbrucker.net/virtio-iommu/spec/v0.8/virtio-iommu-v0.8.pdf
>     http://jpbrucker.net/virtio-iommu/spec/diffs/virtio-iommu-pdf-diff-v0.7-v0.8.pdf
> 
> [2] [PATCH v2 0/5] Add virtio-iommu driver
>     https://www.spinics.net/lists/kvm/msg170655.html
> 
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.8
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.8
> 
> Jean-Philippe Brucker (7):
>   dt-bindings: virtio-mmio: Add IOMMU description
>   dt-bindings: virtio: Add virtio-pci-iommu node
>   PCI: OF: allow endpoints to bypass the iommu
>   PCI: OF: Initialize dev->fwnode appropriately
>   iommu: Add virtio-iommu driver
>   iommu/virtio: Add probe request
>   iommu/virtio: Add event queue
> 
>  .../devicetree/bindings/virtio/iommu.txt      |   66 +
>  .../devicetree/bindings/virtio/mmio.txt       |   30 +
>  MAINTAINERS                                   |    7 +
>  drivers/iommu/Kconfig                         |   11 +
>  drivers/iommu/Makefile                        |    1 +
>  drivers/iommu/virtio-iommu.c                  | 1171 +++++++++++++++++
>  drivers/pci/of.c                              |   14 +-
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  159 +++
>  9 files changed, 1457 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h

This all looks good to me. Minor nits:
- I think DEBUG mode is best just removed for now
- Slightly wrong patch splitup causing a misaligned structure
  in uapi until all patches are applied.

You should Cc Bjorn on the pci change - I'd like to see his ack on it
being merged through my tree.

And pls Cc the virtio-dev list on any virtio uapi changes.

At a feature level I have some ideas for more features we
could add, but for now I think I'll put this version in -next
while you iron out the above wrinkles. Hope you can make the
merge window.

> -- 
> 2.19.1
