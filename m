From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Tue, 25 Sep 2018 11:24:13 +0100
Message-ID: <75c3abc2-6518-9a4b-ea1e-01619489d535@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-19-suzuki.poulose@arm.com>
 <552680a6-23e6-001c-416e-214d1e8276c6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBD644A20B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Sep 2018 06:23:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVMVqVp7jg3I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Sep 2018 06:23:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0D7D4A0C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Sep 2018 06:23:17 -0400 (EDT)
In-Reply-To: <552680a6-23e6-001c-416e-214d1e8276c6@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 09/25/2018 11:00 AM, Auger Eric wrote:
> Hi Suzuki,
> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>> Allow specifying the physical address size limit for a new
>> VM via the kvm_type argument for the KVM_CREATE_VM ioctl. This
>> allows us to finalise the stage2 page table as early as possible
>> and hence perform the right checks on the memory slots
>> without complication. The size is ecnoded as Log2(PA_Size) in
> encoded

...

>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index c664064f76fb..f860251ff27c 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -122,6 +122,14 @@ the default trap & emulate implementation (which changes the virtual
>>   memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
>>   flag KVM_VM_MIPS_VZ.
>>   
>> +To configure the physical address space size for a VM (IPA size) on arm64,
>> +check KVM_CAP_ARM_VM_PHYS_SHIFT (which returns the maximum limit for the
>> +IPA shift) and use KVM_VM_TYPE_ARM_PHYS_SHIFT(PHYS_SHIFT). Bits[7-0] of the
>> +machine type has been reserved for specifying the PHYS_SHIFT.
> are reserved to pass the PHYS_SHIFT?
>> +The supported range is [32...IPA_LIMIT], where IPA_LIMIT could be
> s/could be/is



>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 07548de5c988..2a6b29c446db 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -750,6 +750,15 @@ struct kvm_ppc_resize_hpt {
>>   
>>   #define KVM_S390_SIE_PAGE_OFFSET 1
>>   
>> +/*
>> + * On arm64, machine type can be used to request the physical
>> + * address size for the VM. Bits[7-0] has been reserved for the PA
> s/has been reserved/are?

Thanks for spotting, fixed all the above.

Suzuki
