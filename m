From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: Re: [PATCH v13 00/18] VFIO support for platform devices
Date: Fri, 27 Feb 2015 12:05:26 +0100
Message-ID: <CAN9JPjE9ssasEBMbxpf+FOyc_jMkz6-7z82WRFj2YwuSDgv85w@mail.gmail.com>
References: <1422625584-3741-1-git-send-email-b.reynal@virtualopensystems.com>
 <CAN9JPjHo3AP_O=9EE83Fa7ZR+6Q2J2xYjc=ksNwLrF2WChZ4qg@mail.gmail.com>
 <54EF5892.7080908@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4266795144776573961=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC84D46C55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 05:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8HOuHaTiTD3V for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Feb 2015 05:59:38 -0500 (EST)
Received: from mail-qg0-f42.google.com (mail-qg0-f42.google.com
 [209.85.192.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D74146C17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 05:59:37 -0500 (EST)
Received: by mail-qg0-f42.google.com with SMTP id z107so13401218qgd.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 03:05:26 -0800 (PST)
In-Reply-To: <54EF5892.7080908@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Linux IOMMU <iommu@lists.linux-foundation.org>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvm-arm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============4266795144776573961==
Content-Type: multipart/alternative; boundary=001a11c13c12823b4205100fd8d8

--001a11c13c12823b4205100fd8d8
Content-Type: text/plain; charset=UTF-8

Thanks for your answers.

I am now the sub-maintainer of vfio-platform. I will handle the rebase of
these serie and fix "[PATCH v3 0/6] vfio: type1: support for ARM SMMUS with
VFIO_IOMMU_TYPE1". New versions are coming soon.

Regards,
Baptiste

On Thu, Feb 26, 2015 at 6:32 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> Hi Baptiste,
>
> On 26/02/15 17:02, Baptiste Reynal wrote:
> > Hi everyone,
> >
> > Are there any comments on this patch series? If not, Is there
> > anything keeping this series from getting merged upstream?
>
> For a start, it looks like the dependency mentioned below is still not
> in, which is a bit of a problem.
>
> Also, trying to merge your branch below (after fixing the URL), I get
> some conflicts with the current mainline, so that's a bit of a show
> stopper too.
>
> Can you start by rebasing on top of 4.0-rc1 with all the dependencies,
> reposting the series, and cc-ing the original author of the patches (as
> I cannot see Antonios on the CC list)?
>
> Thanks,
>
>         M.
>
> > Thanks,
> > Baptiste
> >
> > On Fri, Jan 30, 2015 at 2:46 PM, Baptiste Reynal <
> b.reynal@virtualopensystems.com<mailto:b.reynal@virtualopensystems.com>>
> wrote:
> > This patch series aims to implement VFIO support for platform devices
> that
> > reside behind an IOMMU. Examples of such devices are devices behind an
> ARM
> > SMMU, or behind a Samsung Exynos System MMU.
> >
> > The API used is based on the existing VFIO API that is also used with PCI
> > devices. Only devices that include a basic set of IRQs and memory
> regions are
> > targeted; devices with complex relationships with other devices on a
> device
> > tree are not taken into account at this stage.
> >
> > This patch series may be applied on the following series/patches:
> >  - [PATCH v3 0/6] vfio: type1: support for ARM SMMUS with
> VFIO_IOMMU_TYPE1
> >
> > A copy can be cloned from the branch vfio-platform-v13 at:
> > git@github.com:virtualopensystems/linux-kvm-arm.git
> >
> > Changes since v12:
> >  - Reorder chunks to be bisect-able
> > Changes since v11:
> >  - Drop support for ARM AMBA devices
> >  - vfio_platform_private.h is now self-contained
> >  - Fix masked IRQ initialization
> > Changes since v10:
> >  - Check if interrupt is already masked when setting a new trigger
> >  - Fixed kasprintf with unchecked return value in VFIO AMBA driver
> > Changes since v9:
> >  - Reworked the splitting of the patches that decouple virqfd from PCI
> >  - Some styling issues and typos
> >  - Removed superfluous includes
> >  - AMBA devices are now named vfio-amba- suffixed by the AMBA device id
> >  - Several other cleanups and fixes
> > Changes since v8:
> >  - Separate irq handler for edge and level triggered interrupts
> >  - Mutex based lock for VFIO fd open/release
> >  - Fixed bug where the first region of a platform device wasn't exposed
> >  - Read only regions can be MMAPed only read only
> >  - Code cleanups
> > Changes since v7:
> >  - Some initial placeholder functionality for PIO resources
> >  - Cleaned up code for IRQ triggering, masking and unmasking
> >  - Some functionality has been removed from this series and posted
> separately:
> >    - VFIO_IOMMU_TYPE1 support for ARM SMMUs
> >    - IOMMU NOEXEC patches
> >    - driver_override functionality for AMBA devices
> >  - Several fixes
> > Changes since v6:
> >  - Integrated support for AMBA devices
> >  - Numerous cleanups and fixes
> > Changes since v5:
> >  - Full eventfd support for IRQ masking and unmasking.
> >  - Changed IOMMU_EXEC to IOMMU_NOEXEC, along with related flags in VFIO.
> >  - Other fixes based on reviewer comments.
> > Changes since v4:
> >  - Use static offsets for each region in the VFIO device fd
> >  - Include patch in the series for the ARM SMMU to expose IOMMU_EXEC
> >    availability via IOMMU_CAP_DMA_EXEC
> >  - Rebased on VFIO multi domain support:
> >    - IOMMU_EXEC is now available if at least one IOMMU in the container
> >      supports it
> >    - Expose IOMMU_EXEC if available via the capability
> VFIO_IOMMU_PROT_EXEC
> >  - Some bug fixes
> > Changes since v3:
> >  - Use Kim Phillips' driver_probe_device()
> > Changes since v2:
> >  - Fixed Read/Write and MMAP on device regions
> >  - Removed dependency on Device Tree
> >  - Interrupts support
> >  - Interrupt masking/unmasking
> >  - Automask level sensitive interrupts
> >  - Introduced VFIO_DMA_MAP_FLAG_EXEC
> >  - Code clean ups
> >
> > Antonios Motakis (18):
> >   vfio/platform: initial skeleton of VFIO support for platform devices
> >   vfio: platform: probe to devices on the platform bus
> >   vfio: platform: add the VFIO PLATFORM module to Kconfig
> >   vfio/platform: return info for bound device
> >   vfio/platform: return info for device memory mapped IO regions
> >   vfio/platform: read and write support for the device fd
> >   vfio/platform: support MMAP of MMIO regions
> >   vfio/platform: return IRQ info
> >   vfio/platform: initial interrupts support code
> >   vfio/platform: trigger an interrupt via eventfd
> >   vfio/platform: support for level sensitive interrupts
> >   vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and
> >     export
> >   vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit
> >   vfio: add local lock for virqfd instead of depending on VFIO PCI
> >   vfio: pass an opaque pointer on virqfd initialization
> >   vfio: move eventfd support code for VFIO_PCI to a separate file
> >   vfio: initialize the virqfd workqueue in VFIO generic code
> >   vfio/platform: implement IRQ masking/unmasking via an eventfd
> >
> >  drivers/vfio/Kconfig                          |   1 +
> >  drivers/vfio/Makefile                         |   5 +-
> >  drivers/vfio/pci/vfio_pci.c                   |   8 -
> >  drivers/vfio/pci/vfio_pci_intrs.c             | 238 +-----------
> >  drivers/vfio/pci/vfio_pci_private.h           |   3 -
> >  drivers/vfio/platform/Kconfig                 |   9 +
> >  drivers/vfio/platform/Makefile                |   4 +
> >  drivers/vfio/platform/vfio_platform.c         | 103 +++++
> >  drivers/vfio/platform/vfio_platform_common.c  | 521
> ++++++++++++++++++++++++++
> >  drivers/vfio/platform/vfio_platform_irq.c     | 336 +++++++++++++++++
> >  drivers/vfio/platform/vfio_platform_private.h |  85 +++++
> >  drivers/vfio/vfio.c                           |   8 +
> >  drivers/vfio/virqfd.c                         | 213 +++++++++++
> >  include/linux/vfio.h                          |  27 ++
> >  include/uapi/linux/vfio.h                     |   1 +
> >  15 files changed, 1326 insertions(+), 236 deletions(-)
> >  create mode 100644 drivers/vfio/platform/Kconfig
> >  create mode 100644 drivers/vfio/platform/Makefile
> >  create mode 100644 drivers/vfio/platform/vfio_platform.c
> >  create mode 100644 drivers/vfio/platform/vfio_platform_common.c
> >  create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
> >  create mode 100644 drivers/vfio/platform/vfio_platform_private.h
> >  create mode 100644 drivers/vfio/virqfd.c
> >
> > --
> > 2.2.2
> >
> >
>
>
> --
> Jazz is not dead. It just smells funny...
>

--001a11c13c12823b4205100fd8d8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for your answers.<br><br>I am now the sub-maintaine=
r of vfio-platform. I will handle the rebase of these serie and fix &quot;[=
PATCH v3 0/6] vfio: type1: support for ARM SMMUS with VFIO_IOMMU_TYPE1&quot=
;. New versions are coming soon.<br><br>Regards,<br>Baptiste</div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Feb 26, 2015 at 6:=
32 PM, Marc Zyngier <span dir=3D"ltr">&lt;<a href=3D"mailto:marc.zyngier@ar=
m.com" target=3D"_blank">marc.zyngier@arm.com</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">Hi Baptiste,<br>
<span class=3D""><br>
On 26/02/15 17:02, Baptiste Reynal wrote:<br>
&gt; Hi everyone,<br>
&gt;<br>
&gt; Are there any comments on this patch series? If not, Is there<br>
&gt; anything keeping this series from getting merged upstream?<br>
<br>
</span>For a start, it looks like the dependency mentioned below is still n=
ot<br>
in, which is a bit of a problem.<br>
<br>
Also, trying to merge your branch below (after fixing the URL), I get<br>
some conflicts with the current mainline, so that&#39;s a bit of a show<br>
stopper too.<br>
<br>
Can you start by rebasing on top of 4.0-rc1 with all the dependencies,<br>
reposting the series, and cc-ing the original author of the patches (as<br>
I cannot see Antonios on the CC list)?<br>
<br>
Thanks,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<br>
&gt; Thanks,<br>
&gt; Baptiste<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;<br>
&gt; On Fri, Jan 30, 2015 at 2:46 PM, Baptiste Reynal &lt;<a href=3D"mailto=
:b.reynal@virtualopensystems.com">b.reynal@virtualopensystems.com</a>&lt;ma=
ilto:<a href=3D"mailto:b.reynal@virtualopensystems.com">b.reynal@virtualope=
nsystems.com</a>&gt;&gt; wrote:<br>
&gt; This patch series aims to implement VFIO support for platform devices =
that<br>
&gt; reside behind an IOMMU. Examples of such devices are devices behind an=
 ARM<br>
&gt; SMMU, or behind a Samsung Exynos System MMU.<br>
&gt;<br>
&gt; The API used is based on the existing VFIO API that is also used with =
PCI<br>
&gt; devices. Only devices that include a basic set of IRQs and memory regi=
ons are<br>
&gt; targeted; devices with complex relationships with other devices on a d=
evice<br>
&gt; tree are not taken into account at this stage.<br>
&gt;<br>
&gt; This patch series may be applied on the following series/patches:<br>
&gt;=C2=A0 - [PATCH v3 0/6] vfio: type1: support for ARM SMMUS with VFIO_IO=
MMU_TYPE1<br>
&gt;<br>
&gt; A copy can be cloned from the branch vfio-platform-v13 at:<br>
&gt; git@github.com:virtualopensystems/linux-kvm-arm.git<br>
&gt;<br>
&gt; Changes since v12:<br>
&gt;=C2=A0 - Reorder chunks to be bisect-able<br>
&gt; Changes since v11:<br>
&gt;=C2=A0 - Drop support for ARM AMBA devices<br>
&gt;=C2=A0 - vfio_platform_private.h is now self-contained<br>
&gt;=C2=A0 - Fix masked IRQ initialization<br>
&gt; Changes since v10:<br>
&gt;=C2=A0 - Check if interrupt is already masked when setting a new trigge=
r<br>
&gt;=C2=A0 - Fixed kasprintf with unchecked return value in VFIO AMBA drive=
r<br>
&gt; Changes since v9:<br>
&gt;=C2=A0 - Reworked the splitting of the patches that decouple virqfd fro=
m PCI<br>
&gt;=C2=A0 - Some styling issues and typos<br>
&gt;=C2=A0 - Removed superfluous includes<br>
&gt;=C2=A0 - AMBA devices are now named vfio-amba- suffixed by the AMBA dev=
ice id<br>
&gt;=C2=A0 - Several other cleanups and fixes<br>
&gt; Changes since v8:<br>
&gt;=C2=A0 - Separate irq handler for edge and level triggered interrupts<b=
r>
&gt;=C2=A0 - Mutex based lock for VFIO fd open/release<br>
&gt;=C2=A0 - Fixed bug where the first region of a platform device wasn&#39=
;t exposed<br>
&gt;=C2=A0 - Read only regions can be MMAPed only read only<br>
&gt;=C2=A0 - Code cleanups<br>
&gt; Changes since v7:<br>
&gt;=C2=A0 - Some initial placeholder functionality for PIO resources<br>
&gt;=C2=A0 - Cleaned up code for IRQ triggering, masking and unmasking<br>
&gt;=C2=A0 - Some functionality has been removed from this series and poste=
d separately:<br>
&gt;=C2=A0 =C2=A0 - VFIO_IOMMU_TYPE1 support for ARM SMMUs<br>
&gt;=C2=A0 =C2=A0 - IOMMU NOEXEC patches<br>
&gt;=C2=A0 =C2=A0 - driver_override functionality for AMBA devices<br>
&gt;=C2=A0 - Several fixes<br>
&gt; Changes since v6:<br>
&gt;=C2=A0 - Integrated support for AMBA devices<br>
&gt;=C2=A0 - Numerous cleanups and fixes<br>
&gt; Changes since v5:<br>
&gt;=C2=A0 - Full eventfd support for IRQ masking and unmasking.<br>
&gt;=C2=A0 - Changed IOMMU_EXEC to IOMMU_NOEXEC, along with related flags i=
n VFIO.<br>
&gt;=C2=A0 - Other fixes based on reviewer comments.<br>
&gt; Changes since v4:<br>
&gt;=C2=A0 - Use static offsets for each region in the VFIO device fd<br>
&gt;=C2=A0 - Include patch in the series for the ARM SMMU to expose IOMMU_E=
XEC<br>
&gt;=C2=A0 =C2=A0 availability via IOMMU_CAP_DMA_EXEC<br>
&gt;=C2=A0 - Rebased on VFIO multi domain support:<br>
&gt;=C2=A0 =C2=A0 - IOMMU_EXEC is now available if at least one IOMMU in th=
e container<br>
&gt;=C2=A0 =C2=A0 =C2=A0 supports it<br>
&gt;=C2=A0 =C2=A0 - Expose IOMMU_EXEC if available via the capability VFIO_=
IOMMU_PROT_EXEC<br>
&gt;=C2=A0 - Some bug fixes<br>
&gt; Changes since v3:<br>
&gt;=C2=A0 - Use Kim Phillips&#39; driver_probe_device()<br>
&gt; Changes since v2:<br>
&gt;=C2=A0 - Fixed Read/Write and MMAP on device regions<br>
&gt;=C2=A0 - Removed dependency on Device Tree<br>
&gt;=C2=A0 - Interrupts support<br>
&gt;=C2=A0 - Interrupt masking/unmasking<br>
&gt;=C2=A0 - Automask level sensitive interrupts<br>
&gt;=C2=A0 - Introduced VFIO_DMA_MAP_FLAG_EXEC<br>
&gt;=C2=A0 - Code clean ups<br>
&gt;<br>
&gt; Antonios Motakis (18):<br>
&gt;=C2=A0 =C2=A0vfio/platform: initial skeleton of VFIO support for platfo=
rm devices<br>
&gt;=C2=A0 =C2=A0vfio: platform: probe to devices on the platform bus<br>
&gt;=C2=A0 =C2=A0vfio: platform: add the VFIO PLATFORM module to Kconfig<br=
>
&gt;=C2=A0 =C2=A0vfio/platform: return info for bound device<br>
&gt;=C2=A0 =C2=A0vfio/platform: return info for device memory mapped IO reg=
ions<br>
&gt;=C2=A0 =C2=A0vfio/platform: read and write support for the device fd<br=
>
&gt;=C2=A0 =C2=A0vfio/platform: support MMAP of MMIO regions<br>
&gt;=C2=A0 =C2=A0vfio/platform: return IRQ info<br>
&gt;=C2=A0 =C2=A0vfio/platform: initial interrupts support code<br>
&gt;=C2=A0 =C2=A0vfio/platform: trigger an interrupt via eventfd<br>
&gt;=C2=A0 =C2=A0vfio/platform: support for level sensitive interrupts<br>
&gt;=C2=A0 =C2=A0vfio: add a vfio_ prefix to virqfd_enable and virqfd_disab=
le and<br>
&gt;=C2=A0 =C2=A0 =C2=A0export<br>
&gt;=C2=A0 =C2=A0vfio: virqfd: rename vfio_pci_virqfd_init and vfio_pci_vir=
qfd_exit<br>
&gt;=C2=A0 =C2=A0vfio: add local lock for virqfd instead of depending on VF=
IO PCI<br>
&gt;=C2=A0 =C2=A0vfio: pass an opaque pointer on virqfd initialization<br>
&gt;=C2=A0 =C2=A0vfio: move eventfd support code for VFIO_PCI to a separate=
 file<br>
&gt;=C2=A0 =C2=A0vfio: initialize the virqfd workqueue in VFIO generic code=
<br>
&gt;=C2=A0 =C2=A0vfio/platform: implement IRQ masking/unmasking via an even=
tfd<br>
&gt;<br>
&gt;=C2=A0 drivers/vfio/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
&gt;=C2=A0 drivers/vfio/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
&gt;=C2=A0 drivers/vfio/pci/vfio_pci.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 -<br>
&gt;=C2=A0 drivers/vfio/pci/vfio_pci_intrs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0| 238 +-----------<br>
&gt;=C2=A0 drivers/vfio/pci/vfio_pci_private.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A03 -<br>
&gt;=C2=A0 drivers/vfio/platform/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A09 +<br>
&gt;=C2=A0 drivers/vfio/platform/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform.c=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0| 103 +++++<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform_common.c=C2=A0 | 521 +++++++=
+++++++++++++++++++<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform_irq.c=C2=A0 =C2=A0 =C2=A0| 3=
36 +++++++++++++++++<br>
&gt;=C2=A0 drivers/vfio/platform/vfio_platform_private.h |=C2=A0 85 +++++<b=
r>
&gt;=C2=A0 drivers/vfio/vfio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +<br>
&gt;=C2=A0 drivers/vfio/virqfd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 213 +++++++++++<br>
&gt;=C2=A0 include/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 27 ++<br>
&gt;=C2=A0 include/uapi/linux/vfio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A01 +<br>
&gt;=C2=A0 15 files changed, 1326 insertions(+), 236 deletions(-)<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/Kconfig<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/Makefile<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/vfio_platform.c<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/vfio_platform_common.c<=
br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/vfio_platform_irq.c<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/platform/vfio_platform_private.h=
<br>
&gt;=C2=A0 create mode 100644 drivers/vfio/virqfd.c<br>
&gt;<br>
&gt; --<br>
&gt; 2.2.2<br>
&gt;<br>
&gt;<br>
<br>
<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Jazz is not dead. It just smells funny...<br>
</font></span></blockquote></div><br></div>

--001a11c13c12823b4205100fd8d8--

--===============4266795144776573961==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4266795144776573961==--
