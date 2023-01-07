Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A55B1842
	for <kvmarm@lists.linux.dev>; Sat,  7 Jan 2023 09:53:33 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso4296670pjo.3
        for <kvmarm@lists.linux.dev>; Sat, 07 Jan 2023 01:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZvpXpT1Ky1e5AYlFd/MAc5bKweGcXE3957nMDydsC48=;
        b=D95m4YQXS8WHfRC3jEEq7PHeAUm47ibQ9hLFdTpWAfsKicrq1c4eoEWt64dkl+HlZ/
         DimaYNWNHmj7Eqy67H0VHcCyHZWfazX9EMjd3mAtzYJee8uW75ZNKmaJf5aPfgTYBOvN
         ITZJuqIJ/LocP15/MBe+jupY7ApZ/GH5SkJdLmX6oa3pAUd2Rgpa+02Hn+IX52KR8fiW
         JjEd3nwhuj+cmwoQWPzLznkXXkcpYaMOR2n5JELfgPB7Cm6nc3asBM/QyJk40brNywqu
         OH05M6x730rLUKVuEiWAtE54j0KnQ0W9V2xtvCmRMWkWZEz0SFsUZiFYxikIJV6ePkRi
         2psA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvpXpT1Ky1e5AYlFd/MAc5bKweGcXE3957nMDydsC48=;
        b=UFQvIf/Jm6pwBktmec+iyFfWOELana9Hr6GAwXQTqwqrn4WUTPpZfTxaaEd9bkQhbO
         V6S5mYxxmgGUZMj98Dsbji0/e22TOgh8GzqDw11dIPj5eCEzA3pTFO8BfZ3gGkjXgTyB
         6M5Dxf1UvaeEqfEbQ5hPC5bX1ekdSyp6xKy22KTkPwsNjvZ8qf6dCNTjbWbngglM/r2u
         vilakoMciGdyXICkdkTi9G2uqcjbwsjyqLJGq2xd+8Z115mOtH67Fjpub1lze3a4wVAF
         EKt9xyvLtNEUnm44lzx0fQk6ZUB8Rc1bNqRmyQrCXnWVB1YWC8Op+FkFRmj25FQNu9rj
         KYiQ==
X-Gm-Message-State: AFqh2kr7Y++m31suLpTXduHcr4jWHmnBED6WRkgBta+XKYZLGQpnZppy
	aIB11a15tTWknbCbdfEUPvrpcg==
X-Google-Smtp-Source: AMrXdXv5SBuUSPC6/xJKA93nQCS9A3SD15xbEP57fF5p/kQgc/6pznyw9eQ6sulp/19xM9s9+7LjQw==
X-Received: by 2002:a17:90b:23c8:b0:226:db61:c8ae with SMTP id md8-20020a17090b23c800b00226db61c8aemr6318211pjb.20.1673085213573;
        Sat, 07 Jan 2023 01:53:33 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:d54:e521:8bac:7bed? ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id i7-20020a655b87000000b0049f476e9906sm2074487pgr.53.2023.01.07.01.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 01:53:33 -0800 (PST)
Message-ID: <b47d77c6-0fb5-b11b-d98a-f85e1bbc5d38@daynix.com>
Date: Sat, 7 Jan 2023 18:53:28 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v5 6/7] KVM: arm64: Mask FEAT_CCIDX
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Hector Martin <marcan@marcan.st>
References: <20221230095452.181764-1-akihiko.odaki@daynix.com>
 <20221230095452.181764-7-akihiko.odaki@daynix.com>
 <Y7dNihZMs4NSSw0v@google.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <Y7dNihZMs4NSSw0v@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023/01/06 7:22, Oliver Upton wrote:
> On Fri, Dec 30, 2022 at 06:54:51PM +0900, Akihiko Odaki wrote:
>> The CCSIDR access handler masks the associativity bits according to the
>> bit layout for processors without FEAT_CCIDX. KVM also assumes CCSIDR is
>> 32-bit where it will be 64-bit if FEAT_CCIDX is enabled. Mask FEAT_CCIDX
>> so that these assumptions hold.
>>
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> FYI, I'm an idiot and replied to v4 of this patch... Forwarding comments
> below:
> 
>> ---
>>   arch/arm64/kvm/sys_regs.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index f4a7c5abcbca..aeabf1f3370b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1124,6 +1124,12 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
>>   						      ID_DFR0_PERFMON_SHIFT,
>>   						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
>>   		break;
>> +	case SYS_ID_AA64MMFR2_EL1:
>> +		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
>> +		break;
>> +	case SYS_ID_MMFR4_EL1:
>> +		val &= ~ARM64_FEATURE_MASK(ID_MMFR4_CCIDX);
>> +		break;
> 
> Not that it is necessarily worth addressing, but I wanted to point
> something out.
> 
> This change breaks migration from older kernels on implementations w/
> FEAT_CCIDX. There is most likely exactly 0 of those in the wild, but
> we need to be careful changing user-visible stuff like this.
> 
> --
> Thanks,
> Oliver

I also don't think whether FEAT_CCIDX is visible matters for any guest 
because the line size a guest would care is held in the same bits 
whether FEAT_CCIDX is implemented. But if it concerns you I can write a 
bit more code so that it won't mask CCIDX bit if it's set from the 
userspace.

Regards,
Akihiko Odaki
