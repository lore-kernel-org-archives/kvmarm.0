From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS
 condition
Date: Mon, 23 Mar 2015 15:23:41 +0100
Message-ID: <20150323142340.GA2226@8bytes.org>
References: <1425484266-5449-1-git-send-email-b.reynal@virtualopensystems.com>
 <20150304183258.GN17250@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150304183258.GN17250@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Baptiste Reynal <b.reynal@virtualopensystems.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 06:32:58PM +0000, Will Deacon wrote:
> > -	if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS))) {
> > +	if ((id & ID0_S1TS) && ((smmu->version == 1) || (id & ID0_ATOSNS))) {
> >  		smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
> >  		dev_notice(smmu->dev, "\taddress translation ops\n");
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Sorry Joerg, but this is the latest in the drip of ARM SMMU fixes for
> 4.0! Please pick it up with the rest.

Applied to iommu/fixes, thanks.
