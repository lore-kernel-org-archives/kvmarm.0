Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018386;
	b=2bdhl8Ke8OoG+a+SOsN0TAFoKc49vmqIExbeu0QVrNwk2GHqaNjUUOA84dwrwipou8sS
	 DGUF9J5EdPXQUvhodOCJ5tx8X/Y2moN0azq2tvnK3/CPZ8gJKyYqJx3l+97oQ4WK99rYA
	 dWU1w3q+vXjaOUAV+l36GlX5d0ZvDIGraWAUKce791PT7awFnYAYstKsHiXwDUNthrL+H
	 FR8l0qBfO5yMftVmHdLCYo1Mxwi9LdNpgNVBbrpvDjmBU6uplTFay1Yio+O5ENydlMp09
	 sdr67EkvDrd7fiFzAbfG3FF3haXdGaOpfr30veSpFx18T1JuBTQsj6wPaW9OvVqd1ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018386;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yYNwdmBSIDxtuxPrHW8cdhm8SfdRppfZaAmTog96H2A=;
	b=2VwmlbGVaeiWno73AzYiKcRYnYs7mqGPhxtIAtBFpypLWQyzy4U35YEDCtONHsHXqp99
	 flB4fVn3+hWkUTx11m79W61T0mxX9W1eZN1cipbvoSoqmuZDU4EEkboD1U+MJ2dZYmZIx
	 Bdh3gW3swLDnROdM9aUKD2K/bd/FRwJykrlhy521V1ozMp+E/8lUeyz9uVi3o8tCjxjlH
	 mhdK0apwV1MjwjK7XYMKyG3NQ50kQT9Kx4cKDJ7A6ihRWLCkP/ChXQm+WdG1T1FIbp5cn
	 xAHHZO1CCUp2N1j83DojjoiyvBEKhUYN7brDikJjZ/b33WR+3TBusJB4REF1AiPiY9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VfMYMAuM;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8162606A330;
	Wed, 18 Nov 2026 16:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8162606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VfMYMAuM
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FF44339;
	Wed, 18 Nov 2026 08:13:02 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E29C53F673;
	Wed, 18 Nov 2026 08:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795018385; bh=7HisUsPk+KXisBKOhhwZZBhSMTa8p36OAkhoTk09/p8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VfMYMAuMFySbcli51fpiRUiyHhsrWxVA0JvsMlnhNMKHwT3OC8N7svYDR6AXpwyRI
	 DQ3ucKevGEEZxmSMHnhWCReSwkfPCO0oRhqJaRKuPRh1v7zUXh0fBwqw4KIilbCFx/
	 PLAJ0VltMjZX2DM+j8kxWZtoujx0Rpj6phIcEFV0=
Message-ID: <a36b5c53-5148-4b08-b399-ae64b1ad8707@arm.com>
Date: Wed, 18 Nov 2026 16:12:57 +0000
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
Subject: Re: [PATCH v3 02/11] KVM: arm64: CCA: Introduce Realms
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-3-steven.price@arm.com>
 <CA+EHjTwfp8p7uwP2LXEqSmTwL6ZHuDCYbvMie_Wr_30xJwfO6A@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTwfp8p7uwP2LXEqSmTwL6ZHuDCYbvMie_Wr_30xJwfO6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/11/2026 14:07, Fuad Tabba wrote:
> On Mon, 16 Nov 2026 16:43:48 +0000, Steven Price <steven.price@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> [...]
>> @@ -1571,31 +1576,39 @@ struct kvm *kvm_arch_alloc_vm(void);
>>
>>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>
>> -#ifdef __KVM_NVHE_HYPERVISOR__
>> +#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>
>> -#define kvm_vm_is_protected(kvm)                        \
>> -        (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>> +#ifdef __KVM_NVHE_HYPERVISOR__
>>  /*
>>   * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
>>   * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
>> - * which is populated correctly and is gated on is_protected_kvm_enabled().
>> + * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
>> + * gated on is_protected_kvm_enabled().
>>   */
>> -#define vcpu_is_protected(vcpu)                                                \
>> +#define vcpu_is_protected(vcpu)                BUILD_BUG_ON(1)
>> +#else
>> +#define vcpu_is_protected(vcpu)                kvm_vm_is_protected((vcpu)->kvm)
>> +#endif
>> +
>> +#define kvm_vm_is_protected_pkvm(kvm)                                        \
>> +        (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>> +
>> +/*
>> + * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
>> + * make sure the vcpu->kvm is always valid VA in the context
>> + */
>> +#define vcpu_is_protected_pkvm(vcpu)                                        \
>>          ({                                                                \
>>                  struct kvm *__kvm = READ_ONCE((vcpu)->kvm);                \
>>                                                                          \
>> -                (__kvm && kvm_vm_is_protected(__kvm));                        \
>> +                (__kvm && kvm_vm_is_protected_pkvm(__kvm));                \
>>          })
>>
>> -#else
>> -
>> -#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>> -#define vcpu_is_protected(vcpu)                kvm_vm_is_protected((vcpu)->kvm)
> 
> This brings back the _pkvm variants that Marc asked to drop in the
> plumbing series [1]. In the nVHE hyp code, kvm_vm_is_protected() and
> vcpu_is_protected() already mean pKVM-protected, so I think the hyp
> side can stay as it is.
> 
> At EL1, the pKVM-only checks that a Realm vCPU also reaches are in
> kvm_arm_vcpu_power_off() and kvm_psci_vcpu_on(). Could they check
> vm_flavor == VM_PROTECTED_PKVM directly?

Ah, yes that should work better. Thanks for the suggestion.

>> +#define kvm_vm_is_realm(kvm)                ((kvm)->arch.vm_flavor == VM_REALM)
>> +#define vcpu_is_rec(vcpu)                kvm_vm_is_realm((vcpu)->kvm)
> 
> vcpu_is_rec() isn't used anywhere in this series. Could it be dropped?

Yep, I can move it after this series.

> [...]
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
>> @@ -906,7 +907,8 @@ static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
>>  /* Only the guest's CPU_ON may start a vCPU EL2 holds powered off. */
>>  bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu)
>>  {
>> -        return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
>> +        return vcpu_is_protected_pkvm(vcpu) &&
>> +                READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
> 
> Only a pVM's vCPU can be in KVM_MP_STATE_UNINITIALIZED, so is this needed?

I guess not. I'll drop this change.

Thanks,
Steve

> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/86pkxs2npx.wl-maz@kernel.org/

