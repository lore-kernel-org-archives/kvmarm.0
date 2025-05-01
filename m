Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346922FF22
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070819; cv=none; b=u73MUWbPTkjxSLTRK/JJs1tjMUiJw/VVF/KBQqOyJ9HRUxq1kEtQ1EosVb6LF9Vtjsl+gJ+p+FNkCKXn+2iLIVh20evXdV9kQ1Zu7HRwZ80BmfV8DC3DUwE+WRPqx1l4C4+ujkFUXJ/iNB7bkrH4tqQdt2WyPCckZU6ChW2l0jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070819; c=relaxed/simple;
	bh=w6pHwud+/EkotQy9ay5dJmhJJQShSvE59NMA8IETKwQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SbMB3y0y8/DkwdxNBYMfjrx81REAFLqdO2P8l4UKC892XPcGL+yrdP2Xb3FQWwXuiAe7IvR7SrzjB66lMh1UK502Zc5d7KKOaLv2LVRpajGlmSfH4r/HYjEHiJAApQv367CmmLZFINg0c9NzkZBixMZ8pxmJC1k9IHZy1Diw/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LI+Y2Rsh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LI+Y2Rsh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YzT7K8I220lkIra9KzhKbkEcpgT3/dCi3JXgDt4xJnU=;
	b=LI+Y2Rshyt4KWQqi4zMrRKxaL9BnhcT6QU2LRgyiU+a7fzcYzkmPXM+D1CmlvgsORokLs4
	SmrmJKeKqWogEJMfUjFFH+1GuOVDnMglf/1CO8KtgrRGNE0Hvx8nQpyfmKbEYT/kqEsufT
	p/bOWtX/Y4XPMoVpfYqfO/kaGazXj1k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-TF2HdAGaMQG4xJhXYMsnPw-1; Wed, 30 Apr 2025 23:40:12 -0400
X-MC-Unique: TF2HdAGaMQG4xJhXYMsnPw-1
X-Mimecast-MFC-AGG-ID: TF2HdAGaMQG4xJhXYMsnPw_1746070812
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22c31b55ac6so7434265ad.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070811; x=1746675611;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzT7K8I220lkIra9KzhKbkEcpgT3/dCi3JXgDt4xJnU=;
        b=s8G6knLnl+JxpA33Maq72Hl6Z4qFo3IUXC4GZ7oimKQ+1Uq/4aVnDOw8iYnyhOFgbA
         ujI8K+ZY4EznruMfQqVoZGLMWWXNkxImLPDJZftbQtT/zQeaYGtsXbURm0hu+WEkMx9R
         MMP5FXMEC9M41kSztsmhLIo6MLIXrREPTddAGkug5GocwjiNsscv6Dk/5h3dVY2QyrMW
         wcS3suR3n8mOHJ4zK4lrD/1lHqVte0wGE4tra3GRVUaslPzyEqgxKNOJJF75pIU6g43C
         TOhtfbjW9xpnME/UgT1nvXDsf9CUPlhGzoyYoP8SNocfcIi3m4AhGgxv2Ddf+bUtHing
         RSDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrqNLGBzaTPbAj1s24dq7n/QyXXEWapL9Gn7IVysOVozOvJFKP/6CzXpEAmTNerLQi+I9HGQI=@lists.linux.dev
X-Gm-Message-State: AOJu0YykRfM1gWyME+g9zOX5TFv1KnOyQv9nP+dULfD3CjeG+yBSLQlW
	0WEJnSUfuO5Ewu2VsYJJYJWivPUMnb/dMfEGBzL476Ql31aP1eZJhrADu+GdkcpKisfLyKmxKRh
	pve8FLJI1UoXP4t8s36aNbD74J80YfoM+LScKYlju23/p7wF1erToIQ==
X-Gm-Gg: ASbGncun+8yvgVaif8WI2s6faOX5WzZuTr+kUoakBgEzPdEyG8xEhU7VwZNMQBQOo8d
	x3SZveXeI6PIf9G10N4Bwc3zu0o8w6yFU69bq/E2nX8ldjFs5bv6yjS/1erEnc38qhr+CZhFEYx
	vK0CuMg25ZSrcCzty1V8QqjE3u2PbA5poajxfsynxUNROYEAAE7dVdIP9tLWyqIFXK609soQpeE
	P91YjSaO6LU01XmE6NouyRqiaZVKCfVGoifQoauMr8wiwZQ93lIrFPljpmuuLVNwVWv2+2cTOSG
	s/+Ja8XHcwEF
X-Received: by 2002:a17:903:18e:b0:224:10a2:cad5 with SMTP id d9443c01a7336-22e040a2e4fmr26932705ad.10.1746070811586;
        Wed, 30 Apr 2025 20:40:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHW6a/uU1DCKjMX5JLHAC9khf/wySTJvMqlUsZIdvGKjmMukBMZ9FoZF/x8NrqKxPW33mJK9A==
X-Received: by 2002:a17:903:18e:b0:224:10a2:cad5 with SMTP id d9443c01a7336-22e040a2e4fmr26932325ad.10.1746070811228;
        Wed, 30 Apr 2025 20:40:11 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db51051c6sm130511945ad.206.2025.04.30.20.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:40:10 -0700 (PDT)
Message-ID: <cfa0ba0f-86ad-4a72-be14-67b0639a7f59@redhat.com>
Date: Thu, 1 May 2025 13:40:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
From: Gavin Shan <gshan@redhat.com>
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-35-steven.price@arm.com>
 <19ec5533-ee10-4670-a9fd-da1345a6946a@redhat.com>
In-Reply-To: <19ec5533-ee10-4670-a9fd-da1345a6946a@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0O41L13l8XjxJUMVW_KVYaNPm8d1DWGAS67iYUQppig_1746070812
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 1:36 PM, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM describes the maximum number of BPs/WPs available to the guest
>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>> which is visible to userspace. A VMM needs this information in order to
>> set up realm parameters.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>>   arch/arm64/kvm/sys_regs.c        |  2 +-
>>   3 files changed, 25 insertions(+), 1 deletion(-)
>>
> 
> If I don't miss anything, it's not enough to apply the filter on reading and
> resetting path where sanitise_id_aa64dfr0_el1() is called. id_aa64dfr0_el1
> is writable and it's possible that QEMU modifies its value. Afterwards, the
> register is read from guest kernel, which will be trapped to host and the
> modified value is returned, without this filter applied. So I think the same
> filter need to be applied to the write path originated from QEMU.
> 

Please ignore this and it has been done in next patch :)

Thanks,
Gavin

>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index f786fd978cf6..09cbb61816f3 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -94,6 +94,8 @@ void kvm_init_rme(void);
>>   u32 kvm_realm_ipa_limit(void);
>>   u32 kvm_realm_vgic_nr_lr(void);
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>> +
>>   bool kvm_rme_supports_sve(void);
>>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 297b13ef1729..0c358ce0a7a1 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>>       return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>>   }
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +    u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
>> +    u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
>> +    u32 ctx_cmps;
>> +
>> +    if (!kvm_is_realm(vcpu->kvm))
>> +        return val;
>> +
>> +    /* Ensure CTX_CMPs is still valid */
>> +    ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>> +    ctx_cmps = min(bps, ctx_cmps);
>> +
>> +    val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>> +         ID_AA64DFR0_EL1_CTX_CMPs);
>> +    val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>> +
>> +    return val;
>> +}
>> +
>>   static int get_start_level(struct realm *realm)
>>   {
>>       return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index de7fe024dbff..36e22ed84e7e 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1844,7 +1844,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>>       /* Hide BRBE from guests */
>>       val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>> -    return val;
>> +    return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>>   }
>>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> 

