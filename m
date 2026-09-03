Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204EB4CA286;
	Thu,  3 Sep 2026 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788448406; cv=none; b=T0DbNBEHjS41RUqljzKu7MnNubs4SBxiHyoFF19HjA389OqMrwhRcTQ5+ru9+1AKzLwXwd+8eOjuW6PcqrErcZLo5Qw9f2SMUbPmqPD1U11Eaq0kTmiUtP48K3PSavE4TXUeZPoIfwco6BZ1hCt+sGPQJH9/7OpVZ4XMTuFhjw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788448406; c=relaxed/simple;
	bh=57j47RyZeNUjgjXsnOt5hbGdiXiuODI5u3NMZr+QVkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s8VSz759juu3ZvSiJ+y37rhWvbIdRc6vbTxiHzVFOdjNh6BCViHpEqvreg0v7L6+ZwMQvS0h+ywqKFQqhWRItSOH7kVt1DICadHAE41w+XZ+qIhkVOp9ll3feJnV01pc/b9jt+zn7NZA+XXJCWzQxnbrsaEaVYp8GGi6kHLey1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qJGrtaLe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qJGrtaLe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE4CA1596;
	Thu,  3 Sep 2026 08:13:20 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D3613F7D8;
	Thu,  3 Sep 2026 08:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788448404; bh=57j47RyZeNUjgjXsnOt5hbGdiXiuODI5u3NMZr+QVkM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qJGrtaLeOoudxOSt6YMXpLod14VkO5FrCtOCsE2Dn8K58P/B81zn9hbERHErZ3jeR
	 8WjlLFYel7f7Nzl+7B1xo8+I5RRJUOn5yL8rQTfD6QbnGGXlvB2Y6ENK7T4FbjAMSN
	 Itb4FzT/1cl3e5v34OcabChJ7cxRRhnfL/UHKLq8=
Message-ID: <39c8cec6-002f-456e-9e5e-7af2158047fa@arm.com>
Date: Thu, 3 Sep 2026 16:13:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
To: Jason Gunthorpe <jgg@ziepe.ca>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dan Williams <dan.j.williams@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Jonathan Cameron <jic23@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Pranjal Shrivastava <praan@google.com>, Robin Murphy <robin.murphy@arm.com>,
 Samuel Ortiz <sameo@rivosinc.com>, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
References: <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com> <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org> <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org> <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org> <20260902193014.GF2890729@ziepe.ca>
 <yq5abjaezyxl.fsf@kernel.org> <20260903144729.GJ2890729@ziepe.ca>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260903144729.GJ2890729@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2026 15:47, Jason Gunthorpe wrote:
> On Thu, Sep 03, 2026 at 10:58:06AM +0530, Aneesh Kumar K.V wrote:
>>> Do you mean the SMMUv3 driver triggers RD creation? That feels
>>> wrong. Did you mean the VMM just does it earlier?
>>
>> Currently, CCA creates the realm lazily as part of another operation.
>> Realm creation is triggered by kvm_arm_rmi_populate() or
>> kvm_arch_vcpu_run_pid_change()
> 
> Okay, that's not what I would have guessed. But critically is there
> some way for userspace to specify any realm creation parameters (like
> rpv, ats_plane and so one) prior to the lazy creation?

There would be, eventually. Based on the feedback from KVM arm64
maintainers, we are trying to keep the ABI as generic as possible as the
normal VMs. Thus, for now we have not included the Realm specific
parameter configuration (which was present in the earlier versions)
in the latest version of the KVM support.

We have some ideas on how to do the configuration step. e.g. for MEC,
see the following thread :

https://lore.kernel.org/all/46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com/


> 
> Why lazy? Why not just have userspace provide the creation parameters
> and create the RD right then?

Cheers
Suzuki

> 
> Jason

