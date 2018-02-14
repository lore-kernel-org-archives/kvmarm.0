From: Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 0/4] Add virtio-iommu driver
Date: Wed, 14 Feb 2018 14:53:36 +0000
Message-ID: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
Cc: jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement the virtio-iommu driver following version 0.6 of the
specification [1]. Previous version, RFCv2, was sent in November [2].
This version addresses Eric's comments and changes the device number.
(Since last week I also tested and fixed the probe/release functions,
they now use devm properly.)

I did not include ACPI support because the next IORT specifications
isn't ready yet (even though the virtio-iommu spec describes the node
format, a new node type has to be allocated). Therefore only device-tree
guests are supported for the moment but the x86 prototype, on branch
virtio-iommu/devel, doesn't add much complexity.

	git://linux-arm.org/linux-jpb.git virtio-iommu/v0.6

Test it with Eric's latest QEMU device [3], for example with the
following command-line:

$ qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic
	-kernel Image -append 'console=ttyAMA0 root=/dev/vda rw'
	-device virtio-iommu-device
	-device virtio-blk-pci,iommu_platform,disable-legacy=on,drive=hd0
	-drive if=none,file=rootfs.bin,id=hd0

You can also try the kvmtool device [4]. For example on AMD Seattle I
use the following commands to boot a guest with all devices behind a
virtio-iommu, then display mapping stats.

$ lkvm run -k Image --irqchip gicv2m --console virtio --vfio-pci 01:00.0
	--viommu vfio --viommu virtio
$ lkvm debug -a -i stats

[1] [RFC] virtio-iommu version 0.6
    https://www.spinics.net/lists/linux-virtualization/msg32628.html
[2] [RFC PATCH v2 0/5] Add virtio-iommu driver
    https://www.spinics.net/lists/kvm/msg159047.html
[3] [RFC v6 00/22] VIRTIO-IOMMU device
    http://lists.gnu.org/archive/html/qemu-arm/2018-02/msg00274.html
[4] git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.6

Jean-Philippe Brucker (4):
  iommu: Add virtio-iommu driver
  iommu/virtio: Add probe request
  iommu/virtio: Add event queue
  vfio: Allow type-1 IOMMU instantiation with a virtio-iommu

 MAINTAINERS                       |    6 +
 drivers/iommu/Kconfig             |   11 +
 drivers/iommu/Makefile            |    1 +
 drivers/iommu/virtio-iommu.c      | 1220 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/Kconfig              |    2 +-
 include/uapi/linux/virtio_ids.h   |    1 +
 include/uapi/linux/virtio_iommu.h |  171 ++++++
 7 files changed, 1411 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/virtio-iommu.c
 create mode 100644 include/uapi/linux/virtio_iommu.h

-- 
2.16.1
