Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CD83E639B;
	Wed, 16 Sep 2026 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547391; cv=none; b=Bxlq1fuhQtlOJbf83dxAY03mxdLS+JeWBR7t3rw9T3rwDEpftojJ6dCqNFijjD4cyCra4F8kS/cz5I72BPNaAtq2Gvm9R9gbZYI/8esLucnvDXMofPlEfL3EWPHbtVysMCkGslJjkXnuTKOeEWrQWlH8GVMSCfjwSFHt8FvM9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547391; c=relaxed/simple;
	bh=y55ACC3MPUfOeusEzJNUnJR+YNOw7CmGAYFFZG69fOM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EUKgA15Dt1cIpe6EBJRvp31SWtLuNccxcwBTLI6OH9xjnPuwEjf1MB2wfKeIDO7S8wNrZM5XlH2AQ3501zuyGqP0/FdB4VnAYS280XjVUp2pICm9hcoouqMjG/KnjDrfcrkhadJIv6jii6waikSruutCc6YmZkavaRvKqOTjmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IVLNFXo7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IVLNFXo7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF092152B;
	Wed, 16 Sep 2026 01:29:45 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDA623F882;
	Wed, 16 Sep 2026 01:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789547389; bh=y55ACC3MPUfOeusEzJNUnJR+YNOw7CmGAYFFZG69fOM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=IVLNFXo7GeAU8Xo5pmHQ1MHSQ3ZU8IGha06VwIrdgjVX2p9OPrAwXhk7dujDGXGBj
	 CtC9UsgPBlBPaS0h/XPyJS+/ciKGCsXUQJ4HFHEmNlKYjAtEHZSyEt4hMpCRy6SzQP
	 wUps3ACm3E14i5O4dVE1QwXxXGqEcQEXXJCjWAAA=
Message-ID: <a53512f8-251b-4081-8d19-7957de3fc678@arm.com>
Date: Wed, 16 Sep 2026 09:29:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 20/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-21-suzuki.poulose@arm.com>
 <20260915164346.D49711F000FF@smtp.kernel.org>
 <6c3b2732-052c-47b8-905d-32aad2871ef8@arm.com>
In-Reply-To: <6c3b2732-052c-47b8-905d-32aad2871ef8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/09/2026 18:55, Suzuki K Poulose wrote:
> On 15/09/2026 17:43, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential 
>> issue(s) to consider:
>> - [High] kvm: host Denial of Service via WARN_ON_ONCE in 
>> kvm_arch_vm_ioctl_allowed()
>> -- 
>>
>> commit f9fdb12a2363dfa41ace289596ec2d2bd95cde48
>> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
>> KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
>>
>> This commit limits the capabilities allowed for Realm VMs and blocks
>> vm_ioctls backed by unsupported capabilities. It introduces generic
>> capability and ioctl filtering helpers kvm_arch_vm_ext_allowed() and
>> kvm_arch_vm_ioctl_allowed() to support both pKVM and Realm guests.
>>
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>> [ ... ]
>>> +static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, 
>>> unsigned int ioctl)
>>> +{
>>> +    long ext;
>>> +    int r;
>>> +
>>> +    r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
>>> +    if (WARN_ON_ONCE(r < 0))
>>> +        return false;
>>
>> [Severity: High]
>> Could this allow an unprivileged host userspace process to crash the 
>> host?
> 
> This is addressed by a patch from Fuad, hence I didn't try to fix that
> here.
> 
> https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev
> 
> 
>>
>> When kvm_arch_vm_ioctl() receives an unrecognized or garbage ioctl,
>> kvm_get_cap_for_kvm_ioctl() returns a negative value. This evaluates 
>> to true
>> and triggers the WARN_ON_ONCE() here. On systems configured with 
>> panic_on_warn
>> (which is common in production and Android environments), this results 
>> in a
>> kernel panic and a complete host denial of service.
>>
>> [ ... ]
>>> @@ -2150,7 +2202,7 @@ int kvm_arch_vm_ioctl(struct file *filp, 
>>> unsigned int ioctl, unsigned long arg)
>>>       void __user *argp = (void __user *)arg;
>>>       struct kvm_device_attr attr;
>>> -    if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, 
>>> ioctl))
>>> +    if (!kvm_arch_vm_ioctl_allowed(kvm, ioctl))
>>>           return -EINVAL;
>>
>> [Severity: High]
>> Does removing the is_protected_kvm_enabled() check expose the 
>> WARN_ON_ONCE()
>> above to all ARM64 KVM deployments?
> 
> Thats right, I will add the following check in the 
> kvm_arch_vm_ioctl_allowed()
> 
> if (!kvm || !kvm_vm_is_hyp_distrusting(kvm))
>      return true;

Thats not correct. It should be :

if (!is_protected_kvm_enabled() &&
     (!kvm || !kvm_is_realm(kvm)))
	return true;

Cheers
Suzuki

