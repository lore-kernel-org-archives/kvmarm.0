Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8A17FF7
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 11:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689853832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jx6EOdcX24MLWgGqV3iDS/42+N7tAZafpHq9oSuqr7A=;
	b=HaZ5aY7Iq3izQkuOQ3AuEubik10KUg4UBR6JC1y3Gcr/hDLxRLwQzeQIFWQRi1xS6KGos/
	YLeYyE7h83Xawq5r50C0YZQ/Ox2vUya12eEJcQWhwqKgni49VSKkqoMntmxXBDMjqpAjZx
	ZKeZLBouZ1S9m8NTfiJlZqhYu+4g5ow=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-FZtrMy00PquJZDoLliyqVw-1; Thu, 20 Jul 2023 07:50:31 -0400
X-MC-Unique: FZtrMy00PquJZDoLliyqVw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-53fe625f145so191678a12.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 04:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689853830; x=1690458630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jx6EOdcX24MLWgGqV3iDS/42+N7tAZafpHq9oSuqr7A=;
        b=RTH+jPWJoDDFK141T/xUA2eEc4eEog+oeW8R5X8KvmEnn5HS9BliuXLfCCPvvSEfEx
         akHZhfVvuzcyzKjbh3QMAqwnoh1u5PvLLRrMKqbu8GhPuo8ozSNouCHkDqzE/bL2iREN
         np9YRyUF579I4NiUPZ0vEsF5t+URfyhp1yC7Qs6bmF6+LeJgFLLQSyQorUaxhKftm5nl
         Mnd7G8f7vjEetscuXavYOltB1Jf6Sovq9aRxhfgmBFzW58NKItS24N2e6p6Nl3Ij0JzN
         MPHjEOUWJZl7WUOgrtfDb5YhWl3Q8SyaXE7i2R8JYmaVvtjpl6dgK1xFxdpO/qtWE7Rl
         4XYA==
X-Gm-Message-State: ABy/qLbaTAr8OkjrrkZnQa+vYyNHBmvBpDo+PgnPZWK/ma5y1GlKJ6Y4
	kJ2uX1iSzi7Hsl7+id6TJhzrSU4QjFvmHQ2qq9j01r/967DG8A/0xchzcuWpPOKpz/4E0mLPx5R
	fP1F1b9PIhSE9d0Z/
X-Received: by 2002:a05:6a00:e0a:b0:668:834d:4bd with SMTP id bq10-20020a056a000e0a00b00668834d04bdmr19093089pfb.0.1689853830476;
        Thu, 20 Jul 2023 04:50:30 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF9Wgu02vzYI9FbSDeIx6hVxfo5aA65r/vOCyVZENjPU/Zny8BpXYCD3cH6jyOuUBZMtdMbKg==
X-Received: by 2002:a05:6a00:e0a:b0:668:834d:4bd with SMTP id bq10-20020a056a000e0a00b00668834d04bdmr19093070pfb.0.1689853830141;
        Thu, 20 Jul 2023 04:50:30 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78486000000b00682af82a9desm1016820pfn.98.2023.07.20.04.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 04:50:29 -0700 (PDT)
Message-ID: <41643570-a927-87de-ef1e-f0ec375edff9@redhat.com>
Date: Thu, 20 Jul 2023 19:50:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm64: Replace the SCTLR_EL1 filed
 definition by _BITUL()
To: eric.auger@redhat.com, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-2-shahuang@redhat.com>
 <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 7/20/23 01:46, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 7/19/23 05:19, Shaoqin Huang wrote:
>> Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
>> replaced by the _BITUL() macro to make the format consistent with the
>> SCTLR_EL1_RES1 definition.
> 
> I would rephrase the commit title into arm64: Use _BITUL() to define
> SCTLR_EL1 bit fields
> 
This would be good. I will change the title to it.

> Besides, since SCTLR_EL1 is 64b shouldn't we have _BITULL() everywhere
> instead?
Yeah. Although the _BITUL() can cover the 64 bit value, it would be 
clear to use the _BITULL(), let me change it in next version.

Thanks,
Shaoqin
> 
> Eric
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   lib/arm64/asm/sysreg.h | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index 18c4ed3..c7f529d 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -80,14 +80,14 @@ asm(
>>   #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>>   
>>   /* System Control Register (SCTLR_EL1) bits */
>> -#define SCTLR_EL1_EE	(1 << 25)
>> -#define SCTLR_EL1_WXN	(1 << 19)
>> -#define SCTLR_EL1_I	(1 << 12)
>> -#define SCTLR_EL1_SA0	(1 << 4)
>> -#define SCTLR_EL1_SA	(1 << 3)
>> -#define SCTLR_EL1_C	(1 << 2)
>> -#define SCTLR_EL1_A	(1 << 1)
>> -#define SCTLR_EL1_M	(1 << 0)
>> +#define SCTLR_EL1_EE		_BITUL(25)
>> +#define SCTLR_EL1_WXN		_BITUL(19)
>> +#define SCTLR_EL1_I		_BITUL(12)
>> +#define SCTLR_EL1_SA0		_BITUL(4)
>> +#define SCTLR_EL1_SA		_BITUL(3)
>> +#define SCTLR_EL1_C		_BITUL(2)
>> +#define SCTLR_EL1_A		_BITUL(1)
>> +#define SCTLR_EL1_M		_BITUL(0)
>>   
>>   #define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>>   			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> 

-- 
Shaoqin

