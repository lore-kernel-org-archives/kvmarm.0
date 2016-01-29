From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Fri, 29 Jan 2016 12:33:24 -0700
Message-ID: <1454096004.9301.1.camel@redhat.com>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
	 <1454017899.23148.0.camel@redhat.com> <56AB78B1.2030202@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56AB78B1.2030202@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, suravee.suthikulpanit@amd.com, linux-kernel@vger.kernel.org, patches@linaro.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 2016-01-29 at 15:35 +0100, Eric Auger wrote:
> Hi Alex,
> On 01/28/2016 10:51 PM, Alex Williamson wrote:
> > On Tue, 2016-01-26 at 13:12 +0000, Eric Auger wrote:
> > > This series addresses KVM PCIe passthrough with MSI enabled on AR=
M/ARM64.
> > > It pursues the efforts done on [1], [2], [3]. It also aims at cov=
ering the
> > > same need on some PowerPC platforms.
> > > =C2=A0
> > > On x86 all accesses to the 1MB PA region [FEE0_0000h - FEF0_000h]=
 are directed
> > > as interrupt messages: accesses to this special PA window directl=
y target the
> > > APIC configuration space and not DRAM, meaning the downstream IOM=
MU is bypassed.
> > > =C2=A0
> > > This is not the case on above mentionned platforms where MSI mess=
ages emitted
> > > by devices are conveyed through the IOMMU. This means an IOVA/hos=
t PA mapping
> > > must exist for the MSI to reach the MSI controller. Normal way to=
 create
> > > IOVA bindings consists in using VFIO DMA MAP API. However in this=
 case
> > > the MSI IOVA is not mapped onto guest RAM but on host physical pa=
ge (the MSI
> > > controller frame).
> > > =C2=A0
> > > Following first comments, the spirit of [2] is kept: the guest re=
gisters
> > > an IOVA range reserved for MSI mapping. When the VFIO-PCIe driver=
 allocates
> > > its MSI vectors, it overwrites the MSI controller physical addres=
s with an IOVA,
> > > allocated within the window provided by the userspace. This IOVA =
is mapped
> > > onto the MSI controller frame physical page.
> > > =C2=A0
> > > The series does not address yet the problematic of telling the us=
erspace how
> > > much IOVA he should provision.
> >=C2=A0
> > I'm sort of on a think-different approach today, so bear with me; h=
ow is
> > it that x86 can make interrupt remapping so transparent to drivers =
like
> > vfio-pci while for ARM and ppc we seem to be stuck with doing these
> > fixups of the physical vector ourselves, implying ugly (no offense)
> > paths bouncing through vfio to connect the driver and iommu backend=
s?
> >=C2=A0
> > We know that x86 handles MSI vectors specially, so there is some
> > hardware that helps the situation.=C2=A0=C2=A0It's not just that x8=
6 has a fixed
> > range for MSI, it's how it manages that range when interrupt remapp=
ing
> > hardware is enabled.=C2=A0=C2=A0A device table indexed by source-ID=
 references a
> > per device table indexed by data from the MSI write itself.=C2=A0=C2=
=A0So we get
> > much, much finer granularity,
> About the granularity, I think ARM GICv3 now provides a similar
> capability with GICv3 ITS (interrupt translation service). Along with
> the MSI MSG write transaction, the device outputs a DeviceID conveyed=
 on
> the bus. This DeviceID (~ your source-ID) enables to index a device
> table. The entry in the device table points to a DeviceId interrupt
> translation table indexed by the EventID found in the msi msg. So the
> entry in the interrupt translation table eventually gives you the
> eventual interrupt ID targeted by the MSI MSG.
> This translation capability if not available in GICv2M though, ie. th=
e
> one I am currently using.
>=C2=A0
> Those tables currently are built by the ITS irqchip (irq-gic-v3-its.c=
)

So it sounds like the interrupt remapping plumbing needs to be
implemented for those chips.=C2=A0=C2=A0How does ITS identify an MSI ve=
rsus any
other DMA write?=C2=A0=C2=A0Does it need to be within a preconfigured a=
ddress
space like on x86 or does it know this implicitly by the transaction
(which doesn't seem possible on PCIe)?

Along with this discussion, we should probably be revisiting whether
existing ARM SMMUs should be exposing the IOMMU_CAP_INTR_REMAP
capability.=C2=A0=C2=A0This capability is meant to indicate interrupt i=
solation,
but if an entire page of IOVA space is mapped through the IOMMU to a
range of interrupts and some of those interrupts are shared with host
devices or other VMs, then we really don't have that isolation and the
system is susceptible to one VM interfering with another or with the
host.=C2=A0=C2=A0If that's the case, the SMMU should not be claiming
IOMMU_CAP_INTR_REMAP.

> =C2=A0but there's still effectively an interrupt
> > domain per device that's being transparently managed under the cove=
rs
> > whenever we request an MSI vector for a device.
> >=C2=A0
> > So why can't we do something more like that here?=C2=A0=C2=A0There'=
s no predefined
> > MSI vector range, so defining an interface for the user to specify =
that
> > is unavoidable.
> Do you confirm that VFIO user API still still is the good choice to
> provide that IOVA range?

I don't see that we have an option there unless ARM wants to
retroactively reserve a range of IOVA space in the spec, which is
certainly not going to happen.=C2=A0=C2=A0The only other thing that com=
es to mind
would be if there was an existing address space which could never be
backed by RAM or other DMA capable targets.=C2=A0=C2=A0But that seems f=
ar fetched
as well.

> =C2=A0 But why shouldn't everything else be transparent?=C2=A0=C2=A0W=
e
> > could add an interface to the IOMMU API that allows us to register =
that
> > reserved range for the IOMMU domain.=C2=A0=C2=A0IOMMU-core (or mayb=
e interrupt
> > remapping) code might allocate an IOVA domain for this just as you'=
ve
> > done in the type1 code here.
> I have no objection to move that iova allocation scheme somewhere els=
e.
> I just need to figure out how to deal with the fact iova.c is not
> compiled everywhere as I noticed too late ;-)
> =C2=A0 But rather than having any interaction
> > with vfio-pci, why not do this at lower levels such that the platfo=
rm
> > interrupt vector allocation code automatically uses one of those IO=
VA
> > ranges and returns the IOVA rather than the physical address for th=
e PCI
> > code to program into the device?=C2=A0=C2=A0I think we know what ne=
eds to be done,
> > but we're taking the approach of managing the space ourselves and d=
oing
> > a fixup of the device after the core code has done its job when we
> > really ought to be letting the core code manage a space that we def=
ine
> > and programming the device so that it doesn't need a fixup in the
> > vfio-pci code.=C2=A0=C2=A0Wouldn't it be nicer if pci_enable_msix_r=
ange() returned
> > with the device properly programmed or generate an error if there's=
 not
> > enough reserved mapping space in IOMMU domain?=C2=A0=C2=A0Can it be=
 done?
> I agree with you on the fact it would be cleaner to manage that nativ=
ely
> at MSI controller level instead of patching the address value in
> vfio_pci_intrs.c. I will investigate in that direction but I need som=
e
> more time to understand the links between the MSI controller, the PCI
> device and the IOMMU.

Since the current interrupt remapping schemes seem to operate in a
different address space, I expect there will be work to do to fit the
interrupt remapping within a provided address space, but it seems like =
a
very reasonable constraint to add.=C2=A0=C2=A0Thanks,

Alex

