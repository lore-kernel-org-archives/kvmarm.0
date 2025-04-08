Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4919D882
	for <kvmarm@lists.linux.dev>; Tue,  8 Apr 2025 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744094357; cv=none; b=lHdFhTZc5cnkjsAsEr4njHiQlnHHJ3A6nP03Ueb64ala21EAuwVPDDJmxl5/kJr5xPWeaL5xUNJtHYXJqGokkhAFnkloH3slhD7IBZagfyRGdP/wtJY3zd80liOVDbElEmQHX7rLYn3E+BX141xHaBTw4RfNmq+QG0xpsbEz614=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744094357; c=relaxed/simple;
	bh=QImjOwZmHFIglPjEksFrg4C+14Ff/Y7CUPgguEl5tWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kt7fVNPdx0cT9O8yMQVrmupGLL1xa3UQOY0I3PqdN1HuwuU30L3lFGH9QUzh5oc//e3zcAoAueJssIHmm9QMV/uE7QuWym6EKx11HaDxM9FkKN12M+opgBtPDVIxcWq7uEtoWptOMqCd3z1Zj7wPMZNUkuEN29K5Fh0UZQzPygs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cAvhgW3N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cAvhgW3N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744094354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oo+vNBz6jEsiKjb63zXVQ6UhZa9LQg13RIyxKH2Wp2U=;
	b=cAvhgW3NPcK+I51CEnAIUQVzMhXbsaTT1HL5TIZHT3lFcHSdY1Vg5sdpfZ04/CgydnVZRL
	oMTY0dZAT8sJP5BmDhikpCzVlJ0qF2fk0ne3WfFjSQinyrnrYfwEcXwWCdls8wTk4YyQVs
	fye4YUetTUOOIm1ISkygo/MAOKFBL1c=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-v3dAVskPOgmarfMgKTb97w-1; Tue, 08 Apr 2025 02:39:13 -0400
X-MC-Unique: v3dAVskPOgmarfMgKTb97w-1
X-Mimecast-MFC-AGG-ID: v3dAVskPOgmarfMgKTb97w_1744094352
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7370e73f690so6274735b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Apr 2025 23:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744094352; x=1744699152;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oo+vNBz6jEsiKjb63zXVQ6UhZa9LQg13RIyxKH2Wp2U=;
        b=N8kPrpQPXtrJTdH33+mD9Ph81sPDtsNAg2R0FG1qPDRHc5z3WrfcZk6VLzQXqzxRon
         TxZN45riOE9t+0xajucbE4BiaKPrGB2FwBKf+HjaAgWpFlGjt7q9oyeB2rJL1v3OECSw
         3RzeqIrJzWOW7DeVILzxlxjyQPoQVLzle5pvcOpWZedURyrTCTQMdoSz2VzW2vFbvtSi
         mHRDAOYnSYBioGppbb61G88cJ1Z8olnr/KD4cyYh11/j0m3CmliJ/WItNR29DIQfpcY/
         Gorh6stnMfnAQTtE4xQqDkyBktv/0/5v6xsTNOH2BvTB+DrEt50S6A0KeRA+BrOGlpQi
         YRgQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+cAqg0NOECGKGQQ8QnKTN3EAKvwvTETfbENxizsUIqiZZJ5BbF4SILIUvw7pbtv0HW4q4yhw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn75kcWUrWkkXGr/7qnJKT1S850LSD+lcFeohQQ+M50AW0oT2Z
	wcBKGEWUuToNfhfQ6NiYZcOt1xSRr2vUQJjExi6ky0jnAoi+Z18p6Sb92j+0mQFgcvHXoSR7HSS
	r/f8E2SxWGTsTSEcbr5Kc6A+xuXlYSo2Ymlx5dqs5+UJUG33gkCt7wA==
X-Gm-Gg: ASbGnct5Uce7Jil70yf+01g1PXMNjxfy9P93nx9lIRE7YevryfPSKqjvPGWjkBEmOEP
	IHvEgaFx4hxGq6EtSsJmMzt01N1TkfISRZnRfya1XCHsStnVwgjHA+NIiSdVtGw7K7WF62k58jZ
	1dgjZ6iv5InMEXm1cMYtid2xg5PltB06q3oxT+AP5x34MEWafFjZ9arlr2y6rIONcLo7lhxcBIQ
	m7BEC5cFGVztJepRMn6O8+bGmCW12wFVg+JCQgm3UZ2Va8XwNrzIqxA4QirjDYq1MKgkN9kuAQA
	c5rAPKibAadXZCOU
X-Received: by 2002:a05:6a00:2393:b0:736:52d7:daca with SMTP id d2e1a72fcca58-73b6b8c3084mr14619978b3a.18.1744094352231;
        Mon, 07 Apr 2025 23:39:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCluDWzP6aX2PyZk9at9nI1CqMZ/cLW37DfwKCDqyszydjKUwNSMY0//3epUtYWIjDAxF0tw==
X-Received: by 2002:a05:6a00:2393:b0:736:52d7:daca with SMTP id d2e1a72fcca58-73b6b8c3084mr14619954b3a.18.1744094351805;
        Mon, 07 Apr 2025 23:39:11 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9ea15d6sm9712319b3a.89.2025.04.07.23.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 23:39:11 -0700 (PDT)
Message-ID: <cda1db80-4b4d-471f-87f0-d978278a4b6c@redhat.com>
Date: Tue, 8 Apr 2025 16:39:02 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 35/45] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250213161426.102987-36-steven.price@arm.com>
 <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
 <adbca476-7d0f-473d-a2a2-0a29a497dbca@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <adbca476-7d0f-473d-a2a2-0a29a497dbca@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EBXwX_g1PxnCmFvSbAgENz55ywXMpVdRKhzO39X7ciY_1744094352
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:35 AM, Steven Price wrote:
> On 04/03/2025 23:45, Gavin Shan wrote:
>> On 2/14/25 2:14 AM, Steven Price wrote:
>>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>
>>> The RMM describes the maximum number of BPs/WPs available to the guest
>>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>>> which is visible to userspace. A VMM needs this information in order to
>>> set up realm parameters.
>>>
>>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |  2 ++
>>>    arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>>>    arch/arm64/kvm/sys_regs.c        |  2 +-
>>>    3 files changed, 25 insertions(+), 1 deletion(-)
>>>
>>
>> With the following one nitpick addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>>> asm/kvm_rme.h
>>> index d684b30493f5..67ee38541a82 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>>>    u32 kvm_realm_ipa_limit(void);
>>>    u32 kvm_realm_vgic_nr_lr(void);
>>>    +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>>> u64 val);
>>> +
>>>    bool kvm_rme_supports_sve(void);
>>>      int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap
>>> *cap);
>>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>>> index f83f34358832..8c426f575728 100644
>>> --- a/arch/arm64/kvm/rme.c
>>> +++ b/arch/arm64/kvm/rme.c
>>> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>>>        return u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>>>    }
>>>    +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>>> u64 val)
>>> +{
>>> +    u32 bps = u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_NUM_BPS);
>>> +    u32 wps = u64_get_bits(rmm_feat_reg0,
>>> RMI_FEATURE_REGISTER_0_NUM_WPS);
>>> +    u32 ctx_cmps;
>>> +
>>> +    if (!kvm_is_realm(vcpu->kvm))
>>> +        return val;
>>> +
>>> +    /* Ensure CTX_CMPs is still valid */
>>> +    ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>>> +    ctx_cmps = min(bps, ctx_cmps);
>>> +
>>> +    val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>>> +         ID_AA64DFR0_EL1_CTX_CMPs);
>>> +    val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>>> +           FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>>> +           FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>>> +
>>> +    return val;
>>> +}
>>> +
>>
>> The chunk of code can be squeezed to
>> sys_reg.c::sanitise_id_aa64dfr0_el1() since
>> sys_reg.c has been plumbed for realm, no reason to keep a separate
>> helper in rme.c
>> because it's only called by sys_reg.c::sanitise_id_aa64dfr0_el1()
> 
> The issue here is the rmm_feat_reg0 variable - it's currently static in
> rme.c - so I can't just shift the code over. I could obviously provide
> helpers to get the necessary information but this seemed cleaner.
> 

Ack.

Thanks,
Gavin

> Thanks,
> Steve
> 
>>>    static int get_start_level(struct realm *realm)
>>>    {
>>>        return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index ed881725eb64..5618eff33155 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1820,7 +1820,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct
>>> kvm_vcpu *vcpu, u64 val)
>>>        /* Hide BRBE from guests */
>>>        val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>>>    -    return val;
>>> +    return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>>>    }
>>>      static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,


