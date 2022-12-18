Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D301C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 11:35:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8C34B3D2;
	Sun, 18 Dec 2022 06:35:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lyJqBGVDPZcw; Sun, 18 Dec 2022 06:35:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 753A74B3DB;
	Sun, 18 Dec 2022 06:35:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6494B3D2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 06:35:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z5lPu9ipncXt for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 06:35:19 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66C344B372
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 06:35:19 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 w4-20020a17090ac98400b002186f5d7a4cso10420360pjt.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 03:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=rty+gpqd+eA6AphifEAmmJ4M709v9JxSpj7F1QZvTIc=;
 b=rX1F2dWgXZwxuIDJaP6FADhEdITe6iLUWSgTYipr1uRJNKw7uwoOTxiZvmH5N4m2SF
 vwLh8iOkGzm1i0EJpfLfyK10qF2lfES2JC93yZliwxDFMUsA1qasbEHIUJppUrhwyxiX
 V1OEK/wWL6fLDtsMPy5vuoY6nv4UtQRi9EpZ1PCQaWGIQiaVpEiVPlW8ag8XpfrV58WG
 Dk8jBOQuJFSnHaK9DTGyqLY13fzpkO71ksuD53JkP7CCwiiQJPIU2b5+WSzUSKXLla6P
 zGgJCMicombA2/LP6pYJPuXeY/qsFTYfMpla0OvqwTcZ6WyZLI4e0PJVfMUl4HceKn5l
 57ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rty+gpqd+eA6AphifEAmmJ4M709v9JxSpj7F1QZvTIc=;
 b=q3kuQmkL+tgfXXjsld6LGe0Pt1suWb4EHjbfp1ZDR+dQ7en0s1sfoakJVBzmYjdLAe
 cUenCNwIp4axhAWiWlxJz0iUiH+EW8eF3pcuVVfddWp8khGPlu0US3xXXktMOetGDliB
 tI0/OK1xzdQBDqMv72LPyTaq4dmF5A+AgS+nAD7Bv9nqTBs5A7L7+5NBMhj9n6FkMU+K
 w74LuNfd48ZU7LtKRYP+SE5dxtGQMWeHCARXqZQMtktstg1B/3fNqYuzMMnaxB5GZ9ow
 rS7qT0mbOEDv38S3eZIV/Wd0rvx6DHR6ToDX5GumNfggnR1ULfhRm7pIj2dWaMLC0zX6
 xKgQ==
X-Gm-Message-State: ANoB5plKyqQs1i1oYdKGx6XIxAfuDgcS0MFdfnU2zJ66J7s9H9Ft0WVz
 gBo1PcmGWnLakhlkvJEbk+hCBQ==
X-Google-Smtp-Source: AA0mqf74k04nAvEcKiP5y4JIHLcCk6t+UInE5HPcz0u12pjKwMJYmzyuAUgg9V5xtJ6hJ6Zw9pRPnw==
X-Received: by 2002:a17:90a:20e:b0:213:18f3:68d1 with SMTP id
 c14-20020a17090a020e00b0021318f368d1mr40701969pjc.29.1671363318359; 
 Sun, 18 Dec 2022 03:35:18 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419?
 ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 s92-20020a17090a2f6500b002191873187dsm7562502pjd.33.2022.12.18.03.35.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 18 Dec 2022 03:35:17 -0800 (PST)
Message-ID: <1ef32b0c-6cee-75f7-e1e0-ede1f5b9a016@daynix.com>
Date: Sun, 18 Dec 2022 20:35:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3 1/7] arm64/sysreg: Convert CCSIDR_EL1 to automatic
 generation
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20221218051412.384657-1-akihiko.odaki@daynix.com>
 <20221218051412.384657-2-akihiko.odaki@daynix.com>
 <87cz8hez0i.wl-maz@kernel.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <87cz8hez0i.wl-maz@kernel.org>
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022/12/18 20:23, Marc Zyngier wrote:
> On Sun, 18 Dec 2022 05:14:06 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> Convert CCSIDR_EL1 to automatic generation as per DDI0487I.a. The field
>> definition is for case when FEAT_CCIDX is not implemented. Fields WT,
>> WB, RA and WA are defined as per A.j since they are now reserved and
>> may have UNKNOWN values in I.a, which the file format cannot represent.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   arch/arm64/include/asm/sysreg.h |  1 -
>>   arch/arm64/tools/sysreg         | 11 +++++++++++
>>   2 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 7d301700d1a9..910e960661d3 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -425,7 +425,6 @@
>>   
>>   #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
>>   
>> -#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
>>   #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
>>   
>>   #define SYS_RNDR_EL0			sys_reg(3, 3, 2, 4, 0)
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 384757a7eda9..acc79b5ccf92 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -871,6 +871,17 @@ Sysreg	SCXTNUM_EL1	3	0	13	0	7
>>   Field	63:0	SoftwareContextNumber
>>   EndSysreg
>>   
>> +Sysreg	CCSIDR_EL1	3	1	0	0	0
>> +Res0	63:32
>> +Field	31:31	WT
>> +Field	30:30	WB
>> +Field	29:29	RA
>> +Field	28:28	WA
> 
> For fields described as a single bit, the tool supports simply
> indicating the bit number (28 rather than 28:28).
> 
> However, I strongly recommend against describing fields that have been
> dropped from the architecture.  This only happens when these fields
> are never used by any implementation, so describing them is at best
> useless.

arch/arm64/tools/gen-sysreg.awk does not allow a hole and requires all 
bits are described hence these descriptions. If you have an alternative 
idea I'd like to hear.

> 
>> +Field	27:13	NumSets
>> +Field	12:3	Associavity
>> +Field	2:0	LineSize
>> +EndSysreg
>> +
> 
> I don't think we have a good solution for overlapping fields that
> depend on other factors, either contextual (such as a mode that
> changes the layout of a sysreg), or architecture warts such as
> FEAT_CCIDX (which changes the layout of a well-known sysreg).
> 
> At least, put a comment here that indicates the context of the
> description.

Sounds good. I'll do so with the next version.

Regards,
Akihiko Odaki

> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
