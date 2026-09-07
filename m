Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3617E44C673;
	Mon,  7 Sep 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774337; cv=none; b=GNIIWYZv1iX81kRHPDTe0n8/qpVVqX78rAy8nK+t6sH/RChMZ7bxTBA+1TBypXutHudN20237Sj5ErGMLB2jkxZdaqor7TEKHWJC9P6YKURhj9Uzurpn2GGR6jreUgSCvfzMKneTbPfUkhFrYYoFoDoxk1fwXBiEyADSpntLnic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774337; c=relaxed/simple;
	bh=ATFtbkzsK2fY+CD2/B3SbCwrAQo54+MJnCrTu1Yu5Zw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VQDyCNOJDdxCXfGRAnZfDgZHASG0rjKiFoY00fUj28bqGjXPHvsaz/hq7oQy/M2U4S89G0IFUj25EHYcobRtWkyrKxGHFDFlW4ssDjQTZ+C0JGbyHlI+zfIHQQtfyIWRlNl5kl1nbIr5juEy3LFtbc1WZ6I6Qh7e9BY16EHeJps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnQmDmS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnQmDmS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA0D1F00A3A;
	Mon,  7 Sep 2026 09:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788774335;
	bh=oLCn0KgbFmIoow0NeU2GgukIdukaCaZZQCZAnw7zNiE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZnQmDmS+AyL0DKSG58BunmmV7U44TxA6pdjCyDOYyoPKxqOJIVYTkWQAKEhYaw6Fa
	 bpXQ/MYazqYRDUzCEDjJmg3kHx1VilxHdY2DNVygNfsI3ngSWCL+/4sglGnDz2ItRH
	 IeqnihEbPh54rT3zzj7yGCnQwtyB7oeEkZq8hHkLREZondj2MhD3IlALtuikfECRVb
	 f0gBclT8FI7tXTkgPZ4F+pPS78fpD3XhlJEFx7k7aNoDo56ckGKIYCYxBq/zjinLdD
	 qBiSxrwTrA33c8u31WE+0Xi/2QDFFxPE0sKZofq3KD1sM7SojzNzTWlNJOu1WbuzWi
	 zM+gFqcY1QELg==
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
In-Reply-To: <20260903171704.GK2890729@ziepe.ca>
References: <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org> <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca> <yq5a8q5izxz4.fsf@kernel.org>
 <20260903171704.GK2890729@ziepe.ca>
Date: Mon, 07 Sep 2026 15:15:25 +0530
Message-ID: <yq5acxupjsy2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Thu, Sep 03, 2026 at 11:18:47AM +0530, Aneesh Kumar K.V wrote:
>> >> 	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
>> >> 	return tsm_bind(dev, kvm, vdev->virt_id);
>> >
>> > I think we should drop tsm_bind() as an abstraction. It doesn't make
>> > sense to take that round about path when we are calling RMIs directly
>> > above. It was intended to be an abstraction, but it isn't working out
>> > with this viommu based abstraction.
>> >
>> 
>> I was considering using the viommu only for explicit pSMMU/vSMMU setup,
>> SID/STE management, and realm stream-table creation. I expected other
>> operations, such as vdevice creation and lock/run state transitions, to
>> be driven by IOMMUFD ioctls and dispatched to the TSM backend through
>> abstractions such as tsm_bind() and tsm_guest_req(). This results in the
>> following split:
>> 
>> - Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
>>   stream-table creation.
>> - PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
>> - arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
>>   measurements, and IDE interaction.
>> - IOMMUFD: route userspace requests using the vdevice ID.
>
> I don't really like it, I think the viommu code should handle the
> VDEV and VSMU, TSM should handle SPDM.
>
> "TDI state" is the existance of a iommufd vdevice, it doesn't make
> sense to have a seperate "TDI state" concept and a parallel set of
> APIs out side the iommufd object model that concretely defines the
> lifecylce of the VDEV.
>
> Is there a reason to have this split aside from it matches the tsm
> prototypes that were sketched?
>
>> >> @@ -513,10 +514,16 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi,
>> >>  		if (copy_from_user((void *)&req_obj, req.user, req_len))
>> >>  			return -EFAULT;
>> >>  
>> >> -		if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
>> >> +		switch (req_obj.tdi_state) {
>> >> +		case RHI_DA_TDI_CONFIG_UNLOCKED:
>> >> +			return cca_vdev_device_unlock(pdev);
>> >> +		case RHI_DA_TDI_CONFIG_LOCKED:
>> >> +			return cca_vdev_device_lock(pdev);
>> >> +		case RHI_DA_TDI_CONFIG_RUN:
>> >> +			return cca_vdev_device_start(pdev);
>> >> +		default:
>> >>  			return -EINVAL;
>> >> -
>> >> -		return cca_vdev_device_start(pdev);
>> >> +		}
>> >>  	}
>> >
>> > This stuff cannot flow through sysfs. The VMM must support running in
>> > a sandbox so it cannot easially call out to sysfs while the VM is
>> > running. That makes the sandboxing more complex and ugly. The flow we
>> > have now relies on fd passing from the launcher into the sandbox to
>> > get things like vfio and iommufd into the VMM.
>> >
>> 
>> This does not go through sysfs. It uses the following IOMMUFD ioctl:
>> 
>> IOCTL_OP(IOMMU_VDEVICE_TSM_REQ, iommufd_vdevice_tsm_req_ioctl,
>> 	 struct iommu_vdevice_tsm_req, tsm_code),
>
> I see, I saw this when I was grepping:
>
> static ssize_t tsm_request_store(struct device *dev,
> 				 struct device_attribute *attr,
> 				 const char *__buf, size_t count)
>
> Which the name and sysfs parts confused me, it looked like core
> code. Turns out it is the sample driver.
>
>> I need to spend more time considering your suggestion to handle guest
>> requests through viommu_ops rather than as TSM backend operations. The
>> split described below seemed more natural to me.
>> 
>> - Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
>>   stream-table creation.
>> - PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
>> - arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
>>   measurements, and IDE interaction.
>> - IOMMUFD: route userspace requests using the vdevice ID.
>> 
>> It is not yet clear to me whether operations such as MMIO validation
>> (TSM_REQ_VALIDATE_MMIO), setting the TDI lock/unlock/run state
>> (TSM_REQ_SET_TDI_STATE), querying TDISP object details
>> (TSM_REQ_OBJECT_INFO), and reading or regenerating TDISP objects
>> (TSM_REQ_READ_OBJECT and TSM_REQ_REGEN_OBJECT) belong in viommu_ops.
>
> They way I'm looking at it is the "TDI" is the RMM's VDEV.
>
> The RMM VDEV has to be created from an iommufd vdevice and be 1:1 with
> that. Thus the iommufd vdevice is the TDI.
>
> Therefore, the struct cca_host_tdi should be the driver specific
> struct of a struct iommufd_vdevice.
>
> So if you want to get the information in the cca_host_tdi you have to
> come in through the viommu ops with a vdevice object in hand.
>
> This seems like a much cleaner logical seperation than trying to
> maintain a cca_host_tdi external to the iommufd vdevice object that
> actually directly controls its lifecycle.
>
> So if you did this then the cca_tsm_guest_req would flow through some
> generic viommu op similar to what AMD proposed:
>
> struct iommu_viommu_op {
> 	__u32 size;
> 	__u32 vdevice_id;
> 	__u32 viommu_type;  // enum iommu_viommu_type
> 	__u32 operation; // unique enum per type
> 	__u32 req_len;
> 	__u32 resp_len;
> 	__aligned_u64 req_uptr;
> 	__aligned_u64 resp_uptr;
> };
>
> enum {
>  IOMMUFD_VIOMMU_OP_CCA_OBJECT_SIZE
>  IOMMUFD_VIOMMU_OP_CCA_OBJECT_READ
>  IOMMUFD_VIOMMU_OP_CCA_UPDATE_INTERFACE_REPORT
>  IOMMUFD_VIOMMU_OP_CCA_UPDATE_MEASUREMENTS
>  IOMMUFD_VIOMMU_OP_CCA_VDEV_MAP
>  IOMMUFD_VIOMMU_OP_CCA_SET_TDI_STATE
>
> And none of the TDI information leaks out side the iommufd world.
>
> The iommufd side change to introduce CCA support would then only be
> adding the IOCTL for iommu_viommu_op and some fiddling with how the
> viommu is created.
>
> Then everyone can use the same infrastructure for their related
> problems.
>
>> Meanwhile, I will clean up my changes and post them as a patch series so
>> that we can review them more closely?
>
> Well, OK, but I'm am still very interested in focusing on the
> viommu. I cc'd you on another thread so you can see the other topics
> I'm looking at here that all come down to very similar patterns.
>
> I think the TDI related tsm ops were developed well before iommufd was
> completed and you have raised a good point now to re-evaluate if the
> we even need them since we now understand that the iommufd vdevice is
> in fact the concrete TDI object in the uAPI.
>

I looked into this, and it becomes fairly complicated. We can move all
vdev/TDI-related code to arm-smmu-realm-v3.c, but that would result in:

1. Adding more CCA-specific code to the SMMU driver.
2. arm-cca-host continuing to own the TSM link setup (IDE).
3. Adding callbacks from the device communication helpers back into
   arm-cca-host, since device communication still goes through DOE.
4. Moving the device communication helpers to firmware/arm-rmm and adding
   something like:

static const struct arm_rmm_pdev_comm_ops cca_dev_comm_ops = {
	.send = cca_dev_comm_send,
	.get_cache = cca_dev_comm_get_cache,
	.refresh_stream_keys = cca_dev_comm_refresh_stream_keys,
};

The locking also becomes more complex. Unlocking a vdev can trigger a
stream key refresh, which is owned by arm-cca-host. Currently, the locking
is simpler, using pci_tsm_rwsem and pci_tsm_pf0::lock. With the SMMU driver
owning the vdev/TDI, we would have:

- pci_tsm_rwsem protecting the lifetime and registration state of
  pdev->tsm.
- pci_tsm::tdi_lock protecting the function's pci_tdi pointer.
- pci_tsm_pf0::lock protecting DSM-wide connect and disconnect operations,
  including probing and removing functions managed by that DSM.
- The lock associated with arm_rmm_pdev_comm protecting the shared PDEV
  communication buffers and cache state used for ARM RMM communication.

I have a working prototype, but it requires quite a bit of cleanup and
rebasing before it can be posted as a clean patch series. Let me know if
you still want to proceed with this approach.

In summary, this requires three subsystems (arm-smmu-realm-v3,
arm-cca-host, and firmware/arm_rmm) to interact closely, with clearly
defined locking rules. Previously, all of this was contained within
arm-cca-host.

-aneesh
