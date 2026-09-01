Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F5147043A
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284707; cv=none; b=NJYY0Kh8l4NznYFjl/+mbGYGuLKofkfIj6e9CZ7hkTvJAcWyr5+898wC4lEHWnA7pC4c3jBuoV95AV/vE75PeA3M2KAE6lsHf6w29HW4VSED1MrYYBUnYLOVlL2avp28b6twIZu8n1qEHum7oST0GXgf3/PrDkaN+X3dwgIpuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284707; c=relaxed/simple;
	bh=6L/MBIpCfqnotMOzUP5gbdtoK12piFj3oych96kwEq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bx+UeKoqfJSziwZ3gV+MHihg6PCcrR/TpSwbf8puhGntwnpkQX9jF4bJgk5hTKik2ZySbzmIrWEFPJjqmN12CsXYFrJKVGN4OPjoFlnaZ6L2ThOIl5Md+uYO4dU2X8Z13VCjsbNjKJZlRo1y+z8SeOJJrt153m5sh+GLowWRly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=B0viACf7; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="B0viACf7"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e50a650a0so19003885a.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788284704; x=1788889504; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dz5fCb8eEO+u0xeHbat1iXwZqnQiKYPkVzTkS17OKDs=;
        b=B0viACf7KFkQwZS3wM3Csb/02R35vsSvsc34Lgv3JtH5c3vV90edZl4+N1CbZXJ4YL
         3TwzKK/BVk9zn9da8h+qhFQS55J8sOKXmHruL7/1O2196TznZEUGzh9y9vcBLOeGBa+V
         Oen85oal4XRW1MAs1f/Yf0gT6Ec8koZSQ0KpCryhGQ6xxDGj84bAImifkZ81WCdPvEd7
         UVYwstZimjzvIRJAPZaQO4fZPV5YlLXCv8h2SmMRSgYhNU2kEwmSgKdMq4tDFPotI9mn
         OQYnDht+566xQoCsPbNoAdtHo9pARqQeFA9A5A4uYcBPjNwPlalsAvu5m1uRIvBEhF01
         sM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788284704; x=1788889504;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dz5fCb8eEO+u0xeHbat1iXwZqnQiKYPkVzTkS17OKDs=;
        b=d7xKz0kA76SlYlXnk09evrxXW8u8ntF3Yrs5GAdwgnMZuUnbfHBBBWFl9DEZl5/Zmq
         12w0nQRZ2evOj5hkOrCafUrUXWqmZ4v085zv1TdR4/8o0/Ibhpu/G+RHBkwG5BjSjM5A
         Y/yjpYfmfHWMt+Kzbce+eG1jBOtH/ZsLwQ+wISsfPXPbMXMVIgSxWy6QHdEMsB9RIyb9
         zJPA22tK1uo5HxZo9cN/lZdHDyvkbUHuYKaA8CywtbqRe1MFWOfFdgDSb9u/09/79vpu
         +kamS0TKJfYgnOmwlenzGHvlIzSmy0nuQHKphV61UrrvTDZqj1LCSPHvsFEaOehrKQRp
         Ttfw==
X-Forwarded-Encrypted: i=1; AHgh+RoiUnS8G3osmZCv5VE63m1S9dehZz7JgjLndNyHYsnZtQDi2XRQRMaPCQDyHphhPPYIyHiWXfQ=@lists.linux.dev
X-Gm-Message-State: AFuF++n6BG7KrYUJu1m0cbbYYMLcsyNapd1rOEPypF9c4xUIvgDxYhgb
	8KXHrpHEeZ33VAS2DI9A8b1Y37y0X+0LrExEDHL/aECzPgcubdNR0X0VR71o1Z22Z98=
X-Gm-Gg: AR+sD12SQKPSc3CcnftToOmRzHDySAvoVpXMKVYq8PRIJOUMy0/ow81slUGDlWcvJHv
	8d4nH7cqnKZ2JEmsXYi++C/DRoqDXMxt9JM+xxGEt+txxAqer56XY9bHA85YJusWaPHMwv1Fnul
	rhbmZzYmzI4i/At9ZlWGkXMv2JXLG5S6gIkl7b4gL7XU6QPjvFnzhoVZ17QDNR1xKAXoDbVXwZl
	ulNkkXjJf2WZS7hmXgqutodDf+ryCHupaSv3ejsn6rZJKvyR5b+fgckUkYKhfsNCyN3GDom6blT
	CLYVjScKM/UhHkLWgx9QnGsQirezAQKhbU4xZ8unEk5tdQJ5ZzXlq3k8sWAeElKs+CO/2JrSBlr
	3mSPdasuBHGYinvSVPVD4l8D1KwSOSIRXZYXFX6MEV9DnoVodxuETOFbTmPeUSn8puBGWgS02SO
	jtBZ31/CX6JKgSvsgFr/ZYB0QawSJzFedgUXW1uE1Xcbj0p1kOm5QLuPYw8D0uzcLclBcVp/t8w
	v8wkt9EIDKqE9PO4rE1JoaWaP+aDswHtsiXhWDJAdm4ew==
X-Received: by 2002:a05:620a:2b90:b0:939:3712:77df with SMTP id af79cd13be357-939480e4a93mr1404504985a.21.1788284704506;
        Tue, 01 Sep 2026 10:45:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93917247209sm1093584585a.17.2026.09.01.10.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 10:45:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1SXf-0000000C5Bj-0yOq;
	Tue, 01 Sep 2026 14:45:03 -0300
Date: Tue, 1 Sep 2026 14:45:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260901174503.GB2847102@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
 <apcI6dnRaGRNdzN1@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcI6dnRaGRNdzN1@nvidia.com>

On Tue, Sep 01, 2026 at 10:18:33AM -0700, Nicolin Chen wrote:
> On Tue, Sep 01, 2026 at 10:13:11AM -0700, Nicolin Chen wrote:
> > On Tue, Sep 01, 2026 at 11:34:45AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
> > > 
> > > > @@ -463,14 +460,13 @@
> > > >  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
> > > >  
> > > >  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> > > > +		if (arm_smmu_is_realm_viommu(viommu))
> > > > +			return arm_realm_smmu_v3_init(viommu, user_data);
> > > > +
> > > 
> > > I think the realm vsmmu is going to require a different info struct
> > > than the normal psmmu case, isn't it?
> > > 
> > > If so it needs its own enum value.
> > > 
> > > It would be nice to see a draft patch showing how the real vsmmu works
> > > on top of the RMM spec for it. If we are using a viommu object then
> > > non-vsmmu case should be identical just with an option in the info
> > > struct to not create the vsmmu object.
> > 
> > Actually, the PSMMU-only viommu object in this series only adds a
> > type with no viommu data structure.
> > 
> > I've drafted the vsmmu case on top of the series, so it would add
> > a structure reusing the same IOMMU_VIOMMU_TYPE_ARM_SMMUV3 with a
> > flag:
> 
> Oh. I replied too fast that I didn't notice this is under the
> standard IOMMU_VIOMMU_TYPE_ARM_SMMUV3 used by non-secure vSTE.

The original patches were OK:

@@ -1055,6 +1055,7 @@ enum iommu_viommu_type {
        IOMMU_VIOMMU_TYPE_DEFAULT = 0,
        IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
        IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV = 2,
+       IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 = 3,

That's where everything should be placed, including your new struct
above.

Jason
