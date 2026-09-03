Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF3E37188A;
	Thu,  3 Sep 2026 05:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414539; cv=none; b=OxwP/Ax/7tF2UNLNzxAZh6FKxHwW/N53DlakdFkbAxilFzhYZBCx6IU2L/kV6Jb6Z1Bea7SwqamzI+VC0W5GRzb38NvBLG8PTbUB6YSIVXDiIoDTfSmIY80IAlEtOoEyBar//PcAhCEdZneL5lJLThFcOtxM7d2PuL263LY1nqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414539; c=relaxed/simple;
	bh=yzuJBxIRtaIfQsH1de3sgHj464RsqHc8IKoLu0fnB+M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=u50iLYnlQ8eVZBQExKdXZP7aGwAeThHYFwFVMDg44ZdbLfXwtru+Tp/54WuJzFUoansFE1iWZzWsvc6zlRur9XKum8ZQOSFu9L0bzSHaHlB3cyWAXCCm/KrdhPmoYsZu6BLSemZhJzaoDBxukpRUI06ZzE3o81Ix3FJAIeYl94w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPjdHGnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPjdHGnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B067B1F000E9;
	Thu,  3 Sep 2026 05:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414537;
	bh=5NNeIbtC3B5Ouf6ooroHN5kj+0AOD3+qypfVw4RP8Ow=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FPjdHGnG1RS4rnYNG4qC5oRYYol5VjixtNrmfVkcj8vFliZN7Te2jtt+feu55/AVb
	 rb0IyWQs5M+p36QNKkqdkwY+GeCIG9TsbIFsCPxygCw0ABafofJEYF3Mzgk65Ebgo1
	 KMTZQcakrrmAHJbJWtY3WViUih/OH5bkVFq4C2Iod4VFUIIC6TTkImPrrhLjdIKEHV
	 BMe73Vu5A+nvS80UVV1s6Ji2PJfo8+l0a4t+CKkD6j0gkHtTCetAbFzPmVgnAvPeMo
	 LgdAP2hW1fELky9BNgq2JkK0so6SKd97UUIbzoesphHeZ+xNHEChV5nKGGj3EJwuGG
	 Q6CR2+xAwCIiA==
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
In-Reply-To: <20260902235609.GG2890729@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org> <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca>
Date: Thu, 03 Sep 2026 11:18:47 +0530
Message-ID: <yq5a8q5izxz4.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Wed, Sep 02, 2026 at 10:09:15PM +0530, Aneesh Kumar K.V wrote:
>> static int arm_realm_smmu_v3_vdevice_init(struct iommufd_vdevice *vdev)
>> {
>> 	struct device *dev = iommufd_vdevice_to_device(vdev);
>> 	struct kvm *kvm = vdev->viommu->kvm_file->private_data;
>> 	struct arm_smmu_device *smmu;
>> 	struct arm_smmu_stream *stream;
>> 	struct arm_smmu_master *master;
>> 	unsigned long rmi_ret = 0;
>> 	unsigned long l2_sid;
>> 	int ret;
>> 
>> 	if (!tsm_is_configured(dev))
>> 		return 0;
>> 
>> 	master = dev_iommu_priv_get(dev);
>> 	/* FIXME which stream to pick */
>> 	/* At this moment, iommufd only supports PCI device that has one SID */
>> 	stream = &master->streams[0];
>> 	smmu = master->smmu;
>> 
>> 	l2_sid = ALIGN_DOWN(stream->id, STRTAB_NUM_L2_STES);
>> 
>> 	{
>> 		guard(mutex)(&smmu->realm.mutex);
>> 
>> 		if (!arm_realm_smmu_active(smmu))
>> 			return -EINVAL;
>> 
>> 		ret = rmi_psmmu_st_l2_create(smmu->base_phys, l2_sid,
>> 					     &rmi_ret);
>> 		if (ret || rmi_ret) {
>> 			if (!ret)
>> 				return -EIO;
>> 			if (RMI_RETURN_STATUS(rmi_ret) != RMI_ERROR_PSMMU_ST ||
>> 			    RMI_RETURN_INDEX(rmi_ret) != 2) {
>> 				dev_warn(dev, "failed to create realm stream mapping\n");
>> 				return -EIO;
>> 			}
>> 			/* The L2 stream table already exists. */
>> 		}
>> 	}
>> 
>> 	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
>> 	return tsm_bind(dev, kvm, vdev->virt_id);
>
> I think we should drop tsm_bind() as an abstraction. It doesn't make
> sense to take that round about path when we are calling RMIs directly
> above. It was intended to be an abstraction, but it isn't working out
> with this viommu based abstraction.
>

I was considering using the viommu only for explicit pSMMU/vSMMU setup,
SID/STE management, and realm stream-table creation. I expected other
operations, such as vdevice creation and lock/run state transitions, to
be driven by IOMMUFD ioctls and dispatched to the TSM backend through
abstractions such as tsm_bind() and tsm_guest_req(). This results in the
following split:

- Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
  stream-table creation.
- PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
- arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
  measurements, and IDE interaction.
- IOMMUFD: route userspace requests using the vdevice ID.


>
>> @@ -513,10 +514,16 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi,
>>  		if (copy_from_user((void *)&req_obj, req.user, req_len))
>>  			return -EFAULT;
>>  
>> -		if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
>> +		switch (req_obj.tdi_state) {
>> +		case RHI_DA_TDI_CONFIG_UNLOCKED:
>> +			return cca_vdev_device_unlock(pdev);
>> +		case RHI_DA_TDI_CONFIG_LOCKED:
>> +			return cca_vdev_device_lock(pdev);
>> +		case RHI_DA_TDI_CONFIG_RUN:
>> +			return cca_vdev_device_start(pdev);
>> +		default:
>>  			return -EINVAL;
>> -
>> -		return cca_vdev_device_start(pdev);
>> +		}
>>  	}
>
> This stuff cannot flow through sysfs. The VMM must support running in
> a sandbox so it cannot easially call out to sysfs while the VM is
> running. That makes the sandboxing more complex and ugly. The flow we
> have now relies on fd passing from the launcher into the sandbox to
> get things like vfio and iommufd into the VMM.
>

This does not go through sysfs. It uses the following IOMMUFD ioctl:

IOCTL_OP(IOMMU_VDEVICE_TSM_REQ, iommufd_vdevice_tsm_req_ioctl,
	 struct iommu_vdevice_tsm_req, tsm_code),

I need to spend more time considering your suggestion to handle guest
requests through viommu_ops rather than as TSM backend operations. The
split described below seemed more natural to me.

- Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
  stream-table creation.
- PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
- arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
  measurements, and IDE interaction.
- IOMMUFD: route userspace requests using the vdevice ID.

It is not yet clear to me whether operations such as MMIO validation
(TSM_REQ_VALIDATE_MMIO), setting the TDI lock/unlock/run state
(TSM_REQ_SET_TDI_STATE), querying TDISP object details
(TSM_REQ_OBJECT_INFO), and reading or regenerating TDISP objects
(TSM_REQ_READ_OBJECT and TSM_REQ_REGEN_OBJECT) belong in viommu_ops.

Meanwhile, I will clean up my changes and post them as a patch series so
that we can review them more closely?

>
> So these actions really should work the same way unless there is a
> strong reason to do otherwise.
>
> Given these are all acting on bound devices, and those can only be
> created by iommufd, it makes more sense to feed the operations through
> iommufd into the viommu and vdevice ops. AMD wanted to create such
> general command ops anyhow for their viommu emulation (non cc).
>
> And.. then you don't need struct pci_tdi. The vdevice is effectively
> the tdi and the existing locking scheme in iommufd for vdevice takes
> care of everything the tsm code was trying to do, except in a way that
> applies to every viommu out there.. This actually makes a lot of sense
> because the tdi is not really separable from vfio. You cannot have a
> tdi without a kvm and you cannot link a pci dev to a kvm without vfio.
>
> Finally, there is really nothing about the viommu_ops that has much to
> do with smmuv3. It would be fairly straightforward for the tsm_ops to
> be able to create the viommu and provide the viommu_ops. We can get
> there based on the IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3.
>
> This then would open up a much nicer split where arm-cca-guest.ko can
> provide a realm smmuv3, and inside those viommu_ops are all the realm
> & tdi related ops, psmmu, vsmmu, vdevice, "guest req".
>
> The arm-cca-guest can just make a simple function call to SMMUv3 to
> get the phys and interrupts. Somehow I think Will would like this
> better than adding to SMMUv3.
>
> Now that the viommu stuff is more developed on the iommufd end, and
> the RMM spec is more complete with vsmmu, I think this arrangement
> becomes visible.
>
> What do you think?
>
> Jason

-aneesh
