Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F76FC8
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689334176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CNc2AMwY6j+gBTg0KDHhtBenH6Ojij4rr7s4QSquO+E=;
	b=ENT+weYA3l73dOnkaV8OJTVb0vZE7LGF/Td3ESI6T50Pm12wshkESCduOebBNpLdnnFIyL
	kx7qlGDkGPmCCZ4Z1v7nyyamARCEK9ZKV0sNj2I06RYeqejBFEtNXqhuazblcQU+PxUVvP
	yfTbSmhjvcBE6l931caPuRdP8z40IJY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-Dp8tgmcOPMmQ4ttyR0MPpw-1; Fri, 14 Jul 2023 07:29:34 -0400
X-MC-Unique: Dp8tgmcOPMmQ4ttyR0MPpw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-682a9264618so438342b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 04:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689334173; x=1689938973;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNc2AMwY6j+gBTg0KDHhtBenH6Ojij4rr7s4QSquO+E=;
        b=b938XrS5gbLUav0i3jlbslYBOyjwRywmJHcTaf11RYlJ2R7Q9DiZBAeTBR4jnscGLL
         WSqrO/5F95XCz4HdiIjhfNVaRjImc6e7xUxRpGEwmQ53UiT1xLOASFk6nNxGQZc5Uw2Z
         e25vcgksvhuy9AN+U1Wc0q3OJD1bPikR0WesNa46OI1UoZvPqMUahbG5CCXumqWd2mUr
         FQBH21+9hhoMeJds5MN1IpkqNt3AAsXjv27Z9GVg1wXRKz5/7LYtidQG1Jmxv9bd4RD8
         plCWuuOivmbrMTl2n8r2D8HidEMpivFXPKOW39Wv8fAq4yndbE4oC3iHB65hicqcNUv2
         /CIg==
X-Gm-Message-State: ABy/qLb3XfvJn2yBXdU5b3hRHDip4QpadYUeloFjzjEgAzHVV16VGBeM
	ejCFaXsf2TN2qNU/PFR1kzhIjVOsx+xcMETjH9sU3IknwSilXygMA6yZd6tq8KgAPvl8LfpyBaa
	YbwRo4dnBvx546Ogk
X-Received: by 2002:a05:6a00:1f97:b0:677:3439:874a with SMTP id bg23-20020a056a001f9700b006773439874amr4494290pfb.3.1689334173679;
        Fri, 14 Jul 2023 04:29:33 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGQz89XwMQNxG/MfZ3XTJEsyp1zR9lJyG/nBkaeSzJsg6n4980dvKlZFGVaUD5lXTpUC3u2RQ==
X-Received: by 2002:a05:6a00:1f97:b0:677:3439:874a with SMTP id bg23-20020a056a001f9700b006773439874amr4494271pfb.3.1689334173333;
        Fri, 14 Jul 2023 04:29:33 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w19-20020aa78593000000b0067886c78745sm7017215pfn.66.2023.07.14.04.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 04:29:32 -0700 (PDT)
Message-ID: <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
Date: Fri, 14 Jul 2023 19:29:28 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Nadav Amit <nadav.amit@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Nadav Amit <namit@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 7/14/23 18:31, Alexandru Elisei wrote:
> Hi,
> 
> On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>>
>> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.
> 
> In arm/cstart64.S
> 
> .globl start
> start:
>          /* get our base address */
> 	[..]
> 
> 1:
>          /* zero BSS */
> 	[..]
> 
>          /* zero and set up stack */
> 	[..]
> 
>          /* set SCTLR_EL1 to a known value */
>          ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
> 	[..]
> 
>          /* set up exception handling */
>          bl      exceptions_init
> 	[..]
> 
> Where in lib/arm64/asm/sysreg.h:
> 
> #define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>                           _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> #define INIT_SCTLR_EL1_MMU_OFF  \
>                          SCTLR_EL1_RES1
> 
> Look like bit 23 (SPAN) should be set.
> 
> How are you seeing SCTLR_EL1.SPAN unset?

Yeah. the sctlr_el1.SPAN has always been set by the above flow. So Nadav 
you can describe what you encounter with more details. Like which tests 
crash you encounter, and how to reproduce it.

Thanks,
Shaoqin

> 
> Thanks,
> Alex
> 
>>
>> Without setting sctlr_el1.SPAN, tests crash when they access the memory
>> after an exception.
>>
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>>   arm/cstart64.S         | 1 +
>>   lib/arm64/asm/sysreg.h | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index 61e27d3..d4cee6f 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -245,6 +245,7 @@ asm_mmu_enable:
>>   	orr	x1, x1, SCTLR_EL1_C
>>   	orr	x1, x1, SCTLR_EL1_I
>>   	orr	x1, x1, SCTLR_EL1_M
>> +	orr	x1, x1, SCTLR_EL1_SPAN
>>   	msr	sctlr_el1, x1
>>   	isb
>>   
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index 18c4ed3..b9868ff 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -81,6 +81,7 @@ asm(
>>   
>>   /* System Control Register (SCTLR_EL1) bits */
>>   #define SCTLR_EL1_EE	(1 << 25)
>> +#define SCTLR_EL1_SPAN	(1 << 23)
>>   #define SCTLR_EL1_WXN	(1 << 19)
>>   #define SCTLR_EL1_I	(1 << 12)
>>   #define SCTLR_EL1_SA0	(1 << 4)
>> -- 
>> 2.34.1
>>
>>
> 

-- 
Shaoqin

