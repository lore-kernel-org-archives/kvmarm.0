Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795425233;
	b=B01L5CcbtJPXjBbrinqrDPq/+yaBqWq1rr6Hw91mgwIUEHzKb7R/OIY0IdcJRpL+IyPB
	 OcJCq3IT9fszbNiKh4L/2Rq1v6s3uvpiT83i1EX8QuOUx1ieuAHUWEanjJMhEdGJ2UWmS
	 AQvvuHEQN9Oas+0YANRQHSqy3sg+NqC+tjU9aX9BAldbjn0rQCakQBCxP/DFqeX2gUlTA
	 97kJ2m2viFf0uERkLWVtQxypJIHxfHoxJ4VHJNANW5rNlHYqcRbLvKwXNtpZai1xf/mv0
	 Vg22wxTuCdikodhQT6kjmhOCHkWIGbpoqBz1eoWe8C9CnCBILSeI9knL+X44ILR6rzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795425233;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=PNz8/jThACatQrxxgBfShzbz4pyu8AsglZobIfmyAmA=;
	b=A1tJIx+pOJT2rIyYcpDTXTiRlQvdC+uxfW7YqvFnDAfSAKL6HEVi3p43aleHNqne4M8c
	 +pAQhfPIe4jB9HPpbVF+o2BkGA5SRMUGwdemdAO+rvv2puuLz003KMne7PdfNsoqK13hd
	 9FZEus34nBt/6TtfI3MusSBpslpk1XAt0km7sgRL65ENeqC7M+Q5HRg5BwZJJOwHpt0B0
	 UQDjcctJISmC1a52ue0ybQcnhxir3cwtTtGWwy7wRZ3y17lOv1QQrewjbH3eXKvehlPPs
	 M19eGQeLhm/7SmaCY5sO9N1DxHcXpJha+V9zO51yQQFSFqBkTZ1BoAF/JbdBMhPL2hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SrDuu9va;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB435606A321;
	Mon, 23 Nov 2026 09:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB435606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SrDuu9va
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PNz8/jThACatQrxxgBfShzbz4pyu8AsglZobIfmyAmA=;
	b=SrDuu9vaZiChaDMfB+FzRKchqdFncFCexaNYmvtoQFjyxz1BtUNyYYBaPKzsZWzyR1mpOTTOl
	v8goqh8fqTe59eA2QvFKllDS7Lqyq4TJgMgYxOHiNsQ/LzreJ8QlacqSm9kHSsUAJLfWH5RF0R+
	0p5yBRuUpklU9vchEGU6CUE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jY0bn2TJQzmV7s;
	Mon, 23 Nov 2026 17:13:25 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id DDD254055B;
	Mon, 23 Nov 2026 17:13:47 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 23 Nov 2026 17:13:47 +0800
Message-ID: <069ff131-882c-43a8-8654-006cb9942eba@huawei.com>
Date: Mon, 23 Nov 2026 17:13:46 +0800
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
Subject: Re: [PATCH v5 14/15] KVM: arm64: Document HDBSS buffer size ioctl
To: <sashiko-reviews@lists.linux.dev>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	"tangchengchang@huawei.com" <tangchengchang@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-15-zhengtian10@huawei.com>
 <20260929110638.D19171F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929110638.D19171F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 7:06 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] kvm: arm64: missing vCPU kick in kvm_arch_update_hw_dirty_mode causes data corruption
> - [High] kvm: arm64: stage2_wrprotect_walker clobbers concurrent hardware PTE updates
> - [Medium] kvm: uapi: enabling dirty ring silently resets HDBSS buffer size
> - [Low] kvm: uapi: KVM_CHECK_EXTENSION misused to return mutable VM state
> --
> 
> commit ad3d8df658768bdca959742e1b61e3dd3914fdd8
> Author: Tian Zheng <zhengtian10@huawei.com>
> 
> KVM: arm64: Document HDBSS buffer size ioctl
>      
> Document KVM_CAP_ARM_HDBSS_BUFFER_SIZE, which lets userspace configure the
> per-vCPU HDBSS buffer size for hardware-assisted dirty tracking during live
> migration.
> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -9056,6 +9056,34 @@ enabled, cmma can't be enabled anymore and pfmfi and the storage key
>>   interpretation are disabled. If cmma has already been enabled or the
>>   hpage_2g module parameter is not set to 1, -EINVAL is returned.
>>   
>> +7.48 KVM_CAP_ARM_HDBSS_BUFFER_SIZE
>> +-----------------------------------
>> +
>> +:Architectures: arm64
>> +:Target: VM
>> +:Parameters: args[0] is the per-vCPU HDBSS buffer size in bytes
>> +:Returns: 0 on success; -EINVAL if the size is invalid or vCPUs have already
>> +          been created; -EBUSY if the buffer size was already configured.
>> +
>> +This capability configures the per-vCPU HDBSS buffer size used for
>> +hardware-assisted dirty tracking during live migration.
>> +
>> +Userspace sets the size in bytes via KVM_ENABLE_CAP. KVM allocates
>> +per-vCPU HDBSS buffers of the requested size.
>> +
>> +KVM_CHECK_EXTENSION returns the maximum supported size (``SZ_2M``)
>> +when queried without a VM, or the configured per-VM size (default
>> +``PAGE_SIZE``) when queried with a VM.
> 
> [Severity: Low]
> KVM_CHECK_EXTENSION is designed to advertise static feature support and
> limits, not to serve as a GET interface for mutable, dynamically configured
> VM attributes.
> 
> Would it be better to use a dedicated interface to read back this dynamic
> state instead of KVM_CHECK_EXTENSION?
> 
>> +
>> +Constraints:
>> +
>> +- The size must be a power of two in [``PAGE_SIZE``, ``SZ_2M``].
>> +- Dirty-bitmap mode only: rejected with -EINVAL once the dirty ring
>> +  (``KVM_CAP_DIRTY_LOG_RING``) is enabled, and enabling the ring after
>> +  a size was set resets it to the default.
> 

You are right, we will fix this. KVM_CHECK_EXTENSION now returns the 
maximum supported size only, matching how KVM_CAP_DIRTY_LOG_RING reports 
the ring size limit:

```
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -519,11 +519,7 @@ int kvm_vm_ioctl_check_extension(str
        case KVM_CAP_ARM_HDBSS_BUFFER_SIZE:
-             if (!system_supports_hdbss())
-                     r = 0;
-             else if (kvm)
-                     r = kvm->arch.hdbss_buffer_size;
-             else
-                     r = KVM_ARM_HDBSS_MAX_SIZE;
+             r = system_supports_hdbss() ? KVM_ARM_HDBSS_MAX_SIZE : 0;
                break;
```

> [Severity: Medium]
> The KVM guidelines mandate that new memslot and vCPU flags default to
> immutable.
> 
> Instead of silently mutating previously configured state (which can lead to
> unpredictable state-machine transitions that userspace is not prepared
> for), should this incompatible capability configuration fail explicitly by
> returning an error like -EINVAL?
> >> +- Must be set before any vCPU is created; a second setting is rejected
>> +  with -EBUSY.
>>   
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
> 

You were right, and the reset is gone. The ring enable never touches the 
buffer size, and the two are now fully decoupled: any buffer size works 
with any ring size.

> [ ... ]
> 
>> @@ -1285,12 +1298,47 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>>   	return 0;
>>   }
>>   
>> +static int stage2_wrprotect_walker(const struct kvm_pgtable_visit_ctx *ctx,
>> +				   enum kvm_pgtable_walk_flags visit)
>> +{
>> +	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +
>> +	/* We remove DBM on blocks so they can fault and get split */
>> +	if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
>> +		new &= ~KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +
>> +	if (kvm_pte_valid(ctx->old) && ctx->old != new &&
>> +	    (ctx->old & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W) &&
>> +	    ctx->mm_ops->mark_page_dirty)
>> +		ctx->mm_ops->mark_page_dirty(kvm_pte_to_phys(ctx->old));
>> +
>> +	/*
>> +	 * The plain WRITE_ONCE races with hardware updates; both are
>> +	 * benign.
>> +	 *
>> +	 * AF: the update may be lost, and is set on the next access.
>> +	 *
>> +	 * Dirty state: we only rewrite entries whose old value had S2AP[1]
>> +	 * set, while hardware only promotes entries with S2AP[1] clear, so
>> +	 * the two never touch the same entry. The one overlap is DBM removal
>> +	 * on writable-clean blocks: a racing promotion is demoted back to
>> +	 * read-only, but the write is still recorded in the HDBSS buffer and
>> +	 * the folio was marked dirty at fault-in, so nothing is lost.
>> +	 */
>> +	if (kvm_pte_valid(ctx->old) && ctx->old != new)
>> +		WRITE_ONCE(*ctx->ptep, new);
> 
> [Severity: High]
> The global review guidelines strictly mandate: When KVM updates SPTE bits that
> the hardware page-table walker also writes (Dirty/Access on leaf entries), the
> update must not clobber a concurrent hardware update.
> 
> Since WRITE_ONCE unconditionally overwrites the PTE with the old masked
> value, could this non-atomic write in stage2_wrprotect_walker() clobber
> concurrent hardware updates to the Access Flag (AF) or Dirty Bit on leaf
> PTEs?
> 

The AF race is real but known and harmless. stage2_attr_walker(), which 
upstream uses for the same write-protect path, has the exact same 
read-modify-write pattern and its own comment on it:

"We may race with the CPU trying to set the access flag
here, but worst-case the access flag update gets lost and
will be set on the next access instead."

For the dirty bit the two writers are disjoint. The walker only rewrites 
entries it read as already dirty, while hardware only promotes clean 
entries, so they never touch the same PTE, and a leaf whose value is 
unchanged is not written at all.

>> +
>> +	return 0;
>> +}
>> +
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> 
> [ ... ]
> 
>> @@ -2581,6 +2629,45 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
>>   	return err;
>>   }
>>   
>> +/*
>> + * The VM's hardware dirty-management mode is a derived value, a pure
>> + * function of the static capabilities and the number of logging
>> + * memslots, so recomputing it on every event cannot lose an update
>> + * and needs no locking against racing writers:
>> + *
>> + *   logging && HDBSS-capable  ->  HD|HA|HDBSS (hardware tracking)
>> + *   logging, no HDBSS         ->  off (write-protect faults)
>> + *   !logging && HAFDBS-cap.   ->  HD|HA (only written pages go dirty)
>> + */
>> +void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
>> +{
>> +	unsigned long cur, target;
>> +	bool logging = atomic_read(&kvm->nr_memslots_dirty_logging) != 0;
>> +
>> +	if (logging && kvm_supports_hdbss(kvm))
>> +		target = VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS;
>> +	else if (logging || !kvm_supports_hafdbs())
>> +		target = 0;
>> +	else
>> +		target = VTCR_EL2_HD | VTCR_EL2_HA;
>> +
>> +	cur = kvm->arch.mmu.vtcr & (VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS);
>> +	if (cur == target)
>> +		return;
>> +
>> +	kvm->arch.mmu.vtcr = (kvm->arch.mmu.vtcr &
>> +			      ~(VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS)) |
>> +			     target;
>> +
>> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
>> +
>> +	/*
>> +	 * The request only reloads VTCR_EL2; cached translations keep
>> +	 * the old permissions until invalidated.
>> +	 */
>> +	kvm_flush_remote_tlbs(kvm);
> 
> [Severity: Critical]
> Inside kvm_arch_update_hw_dirty_mode(), kvm_make_all_cpus_request() is issued
> with KVM_REQ_RELOAD_STAGE2, which is defined as:
> 
> #define KVM_REQ_RELOAD_STAGE2 \
> 	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> 
> The KVM_REQUEST_NO_WAKEUP flag prevents the request from interrupting running
> vCPUs. The subsequent kvm_flush_remote_tlbs() executes a hardware broadcast TLBI
> and also does not send IPIs.
> 
> Because running vCPUs are never kicked out of guest mode, won't they
> continue executing with their physical VTCR_EL2 register holding the
> stale state (HD=1)?
> 
> If software dirty logging is active but HDBSS is not correctly synchronized
> on the CPU, the hardware page table walker could silently promote
> writable-clean PTEs to writable-dirty without trapping. Since KVM never
> sees the write, could this cause silent data loss during live migration?
> 
>> +}
> 

They are kicked out. KVM_REQUEST_NO_WAKEUP only skips waking halted 
vCPUs, the IPI decision in kvm_request_needs_ipi() never consults it, 
and with KVM_REQUEST_WAIT the request IPIs every vCPU in guest mode and 
waits for all of them to leave, the same flag pair KVM_REQ_TLB_FLUSH 
relies on. Re-entering the guest goes through check_vcpu_requests(), 
which calls __load_stage2() for this request, and a halted vCPU passes 
the same check on wakeup, so no guest execution ever runs with the old VTCR.

Thanks,
Tian
