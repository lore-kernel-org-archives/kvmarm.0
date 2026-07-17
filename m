Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11365288C3D
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 03:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784260692; cv=none; b=iMNKrXMOJyBgvKv/zmNtoOZClH4J34VfsARTLWKLAFjmiei2MG2U9JYr0uNCR2K8C4NxnuzABgYshJct0iBgYa3y7wCoIEFfLyHJUVvYg6SsM2aOmkaQWjqjbgu5Tdr9ZJw9yY9/IselVatHBHv/0labU6k8iZI/mii3ja9dpYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784260692; c=relaxed/simple;
	bh=Mzq98crAhyn7P+66ai/t3ljnoidKXUOfHL8K8sK8M3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=erMoCTlBkhcEyU9TZYUjznrjNu8GpsXJJqpPhSKs+cP9TIQO+jWmX1oPoQC2T0TYYdKXr0DhK0mZaOHYzZB65y/JYcCyO/zEnjXz57XrvRci8LcXDgSCT1ss1OYOdUiaWyjRTW/8u9hWruGxy970lI9XrujQJr2Z0TcdOAND3vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TmsvjBY+; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TmsvjBY+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EZieNmbL4He5C8K2KrAUxxR7EUcsvEBRn9bKC7gbbrA=;
	b=TmsvjBY+r52h7d3mKD6Mh6hjchO30XC+iREPzrU9HRz+p2uD+pzog53GVUa+RdKMp/CCivGIl
	/VuPY7lVtEIM9VAd+Hv/taTFJ0lSsoNtilJ5idIAEzoBUaPp2kCFHGNh5yh1Nmx68wrYJ0mT+CZ
	rqE7JNbGFpMZ/EfVKK6CUjc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h1bVQ05c1z12LDV;
	Fri, 17 Jul 2026 11:48:30 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id C2E754056E;
	Fri, 17 Jul 2026 11:58:06 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 17 Jul 2026 11:58:05 +0800
Message-ID: <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com>
Date: Fri, 17 Jul 2026 11:58:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware
 dirty tracking
To: Oliver Upton <oupton@kernel.org>
CC: <maz@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>, <yezhenyu2@huawei.com>,
	<yubihong@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <leo.bras@arm.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-4-zhengtian10@huawei.com>
 <aliKo7dTZzKcWHzI@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <aliKo7dTZzKcWHzI@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 7/16/2026 3:39 PM, Oliver Upton wrote:
> Hi Tian,
>
> On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
>> -	if (prot & KVM_PGTABLE_PROT_W)
>> +	if (prot & KVM_PGTABLE_PROT_W) {
>>   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>>
>> +		/*
>> +		 * No DEVICE filter needed here: relax_perms is only called
>> +		 * on FSC_PERM faults. Device pages always get full RW from
>> +		 * initial mapping and are never write-protected during
>> +		 * migration, so they never trigger a permission fault.
>> +		 */
>> +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
>> +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +	} else {
>> +		/*
>> +		 * Clear DBM on W→RO downgrade to prevent hardware from
>> +		 * silently upgrading RO+DBM back to W+dirty, which would
>> +		 * bypass KVM's write tracking and cause data corruption.
>> +		 */
>> +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
>> +	}
>> +
> This block makes it pretty evident that the DBM bit really *is* the
> write permission bit. I'd much rather we introduce the concept of dirty
> state to the page table library and migrate the abstract write
> permission to the DBM field, even if we don't have FEAT_HAFDBS.
>
> That way everything 'just works' from outside the page-table library:
> write-protecting hugepages would have the effect of clearing DBM and we
> can separately reap dirty state from page descriptors.
>
> If/when the architecture forces FEAT_S2PIE upon us we will need to make
> this change anyway since dirty state management is unconditional and
> handled separately from the actual permissions.
>
> Thanks,
> Oliver


Hi Oliver,

Thanks again for your insightful review. Following your suggestion, I've

reworked the design around a unified three-state model that works regardless

of whether FEAT_HAFDBS is implemented:

**State table**
State                       | DBM | S2AP[1] | Without HTTU         | 
With HTTU (HAFDBS)
Non-writable   (N)  |  0     |    0         | write -> fault, inject    
     | write -> fault, inject
Writable-clean (C)  |  1     |    0         | write -> fault, sw C->D  
  | write -> hw C->D, no fault, HDBSS logs
Writable-dirty (D)   |  1     |    1         | writable, no fault       
     | writable, no fault

**Proposed changes**
1. Remove KVM_PGTABLE_S2_DBM from enum kvm_pgtable_stage2_flags

— VTCR_EL2.{HD,HDBSS,HA} enablement in kvm_arm_enable_hdbss_global()

already keys off kvm->arch.enable_hdbss / system_supports_hdbss().

2. stage2_set_prot_attr() — set DBM unconditionally on writable pages:
```
if (prot & KVM_PGTABLE_PROT_W) {
     attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
     /* Writable-dirty: DBM=1 conveys write intent, S2AP[1]=1 marks dirty */
     attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
}
```

3. kvm_pgtable_stage2_relax_perms() — drop the else branch entirely:
```
if (prot & KVM_PGTABLE_PROT_W) {
     set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
     /* Non-writable -> Writable-dirty: restore both write intent and 
dirty state */
     set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
}
/* no else: callers passing !W (e.g. exec faults) must not touch DBM */
```

4. kvm_pgtable_stage2_wrprotect() — unchanged: it only clears S2AP1 (D->C).

DBM is preserved so HDBSS re-arms next round.
  ```
int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 
size)
{
    /* Writable-dirty -> Writable-clean: clear dirty state (S2AP_W),
    * preserve write intent (DBM) so HDBSS re-arms for next write.
     */
     return stage2_update_leaf_attrs(pgt, addr, size, 0,
                          KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
                          NULL, NULL,
                          KVM_PGTABLE_WALK_IGNORE_EAGAIN);
}
```

**One clarification**
In the three-state model above, wrprotect() clears S2AP[1] but preserves 
DBM (D->C).

This allows HDBSS to re-arm on the next write. If we instead cleared DBM 
as well (->N),

HDBSS would be permanently disabled on that page and we'd lose the 
benefit of hardware

dirty tracking.


So my understanding is:

wrprotect() (dirty tracking): D->C — clears S2AP[1], preserves DBM

mkreadonly() (true RO, future): ->N — clears both S2AP[1] and DBM

Does this match what you had in mind?

Looking forward to your thoughts.

Thanks,
Tian


