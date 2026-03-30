Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42063BFE2F;
	Mon, 30 Mar 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774867974; cv=none; b=UIohcqqPWxcrxcdWOdR3X9xhttcrJMkYOgk6H3g4PsK3qDwwnuELw6tr8793GQjZ3EXdokWP+rfff/C9RTWaDAKQOhsdN3ZaYcWS6Hlm5NK02Hge8iXfB5QsB78Jgzqtfhy3E2y/jr1+H9WzKaodLWjI1NS0uyv6+6eWohYp3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774867974; c=relaxed/simple;
	bh=+19Be+jxc7eVo6ptCT9N5p5AxdrCYoGU6ESzG8t9WMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fYgPhsGm36R7/Wy/hI68pfTzAUSH1mCJrwR9QwDTYnMeqpQSh10xCGRPkX5IUDy7hmMJi+LHnT1xBOau21dvxWHoG64Soc5ZtG0kAqgfJQZ8DyUYcoa4p06pqoC2+paQHmladYayv/jkRKEPNHcpQ9b7Eo0pa+Xitz/GKOT5Rp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ww1bWqYF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ww1bWqYF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43A1B1C2B;
	Mon, 30 Mar 2026 03:52:47 -0700 (PDT)
Received: from [10.57.13.56] (unknown [10.57.13.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEE5E3F915;
	Mon, 30 Mar 2026 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774867973; bh=+19Be+jxc7eVo6ptCT9N5p5AxdrCYoGU6ESzG8t9WMM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ww1bWqYFHkJLZhcCE6e8ZBiflNW2C5IphbVCSs/zVp/vxuEClcMS56xJox2ODahwj
	 LRbyhNBB3fyWq5WX4kJWb+mBsO+xQWPASS6t7IPQrBSXBMZlSMjqaAR1bIi5HLon85
	 iF0M837dqYrazZwcQ7FR4BsQCvEpvt9PN+k5O8Co=
Message-ID: <4a2ab5b0-dec6-4ee2-8790-f27c2501f653@arm.com>
Date: Mon, 30 Mar 2026 11:52:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 32/48] arm64: Don't expose stolen time for realm
 guests
Content-Language: en-GB
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-33-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260318155413.793430-33-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2026 15:53, Steven Price wrote:
> It doesn't make much sense as a realm guest wouldn't want to trust the
> host. It will also need some extra work to ensure that KVM will only
> attempt to write into a shared memory region. So for now just disable
> it.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Update the documentation to add a note about stolen time being
>     unavailable in a realm.
> ---
>   Documentation/virt/kvm/api.rst | 3 +++
>   arch/arm64/kvm/arm.c           | 5 ++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index bc180c853faf..70911fe6d435 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -9240,6 +9240,9 @@ is supported, than the other should as well and vice versa.  For arm64
>   see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
>   For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
>   
> +Note that steal time accounting is not available when a guest is running
> +within a Arm CCA realm (machine type KVM_VM_TYPE_ARM_REALM).
> +
>   8.25 KVM_CAP_S390_DIAG318
>   -------------------------
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 61182eb0cf70..7d92ddb06460 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -469,7 +469,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = system_supports_mte();
>   		break;
>   	case KVM_CAP_STEAL_TIME:
> -		r = kvm_arm_pvtime_supported();
> +		if (kvm_is_realm(kvm))
> +			r = 0;
> +		else
> +			r = kvm_arm_pvtime_supported();

Could this be handled in kvm_realm_ext_allowed() ?

Suzuki


>   		break;
>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);

