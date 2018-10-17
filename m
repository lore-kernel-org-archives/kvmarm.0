From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 0/7] Add virtio-iommu driver
Date: Wed, 17 Oct 2018 11:23:50 -0400
Message-ID: <20181017111509-mutt-send-email-mst@kernel.org>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
 <7874471b-3711-ca44-d220-5e756ac7db8c@redhat.com>
 <b2f929c3-b0df-acdc-c5e8-0d7ddf7ed964@arm.com>
 <c7167c51-d864-08f5-c128-f4b3257840ce@redhat.com>
 <40dddb20-6248-5bb0-e0ed-48bacd1867a1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 695754A1FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 11:23:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwqDme5qtEAa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Oct 2018 11:23:56 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48BB340217
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 11:23:56 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <40dddb20-6248-5bb0-e0ed-48bacd1867a1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "joro@8bytes.org" <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Robin Murphy <Robin.Murphy@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 17, 2018 at 12:54:28PM +0100, Jean-Philippe Brucker wrote:
> On 16/10/2018 21:31, Auger Eric wrote:
> > Hi Jean,
> > =

> > On 10/16/18 8:44 PM, Jean-Philippe Brucker wrote:
> >> On 16/10/2018 10:25, Auger Eric wrote:
> >>> Hi Jean,
> >>>
> >>> On 10/12/18 4:59 PM, Jean-Philippe Brucker wrote:
> >>>> Implement the virtio-iommu driver, following specification v0.8 [1].
> >>>> Changes since v2 [2]:
> >>>>
> >>>> * Patches 2-4 allow virtio-iommu to use the PCI transport, since QEMU
> >>>> =A0=A0 would like to phase out the MMIO transport. This produces a c=
omplex
> >>>> =A0=A0 topology where the programming interface of the IOMMU could a=
ppear
> >>>> =A0=A0 lower than the endpoints that it translates. It's not unheard=
 of (e.g.
> >>>> =A0=A0 AMD IOMMU), and the guest easily copes with this.
> >>>> =A0=A0 =

> >>>> =A0=A0 The "Firmware description" section of the specification has b=
een
> >>>> =A0=A0 updated with all combinations of PCI, MMIO and DT, ACPI.
> >>>
> >>> I have a question wrt the FW specification. The IOMMU consumes 1 slot=
 in
> >>> the PCI domain and one needs to leave a RID hole in the iommu-map.=A0=
 It
> >>> is not obvious to me that this RID always is predictable given the pc=
ie
> >>> enumeration mechanism. Generally we have a coarse grain mapping of RID
> >>> onto iommu phandles/STREAMIDs. Here, if I understand correctly we need
> >>> to precisely identify the RID granted to the iommu. On QEMU this may
> >>> depend on the instantiation order of the virtio-pci device right?
> >> =

> >> Yes, although it should all happen before you boot the guest, since
> >> there is no hotplugging an IOMMU. Could you reserve a PCI slot upfront
> >> and use it for virtio-iommu later? Or generate the iommu-map at the sa=
me
> >> time as generating the child node of the PCI RC?
> > =

> > Even when cold-plugging the PCIe devices through qemu CLI, this depends
> > on the order of the pcie devices in the list I guess. I need to further
> > experiment.
> =

> Please let me know how it goes. I guess the problem will be the same for
> building IORT tables? You're also going to need a hole in the ID
> mappings of the PCI root complex node.
> =

> >>> So
> >>> this does not look trivial to build this info. Isn't it possible to do
> >>> this exclusion at kernel level instead?
> >> =

> >> So in theory VIRTIO_F_IOMMU_PLATFORM already does that:
> >> =

> >> VIRTIO_F_IOMMU_PLATFORM(33)
> >>=A0=A0=A0=A0 This feature indicates that the device is behind an IOMMU =
that
> >>=A0=A0=A0=A0 translates bus addresses from the device into physical add=
resses in
> >>=A0=A0=A0=A0 memory. If this feature bit is set to 0, then the device e=
mits
> >>=A0=A0=A0=A0 physical addresses which are not translated further, even =
though an
> >>=A0=A0=A0=A0 IOMMU may be present.
> > =

> > This tells the driver to use the dma api, right? =

> =

> That's how Linux implements the bit, install custom DMA ops when the bit
> is absent. But it doesn't work for everyone and has caused a lot of
> debate (https://patchwork.ozlabs.org/cover/946708/)
> =

> > Effectively this
> > explicitly says whether the device is supposed to be upfront an IOMMU.
> =

> Yes. It's quite strange if you consider hotpluggable hardware, since
> those devices shouldn't get to choose whether they are managed by an
> IOMMU. For the IOMMU itself, it should be fine
> =

> >> For better or for worse, the guest has to implement it. If this feature
> >> bit is unset for virtio-iommu, it does DMA on the physical address
> >> space, regardless of what the static topology description says.
> >> =

> >> In practice it doesn't quite work. If your iommu-map describes the IOM=
MU
> >> as translating itself, Linux' OF code will wait for the IOMMU to be
> >> probed before probing the IOMMU. Working around this with hacks is
> >> possible, but I don't want to introduce more questionable code to OF a=
nd
> >> device tree bindings if there is any other way.
> > Hum ok. I cannot really comment on this.
> > =

> > I just wanted to raise this concern about RID identfication.
> =

> We can always try. Relaxing iommu-map further would be one additional
> patch to Documentation/devicetree/bindings/pci/pci-iommu.txt, and one to
> drivers/iommu/of-iommu.c. I'd rather make it a separate RFC.
> =

> Since we need acks from an OF maintainer and I'd also like Joerg's
> approval for adding a new driver to the IOMMU tree, I think it's too
> late for this iteration. I wasn't intending for this to go into 4.20,
> just have something to discuss at KVM forum next week.
> =

> Thanks,
> Jean

OK then. I'd appreciate it if you mark patches that aren't
intended to be merged as RFC in subject line.
Thanks!

-- =

MST
