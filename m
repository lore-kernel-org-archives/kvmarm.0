Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A9B32B99F;
	Mon, 21 Sep 2026 08:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978706; cv=none; b=hVR8iIrgb8uU0ZBbILcU9/KHWy2FuM8VvI7SQdh4MGyD2jee4u/6rrd/Zmr+UyG4u/LmONRJ0VHnSZYX/Q9nIdDRmwuOkZW8z60w/1v2/eNO4V4O6qIJPr3dRI1eYLp+qBBldAwbPQahb5E9PwkZbTpbq9eGYoc5jz6wLsvwfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978706; c=relaxed/simple;
	bh=vniDW1I8X7qYwlGYXDC8mfYXtSw62denW+sd99k1LUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uVx0dZGxRZimsVWruYC6oAQhF+Kd6OzmE3ZX/ejKv1zo6TMbZ5lbJMERvtgPCJXiEGyqdr8Tox6OnWC+62KehXz69rQvi2ImJOt7ruk9y26JeXR35WXv9clwL7z1TzWKwYQmByOztOZMjonH+ntApUr7BS70mFZQIQrqy9Ew09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uqBFzJN1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uqBFzJN1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8470153B;
	Mon, 21 Sep 2026 01:18:19 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BECA3F86C;
	Mon, 21 Sep 2026 01:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789978703; bh=vniDW1I8X7qYwlGYXDC8mfYXtSw62denW+sd99k1LUs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uqBFzJN1Q+f4zBcCBayvG7TgzRHbO+m5peS6CUXB61TRmoGRL7Kb9bu/5zfGXz3jY
	 azCmZ+pzLC2vFH/r9HAU/d9zKSRelauGJ0JOaBUW+UDIqM5KQNY4872LA+w/cw17+A
	 8jAAVAkSLhWsZe8LD0p0+QH150iOdS4svKkNWYW8=
Message-ID: <fcad4fd1-ed6c-4357-920a-19d4de91c8a4@arm.com>
Date: Mon, 21 Sep 2026 09:18:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-6-suzuki.poulose@arm.com>
 <20260920213838.411DE1F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260920213838.411DE1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/09/2026 22:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] kvm: arm64: missing READ_ONCE() when reading untrusted host_kvm vm_flavor at EL2
> --
> 
> commit d04a2a8ee6aa64b39d1116da1e8bfebec72b4499
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
>      KVM: arm64: Track the type of VM in kvm_arch
>      
>      KVM arm64 has different types of VMs with all the different modes in which
>      the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
>      protected VM and normal VMs with pKVM. We might soon add other types,
>      e.g., Arm CCA Realm.
> 
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> index 459bd9eb7e4bc..57e2eef6d7426 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> @@ -432,7 +432,11 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
>>   
>>   	hyp_vm->host_kvm = host_kvm;
>>   	hyp_vm->kvm.created_vcpus = nr_vcpus;
>> -	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
>> +	if (kvm_vm_is_protected(host_kvm))
>> +		hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
>> +	else
>> +		hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
> 
> [Severity: Medium]
> Does init_pkvm_hyp_vm() evaluate the untrusted host memory directly without
> READ_ONCE()?
> 
> The pKVM EL2 trust boundary requires that data from host memory must be
> copied to private EL2 memory before validating or acting on it.
> 
> The macro kvm_vm_is_protected(host_kvm) evaluates host_kvm->arch.vm_flavor in
> the condition. The previous code safely used
> READ_ONCE(host_kvm->arch.pkvm.is_protected).
> 
> Could we wrap the host memory read with READ_ONCE() to prevent
> compiler-induced tearing or optimization issues?

Fair point. I have changed the above hunk to :

-       hyp_vm->kvm.arch.pkvm.is_protected = 
READ_ONCE(host_kvm->arch.pkvm.is_protected);
+       if (READ_ONCE(host_kvm->arch.vm_flavor) == VM_PROTECTED_PKVM)
+               hyp_vm->kvm.arch.vm_flavor = VM_PROTECTED_PKVM;
+       else
+               hyp_vm->kvm.arch.vm_flavor = VM_PKVM;
+


Cheers
Suzuki

> 

