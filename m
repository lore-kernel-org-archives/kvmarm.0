Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F333D34AC;
	Wed,  2 Sep 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367170; cv=none; b=O/femh1NiqmQookI3drO/0ICSH5p34eG7EBRWXvLlvod/w2DgfDIjTSXpKW0ilM59zsJIe8B0+DrsnGHQRVam/GWd3TGu/OwBnjsc7tpTZYZHdr5mfdDPdd/HzDm0NPTPfIoorKtV7jVE0wd96YkgEYAymkK6Hgr79MeLKHL4Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367170; c=relaxed/simple;
	bh=Db3awz/KbnLfwISKxnK4Ng7LXl9bS23HPK6EwyZQFqM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EWy8bZN5i4v9uXPA3t8barEeHDtM9oce/jK+KPhiKB6zUuV3f/mvzgKUDtUSMQRQdNFWXqB1NbOp+Bbzuav0oZnii9A6H/b0qsbYKcmKHiK/ixSUJTYBcYejD3LpDwXCMGoi8bvOXvxg0gQMtNWRC3TMyTWxr5nor4QcL74w/Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDQvRkCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDQvRkCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6161F000E9;
	Wed,  2 Sep 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367167;
	bh=z0JXN1Qg8SKT1PqQszVSTrjn1xMyP8kvqiPKrKavDZM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LDQvRkCfft8OKugaNahjcHj8SPwPbh0Lsgz1FJf2bdguoDCEOmR60ruh6hw4HoZ4f
	 lkWCRjdQ6pdsTbghaNmiDzCl18HInwe4FMqj+Yn/gs4UyhvzpvjVFzE/9H7xOvXSPt
	 rSl3MVuAjgd1j0lNArjOmMS8VQDPLG55oNCJuzNAj1cQFT3zMs0QEFZSHy5KstIYS4
	 5oqTIzogNUJSCUe/ib2V9vZ1wo1CNG/jbQar1twhHlw8zr8okeQDvl/JPTNirSKPBp
	 b+AkHnbQLqcvkPxwgCW4rCWeQ+YKJiNl/76NHbcO8x6lfjduRo0gswP1nCsBMo5qkl
	 /nmD2hapvphsQ==
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
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
In-Reply-To: <yq5aik4nztdt.fsf@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
Date: Wed, 02 Sep 2026 22:09:15 +0530
Message-ID: <yq5aecfbzjyk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> Jason Gunthorpe <jgg@ziepe.ca> writes:
>
>> On Wed, Sep 02, 2026 at 02:30:00PM +0530, Aneesh Kumar K.V wrote:
>>> Jason Gunthorpe <jgg@ziepe.ca> writes:
>>> 
>>> > On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
>>> >
>>> >> @@ -463,14 +460,13 @@
>>> >>  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
>>> >>  
>>> >>  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
>>> >> +		if (arm_smmu_is_realm_viommu(viommu))
>>> >> +			return arm_realm_smmu_v3_init(viommu, user_data);
>>> >> +
>>> >
>>> > I think the realm vsmmu is going to require a different info struct
>>> > than the normal psmmu case, isn't it?
>>> >
>>> > If so it needs its own enum value.
>>> >
>>> > It would be nice to see a draft patch showing how the real vsmmu works
>>> > on top of the RMM spec for it. If we are using a viommu object then
>>> > non-vsmmu case should be identical just with an option in the info
>>> > struct to not create the vsmmu object.
>>> 
>>> Based on feedback on other emails in this thread, I have now implemented
>>> this without using a vdevice or viommu. This should make the CCA and
>>> non-CCA cases similar.
>>
>> That wasn't the feedback. The feedback was to use the viommu and not
>> make a bunch of new stuff..
>>
>
> That rework was done before I saw your discussion with Nicolin.
>
> To reiterate, for this configuration:
>
> - The viommu will use a stage-1 bypass configuration.
> - A new IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 type will create the viommu.
>   The psmmu will be activated at this point to avoid creating psmmu
>   objects early. We will reference-count it to ensure that the same
>   psmmu is shared across realm guests.
> - Creating a vdevice will invoke SMC_RMI_PSMMU_ST_L2_CREATE.
>
> I am unclear about the vdev_create suggestion. Creating a vdevice
> requires an RD, which is created later in the flow above. How do you
> suggest linking vdevice_alloc to vdev_create?
>


I was able to prototype the following flow:

 - The viommu uses a stage-1 bypass configuration.
 - A new IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 type creates the viommu.
   The pSMMU is activated at this point to avoid creating pSMMU objects
   early. It is reference-counted so that the same pSMMU can be shared
   across realm guests.
 - The realm is created during viommu allocation, ensuring that the
   vSMMU can be created here.
 - Creating a vdevice invokes SMC_RMI_PSMMU_ST_L2_CREATE.
 - This is followed by tsm_bind() if the device has an established TSM
   link.

static int arm_realm_smmu_v3_vdevice_init(struct iommufd_vdevice *vdev)
{
	struct device *dev = iommufd_vdevice_to_device(vdev);
	struct kvm *kvm = vdev->viommu->kvm_file->private_data;
	struct arm_smmu_device *smmu;
	struct arm_smmu_stream *stream;
	struct arm_smmu_master *master;
	unsigned long rmi_ret = 0;
	unsigned long l2_sid;
	int ret;

	if (!tsm_is_configured(dev))
		return 0;

	master = dev_iommu_priv_get(dev);
	/* FIXME which stream to pick */
	/* At this moment, iommufd only supports PCI device that has one SID */
	stream = &master->streams[0];
	smmu = master->smmu;

	l2_sid = ALIGN_DOWN(stream->id, STRTAB_NUM_L2_STES);

	{
		guard(mutex)(&smmu->realm.mutex);

		if (!arm_realm_smmu_active(smmu))
			return -EINVAL;

		ret = rmi_psmmu_st_l2_create(smmu->base_phys, l2_sid,
					     &rmi_ret);
		if (ret || rmi_ret) {
			if (!ret)
				return -EIO;
			if (RMI_RETURN_STATUS(rmi_ret) != RMI_ERROR_PSMMU_ST ||
			    RMI_RETURN_INDEX(rmi_ret) != 2) {
				dev_warn(dev, "failed to create realm stream mapping\n");
				return -EIO;
			}
			/* The L2 stream table already exists. */
		}
	}

	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
	return tsm_bind(dev, kvm, vdev->virt_id);
}

 - tsm_bind() calls cca_tsm_bind(), which in turn calls vdev_create().
 - After boot, the guest locks the device. This generates an RHI request
   that reaches cca_tsm_guest_req() with RHI_DA_TDI_CONFIG_LOCKED.
 - cca_tsm_guest_req() now handles TSM_REQ_SET_TDI_STATE requests for
   the unlocked, locked, and running states.

@@ -513,10 +514,16 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi,
 		if (copy_from_user((void *)&req_obj, req.user, req_len))
 			return -EFAULT;
 
-		if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
+		switch (req_obj.tdi_state) {
+		case RHI_DA_TDI_CONFIG_UNLOCKED:
+			return cca_vdev_device_unlock(pdev);
+		case RHI_DA_TDI_CONFIG_LOCKED:
+			return cca_vdev_device_lock(pdev);
+		case RHI_DA_TDI_CONFIG_RUN:
+			return cca_vdev_device_start(pdev);
+		default:
 			return -EINVAL;
-
-		return cca_vdev_device_start(pdev);
+		}
 	}
 
-aneesh
