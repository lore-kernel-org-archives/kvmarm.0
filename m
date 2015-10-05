From: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Subject: RE: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for MSI
Date: Mon, 5 Oct 2015 08:33:05 +0000
Message-ID: <CY1PR0301MB127637C2EA08365A249864C090480@CY1PR0301MB1276.namprd03.prod.outlook.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
 <1443826005.26107.191.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2759C4117E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 04:31:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M29R0NKA3Nd0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Oct 2015 04:31:16 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0104.outbound.protection.outlook.com [65.55.169.104])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EB6F4117C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Oct 2015 04:31:16 -0400 (EDT)
In-Reply-To: <1443826005.26107.191.camel@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Saturday, October 03, 2015 4:17 AM
> To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> marc.zyngier@arm.com; will.deacon@arm.com
> Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for
> MSI
> 
> On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> > Finally ARM SMMU declare that iommu-mapping for MSI-pages are not set
> > automatically and it should be set explicitly.
> >
> > Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> > ---
> >  drivers/iommu/arm-smmu.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index
> > a3956fb..9d37e72 100644
> > --- a/drivers/iommu/arm-smmu.c
> > +++ b/drivers/iommu/arm-smmu.c
> > @@ -1401,13 +1401,18 @@ static int arm_smmu_domain_get_attr(struct
> iommu_domain *domain,
> >  				    enum iommu_attr attr, void *data)  {
> >  	struct arm_smmu_domain *smmu_domain =
> to_smmu_domain(domain);
> > +	struct iommu_domain_msi_maps *msi_maps;
> >
> >  	switch (attr) {
> >  	case DOMAIN_ATTR_NESTING:
> >  		*(int *)data = (smmu_domain->stage ==
> ARM_SMMU_DOMAIN_NESTED);
> >  		return 0;
> >  	case DOMAIN_ATTR_MSI_MAPPING:
> > -		/* Dummy handling added */
> > +		msi_maps = data;
> > +
> > +		msi_maps->automap = false;
> > +		msi_maps->override_automap = true;
> > +
> >  		return 0;
> >  	default:
> >  		return -ENODEV;
> 
> In previous discussions I understood one of the problems you were trying to
> solve was having a limited number of MSI banks and while you may be able
> to get isolated MSI banks for some number of users, it wasn't unlimited and
> sharing may be required.  I don't see any of that addressed in this series.

That problem was on PowerPC. Infact there were two problems, one which MSI bank to be used and second how to create iommu-mapping for device assigned to userspace.
First problem was PowerPC specific and that will be solved separately.
For second problem, earlier I tried to added a couple of MSI specific ioctls and you suggested (IIUC) that we should have a generic reserved-iova type of API and then we can map MSI bank using reserved-iova and this will not require involvement of user-space.

> 
> Also, the management of reserved IOVAs vs MSI addresses looks really
> dubious to me.  How does your platform pick an MSI address and what are
> we breaking by covertly changing it?  We seem to be masking over at the
> VFIO level, where there should be lower level interfaces doing the right thing
> when we configure MSI on the device.

Yes, In my understanding the right solution should be:
 1) VFIO driver should know what physical-msi-address will be used for devices in an iommu-group.
    I did not find an generic API, on PowerPC I added some function in ffrescale msi-driver and called from vfio-iommu-fsl-pamu.c (not yet upstreamed).
 2) VFIO driver should know what IOVA to be used for creating iommu-mapping (VFIO APIs patch of this patch series)
 3) VFIO driver will create the iommu-mapping using (1) and (2)
 4) VFIO driver should be able to tell the msi-driver that for a given device it should use different IOVA. So when composing the msi message (for the devices is the given iommu-group) it should use that programmed iova as MSI-address. This interface also needed to be developed.

I was not sure of which approach we should take. The current approach in the patch is simple to develop so I went ahead to take input but I agree this does not look very good.
What do you think, should drop this approach and work out the approach as described above.

Thanks
-Bharat
> 
> The problem of reporting "automap" base address isn't addressed more than
> leaving some unused field in iommu_domain_msi_maps.
