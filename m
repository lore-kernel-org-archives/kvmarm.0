From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/7] Add virtio-iommu driver
Date: Tue, 27 Nov 2018 12:16:21 -0500
Message-ID: <20181127121036-mutt-send-email-mst@kernel.org>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
	<20181127114402-mutt-send-email-mst@kernel.org>
	<6c061729-c404-ac25-f86f-7fe222bf5bc7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6c061729-c404-ac25-f86f-7fe222bf5bc7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 27, 2018 at 06:09:25PM +0100, Auger Eric wrote:
> Hi Michael,
> 
> On 11/27/18 5:53 PM, Michael S. Tsirkin wrote:
> > On Thu, Nov 22, 2018 at 07:37:54PM +0000, Jean-Philippe Brucker wrote:
> >> Implement the virtio-iommu driver, following specification v0.9 [1].
> >>
> >> Since v4 [2] I fixed the issues reported by Eric, and added Reviewed-by
> >> from Eric and Rob. Thanks!
> >>
> >> I changed the specification to fix one inconsistency discussed in v4.
> >> That the device fills the probe buffer with zeroes is now a "SHOULD"
> >> instead of a "MAY", since it's the only way for the driver to know if
> >> the device wrote the status. Existing devices already do this. In
> >> addition the device now needs to fill the three padding bytes at the
> >> tail with zeroes.
> >>
> >> You can find Linux driver and kvmtool device on branches
> >> virtio-iommu/v0.9 [3]. I also lightly tested with Eric's latest QEMU
> >> device [4].
> > 
> > I tried to get this to work on my x86 box but without
> > success. Any hints? Does this have to do with the IORT table?
> > I think we really should just reserve our own table ID
> > and avoid the pain of trying to add things to the IORT spec.
> > I'm reluctant to merge lots of code that I can't easily test.
> > Again, if we found a way to push more configuration into
> > virtio config space the problem space would be smaller.
> 
> You can at least test it with QEMU ARM virt in TCG mode.

It's slow enough that I generally just focus on KVM.

> Then I have
> worked on the IORT integration in PC/Q35 but this is not yet functional.
> I need to debug what's wrong on guest ACPI probing. I plan to work on
> this this week.
> 
> Thanks
> 
> Eric

Sounds good. Did you need to make changes to IORT?  I don't remember. If
yes it would be very easy to just have a virtio specific ACPI table -
I am assuming ARM guys will be just as hostile to virt changes
to IORT as they were to minor changes to ARM vIOMMU.


> > 
> >> [1] Virtio-iommu specification v0.9, sources, pdf and diff from v0.8
> >>     git://linux-arm.org/virtio-iommu.git virtio-iommu/v0.9
> >>     http://jpbrucker.net/virtio-iommu/spec/v0.9/virtio-iommu-v0.9.pdf
> >>     http://jpbrucker.net/virtio-iommu/spec/diffs/virtio-iommu-pdf-diff-v0.8-v0.9.pdf
> >>
> >> [2] [PATCH v4 0/7] Add virtio-iommu driver
> >>     https://lists.linuxfoundation.org/pipermail/iommu/2018-November/031074.html
> >>
> >> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.9
> >>     git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.9
> >>
> >> [4] [RFC v9 00/17] VIRTIO-IOMMU device
> >>     https://www.mail-archive.com/qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org/msg575578.html
> >>
> >> Jean-Philippe Brucker (7):
> >>   dt-bindings: virtio-mmio: Add IOMMU description
> >>   dt-bindings: virtio: Add virtio-pci-iommu node
> >>   of: Allow the iommu-map property to omit untranslated devices
> >>   PCI: OF: Initialize dev->fwnode appropriately
> >>   iommu: Add virtio-iommu driver
> >>   iommu/virtio: Add probe request
> >>   iommu/virtio: Add event queue
> >>
> >>  .../devicetree/bindings/virtio/iommu.txt      |   66 +
> >>  .../devicetree/bindings/virtio/mmio.txt       |   30 +
> >>  MAINTAINERS                                   |    7 +
> >>  drivers/iommu/Kconfig                         |   11 +
> >>  drivers/iommu/Makefile                        |    1 +
> >>  drivers/iommu/virtio-iommu.c                  | 1157 +++++++++++++++++
> >>  drivers/of/base.c                             |   10 +-
> >>  drivers/pci/of.c                              |    7 +
> >>  include/uapi/linux/virtio_ids.h               |    1 +
> >>  include/uapi/linux/virtio_iommu.h             |  161 +++
> >>  10 files changed, 1448 insertions(+), 3 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/virtio/iommu.txt
> >>  create mode 100644 drivers/iommu/virtio-iommu.c
> >>  create mode 100644 include/uapi/linux/virtio_iommu.h
> >>
> >> -- 
> >> 2.19.1
