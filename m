From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 0/7] Add virtio-iommu driver
Date: Fri, 16 Nov 2018 14:00:51 +0100
Message-ID: <a9545c11-347e-aa07-0609-9a9c0141a438@redhat.com>
References: <20181115165234.43990-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-4977-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181115165234.43990-1-jean-philippe.brucker@arm.com>
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, joro@8bytes.org, mst@redhat.com
Cc: frowand.list@gmail.com, jasowang@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, bhelgaas@google.com, kvmarm@lists.cs.columbia.edu, tnowicki@caviumnetworks.com, kevin.tian@intel.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, bharat.bhushan@nxp.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean,
On 11/15/18 5:52 PM, Jean-Philippe Brucker wrote:
> Implement the virtio-iommu driver, following specification v0.8 [1].
> 
> Changes since v3 [2]:
> * Rebase onto v4.20-rc2. Patch 3 now touches drivers/of/base.c instead
>   of drivers/pci/of.c, since the map_rid() function has moved.
> * Removed the request timeout, that depended on DEBUG.
> * Other small fixes addressing comments on v3.
> 
> You can find Linux driver and kvmtool device on my virtio-iommu/v0.8.1
> branches [3]. You can also test it with the latest version of Eric's
> QEMU device [4].

Tested-by: Eric Auger <eric.auger@redhat.com>

this was tested with qemu
(https://github.com/eauger/qemu/tree/v3.1.0-rc1-virtio-iommu-v0.8.1)

Thanks

Eric
> 
> [1] Virtio-iommu specification v0.8, sources and pdf
>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.8
>     http://jpbrucker.net/virtio-iommu/spec/v0.8/virtio-iommu-v0.8.pdf
> 
> [2] [PATCH v3 0/7] Add virtio-iommu driver
>     https://www.spinics.net/lists/linux-pci/msg77110.html
> 
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.8.1
>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.8.1
> 
> [4] [RFC v8 00/18] VIRTIO-IOMMU device
>     https://www.mail-archive.com/qemu-devel@nongnu.org/msg572637.html
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
>  drivers/iommu/virtio-iommu.c                  | 1160 +++++++++++++++++
>  drivers/of/base.c                             |   10 +-
>  drivers/pci/of.c                              |    7 +
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  161 +++
>  10 files changed, 1451 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h
> 
