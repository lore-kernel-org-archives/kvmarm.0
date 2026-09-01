Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B603A7F54;
	Tue,  1 Sep 2026 12:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266671; cv=none; b=tbNe0gK/j1MvN+bGR7+EcAQyij7EqcfNuStbAbLijCeP1GPKUsgJ+8y8vh/pDsXfU12mexaRkuS3U1Z6YC1O++nuAByDz+mu3gjeo+RzX9ROxY6Elx9l5YpOFtqgrmW3cp15h4JuV0p41HWrHoNKuOnhH3B8XV3OIp4joXikOUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266671; c=relaxed/simple;
	bh=lTIFVCbT44JWdCl33pIqGx6hasmFSd29i4Fq3DTtYzM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qzxrNbm5tZgjPH16m/1oQhHOhvnulZuzLvVUQN32Apyx/68nCPrVVCkZEs9RBlDsohUNh7ibtiFQdvmf6Ikth27rRVZQrzjhMLGRrW7n0kJv9GihAucsGCY7bnIcFIyeHLu41Ed5Jxud7SmlSS746nSAo0dTlpU+790FPFNVXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwhOO1V9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwhOO1V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24501F000E9;
	Tue,  1 Sep 2026 12:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788266670;
	bh=CR096vE5bRSe+2pGq3qMqD4kNPXWT2kota8/MmZ+zdM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RwhOO1V9niebNzIBzf1GvUNR1CzWvh4/WjqQebvqF3FWtC5HvBfKszwHDrpLqG2w8
	 xJGmLuZqdoscJgf10Vox5kEQC/57oeCFDXCL+sKG7dcs/2Yn1yN9RCTS38JlKx5jq5
	 Aoz6nm1cXhRzBviRz0gxqcB8OI6drxsMENHk3Ize9ihVMmRnuLu2/eCDmYAjqhekvK
	 qi/E0VXw5db1xVSPOnv5PtNwBOxabMiIVjDI+vRnQ3/Ima0jyRbHQYEs+OdRCz/eM+
	 7Sf/O1Gts3gjcnSGfp6DnQrn0ll3+mCB+3NYAUI4V4tyxwu0fnp7r2AMPniOFG9JPC
	 YTvpgD7hbHWMA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 00/16] coco/TSM: Implement host-side support for
 Arm CCA TDISP setup
In-Reply-To: <20260831180855.GA2171358@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260831180855.GA2171358@nvidia.com>
Date: Tue, 01 Sep 2026 18:14:19 +0530
Message-ID: <yq5aa4q1nnto.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Mon, Apr 27, 2026 at 02:23:28PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> 
>> This patch series implements the host-side changes needed for end-to-end
>> Arm CCA TDISP setup. It adds the RMI/RHI plumbing required to create and
>> manage Realm vdev objects, service device-attestation object requests, and
>> complete the KVM/RMM flows needed for device run-time transitions.
>
> So this is enough for the realm to see a physical PCI device inside it
> without any vSMMU inside the realm?
>

There are multiple series, and this is the final one:

1. arm-cca-guest series
2. arm-cca-host IDE setup series
3. iommufd interface for TSM operations
4. arm-cca-host TDISP support (this series)

>
> It is really weird to see a viommu for a case where there is no
> viommu..
>

We ended up with a viommu despite having no stage-1 SMMU or vSMMU
because it held the KVM reference needed by item (3) above [1]. With the
recent changes in that series [2], we now inherit the KVM details from
VFIO through iommufd_device_bind. I can possibly look at using the idev
for this instead.

[1] https://lore.kernel.org/all/20260309111704.2330479-2-aneesh.kumar@kernel.org
[2] https://lore.kernel.org/all/20260525154816.1029642-1-aneesh.kumar@kernel.org


> It doesn't do anything except manage memory for the RMM..
>
> It feels wrong that the arm-cca-guest module is calling
> RMI_PDEV_CREATE and RMI_VDEV_CREATE while the viommu is allocating STE
> memory for the PDEV. That doesn't make alot of sense? The STE is
> needed before VDEV_CREATE, right? So why not place it there in the
> flow?
>
> If that's changed then the only thing the viommu does is manage the
> PSMMU, which again, seems like something VDEV_CREATE needs, so why is
> a viommu involved at all?
>

We do not have a separate vdev-create operation; instead, we have
tsm_bind. The required iommufd objects (idev/viommu) are set up before
tsm_bind.

Currently, the primary reason for having a viommu is to obtain the KVM
reference. Now that the KVM details are inherited from VFIO through
iommufd_device_bind(), I can look at using the idev instead and dropping
the viommu requirement.

>
> The smmu driver involvment would be much smaller if it was only the
> interrupt routing and some helper to return the psmmu addr for a
> struct device that the arm-cc-guest module can call to manage the
> psmmu?
>

I designed this so that the PSMMU details are managed by the arm-smmu
driver, with minimal involvement from arm-cca-host. If the arm-smmu
driver does not set up the PSMMU correctly, tsm_bind, which is handled
by arm-cca-host, can fail.


> But I'm also sitting here scratching my head a bit, did the tsm_ops
> design go the wrong way? Should we have run more of that through a
> viommu instead of tsm_ops? Bind is sort of an illogical operation
> without a viommu, even if it is a nop viommu.
>
> I suppose it depends what it looks like when a real vsmmu is
> created.. That probably needs a special viommu object, and do we get
> into order problems if the lifecylce becomes split to tsm and viommu?
>
>> RHI v1.0 BET1 specification [5].
>> 
>> At a high level, the series adds support for:
>> - host-side vdev communication and lifecycle management
>> - host handling of RHI DA object read/size requests
>> - host-side fetching and caching of interface reports and measurements
>> - KVM handling of vdev request/complete exits
>> - KVM handling of map/validation exits and teardown on granule destroy
>> - vdev transition to TDISP RUN state
>> - enabling DA in Realm create parameters
>> 
>> The series builds upon the TSM framework patches posted at [2] and depends on
>> the KVM CCA patchset [3]. A git repository containing all related changes is
>> available at [4]. kvmtool repo is at [6]
>
> It looks like it also needs the series that adds bind to iommufd too
>
> Jason

-aneesh
