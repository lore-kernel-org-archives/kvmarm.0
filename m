Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE82FE568
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 02:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762827158; cv=none; b=bBa0OqCbqO09ze5FtX0MEuLv+du0B/WRlSeYKMVhU1LysksEzhdhL0IhDLOiCYCctWbWZ63ZAMDjYDBnxIl43uWCrYD6j3+6AKjwSHaCOHmYoRzr9t73Qr3phctL5Kf0bywYbYPA3GdhXKKDhu5yozwOOocHHRBYh0keHe9DuIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762827158; c=relaxed/simple;
	bh=hYTA4N3OynG6J0xbCv+fr6rP7Ws9A8YbiHTuM/yMTas=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rUU9Ay2EZrGbBj0oQMhPtEhwkLHlXBXgEJttg/YgMn70VJxS3cck+XDN3H/7zfO6ORez1SA0Nwplm8JRmwmU6B37ld2twVBkpTnS9Tbd/oxcWTf4/ejdxQurMt+3TbzL3X5pVys7wm4zhW222vXAwsofyiEyMJZyJ8/HwoeWlUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d594L64VBznTvV;
	Tue, 11 Nov 2025 10:10:58 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FDE81A016C;
	Tue, 11 Nov 2025 10:12:31 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 10:12:30 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 10:12:30 +0800
Message-ID: <b9c8bb91-cd0f-c732-6b21-d8eb2ccc880e@hisilicon.com>
Date: Tue, 11 Nov 2025 10:12:07 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 1/7] KVM: arm64: Add exit to userspace on {LD,ST}64B*
 outside of memslots
Content-Language: en-US
To: Suzuki K Poulose <suzuki.poulose@arm.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-2-wangzhou1@hisilicon.com>
 <1f0d24ae-c20c-4067-aa0c-b5bbeba367db@arm.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <1f0d24ae-c20c-4067-aa0c-b5bbeba367db@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/7 19:48, Suzuki K Poulose wrote:
> On 07/11/2025 07:21, Zhou Wang wrote:
>> From: Marc Zyngier <maz@kernel.org>
>>
>> The main use of {LD,ST}64B* is to talk to a device, which is hopefully
>> directly assigned to the guest and requires no additional handling.
>>
>> However, this does not preclude a VMM from exposing a virtual device
>> to the guest, and to allow 64 byte accesses as part of the programming
>> interface. A direct consequence of this is that we need to be able
>> to forward such access to userspace.
>>
>> Given that such a contraption is very unlikely to ever exist, we choose
>> to offer a limited service: userspace gets (as part of a new exit reason)
>> the ESR, the IPA, and that's it. It is fully expected to handle the full
>> semantics of the instructions, deal with ACCDATA, the return values and
>> increment PC. Much fun.
>>
>> A canonical implementation can also simply inject an abort and be done
>> with it. Frankly, don't try to do anything else unless you have time
>> to waste.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> 
> We also need to document this new EXIT reason here :
> 
> Documentation/virt/kvm/api.rst
> 
> 
>> ---
>>   arch/arm64/kvm/mmio.c    | 27 ++++++++++++++++++++++++++-
>>   include/uapi/linux/kvm.h |  3 ++-
>>   2 files changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>> index 54f9358c9e0e..2a6261abb647 100644
>> --- a/arch/arm64/kvm/mmio.c
>> +++ b/arch/arm64/kvm/mmio.c
>> @@ -159,6 +159,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>       bool is_write;
>>       int len;
>>       u8 data_buf[8];
>> +    u64 esr;
>> +
>> +    esr = kvm_vcpu_get_esr(vcpu);
>>         /*
>>        * No valid syndrome? Ask userspace for help if it has
>> @@ -168,7 +171,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>        * though, so directly deliver an exception to the guest.
>>        */
>>       if (!kvm_vcpu_dabt_isvalid(vcpu)) {
>> -        trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
>> +        trace_kvm_mmio_nisv(*vcpu_pc(vcpu), esr,
>>                       kvm_vcpu_get_hfar(vcpu), fault_ipa);
>>             if (vcpu_is_protected(vcpu))
>> @@ -185,6 +188,28 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>           return -ENOSYS;
>>       }
>>   +    /*
>> +     * When (DFSC == 0b00xxxx || DFSC == 0b10101x) && DFSC != 0b0000xx
>> +     * ESR_EL2[12:11] describe the Load/Store Type. This allows us to
>> +     * punt the LD64B/ST64B/ST64BV/ST64BV0 instructions to luserspace,
> 
> minor nit: typo: s/luserspace/userspace/ 

Will fix this in next version.
> 
>> +     * which will have to provide a full emulation of these 4
>> +     * instructions.  No, we don't expect this do be fast.
>> +     *
>> +     * We rely on traps being set if the corresponding features are not
>> +     * enabled, so if we get here, userspace has promised us to handle
>> +     * it already.
>> +     */
>> +    switch (kvm_vcpu_trap_get_fault(vcpu)) {
>> +    case 0b000100 ... 0b001111:
>> +    case 0b101010 ... 0b101011:
> 
> Matches Arm ARM.

Here is mentioned in L.b D24.2.40(page 7526). It does not include 0b0000xx,
so first case in above code is "case 0b000100 ... 0b001111", just skip 0b0000xx.

> 
>> +        if (FIELD_GET(GENMASK(12, 11), esr)) {
>> +            run->exit_reason = KVM_EXIT_ARM_LDST64B;
>> +            run->arm_nisv.esr_iss = esr & ~(u64)ESR_ELx_FSC;
> 
> Any particular reason why we diverge from the NISV case, where the FSC is provided,> but not here ? May be this needs to be documented too.

NISV case and this case is different. NISV indicates whether the syndrome information
in ISS[23:14] is valid, bits[12:11](LST) indicates which LS64 instruction generated
the data abort. Not sure why did we mask FSC, seems that LST already offers related
information.

Best,
Zhou

> 
> Suzuki
> 
> 
>> +            run->arm_nisv.fault_ipa = fault_ipa;
>> +            return 0;
>> +        }
>> +    }
>> +
>>       /*
>>        * Prepare MMIO operation. First decode the syndrome data we get
>>        * from the CPU. Then try if some in-kernel emulation feels
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 52f6000ab020..d219946b96be 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -179,6 +179,7 @@ struct kvm_xen_exit {
>>   #define KVM_EXIT_LOONGARCH_IOCSR  38
>>   #define KVM_EXIT_MEMORY_FAULT     39
>>   #define KVM_EXIT_TDX              40
>> +#define KVM_EXIT_ARM_LDST64B      41
>>     /* For KVM_EXIT_INTERNAL_ERROR */
>>   /* Emulate instruction failed. */
>> @@ -401,7 +402,7 @@ struct kvm_run {
>>           } eoi;
>>           /* KVM_EXIT_HYPERV */
>>           struct kvm_hyperv_exit hyperv;
>> -        /* KVM_EXIT_ARM_NISV */
>> +        /* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
>>           struct {
>>               __u64 esr_iss;
>>               __u64 fault_ipa;
> 
> 
> 
> 
> .
