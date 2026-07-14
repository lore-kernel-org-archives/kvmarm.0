Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8910B37475E
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027717; cv=none; b=HILJA/EmusfMiAimbgyODTI13Z/uCbzzgMViYeiYbnyhRVsNJZ4vSnhAhk7x0xmHUUlAs8L7+z3lJx0KzqLyk3VgSXUBEnE9flaUCjEB2V8+mZxdlzAiDRV0Cn7j5tt1jmWQzorwRaqeCaluOGsrWk1vU6bseEOPV08amPV7xZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027717; c=relaxed/simple;
	bh=2ZKlsZHbsbSq2D9hX9sNTyFKSvPFILkOtnCKc7s0CsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2/gPK4YCPeLpVrAj378crDGdAEkE/eUVUYLWAAN8tL7X3aZFa2ZCG1osz3t2cVNwfBE33GKHk29z8n52sYJZa5kWMO62ky/5rKmB3BpmDT5fW9/YB51RdbGos9QKOE5s4ondlArWjw4atUn1c2Zev0wIhzdl4DmWOS5ox8g5tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NQM9mNNy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NQM9mNNy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A609B497;
	Tue, 14 Jul 2026 04:15:10 -0700 (PDT)
Received: from [10.2.197.112] (unknown [10.2.197.112])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C25EF3F93E;
	Tue, 14 Jul 2026 04:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784027714; bh=2ZKlsZHbsbSq2D9hX9sNTyFKSvPFILkOtnCKc7s0CsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NQM9mNNyCp6cRHauKW5WjnNOdDcrxe+6UELXga4Q3j/xCQQ6lKrWm+NjZ8gJJ8weT
	 CFyOW8VXyG0hUOp5Xn3kTbz43EcuhME0trgb0GknFhIArQl8LCGh8OSJHkG2A3mVXC
	 ffB3dEQJLqIHSyJxoCgY61HXA0CY8YnEWTircRIE=
Message-ID: <911474e2-c470-451f-b81c-4fd6cb1428b0@arm.com>
Date: Tue, 14 Jul 2026 12:15:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: Query per-VM capabilities when selecting vCPU
 features
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260714110329.12113-1-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260714110329.12113-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/07/2026 12:03, Fuad Tabba wrote:
> kvm_cpu__select_features() and kvm_cpu__configure_features() probe vCPU
> feature availability with kvm__supports_extension(), which issues
> KVM_CHECK_EXTENSION on the global /dev/kvm fd. That reports the host's
> raw capabilities, unaware of any per-VM restrictions.
> 
> Protected VMs support a subset of the host's features. The kernel
> reflects this on the VM fd (commit a3163dca4817 ("KVM: arm64: Use KVM
> extension checks for allowed protected VM capabilities")), while the
> global fd still advertises capabilities such as SVE that the VM cannot
> use. kvmtool then requests SVE in KVM_ARM_VCPU_INIT, which the kernel
> rejects.
> 
> Query these capabilities on the VM fd via kvm__supports_vm_extension().
> More generally, vCPU feature availability is a per-VM property and is
> better checked against the VM fd than the global one.

Sounds sensible to me. We do have this with CCA as well.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arm64/kvm-cpu.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> index ae5a6eb..3aa7684 100644
> --- a/arm64/kvm-cpu.c
> +++ b/arm64/kvm-cpu.c
> @@ -53,34 +53,34 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
>   static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
>   {
>   	if (kvm->cfg.arch.aarch32_guest) {
> -		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
> +		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
>   			die("32bit guests are not supported\n");
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_EL1_32BIT;
>   	}
>   
>   	if (kvm->cfg.arch.has_pmuv3) {
> -		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
> +		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PMU_V3))
>   			die("PMUv3 is not supported");
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_PMU_V3;
>   	}
>   
>   	/* Enable pointer authentication if available */
> -	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> -	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
> +	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +	    kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS;
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC;
>   	}
>   
>   	/* Enable SVE if available */
> -	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
> +	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SVE))
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
>   
>   	if (kvm->cfg.arch.nested_virt) {
> -		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
> +		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL2))
>   			die("EL2 (nested virt) is not supported");
>   		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
>   		if (kvm->cfg.arch.e2h0) {
> -			if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
> +			if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
>   				die("FEAT_E2H0 is not supported");
>   			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
>   		}
> @@ -123,7 +123,7 @@ static int vcpu_configure_sve(struct kvm_cpu *vcpu)
>   
>   static int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
>   {
> -	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
> +	if (kvm__supports_vm_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
>   		return vcpu_configure_sve(vcpu);
>   
>   	return 0;

