Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA7E136E05
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715308812; cv=none; b=H1IdrqkWWK18+Yx1P04pyIPRJX1Rf9LOPFIdoKEUUJNfLq4pqVP7Gdl0DFiTNLIS0HimYEyTpR8Tg/78gNF4dWVYZ9B2GH4cSvjlclgGfDsyKz7KdzQ+zHZ/IvUQYmR1MQ3fm+r1fTUeNP36B6EnRMwc3n+Py8i+2gmYOtcyFB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715308812; c=relaxed/simple;
	bh=AoaoxXjDC5mMtOPbHPCBAlHp20NWsnjTKv0XtoVvxKQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Z9vGHsLJTGuaFk5+QqAQt5vlAG+FhYzMSjiQDaiO+1XUMPi6KvcohUaz9JlAPJ1Gu+Xb5t8mjR4rpnxWs5dAz0nZRqive0E+GMcEY0wlJWIYeWh0YHMjrfqtFSha3s97XO5dFW+bFYNJL8+ZEDrUwXtPN+eReHYO8OndHp5ACP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VbCkN2kTTz1xmpC;
	Fri, 10 May 2024 10:38:52 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id E00FE1402D0;
	Fri, 10 May 2024 10:40:00 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 10:39:59 +0800
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
To: Fuad Tabba <tabba@google.com>
CC: <kvmarm@lists.linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <seanjc@google.com>, <alexandru.elisei@arm.com>,
	<catalin.marinas@arm.com>, <philmd@linaro.org>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <oliver.upton@linux.dev>, <mark.rutland@arm.com>,
	<broonie@kernel.org>, <joey.gouly@arm.com>, <rananta@google.com>,
	<smostafa@google.com>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
 <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com>
Date: Fri, 10 May 2024 10:39:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/5/10 1:46, Fuad Tabba wrote:
> Hi Zenghui,
> 
> On Thu, May 9, 2024 at 3:10 PM Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> Hi Fuad,
>>
>> On 2024/4/23 23:05, Fuad Tabba wrote:
>>> Since the host_fpsimd_state has been removed from kvm_vcpu_arch,
>>> it isn't pointing to the hyp's version of the host fp_regs in
>>> protected mode.
>>>
>>> Initialize the host_data fpsimd_state point to the host_data's
>>> context fp_regs on pKVM initialization.
>>>
>>> Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch")
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
>>>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 +++++++++++
>>>  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
>>>  3 files changed, 13 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
>>> index 82b3d62538a6..20c3f6e13b99 100644
>>> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
>>> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
>>> @@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
>>>  }
>>>  
>>>  void pkvm_hyp_vm_table_init(void *tbl);
>>> +void pkvm_host_fpsimd_state_init(void);
>>>  
>>>  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>>>  		   unsigned long pgd_hva);
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> index 26dd9a20ad6e..492b7fc2c0c7 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>> @@ -247,6 +247,17 @@ void pkvm_hyp_vm_table_init(void *tbl)
>>>  	vm_table = tbl;
>>>  }
>>>  
>>> +void pkvm_host_fpsimd_state_init(void)
>>> +{
>>> +     unsigned long i;
>>> +
>>> +     for (i = 0; i < hyp_nr_cpus; i++) {
>>> +             struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
>>> +
>>> +             host_data->fpsimd_state = &host_data->host_ctxt.fp_regs;
>>
>> So we save the host FP/SIMD state in hypervisor's private host_ctxt when
>> guest accesses to FP/SIMD. Do we then need to save it into host VCPU's
>> process state and (if so,) how does that happen?
> 
> Depends on which tree you're looking at. This is all new in
> kvmarm/next [1], and I don't think it has made it to the main tree
> yet.

I had looked at Marc's "host-data" series before your series, so we
should at the same position.

> If you look in kvmarm/next, the file arch/arm64/include/asm/kvm_host.h
> has "struct kvm_host_data", which has a pointer to fpsimd_state, which
> you've already seen.
> 
> For normal mode, i.e., without kvm: In arch/arm64/kvm/fpsimd.c,

"without pkvm"?

> kvm_arch_vcpu_load_fp(), which is called when a vcpu is loaded,
> assigns that pointer to the current task's fpsimd_state:
> 
>     *host_data_ptr(fpsimd_state) =
> kern_hyp_va(&current->thread.uw.fpsimd_state);
> 
> You might have missed it because it uses the host_data_ptr() macro to
> access struct kvm_host_data

Actually I was not asking for the normal mode (VHE, Hyp nVHE), where we
save the host's FP/SIMD state directly into the current task's
fpsimd_state, which just looks fine.

I asked that in protected mode, how do we save the host state? It looks
to me that we only save it into EL2's private
kvm_host_data->host_ctxt.fp_regs which the host kernel isn't aware of.
How can host kernel restore the state for the current task later (e.g.,
for host userspace accesses)? What am I missing?

Thanks,
Zenghui
