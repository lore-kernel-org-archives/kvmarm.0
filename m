Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD81949E5E6;
	Tue, 15 Sep 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494957; cv=none; b=K8ZVXDKF5qbBY00Ytf259AJlhWu3RkeLUb9nRUNkIQnxDC5hR0Lu+g1WQFLeZrJaabNFYAKjuX8AwhO3/syZFX6Q4qz0mERfx9/zLzVbSpXQuqFIWAM5sajQ70b7b6F2h/XIy/5fts98Or+wa3en8cdmSuQjqW9pPEzGvldbmgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494957; c=relaxed/simple;
	bh=Bi9WYGYa04ZRQP6ojfMNWwEDbq7oWgxz3zcWLJs+aEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lbp2jXeQBDQr+4zyKBTQVKOroLJ4gXZUIqdI+yhmwvxuB/05k8v5t1pBO6khRNiOHgsHepl5r+JLWmXp900Mnr08BM1pW/CGSOIPCj06m82qwwR3Djqir7a2rmuigybCeXSvTfp/rt+I7h6P0C0Tn4ctFhiqoElbRijmImnhfdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mzyzaLd2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mzyzaLd2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DABC153B;
	Tue, 15 Sep 2026 10:55:45 -0700 (PDT)
Received: from [192.168.1.148] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6443F7B4;
	Tue, 15 Sep 2026 10:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789494948; bh=Bi9WYGYa04ZRQP6ojfMNWwEDbq7oWgxz3zcWLJs+aEM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mzyzaLd21WEQeB7PE6sp+qWgfG2XXOTx2oN4bXAHvud1A6vZ0S9r4BR9QJC1Uts++
	 FDhj2Q9Xz9ZUBh/Ki17i2Ekwz2zB8OzwZSO6sL/9wZIFqr3GWF8wgmOCGah25gnPyK
	 +uxGSOtFtiN0GHqbmMmV0NcnF0aU4Q6Hm0KQeFYM=
Message-ID: <6c3b2732-052c-47b8-905d-32aad2871ef8@arm.com>
Date: Tue, 15 Sep 2026 18:55:46 +0100
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
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-21-suzuki.poulose@arm.com>
 <20260915164346.D49711F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260915164346.D49711F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/09/2026 17:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: host Denial of Service via WARN_ON_ONCE in kvm_arch_vm_ioctl_allowed()
> --
> 
> commit f9fdb12a2363dfa41ace289596ec2d2bd95cde48
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
> 
> This commit limits the capabilities allowed for Realm VMs and blocks
> vm_ioctls backed by unsupported capabilities. It introduces generic
> capability and ioctl filtering helpers kvm_arch_vm_ext_allowed() and
> kvm_arch_vm_ioctl_allowed() to support both pKVM and Realm guests.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> [ ... ]
>> +static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
>> +{
>> +	long ext;
>> +	int r;
>> +
>> +	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
>> +	if (WARN_ON_ONCE(r < 0))
>> +		return false;
> 
> [Severity: High]
> Could this allow an unprivileged host userspace process to crash the host?

This is addressed by a patch from Fuad, hence I didn't try to fix that
here.

https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev


> 
> When kvm_arch_vm_ioctl() receives an unrecognized or garbage ioctl,
> kvm_get_cap_for_kvm_ioctl() returns a negative value. This evaluates to true
> and triggers the WARN_ON_ONCE() here. On systems configured with panic_on_warn
> (which is common in production and Android environments), this results in a
> kernel panic and a complete host denial of service.
> 
> [ ... ]
>> @@ -2150,7 +2202,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>   	void __user *argp = (void __user *)arg;
>>   	struct kvm_device_attr attr;
>>   
>> -	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
>> +	if (!kvm_arch_vm_ioctl_allowed(kvm, ioctl))
>>   		return -EINVAL;
> 
> [Severity: High]
> Does removing the is_protected_kvm_enabled() check expose the WARN_ON_ONCE()
> above to all ARM64 KVM deployments?

Thats right, I will add the following check in the 
kvm_arch_vm_ioctl_allowed()

if (!kvm || !kvm_vm_is_hyp_distrusting(kvm))
	return true;

Suzuki


> 
> Previously, the warning in kvm_pkvm_ioctl_allowed() was strictly guarded by
> is_protected_kvm_enabled(). By unconditionally calling
> kvm_arch_vm_ioctl_allowed() for all VMs, any local user with access to
> /dev/kvm can open a VM file descriptor and issue an unrecognized ioctl to
> trigger the warning. This exposes the panic condition to all ARM64 KVM
> deployments rather than strictly limiting it to pKVM configurations.
> 

