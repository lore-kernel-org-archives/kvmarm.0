Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640552;
	b=OCdQuaDS022XnA1Pad/jMijt1e/XCPDTO66rcFuEyZpA4sr6FEbZCzNVy4vk2O+HNtZg
	 DG+m0VyPUZhgD+UbWnaC5EBqKEy2Tp9y4k1qdzL0OTIcctD5nDjzxVBHH2m4Z4EyyoQBR
	 KQJ7W3nEgHWBkYG/GCmW0ow52s82ASD7Yaj0tj0ttb/uJRjwNg4TLQConB2cBSl8DUNFo
	 OBQza0autksWvczY0CUbcz9+PUPoXEPyN7ZUoNZIPnbH3g0PGwL2RIW7rgdOVE1GKgtG7
	 ZwMbFwF8z2+DY4gOSAtkPeDNPiHCNcZDi4ADcZdxbiyL5q38EunpjuKf7YcXjMFnOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640552;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bLJCblaC6p74X0djr/s7k+NpLQHxJXC32OYuLH+pEfk=;
	b=CUPhWuXJsnBLU0bE7hruFXZyw1XU/Qc4hUCWAvmUPAj887iT+YbeBcN9PuaWAkFWdgkq
	 XjDLkub0+XkuSJihkgJPE5+NUf04EyRLWMokC8WzKsrQBukBEUhMub0SlfqgnYYqOp5bJ
	 FJb2fmmRioKflpZQZ1aJEy8xiAm0Osk8tPw82KcDgPm5X3Ef6ZsYBJdvYfpbLStd1FTwl
	 NFMIh+fpv8+x/wUfaXv32qEBV9I6TaUejfJvVdQd/hSimMD9lDwNSkfMZ8wEV+tMF8t5m
	 A6ZQ2agqcR9qrtvf1kRv9QK3/e7Veo2iQNwzhbfJsXdlKpndLM9nYJmJqh299Om0VfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vdnNkLzw;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D720606E031;
	Mon,  2 Nov 2026 17:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D720606E031
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vdnNkLzw
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A72A716F3;
	Mon,  2 Nov 2026 09:29:07 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A18F3F59E;
	Mon,  2 Nov 2026 09:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793640550; bh=ZlHYnqiU00gksrwMlhvvPkWAHmYQOGltgW8sZDyoCXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vdnNkLzwOmkpdJGKhWTBsOK9HdfAJx8FDNmhV+Nio/h04lbIvSgm9v5ndCwQd8Z6+
	 4Fvxg6Rm4tWYOBDjT3xSyEG6D6J7NIjij++stxkXIZrydT81vhZLy8WeO/KzTnNcOv
	 NexeDzHHWZ47qbqocYmkYKMNEIdMOqIEnlshIrqM=
Message-ID: <909ce27c-524d-4206-93bb-113711c8ca11@arm.com>
Date: Mon, 2 Nov 2026 17:29:08 +0000
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
Subject: Re: [PATCH 09/16] KVM: arm64: gic-v5: Add ITS MSI injection
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-10-sascha.bischoff@arm.com>
 <sashiko-outbox-174632@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174632@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:23, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] kvm/vgic: raw_spinlock deadlock due to missing IRQ disable in its_cache_add_translation
> - [High] kvm/vgic: userspace-triggerable WARN_ON_ONCE causes host DoS in vgic_v5_its_inject_msi
> - [High] arm64: vgic-v5: User-triggerable WARN_ON_ONCE in MSI injection
> - [High] kvm: arm64: ABI violation on guest-driven MSI mapping errors
> - [Medium] kvm: arm64: gic-v5: MSI injection aborted on translation cache allocation failure
> - [Medium] arm64: vgic-v5: MSI injection fails if ITS cache insertion fails
> --
> 
> commit 65afd53542f7c52bea1da09f7e70c85b22c50b33
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
>      KVM: arm64: gic-v5: Add ITS MSI injection
>      
>      Now that KVM can resolve GICv5 ITS translations from guest memory,
>      allow userspace and irqfd MSI injection to target a virtual GICv5 ITS.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> index e4c0415137605..5920fa1bcb2cf 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> 
> [ ... ]
> 
>>   static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
>>   				     u32 device_id, u16 event_id,
>>   				     struct vgic_irq *irq)
>>   {
>>   	u64 key = ((u64)device_id << 16) | (u64)event_id;
>>   	struct its_cache_translation_entry *entry;
>>   	struct its_cache_translation_entry *old;
>>   	struct hlist_node *tmp;
>>   	HLIST_HEAD(removed);
>>   
>>   	entry = kzalloc_obj(*entry, GFP_KERNEL);
>>   	if (!entry)
>>   		return -ENOMEM;
>>   
>>   	entry->key = key;
>>   	entry->irq = irq;
>>   
>>   	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
> 
> [Severity: High]
> Could this lock acquisition deadlock?
> 
> The translation_cache_lock is a raw_spinlock_t that is also acquired in
> hardirq context by its_cache_look_up_translation(). Since
> scoped_guard(raw_spinlock) does not disable local interrupts, a hardirq could
> preempt this process-context section and attempt to acquire the same lock,
> spinning forever.
> 
> Should this use the raw_spinlock_irqsave variant?

I think it should have, if I'd not reworked the code to use XArrays 
instead. The original cache lock could be interrupted by a hardirq 
trying to take the same lock.

I've removed translation_cache_lock as part of the XArray conversion, so 
I think that this is now addressed.

> 
> [ ... ]
> 
>>   static int its_cache_look_up_translation(struct vgic_v5_its *its,
>>   					 u32 device_id, u16 event_id,
>>   					 struct vgic_irq **irq)
>>   {
>>   	u64 key = ((u64)device_id << 16) | (u64)event_id;
>>   	struct its_cache_translation_entry *entry;
>>   
>>   	guard(raw_spinlock)(&its->translation_cache_lock);
> 
> [Severity: High]
> Does this also need to disable interrupts?
> 
> Since this is called from the fast path (kvm_arch_set_irq_inatomic) which can
> run in hardirq context, and the same lock is taken in process context, should
> both sides use the irqsave/irqrestore variants to prevent deadlocks?

As above, the translation_cache_lock has now been dropped. We now do RCU 
lookups in the XArray instead.

> 
> [ ... ]
> 
>> @@ -531,7 +572,8 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
>>   		return PTR_ERR(*irq);
>>   
>>   	vgic_get_irq_ref(*irq);
>> -	ret = its_cache_add_translation(kvm, its, device_id, event_id, *irq);
>> +	ret = its_cache_add_translation(kvm, its, device_id, (u16)event_id,
>> +					 *irq);
>>   	if (ret) {
>>   		vgic_put_irq(kvm, *irq);
>>   		vgic_put_irq(kvm, *irq);
>>   		*irq = NULL;
>>   	}
>>   
>>   	return ret;
>>   }
> 
> [Severity: Medium]
> Is it correct to abort the injection if the translation cache insertion fails?
> 
> The translation cache is intended to be a best-effort optimization. If
> its_cache_add_translation() fails (e.g., due to -ENOMEM), propagating the
> error and dropping the successfully resolved LPI will silently lose the
> interrupt, which could hang guest drivers under host memory pressure.
> 
> Should the error be swallowed here instead so that injection proceeds?

I've made cache insertion best effort for software MSI injection, so the 
interrupt is still injected on that failure. That said, we realistically 
shouldn't be hitting this case unless we're under very high memory 
pressure, at which point all sorts of things will be going wrong!

> 
> [ ... ]
> 
>> +int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>> +{
>> +	struct vgic_v5_its *its;
>> +	struct vgic_irq *irq;
>> +	bool borrowed_mm = false;
>> +	int ret;
>> +
>> +	ret = vgic_v5_check_msi(kvm, msi);
>> +	if (ret)
>> +		return ret;
>> +
>> +	its = vgic_v5_msi_to_its(kvm, msi);
>> +	if (IS_ERR(its))
>> +		return PTR_ERR(its);
>> +
>> +	/* An irqfd cache miss is resolved by a worker outside the VM's mm. */
>> +	if (current->mm != kvm->mm) {
>> +		if (WARN_ON_ONCE(current->mm || !(current->flags & PF_KTHREAD)))
>> +			return -EWOULDBLOCK;
> 
> [Severity: High]
> Could this WARN_ON_ONCE be triggered by unprivileged userspace?
> 
> If a normal user process (other than the VM creator) calls the KVM_SIGNAL_MSI
> ioctl, current->mm will not equal kvm->mm, and since it is a user thread,
> current->mm is non-NULL and it lacks PF_KTHREAD. Triggering a kernel warning
> can crash the host if panic_on_warn is enabled, leading to a Denial of Service.

Can we realistically reach that case?

kvm_vm_ioctl() rejects a userspace caller whose mm differs from the VM's 
mm before KVM_SIGNAL_MSI reaches this code.

The irqfd worker is a kernel thread using the VM's mm struct.

How can we reach this code? I've not changed anything to address this!

> 
>> +
>> +		if (!mmget_not_zero(kvm->mm))
>> +			return -EFAULT;
>> +
>> +		kthread_use_mm(kvm->mm);
>> +		borrowed_mm = true;
>> +	}
>> +
>> +	ret = vgic_v5_its_resolve_lpi(kvm, its, msi->devid, msi->data, &irq);
>> +	if (borrowed_mm) {
>> +		kthread_unuse_mm(kvm->mm);
>> +		mmput(kvm->mm);
>> +	}
>> +
>> +	if (ret)
>> +		return ret;
> 
> [Severity: High]
> Does this violate the KVM_SIGNAL_MSI ABI by returning negative error codes?
> 
> When the guest provides an invalid mapping (like an out-of-bounds Event ID),
> vgic_v5_its_resolve_lpi() returns errors like -E2BIG or -EINVAL. Propagating
> these directly to the ioctl caller instead of returning 0 (to indicate the
> guest blocked or unmapped the MSI) can cause the VMM to abort, creating a
> guest-to-host Denial of Service.
> 

Ah, yes. This was a mistake, and those shouldn't be returned. I've 
changed these to return 0 to the caller instead. We still return 
negative error codes for malformed MSIs, allocation failures, and when 
the ITS itself is disabled.


Thanks,
Sascha
