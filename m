Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A783B47D0;
	Fri,  2 Oct 2026 09:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932838; cv=none; b=SenZ1NKGdL5wltCgm9IKUomwMMNbI+MbDzZoWkPw2rA5Ib45Fm+wJ0o91/HF/0Lc9QtBEaf8CV8o0P8soG+OYaR+DARgIrXWaLmz2T0OTpUV1UJtxfqSq9Tarj5c43JBoO5S3Weq+oOjpWPca9wHHztLNg26w076Ea+c7zNWHzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932838; c=relaxed/simple;
	bh=NiDPwnF91J1fElrQM+XOqR3EbPaFQvf5QeJhyPBAcs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tvb8cbXJl6LdbejXbglpVGMckAKLdXPiez72Tlg6g8IHxU8X1nndJj8awQQVeDewceCpiOz6V11svbheBhEci66dv8DtyzInFLXCzABNRhaUlJWRZG+LYuY68gxwgh9NoFnYX2F+ros+ZADYNnKolL9/LUptgfbgAAdeipdhk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kVni3wC7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kVni3wC7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE243497;
	Fri,  2 Oct 2026 02:20:30 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6A1A3F86F;
	Fri,  2 Oct 2026 02:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790932834; bh=NiDPwnF91J1fElrQM+XOqR3EbPaFQvf5QeJhyPBAcs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kVni3wC7f/qTgA063L/gEbfkL5Vy/kC4H8uyWTCs2um2/CQorXzR1TU+NnjXw1Vjz
	 kq/KGVFfbFf8VPdv9o6CtFoDJkFSEBblU08m/dpa+CB4Toy9jLMpMhEPJcwp1TF+dD
	 zemNRWJmmTOG+Wrx//RcIimAAw0a4SLnw+ZVFOxs=
Message-ID: <73ee7e2e-997b-4b19-9280-2d5a5d5c8deb@arm.com>
Date: Fri, 2 Oct 2026 10:20:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 18/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-19-suzuki.poulose@arm.com>
 <20261002091348.1769C1F00899@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261002091348.1769C1F00899@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 10:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] arm64: kvm: KVM_CAP_IRQCHIP incorrectly exposed for Realm VMs
> --
> 
> commit af0bceb4971b2a4c5816fbca6500c4f10a51388d
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
> 
> This commit limits the capabilities that are allowed for Realm VMs and blocks
> the corresponding vm_ioctls. It repurposes kvm_pkvm_ioctl_allowed() to
> support both pKVM and Realm ioctls and adds a generic kvm_vm_ext_allowed()
> helper for filtering.
> 
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 44f5c75a27b5b..ea1450e0c8619 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
> [ ... ]
>> @@ -58,4 +60,26 @@ struct realm {
>>   
>>   void kvm_init_rmi(void);
>>   
>> +static inline bool kvm_realm_ext_allowed(long ext)
>> +{
>> +	switch (ext) {
>> +	case KVM_CAP_IRQCHIP:
> 
> [Severity: Medium]
> The commit message states "Drop KVM_CAP_CREATE_IRQCHIP, as we don't support
> VGIC_V2 for Realms". Did you intend to drop KVM_CAP_IRQCHIP from this
> allowlist?

No, this was put back in based on Fuad's comment to advertise that 
in-kernel IRQ chip is supported.

See 
https://lore.kernel.org/all/CA+EHjTwYqTFzGdNPproWW5L6j5pNqmuWeFuu9HbHa8LBLPvY2A@mail.gmail.com 



Cheers
Suzuki


> 
> Because KVM_CAP_IRQCHIP is still explicitly allowed here in
> kvm_realm_ext_allowed(), userspace is falsely advertised VGIC_V2 capability
> via KVM_CHECK_EXTENSION.
> 

> This also allows the KVM_CREATE_IRQCHIP ioctl to bypass the
> kvm_vm_ioctl_allowed() check in kvm_arch_vm_ioctl() and attempt to
> instantiate an unsupported VGIC_V2 before being rejected downstream.


> 
>> +	case KVM_CAP_ARM_PSCI:
>> +	case KVM_CAP_ARM_PSCI_0_2:
>> +	case KVM_CAP_DEVICE_CTRL:
> [ ... ]
> 

