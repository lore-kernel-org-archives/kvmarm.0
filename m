From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for MSI
Date: Mon, 2 Nov 2015 08:23:28 +0530
Message-ID: <CAAHg+Hj1At3sS=tMeWt6PYVu-7bUUcKGeyROjYD-3_-_c1i3WQ@mail.gmail.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
 <1443826005.26107.191.camel@redhat.com> <CY1PR0301MB127637C2EA08365A249864C090480@CY1PR0301MB1276.namprd03.prod.outlook.com>
 <1444085675.26107.372.camel@redhat.com> <BN3PR0301MB1265E14339BD005A912624B990370@BN3PR0301MB1265.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <BN3PR0301MB1265E14339BD005A912624B990370@BN3PR0301MB1265.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Bharat,

On 6 October 2015 at 15:56, Bhushan Bharat <Bharat.Bhushan@freescale.com> wrote:
>
>
>> -----Original Message-----
>> From: Alex Williamson [mailto:alex.williamson@redhat.com]
>> Sent: Tuesday, October 06, 2015 4:25 AM
>> To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
>> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
>> christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
>> marc.zyngier@arm.com; will.deacon@arm.com
>> Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for
>> MSI
>>
>> On Mon, 2015-10-05 at 08:33 +0000, Bhushan Bharat wrote:
>> >
>> >
>> > > -----Original Message-----
>> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
>> > > Sent: Saturday, October 03, 2015 4:17 AM
>> > > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
>> > > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
>> > > christoffer.dall@linaro.org; eric.auger@linaro.org;
>> > > pranavkumar@linaro.org; marc.zyngier@arm.com; will.deacon@arm.com
>> > > Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping
>> > > for MSI
>> > >
>> > > On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
>> > > > Finally ARM SMMU declare that iommu-mapping for MSI-pages are not
>> > > > set automatically and it should be set explicitly.
>> > > >
>> > > > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
>> > > > ---
>> > > >  drivers/iommu/arm-smmu.c | 7 ++++++-
>> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
>> > > index
>> > > > a3956fb..9d37e72 100644
>> > > > --- a/drivers/iommu/arm-smmu.c
>> > > > +++ b/drivers/iommu/arm-smmu.c
>> > > > @@ -1401,13 +1401,18 @@ static int
>> arm_smmu_domain_get_attr(struct
>> > > iommu_domain *domain,
>> > > >                                     enum iommu_attr attr, void *data)  {
>> > > >         struct arm_smmu_domain *smmu_domain =
>> > > to_smmu_domain(domain);
>> > > > +       struct iommu_domain_msi_maps *msi_maps;
>> > > >
>> > > >         switch (attr) {
>> > > >         case DOMAIN_ATTR_NESTING:
>> > > >                 *(int *)data = (smmu_domain->stage ==
>> > > ARM_SMMU_DOMAIN_NESTED);
>> > > >                 return 0;
>> > > >         case DOMAIN_ATTR_MSI_MAPPING:
>> > > > -               /* Dummy handling added */
>> > > > +               msi_maps = data;
>> > > > +
>> > > > +               msi_maps->automap = false;
>> > > > +               msi_maps->override_automap = true;
>> > > > +
>> > > >                 return 0;
>> > > >         default:
>> > > >                 return -ENODEV;
>> > >
>> > > In previous discussions I understood one of the problems you were
>> > > trying to solve was having a limited number of MSI banks and while
>> > > you may be able to get isolated MSI banks for some number of users,
>> > > it wasn't unlimited and sharing may be required.  I don't see any of that
>> addressed in this series.
>> >
>> > That problem was on PowerPC. Infact there were two problems, one which
>> MSI bank to be used and second how to create iommu-mapping for device
>> assigned to userspace.
>> > First problem was PowerPC specific and that will be solved separately.
>> > For second problem, earlier I tried to added a couple of MSI specific ioctls
>> and you suggested (IIUC) that we should have a generic reserved-iova type
>> of API and then we can map MSI bank using reserved-iova and this will not
>> require involvement of user-space.
>> >
>> > >
>> > > Also, the management of reserved IOVAs vs MSI addresses looks really
>> > > dubious to me.  How does your platform pick an MSI address and what
>> > > are we breaking by covertly changing it?  We seem to be masking over
>> > > at the VFIO level, where there should be lower level interfaces
>> > > doing the right thing when we configure MSI on the device.
>> >
>> > Yes, In my understanding the right solution should be:
>> >  1) VFIO driver should know what physical-msi-address will be used for
>> devices in an iommu-group.
>> >     I did not find an generic API, on PowerPC I added some function in
>> ffrescale msi-driver and called from vfio-iommu-fsl-pamu.c (not yet
>> upstreamed).
>> >  2) VFIO driver should know what IOVA to be used for creating
>> > iommu-mapping (VFIO APIs patch of this patch series)
>> >  3) VFIO driver will create the iommu-mapping using (1) and (2)
>> >  4) VFIO driver should be able to tell the msi-driver that for a given device it
>> should use different IOVA. So when composing the msi message (for the
>> devices is the given iommu-group) it should use that programmed iova as
>> MSI-address. This interface also needed to be developed.
>> >
>> > I was not sure of which approach we should take. The current approach in
>> the patch is simple to develop so I went ahead to take input but I agree this
>> does not look very good.
>> > What do you think, should drop this approach and work out the approach
>> as described above.
>>
>> I'm certainly not interested in applying an maintaining an interim solution that
>> isn't the right one.  It seems like VFIO is too involved in this process in your
>> example.  On x86 we have per vector isolation and the only thing we're
>> missing is reporting back of the region used by MSI vectors as reserved IOVA
>> space (but it's standard on x86, so an x86 VM user will never use it for IOVA).
>
> I remember you mentioned that there is no problem when running an x86 guest on an x86 host.  But it will interesting when running a non-x86 VMs on an x86 host  or non-VM userspace use of VFIO though.
>
>> In your model, the MSI IOVA space is programmable,
>
> Yes, on PowerPC and ARM-SMMU case also we have to create mapping with an IOVA. First question is which IOVA to be used, and we added the reserved iova ioctl for same.
>
> Second problem is we needed an msi-page physical address for setting up iommu-mapping, and so we needed to reserve an msi-page. I did this for PowerPC but not in a generic extension in msi-driver and will look the code a bit more details on adding an interface to reserve an msi-page or get a shared msi-page with allow-unsafe-interrupt.

I think reserving MSI page is tricky as in arm/arm64 in MSI
controllers like GICv2M:
1. We  have number of interrupts mapped to one physical MSI address.
2. Two root complexes can have same MSI controller this means two EP
devices on two different RCs can have same MSI address programmed (and
will have different data to generate different MSI interrupt)
3. This means reserving of a MSI physical address is difficult since
we can have one EP device from one RC assigned to a VM and another EP
device can be used by host linux or by a different VM.

One way to get msi physical address which I have tried in my patch series was:

1. Let linux host controller assigned MSI address (by calling
request_irq) which current VFIO PCI driver does, and then extract this
address.
2. Map this extracted address with an IOVA address.

>
> Third problem is to report the reserved IOVA to be used for MSI vectors for the given set of devices (devices in a vfio-group).

I am not sure what is the problem here ? as userspace is going to tell
us which IOVA is to be used.
Do you mean -
1. userspace is going to provide us a range of IOVA and we will choose
one of them to map it with a physical MSI address.
2. Now how to tell userspace which IOVA we have used ???????

>
> Mark/Christopher,
> I am not an expert in this area so I might have to understand that code. If you think you can give solution to 2nd and 3rd problem quickly then please let me know.
>
> Thanks
> -Bharat
>
>> but it has page
>> granularity (I assume).  Therefore we shouldn't be sharing that page with
>> anyone.  That seems to suggest we need to allocate a page of vector space
>> from the host kernel, setup the IOVA mapping, and then the host kernel
>> should know to only allocate MSI vectors for these devices from that pre-
>> allocated page.  Otherwise we need to call the interrupts unsafe, like we do
>> on x86 without interrupt remapping.  Thanks,
>>
>> Alex
>
Thanks,
Pranav
