Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B45528EC6E
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736848539; cv=none; b=HlBy8N57I7IXJq8UI0q/0csxyFXb26f6oqJuW98ohsp/egtXJWZC7Lsg3Zfbk36qezCQOCOcYr1bXHkKXKvk4vEA3956zybeloi1chP6Pg/a5p7D29BSqDmIuoBVEZbfr6TxemyPBQ9eLYAAzIRM0rA9RYFW1E8zWexyXTqhZ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736848539; c=relaxed/simple;
	bh=xxLGlU/FIT4lnPp7o3tKeTD0oD4NlG02E+vY4nChYG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WkjBzW0pKM7xZL/kdnnlFpLNQWK8YqKBaWeBhBWQvYdgN2sk5iBYRayEpyIxmbnyO8MQ70WNR8PfhUPlwBCrFE8qs76er0iZ4kSuNaH7CYtojk4Jrjy+Vw7bWkGkB0jZBkwng8HeuV7qcZVeoEjeko1tH+EVtvKpMjvwf1B/LP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AD7D11FB;
	Tue, 14 Jan 2025 01:56:04 -0800 (PST)
Received: from [10.57.35.117] (unknown [10.57.35.117])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C9713F792;
	Tue, 14 Jan 2025 01:55:33 -0800 (PST)
Message-ID: <bfd6361b-1a6f-43e5-9ad1-80692c146d61@arm.com>
Date: Tue, 14 Jan 2025 09:55:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
Content-Language: en-GB
To: Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org> <Z4Fk58k8YptDkVgm@arm.com>
 <yq5amsfxtrlw.fsf@kernel.org> <Z4Vk5gTnd8o7VKWL@arm.com>
 <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAMn1gO4huP4D_1mFdC8FsmvHkaQn+hC02ULcfBuS30VDM9=9gA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,


On 13/01/2025 20:47, Peter Collingbourne wrote:
> On Mon, Jan 13, 2025 at 11:09 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>>
>> On Sat, Jan 11, 2025 at 06:49:55PM +0530, Aneesh Kumar K.V wrote:
>>> Catalin Marinas <catalin.marinas@arm.com> writes:
>>>> On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>>>> Currently, the kernel won't start a guest if the MTE feature is enabled
>>>
>>> ...
>>>
>>>>> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>>>>             if (!vma)
>>>>>                     break;
>>>>>
>>>>> -          if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
>>>>> +          if (kvm_has_mte(kvm) &&
>>>>> +              !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
>>>>>                     ret = -EINVAL;
>>>>>                     break;
>>>>>             }
>>>>
>>>> I don't think we should change this, or at least not how it's done above
>>>> (Suzuki raised a related issue internally relaxing this for VM_PFNMAP).
>>>>
>>>> For standard memory slots, we want to reject them upfront rather than
>>>> deferring to the fault handler. An example here is file mmap() passed as
>>>> standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
>>>> I'd only relax this for VM_PFNMAP mappings further down in this
>>>> function (and move the VM_PFNMAP check above; see Suzuki's internal
>>>> patch, unless he posted it publicly already).

For the record, here is the patch Catalin was referring to.


--->8---

kvm: arm64: Allow device mappings with MTE

When a VM is configured to use MTE, we prevent mapping a "Device" to the VM.

e.g: with kvmtool (with additional debugging to dump error code and 
addresses)

$ lkvm run ... --vfio 0000:01:00.0 ...

  Info: Using IOMMU type 3 for VFIO container
    Error: 0000:01:00.0: failed to register region with KVM 
50020000-50022000: -22
       Warning: [0abc:aced] Error activating emulation for BAR 0
       Error: 0000:01:00.0: failed to configure regions
       Warning: Failed init: vfio__init

Only check for the MTE allowed for a VMA if it is not backed by "device"

Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
Cc: Steven Price <steven.price at arm.com>
Cc: Marc Zyngier <maz at kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose at arm.com>
---
  arch/arm64/kvm/mmu.c | 8 +++-----
  1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8b2d803e558a..7e084f22e185 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2295,17 +2295,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
  		if (!vma)
  			break;

-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
-			ret = -EINVAL;
-			break;
-		}
-
  		if (vma->vm_flags & VM_PFNMAP) {
  			/* IO region dirty page logging not allowed */
  			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
  				ret = -EINVAL;
  				break;
  			}
+		} else if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
+			ret = -EINVAL;
+			break;
  		}
  		hva = min(reg_end, vma->vm_end);
  	} while (hva < reg_end);
-- 
2.34.1


Suzuki


>>>
>>> But we want to handle memslots backed by pagecache pages for virtio-shm
>>> here (virtiofs dax use case).
>>
>> Ah, I forgot about this use case. So with virtiofs DAX, does a host page
>> cache page (host VMM mmap()) get mapped directly into the guest as a
>> separate memory slot? In this case, the host vma would not have
>> VM_MTE_ALLOWED set.
>>
>>> With MTE_PERM, we can essentially skip the
>>> kvm_vma_mte_allowed(vma) check because we handle all types in the fault
>>> handler.
>>
>> This was pretty much the early behaviour when we added KVM support for
>> MTE, allow !VM_MTE_ALLOWED and trap them later. However, we disallowed
>> VM_SHARED because of some non-trivial race. Commit d89585fbb308 ("KVM:
>> arm64: unify the tests for VMAs in memslots when MTE is enabled")
>> changed this behaviour and the VM_MTE_ALLOWED check happens upfront. A
>> subsequent commit removed the VM_SHARED check.
>>
>> It's a minor ABI change but I'm trying to figure out why we needed this
>> upfront check rather than simply dropping the VM_SHARED check. Adding
>> Peter in case he remembers. I can't see any race if we simply skipped
>> this check altogether, irrespective of FEAT_MTE_PERM.
> 
> I don't see a problem with removing the upfront check. The reason I
> kept the check was IIRC just that there was already a check there and
> its logic needed to be adjusted for my VM_SHARED changes.
> 
> Peter

