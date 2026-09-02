Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7F646C848
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788393377; cv=none; b=lNlLOYaWjI4iKpl6peyBj137LmfmgrWdpR3plhZH3ECYtQL9tgcDOUDlCxYnUUfs5Q2PkIpTksjfORiOS9W5YbE3bWKC1kzrZDjPYypaxmiuiAiqXNAD5aem40nTzB0uuRlB9TPwTSCwddVn+VbluDtOhSEu7EVNhY9b1PMz+4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788393377; c=relaxed/simple;
	bh=oGFB4tUe4uIiJbL6QZtviPmqaClzJ2Rpq67zK1xKdQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfnkWOjW2lJeESSovupxj66VABtuGwm7SAT8Qof3PW1ZXk016c9Ul2zGMi+WaHU1zbnWrbyS4mdKmhDETwFd/aGNJLVM2sdc+q+r/lXHa1IYdL1g3rxqq1Ip5Y4x5WFCyzVxL2FaE5iuOJT40e5KzDlqxDHmYvtvJhm5Jxv3p14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=iSzURWR1; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="iSzURWR1"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9390f8a1c9eso137310985a.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 16:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788393371; x=1788998171; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JHkE0KygFhIS9HXgLrJJS0y5ES5oOeyv4LpvZ/FUmdg=;
        b=iSzURWR1QQFXKc79Dw+fS8617rh+lSRMLV9Uk0r0TTt0LXXT05h9xcotHrXWd072jF
         pkCHbTiA7631VtVjmJ/R9mw0QEnYBJO5vZpw0V9iVuINkYxQUtk56t5LX4R2jwGbFRq+
         T7e68pssXK/dxGgddK6v3MZoCxwgyH9O5jaGDNdFTNGnrkAmo68QW0VZ1MTsujfkfZ3r
         MHc94rNdJj1DlpjoXPV6QvQeh5qD2MovMm/1XJHNuoRYu4PIRuh6Fx94noOaWXHlmseY
         Q+z0E3gf7XJAnjgmmyLiLs/Yu2qVvCY7rTSVHFMa3wWDtyxjBzXN994n2QqE2adeywpM
         v9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788393371; x=1788998171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JHkE0KygFhIS9HXgLrJJS0y5ES5oOeyv4LpvZ/FUmdg=;
        b=rzHyw/woGTzA6q9PdblW4/J+yVEhY3XJySbhwCcEyovuPxAo1EHEVr+gL50wIVawjt
         Fnw73qOLNcox5ySnLw0Jz9amqJ7FlVbM18YhyPtUoHmYZT045UDRNZse3FKaar0m5Z5F
         0dxcpH8xbFnJLi3018V09NyKqjLPuOd/lL/gp8SYldOlMUByBv9qrRfbAgQ1mRwIka/J
         ojePWf0fgDojtQVuLp5mAJv0aT25Mrtume+mSvTbQWDBT07olEl1v8Xj0WVqEnHyvQfG
         kDcDYGkduJbjjfltpns6VgzNztvG+kBag6pL1bYzk1e2yDZ1eK0ZaW7c2QTvF9Kda3wQ
         fX6w==
X-Forwarded-Encrypted: i=1; AKwUvBzYP2JsOdBRq8ZlrtzZsH2ZUoeoehahJh04wq/GNCm2T7014mq0WV76lG9O9OM8GPghYNhF9Lk=@lists.linux.dev
X-Gm-Message-State: AFuF++n7oMYlZFj1cU7F3oYksqizr3wFCsYOarJPUyw5IS7qiZsdjyOu
	TbVCNO5328Y+kEUUol41JCvt8jzK9Q4njasB4UawsBHHP3AcRSoA3cFZvm5q7uHmWSQ=
X-Gm-Gg: AYBFou0lIFBC45XRyLLPGPoHNrxXdJKCvXr6kCYRBaOrnv52d1OtHQ1qIfvu94vtiqo
	To6YJuQMWQB5P1hdvq4wT5ROXmAAGOy2t4EvkzCzZe5z5gh6iFiCTkdC5h6sAUXL359nMxjPuaT
	3oDex+ep2F4DYlUaad0/x7THjQO4905vCzIW9F4jg/ustmDmqju3XuCsXRMU6SwJ/6Nsh6Id35D
	6VOWDo2xdfm5VFiv5aZuw9UJeUApqAmufF7jw5mVfSTZmbmngHCxTvfn8B8n/S1AVuc23LGXVdt
	TLZNY26Hy06JwLlvJXmnziMQxbhXjXO6+wTnEZ6+Grgs5cOJs/5Kp2xKsCUuvdVNt7pzklnvcnX
	zyIKKES2sc3YD9ZlXR8KoJqGY7aU5eNn76QnIJa87AcvA4WXeboKmIs57/7u+Ed+IMbF18Hf40M
	qcYeDwmRNbFzmGTwHertspYjXvOXydFaK+N4DqkpuLoju0UE6RH79iut14shT+YY/6p8v+znUOL
	B4PaNRFzKLT1dlhyUWzb/dlWcNsv1ft5Q6v3TBBVl/VSQ==
X-Received: by 2002:a05:620a:8c98:b0:92e:7ba3:73e5 with SMTP id af79cd13be357-939610139b3mr758596785a.42.1788393370920;
        Wed, 02 Sep 2026 16:56:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f3dd7easm362448885a.45.2026.09.02.16.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 16:56:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1uoL-0000000FTW5-1KK8;
	Wed, 02 Sep 2026 20:56:09 -0300
Date: Wed, 2 Sep 2026 20:56:09 -0300
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
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260902235609.GG2890729@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <yq5aecfbzjyk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aecfbzjyk.fsf@kernel.org>

On Wed, Sep 02, 2026 at 10:09:15PM +0530, Aneesh Kumar K.V wrote:
> static int arm_realm_smmu_v3_vdevice_init(struct iommufd_vdevice *vdev)
> {
> 	struct device *dev = iommufd_vdevice_to_device(vdev);
> 	struct kvm *kvm = vdev->viommu->kvm_file->private_data;
> 	struct arm_smmu_device *smmu;
> 	struct arm_smmu_stream *stream;
> 	struct arm_smmu_master *master;
> 	unsigned long rmi_ret = 0;
> 	unsigned long l2_sid;
> 	int ret;
> 
> 	if (!tsm_is_configured(dev))
> 		return 0;
> 
> 	master = dev_iommu_priv_get(dev);
> 	/* FIXME which stream to pick */
> 	/* At this moment, iommufd only supports PCI device that has one SID */
> 	stream = &master->streams[0];
> 	smmu = master->smmu;
> 
> 	l2_sid = ALIGN_DOWN(stream->id, STRTAB_NUM_L2_STES);
> 
> 	{
> 		guard(mutex)(&smmu->realm.mutex);
> 
> 		if (!arm_realm_smmu_active(smmu))
> 			return -EINVAL;
> 
> 		ret = rmi_psmmu_st_l2_create(smmu->base_phys, l2_sid,
> 					     &rmi_ret);
> 		if (ret || rmi_ret) {
> 			if (!ret)
> 				return -EIO;
> 			if (RMI_RETURN_STATUS(rmi_ret) != RMI_ERROR_PSMMU_ST ||
> 			    RMI_RETURN_INDEX(rmi_ret) != 2) {
> 				dev_warn(dev, "failed to create realm stream mapping\n");
> 				return -EIO;
> 			}
> 			/* The L2 stream table already exists. */
> 		}
> 	}
> 
> 	vdev->destroy = arm_realm_smmu_v3_vdevice_destroy;
> 	return tsm_bind(dev, kvm, vdev->virt_id);

I think we should drop tsm_bind() as an abstraction. It doesn't make
sense to take that round about path when we are calling RMIs directly
above. It was intended to be an abstraction, but it isn't working out
with this viommu based abstraction.

> @@ -513,10 +514,16 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi,
>  		if (copy_from_user((void *)&req_obj, req.user, req_len))
>  			return -EFAULT;
>  
> -		if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
> +		switch (req_obj.tdi_state) {
> +		case RHI_DA_TDI_CONFIG_UNLOCKED:
> +			return cca_vdev_device_unlock(pdev);
> +		case RHI_DA_TDI_CONFIG_LOCKED:
> +			return cca_vdev_device_lock(pdev);
> +		case RHI_DA_TDI_CONFIG_RUN:
> +			return cca_vdev_device_start(pdev);
> +		default:
>  			return -EINVAL;
> -
> -		return cca_vdev_device_start(pdev);
> +		}
>  	}

This stuff cannot flow through sysfs. The VMM must support running in
a sandbox so it cannot easially call out to sysfs while the VM is
running. That makes the sandboxing more complex and ugly. The flow we
have now relies on fd passing from the launcher into the sandbox to
get things like vfio and iommufd into the VMM.

So these actions really should work the same way unless there is a
strong reason to do otherwise.

Given these are all acting on bound devices, and those can only be
created by iommufd, it makes more sense to feed the operations through
iommufd into the viommu and vdevice ops. AMD wanted to create such
general command ops anyhow for their viommu emulation (non cc).

And.. then you don't need struct pci_tdi. The vdevice is effectively
the tdi and the existing locking scheme in iommufd for vdevice takes
care of everything the tsm code was trying to do, except in a way that
applies to every viommu out there.. This actually makes a lot of sense
because the tdi is not really separable from vfio. You cannot have a
tdi without a kvm and you cannot link a pci dev to a kvm without vfio.

Finally, there is really nothing about the viommu_ops that has much to
do with smmuv3. It would be fairly straightforward for the tsm_ops to
be able to create the viommu and provide the viommu_ops. We can get
there based on the IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3.

This then would open up a much nicer split where arm-cca-guest.ko can
provide a realm smmuv3, and inside those viommu_ops are all the realm
& tdi related ops, psmmu, vsmmu, vdevice, "guest req".

The arm-cca-guest can just make a simple function call to SMMUv3 to
get the phys and interrupts. Somehow I think Will would like this
better than adding to SMMUv3.

Now that the viommu stuff is more developed on the iommufd end, and
the RMM spec is more complete with vsmmu, I think this arrangement
becomes visible.

What do you think?

Jason
