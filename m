Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A613BC39
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 05:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721712949; cv=none; b=LRLG9MU/RQc9s6hOZuaIQEPKkJXIVvZBwD56cz8L7VWljcOkIAPjVY6YTA176HH4si0x1y3yfOb+SdrzGXdXS5RwPYszRXoyRTg8JuMkWjDSkcwOFvTo/2ZRI6WIg3PHYsQJm5qL5Z6VSB8TfXMuiy6oHje/yWkUSntD+0qV4Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721712949; c=relaxed/simple;
	bh=VtdTtInp8xltP7woCl3ZLIkQdg2goHxfX1mvCYp/CEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mofK9Wo1THRlVhZe2L32lCo3W1n1mWxVYa5/Eol1y5QMDvix2b9XgpOGN/0fq3rKw/cKq0Yryj2mkpE7Tsa1i5mFW7jLWBL3uo3DXNUj1aC5AGRPrGhUWdLJNvB4HFZHNtcQCsu/fioyX45ST5ygW1vuKP+ic6zC+lcunO4FXME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcRbySwS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcRbySwS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721712947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aW1THt75DeB8IkjnkNQ5OOu8ISWACnD4UYq7Ars9y+U=;
	b=RcRbySwSlozET+EXv+piXKcb12kDS6f6ED/2Fr0tPy4FzxVo0Ze1KldNT42VaGoW1YaZZI
	MY1m1Cws7y2I4vO5b21gRp91vNJ2tmaCYgejtswVsQ8UuIw9xtjrcNd4+LWwhUsJMQ7jhq
	H0vT50uq8gNtgnsHK4a/6L8z6CqHh5Q=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-6Qtm8-ATPpi37ff1m-9TLg-1; Tue, 23 Jul 2024 01:35:43 -0400
X-MC-Unique: 6Qtm8-ATPpi37ff1m-9TLg-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-78fad6425c1so393037a12.2
        for <kvmarm@lists.linux.dev>; Mon, 22 Jul 2024 22:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721712942; x=1722317742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aW1THt75DeB8IkjnkNQ5OOu8ISWACnD4UYq7Ars9y+U=;
        b=Y+TupD+7j0di2ofVbaW3RiOgg2EmyKrqraJT4ruATQKbNFV0N+eUXpCAWRgGkmRtAW
         onfGbAlD917vRpOWTmHCx1Peo8bnWNjdb9wGhao/fYMxlWRUE3TWrOuT0NKOFKtG9MJP
         x2goHhe8YoPSON9ffKq88wkWxnzICrHaYo+uRPKpYi5rmu3VFk9FBOXqXZBOHSziQ7UC
         1v3FWM4tIh54HLgjPjJRWeLgJ3yyp/PmC+Uq1NgTEYKqnP9yMGUQ8RinmflL0xxFGVwk
         oBzGLaW80Xi727oHC+Lm4ZF6SMgVXZy8keGIIuNdkrH6L9ajNZBbS2+QC/7u6jdUk5A/
         VPrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwuB7xZVcfIKwJjQWiyNIq1H9CSmxyjvizL1cAe/w/k/CBzgZnN305x+PURI878q+tVPLpSqxhupWowSyANhvz8Bf6EnSq
X-Gm-Message-State: AOJu0YwU0w2YZ6ud2NGE9He+vt1z+Mp5CvFkt3OgPi48wt55PnW/eYEj
	3I3AcwD4F2cQGRtYdigapW4aqgNdKCVbDcW5Tbl9tgWzakUvs+mqJ+vPjDZYAxNNKE74qIXkYPk
	w+mXPPbArMdXJUMw4Uje+PmAIC8d7VHBlEKZ0peyfYV9h65F+eNeofQ==
X-Received: by 2002:a05:6a20:841c:b0:1c2:9cbf:cc3e with SMTP id adf61e73a8af0-1c4285dfbb7mr8095012637.45.1721712942170;
        Mon, 22 Jul 2024 22:35:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUfgk+Po+fWXzUtaVQDwmY3IatFJXFV7UxMV0i7PuLgsZH5vwiyfgOw2C73FeYVdG6yKkjMw==
X-Received: by 2002:a05:6a20:841c:b0:1c2:9cbf:cc3e with SMTP id adf61e73a8af0-1c4285dfbb7mr8094992637.45.1721712941776;
        Mon, 22 Jul 2024 22:35:41 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.134])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-79f0ba12970sm4760247a12.50.2024.07.22.22.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 22:35:40 -0700 (PDT)
Message-ID: <682d62b8-6cca-4782-b4e4-ffd2a706fadf@redhat.com>
Date: Tue, 23 Jul 2024 15:35:33 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] arm64: rsi: Add RSI definitions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-2-steven.price@arm.com>
 <3b1c8387-f40f-4841-b2b3-9e4dc1e35efc@redhat.com>
 <3b2ddd79-c7f0-4d41-8795-13d1305e3d08@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <3b2ddd79-c7f0-4d41-8795-13d1305e3d08@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/11/24 1:34 AM, Steven Price wrote:
> On 09/07/2024 06:19, Gavin Shan wrote:
>> On 7/1/24 7:54 PM, Steven Price wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> The RMM (Realm Management Monitor) provides functionality that can be
>>> accessed by a realm guest through SMC (Realm Services Interface) calls.
>>>
>>> The SMC definitions are based on DEN0137[1] version A-eac5.
>>>
>>> [1] https://developer.arm.com/documentation/den0137/latest
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v3:
>>>    * Drop invoke_rsi_fn_smc_with_res() function and call arm_smccc_smc()
>>>      directly instead.
>>>    * Rename header guard in rsi_smc.h to be consistent.
>>> Changes since v2:
>>>    * Rename rsi_get_version() to rsi_request_version()
>>>    * Fix size/alignment of struct realm_config
>>> ---
>>>    arch/arm64/include/asm/rsi_cmds.h |  38 ++++++++
>>>    arch/arm64/include/asm/rsi_smc.h  | 142 ++++++++++++++++++++++++++++++
>>>    2 files changed, 180 insertions(+)
>>>    create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>>>    create mode 100644 arch/arm64/include/asm/rsi_smc.h
>>>
>>
>> [...]
>>
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/rsi_smc.h
>>> @@ -0,0 +1,142 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#ifndef __ASM_RSI_SMC_H_
>>> +#define __ASM_RSI_SMC_H_
>>> +
>>> +/*
>>> + * This file describes the Realm Services Interface (RSI) Application
>>> Binary
>>> + * Interface (ABI) for SMC calls made from within the Realm to the
>>> RMM and
>>> + * serviced by the RMM.
>>> + */
>>> +
>>> +#define SMC_RSI_CALL_BASE        0xC4000000
>>> +
>>
>> These fields have been defined in include/linux/arm-smccc.h. Those definitions
>> can be reused. Otherwise, it's not obvious to reader what does 0xC4000000 represent.
>>
>> #define SMC_RSI_CALL_BASE    ((ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT)   | \
>>                                   (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT) | \
>>                                   (ARM_SMCCC_OWNER_STANDARD << ARM_SMCCC_OWNER_SHIFT))
>>
>> or
>>
>> #define SMC_RSI_CALL_BASE       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,            \
>>                                                     ARM_SMCCC_SMC_64,               \
>>                                                     ARM_SMCCC_OWNER_STANDARD,       \
>>                                                     0)
> 
> Good point, even better is actually to just drop SMC_RSI_CALL_BASE and
> just redefine SMC_RSI_FID() in terms of ARM_SMCCC_CALL_VAL().
> 

Agreed, it's going to be more clear. The point is to reuse the existing definitions
in include/linux/arm-smccc.h.

Sorry for slow response. I spent some time going through tf-a/tf-rmm implementation
to understand how GPT and stage-2 page-table are managed in order to review this
series. I realized it's complicated to manage GPT and stage-2 page-table and lots
of details still need more time to be figured out.

Thanks,
Gavin

