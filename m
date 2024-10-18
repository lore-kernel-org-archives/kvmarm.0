Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E65D23207;
	Fri, 18 Oct 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729257431; cv=none; b=LV6+K6QdLpAzLljl5PmJDF5VLUm1N+invre1hoN4kb+/RpDvILnw/A6hwmiaGVWVoqbIv4dGRKhqay9rsr83j3831iijcohpVxASS/ZtBrXKy0r8+lfbRgvcsYKOQp41dtUzASXiymSEixhrDjU0GrIi/gwsnrYPEH0G8mzgpmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729257431; c=relaxed/simple;
	bh=CRuZ3sTqe9mSNn1sIhAKhwXzViKqDumbwdvc2Bdcg0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nccgnApr+KsmU1at4yEbJpR12PFsn1yr3q+Vyl84YZSD0fHvVtFlNtw/VaojpHKUENU/bHAQviZJmrfVLx5bAyCwVb8RO5fPxdYAhPyasL/zsm1JDjSFXZjOTCwlQ87qc0qjKrdYYXX/Rx3VUDwKj8kudrqrXD5Z3BJkgOtgcZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5DCBFEC;
	Fri, 18 Oct 2024 06:17:38 -0700 (PDT)
Received: from [10.57.64.219] (unknown [10.57.64.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D69BC3F528;
	Fri, 18 Oct 2024 06:17:05 -0700 (PDT)
Message-ID: <3595b13e-0b94-408b-a101-4140b4784bf6@arm.com>
Date: Fri, 18 Oct 2024 14:17:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 26/43] arm64: Don't expose stolen time for realm guests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-27-steven.price@arm.com>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-27-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/10/2024 16:27, Steven Price wrote:
> It doesn't make much sense as a realm guest wouldn't want to trust the
> host. It will also need some extra work to ensure that KVM will only
> attempt to write into a shared memory region. So for now just disable
> it.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 075c1b7306ff..bde1e0f23258 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -433,7 +433,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


>   		break;
>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);

