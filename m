From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs automap
 state
Date: Tue, 06 Oct 2015 09:11:18 -0600
Message-ID: <1444144278.4059.35.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-3-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443825961.26107.188.camel@redhat.com>
	 <CY1PR0301MB1276F6E301D347F20D7A766590480@CY1PR0301MB1276.namprd03.prod.outlook.com>
	 <1444085102.26107.364.camel@redhat.com>
	 <CY1PR0301MB12762322B3669142A04F9DB890370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CY1PR0301MB12762322B3669142A04F9DB890370@CY1PR0301MB1276.namprd03.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
To: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 2015-10-06 at 08:53 +0000, Bhushan Bharat wrote:
> 
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Tuesday, October 06, 2015 4:15 AM
> > To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> > Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > christoffer.dall@linaro.org; eric.auger@linaro.org; pranavkumar@linaro.org;
> > marc.zyngier@arm.com; will.deacon@arm.com
> > Subject: Re: [RFC PATCH 3/6] vfio: Extend iommu-info to return MSIs
> > automap state
> > 
> > On Mon, 2015-10-05 at 06:00 +0000, Bhushan Bharat wrote:
> > > > -1138,6 +1156,8 @@
> > > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > >  		}
> > > > >  	} else if (cmd == VFIO_IOMMU_GET_INFO) {
> > > > >  		struct vfio_iommu_type1_info info;
> > > > > +		struct iommu_domain_msi_maps msi_maps;
> > > > > +		int ret;
> > > > >
> > > > >  		minsz = offsetofend(struct vfio_iommu_type1_info,
> > > > iova_pgsizes);
> > > > >
> > > > > @@ -1149,6 +1169,18 @@ static long vfio_iommu_type1_ioctl(void
> > > > > *iommu_data,
> > > > >
> > > > >  		info.flags = 0;
> > > > >
> > > > > +		ret = vfio_domains_get_msi_maps(iommu, &msi_maps);
> > > > > +		if (ret)
> > > > > +			return ret;
> > > >
> > > > And now ioctl(VFIO_IOMMU_GET_INFO) no longer works for any
> > IOMMU
> > > > implementing domain_get_attr but not supporting
> > > > DOMAIN_ATTR_MSI_MAPPING.
> > >
> > > With this current patch version this will get the default assumed behavior
> > as you commented on previous patch.
> > 
> > How so?
> 
> You are right, the ioctl will return failure. But that should be ok, right?

Not remotely.  ioctl(VFIO_IOMMU_GET_INFO) can't suddenly stop working on
some platforms.

> > 
> > +               msi_maps->automap = true;
> > +               msi_maps->override_automap = false;
> > +
> > +               if (domain->ops->domain_get_attr)
> > +                       ret = domain->ops->domain_get_attr(domain, attr,
> > + data);
> > 
> > If domain_get_attr is implemented, but DOMAIN_ATTR_MSI_MAPPING is
> > not, ret should be an error code.
> 
> Currently it returns same error code returned by domain->ops->domain_get_attr(). 
> I do not think we want to complicate that we return an error to user-space that msi's probably cannot be used but user-space can continue with Legacy interrupt, or you want that?

I can't really parse your statement, but ioctl(VFIO_IOMMU_GET_INFO)
works today and it must work with your changes.  Your change should only
affect whether some flags are visible, MSI has worked just fine up to
this point on other platforms.



