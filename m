Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932093DD525
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 09:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033236; cv=none; b=DF+3puyDZeZ5QaL7+k8GQHqMcToxVl45culeDzkrejG5BZIsMN7len38kHjbvqTTYZh1bnGEMaYaq7lG3PygBzyZqs66roTotoIqD+SdPUXIMlk7Fz2BhJODEltwf6eA6sntD/0LT98ymi/atyIGiUGs8JYiLc8z4Vw+HKoGi90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033236; c=relaxed/simple;
	bh=2U05edltdc65w78+ZV5IWr4TVwXUEOtUfX+tKTehz0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbAMl9LxANm18IqqknhYwQSTOKGqx9fUpGDz4fzH0dl4NOr8+TQlApQMype2ttCVDwkKa1YcPftGyQfDHBj8KD3IqkTQValh+kL+PWCFfgJS+ma8dCSih9Cx+10nUEbD0jjof4tagP6Wzj1C93Igl9PA60RBwg/RGP4FSqwLKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkJI1XlJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkJI1XlJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789033231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/H7/x7jrZUwe3gjvxEalG5iN9U5i6+Y9YANROw43qY=;
	b=XkJI1XlJR5W+JivpoVkve6DQ82ASVsiKLZQE7Qi3zmTQdjeishUgUqTJ9ngyIQpGjhh2hc
	phSG3daWMlLzD7p8dzvYLeXyA6/RJXKUJezU426WUcDmMNOCsaQEKDtNtu9GTkH0tIz32o
	ZluHluG+qUSfgkzCYP5DhWDuCNeNRlo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-vKzYr8DzNTmRpiV_ugy8WA-1; Thu, 10 Sep 2026 05:40:29 -0400
X-MC-Unique: vKzYr8DzNTmRpiV_ugy8WA-1
X-Mimecast-MFC-AGG-ID: vKzYr8DzNTmRpiV_ugy8WA_1789033228
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4afc810bfso789811a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 02:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789033228; x=1789638028;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J/H7/x7jrZUwe3gjvxEalG5iN9U5i6+Y9YANROw43qY=;
        b=cHEYQCD2Ds5wc3H/kqWySmAz+0zTfvMWkhZ4XcJ5IipipKPtTJue8IlA+Pt4S32cxw
         abAxVC8EGJBeX37l+dP41/JxssMV1f/Fr9HH6VOJN12B0gkbHF40YspOaPhgpL1tQAS9
         AjcHOMjxL7D3kJdBt57yNuQwBEv5VIaUmtBGj7mZfTiYzzK0IaAcAkahG+WPK6gHhwAp
         HJxAt7H8F8YOprzVCX7mNT8v0x+eajaks8Iz4TKWxqcMlkDRJidZWg3mGSRtWPLQVe9t
         la6PZnjzK+TlBKpKeLa22RfjAYBlq4ZTg4EwOxOVg1t6BlXcJCcZxrULIGRJ+MdJbwea
         NNsg==
X-Forwarded-Encrypted: i=1; AKwUvBwZHO6MTqOiDr4IO1OS+SWirXTC/7EzK4pSB08qqs3I+CmcqwlX8sp3wCk/4wVswPwakvBAM44=@lists.linux.dev
X-Gm-Message-State: AFuF++nB2KVHhaVTO3bpqqr+s1SQOQrCWDLSBfFT9IOTmcLxOcVpqMJ9
	6fCqd8ZMVjVOrsz2Pbkq6JoiBe0flOmo/+9MJ4UEDiX4OMxlNTF2+7hcol4VovXXNDEVgz4SOCt
	RFI8YAGJ0BT99Gh7h66tn6me+/ZFkNoxlECBIxHZcdchfrF1L2Q6WrwjKBA==
X-Gm-Gg: AYBFou3NUj0TN0uT8HmyYBXu3Qj/qIx2f42GvwU3lYo+AEzQ4SvTPgjl9nXSJ+jEj84
	9Kvjkx5ExdMoyg+fG+YJZ8dvUCxkxh+49VQx4tyKWJ8rmShrSAzDKMC+DHH6uUbMDO2GsApr4HG
	KAoZKH0VcPREir0BemTMasHfp43StBg79Gmj+c76P+/zd4+cLy4qTvG3rYMdhIWGVHM8Wq6kVCE
	XDwFgeE6wLBJ6fnLuS606eeTuHfqa3BbV8r2Ar6M/1RkaWoPadBZLAAMxRnLcfg2OopVcQcaK7l
	p6tT7ECcR+jdf2uv3cxenXu48yw8d2Mg8+IyVenh63kyL3gbQg9cBTRuYHEQ1QdkXt0mdgbFdQY
	/xHIvPA0ryYCtCs1g/4fs3eXE/At8M5gFQbvF9aEnEQ==
X-Received: by 2002:a17:90b:4490:b0:398:baa7:4c2f with SMTP id 98e67ed59e1d1-39d77a08755mr3066641a91.5.1789033228082;
        Thu, 10 Sep 2026 02:40:28 -0700 (PDT)
X-Received: by 2002:a17:90b:4490:b0:398:baa7:4c2f with SMTP id 98e67ed59e1d1-39d77a08755mr3066617a91.5.1789033227578;
        Thu, 10 Sep 2026 02:40:27 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d80f0068esm3343502a91.10.2026.09.10.02.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 02:40:26 -0700 (PDT)
Message-ID: <472daa5d-19e5-41f1-9650-44e0245bc1f0@redhat.com>
Date: Thu, 10 Sep 2026 19:40:13 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 06/20] KVM: arm64: CCA: Add a new mode for supporting
 Realm guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-7-suzuki.poulose@arm.com>
 <e66698e1-e582-4ff8-9881-4ddda5bc1d94@redhat.com>
 <40d3312a-c695-44ed-857a-fc6bf293f3e6@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <40d3312a-c695-44ed-857a-fc6bf293f3e6@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yhoS0piKesh0K967lTM7_7sAj965WneXIn1a-zEuQWU_1789033228
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/10/26 6:43 PM, Suzuki K Poulose wrote:
> On 10/09/2026 06:53, Gavin Shan wrote:
>> Hi Suzuki,
>>
>> On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
>>> Add an explicit mode to support Arm CCA guests.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>>   Documentation/admin-guide/kernel-parameters.txt | 3 +++
>>>   arch/arm64/include/asm/kvm_host.h               | 1 +
>>>   arch/arm64/kvm/arm.c                            | 5 +++++
>>>   3 files changed, 9 insertions(+)
>>>
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/ Documentation/admin-guide/kernel-parameters.txt
>>> index 68647ff4bdd24..1afe3df3b923e 100644
>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>> @@ -3256,6 +3256,9 @@ Kernel parameters
>>>               nested: VHE-based mode with support for nested
>>>                   virtualization. Requires at least ARMv8.4
>>>                   hardware (with FEAT_NV2).
>>> +            rmm: Support for running confidential guests in Realm
>>> +                 world using RMM, as defined by Arm Confidential
>>> +                 Compute Architecture (CCA)
>>>
>>
>> I'm not sure, but 'realm' would be more appropriate name. rmm (Real Management Monitor) is
>> the term limited to the firmware to me. Besides, we have been using 'realm' broadly in this
>> series like kvm_vm_is_realm(), kvm_realm_state() and so on.
> 
> May be. But we use the "mode" of the hypervisor in question here, mostly. e.g., nvhe, vhe, protected etc. So, I went with RMM (in favor
> of CCA). Does that make sense ? Also, we rely on firmware/arm_rmm for
> the support. So, it kind of make sense to keep it "rmm" ?
> 

Ok, lets keep 'rmm' unless somebody else has better suggestion.

> Cheers
> Suzuki
> 

Thanks,
Gavin

