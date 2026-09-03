Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64E4EE867
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788455830; cv=none; b=PrWs6Imd3CeTgRvdjbKlv5Rk3HwgKGByhnuPhevdLtl2HtWPBC8u3Ao6AvwOukd1DXT9PahGTTLEPFy7og1VC0QE31EjoOdpzF0wtJ0s3C4YHO7oVygfXiYnmS7hStmZqSpO240rLVZBfQ+O9MNU6LUdoN4eaJ5izn6cZKPLH2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788455830; c=relaxed/simple;
	bh=1Vs/QSikNTCs7J6jqrx8XHtOqyj60Qiq6SQhxgAPom0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gaiq8GEYfXcVySxEuCsFQR0s9bde+FqFurj2O6DObqLaBDYeNFZhYveRT3IXO3WH2UYFpJxNSB7rhEhNT3XJAg7WGc04Vhih5oxm9Av3kuk2nz2xaGIraHbGPpFsUIPt5xQ9TvUkNIauUc8uYqTvfzGIMJdr39qa6tMdKM9990I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BQXoD03q; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BQXoD03q"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9390f8a1c9eso975185a.3
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788455827; x=1789060627; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AZhtG1wx2jm/FfrEGQtp35GRqcBVCx7bZi9IJYydKpM=;
        b=BQXoD03qk1ZRKenUH11peacE/saFclmnobDDWHVfp1CyKrgY7Yw3n3KhGViD/YN0XB
         nYMabPtqVcvzFiXalleli8v8kTR5VUMXq0+u2how8IqlEf115kV9rBaVZLOBrVz/SsHA
         7Wragpp5bvRlubP573i+sJR7MeDcFdya9uxNu0aHNpKihCC4m6qrn7InW3yLEk11WcPd
         /PH4HG/6OnlEcRM3o7VgHMjUJ1j1HSpl+NqGmPTHue+IKHaO7BddpBZJiAAT0moxNHiZ
         +fNqlWjvX3y5PCB/6zsez6i79oP/2QXZcyL+Xkwjg9S+s9/N0B5elEREvW4adw+o/4Ct
         cs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788455827; x=1789060627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AZhtG1wx2jm/FfrEGQtp35GRqcBVCx7bZi9IJYydKpM=;
        b=i1GgLuEc2eZdEtKUHIlkoOvNBM8xLFUXUsFQS/D7wz86S+wgVGwIfZw6985RsjPk4b
         gUjMnWbwppF8Cads+6n3bj9S4Z5JG7pvm5OXKmass3zy67PN4xVow049oadKxXKmF23f
         s1rwgjIoZXyTh10N2aHMuQyBMk4O0gN5RMkSCfibkh3ZBl+EK29XUL0XceEvg9BLmX0U
         +gCcma5sKtEu7GrEAjzKW6PqihKldocBubwmlc1avPLZjz6rrQ5Ckq0ZW79/AQHBEH+6
         OlvVMmDJSB9bdXfGf6xpWKDjQ0QwIrNBO5XNjZ/jY9NWR+/87qDS5EXW5m2TPIsxlOmB
         rwgA==
X-Forwarded-Encrypted: i=1; AKwUvBwka9Nq+Pt2P4VAob8OvxKrRdlrq+d389u/13gslc5wED/A8qzV5wCtg6sZXLcpXW+BAPW4dzs=@lists.linux.dev
X-Gm-Message-State: AFuF++kiEAAwVtpOzPr/twNBeJNqxlzwHL4f7BaExMGko1e6JrYJWRby
	GpwYfEE2ettb5V/ejAFWXNi1kNe3jUk1b/JA/gjSvWX53lk4jRZks2CmCiBB0GEEITM=
X-Gm-Gg: AYBFou3inlozCvYsTA50wZK4z7i4XhT4oPuGM/q0VBeRkcugIRSlU+VCVntvmUNyHhF
	DcBOPA9HvH0YIcW4tNZkpY+AtFcRw0YytwjHS00RjDOnYlAL28L8/sAAeJSwL11/ObOOvke6ja9
	lCijd6VE0IjHeEDroPG+rtFXIVMxCXW9TyOg1KFFyQnslEHPqjm1M0I7xLFOn0aZm0Y4uFHF7QN
	dxjdng1oo10dr7WKL9ee30bNQb4GEAT0cCoEu6sAy6tLMi7XWX5M6By5UYxsx4IO53F7Re256w4
	1C733t3HtHSVusSUiCV32yUi1CKhLDfEve97beKPCYKiz3tqHZkBFwpXrWH05fAVFygfSYaGlj+
	EqGwm4ZLVQg76S0fH56Q7mJ7Je3cJm47xEt1ok38EKZWBm/SDZptRbVbzas1Ad6VKNCMC+3hdpt
	VF8W7gLWccbwfiQr5WhvWY8N/PMXFX5Zi2WBd3BgUvFGMybiWHhCVFkJPUTRKWRSGiNf1RPXQYK
	U5+hJLU8O5/1RyYL1jNdzthSNnbmknSA15zdXC6NOQutuzkIdHQ59SMmg==
X-Received: by 2002:a05:620a:4448:b0:936:a407:98bb with SMTP id af79cd13be357-9396f65f15cmr827993085a.9.1788455826461;
        Thu, 03 Sep 2026 10:17:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb678b8sm13297985a.30.2026.09.03.10.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:17:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x2B3g-0000000HY70-3vJi;
	Thu, 03 Sep 2026 14:17:04 -0300
Date: Thu, 3 Sep 2026 14:17:04 -0300
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
Message-ID: <20260903171704.GK2890729@ziepe.ca>
References: <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <yq5aecfbzjyk.fsf@kernel.org>
 <20260902235609.GG2890729@ziepe.ca>
 <yq5a8q5izxz4.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a8q5izxz4.fsf@kernel.org>

On Thu, Sep 03, 2026 at 11:18:47AM +0530, Aneesh Kumar K.V wrote:
> >> 	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
> >> 	return tsm_bind(dev, kvm, vdev->virt_id);
> >
> > I think we should drop tsm_bind() as an abstraction. It doesn't make
> > sense to take that round about path when we are calling RMIs directly
> > above. It was intended to be an abstraction, but it isn't working out
> > with this viommu based abstraction.
> >
> 
> I was considering using the viommu only for explicit pSMMU/vSMMU setup,
> SID/STE management, and realm stream-table creation. I expected other
> operations, such as vdevice creation and lock/run state transitions, to
> be driven by IOMMUFD ioctls and dispatched to the TSM backend through
> abstractions such as tsm_bind() and tsm_guest_req(). This results in the
> following split:
> 
> - Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
>   stream-table creation.
> - PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
> - arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
>   measurements, and IDE interaction.
> - IOMMUFD: route userspace requests using the vdevice ID.

I don't really like it, I think the viommu code should handle the
VDEV and VSMU, TSM should handle SPDM.

"TDI state" is the existance of a iommufd vdevice, it doesn't make
sense to have a seperate "TDI state" concept and a parallel set of
APIs out side the iommufd object model that concretely defines the
lifecylce of the VDEV.

Is there a reason to have this split aside from it matches the tsm
prototypes that were sketched?

> >> @@ -513,10 +514,16 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi,
> >>  		if (copy_from_user((void *)&req_obj, req.user, req_len))
> >>  			return -EFAULT;
> >>  
> >> -		if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
> >> +		switch (req_obj.tdi_state) {
> >> +		case RHI_DA_TDI_CONFIG_UNLOCKED:
> >> +			return cca_vdev_device_unlock(pdev);
> >> +		case RHI_DA_TDI_CONFIG_LOCKED:
> >> +			return cca_vdev_device_lock(pdev);
> >> +		case RHI_DA_TDI_CONFIG_RUN:
> >> +			return cca_vdev_device_start(pdev);
> >> +		default:
> >>  			return -EINVAL;
> >> -
> >> -		return cca_vdev_device_start(pdev);
> >> +		}
> >>  	}
> >
> > This stuff cannot flow through sysfs. The VMM must support running in
> > a sandbox so it cannot easially call out to sysfs while the VM is
> > running. That makes the sandboxing more complex and ugly. The flow we
> > have now relies on fd passing from the launcher into the sandbox to
> > get things like vfio and iommufd into the VMM.
> >
> 
> This does not go through sysfs. It uses the following IOMMUFD ioctl:
> 
> IOCTL_OP(IOMMU_VDEVICE_TSM_REQ, iommufd_vdevice_tsm_req_ioctl,
> 	 struct iommu_vdevice_tsm_req, tsm_code),

I see, I saw this when I was grepping:

static ssize_t tsm_request_store(struct device *dev,
				 struct device_attribute *attr,
				 const char *__buf, size_t count)

Which the name and sysfs parts confused me, it looked like core
code. Turns out it is the sample driver.

> I need to spend more time considering your suggestion to handle guest
> requests through viommu_ops rather than as TSM backend operations. The
> split described below seemed more natural to me.
> 
> - Arm SMMU: pSMMU/vSMMU setup, SID/STE management, and Realm
>   stream-table creation.
> - PCI TSM: device association, bind lifetime, DSM lookup, and TDI state.
> - arm-cca-host: PDEV/VDEV operations, TDISP transitions, reports,
>   measurements, and IDE interaction.
> - IOMMUFD: route userspace requests using the vdevice ID.
> 
> It is not yet clear to me whether operations such as MMIO validation
> (TSM_REQ_VALIDATE_MMIO), setting the TDI lock/unlock/run state
> (TSM_REQ_SET_TDI_STATE), querying TDISP object details
> (TSM_REQ_OBJECT_INFO), and reading or regenerating TDISP objects
> (TSM_REQ_READ_OBJECT and TSM_REQ_REGEN_OBJECT) belong in viommu_ops.

They way I'm looking at it is the "TDI" is the RMM's VDEV.

The RMM VDEV has to be created from an iommufd vdevice and be 1:1 with
that. Thus the iommufd vdevice is the TDI.

Therefore, the struct cca_host_tdi should be the driver specific
struct of a struct iommufd_vdevice.

So if you want to get the information in the cca_host_tdi you have to
come in through the viommu ops with a vdevice object in hand.

This seems like a much cleaner logical seperation than trying to
maintain a cca_host_tdi external to the iommufd vdevice object that
actually directly controls its lifecycle.

So if you did this then the cca_tsm_guest_req would flow through some
generic viommu op similar to what AMD proposed:

struct iommu_viommu_op {
	__u32 size;
	__u32 vdevice_id;
	__u32 viommu_type;  // enum iommu_viommu_type
	__u32 operation; // unique enum per type
	__u32 req_len;
	__u32 resp_len;
	__aligned_u64 req_uptr;
	__aligned_u64 resp_uptr;
};

enum {
 IOMMUFD_VIOMMU_OP_CCA_OBJECT_SIZE
 IOMMUFD_VIOMMU_OP_CCA_OBJECT_READ
 IOMMUFD_VIOMMU_OP_CCA_UPDATE_INTERFACE_REPORT
 IOMMUFD_VIOMMU_OP_CCA_UPDATE_MEASUREMENTS
 IOMMUFD_VIOMMU_OP_CCA_VDEV_MAP
 IOMMUFD_VIOMMU_OP_CCA_SET_TDI_STATE

And none of the TDI information leaks out side the iommufd world.

The iommufd side change to introduce CCA support would then only be
adding the IOCTL for iommu_viommu_op and some fiddling with how the
viommu is created.

Then everyone can use the same infrastructure for their related
problems.

> Meanwhile, I will clean up my changes and post them as a patch series so
> that we can review them more closely?

Well, OK, but I'm am still very interested in focusing on the
viommu. I cc'd you on another thread so you can see the other topics
I'm looking at here that all come down to very similar patterns.

I think the TDI related tsm ops were developed well before iommufd was
completed and you have raised a good point now to re-evaluate if the
we even need them since we now understand that the iommufd vdevice is
in fact the concrete TDI object in the uAPI.

Jason
