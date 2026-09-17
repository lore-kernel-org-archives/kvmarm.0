Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F611C84AB;
	Thu, 17 Sep 2026 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657035; cv=none; b=cioyNgJ9ff5485ZvWv3IB9OZYlCVXZa1xPQ8taNzJV/re4adRGndq/sjrS9XwncOXjMj9WDZ5lm1IZ1CneT6y1rkIgnzIfiNtgT42kU6blhi7LE/jrFp1WK8K5bz9+a0NGdijdCJrUiMFm2qRr8w1KFkV3U3wVpq1u44QLJbwys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657035; c=relaxed/simple;
	bh=eUxG9747wszXc+62EGP/WBFIfzWwzDqmVrDkyyASluY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7cU8PuQkSJbMCgtggi9gVtYyamSVQ7IuXQn0uDB5E/rYwdZJ4FsedlCZThexWmRymeFpXjYcM/5bFpZ24x3W2rLTyTaLdHZY12qYEFjOqmJENW9rLIs0mFv51H/ULNlwa7myRTpmDW67LM3OHjE7mD1IjsBW6YJd5oPZfo4Rkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TsyKfiEi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TsyKfiEi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 793A11AED;
	Thu, 17 Sep 2026 07:56:25 -0700 (PDT)
Received: from [192.168.4.158] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 717683FAF5;
	Thu, 17 Sep 2026 07:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789656989; bh=eUxG9747wszXc+62EGP/WBFIfzWwzDqmVrDkyyASluY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TsyKfiEiMhJBNLVveiQpLq85U6MQ93vNKCu3TgmqxqLIMIdSx9GBKJi8IP9JDllJU
	 7pB41kUm+a3xgdocm3fTfC/tvwzwS08OzoGuh1QpB/RhCCf+SCq70C29VDVUcQK7/O
	 UUmSYCXbKSoxUdqmV8OqGAfBjt9YCJrAmcFb3qlU=
Message-ID: <1ed53b83-a598-49c7-aa42-7736df87e2b1@arm.com>
Date: Thu, 17 Sep 2026 15:56:25 +0100
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
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-21-suzuki.poulose@arm.com>
 <CA+EHjTwYqTFzGdNPproWW5L6j5pNqmuWeFuu9HbHa8LBLPvY2A@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTwYqTFzGdNPproWW5L6j5pNqmuWeFuu9HbHa8LBLPvY2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 14:16, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Tue, 15 Sep 2026 17:01:38 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
>> +static inline bool kvm_realm_ext_allowed(long ext)
>> +{
>> +        switch (ext) {
>> +        case KVM_CAP_ARM_PSCI:
>> +        case KVM_CAP_ARM_PSCI_0_2:
>> +        case KVM_CAP_NR_VCPUS:
>> +        case KVM_CAP_MAX_VCPUS:
>> +        case KVM_CAP_MAX_VCPU_ID:
>> +        case KVM_CAP_MSI_DEVID:
>> +        case KVM_CAP_ARM_VM_IPA_SIZE:
>> +        case KVM_CAP_ARM_SVE:
>> +        case KVM_CAP_ONE_REG:
>> +        case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>> +        case KVM_CAP_ARM_PTRAUTH_GENERIC:
>> +        case KVM_CAP_SYNC_MMU:
>> +                return true;
>> +        }
>> +        return false;
>> +}
> 
> I'd keep KVM_CAP_IRQCHIP in this list. api.rst has it advertising
> KVM_IRQ_LINE as well as KVM_CREATE_IRQCHIP, so the cap means in-kernel
> irqchip rather than GICv2, and the GICv2 case is already rejected by
> patch 18 in kvm_vgic_create(). It also keeps the two protected lists

Ack

> the same where the support is the same. And could this live in
> kvm_rmi.h, next to where kvm_pkvm_ext_allowed() lives in kvm_pkvm.h,
> rather than in arm.c?

 From what I remember, it creates weird header file dependencies. I
will see if I can resolve them.

> 
> [...]
>> +static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
>> +{
>> +        long ext;
>> +        int r;
>> +
>> +        r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
>> +        if (WARN_ON_ONCE(r < 0))
>> +                return false;
> 
> You told Sashiko my fix covers this one [1], but that fix changes
> kvm_pkvm_ioctl_allowed(), which this patch deletes, so the `if (r <
> 0)` has to go into this copy too. The guard you posted for the second
> finding still leaves the WARN reachable on pKVM and Realm hosts, which
> is the case the fix removed.

I had the chat with Marc about this and his recommendation was to
post my changes as they are and he would resolve the changes
while managing the conflict.

> 
> nit: kvm_arch_ is the prefix generic KVM uses for the hooks it calls
> into the arch. For two static helpers in arm.c, kvm_vm_ext_allowed()
> and kvm_vm_ioctl_allowed() would avoid the collision, and the same for
> kvm_arch_vm_ext_allowed() above.

Ack

Suzuki

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev/

