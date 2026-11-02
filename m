Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611462;
	b=Lii/OwvitEmnQ4eNokt8ij3/6uVbcL1jJvjnPfZmcTlY9GT4cZOs491nc9S2uIRiLgLB
	 Ry3jjSJ15BqOuW2tXny9hEEtq+hwaO0OCnwZCnRNWezU/LclGeYB6OHtNc+X+bjzTRwoZ
	 1uhLCz0CFjS+YSMP1MXQ0uET+l+b8D1vIcU24J+0+jocrZ9zoMwVaE7rmms5iET94ajNe
	 UBIM3LcTK9/1YXTPcQhhm4+ZkFaf0GZJAemDQdtk39xFEsIbso32cJ1cVX59H44eNetPg
	 KV8zG5Qc7N+Vt/1UVhP09eL4p3roN5Z//Gj7IpX9LKjYmuokd+ACIFfmevVyq44FFCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611462;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9h7Gytq9HCPVXq2/X5UCkV4eCMg+CFGh9wukiXakeb0=;
	b=Zmwt1FFqclyS7ZyVbE59xR/nhxqhtRL3vEzAK0ZL4S51utnZtgPdIBwzFSA/5x2QXv+V
	 YNfNv0iatInfOSJXUJlP3i4dPAQk/CkrcDgsaH3MGxPsEZTqwyluMe24fpVTi4v8+zBPz
	 NFxMcKaB1pPV7fnyLXx0xI7P38yKpKQlh0GhPLDI8wPxnn/uFbUiBqOOUnSM5HQmrV91I
	 n2HOpViDruoGL3/hp62DXhR2Nikq+nz+OceHAn4/hbWbU6L+KnQY9iN56p0eB2a+aDD1e
	 curf7hv/tgWRIslGzV0NDDr3vtbsKSUIXr6RK4x80DABX5FaCkXbCSmrixN/h61OUuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JPCFEXT9;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81649606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81649606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JPCFEXT9
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 649281691;
	Mon,  2 Nov 2026 01:24:16 -0800 (PST)
Received: from [10.57.66.79] (unknown [10.57.66.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6574A3F59E;
	Mon,  2 Nov 2026 01:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793611459; bh=K1Dq/9I09sZWP43Xp3qaEUYCa73+ATXolgz26YaJ1Kg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JPCFEXT9IuhR/bA6QW0TCqOFPie0SNczPkWArQ6j6p0psmc/2iUd7C/NPS16WhaKp
	 3cc3n6plh2RtDLch0kqOTRqVcBbq/rlqSlLfdjQDTmB6aMkQVzO49B4ttqZOiq+hNn
	 R5IowOwJBmzGd6XgRc/uRmpDWyYXTDJM4Lx+WMe8=
Message-ID: <07d0afa8-1b9a-4991-a419-9840cf629d57@arm.com>
Date: Mon, 2 Nov 2026 09:24:15 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] KVM: arm64: Clear the VM's feature bitmap when
 kvm_setup_vcpu() fails
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Jack Thomson <jackabt@amazon.com>,
 Congkai Tan <congkai@amazon.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>
References: <20261102075843.2556018-1-fuad.tabba@linux.dev>
 <20261102075843.2556018-2-fuad.tabba@linux.dev>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261102075843.2556018-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/11/2026 07:58, Fuad Tabba wrote:
> KVM_ARM_VCPU_INIT records the requested features in the VM-wide bitmap
> before kvm_setup_vcpu() runs, and leaves them there when setup fails
> (e.g., HAS_EL2_E2H0 on a host without FEAT_NV1). The PMU attributes
> read that bitmap before the vCPU is initialized, so after such a
> failure with PMU_V3 requested, KVM_SET_DEVICE_ATTR on the PMU group no
> longer returns -ENODEV.
> 
> Until an INIT has succeeded, every INIT that gets past the feature
> checks rewrites the bitmap. After that, kvm_vcpu_init_changed()
> requires the requested features to match it, so the copy is a no-op.
> Clear the bitmap on failure while KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED
> is clear.
> 
> Fixes: 427733579744e ("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler")
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arch/arm64/kvm/arm.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 157bf4b812020..3e91e01b032c4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1856,8 +1856,13 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
>   
>   	ret = kvm_setup_vcpu(vcpu);
> -	if (ret)
> +	if (ret) {
> +		/* Clear the bitmap if setup fails on the first vCPU to be initialized. */
> +		if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))

Is this check necessary ? We go into kvm_setup_vcpu() only if the bit is
cleared and we do this under the config_lock mutex. The flag is only set
after we have finished the kvm_setup_vcpu() successfully, later down.

Otherwise,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> +			bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
> +
>   		goto out_unlock;
> +	}
>   
>   	/* Now we know what it is, we can reset it. */
>   	kvm_reset_vcpu(vcpu);

