Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2703FFFA8;
	Fri,  5 Jun 2026 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780671751; cv=none; b=rRMkX8U0bC0N2jtdtHTfZ+8WOhtmBVoR5tBa4DIa1eoMATMaxqaxoBEWQH0sL2yMNuq8njGK1YgHmv5Y9qfpo/NJB3r4KAEXDiDC88MnBThmbroWMZd3Zphhg74gTOVtdYIwSka8begwJS5DgifyqQXL+OwXljR1xAnrvvUfXqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780671751; c=relaxed/simple;
	bh=7tt4d8MaJgpOSLKymncdsizpcHBAdx7d144Wan8ieGE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cpLezBEmDAFuA2F6E8hHCvsXFxN4bVbdks6SAh2y08EUJWa5expwr3AjNwpOtptpae5Oi5Tzf0sICehYX3huuqlnvIYUAQS6nkTEEetdaKHrKfKRshG0h2DNwpAj2D7L4NoaP47JhSt1eR+8Nf9EWolCwur0HRYHMyZAZj1AcJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G6NmiYoY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G6NmiYoY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18F6B2E9D;
	Fri,  5 Jun 2026 08:02:25 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 797C43F7D8;
	Fri,  5 Jun 2026 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780671749; bh=7tt4d8MaJgpOSLKymncdsizpcHBAdx7d144Wan8ieGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G6NmiYoYNX8kpQgsWGEAAEKqMnc2Q3GqMf446Ca73c0kIwcSLs6I/ps9ycxqLp4VB
	 bhT7XUxfOJufCkHkLzDHMMS0OLzCkcrsTPDrhEMhUH8N3PrZ9tiOVEWSaeS2AG0rbH
	 AXF0TKQuPtK5APza+Ph3AGCg2Dbn90hOUmY6cMfE=
Message-ID: <d9d57c7d-45c7-4747-b7ce-ec3bab537136@arm.com>
Date: Fri, 5 Jun 2026 16:02:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 20/44] arm64: RMI: Support for the VGIC in realms
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-21-steven.price@arm.com>
 <5ea74b6a-a51a-415e-b53f-5ece9829dee8@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <5ea74b6a-a51a-415e-b53f-5ece9829dee8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 28/05/2026 05:07, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
>> the registers are passed in the system registers so this works similar
>> to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
>> and realm guests don't support GICv2 even if the host does.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v12:
>>   * GIC registers are now passed in the system registers rather than via
>>     rec_entry/rec_exit which removes most of the changes.
>> Changes from v11:
>>   * Minor changes to align with the previous patches. Note that the VGIC
>>     handling will change with RMM v2.0.
>> Changes from v10:
>>   * Make sure we sync the VGIC v4 state, and only populate valid lrs from
>>     the list.
>> Changes from v9:
>>   * Copy gicv3_vmcr from the RMM at the same time as gicv3_hcr rather
>>     than having to handle that as a special case.
>> Changes from v8:
>>   * Propagate gicv3_hcr to from the RMM.
>> Changes from v5:
>>   * Handle RMM providing fewer GIC LRs than the hardware supports.
>> ---
>>   arch/arm64/kvm/arm.c            | 11 ++++++++---
>>   arch/arm64/kvm/vgic/vgic-init.c |  2 +-
>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 93d34762db91..21d9dfdb1ea0 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -786,19 +786,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>           kvm_call_hyp_nvhe(__pkvm_vcpu_put);
>>       }
>>   +    kvm_timer_vcpu_put(vcpu);
>> +    kvm_vgic_put(vcpu);
>> +
>> +    vcpu->cpu = -1;
>> +
>> +    if (vcpu_is_rec(vcpu))
>> +        return;
>> +
> 
> For a REC, kvm_vcpu_{load, put}_debug() becomes unbalanced in
> kvm_arch_vcpu_{load, put}().
> kvm_vcpu_load_debug() is called in kvm_arch_vcpu_load(), but
> kvm_vcpu_put_debug() won't
> be called in kvm_arch_vcpu_put() after this whole series is applied.

Good catch. Yes that's not quite right.

Thanks,
Steve

>>       kvm_vcpu_put_debug(vcpu);
>>       kvm_arch_vcpu_put_fp(vcpu);
>>       if (has_vhe())
>>           kvm_vcpu_put_vhe(vcpu);
>> -    kvm_timer_vcpu_put(vcpu);
>> -    kvm_vgic_put(vcpu);
>>       kvm_vcpu_pmu_restore_host(vcpu);
>>       if (vcpu_has_nv(vcpu))
>>           kvm_vcpu_put_hw_mmu(vcpu);
>>       kvm_arm_vmid_clear_active();
>>         vcpu_clear_on_unsupported_cpu(vcpu);
>> -    vcpu->cpu = -1;
>>   }
>>     static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/
>> vgic-init.c
>> index 933983bb2005..a9db963dfd23 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -81,7 +81,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>>        * the proper checks already.
>>        */
>>       if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
>> -        !kvm_vgic_global_state.can_emulate_gicv2)
>> +        (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
>>           return -ENODEV;
>>         /*
> 
> Thanks,
> Gavin
> 

