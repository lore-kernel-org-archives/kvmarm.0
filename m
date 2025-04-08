Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F59263F43
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 08:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744099905; cv=none; b=MkhA5zfiUmyPFOHxQb3fHrcQ08bXiQUw5GnUeDoDU570S/2uzhIab0q8u3yBTq9ziHGhBFvqTRuYOcm5izWn9Gi4NmJ8J1hGxCpkJK39qDAfDuLfVIsSVtS8ERHqk7shbrZ2BsSJTYIDY69Kir/ujfUibxxCTkUp8XeTpFjCm2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744099905; c=relaxed/simple;
	bh=FxYoGDCd/cHFcZ2fsubOHjOGdK9XfaWuBq2wby33psQ=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=j1rgKzfZKqFrypNsl6MdJtEq/KVnLSF/37tRjtPfYxPX9hl5hdQQaK6Ehqg6IxSqzoMGFpTMlEmRFNMkuLKgivQr53cCBw1wTf0G8NRiGaGmBnFetnZOA+uS802OqwkEwCTn1Qe5e2b4NhKKUMXIYE/2jU1eNBCoBigFlnN8LB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZWzKq25m1z13LWd;
	Tue,  8 Apr 2025 16:10:55 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id C0DD51800E4;
	Tue,  8 Apr 2025 16:11:34 +0800 (CST)
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 8 Apr 2025 16:11:33 +0800
CC: <yangyicong@hisilicon.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<maz@kernel.org>, <corbet@lwn.net>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kselftest@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <shuah@kernel.org>, <jonathan.cameron@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <tangchengchang@huawei.com>
Subject: Re: [PATCH v2 6/6] KVM: arm64: Handle DABT caused by LS64*
 instructions on unsupported memory
To: Oliver Upton <oliver.upton@linux.dev>
References: <20250331094320.35226-1-yangyicong@huawei.com>
 <20250331094320.35226-7-yangyicong@huawei.com> <Z-wQuJAefT3xNipl@linux.dev>
 <e9674079-9a22-c3cd-3b00-5989f6926303@huawei.com>
 <Z_NkHWStDJLo0cmY@linux.dev>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <3355f89a-aecf-6ec7-b8ee-6faf6f1f7106@huawei.com>
Date: Tue, 8 Apr 2025 16:11:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z_NkHWStDJLo0cmY@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200014.china.huawei.com (7.221.188.8)

On 2025/4/7 13:35, Oliver Upton wrote:
> On Mon, Apr 07, 2025 at 11:33:01AM +0800, Yicong Yang wrote:
>> On 2025/4/2 0:13, Oliver Upton wrote:
>>> On Mon, Mar 31, 2025 at 05:43:20PM +0800, Yicong Yang wrote:
>>>> @@ -1658,6 +1658,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>> Keep in mind that data aborts with DFSC == 0x35 can happen for a lot
>>> more than LS64 instructions, e.g. an atomic on a Device-* mapping.
>>>
>>
>> got it. 0x35 should be caused by LS64* or IMPLEMENTATION DEFINED fault, but no
>> further hint to distinguish between these two faults. hope it's also the right
>> behaviour to inject a DABT back for the latter case.
> 
> There isn't exactly a 'right' behavior here. The abort could either be
> due to a bug in the guest (doing an access on something knows it can't)
> or the VMM creating / describing the IPA memory map incorrectly.
> 
> Since KVM can't really work out who's to blame in this situation we should
> probably exit to userspace + provide a way to reinject the abort.
> 

as mentioned below, maybe the proper way is to handle it like KVM_EXIT_ARM_NISV. In this
case exit to userspace with KVM_EXIT_ARM_LDST64B, if it's due to the wrong mapping of the
guestOS then reinject the DABT back to the guest, otherwise the userspace need to check
whether it's reporting the memory region correctly and handle in its own way.

>>>> @@ -1919,6 +1939,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>>>  			goto out_unlock;
>>>>  		}
>>>>  
>>>> +		/*
>>>> +		 * If instructions of FEAT_{LS64, LS64_V} operated on
>>>> +		 * unsupported memory regions, a DABT for unsupported
>>>> +		 * Exclusive or atomic access is generated. It's
>>>> +		 * implementation defined whether the exception will
>>>> +		 * be taken to, a stage-1 DABT or the final enabled
>>>> +		 * stage of translation (stage-2 in this case as we
>>>> +		 * hit here). Inject a DABT to the guest to handle it
>>>> +		 * if it's implemented as a stage-2 DABT.
>>>> +		 */
>>>> +		if (esr_fsc_is_excl_atomic_fault(esr)) {
>>>> +			kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
>>>> +			return 1;
>>>> +		}
>>>> +
>>>
>>> A precondition of taking such a data abort is having a valid mapping at
>>> stage-2. If KVM can't resolve the HVA of the fault then there couldn't
>>> have been a stage-2 mapping.
>>>
>>
>> Here's handling the case for emulated mmio, I thought there's no valid stage-2 mapping
>> for the emulated MMIO? so this check is put just before entering io_mem_abort(). should
>> it be put into io_mem_abort() or we just don't handle the emulated case?
> 
> Right -- there's no valid stage-2 translation for _most_ MMIO. If KVM
> cannot find an HVA for the fault (look at the condition that gets us
> here) then we know there isn't a stage-2 mapping. How would we know what
> to map?
> 
> In that case I would expect to take a Translation fault with instruction
> syndrome that can can be used to construct an exit to the VMM.

you're right, I misunderstand here. If there's no stage-2 mapping we'll have
a translation fault here rather than an unsupported exclusive or atomic access
fault. So no need to check and handle it here since we won't have such a fault
in this case.

> Marc had
> some patches on list to do exactly that [*].
> 
> However, after reading this again there's a rather ugly catch. The KVM
> ABI has it that writes to a RO memlot generate an MMIO exit, so it *is*
> possible to get here w/ a stage-2 mapping. Unfortunately there's no
> instruction syndrome with DFSC = 0x35 so no way to decode the access.
> 
> This is starting to sound similar an nISV MMIO abort...
> 

yes similiar to nISV MMIO and no ISV as well. Per-spec DABT caused by LS64* has ISV==1
if it's a Translation fault, Access flag fault, or Permission fault, but not for
unsupported exclusive or atomic access fault..

> [*]: https://lore.kernel.org/kvmarm/20240815125959.2097734-1-maz@kernel.org/
> 

Thanks.


