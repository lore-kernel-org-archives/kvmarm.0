Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F281E51D
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732721080; cv=none; b=qKZnXzG9maTZslKp+02d4aXbNQ5914fncmGErCn2OguXUhO5ELLr1orBGBdXgRbURIXeRUYRkmokd9XginmxjP38Jw/Cp0axUOc7RW2ROru2VsBxzp477fH8+zcHsiTbcIo2oQUmO99V2A38O45qfhtoeaUn+hn+opLVyLp2Ptg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732721080; c=relaxed/simple;
	bh=k8Y+s9d1Ct44DQbkCmzZQEuJXJRcZKAzfiXcmPvCi0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1170WF6YCx2dAtcKMEwjN1UIuPG3kr4Hwb6Oij6GJ+s8s8Yg3q0eC9PqYnh43ALSpDh3wF23G8YQAM33ISeBO5HhrriEeFwFlmp/hcHW3mvcRLUcsMC/AvS4flcSM3DTlj06//YSkcruol9enx3Hr3eHmUGxH8KHu7ZB9IryCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F4161477;
	Wed, 27 Nov 2024 07:25:07 -0800 (PST)
Received: from [10.57.69.41] (unknown [10.57.69.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0519E3F58B;
	Wed, 27 Nov 2024 07:24:34 -0800 (PST)
Message-ID: <a7011738-a084-46fa-947f-395d90b37f8b@arm.com>
Date: Wed, 27 Nov 2024 15:24:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Bump KVM_VCPU_MAX_FEATURES
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241127145644.421352-1-steven.price@arm.com>
 <86a5dkvh9o.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86a5dkvh9o.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/11/2024 15:16, Marc Zyngier wrote:
> On Wed, 27 Nov 2024 14:56:31 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> When the KVM_ARM_VCPU_HAS_EL2 define was added, the value of
>> KVM_VCPU_MAX_FEATURES wasn't incremented, so that feature has never been
>> in the KVM_VCPU_VALID_FEATURES bit mask. This means the HAS_EL2 feature
>> will never be exposed to user space even if the system supports it.
>>
>> Fixes: 89b0e7de3451 ("KVM: arm64: nv: Introduce nested virtualization VCPU feature")
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> I might be missing something, and it's possible that
>> KVM_ARM_VCPU_HAS_EL2 is deliberately not exposed yet.
> 
> This is on purpose. I'm not planning to enable EL2 support until it is
> ready.

I did suspect that's the case - but it might have been better to knobble
it in system_supported_vcpu_features()/kvm_vcpu_init_check_features()
rather than 'hiding' it in the MAX_FEATURES. But hindsight is a
wonderful thing ;)

>> However I'm
>> working on v6 of the host CCA series and as part of that want to add a
>> new feature but and bump KVM_VCPU_MAX_FEATURES up to 9.
> 
> Well, I guess that defines some ordering then! :D

Indeed - I'll try to remember to include note about this "dependency" in
my cover letter. We're likely to need a few more rounds for CCA to be
ready, so hopefully NV will naturally be there in time :D

Thanks,
Steve

