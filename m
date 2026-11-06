Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958276;
	b=Gm4Vu30VPQ1wrCa+C9GlGQ5LCt2gHOLwT1kHRVOvtgGkvEVvhiJ6tbXlnYTqC8xp7kLa
	 m/mMrtSF0S7EdqKLNRKmpIA/EZoV4CbNCceuCldTizLhqX5mgXnrfu0VUMBgBRW+PfpAA
	 3QSomw4pH9KXtQWq+xJOaKl2Z1js+dK1V+84AN7/lu/80cKsvcrPR2OQaHBjWRONMzS96
	 Tt29GxoLik3AlaDc4FVKBB67iP0tlsf8P9+FXukHhoONI8zC5isB3VhCqB/bP/fy4OSad
	 4M0ZBUW6pK9tNgY8DKzsqC8UhuHcasQZlFinbdp09WL0raPi8guWuK/B0TLSoE94azQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958276;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=3x30TCVHI6HA+CeHvlHb/+H3RtIDMYmugjilEli4TFo=;
	b=VcYH4brjovbqCYh+No/ryo8jzNqKEutzIMwrj/MiBHG3HjwncROPJzse85OpZ1SGWWMR
	 o8WRpMd8onBhZ3xd+tqB2qAhTpvF8TX4pXifGvC5Jd385guJZ+RN8Qn0bGwgppP6tG2QP
	 F12hpax01fdMZhHGpFsQpL8y+Au25labjUxWWcqr2kSspnmfMIGqwYqMb8Gw1/aGsRI01
	 sCz7MsTVRzlqVewE20YCzm0DxJ96bxrQRyAK4zg1uA3Cnn7yOoY7/UI7Ya/0QwTf3yFYa
	 PLrasCC0H2zXUOL1k3SwoklyylFfjxm983h8dzJuVCbgbOULAlzLpjS2rqfk4lVXt9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=gAIJS6Ha;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7624A606A338
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 09:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7624A606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=gAIJS6Ha
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3x30TCVHI6HA+CeHvlHb/+H3RtIDMYmugjilEli4TFo=;
	b=gAIJS6HaMixK13xBJxngCizzqXaVwAQAylIRB1e8UBqkX8JYSzj7oCVsGuI+kD0FtyWqrZCeO
	SRzsBCWQ6s7XTmyTWAmwPM+7+5Py8e2Lb/uMdsEta20vaiUGFwE64ocIONy5XOZzbTgI29bU1q2
	5fnLV0zl5K5XePyypLSDHUI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jLZ4w0RgBzcb0q;
	Fri,  6 Nov 2026 17:44:00 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 76A0540577;
	Fri,  6 Nov 2026 17:44:30 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 17:44:29 +0800
Message-ID: <3bc53520-0d1c-4fdf-88f3-d88295aa8a75@huawei.com>
Date: Fri, 6 Nov 2026 17:44:28 +0800
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
Subject: Re: [PATCH v5 09/15] KVM: arm64: Handle HDBSS faults
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-10-zhengtian10@huawei.com> <auifWrY1u72afXfJ@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auifWrY1u72afXfJ@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/2/2026 10:34 PM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:49PM +0800, Tian Zheng wrote:
>> From: Eillon <yezhenyu2@huawei.com>
>>
>> Once the buffer is full, hardware stops promoting writable-clean
>> descriptors and raises a stage-2 Permission fault with
>> ESR_EL2.ISS2.HDBSSF instead. Failed HDBSS accesses, such as external
>> aborts and granule protection faults, are reported the same way.
>>
>> Dispatch from kvm_handle_guest_abort() via the new esr_iss2_is_hdbssf()
>> helper. FSC == OK means the exit path already flushed, so resume the
>> guest; any other FSC is an error - clear it and report -EFAULT.
>>
>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/esr.h           |  5 +++++
>>   arch/arm64/include/asm/kvm_dirty_bit.h |  1 +
>>   arch/arm64/kvm/dirty_bit.c             | 29 ++++++++++++++++++++++++++
>>   arch/arm64/kvm/mmu.c                   |  4 ++++
>>   4 files changed, 39 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index f816f5d77f1a..4b3ccd407faa 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -437,6 +437,11 @@
>>   #ifndef __ASSEMBLER__
>>   #include <asm/types.h>
>>
>> +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
>> +{
>> +	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF);
>> +}
>> +
>>   static inline unsigned long esr_brk_comment(unsigned long esr)
>>   {
>>   	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
>> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
>> index d828e6b43fe9..eb2039820777 100644
>> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
>> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
>> @@ -39,5 +39,6 @@ static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
>>   int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
>>   void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>   void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
>> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
>>
>>   #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> index be0d12555c84..893a8c4248bc 100644
>> --- a/arch/arm64/kvm/dirty_bit.c
>> +++ b/arch/arm64/kvm/dirty_bit.c
>> @@ -98,3 +98,32 @@ void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.hdbss.hdbssprod_el2 = prod;
>>   	isb();
>>   }
>> +
>> +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 prod;
>> +	u64 fsc;
>> +
>> +	if (WARN_ON_ONCE(!system_supports_hdbss()))
>> +		return -EFAULT;
>> +
>> +	if (WARN_ON_ONCE(!vcpu_hdbss_enabled(vcpu)))
>> +		return -EFAULT;
>> +
>> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
>> +	fsc = FIELD_GET(HDBSSPROD_EL2_FSC_MASK, prod);
>> +
>> +	if (fsc == HDBSSPROD_EL2_FSC_OK)
>> +		/* Buffer full: the exit path drained it before handle_exit. */
>> +		return 1;
>> +
>> +	if (fsc != HDBSSPROD_EL2_FSC_ExternalAbort &&
>> +	    fsc != HDBSSPROD_EL2_FSC_GPF)
>> +		WARN_ONCE(1,
>> +			  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
>> +			  fsc, prod, vcpu->vcpu_id);
> 
> Any reason for using if() before warn_once, given the first parameter is a
> condition? I mean, why not use, instead:
> 
> +	WARN_ONCE(fsc != HDBSSPROD_EL2_FSC_ExternalAbort &&
> +		  fsc != HDBSSPROD_EL2_FSC_GPF,
> +		  "Unexpected HDBSS fault type, FSC: 0x%llx (prod=0x%llx, vcpu=%d)\n",
> +		  fsc, prod, vcpu->vcpu_id);
> 

Right, this is a syntax style closer to the Linux kernel. I will modify
it.

>> +
>> +	/* Clear FSC so hardware dirty state updates can resume. */
>> +	write_sysreg_s(prod & ~HDBSSPROD_EL2_FSC_MASK, SYS_HDBSSPROD_EL2);
>> +	return -EFAULT;
>> +}
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 85a98d2c23a9..7bf82d65041c 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -15,6 +15,7 @@
>>   #include <asm/pgalloc.h>
>>   #include <asm/cacheflush.h>
>>   #include <asm/kvm_arm.h>
>> +#include <asm/kvm_dirty_bit.h>
>>   #include <asm/kvm_mmu.h>
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/kvm_pkvm.h>
>> @@ -2315,6 +2316,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>
>>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>
>> +	if (esr_iss2_is_hdbssf(esr))
>> +		return kvm_handle_hdbss_fault(vcpu);
>> +
>>   	if (esr_fsc_is_translation_fault(esr)) {
>>   		/* Beyond sanitised PARange (which is the IPA limit) */
>>   		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> 
> I did not get the criteria used to positioning it here:
> Why placed before is_abt, if not using the result before returning?
> What is the rationale to putting it here?
> 
> Thanks!
> Leo

Ah, I'm sorry, there's no particular reason. I'll move it so it's placed
before is_abt.

Thanks!
Tian
