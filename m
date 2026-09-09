Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05824B2CBD;
	Wed,  9 Sep 2026 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788948583; cv=none; b=dVc+ZhQ5/eFXAjthSMeShyoSANsodwoORglaq8Hlo7IlYMoCTIKleEcUut3T63EVNgyCfaudsHdBfW51Vs0DA4mEzIrtt8ANaHf/k1yyiCE5dNKW0qhFfAcfn0NbZFpQ6f+96q2pztpjIpvkx/Y3N200cj4+3fPifGWqBmjFiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788948583; c=relaxed/simple;
	bh=PRi9lqc8pogN77KOIMjGVdF0rVg9ebU0q7ETmQ1r7yo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dp9dMy+t1YpBlpPOM45eCTCNGDX6VQvDMj7/nP3DbzUavaGOLAxso74+08VGeaZJ7Wyr6Ftyfz1dfyqEHCIvBthJRoqMwegJ54+UVtCaV4sQyHo22j3h0TcmA5XZhyj8aFgqblXSqIylQwe+m9PQzmI+3rMIj/ilks91leMqAys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeJPs6Mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeJPs6Mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE581F00A3D;
	Wed,  9 Sep 2026 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788948581;
	bh=HfjgJeFpXM7grjwxJfO9iaFDcmusZnd9R05IdvkkszY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VeJPs6McjFgTz/IiwdZe50yyfTdbdVtvaH6gF5gv/T/x86fxjvRe+A/K4vPgm3VSE
	 lfKfhw97jMEtSumkA8PvJD1Z1TdnuwlPiBRHcMk2KdeE4Hyca3oSLDRmd1fs/n/YUt
	 U3MmezgBgYg7oBD/V7aQY8WHM8NUhQgZLSGoeo65zlqnu5Zh7zrshGYPe5NeY9sEVW
	 a7SOWrGlQpwUHancrAQKHS8xwE/X33ENjhn/KoxUAcHqW7upatus/oFeRXX2AIAsFz
	 ZRVSMXlOOQ3RKspRQZ9kzV6lsfcQ0//E2HjAZLMk60VQVSBjQFGqpq6M/2QbNwEOHz
	 AsHZ+b3dfH+JA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
In-Reply-To: <20260907125228.GB667892@ziepe.ca>
References: <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org> <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca> <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca> <yq5acxupjsy2.fsf@kernel.org>
 <20260907125228.GB667892@ziepe.ca>
Date: Wed, 09 Sep 2026 15:39:31 +0530
Message-ID: <yq5atsnyag84.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Mon, Sep 07, 2026 at 03:15:25PM +0530, Aneesh Kumar K.V wrote:
>
>> I looked into this, and it becomes fairly complicated. We can move all
>> vdev/TDI-related code to arm-smmu-realm-v3.c, but that would result in:
>
> I was going for the opposite, you'd move everything out of arm-smmu-v3
> and into the arm-cca-host and obtain the viommu through tsm_ops not
> through iommu_ops.
>
> I guess I pointed to that in another email.
>
> The only thing arm-smmu-v3 should provide is a simple function to give
> the pdev phys and irq parameters. arm-cca-host calls that when it
> creates an viommu object.
>


So ended up with

static const struct tsm_viommu_ops cca_tsm_viommu_ops = {
	.owner = THIS_MODULE,
	.type = IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3,
	.get_size = cca_viommu_get_size,
	.init = cca_viommu_init,
};

struct cca_viommu {
	struct cca_psmmu *psmmu;
	struct iommu_viommu_provider *iommu_provider;
	const struct iommufd_viommu_ops *iommu_ops; // backing SMMU ops
};


// backing ops are mostly used for

static struct iommu_domain *
cca_viommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
			       const struct iommu_user_data *user_data)
{
	struct cca_viommu *cca = viommu->provider_data;

	return cca->iommu_ops->alloc_domain_nested(viommu, flags, user_data);
}

static int cca_viommu_cache_invalidate(struct iommufd_viommu *viommu,
				       struct iommu_user_data_array *array)
{
	struct cca_viommu *cca = viommu->provider_data;

	return cca->iommu_ops->cache_invalidate(viommu, array);
}


struct cca_vdevice {
	struct iommufd_vdevice core;
	struct pci_tsm_context *tsm_context;
	struct cca_host_tdi host_tdi;
	u32 l2_sid;
};

static const struct iommufd_viommu_ops cca_viommu_ops = {
	.destroy = cca_viommu_destroy,
	.alloc_domain_nested = cca_viommu_alloc_domain_nested,
	.cache_invalidate = cca_viommu_cache_invalidate,
	.vdevice_size = VDEVICE_STRUCT_SIZE(struct cca_vdevice, core),
	.vdevice_init = cca_vdevice_init,
	.vdevice_tsm_req = cca_vdevice_tsm_req,
};


and on iommu side

struct iommu_viommu_provider {
	size_t size;
	int (*init)(struct iommufd_viommu *viommu, struct device *dev,
		    enum iommu_viommu_type type,
		    struct iommu_domain *parent_domain,
		    const struct iommu_user_data *user_data);
	int (*get_params)(struct iommu_viommu_provider *provider,
			  struct device *dev, enum iommu_viommu_type type,
			  void *params, size_t params_size);
	void (*release)(struct iommu_viommu_provider *provider);
	void *data;
};


The TSM disconnect path will now fail while any vdevice is alive or
active. Destroying a vdevice will unlock and destroy the VDEV. I think
we can also unmap its MMIO mappings at that point, provided we track the
mapping requests in a list alongside the vdevice details.

All CCA operations will use pci_tsm_pf0::lock, though I think the
locking can be made more fine-grained.

I will send a cleaned-up series so that we can review the code changes.

-aneesh
