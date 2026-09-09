Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F955C326
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788958002; cv=none; b=QOdLLGYH/zMCySTxTnroBrSUJHiwbizfpn81qz2Q/DlVkKvy9GHZ9XMh9Dx4xkEDfcfadgXKCl0z6Vke0suSYssAHIfmWyAMgfiESStWGbcFkFk/5kxFhXyeCGaCcoUKI2rTlcToCdeJvr3+ppRvL7Icc0WF7scakMXm3IanurM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788958002; c=relaxed/simple;
	bh=QDi/RLEV4NM3t1kYDBD1hT0dRtZz7+g9ZWoQx4FJiek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3HgUDjrBOdtuW15agfo7FQl0RIBT52kGpu2uwZ8PYvnSQUpgyD4z5kNPFemImbgJS3DJZhg/L6dW/vpV0Ws+Khdw8ghJquvXR0GChVn9dOccVYSHUhLtRZulDFlNkVh/1PohRGSUTuW3Ke76lmlFJ5h1gDeq+/y0U0dMe+GreI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kW9K/j8D; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kW9K/j8D"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfbd148aso10002216d6.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 05:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788957992; x=1789562792; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+JBkF2wxS+es6K6okap3riPRAx5NmOpjF4k3ofV33EY=;
        b=kW9K/j8Dfp7g0pn3q3B+8D7a26jlSQ7h/cJINRjzrp2bEjr2V6+5algvTs9DydY6nA
         vbBaSeCBBPF7mkai9HROyO3ZsrzcCeCBq7SG1dIBHu8Xvx1RUPQ+GDgU+GbSLex71eEP
         xpNzb0wVd+Bp+d9OBFScTv5aIo2auqZmnVhNZnchvI7Tu1kvqe3w8ZRacTLPNp5RitgC
         Z7lf6/m5dmDVoQ/2MJrFmyDsyGTybkojCNawjOtr0vFoDdgFYsPZq01i0UjzHfnAQH32
         2VJ698AYiAZHKFJFIlIfzGuLDcmu8PmOPp4Inuquxu9/FmFmJEW2RWDkrdtH3etqLy8B
         q9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788957992; x=1789562792;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+JBkF2wxS+es6K6okap3riPRAx5NmOpjF4k3ofV33EY=;
        b=mwDrJLc9SeNvD8H0qx4xWkPhgJXKNVfRIo+DxP6zrDqrCsxl3dhItzZ7GEqpclseey
         8Yp/C12Lyo+uR9mQMtEqsGig4c3XO78eNn4MTXRwZ9YnUUVi6qLKhlwfM7bEhMCh6uaY
         VRflKsdi3CXe2qoCMCnUzifrD+JHNaXgSWdNouJVPXiZgk8QEJKT9YrYShXYdJNaMoVi
         QFfjJfEaVdwNd+oicd7cVDd1pYAK1+t0lZqwZnlXs6TPbOezVxDR0pjr3yExnAHlJ2ex
         zXwNo+80uow6K6Xo5wcTKHUi6h6F/cxgQ82TjnY6fzDFNk6czMa/HV80M/PUPXxzmCyj
         2WWA==
X-Forwarded-Encrypted: i=1; AKwUvBzGbmxqWWbePWM+xWFhd4DgEmxOWIfmFAq+SOCEpKHgm+gudhtVSWjRIhaGUc5xIlfBJQqLhkM=@lists.linux.dev
X-Gm-Message-State: AFuF++mIgAYvbHQoGhXwYlX9S6hgZtCEWlLRv0/2lh+VOL02/zsxAlP1
	1AWM3kYvHRq08vKJZMgWcbMWUvewkzqAkXjE+haw6LlDw36eyUoeUW+y1AIA7J9qXA0=
X-Gm-Gg: AYBFou14h7czUZbHLWzahOQCAnJKnQCrYE6Y92SD+ruaFlS2sFNq2+Uf4jMXGG5xiqI
	08Re8aIosXbEBsLBX5OWxURYXISjGUSFoj5GFPHaKyriAZG+Rd7C1bCsiWCyXPhJGmhBzDBDRcS
	qyf6b1WFGOouijKCnA+yKcf1hrSyh9JmPrQokJDp4T84iWh+p+Evceq4ZKJNMA6WpxEKoF4hWEp
	FoXTdNvlE87ikJvIoygU73doexlzwwif29E/1Kw77XbbdsI/kxOxRnzR7xGMoRxLBn68ye93Ezz
	nSWiP9vxpb8SVNyBMyFKLqZn06sEa2/pLjcesnltnSU9x991KobCkUFWKkrEWLniOpaowbuk5PX
	pdCSUs2eJ5bijCVubI6KGGI0sE1/QBszHJKTlZWIZcp8nvpSA8TWeGTya6z/5D5NlIo8kfLKa/1
	RRN58cz199D7t4jAgAXPkt0jTkAbrBDTcOMhuodU5SjWe1FYEA+hs6zIeAjBiPZX1Cs+Ci/NkfM
	cVoUMhU+tvBZPJ6U5GMI+f4+vJ4i8bmBwZ4s0JvZKT0QhdeE/PxVRCw
X-Received: by 2002:a05:6214:ccc:b0:910:4080:dc4f with SMTP id 6a1803df08f44-9106b371c17mr87577676d6.4.1788957992321;
        Wed, 09 Sep 2026 05:46:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91053b4992csm85467086d6.22.2026.09.09.05.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 05:46:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x4Hh6-0000000Ge25-36Uc;
	Wed, 09 Sep 2026 09:46:28 -0300
Date: Wed, 9 Sep 2026 09:46:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260909124628.GH2543240@ziepe.ca>
References: <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca>
 <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca>
 <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca>
 <yq5atsnyag84.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5atsnyag84.fsf@kernel.org>

On Wed, Sep 09, 2026 at 03:39:31PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Mon, Sep 07, 2026 at 03:15:25PM +0530, Aneesh Kumar K.V wrote:
> >
> >> I looked into this, and it becomes fairly complicated. We can move all
> >> vdev/TDI-related code to arm-smmu-realm-v3.c, but that would result in:
> >
> > I was going for the opposite, you'd move everything out of arm-smmu-v3
> > and into the arm-cca-host and obtain the viommu through tsm_ops not
> > through iommu_ops.
> >
> > I guess I pointed to that in another email.
> >
> > The only thing arm-smmu-v3 should provide is a simple function to give
> > the pdev phys and irq parameters. arm-cca-host calls that when it
> > creates an viommu object.
> >
> 
> 
> So ended up with
> 
> static const struct tsm_viommu_ops cca_tsm_viommu_ops = {
> 	.owner = THIS_MODULE,
> 	.type = IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3,
> 	.get_size = cca_viommu_get_size,
> 	.init = cca_viommu_init,
> };

OK, may also be fine in the main tsm ops? 

> struct cca_viommu {
> 	struct cca_psmmu *psmmu;
> 	struct iommu_viommu_provider *iommu_provider;
> 	const struct iommufd_viommu_ops *iommu_ops; // backing SMMU ops

??

The viommu created for a RMM owned vSMMU should have no connection to
the normal SMMU driver? It just needs the psmmu information.

We need to adjust iommufd side to know that this object cannot accept
an iommu_domain, only a kvm fd. I don't want to pass in a fake
iommu_domain that has nothing to do with how RMM will operate things.

> static struct iommu_domain *
> cca_viommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
> 			       const struct iommu_user_data *user_data)
> {
> 	struct cca_viommu *cca = viommu->provider_data;
> 
> 	return cca->iommu_ops->alloc_domain_nested(viommu, flags, user_data);
> }
> 
> static int cca_viommu_cache_invalidate(struct iommufd_viommu *viommu,
> 				       struct iommu_user_data_array *array)
> {
> 	struct cca_viommu *cca = viommu->provider_data;
> 
> 	return cca->iommu_ops->cache_invalidate(viommu, array);
> }

These ops should fail (just be NULL) not reflect to a psmmu.
 
> struct cca_vdevice {
> 	struct iommufd_vdevice core;
> 	struct pci_tsm_context *tsm_context;
> 	struct cca_host_tdi host_tdi;

Is the extra tdi struct still needed? Isn't cca_vdevice the tdi struct?

> 	u32 l2_sid;
> };
> 
> static const struct iommufd_viommu_ops cca_viommu_ops = {
> 	.destroy = cca_viommu_destroy,
> 	.alloc_domain_nested = cca_viommu_alloc_domain_nested,
> 	.cache_invalidate = cca_viommu_cache_invalidate,
> 	.vdevice_size = VDEVICE_STRUCT_SIZE(struct cca_vdevice, core),
> 	.vdevice_init = cca_vdevice_init,
> 	.vdevice_tsm_req = cca_vdevice_tsm_req,
> };

> 
> and on iommu side
> 
> struct iommu_viommu_provider {
> 	size_t size;
> 	int (*init)(struct iommufd_viommu *viommu, struct device *dev,
> 		    enum iommu_viommu_type type,
> 		    struct iommu_domain *parent_domain,
> 		    const struct iommu_user_data *user_data);
> 	int (*get_params)(struct iommu_viommu_provider *provider,
> 			  struct device *dev, enum iommu_viommu_type type,
> 			  void *params, size_t params_size);
> 	void (*release)(struct iommu_viommu_provider *provider);
> 	void *data;
> };

Not sure what this is?

> The TSM disconnect path will now fail while any vdevice is alive or
> active. 

Yes, that's makes sense.

> Destroying a vdevice will unlock and destroy the VDEV. 

Yes

> I think we can also unmap its MMIO mappings at that point, provided
> we track the mapping requests in a list alongside the vdevice
> details.

The mmio is owned by vfio, there should be a handshake in VFIO to
remove mmio when it becomes private, otherwise I don't think we need
to do anything more?

> All CCA operations will use pci_tsm_pf0::lock, though I think the
> locking can be made more fine-grained.

Sure
 
> I will send a cleaned-up series so that we can review the code changes.

Does it seems reasonable to you? Was there any oddness with modeling
the vdev/bind through the viommu?

Anyhow I'll look more closely when you are ready. Thanks

Jason
