From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for MSI
Date: Fri, 02 Oct 2015 16:46:45 -0600
Message-ID: <1443826005.26107.191.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
Sender: kvm-owner@vger.kernel.org
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, eric.auger@linaro.org, pranavkumar@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> Finally ARM SMMU declare that iommu-mapping for MSI-pages are not
> set automatically and it should be set explicitly.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> ---
>  drivers/iommu/arm-smmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index a3956fb..9d37e72 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1401,13 +1401,18 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  				    enum iommu_attr attr, void *data)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct iommu_domain_msi_maps *msi_maps;
>  
>  	switch (attr) {
>  	case DOMAIN_ATTR_NESTING:
>  		*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
>  		return 0;
>  	case DOMAIN_ATTR_MSI_MAPPING:
> -		/* Dummy handling added */
> +		msi_maps = data;
> +
> +		msi_maps->automap = false;
> +		msi_maps->override_automap = true;
> +
>  		return 0;
>  	default:
>  		return -ENODEV;

In previous discussions I understood one of the problems you were trying
to solve was having a limited number of MSI banks and while you may be
able to get isolated MSI banks for some number of users, it wasn't
unlimited and sharing may be required.  I don't see any of that
addressed in this series.

Also, the management of reserved IOVAs vs MSI addresses looks really
dubious to me.  How does your platform pick an MSI address and what are
we breaking by covertly changing it?  We seem to be masking over at the
VFIO level, where there should be lower level interfaces doing the right
thing when we configure MSI on the device.

The problem of reporting "automap" base address isn't addressed more
than leaving some unused field in iommu_domain_msi_maps.

