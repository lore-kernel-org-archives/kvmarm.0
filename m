Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A72836A0
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 09:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748944229; cv=none; b=F04+ZF8TGTm5jK2MxXT75bENhkd2AfLrJ/SI4ZO+92btQBJtcGQcZSZ6CfmrYmbIcoIgDpDB5iP3RnqxqvDfgw8LHjEnSnMaDYNL7jZZ3WPrt2k5TdVjBD8C2wN0UWAUAfVobwqm5cPaELeOC5JrCU8Y6ZqQuzqML/WOe+Fgrgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748944229; c=relaxed/simple;
	bh=cYofdeohFRtCrlrs30kGtQgAlnzJghGw3tFBSu52gXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qFRuZrnFspC2zFSvLve6pa6rsADq+u006+PUtnBPwDhTf4AHfZTX5HLirliKlmihairSWzAFZtcu4C8nJF8fAxemoVmXKrb/5G9qJjRCyu+3dbnfRHtJrMsXvFRUFQc2cPae5mn9pMsOlcfv6e9bYZ5jd82sDP2zx9NSDvX1lAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FDKCIrNh; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FDKCIrNh"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a375888297so3204942f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748944226; x=1749549026; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YTiUXP9qqpwePncWUOCrudvn6ikDCRoeniFYV5C54HQ=;
        b=FDKCIrNhQp1wejPugRqka1qXo1FFFtsaU8bLFLLo+aTX5Lceo7F+XVh9wnJ+bAASNS
         4okL0vzNpD3VWP2woP5BGxduZI0BIAU4up6RtsgwG7tES9rJjZwYYC3CaMa8K+q34knJ
         7KX8AVP5zHKCRzevM3iDwepDR1EsQ6c7WdK7ZoBS89oT5wKKNbDocGy+2v9ZJNQmo9n9
         BdnZSh3ut761CZoiYTtmroW4kMxhbgZB1bJMi9MfB8E1zubiv4UnUliYIeddXaQh9ALx
         LBuWRxp8LGlh2NrVQPAmIpw48iBBIrbfrwchHmE+/Wt+Id0aoHzFghDdD0fapLlasCVS
         6A5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748944226; x=1749549026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YTiUXP9qqpwePncWUOCrudvn6ikDCRoeniFYV5C54HQ=;
        b=cBbnltaCFIRCRMR0NrbPaRtFWCbc6o9oRl6JE1gLkVBpurjMSYX1Zy44YiSqod4+RJ
         taRI95M5hxLM8+UW0HZh+Cql1wmSrEczfR02pvMQ9S9JyGvgfzUCzGLnTMUFwckkLR+O
         HjbNn5cQnmMpTKIG24H5N6cyL4iG/K92rkqgtgUSHkaE0h8OqS9EKAMV65tnyHaLi6yP
         9ptkjf1HgMfPd2xF4jB/vykFia29UNBBBnB+ljXCZ+qwi1/wkTNnDmRcyxoDTjjRtZGl
         BxFW8Zb+RRVj0sKOJxSGIXQ9tQtYGgQs8TH253WEm4NEBUPjBNvilbt0Rd/FL2mPXg2M
         xOKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnKmshIqeGTRw6KE3F5cR8jzmigx1BTUL8uodAgpysroEidof0rLH8rmzVoHGoCxTxsUpIIMk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9XHYArUBJWVmfkFVH8n/yej+0uNV9xNkyTcVJ7ktqDqFXRThp
	0TmKWtCd5XH/QA2YGyzAzf4uvSji1xhmQX/0x6I4QGnyHUJ/dwu081nvl8lz20lV+l0=
X-Gm-Gg: ASbGncv5Zj5a6WRQZ4dcN/ieQ2oTFPz1MkVOc9ZaLG+R2SbJVzca0KlNv9PxacG/pXG
	a7gH/MslbhD2NDAqBTuvW0VE2sHd+D/NkzmTgrYT1n8YPQLfAvUyXO+lRw+GqvZ6gvtJ8xyw14k
	ngtJWX8Y5IQSiN5HXwV0j0TY0y0evK7SF76oPxi9wQpXi09OeaKFL5D2s8ads8psHZXSW4tTfnc
	yxP+uJJPE83AXck2tfNnhUWPyAH3r7XayLiRwje2jfUHW0qP7lztMEtV5Of+Ojk03A2rfLFeUDT
	4qrzT35335vUVy1tcTtIntaJnmTaqtwOEiA4BPeW3lc9yld3OVOSKivc
X-Google-Smtp-Source: AGHT+IHsW44MmqwfDKjzghl/i3BzuGEINgERerQaDbyP3gu7SUf4muuyytvtJbMK7SPgP194SuthmQ==
X-Received: by 2002:a05:6000:2892:b0:3a3:6478:e08 with SMTP id ffacd0b85a97d-3a514502388mr1696065f8f.23.1748944225608;
        Tue, 03 Jun 2025 02:50:25 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c9d4sm17906246f8f.38.2025.06.03.02.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 02:50:25 -0700 (PDT)
Message-ID: <2fb1965b-bef9-4a8e-a1c7-c8a77d957b23@linaro.org>
Date: Tue, 3 Jun 2025 10:50:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add trap configs for PMSDSFR_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
 <20250529-james-perf-feat_spe_eft-v2-6-a01a9baad06a@linaro.org>
 <867c1ze4pg.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <867c1ze4pg.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 29/05/2025 5:56 pm, Marc Zyngier wrote:
> On Thu, 29 May 2025 12:30:27 +0100,
> James Clark <james.clark@linaro.org> wrote:
>>
>> SPE data source filtering (SPE_FEAT_FDS) adds a new register
>> PMSDSFR_EL1, add the trap configs for it.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/kvm/emulate-nested.c | 1 +
>>   arch/arm64/kvm/sys_regs.c       | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
>> index 0fcfcc0478f9..05d3e6b93ae9 100644
>> --- a/arch/arm64/kvm/emulate-nested.c
>> +++ b/arch/arm64/kvm/emulate-nested.c
>> @@ -1169,6 +1169,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>>   	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
>>   	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
>>   	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
>> +	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
>>   	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
>>   	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
>>   	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 5dde9285afc8..9f544ac7b5a6 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2956,6 +2956,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>   	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
>>   	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
>>   	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
>> +	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
> 
> PMSDSFR_EL1 has an offset in the VNCR page (0x858), and must be
> described as such. This is equally true for a bunch of other
> SPE-related registers, so you might as well fix those while you're at
> it.
> 
> Thanks,
> 
> 	M.
> 

I got a bit stuck with what that would look like with registers that are 
only undef in case there was something that I missed, but do I just 
document the offsets?

+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -87,6 +87,8 @@
  #define VNCR_PMSICR_EL1         0x838
  #define VNCR_PMSIRR_EL1         0x840
  #define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_PMSNEVFR_EL1       0x850
+#define VNCR_PMSDSFR_EL1        0x858

+++ b/arch/arm64/include/asm/kvm_host.h
@@ -596,6 +596,16 @@ enum vcpu_sysreg {
         VNCR(ICH_HCR_EL2),
         VNCR(ICH_VMCR_EL2),

+       /* SPE Registers */
+       VNCR(PMBLIMITR_EL1),
+       VNCR(PMBPTR_EL1),
+       VNCR(PMBSR_EL1),
+       VNCR(PMSCR_EL1),
+       VNCR(PMSEVFR_EL1),
+       VNCR(PMSICR_EL1),
+       VNCR(PMSIRR_EL1),
+       VNCR(PMSLATFR_EL1),


And then sys_reg_descs[] remain as "{ SYS_DESC(SYS_PMBLIMITR_EL1), 
undef_access }," rather than EL2_REG_VNCR() because we don't actually 
want to change to bad_vncr_trap()?

There are some other parts about fine grained traps and res0 bits for 
NV, but they all already look to be setup correctly. Except 
HDFGRTR2_EL2.nPMSDSFR_EL1, but it's inverted, none of the FGT2 traps are 
configured currently and PMSDSFR_EL1 is already trapped by MDCR_EL2 anyway.

Thanks
James

