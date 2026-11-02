Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640036;
	b=0HfmIR++Drnm7A1TtcH4sUNRMD5BcsYurF+Vy0EIRkrZ8Xex/55rNkT2GajiexiSdzaL
	 LNTg54C4i5EtH00/J9JUzsXDCmCPfhbhOV6hhkc+c5X2/4m63v4NM0/ORKpdO5VgLNC75
	 209JF+XAsXDIrGYxQrKZiA8NCJ/XSLZl3VKF6gnFCPQ2PgHVovooxuNjCmvqNzsvhSYbv
	 8x4SBEWa7a+Mn5w/uM2qLkcWYjhD+uavZe06/+1WNyb5oWLXPM6wcPPKWzrVfUBc8KUA9
	 NfpRXVLumWO3mHLxHomGcQBV7v21FQTlgkFEZJBJTmTv1p7hLjM3G/nbNU2KBKuik1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640036;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dzzxSQBG0AvDDv9COAPOwA5LVMAcbbFKl5UqiJsAWms=;
	b=mjnjZ5ZZMtHmwboYEVlZuq+M23QlXzZeHKpdBIQcYchzaKJGxI+7wNQvMW6/YpOBOA2O
	 mB3K4TS9GC46iG0V9AxRTJuvUdfTEiYDvboEQKQykqqrPAcJWFZk/PzQF4DwdQ12wfOM2
	 6GG43KweBPzZfz563ayl1HPnT58/fCPYszSsVqbRq9qE8VH+QQoL/9C6qcW1CvmsRBMZU
	 owOBVSPGzXXaOQxWd+ZB44QycsCgnTU80VSqlwuVDoamfc8/WE3v/WOP68+jUPvK0681e
	 FlqU/LLFliKysQt79smyByN4nHT9ETrP39+ImwLXVYYhN5v4eeXLujz7kipolITcd6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="Qz/urx1t";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F68F60A2638;
	Mon,  2 Nov 2026 17:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F68F60A2638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Qz/urx1t
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3910516F3;
	Mon,  2 Nov 2026 09:20:31 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABE883FB9E;
	Mon,  2 Nov 2026 09:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793640034; bh=BxBrr70udayxaWonC/JoGNatfdqjF5UKhrB8xkcjNxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qz/urx1tqji9NmQKNsRp8JpqImZLfp0JlQOKFBWH9nsJvq55GlGCKIeGwk7CN676z
	 HW2ZmvwWKMvrbZIRFJtu1ZWwa+of/ylr3undEPIpvulsCRDG+oaKptqwHiW6BxQeUU
	 bdzKiPZ7rdGDRlk+/DpUWMSScl7PmqQPea6e/5yo=
Message-ID: <8bc11d0b-f7c6-49e1-b007-c0824deb7636@arm.com>
Date: Mon, 2 Nov 2026 17:20:32 +0000
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
Subject: Re: [PATCH 08/16] KVM: arm64: gic-v5: Add ITS translation cache
 maintenance
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-9-sascha.bischoff@arm.com>
 <sashiko-outbox-174606@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174606@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:10, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] kvm: missing memcg accounting for ITS translation cache allocations
> - [High] kvm: undersized ITS translation hash table causes raw spinlock DoS
> - [Medium] kvm: arm64: gic-v5: cache insertion failure drops valid LPI
> --
> 
> commit b6b2c7ac3d0d6dc377bf1fd1bb7de1527b73194f
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: gic-v5: Add ITS translation cache maintenance
> 
> This commit introduces a disposable acceleration structure to cache
> resolved ITS translations, avoiding iterating over guest memory on every
> MSI or ITS event.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
>> index f6d2acca4ae4c..e4c0415137605 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> 
> [ ... ]
> 
>> @@ -19,6 +19,272 @@
>>   #define VITS_V5_DEVICE_ID_BITS		16
>>   #define VITS_V5_EVENT_ID_BITS		16
> 
> [ ... ]
> 
>> +static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
>> +				     u32 device_id, u16 event_id,
>> +				     struct vgic_irq *irq)
>> +{
>> +	u64 key = ((u64)device_id << 16) | (u64)event_id;
>> +	struct its_cache_translation_entry *entry;
>> +	struct its_cache_translation_entry *old;
>> +	struct hlist_node *tmp;
>> +	HLIST_HEAD(removed);
>> +
>> +	entry = kzalloc_obj(*entry, GFP_KERNEL);
>> +	if (!entry)
>> +		return -ENOMEM;
> 
> [Severity: High]
> Does this allocation need memcg accounting?
> 
> The GFP_KERNEL flag is missing __GFP_ACCOUNT, which means these guest-driven
> allocations are not charged to the VM memory cgroup. Since the cache has no
> upper size bound, could a guest inject arbitrary device_id and event_id
> combinations via GICV5_ITS_GEN_EVENTR to exhaust host kernel memory and
> cause an out-of-memory denial of service?

That's a good point. The cache allocation is unaccounted in the posted 
patch. Due to the review comments, I've reworked the translation cache 
from a hash table to an XArray. As part of this, I've changed both the 
entry allocation and XArray insertion to use GFP_KERNEL_ACCOUNT.

> 
> [ ... ]
> 
>> +static int its_cache_look_up_translation(struct vgic_v5_its *its,
>> +					 u32 device_id, u16 event_id,
>> +					 struct vgic_irq **irq)
>> +{
>> +	u64 key = ((u64)device_id << 16) | (u64)event_id;
>> +	struct its_cache_translation_entry *entry;
>> +
>> +	guard(raw_spinlock)(&its->translation_cache_lock);
>> +
>> +	hash_for_each_possible(its->translation_cache, entry, node, key) {
> 
> [Severity: High]
> Can this traversal cause a host lockup under a raw spinlock?
> 
> Since the translation cache is unbounded, a guest could trigger the insertion
> of millions of LPI translations. These entries are distributed across a small
> fixed-size hash table, which will result in massive hash collisions and
> extremely long bucket chains.
> 
> Traversing tens or hundreds of thousands of entries under a raw spinlock
> disables preemption and interrupts for an extended period, which could
> lead to soft or hard CPU lockups.

I've replaced the fixed hash table with an XArray. I don't think that 
this same issue exists in the new implementation.

> 
> [ ... ]
> 
>> @@ -260,7 +530,15 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
>>   	if (IS_ERR(*irq))
>>   		return PTR_ERR(*irq);
>>   
>> -	return 0;
>> +	vgic_get_irq_ref(*irq);
>> +	ret = its_cache_add_translation(kvm, its, device_id, event_id, *irq);
>> +	if (ret) {
>> +		vgic_put_irq(kvm, *irq);
>> +		vgic_put_irq(kvm, *irq);
>> +		*irq = NULL;
>> +	}
>> +
>> +	return ret;
> 
> [Severity: Medium]
> Should a cache insertion failure cause the valid LPI to be dropped?
> 
> If its_cache_add_translation() fails due to memory pressure, this error
> handling path drops both the cache reference and the caller's successfully
> resolved reference, propagating the error and discarding the interrupt.
> 
> Since the translation cache is a best-effort acceleration structure, is it
> better to swallow the caching error and allow the caller to proceed with the
> validly resolved LPI rather than completely failing the resolution?

If we're dropping translation insertions due to memory pressure, then 
we're going to have big issues real soon! That said, a cache allocation 
failure should not discard an LPI already resolved for software MSI 
delivery or an ITS event, so I've made cache insertion best effort in 
those cases.

Direct injection still needs a cache entry to track its owner, as we 
need to be able to resolve which guest translation was used for the 
forwarding to correctly tear down translations when the guest 
invalidates them.

> 
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index c9eaa7897b57e..bf970275868c9 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
> 
> [ ... ]
> 
>> @@ -590,6 +591,12 @@ struct vgic_v5_its {
>>   		u32 device_id;
>>   	} gen_event_didr;
>>   
>> +	/* A hash table with 2^3 buckets */
>> +	DECLARE_HASHTABLE(translation_cache, 3);
>> +
>> +	/* Protects the translation_cache */
>> +	raw_spinlock_t translation_cache_lock;
> 
> [Severity: High]
> Is a 3-bit hash table (8 buckets) sufficient for an unbounded number of
> guest-driven translations?
> 
> As noted earlier, storing a potentially unbounded number of LPI translations
> in 8 buckets causes significant hash collisions. When paired with the
> translation_cache_lock raw spinlock, this creates the denial of service
> risk mentioned above.
> 

As I mentioned above, I've moved from a hashtable to an XArray for 
storing the translations. I'd not considered the case where a guest 
(maliciously?) causes many collisions. The irqfd lookup now uses RCU and 
does not take that lock, so I hope we're good there!

Thanks,
Sascha
