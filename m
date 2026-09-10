Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF65447D928;
	Thu, 10 Sep 2026 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042691; cv=none; b=DnxQjJp5kPwypFuBkt0Nf/XlQTP1RKsHDTIBgHWfgvcwgitwSjTcYDuAxswgNEnPVpJglKTJdjXuTT6MO7Fcda4d8vFsLzoRBrQbcYHDIYXNqgDQa1xV4N9Ww3SkYY3iOdxCJaNFtA9e8rIPP73johkJXvwm+JYs10x+J67oSQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042691; c=relaxed/simple;
	bh=/o1gqsGEWGju65drSNTHsli+Gh3O7GdVtGdNySmI8Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fx17IQ0z9jIeYWGHWVDG4L7Zx2l15o9Ur02mtfGNLk2Jy36g4XoVrT6BrqIZFGCVTF3nAeH34Fa1cQxyRi0iOPUi/Yo9e6IqbxqMho9k9rIly1hyTFsdpL0YT7eG0JlXTCrWTKwSGIBvmamdJrEzqa+N6Lv2qFcuJe2WBLT6mX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=osmtq4ou; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="osmtq4ou"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BECE6153B;
	Thu, 10 Sep 2026 05:18:03 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C4603F7B4;
	Thu, 10 Sep 2026 05:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789042687; bh=/o1gqsGEWGju65drSNTHsli+Gh3O7GdVtGdNySmI8Fk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=osmtq4ou2BV/Sn7Abie/3hd3pOjobCCFAb9fIvFvZPeYM6GFPpdMj/+m4e/kSKYID
	 QNczvXzRNlixGoTfX+RXwmgRVo5Umu+T64PPDVFvppjzDw8PcHMLJWi0458wO4mFm3
	 gWvwLt7Oaa1YnutWOWqvfywplpE4e87exim9n83k=
Message-ID: <0d0d27fc-3f0f-48b2-96a3-2bce85c3a031@arm.com>
Date: Thu, 10 Sep 2026 13:18:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 14/20] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-15-suzuki.poulose@arm.com>
 <20260908165201.348181F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260908165201.348181F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/09/2026 17:52, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Redundant NULL check on the 'kvm' pointer in kvm_vm_ioctl_enable_cap().
> --
> 
> commit 849adae1adab6cdadc3f93c498689cfc52591e9d
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests
> 
> This commit restricts the extensions visible to realm guests to an
> allowlist, as RMM v2.0 provides no mechanism for the host to perform
> debug operations on the guest.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 3dfe0e03fab7a..fbb4d6651ab51 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> [ ... ]
>> @@ -148,6 +167,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
>>   		return -EINVAL;
>>   
>> +	if (kvm && kvm_vm_is_realm(kvm) && !kvm_realm_ext_allowed(cap->cap))
> 
> [Severity: Low]
> Is the kvm && check strictly necessary in kvm_vm_ioctl_enable_cap()?
> 
> Since this function is only called as a VM-level ioctl (dispatched from
> kvm_vm_ioctl() where the pointer is extracted from the file descriptor's
> private data), kvm is structurally guaranteed to be non-NULL in this
> context.
> 
> While kvm_vm_ioctl_check_extension() handles global /dev/kvm calls with a
> NULL kvm pointer, this function does not appear to need the same check.

Ack, I have addressed this now.

Suzuki

