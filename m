From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Add virtio-iommu driver
Date: Tue, 26 Jun 2018 21:07:55 +0300
Message-ID: <20180626210132-mutt-send-email-mst@kernel.org>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180621190655.56391-1-jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>
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
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 21, 2018 at 08:06:50PM +0100, Jean-Philippe Brucker wrote:
> Implement the base virtio-iommu driver, following version 0.7 of the
> specification [1].
> =

> Changes since last version [2]:
> * Address comments, thanks again for the review.
> * As suggested, add a DT binding description in patch 1.
> * Depend on VIRTIO_MMIO=3Dy to fix a build failure=B9
> * Switch to v0.7 of the spec, which changes resv_mem parameters and adds
>   an MMIO flag. These are trivial but not backward compatible. Once
>   device or driver is upstream, updates to the spec will rely on feature
>   bits to stay compatible with this code.
> * Implement the new tlb_sync interface, by splitting add_req() and
>   sync_req(). I noticed a small improvement on netperf stream because
>   the synchronous iommu_unmap() also benefits from this. Other
>   experiments, such as using kmem_cache for requests instead of kmalloc,
>   didn't show any improvement.
> =

> Driver is available on branch virtio-iommu/v0.7 [3], and the x86+ACPI
> prototype is on branch virtio-iommu/devel. That x86 code hasn't changed,
> it still requires the DMA ifdeffery and I lack the expertise to tidy it
> up. The kvmtool example device has been cleaned up and is available on
> branch virtio-iommu/v0.7 [4].
> =

> Feedback welcome!
> =

> Thanks,
> Jean

So as I pointed out new virtio 0 device isn't really welcome ;)
No one bothered implementing virtio 1 in MMIO for all the work
that was put in defining it. The fact that the MMIO part of the
spec doesn't seem to allow for transitional devices might
or might not have something to do with this.

So why make it an MMIO device at all? A system with an IOMMU
will have a PCI bus, won't it? And it's pretty common to
have the IOMMU be a PCI device on the root bus.
Will remove need to bother with dt bindings etc.


> [1] virtio-iommu specification v0.7
>     https://www.spinics.net/lists/linux-virtualization/msg34127.html
> [2] virtio-iommu driver v1
>     https://www.spinics.net/lists/kvm/msg164322.html
> [3] git://linux-arm.org/linux-jpb.git virtio-iommu/v0.7
>     http://www.linux-arm.org/git?p=3Dlinux-jpb.git;a=3Dshortlog;h=3Drefs/=
heads/virtio-iommu/v0.7
> [4] git://linux-arm.org/kvmtool-jpb.git virtio-iommu/v0.7 =

> =

>                                   ---
> =B9 A word on the module story. Because of complex dependencies IOMMU
> drivers cannot yet be .ko modules. Enabling it is outside the scope of
> this series but I have a small prototype on branch virtio-iommu/
> module-devel. It seems desirable since some distros currently ship the
> transport code as module and are unlikely to change this on our account.
> Note that this series works fine with arm64 defconfig, which selects
> VIRTIO_MMIO=3Dy.
> =

> I could use some help to clean this up. Currently my solution is to split
> virtio-iommu into a module and a 3-lines built-in stub, which isn't
> graceful but could have been worse.
> =

> Keeping the whole virtio-iommu driver as builtin would require accessing
> any virtio utility through get_symbol. So far we only have seven of
> those and could keep a list of pointer ops, but I find this solution
> terrible. If virtio or virtio_mmio is a module, virtio-iommu also needs
> to be one.
> =

> The minimal set of changes to make a module out of an OF-based IOMMU
> driver seems to be:
> * Export IOMMU symbols used by drivers
> * Don't give up deferring probe in of_iommu
> * Move IOMMU OF tables to .rodata
> * Create a static virtio-iommu stub that declares the virtio-iommu OF
>   table entry. The build system doesn't pick up IOMMU_OF_DECLARE when
>   done from an object destined to be built as module :(
> * Create a device_link between endpoint and IOMMU, to ensure that
>   removing the IOMMU driver also unbinds the endpoint driver. Putting
>   this in IOMMU core seems like a better approach since even when not
>   built as module, unbinding an IOMMU device via sysfs will cause
>   crashes.
> =

> With this, as long as virtio-mmio isn't loaded, the OF code defers probe
> of endpoints that depend on virtio-iommu. Once virtio-mmio is loaded,
> the probe is still deferred until virtio-iommu registers itself to the
> virtio bus. Once virtio-iommu is loaded, probe of endpoints managed by
> the IOMMU follows.
> =

> I'll investigate ACPI IORT when I find some time, though I don't expect
> much complication and suggest we tackle one problem at a time. Since it
> is a luxury that requires changes to the IOMMU core, module support is
> left as a future improvement.
>                                   ---
> =

> Jean-Philippe Brucker (5):
>   dt-bindings: virtio: Specify #iommu-cells value for a virtio-iommu
>   iommu: Add virtio-iommu driver
>   iommu/virtio: Add probe request
>   iommu/virtio: Add event queue
>   vfio: Allow type-1 IOMMU instantiation for ARM
> =

>  .../devicetree/bindings/virtio/mmio.txt       |    8 +
>  MAINTAINERS                                   |    6 +
>  drivers/iommu/Kconfig                         |   11 +
>  drivers/iommu/Makefile                        |    1 +
>  drivers/iommu/virtio-iommu.c                  | 1164 +++++++++++++++++
>  drivers/vfio/Kconfig                          |    2 +-
>  include/uapi/linux/virtio_ids.h               |    1 +
>  include/uapi/linux/virtio_iommu.h             |  172 +++
>  8 files changed, 1364 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/iommu/virtio-iommu.c
>  create mode 100644 include/uapi/linux/virtio_iommu.h
> =

> -- =

> 2.17.0
