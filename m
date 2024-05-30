Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960324596F
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717089662; cv=none; b=ff9pmRaHV89I6xYfH3f/d6yLRIK1Oy69UovoGmJPQsj6/AtBtm6f2OiSvZAT55vqK7vTt07R4Vp/2APeUXfSpLISSfndp3Wg1phxsab/7vEK7adZCypiU6OUV5zAm/2UOE+AMzKvE4gheQ/RTOB2lFF4KGp+xGdHjl1TSKG/Fo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717089662; c=relaxed/simple;
	bh=Ab40fFziNTCR3bIRbRFkfjAS+VLoC1PKr4P45quh/K4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnlvYTT/w+7V+fi6DBJNU2Pasuhc9gJi48YQ2Yksl2rdyZz/y9lR7lCEodo5kyeIz27tnslu0EjoZqzSnfVUDcLrhdWLhS/twL8E/7lOrqG6C31CKKnMeh0464o+DbMWC0oaWTHo0xa9xYTbmKO55D0F4/qMi9NF7H6Cr9V4xcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4On2IBu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4On2IBu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717089659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5KuYwrlXvy2N8LV4iq+ZSNoKmsKOKbU0DyIuxTd5sy0=;
	b=e4On2IBudx8E3wWTxlRW9iE6t6N5dM+LQZh9teBX4aFNwo73whPYWsEyFbcl9DY+HaYLI7
	Xv4AReLnc+M/tFxtUh2bPB01c4kuurcRi4z2J9zVp5zVJhtXk8IfGxsQrCXBawi6bxyQrx
	znY1yTcRldKq6X3pKtth5LJ2sgN5epU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-2lnwGTolMg-SFA1NpTLEwg-1; Thu, 30 May 2024 13:20:58 -0400
X-MC-Unique: 2lnwGTolMg-SFA1NpTLEwg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-358f9dffbedso628368f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 10:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717089656; x=1717694456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5KuYwrlXvy2N8LV4iq+ZSNoKmsKOKbU0DyIuxTd5sy0=;
        b=rIX42zVKFEUV4QSMzq5U+1Am3cJQv2oLJ6VDNVkzyG3MxUfwgYwrg4gG2DvmS1HHee
         ol+PPKNKMHdUwxFSGsFup2a1pwlj1jYk/eyowjDpgAuMCYAwAhKFMY+9KSjP1SCDt3M3
         emReFhTI9H94g7jZEYH9sOqbNmjQes4vWQr+rn1Hu/JYhQcyFoTrawDYX8UhFnhBbl7K
         7VCX2KtBP4XTPn6Y5h60wKpGDFJaoniv44SeFnpKNX739qOrNuFuvnjzfcxF7K/vcjU3
         rb02QhNY2zGMxBD8HLzTocevlX01e3+UEVgYsylWOMeLkAeQ7Ign9PjJyLdVsdRGOwvG
         DihA==
X-Forwarded-Encrypted: i=1; AJvYcCVItsYeF3MZHpJPEkS8fXtf93hwruhHeIm3BU0WIO98bCCa4NF/a+Nfmyr/GxDSMO7rGMbgVIqp7TcXQQwLvMqbT2N0PVp8
X-Gm-Message-State: AOJu0Yxd7gbqS4wPmDXj0cOu24ctTWPyJnDpJ3cToH6nG7FYNWDC071Y
	D2yGi3CCUqtjzJSrisVopw2M2kQOQdm+PPC8rGU5pEbj2WwYzTTYXvR2CI8MB/e4dAoJdyIITwY
	TuCHuwr6OpHfZkIJatK4lLMMNX/e4L65Fg+yB0FT9Hoj7P+23tRoQ7A4f6JSIhg==
X-Received: by 2002:adf:ef50:0:b0:354:f44d:a020 with SMTP id ffacd0b85a97d-35dc00bf084mr2986434f8f.48.1717089655808;
        Thu, 30 May 2024 10:20:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBHht46/0aHH98H3F2Btkvz/+IBrdTIlSs6v8sQAHIKqk2hS+lTqMGvUepjWfHpzCCT8C1Fg==
X-Received: by 2002:adf:ef50:0:b0:354:f44d:a020 with SMTP id ffacd0b85a97d-35dc00bf084mr2986414f8f.48.1717089655287;
        Thu, 30 May 2024 10:20:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04d94e6sm17916f8f.51.2024.05.30.10.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 10:20:54 -0700 (PDT)
Message-ID: <b8ecf0c6-b936-4c33-9bd5-1a0c4660ddce@redhat.com>
Date: Thu, 30 May 2024 19:20:52 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] KVM: arm64: add emulation for CTR_EL0 register
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-4-sebott@redhat.com>
 <312fd3cf-2eb9-4a38-8c50-e3b7639c3cbc@redhat.com>
 <c62a1fd5-54e6-4727-d457-1b2d19b0af35@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <c62a1fd5-54e6-4727-d457-1b2d19b0af35@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/30/24 14:56, Sebastian Ott wrote:
> Hej Eric,
> 
> On Wed, 29 May 2024, Eric Auger wrote:
>> On 5/14/24 09:22, Sebastian Ott wrote:
>>> +static int validate_clidr_el1(u64 clidr_el1, u64 ctr_el0)
>>> +{
>>> +    u64 idc = !CLIDR_LOC(clidr_el1) ||
>>> +          (!CLIDR_LOUIS(clidr_el1) && !CLIDR_LOUU(clidr_el1));
>> This actually computes:
>> CLIDR_EL1.LoC == 0b000 or (CLIDR_EL1.LoUIS == 0b000 &&
>> CLIDR_EL1.LoUU == 0b000)
>>
>> refering to ARM ARM
>> Terminology for Clean, Invalidate, and Clean and Invalidate instructions
>>
>> 1) If the LoC field value is 0x0, this means that no levels of cache
>> need to cleaned or invalidated
>> when cleaning or invalidating to the Point of Coherency.
>>
>> 2) If the LoUU field value is 0x0, this means that no levels of data
>> cache need to be cleaned or
>> invalidated when cleaning or invalidating to the Point of Unification.
>>
>> 3) If the LoUIS field value is 0x0, this means that no levels of data or
>> unified cache need to
>> cleaned or invalidated when cleaning or invalidating to the Point of
>> Unification for the Inner Shareable shareability domain.
>>
>> so to me if above computation is true this means who have no level of
>> cache to take care of, so although CTR_EL0.IDC = 0 would normally mean
>> you must "Data cache clean to the Point of Unification" that is not
>> needed in that case.
>>
>> But the spec does not really state that IDC=0 and
>> no_level_of_cache_to_clean_inv are incompatible as far as I see
> 
> This is just existing code moved to a helper..
agreed this comment/question is not related to your patch

> 
>>> +    if ((clidr_el1 & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) &&
>>> idc))> +        return -EINVAL;
>>
>> Isn't (clidr_el1 & CLIDR_EL1_RES0) already checked by
>>
>>        { SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
>>          .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
>>
> 
> Nope, that would only be the case when arm64_check_features()
> is used (by having set_id_reg() for the .set_user callback).
OK
> 
>>> +static int validate_cache_top(struct kvm_vcpu *vcpu, u64 ctr_el0)
>> s/top/topology?
> 
> Hm, that name is already quiet long.
yes but top does not mean much
> 
>>> +{
>>> +    const struct sys_reg_desc *clidr_el1;
>>> +    unsigned int i;
>>> +    int ret;
>>> +
>>> +    clidr_el1 = get_sys_reg_desc(SYS_CLIDR_EL1);
>>> +    if (!clidr_el1)
>>> +        return -ENOENT;
>>> +
>>> +    ret = validate_clidr_el1(__vcpu_sys_reg(vcpu, clidr_el1->reg),
>>> ctr_el0);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    if (!vcpu->arch.ccsidr)
>>> +        return 0;
>>> +
>> worth to add a comment about what this does as this is not
>> straighforward ;-)
> 
> Hm, "check for validity of the cache topology" - that's kinda the
> functions name, so no added value. "Make sure the cache line size
> per level obeys the minimum cache line setting" - would this help?
> Can't think of smth else right now, sry. Suggestions?
yes the latter is fine to me
> 
>>> +    for (i = 0; i < CSSELR_MAX; i++) {
>>> +        if ((FIELD_GET(CCSIDR_EL1_LineSize, get_ccsidr(vcpu, i)) + 4)
>> maybe use a local variable such as log2_cache_bytes
>>> +            < __get_min_cache_line_size(ctr_el0, i & CSSELR_EL1_InD))
>> I don't get i & CSSELR_EL1_InD, please can you explain?
> 
> It flags the cache at this level as a data or instruction cache (see also
> get_ccsidr()).
OK I understand the principle now. thank you
> 
>>> +static int set_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc
>>> *rd,
>>> +           u64 val)
>>> +{
>> don't you need to take the config_lock earlier as in set_id_reg()? isn't
>> it racy versus has_ran_once?
> 
> I was about to write that this is not the case since that's an rcu
> accessed pointer not guarded by the config lock but I confused this
> with the vcpu_has_run_once() .... again :-(
> 
> I'm not a 100% sure we really need that but I'll just move the lock up -
> it definitely doesn't hurt.
yup

Eric
> 
>>> +    u64 ctr = vcpu->kvm->arch.ctr_el0;
>>> +    u64 writable_mask = rd->val;
>>> +    int ret;
>>> +
>>> +    if (val == ctr)
>>> +        return 0;
>>> +
>>> +    if (kvm_vm_has_ran_once(vcpu->kvm))> +        return -EBUSY;> +
>>> +    if ((ctr & ~writable_mask) != (val & ~writable_mask))
>>> +        return -EINVAL;
>>> +
>>> +    if (((ctr & CTR_EL0_DIC_MASK) < (val & CTR_EL0_DIC_MASK)) ||
>>> +        ((ctr & CTR_EL0_IDC_MASK) < (val & CTR_EL0_IDC_MASK)) ||
>>> +        ((ctr & CTR_EL0_DminLine_MASK) < (val &
>>> CTR_EL0_DminLine_MASK)) ||
>>> +        ((ctr & CTR_EL0_IminLine_MASK) < (val &
>>> CTR_EL0_IminLine_MASK))) {
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    mutex_lock(&vcpu->kvm->arch.config_lock);
>>> +    ret = validate_cache_top(vcpu, val);
>>> +    if (ret) {
>>> +        mutex_unlock(&vcpu->kvm->arch.config_lock);
>>> +        return ret;
>> nit use a goto out
> 
> Thanks,
> Sebastian
> 

