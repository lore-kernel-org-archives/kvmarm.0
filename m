Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644359;
	b=qGU3txi7fVxzvuv1/DBrLiCbnWOoAhBt3SHNV3CcjxpvfBNgIC6aqJeg/sn39iTMpEaA
	 h3WT+VBpY4FBRdclbLTZBM/TvgdWLWTO3i8KYsbIjQUGVNJInJ8NFZ5Ww0K4jJZREXdaN
	 2bc+lLaDaP32h97YsyQ+4+DIuT/xXgZoXGsSvvSa9IXkZhWjznkSJCME994xIPcdg0Y2Y
	 Sbm8UoM12jW2r75SVloJVY7RMwMoW4IWXlTeKecHDQ8qJTvo/6w4A6M8ow1oBBaLQP/hB
	 cieyPg5lxrXzQ6Oz6hOSQWKBjQcFwePkD6KM0c9nNDTb7n0CnzoHzmppL0zBGef02Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644359;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=d6Zs7hYlOcAb9GpTpzgd4RT7Z8RUJLNrzQEbBotUN6E=;
	b=VgcK6GAvxJIr5hgDnfYU3laMRg6BP9REmr5ZZHKEPPjK/S2o5ZsyEm3yglYCmGCr9q9W
	 f5suyXtgOpQYnkrv33YIwhEao7HzyttxyAOL0HcciAaB01B/+WG3YhkuDl/rWHnjIVslj
	 JDT3cEkjCf9zRLSyCBYuuLx3siTr5giApA3q3JXiuBdBgHsE653rqLYowcscFJQWjqHGf
	 RrY9B27ucMnBCC3TlN4Exvb70otrrfoEwuw6o+L43kmI9ntRVPPVZBFAz2LsO5vEZ8dTk
	 6j/OU4cZiLCrKx9IyxLCwgWNhOKLck/sV1f/9VQf3naYIFCzuYu1jrbvfQPL9flxLUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dtYbcMk9;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE54606A33B;
	Mon,  2 Nov 2026 18:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BE54606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dtYbcMk9
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 447D41C14;
	Mon,  2 Nov 2026 10:32:34 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CA6C3F673;
	Mon,  2 Nov 2026 10:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793644357; bh=nI0YXxpb9UJqKj3m7hjIKI17k4V7uhAOorjJL+Fywkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dtYbcMk9SJkWCbo6y4hdjHWxZOwL9CpwtcA2b4elAGjGLsZeaCJN663iacuO5uYbO
	 XLI0yB1qxIUfPQOvxrnkTtNZ2VAro4Kl3tyrcL3mo936a2wRfsoA2DtOWK2+2IiEU9
	 mEbbnIYtqLnx8pJ63j9bC3J5QzCb8Ceqa7joSIw4=
Message-ID: <1a069f22-64ac-44f3-9eb0-bd4b9416d2bf@arm.com>
Date: Mon, 2 Nov 2026 18:32:34 +0000
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
Subject: Re: [PATCH 13/16] KVM: arm64: gic-v5: Implement irq forwarding
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-14-sascha.bischoff@arm.com>
 <sashiko-outbox-174635@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174635@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] kvm: passing full typed INTID to hardware VDPEND instruction
> - [High] kvm: use of undefined macro kzalloc_obj
> - [High] kvm: ABBA deadlock due to translation_cache_lock acquired without disabling IRQs
> - [High] kvm/vgic: TOCTOU race in its_cache_drop_translation disables wrong host IRQ
> - [Medium] kvm: data race from lockless read of irq->hw bitfield
> - [Low] cleanup: mixing goto-based cleanup with guard() declarations
> --
> 
> commit 3a376f5ffceb9df2e3023c6def306e4b00a9eba1
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
>      KVM: arm64: gic-v5: Implement irq forwarding
> 
>      GICv5, like GICv4, supports direct injection of interrupts via the
>      ITS. Move the existing GICv4 interface behind a common shim that selects
>      the appropriate implementation. For GICv5 forwarding, the ITS driver
>      replaces a host ITTE with one targeting a guest. The host no longer
>      receives that interrupt until forwarding is removed and the host ITTE is
>      restored.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> index 62c1ca8004007..e71cd67652bae 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> [ ... ]
>> @@ -31,7 +32,41 @@ static void its_cache_drop_translation(struct kvm *kvm,
>>   				       struct its_cache_translation_entry *entry)
>>   {
>>   	struct vgic_irq *irq = entry->irq;
>> +	unsigned long flags;
>> +	int virq = 0;
>> +	bool hw = false;
>> +	bool drop_forwarding_ref = false;
>>   
>> +	/*
>> +	 * Multiple translations can share an LPI as we have no way of stopping
>> +	 * the guest from doing so. Only the entry associated with direct injection
>> +	 * may tear down the IRQ's forwarding state, as otherwise we can end up
>> +	 * accidentally tearing something down. Realistically, this only would
>> +	 * result in a performance degradation, but we might as well avoid that
>> +	 * in the first place if we can.
>> +	 */
>> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> +	if (irq->forwarding_owner == entry) {
>> +		/* The entry is about to be freed, even if unforwarding fails. */
>> +		irq->forwarding_owner = NULL;
>> +		virq = irq->host_irq;
>> +		hw = irq->hw;
>> +	}
>> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +
>> +	if (hw && !WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq))) {
> 
> [Severity: High]
> Is there a TOCTOU race here when the lock is dropped before calling
> gicv5_its_disable_direct_injection?
> 
> While the lock is released, a concurrent host unbind operation could invoke
> irq_bypass_del_producer, unset the forwarding, and free the host IRQ. The Linux
> IRQ number could then be immediately reallocated to a different device. When
> this thread resumes, it would unconditionally disable hardware direct injection
> for the newly assigned device/VM using the stale virq identifier, potentially
> causing lost interrupts.

I agree that this is an issue with the commit as posted here. I've 
re-worked this to keep the lock held while disabling direct injection. 
This prevents a concurrent unbind from freeing or reusing the host IRQ 
until we're done with the disable operation. At the point where the lock 
is release, we no longer use the host IRQ.

> 
>> +		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> +		if (irq->hw && irq->host_irq == virq &&
>> +		    !irq->forwarding_owner) {
>> +			irq->hw = false;
>> +			irq->host_irq = 0;
>> +			drop_forwarding_ref = true;
>> +		}
>> +		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>> +	}
> [ ... ]
>> @@ -50,7 +85,8 @@ static void its_cache_drop_removed_translations(struct kvm *kvm,
>>   
>>   static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
>>   				     u32 device_id, u16 event_id,
>> -				     struct vgic_irq *irq)
>> +				     struct vgic_irq *irq,
>> +				     void **owner)
>>   {
>>   	u64 key = ((u64)device_id << 16) | (u64)event_id;
>>   	struct its_cache_translation_entry *entry;
>> @@ -78,6 +114,8 @@ static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
>> +	struct its_cache_translation_entry *old;
>> +	struct hlist_node *tmp;
>> +	HLIST_HEAD(removed);
>>
>> -	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>> +	entry = kzalloc_obj(*entry, GFP_KERNEL);
> 
> [Severity: High]
> Is kzalloc_obj defined anywhere in the tree? It looks like this might be a
> typo for kzalloc(sizeof(*entry), GFP_KERNEL) which will cause compilation
> failures.

Uh, yes. I certainly hope so! kzalloc_obj is defined in 
include/linux/slab.h, which this file includes, and this allocation 
predates this commit. I'm not fixing this non-issue.

> 
>>   	if (!entry)
>>   		return -ENOMEM;
>>   
>>   	entry->key = key;
>>   	entry->irq = irq;
>>   
>> -	raw_spin_lock(&its->translation_cache_lock);
>> +	scoped_guard(raw_spinlock, &its->translation_cache_lock) {
> 
> [Severity: High]
> Should this use the irqsave variant of scoped_guard? Acquiring
> translation_cache_lock in process context without disabling local hardware
> interrupts could lead to an ABBA deadlock. If irqfd_wakeup runs in HardIRQ
> context on a CPU that already holds this lock, the interrupt handler might
> spin forever trying to acquire it.

With the series as posted, this is an issue. Now that I've reworked it 
to use an XArray to track the translations it is no longer an issue. The 
lookup is now using RCU for the XArray.

> 
>>   		hash_for_each_possible_safe(its->translation_cache, old, tmp,
>>   					    node, key) {
>>   			if (old->key == key) {
> [ ... ]
>> @@ -129,7 +167,8 @@ static void its_cache_clear_translations(struct vgic_v5_its *its)
>>   
>>   static int its_cache_look_up_translation(struct vgic_v5_its *its,
>>   					 u32 device_id, u16 event_id,
>> -					 struct vgic_irq **irq)
>> +					 struct vgic_irq **irq,
>> +					 void **owner)
>>   {
>>   	u64 key = ((u64)device_id << 16) | (u64)event_id;
>>   	struct its_cache_translation_entry *entry;
>>
>> -	raw_spin_lock(&its->translation_cache_lock);
>> +	guard(raw_spinlock)(&its->translation_cache_lock);
> 
> [Severity: High]
> Similarly here, acquiring translation_cache_lock without disabling interrupts
> leaves the system vulnerable to the same ABBA deadlock if the lock is
> contended by HardIRQ context.

This is the same issue as reported above. The translation_cache_lock has 
now been removed, and we're not taking any lock on the XArray itself. 
Therefore, this is no longer an issue with the upcoming repost.

> 
>>   	hash_for_each_possible(its->translation_cache, entry, node, key) {
>>   		if (entry->key == key) {
> [ ... ]
>> @@ -657,8 +735,8 @@ int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
>>   static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
>>   {
>>   	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
>>   		     kvm->arch.vgic.gicv5_vm.vm_id);
>>   }
> 
> [Severity: High]
> Does this pass the full typed INTID directly to the hardware GIC VDPEND
> instruction?
> 
> GICv5 INTIDs encode the type in bits [31:29]. The architecture limits hardware
> instructions to expecting a raw hardware ID. Should this be masked using
> vgic_v5_get_hwirq_id(irq->intid) to avoid feeding the type bits into the
> hardware operand?

Yes, of course this is passing the typed INTID directly to GIC VDPEND! 
We need to tell the GIC which type of interrupt we are injecting, so 
that's absolutely by design. We could arguably split this into type and 
ID, but what's the point? All we'd do is reconstrut that again on the 
other side.

Leaving this as is.

> 
> [ ... ]
>> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
>> index c90e00f56b298..970df3f41cf24 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> [ ... ]
>> +int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int virq,
>> +			       struct kvm_kernel_irq_routing_entry *irq_entry)
>> +{
>> +	struct vgic_v5_its *its_data;
>> +	struct vgic_irq *irq;
>> +	void *owner;
>> +	bool hw;
>> +	int ret;
>> +
>> +	if (!vgic_has_its(kvm))
>> +		return 0;
>> +
>> +	/* Look up the ITS; bail out if we can't look it up */
>> +	its_data = vgic_v5_get_its(kvm, irq_entry);
>> +	if (IS_ERR(its_data))
>> +		return 0;
>> +
>> +	/*
>> +	 * Look up and cache the translation. Bail out if we failed to look up
>> +	 * the translation at this stage. If the translation becomes valid at a
>> +	 * later stage, we should fall back to software-based injection.
>> +	 */
>> +	guard(mutex)(&its_data->its_lock);
>> +
>> +	ret = vgic_v5_its_resolve_lpi_locked(kvm, its_data,
>> +					     irq_entry->msi.devid,
>> +					     irq_entry->msi.data, &irq, &owner);
>> +	if (ret)
>> +		return 0;
>> +
>> +	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
>> +		hw = irq->hw;
>> +	}
>> +
>> +	if (hw)
>> +		goto out_put_irq;
> 
> [Severity: Low]
> Does this mix goto-based error handling with scope-based cleanup helpers like
> guard() and scoped_guard()? The kernel cleanup guidelines strongly discourage
> mixing these in the same function to avoid confusing ownership semantics.
> Should this function be standardized to use only one of the approaches?

Yeah, agreed that the posted code is confusing and does mix those two 
styles. I've dropped the gotos and have replaced them with explcit 
reference drops and returns, instead. The scoped_guard()s remain.

> 
> [ ... ]
>> +static struct vgic_irq *vgic_v5_host_irq_get_lpi(struct kvm *kvm, int host_irq)
>> +{
>> +	struct vgic_irq *irq;
>> +	unsigned long idx;
>> +
>> +	guard(rcu)();
>> +	xa_for_each(&kvm->arch.vgic.lpi_xa, idx, irq) {
>> +		if (!irq->hw || irq->host_irq != host_irq)
>> +			continue;
> 
> [Severity: Medium]
> Is it safe to locklessly read the irq->hw bitfield here?
> 
> This bitfield is modified concurrently by kvm_vgic_v5_set_forwarding and
> kvm_vgic_v5_unset_forwarding under irq_lock. Concurrent read and write access
> to a C bitfield is undefined behavior and can result in torn reads or
> corrupted data.

These now happen under irq_lock, and therefore concurrent updates are no 
longer possible. We hold the lock when setting up and tearing down the 
forwarding, so these should not be able to unexpectedly change 
underneath us.

> 
>> +
>> +		if (!vgic_try_get_irq_ref(irq))
>> +			return NULL;
>> +
>> +		return irq;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +void kvm_vgic_v5_unset_forwarding(struct kvm *kvm, int virq)
>> +{
>> +	struct vgic_irq *irq;
>> +	bool drop_forwarding_ref = false;
>> +
>> +	if (!vgic_has_its(kvm))
>> +		return;
>> +
>> +	/*
>> +	 * Note: We don't remove the entry from our translation cache here. It
>> +	 * is up to the guest to invalidate the old translations, and hence the
>> +	 * removal path is tied into ITS_INV_DEVICER and ITS_INV_EVENTR, rather
>> +	 * than being explicitly called here.
>> +	 */
>> +	irq = vgic_v5_host_irq_get_lpi(kvm, virq);
>> +	if (!irq)
>> +		return;
>> +
>> +	if (WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq)))
>> +		goto out_put_irq;
>> +
>> +	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> 
> [Severity: Low]
> This is another instance of mixing goto-based error handling alongside
> scoped_guard(). Should we convert this completely to scope-based cleanup or
> stick entirely to traditional goto labels?

I've done the same as I said above - the gotos are now gone and have 
been replaced with explicit returns instead. scoped_guard() is still 
used to handle the locking.

> 
>> +		if (irq->hw && irq->host_irq == virq) {
>> +			irq->hw = false;
>> +			irq->host_irq = 0;
>> +			irq->forwarding_owner = NULL;
>> +			drop_forwarding_ref = true;
>> +		}
>> +	}
>> +
>> +	if (drop_forwarding_ref)
>> +		vgic_put_irq(kvm, irq);
>> +
>> +out_put_irq:
>> +	vgic_put_irq(kvm, irq);
>> +}
> 

Thanks,
Sascha
