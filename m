Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634359;
	b=X7wIDpfPZZydEe2Zu69RHm4afhNYeoeXigs4q4Qg8CeIj//NEYtKJhRgR383jwOsilAu
	 m/N5QaRegrYBt6rSF0WI3vIiaYjgvAQxB4J9ws2ge6zr2ZguxcQMzTAHk6xEia03xdMJ1
	 vEibQ0o8O6nbtgAYWoWSkQgK/NxVbqDzy+xkAkqxzb5+mjUz/0zZevL2qrFHnLnMEhT8s
	 ZpIuTDy0SZmV3/cd0/0j70a/jI9jnJWmlPzqwnLw6YD3e5BD48gLTgJ5rf8dPf2hC2n1C
	 qitIWop2hsVfuiuQvmxXHBGOq1qknLjDLAntq9rE8Vv5sDcV5qo8cRxgX8Qyj42Lj5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634359;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=OxZ1FKz93yFmSf3rlu7UFTVP3JEk6naoYRS2+rfDo78=;
	b=Q7V32JF8hwBodjxNrsoRpKjydGO+TmJsFJt1IDmPCWMgmn0lYFfvrMUKjkacQwB+F/Gl
	 B+rr5qX2enXZn7AcD5F71C+vPg+k8jYIZMKGPzUQ2CPBTRA77dq8SH51fReoz2uQ5uZjX
	 RpaoNp5KoKmNf8GIlmxvXx64aUyQm5vnt9G0+yTPhrNmmD7odg44bWR5/JbXDYpeEwnyE
	 M9B33TT3ULtMJZmV/PwS1gxdGdAaU3LtPmUYZtL65cdU3P+rOaHLYg91QyCLHCUjE7m+l
	 sv5iUeO0mQq5v9HXQjK5+UT2s3pN6fV/2wZUnTltW6fn4kG3T57OeomgI9a8eCM1e9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="cOCS/GGj";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655146074659;
	Mon,  2 Nov 2026 15:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 655146074659
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cOCS/GGj
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABA581691;
	Mon,  2 Nov 2026 07:45:54 -0800 (PST)
Received: from [10.57.58.9] (unknown [10.57.58.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85CB43F673;
	Mon,  2 Nov 2026 07:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793634357; bh=20817R1mA1QbVjTwjDkW4AThGUuc7p8N/sVrM+ih4AM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cOCS/GGjHAgkaZa/DZHphD0w3MxNA7tE7wxbCjH8zp+5E7JfZTNU8KDbBKcYTkzOx
	 P6yo5GiKL8de1WXQF+qhbIqjXEZz6rB1M9ziyY9EMMl4CCUM+JI7JSq+3rS6d0FCAP
	 MgQUxyTQuOyY5SBKB0xtNrB55E8y/cf5P+PdJUYE=
Message-ID: <b0755ab6-d7a9-4952-8f18-09b72fbd662d@arm.com>
Date: Mon, 2 Nov 2026 15:45:54 +0000
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
Subject: Re: [PATCH 02/11] KVM: arm64: CCA: Introduce Realms
To: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-3-steven.price@arm.com>
 <sashiko-outbox-193575@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-193575@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 14:30, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] KVM: arm64: premature kvm_arch_has_private_mem() breaks gmem checks and caps
> - [Low] KVM: arm64: duplicate kvm_arm_vcpu_finalize() declarations in kvm_host.h
> --
> 
> commit d7e08ee0dbb02a4cf114f13c026edc843145fe6e
> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> KVM: arm64: CCA: Introduce Realms
> 
> This commit adds foundational infrastructure for Arm CCA Realm VMs,
> including the VM_REALM flavor, a static key for RMI availability,
> per-VM Realm state tracking in struct kvm_arch, and initial feature and
> memslot checks.
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index ccd2dc8f73c3a..7d0222047ca1e 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
> [ ... ]
>> @@ -1572,30 +1584,43 @@ struct kvm *kvm_arch_alloc_vm(void);
> [ ... ]
>> +#define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
>> +#define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
>>  
>>  #define kvm_vm_hyp_is_distrusting(kvm)	((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
>>  
>> -#endif	/* __KVM_NVHE_HYPERVISOR__ */
>> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
> 
> [Severity: High]
> Does defining kvm_arch_has_private_mem(kvm) here cause a regression in
> guest_memfd memslot validation and capability reporting across arm64?
> 
> Because CONFIG_KVM_PRIVATE_MEMATTR_VM is not selected on arm64, defining
> kvm_arch_has_private_mem activates the preprocessor branch in
> include/linux/kvm_host.h that sets gmem_in_place_conversion to true at
> compile time:
> 
> include/linux/kvm_host.h:
>     #elif defined kvm_arch_has_private_mem
>     #define gmem_in_place_conversion true
>     #define kvm_is_private_gfn kvm_gmem_is_private_gfn
> 
> With gmem_in_place_conversion unconditionally true,
> kvm_gmem_prepare_memory_region() in virt/kvm/guest_memfd.c sets
> KVM_MEMSLOT_GMEM_ONLY on every guest_memfd memslot even when
> GUEST_MEMFD_FLAG_MMAP is not set:
> 
> virt/kvm/guest_memfd.c:kvm_gmem_prepare_memory_region() {
>     ...
>     if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
>         slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
> }
> 
> As a result, the check in kvm_arch_prepare_memory_region() in
> arch/arm64/kvm/mmu.c that rejects non-mappable guest_memfd memslots:
> 
> arch/arm64/kvm/mmu.c:kvm_arch_prepare_memory_region() {
>     ...
>     if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>         return -EINVAL;
> }
> 
> is bypassed for non-Realm VMs, allowing userspace to bind a private
> guest_memfd created with flags == 0 via KVM_SET_USER_MEMORY_REGION2 and
> fault those pages into non-Realm stage-2 page tables through gmem_abort().
> 
> In addition, when userspace queries
> KVM_CHECK_EXTENSION(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) on the /dev/kvm
> fd (where kvm is NULL), kvm_vm_ioctl_check_extension_generic() in
> virt/kvm/kvm_main.c calls kvm_supports_private_mem(NULL):
> 
> virt/kvm/kvm_main.c:kvm_supports_private_mem() {
>     return !kvm || kvm_arch_has_private_mem(kvm);
> }
> 
> virt/kvm/kvm_main.c:kvm_vm_ioctl_check_extension_generic() {
>     ...
>     case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>         if (!gmem_in_place_conversion || !kvm_supports_private_mem(kvm))
>             return 0;
> 
>         return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> }
> 
> This advertises KVM_MEMORY_ATTRIBUTE_PRIVATE on all arm64 hosts even when
> KVM_MODE_RMM is not active and while kvm_gmem_set_attributes() in
> virt/kvm/guest_memfd.c rejects KVM_SET_MEMORY_ATTRIBUTES2 with -EINVAL on
> every creatable VM.

Dang, yes that's broken. The later commit "KVM: arm64: CCA: Support
runtime faulting of memory" changes the condition in
kvm_arch_prepare_memory_region() to check "!kvm_vm_is_realm()" but
clearly I've broken the bisect here. That check also isn't quite right.
I think rather than using kvm_memslot_is_gmem_only() we should check the
gmem file with kvm_gmem_supports_mmap(). So we end up with the check:

       if (kvm_slot_has_gmem(new) && !kvm_vm_is_realm(kvm) &&
           !kvm_gmem_slot_supports_mmap(new))

and a new function:

 bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot)
 {
        /* The guest_memfd file is pinned while preparing a new memslot. */
        return kvm_gmem_supports_mmap(file_inode(slot->gmem.file));
 }


I'm not sure what we can do about the KVM extension when !kvm. x86
presumably already has the situation where !kvm can expose
KVM_MEMORY_ATTRIBUTE_PRIVATE even if the host doesn't support it. Is
this a problem?

>> +
>> +int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>> +bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> 
> [Severity: Low]
> This isn't a bug, but commit df6a70516adec8 already moved the declarations
> of kvm_arm_vcpu_finalize() and kvm_arm_vcpu_is_finalized() earlier in
> arch/arm64/include/asm/kvm_host.h right below VCPU_PKVM_FINALIZED:
> 
> arch/arm64/include/asm/kvm_host.h:
>     #define VCPU_PKVM_FINALIZED	__vcpu_single_flag(cflags, BIT(2))
> 
>     int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>     bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
> 
> Can these duplicate declarations be dropped?

Indeed they can.

Steve

