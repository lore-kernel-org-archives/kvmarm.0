Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E0847988B;
	Wed,  2 Sep 2026 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354669; cv=none; b=bd1c9HW3m5GitjeI5lMhkb2W0Y9STDPmfAx6KPusvtEZRINV1G/K6GtyVfl893ydVplKrpGxk2OoD71RsBRH8Dgg+lJ9R4HPexrph51qpc58jTilDHFK3H7kwwJ25vRhTYoJE5ohrxKMmKDX6GQ9tr9neHJObLVlm9qM22mab3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354669; c=relaxed/simple;
	bh=8RDVjphGMT2EY4EWAqX83Bv0HQdJis+1/wyjgNmypO4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=N/FtgIlQ+W+zJFiWDFAhTFeMAA9/uhmPNJyVy5AXvfJh2mzD1Z7Es72HrHVduAH2bIdFRe7Adq+A2Gb56+BjcIdPhcHiS0CbK+eR+HeMi3DWoopwaJiEaGrnHyf5h156dMwkXMzBaUhLmvzI1CB4KiMQOq1Q6+gK/x5tU1rEC7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjTqpzq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjTqpzq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A611F000E9;
	Wed,  2 Sep 2026 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788354667;
	bh=nRLi1FBteYpjMUirky+hyusys6nAANuCHisJ2JsNe8k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AjTqpzq4q2LFSPFFt+yF0vXv5UNifGGusVKCrtWydIJ+Ib1DGqMErun1wVgdXn/1H
	 lU1n+rD9Cok863jcdsTklSuT6Y0QSauxCSRV+inADasqrGmuGTun/tsJhEpB2YwUFG
	 JGgxDB4x9N1wpwQ7KOaK5Bw3rrjHVPCEyqlYlZBXcmclfdxz23uEJ4mkQa5KawrX6e
	 PK2eOBHtzGLnlXN1mzewSMnuqCDJhTfczqRGiRuobPLXqqgegsCKBl3Pe/Covj9d2B
	 as4VOU1YWGFO52qoukHRQDiZfSAZU1c5ZnFEeOxWWYguRLa2uD4OVvWGAojYxp6ZYg
	 Dv1XgULDqf4kA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
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
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
In-Reply-To: <apcHoHKGoI7WNFXp@nvidia.com>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <apcHoHKGoI7WNFXp@nvidia.com>
Date: Wed, 02 Sep 2026 18:40:57 +0530
Message-ID: <yq5ajyp3ztlq.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Nicolin Chen <nicolinc@nvidia.com> writes:

> On Tue, Sep 01, 2026 at 11:34:45AM -0300, Jason Gunthorpe wrote:
>> On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
>> 
>> > @@ -463,14 +460,13 @@
>> >  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
>> >  
>> >  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
>> > +		if (arm_smmu_is_realm_viommu(viommu))
>> > +			return arm_realm_smmu_v3_init(viommu, user_data);
>> > +
>> 
>> I think the realm vsmmu is going to require a different info struct
>> than the normal psmmu case, isn't it?
>> 
>> If so it needs its own enum value.
>> 
>> It would be nice to see a draft patch showing how the real vsmmu works
>> on top of the RMM spec for it. If we are using a viommu object then
>> non-vsmmu case should be identical just with an option in the info
>> struct to not create the vsmmu object.
>
> Actually, the PSMMU-only viommu object in this series only adds a
> type with no viommu data structure.
>
> I've drafted the vsmmu case on top of the series, so it would add
> a structure reusing the same IOMMU_VIOMMU_TYPE_ARM_SMMUV3 with a
> flag:
>
> +/**
> + * enum iommu_viommu_arm_realm_vsmmuv3_flags - Flags for ARM SMMUv3 Realm
> + * @IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU: Indicates whether the Realm has
> + *                                             a guest-visible VSMMU instance
> + */
> +enum iommu_viommu_arm_realm_vsmmuv3_flags {
> +	IOMMU_VIOMMU_ARM_REALM_SMMUV3_FLAGS_VSMMU = 1 << 0,
> +};
> +
> +/**
> + * struct iommu_viommu_arm_realm_vsmmuv3 - ARM Realm VSMMUv3 parameters
> + *                                         (IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3)
> + * @flags: Combination of enum iommu_viommu_arm_realm_vsmmuv3_flags
> + * @reg_base: MMIO base address of the VSMMU in the guest VM
> + * @reg_top: MMIO top address of the VSMMU in the guest VM
> + * @aidr: AIDR register value of the VSMMU in the guest VM
> + * @idr: IDR register values of the VSMMU in the guest VM
> + */
> +struct iommu_viommu_arm_realm_vsmmuv3 {
> +	__aligned_u64 flags;
> +	__aligned_le64 reg_base;
> +	__aligned_le64 reg_top;
> +	__aligned_le64 aidr;
> +	__aligned_le64 idr[7];
> +};
>
> I think this should work. But I still feel awkward that a non-vsmmu
> case has to allocate a viommu object for a set of RMI commands that
> don't need an Realm Descriptor. Things could be cleaner if we allow
> RMI_PSMMU_ACTIVATE and RMI_PSMMU_ST_L2_CREATE to be independent on
> a viommu; then leave IOMMU_VIOMMU_TYPE_ARM_SMMUV3 to vsmmu-visiable
> case.
 
RMI_VSMMU_CREATE requires an RD, RD won't be available during
viomm_alloc right?

-aneesh
