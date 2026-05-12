Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AE33B9929
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778599997; cv=none; b=ofdT5sA+9pI2GhMSVI+Xi0rB/UhLz2qPc5Cx5mRQLpd0oK7ANN9hf1URgGvAz7DrHUPJXog2GiXm5vZHQxmc5Ug+C1HDjlu1ux6+/eUzKrFycpavMpjAQKPQZnN6XlXN2wbfBcIcxA+r5Ngp86GI26vBwujFRz9178/VL1J6p2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778599997; c=relaxed/simple;
	bh=3yWcHf8UykHBzHBdR7mSQMhi/cBR0qMqmOXh4rlQGx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfqcBGaVFKIt+/jiRBGgMhLow81kWNGi8NzEFBpijjYBT6OF8P7E393RVsgVzjNxBL11b7X9pwnyLE1jOCRMTpl4neCRXUzqiLh21I44imVJ+0VCLA6Kj/j/TONSEQwj1NaoEL5ZQGUCY6VntmYak+G9lvZ5c7KMncSEIL26PYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Asb4Ct7z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Asb4Ct7z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778599991;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5+xnXbVYTH65ka/uxiCb0qLOyxZQA+00M7WtNB18gU=;
	b=Asb4Ct7z1I6GzauLQjmJDD1GlDR8f3Ft1q8/u2OD1Lq55jP0uV7kp8/EIUAiqtRpksnoJr
	+VWBBaZE1qMM+VuJUyxSycZBKnzsSIfDcy+M/t+ujL7y7xcR6OfcwRdsWX9KaL/IhgAjOu
	/0WNDJwlIwJUq+DbsreQAjAwrQ981mc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-pL9OexUFPvq6ZUwP5G3VLA-1; Tue, 12 May 2026 11:33:09 -0400
X-MC-Unique: pL9OexUFPvq6ZUwP5G3VLA-1
X-Mimecast-MFC-AGG-ID: pL9OexUFPvq6ZUwP5G3VLA_1778599988
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so39653635e9.3
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 08:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778599988; x=1779204788;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5+xnXbVYTH65ka/uxiCb0qLOyxZQA+00M7WtNB18gU=;
        b=d10kzvIGCFNh8u1NP3ibP6ZwUai4oMRLj5HzxvRfHeh2mD6xPFKXa4CJiPoBwujyLF
         VsCJiZMrODz6NQTWeoROH8JjOP4P4HTNzXtKKQRdIHEA1X6uBqEe/grlMSP7Jbb4Nx7D
         jOdqUpHMuK6J4RKOVDTvkTd5O0wUlgmuJ2aRFRwp3JE4vKGgaIaREjn0MJaqK2X9vlfn
         Zrwo4nYgeWqg1JAqsOLZAcM1voUmzCylqVITWLtF97gLSIZ8k5gwM3ni5v1xT6R3MwUN
         sK8zgTTBJ/AhrEsPrvwojaV+fCqRjQHwQQ96wgVabUR3SB73d3BeUm1J7TuqCnG38e0G
         hN+w==
X-Forwarded-Encrypted: i=1; AFNElJ9ZLjDgWg1h55Q5nRGgxXXJqgB47QOEBvAPrt5/6YZFlxwMkv1HZWRj/yOooWzm2TGU63arBKI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ/cpI6HbpyCYxg2vo1i1TSES2EdKhFu4S3XY7D1+zOX750ThD
	bgR3hIuGowgNBQK/pT/OLEJ0jGAIfFQVeKC64Df0YNnhINyAjBXJ5ESSRu+p0PwMAlPt94tju5E
	vyBt8Z1pFS/x/+5whAjlLj6PJId0eGNLl1GiYvwrBZeE4qkr3zTFaUvyzAg==
X-Gm-Gg: Acq92OFwN4zw2CXB+FKTXBtwuLysFk+FCmuo1RAb74OcX3nw+dwsIwD3aHFFUs/jRGg
	or0LN+xUc/QXfOaf3hiv3WIWxAxSpnGJY9od020nu9G44HmMFFKun9FD6NG4cYCG8AijTZKrZZe
	uzbOBpq3C7qhwazTbilOjS/be7TAndmLM1mzN8kS0FwoG4LQK1hYXXQ4KaeU6Foqn+qJyypGVGa
	FrNzO9Twwr9tGkykQ1MsI1l3n2PCFRRBJ2OQOzJMdbwF+sxLtvpKq9VRjCkY/CcRjpHLrzA0JoW
	ey6q+/XoKvnxiXH00vA8RdOwEdIRDhGsg+JS+uMcQRwkeZkneS/1vg823KBeP3LQP3Bhf6M3g7l
	yetZN1ptdwFDwLqYrVnWD44IBHf/MILWjT03Dvi8mvuKyDXpdBY9fAukTGWpCUAwxELKyuA==
X-Received: by 2002:a05:600c:8115:b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-48e51e196f9mr472852305e9.8.1778599987833;
        Tue, 12 May 2026 08:33:07 -0700 (PDT)
X-Received: by 2002:a05:600c:8115:b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-48e51e196f9mr472851615e9.8.1778599987380;
        Tue, 12 May 2026 08:33:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f445f83sm18667735e9.29.2026.05.12.08.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 08:33:06 -0700 (PDT)
Message-ID: <ada244d4-0bfd-4bbd-b594-c3278a5570dc@redhat.com>
Date: Tue, 12 May 2026 17:33:03 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-10-eric.auger@redhat.com>
 <CH3PR12MB7548053696CA900F2A2349BDAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548053696CA900F2A2349BDAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pRo2ZVcvU9Y9yVfYKGoN1cN3qoULqfCFnP5xDzCUZYk_1778599988
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/26 12:32 PM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:33
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 09/17] arm/cpu: accessors for writable id registers
>>
>> External email: Use caution opening links or attachments
>>
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Introduce ARM_FEATURE_ID_RANGE_IDX macro that converts opcodes
>> into the index used to access the 3 * 8 * 8 feature id array.
>>
>> KVM_ARM_GET_REG_WRITABLE_MASKS populates writable masks with
>> that indexing.
>>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  target/arm/cpu.h | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index 2aa22360d2..0ac0fd13cf 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -886,6 +886,13 @@ typedef struct IdRegMap {
>>      uint64_t regs[NR_ID_REG_MASKS]; /* writable masks for registers */
>>  } IdRegMap;
>>
>> +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)               \
>> +        ({                                                              \
>> +                __u64 __op1 = (op1) & 3;                                \
>> +                __op1 -= (__op1 == 3);                                  \
>> +                (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
>> +        })
>> +
> It looks like this macro is not used anywhere and in next patch it
> uses KVM_ARM_FEATURE_ID_RANGE_IDX instead.

Thanks for pointing this out. Removed that patch

Eric
>
> Please check.
>
> Thanks,
> Shameer
>
>
>>  /* REG is ID_XXX */
>>  #define FIELD_DP64_IDREG(ISAR, REG, FIELD, VALUE)                       \
>>      ({                                                                  \
>> --
>> 2.53.0

