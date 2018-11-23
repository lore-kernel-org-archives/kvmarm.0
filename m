From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 0/7] Add virtio-iommu driver
Date: Fri, 23 Nov 2018 09:28:51 +0100
Message-ID: <250a38a9-e6b1-35ae-9261-eb8aab123f43@redhat.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-5023-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, joro@8bytes.org, mst@redhat.com
Cc: jasowang@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu, tnowicki@caviumnetworks.com, kevin.tian@intel.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, bharat.bhushan@nxp.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,

On 11/22/18 8:37 PM, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.9 [1].
> 
> Since v4 [2] I fixed the issues reported by Eric, and added Reviewed-by
> from Eric and Rob. Thanks!
> 
> I changed the specification to fix one inconsistency discussed in v4.
> That the device fills the probe buffer with zeroes is now a "SHOULD"
> instead of a "MAY", since it's the only way for the driver to know if
> the device wrote the status. Existing devices already do this. In
> addition the device now needs to fill the three padding bytes at the
> tail with zeroes.
> 
> You can find Linux driver and kvmtool device on branches
> virtio-iommu/v0.9 [3]. I also lightly tested with Eric's latest QEMU
> device [4].
> 
> [1] Virtio-iommu specification v0.9, sources, pdf and diff from v0.8
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.9
>     http://jpbrucker.net/virtio-iommu/spec/v0.9/virtio-iommu-v0.9.pdf
>     http://jpbrucker.net/virtio-iommu/spec/diffs/virtio-iommu-pdf-diff-v0.8-v0.9.pdf
> 
> [2] [PATCH v4 0/7] Add virtio-iommu driver
>     https://lists.linuxfoundation.org/pipermail/iommu/2018-November/031074.html
> 
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9
> 
> [4] [RFC v9 00/17] VIRTIO-IOMMU device
>     https://www.mail-archive.com/qemu-devel@nongnu.org/msg575578.html
> 
> Jean-Philippe Brucker (7):
>   dt-bindings: virtio-mmio: Add IOMMU description
>   dt-bindings: virtio: Add virtio-pci-iommu node
>   of: Allow the iommu-map property to omit untranslated devices
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
>  drivers/iommu/virtio-iommu.c                  | 1157 +++++++++++++++++
>  drivers/of/base.c                             |   10 +-
>  drivers/pci/of.c                              |    7 +
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  161 +++
>  10 files changed, 1448 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h
> 
for the whole series
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
