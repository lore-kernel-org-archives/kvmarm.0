Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AAE3EC811;
	Wed,  2 Sep 2026 09:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788339610; cv=none; b=g7WVPqQ2kCWA7lXSi5wLcqgkC5GVKLjFC0iIVsQ0geinARxxmFQ/kMDD8RQLsKjdhU4caUVuru/fDYcKJ0aHkp5pTh/DYDXB5UO8oFxHJm9mrV7K0wh9YgJmRVKxTb8e3qklwX69A1t/Zx99OeREJf8H2QnvbaGGDdlJzWYJ/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788339610; c=relaxed/simple;
	bh=RTuNo/vCd6tr9XWbXJARMNn8ie7kdLSH2vuxcvl2i1A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BHBAqs0xmcDtFPFl8g+9Df+0VTkhDaKejWDTzO+ejMxYDj7f4m3GaFnlf8L2bCaRDAwK1vD1raozCFoXIMasBC/U4GJpeTyS8ZO4oC2489Hxhx4Dy5sJ7/0VnCznE7mxRgMSWImlhD8/EtJOiHClNRYy80m8c2hm6M3UqSPyBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HT9rw3M2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HT9rw3M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F01F000E9;
	Wed,  2 Sep 2026 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788339609;
	bh=kGyhqwpoKTL0G6djLUzdmHXBsAx/+FUeg8O/vusz8V0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HT9rw3M2ril3h9HMMccrqUbRw18Y37zhmnmK/bItstsqPU4xvADrVr3rHRziehMDw
	 BOw4h8K19eDGvV5uEW9XBGFwwqKZpgEZHr2FBOCKTGra1KFISWVC2rLqTKmw+zAFta
	 x9RXu3uiPfFMY5S5Q2IO51/Spu0QzQzo0UY+f0A8s4fRaDqS+ZKVlIX5CTCp34qlwg
	 g+bYFUVyqj8wsMbDg7JBmHCuq2uyVf/pgX8yOO8mWpbeeJ/+Q7RFQYvj1lZqsWNWqx
	 PCYywxlsofp9l9u8saVOHj8DrFoOq3Emn4t2HB7mFhKBI+jQ61+t3rTzm/gk0c8+XT
	 RamxAu6k/gU2A==
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
In-Reply-To: <20260901143445.GC56830@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
Date: Wed, 02 Sep 2026 14:30:00 +0530
Message-ID: <yq5a8q5kkoz3.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
>
>> @@ -463,14 +460,13 @@
>>  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
>>  
>>  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
>> +		if (arm_smmu_is_realm_viommu(viommu))
>> +			return arm_realm_smmu_v3_init(viommu, user_data);
>> +
>
> I think the realm vsmmu is going to require a different info struct
> than the normal psmmu case, isn't it?
>
> If so it needs its own enum value.
>
> It would be nice to see a draft patch showing how the real vsmmu works
> on top of the RMM spec for it. If we are using a viommu object then
> non-vsmmu case should be identical just with an option in the info
> struct to not create the vsmmu object.
>

Based on feedback on other emails in this thread, I have now implemented
this without using a vdevice or viommu. This should make the CCA and
non-CCA cases similar.

This ends up adding:

modified   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4324,6 +4324,8 @@ static const struct iommu_ops arm_smmu_ops = {
 	.def_domain_type	= arm_smmu_def_domain_type,
 	.get_viommu_size	= arm_smmu_get_viommu_size,
 	.viommu_init		= arm_vsmmu_init,
+	.tsm_bind		= arm_smmu_realm_tsm_bind,
+	.tsm_unbind		= arm_smmu_realm_tsm_unbind,
 	.user_pasid_table	= 1,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {


and

+int arm_smmu_realm_tsm_bind(struct device *dev, struct kvm *kvm)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	int ret;
+
+	if (!kvm_is_realm(kvm))
+		return 0;
+
+	ret = arm_realm_smmu_get(master->smmu);
+	if (ret)
+		return ret;
+
+	ret = arm_realm_smmu_stream_get(master);
+	if (ret)
+		arm_realm_smmu_put(master->smmu);
+	return ret;
+}
+
+void arm_smmu_realm_tsm_unbind(struct device *dev, struct kvm *kvm)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	if (!kvm_is_realm(kvm))
+		return;
+
+	arm_realm_smmu_stream_put(master);
+	arm_realm_smmu_put(master->smmu);
+}

and tsm op iotcl now becomes

iommufd_device_tsm_op_ioctl()

	switch (cmd->type) {
	case IOMMU_DEVICE_TSM_BIND:
		if (!idev->tsm_iommu_bound && ops->tsm_bind) {
			if (WARN_ON_ONCE(!ops->tsm_unbind)) {
				ret = -EOPNOTSUPP;
				break;
			}
			ret = ops->tsm_bind(idev->dev, kvm);
			if (ret)
				break;
			idev->tsm_iommu_bound = true;
			iommu_bound = true;
		}
		ret = tsm_bind(idev->dev, kvm, cmd->tdi_id);
		if (ret && iommu_bound) {
			ops->tsm_unbind(idev->dev, kvm);
			idev->tsm_iommu_bound = false;
		}
		break;
	case IOMMU_DEVICE_TSM_UNBIND:
		__iommufd_device_tsm_unbind(idev);
		ret = 0;
		break;
	default:
		ret = -EINVAL;
		break;
	}

I am yet to clean up the changes. I just wanted to share that we can
possibly drop the vdevice/viommu requirement.

-aneesh
