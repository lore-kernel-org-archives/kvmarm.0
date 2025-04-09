Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9B31C32
	for <kvmarm@lists.linux.dev>; Wed,  9 Apr 2025 00:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744157637; cv=none; b=VBQJmW/IiFoFIktF87zTko9xPa4sTdGMyQzLfe/LUOvS2BnSZ2DavAyWI5k2S6hKmWq0YmvQrY5nxmvhDFmfGELvXQvZ3UiIu1tsrGm7bH9OkGDugFV6vQ0mEKvEtWxeRd4iajplTM1eI25rOAAVssz7ca5GD22pp8PK6w1FjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744157637; c=relaxed/simple;
	bh=MWAbBoZecuM4T0ZFofmWRbQeSKpPlixs5mTxTTFnbdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2gUdR1M7ICGS4Q3Q33oCWf8QvY+m1K4XzKtiI/dZ5k0QXbRB1ov/xAdZ1F4vDbF6JfI8Cv+GsOk6nGsm2t1917ZXtxQ5nM37Ck6hyPsP+eqjhUJ652Pjo2icZc1Q0o6bF8hh8pIJaidN663MDJ5gn2LA6LbeN2RT8E8qIIWfLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBDj+HNU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBDj+HNU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744157634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bNddaKzNbdSe+8ksA8KcJkLM4w4kGgEVBgKegQ6RNTI=;
	b=WBDj+HNU/aVtofY9iWltAVLFQdbRSuu+Hlkc0l1/kYfuUWtfVb3RCe2TImSfhJaVMvCNjE
	101MtgOxIaXe2fVoXWc6BMEKKHLCbfthVtCimTWE9OhXruonO8NkIwDFNzLqZFACxxaDnZ
	H6JNWN0Uog2Rss3d9qQgxGp2oR0+NCw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-SHfns-VINKeo0T4Rgz9VaA-1; Tue, 08 Apr 2025 20:13:52 -0400
X-MC-Unique: SHfns-VINKeo0T4Rgz9VaA-1
X-Mimecast-MFC-AGG-ID: SHfns-VINKeo0T4Rgz9VaA_1744157632
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2242ade807fso97481055ad.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Apr 2025 17:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744157631; x=1744762431;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNddaKzNbdSe+8ksA8KcJkLM4w4kGgEVBgKegQ6RNTI=;
        b=Ovo2zu0eSILX1v/E7KVHar8vgMAEeNEvJkj+c+35SRCGnWcXLp1pfzs7BcnBKHDCFx
         aOIPe1XOuSp51CRMJDBaavO9oBBM+7/xIf4ULBwEt6H976WRsbQSjHWrvtP5R9w510EK
         wvnI2j4YhEklP2XsMjkgEGzqRFL+XAsbl3ESandv4JNL/x8kvozmvzDx8o8mKKusH+rM
         avI1TiAdsaQBNA1i7Z6rG24pGdvlm+dUnNRHH3oiTcHtxAhHXUl648j2ZtKo2n+wL2zq
         u5LV0LV2ncW+RJTRxn+I9eL8rI0OLN+tVRwrL/cFLDSd4I59NcQVm3KoSyE6wmvYP2ws
         XAdw==
X-Forwarded-Encrypted: i=1; AJvYcCUBlqZiOxEcl+9QakX6ri+8voG7MoU71fZdH17z15jBsTfAl3LcxfHq8xgpxikNM7UN3NYacec=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzI9Uq0WrDkhkg8NT84V3PwTuqmAN9BYKAt0S9+nWyipWA7wHK
	A8yBCDobpa/sMTe3ZwnqzuAQr+wt2+B/Oy6og40Cnnb/sDRwIwPgXvqGMmaqbKZLzkUF98YdX9t
	aGtP7kED4NK2AaZ06LM8jgOFmTdLxaPVp4tlkzoqFzTvDRLUmtRzjpw==
X-Gm-Gg: ASbGncubsIP3cfsRe9Pd+gM+/oBHQ4G0+ktbtBJFgM5mlXo5nLOkZ89cAhjU3JED3WX
	rmCEkVEoIyjDyFKrB5+EthYVc9rLxgEPog+Y2WAnp1+Vvv6VqazOUs8qVHjsg+iadmgZvXS5WQn
	Zd7hqxUcMR76azK4JKtaKIXatlCXr6zFHhQzu5v4xWcWFpf82T+ZvGHTwVcrsCjl2OjZ7Pp00iC
	i8+APYByTttkKCr087Rda2Ga+O6I4UeQ6T4irFXyD8eHn70WluJj5RXhQfEMVH3SSc30MywGaVH
	sqoVxajVs4UFNUAk
X-Received: by 2002:a17:902:f610:b0:21b:b3c9:38ff with SMTP id d9443c01a7336-22ac2a1a6abmr15802985ad.37.1744157631545;
        Tue, 08 Apr 2025 17:13:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq+iQbZRk3CBUAHj/H45YzBC+2eopn/nHrs+gAR5sUafqXx8zvscTJMIOvv07DM2mbfcEtQA==
X-Received: by 2002:a17:902:f610:b0:21b:b3c9:38ff with SMTP id d9443c01a7336-22ac2a1a6abmr15802675ad.37.1744157631156;
        Tue, 08 Apr 2025 17:13:51 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739da0dea8fsm11215481b3a.157.2025.04.08.17.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 17:13:50 -0700 (PDT)
Message-ID: <f87fa539-9abd-4a7e-8ce6-9515f26bed71@redhat.com>
Date: Wed, 9 Apr 2025 10:13:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/45] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-19-steven.price@arm.com>
 <b89caaaf-3d26-4ca4-b395-08bf3f90dd1f@redhat.com>
 <3b563b01-5090-4c9d-a47c-a0aaa13c474b@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <3b563b01-5090-4c9d-a47c-a0aaa13c474b@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _qi5u7Y_Mb3eArf4buRLd4VkPQrLAriVbk99Cp-vA2E_1744157632
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steve,

On 4/8/25 2:34 AM, Steven Price wrote:
> On 04/03/2025 04:35, Gavin Shan wrote:
>> On 2/14/25 2:13 AM, Steven Price wrote:
>>> The guest can request that a region of it's protected address space is
>>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>>> RSI_IPA_STATE_SET. This causes a guest exit with the
>>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>>> protected region to unprotected (or back), exiting to the VMM to make
>>> the necessary changes to the guest_memfd and memslot mappings. On the
>>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>>> calls.
>>>
>>> The VMM may wish to reject the RIPAS change requested by the guest. For
>>> now it can only do with by no longer scheduling the VCPU as we don't
>>> currently have a usecase for returning that rejection to the guest, but
>>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>>> open for adding a new ioctl in the future for this purpose.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> New patch for v7: The code was previously split awkwardly between two
>>> other patches.
>>> ---
>>>    arch/arm64/kvm/rme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 87 insertions(+)
>>>
>>
>> With the following comments addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>>> index 507eb4b71bb7..f965869e9ef7 100644
>>> --- a/arch/arm64/kvm/rme.c
>>> +++ b/arch/arm64/kvm/rme.c
>>> @@ -624,6 +624,64 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>> unsigned long start, u64 size,
>>>            realm_unmap_private_range(kvm, start, end);
>>>    }
>>>    +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>>> +                   unsigned long start,
>>> +                   unsigned long end,
>>> +                   unsigned long ripas,
>>> +                   unsigned long *top_ipa)
>>> +{
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>> +    phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>>> +    unsigned long ipa = start;
>>> +    int ret = 0;
>>> +
>>> +    while (ipa < end) {
>>> +        unsigned long next;
>>> +
>>> +        ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
>>> +
>>
>> This doesn't look correct to me. Looking at RMM::smc_rtt_set_ripas(),
>> it's possible
>> the SMC call is returned without updating 'next' to a valid address. In
>> this case,
>> the garbage content resident in 'next' can be used to updated to 'ipa'
>> in next
>> iternation. So we need to initialize it in advance, like below.
>>
>>      unsigned long ipa = start;
>>      unsigned long next = start;
>>
>>      while (ipa < end) {
>>          ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
> 
> I agree this might not be the clearest code, but 'next' should be set if
> the return state is RMI_SUCCESS, and we don't actually get to the "ipa =
> next" line unless that is the case. But I'll rejig things because it's
> not clear.
> 

Yes, 'next' is always updated when RMI_SUCCESS is returned. However, 'next'
won't be updated when RMI_ERROR_RTT is returned. I've overlooked the code,
when RMI_ERROR_RTT is returned for the first iteration, 'ipa' is kept as
intact and the 'ipa' is retried after stage2 page-table is populated. So
everything should be fine.

>>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>> +            int walk_level = RMI_RETURN_INDEX(ret);
>>> +            int level = find_map_level(realm, ipa, end);
>>> +
>>> +            /*
>>> +             * If the RMM walk ended early then more tables are
>>> +             * needed to reach the required depth to set the RIPAS.
>>> +             */
>>> +            if (walk_level < level) {
>>> +                ret = realm_create_rtt_levels(realm, ipa,
>>> +                                  walk_level,
>>> +                                  level,
>>> +                                  memcache);
>>> +                /* Retry with RTTs created */
>>> +                if (!ret)
>>> +                    continue;
>>> +            } else {
>>> +                ret = -EINVAL;
>>> +            }
>>> +
>>> +            break;
>>> +        } else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
>>> +            WARN(1, "Unexpected error in %s: %#x\n", __func__,
>>> +                 ret);
>>> +            ret = -EINVAL;
>>
>>              ret = -ENXIO;
> 
> Ack
> 
>>> +            break;
>>> +        }
>>> +        ipa = next;
>>> +    }
>>> +
>>> +    *top_ipa = ipa;
>>> +
>>> +    if (ripas == RMI_EMPTY && ipa != start)
>>> +        realm_unmap_private_range(kvm, start, ipa);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>>    static int realm_init_ipa_state(struct realm *realm,
>>>                    unsigned long ipa,
>>>                    unsigned long end)
>>> @@ -863,6 +921,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>>>        kvm_free_stage2_pgd(&kvm->arch.mmu);
>>>    }
>>>    +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +    unsigned long base = rec->run->exit.ripas_base;
>>> +    unsigned long top = rec->run->exit.ripas_top;
>>> +    unsigned long ripas = rec->run->exit.ripas_value;
>>> +    unsigned long top_ipa;
>>> +    int ret;
>>> +
>>
>> Some checks are needed here to ensure the addresses (@base and @top)
>> falls inside
>> the protected (private) space for two facts: (1) Those parameters
>> originates from
>> the guest, which can be misbehaving. (2) RMM::smc_rtt_set_ripas() isn't
>> limited to
>> the private space, meaning it also can change RIPAS for the ranges in
>> the shared
>> space.
> 
> I might be missing something, but AFAICT this is safe:
> 
>   1. The RMM doesn't permit RIPAS changes within the shared space:
>      RSI_IPA_STATE_SET has a precondition [rgn_bound]:
>      AddrRangeIsProtected(base, top, realm)
>      So a malicious guest shouldn't get passed the RMM.
> 
>   2. The RMM validates that the range passed here is (a subset of) the
>      one provided to the NS-world [base_bound / top_bound].
> 
> And even if somehow a malicious guest managed to bypass these checks I
> don't see how it would cause harm to the host operating on the wrong region.
> 
> I'm happy to be corrected though! What am I missing?
> 

No, you don't miss anything, I did. I missed that the requested address range
is ensured to be part of the private space by RMM::handle_rsi_ipa_state_set().
So everything should be fine.

void handle_rsi_ipa_state_set(struct rec *rec,
                               struct rmi_rec_exit *rec_exit,
                               struct rsi_result *res)
{
         :
         if ((ripas_val > RIPAS_RAM) ||
             !GRANULE_ALIGNED(base)  || !GRANULE_ALIGNED(top) ||
             (top <= base)           || /* Size is zero, or range overflows */
             !region_in_rec_par(rec, base, top)) {
                 res->action = UPDATE_REC_RETURN_TO_REALM;
                 res->smc_res.x[0] = RSI_ERROR_INPUT;
                 return;
         }
         :
}


> Thank,
> Steve
> 
>>> +    do {
>>> +        kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>>> +                       kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>>> +        write_lock(&kvm->mmu_lock);
>>> +        ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>>> +        write_unlock(&kvm->mmu_lock);
>>> +
>>> +        if (WARN_RATELIMIT(ret && ret != -ENOMEM,
>>> +                   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx,
>>> ripas: %#lx\n",
>>> +                   base, top, ripas))
>>> +            break;
>>> +
>>> +        base = top_ipa;
>>> +    } while (top_ipa < top);
>>> +}
>>> +
>>>    int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>>    {
>>>        struct realm_rec *rec = &vcpu->arch.rec;
>>> @@ -873,6 +957,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>>            for (int i = 0; i < REC_RUN_GPRS; i++)
>>>                rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>>>            break;
>>> +    case RMI_EXIT_RIPAS_CHANGE:
>>> +        kvm_complete_ripas_change(vcpu);
>>> +        break;
>>>        }
>>>          if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
>>

Thanks,
Gavin

