Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D4D381AEA
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772716212; cv=none; b=uWG2jdRSpdhwArpVfoVvPvh4YjfmQzMaSTaJFx/SNorVsfAMHm/12h6Ihzyvi7XUS+N/dvxte6t6r4abR19X3Rw9ND804C63n/a0/8sXedGqrlH61vb1ctog+LxYpvI1R8ULuDU1sX/Z/7kVizAKDTZIPqFFe3ucuYBzPmn35qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772716212; c=relaxed/simple;
	bh=vPlxut9OXHH1bY2Gdlnx6lxT/9pg9NXPcgHZbpeBWt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jkal9blm4lJ3w9Y42HZEBi3mKhdn8y0/+WtrdCx6xWG3r/9VVqTbJE7SwQm6JhaHzAJBqEHfnHEjWrBpA/sFMK+sBrhm0xwWRtiZnEICqes4HK2/M4ez/qNjWF+aYaSXthZVD5KRpi3KkHPiaZ7rxvh6OEWjn/GL91CGlNhfIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GB/tgfZt; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GB/tgfZt"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439b7c2788dso3132676f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 05:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772716208; x=1773321008; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LVxY2Nvs4CUcsSzzohIG+ez/mPEabd4kcPakxAuZGEQ=;
        b=GB/tgfZtBgZJA8Msq1kpSyuZVx1ts9IU3gHyjsyRcYXeCXduJdCrNCvhpNnD2Qql5t
         zaJYJEPUvtHrzSI51fkI9FGDml59BUmsq/M1y7goVIhpYTAiSbaFcvAYpwyYqmlIhvLm
         UsxDf5m2Y0E3P98k8r/NQEgD32/DjbmI1ToeqaL+8/1fhAOX8tfp3UqQcqEFgTEEu1Ik
         DHrs00LPj5hRLZBQz58aShWz8ztfwheghAFsj181Exlvcgww4kECgIgUSalPE2xZuJ+Y
         iuF0Sjxu7zHoEJerLusYQSJ+FrUiff8A4L18DORhsqwfyPbgQ0Ar4MtQRGCT0pT1NmrL
         Anew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772716208; x=1773321008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LVxY2Nvs4CUcsSzzohIG+ez/mPEabd4kcPakxAuZGEQ=;
        b=sKpjBoG67Cu81NQu8rh95HxYMUIs15Ws3YsMToSt6MQ6/BYDnuKzBK2PeCV+ArcUYo
         yy7b/C60V0UchCEtpEeELvQHM1TIf1sHGzM5YO3QYsoLLf54jl+HUVCI04a1DrtH/xiw
         j4xvF12KiQJzQKKh50Xsjb8Q8y+m4fMK9taM8V1g1BbYrGQynM7h+r/hfeRfWJrym+8a
         WSbcnlSViEuR3pJ8CRInS1Q7sj1oIAgxWo65bS5aILXmmZpU5b+1p+QYm9GQOdIjNa97
         /+VoOJ0jUbmsKrApfNo2C8hPZjEXfww3aTPFyI0nlXda7Uf2Pw1yyGfP5bfyrVJGnbL0
         fSoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA4Paka+DrMxm8eSABvGEty2NjXcS3pPB8Rb55N6BE795lCmhM2CZXZkpdpUEjU64FJd8yWzo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7hfXofPvewgSAL1YaJ6uDIdoQPu7ZTO8pbS0Oeo0LskREG+Ay
	OE9UNNAe6VlJyIpwcaEjsl0mSQnFoAmbmAPJ9h1nxSXRw3ENKTzFBdhiVVl7WI+4KOM=
X-Gm-Gg: ATEYQzzac7QBVgTsw0dQS9OMbK5NZ18W2j1K7XEvDyv8hdUUyyKB2Kbzr2IOXajCgFW
	crRG8NAyldWYZUgFwyHAjTCzosODUO/cwRlXX7cIBkIYb81apufauI1l4cIlFwmhEh2juzU2WTu
	zvOBaTTowbAF2Gp9zIjNPAHRSmd9oeWGsM6OA+HDgTfGS/0Ob701Wnh0OTIldDn898KrWUhauPY
	n0N0nY4U7JJnL3OiS8D1xkh48ycwlxlmF9ySAxI3R+x3xbB8td2yBCcWo2j6+V2pGduI9mUJFd+
	8VkkB5HyjafWB6uHmfWt2CL99RnNPlc+kcMkY4XboiMlm7pOS+IJ3SRBQjB4TMRnScVRW6+OB6i
	PV6GV/DeP7ksJUuXFKO5s/Krcxgfen8RSJmqi9N/mCHNtcDfS8cmrDzMltFbL589SelrtLtVetL
	dI2i7rbIcqVjIeD0JlbMkk9Ap8VfWq
X-Received: by 2002:a05:6000:22c2:b0:439:b715:6f49 with SMTP id ffacd0b85a97d-439c8020eadmr11409689f8f.59.1772716208133;
        Thu, 05 Mar 2026 05:10:08 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b8807a4esm30338894f8f.4.2026.03.05.05.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 05:10:07 -0800 (PST)
Message-ID: <208aebfe-3b25-4bf5-8c82-71f323f57847@linaro.org>
Date: Thu, 5 Mar 2026 13:10:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Read PMUVer as unsigned
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260305-james-kvm-pmuver-sign-v1-1-eea0a2116dd0@linaro.org>
 <86pl5i7ahj.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86pl5i7ahj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 05/03/2026 11:59 am, Marc Zyngier wrote:
> On Thu, 05 Mar 2026 11:50:01 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> ID_AA64DFR0_EL1.PMUVer is an unsigned field, so this skips
>> initialization of host_data_ptr(nr_event_counters) for PMUv3 for Armv8.8
>> onwards as they appear as negative values.
>>
>> Fix it by reading it as unsigned.
>>
>> Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/kvm/debug.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 3ad6b7c6e4ba..b8632edba9a3 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -76,7 +76,7 @@ void kvm_init_host_debug_data(void)
>>   {
>>   	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
>>   
>> -	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
>> +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
>>   		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
>>   							      read_sysreg(pmcr_el0));
>>   
> 
> How does this work on a system that advertises a non-architected PMU?
> 
> 	M.
> 

Hmmm yeah I suppose it doesn't, there's actually already 
pmuv3_implemented() and has_pmuv3() which open code the same check 
again. Maybe I can try re-using something and tidying it up.

