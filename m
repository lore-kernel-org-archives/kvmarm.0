Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DFB3B635C;
	Wed, 30 Sep 2026 08:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756839; cv=none; b=Zk6tTu5X8W4V1vZAwQvbTOaZ90LPofagwCb7ttExQSqgmtpace4DvniuqrvkIg1CWsV+bE2Sz7CVfOUMxNia3NIfmRu/Pec4O8SjAPeOHH+JlzmXa/jvToDRrTqLakkTpU8kBGPNEze5d/ZSvKY7l9UVesanFL4Pbg0+BEDJx7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756839; c=relaxed/simple;
	bh=w72+kYNnWQafaKAS/FlZpI8K9Ijx/4pBz1PwjLYC5ZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oKOln2MSIMfCRE7AlO0ZBiYvLvhmQA5OI9Y6pEi2R4DOAX5OlIWYbkT2CGWTcsg8+6+xqFEXH3ROaMAKTEfC95XzRu88LdUmXfZLVu2H2GjrfwlUweFKhVh+/ktPVdfm66FfjUmtpO2QZ62kq9qd0Pvoio8HgzImI1Qsx+cheHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oAe1w5qb; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oAe1w5qb"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vnL5tLdkKlxe+PYYqqEiDNYYSIH09lAMEtW7hHPZpTA=;
	b=oAe1w5qbYzs+YAW9r7h0tP7s9BBT7T7NPIN8bFYagHEawv35WmLhsHbm3pGvoQJL2wPHpNHJe
	Ay4mIb8oUchSYngvlds6ydubmEQuA58q20xfPsN1ELhx1SrfKizwsNhmj3vOUGZpVaZCp5ntRFP
	d6lk8AKMba1b5T3I1tU3fz8=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hvnsz3LhGzcb49;
	Wed, 30 Sep 2026 16:15:35 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6BAA640577;
	Wed, 30 Sep 2026 16:27:12 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 30 Sep 2026 16:27:11 +0800
Message-ID: <66d612c9-7051-4b71-870e-580ea377d2ae@huawei.com>
Date: Wed, 30 Sep 2026 16:27:11 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/15] KVM: arm64: Derive the VM hardware dirty mode
 from dirty logging
To: <sashiko-reviews@lists.linux.dev>
CC: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	<kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, Tian Zheng
	<zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-13-zhengtian10@huawei.com>
 <20260929111605.4EB631F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929111605.4EB631F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 7:16 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] KVM: arm64: Host kernel panic on nVHE via KVM_REQ_RELOAD_STAGE2
> - [High] KVM: arm64: HDBSS erroneously enabled for nested VMs
> - [High] KVM: arm64: Ampere AC03 CPU 38 hardware erratum mitigation bypass
> - [Medium] KVM: arm64: Data race on kvm->arch.mmu.vtcr
> --
> 
> commit 44b8e43689e1fc16603d982a85e0902b833fcf7d
> Author: Tian Zheng <zhengtian10@huawei.com>
> Subject: KVM: arm64: Derive the VM hardware dirty mode from dirty logging
> 
> Both HAFDBS and HDBSS flip VTCR_EL2.HD at memslot-update time. Two
> independent toggles allow an intermediate HDBSS-set/HD-clear state,
> an illegal combination, and need locking against concurrent updates.
> 
> Replace both with kvm_arch_update_hw_dirty_mode(), a pure function
> of the static capabilities and the number of logging memslots.
> 
> Link: https://lore.kernel.org/all/20260901171558.2674031-6-leo.bras@arm.com/
> 
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 6eae7e7e2a684..24407194444af 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
> [ ... ]
>> @@ -390,6 +390,24 @@ static inline bool kvm_supports_cacheable_pfnmap(void)
>>   	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
>>   }
>>   
>> +static inline bool kvm_supports_hafdbs(void)
>> +{
>> +	return IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && has_vhe() &&
>> +		cpus_have_final_cap(ARM64_HW_DBM);
>> +}
>> +
>> +static inline bool kvm_supports_hdbss(struct kvm *kvm)
>> +{
>> +	return system_supports_hdbss() && !kvm_has_nv(kvm);
>> +}
> 
> [Severity: High]
> Does this check reliably gate nested virtualization features if a memslot is
> created before vCPUs are initialized?
> 
> If userspace creates a memslot with dirty logging prior to initializing
> vCPUs, kvm_has_nv() evaluates to false because KVM_ARM_VCPU_HAS_EL2 is not
> yet set. This causes HDBSS to be erroneously enabled.
> 
> When vCPUs are subsequently initialized, the dirty mode is never
> re-evaluated, leaving HDBSS active for the nested VM. This bypasses the
> safety gates and can lead to host panics or data corruption.
> 

Yes, the timing hole is real. kvm_has_nv() reads kvm-
 >arch.vcpu_features, which is only populated at the first
KVM_ARM_VCPU_INIT. A memslot created before that derives the mode with
kvm_has_nv() still false and enables HDBSS, and nothing re-evaluates it
afterwards.

I'll recompute the mode once kvm_vcpu_set_target() succeeds — features
are fixed at that point, so a single recompute is complete. INIT always
precedes KVM_RUN, so the request inside the update is safe:

```
static int kvm_vcpu_set_target(...)
{
	...
	if (!kvm_vcpu_initialized(vcpu)) {
		ret = __kvm_vcpu_set_target(vcpu, init);
		if (ret)
			return ret;

		/*
		 * vCPU features have now fixed kvm_has_nv(), which a
		 * logging memslot created earlier could not have seen.
		 */
		kvm_arch_update_hw_dirty_mode(vcpu->kvm);
		return 0;
	}
	...
}
```

>> +
>> +void kvm_arch_update_hw_dirty_mode(struct kvm *kvm);
>> +
>> +static inline bool kvm_hw_dirty_enabled(struct kvm_s2_mmu *mmu)
>> +{
>> +	return mmu->vtcr & VTCR_EL2_HD;
>> +}
>> +
>>   #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>>   void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
>>   void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c1e09ba98d48a..17786453c0044 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
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
> 
> [Severity: High]
> Does this bypass the Ampere AC03 CPU 38 hardware erratum mitigation?
> 
> kvm_get_vtcr() correctly masks out VTCR_EL2_HA if the erratum is present.
> However, this code unconditionally sets VTCR_EL2_HA when
> kvm_supports_hafdbs() is true.
> 
> Since the erratum does not remove ARM64_HW_DBM support,
> kvm_supports_hafdbs() returns true, and this update unconditionally
> overwrites the mitigation on any memslot update.
> 

Right, I'll gate it in kvm_supports_hafdbs() so the mode never sets HA
on systems with an affected CPU:

```
static inline bool kvm_supports_hafdbs(void)
{
	return IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && has_vhe() &&
	 !cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) &&
	       cpus_have_final_cap(ARM64_HW_DBM);
}
```

ARM64_HW_DBM is a weak per-CPU cap, so in a mixed system one CPU could
enable it while the erratum workaround stays system-wide. This keeps
both checks consistent.

>> +
>> +	cur = kvm->arch.mmu.vtcr & (VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS);
>> +	if (cur == target)
>> +		return;
>> +
>> +	kvm->arch.mmu.vtcr = (kvm->arch.mmu.vtcr &
>> +			      ~(VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS)) |
>> +			     target;
> 
> [Severity: Medium]
> Can this plain read-modify-write of kvm->arch.mmu.vtcr cause a data race?
> 
> This update is performed under slots_lock, but concurrent page faults
> locklessly read this value via kvm_hw_dirty_enabled(). This plain C
> assignment violates the Linux Kernel Memory Model and could lead to
> load/store tearing and corrupted hardware state.
> 

Yes, this is a data race in the formal sense — the writer does a plain 
read-modify-write under slots_lock while kvm_hw_dirty_enabled() reads it 
locklessly on the fault paths, so KCSAN would flag it.

There's no actual corruption here, though: an aligned unsigned long is 
single-copy atomic on arm64, so there's no tearing, and a reader that 
sees the pre-flip value is covered by the reload request and TLBI that 
come with the flip.

The fix is the usual idiom for a locked writer with lockless readers — 
annotate both sides with READ_ONCE()/WRITE_ONCE() instead of taking a 
lock on the fault path:

```
static inline bool kvm_hw_dirty_enabled(struct kvm_s2_mmu *mmu)
{
	return READ_ONCE(mmu->vtcr) & VTCR_EL2_HD;
}
```

```
unsigned long cur, target, vtcr;
...

vtcr = READ_ONCE(kvm->arch.mmu.vtcr);
cur = vtcr & (VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS);
if (cur == target)
	return;

WRITE_ONCE(kvm->arch.mmu.vtcr,
	   (vtcr & ~(VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS)) |
	   target);
```

>> +
>> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
> 
> [Severity: Critical]
> Will this KVM_REQ_RELOAD_STAGE2 request cause a host kernel panic on an
> nVHE system?
> 
> When this request is handled by check_vcpu_requests() at EL1 on an nVHE
> host, it invokes __load_stage2(), which attempts to write directly to
> vtcr_el2. Because vtcr_el2 is an EL2-only register, this will trigger an
> Undefined Instruction exception and crash the host kernel.
> 

That's right. kvm_arch_update_hw_dirty_mode() is only useful in VHE
mode, so I'll gate it at the top like this:

```c
void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
{
	if (!kvm_supports_hafdbs())
		return;
	...
}
```

