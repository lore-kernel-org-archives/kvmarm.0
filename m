Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AF6176FDB
	for <kvmarm@lists.linux.dev>; Sun,  8 Sep 2024 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725839796; cv=none; b=LcsllMAs4rJnYrhXHyHncZWmnAA3L0QCVFAJoGtUwej7U0Hlxs5nsrIUIjjPHbBLuAZWRuD0FfFOP85rBjGRVQbUKBmKL7M1wKOdsfjbtppgF9Gq8UDUjuysvq0zxuSJ91k5C8fmY+jRl3NhARtquhq13gjt/+6AiQD3w6L+O7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725839796; c=relaxed/simple;
	bh=xnBhG1htVsYmmeqg4KhLhGhJm+4eFBxJoyGWnxUjqow=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DWPm4LN0oIGdtQPUO3m8j8rNofSUd4JFIVuEiJ4fjanJu/tUoNGbjdESs7abcghDXJpCU2GOHr5yXouNceJtZ8UAuxXZPUIX6VGjdlQSgSKC5QfCUfNPCi1xTJPhmXalrO4TMcIhTjWB2wEi6vPVT+wb3ch80vYPrrYfVh19NCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJs0hktg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJs0hktg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725839793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Eay2AcB10eOA0g7b1zM6F5JSavvwWWINu74NLyTeAA=;
	b=BJs0hktgKxAiWXWtfjRHMi7LNey9OMtST6XU0eU8d/nZr1OVBMDrTzTNS9yDxhfT62bHHe
	bHSt/ybJIwAQXAKYsQCEO0QJyr3VUfZXC8Z89P7i0f8Al3WEbJJAf8soyHZWNDul+YQMLL
	Thra1np/SGSloBPwcBr3318XTiR8Jck=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-4AvhT5grMJaNPejHsZsEIQ-1; Sun, 08 Sep 2024 19:56:32 -0400
X-MC-Unique: 4AvhT5grMJaNPejHsZsEIQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-718dedf3615so1615786b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Sep 2024 16:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725839791; x=1726444591;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Eay2AcB10eOA0g7b1zM6F5JSavvwWWINu74NLyTeAA=;
        b=Lvx65aC0tdYFy/spXCJ5NHtW7dGt+2wrtNGRc7WQtncHkR1MDuSaltXfUJ0XnA8qMx
         IC8QzkkySsmgQh0coADZL42zXwEGEZzQ4fE11ADEwRLqbSGF820eOlqD48uEk5g9uiW7
         ly0M80nxwY43kEWlsvsVba5beOH0gUSBW03ztLSUgllcWRP16hQjq7uLic4IaDXIXsa7
         56chg7SXluneqPRAk2YrKTaBVlDgJqTFv4W4iAqKg4WCbWobYMSaSLSXD+u/TaTOogcQ
         7wcPq3kolePbCiFD5vqAiTFSX2jLMqOKu88bAb6ah+P/QrjriRe/PopGjvlpXadBoy0h
         fi8g==
X-Forwarded-Encrypted: i=1; AJvYcCWSP3XSi9DG0W3IwVkCxj2P9zBMY3uUF1KII/loOf7PNTPWupcSV96M5gBBC2MpHEKQ5BuGEnc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPoVPYFhqqCqBtOZgqQ1k9aEBpgVeA4jXkZbuWfgQv7Pk3iKuF
	8Eek5n/BfRm6G9dvEYmZamK8D7fP3kqqjuBbyRNdkndCE9NUgeQArPbiY47J1zIizv3F644wo37
	Nv6fmwSGB5feKv2KWDMLvLi0sO5Np9Ei1mblRWBQ1EoL8JMf6q39chKbJqDDM3w==
X-Received: by 2002:a05:6a21:1796:b0:1cc:e3a1:b9e3 with SMTP id adf61e73a8af0-1cf2a0b0411mr6502650637.25.1725839790878;
        Sun, 08 Sep 2024 16:56:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHG8rnmzacFhD7eXK/M1BWkW92PLgR0E8PqBkp5IEXjFxmE+Aw+DEcmm9s8X9PHOrtvGDYEA==
X-Received: by 2002:a05:6a21:1796:b0:1cc:e3a1:b9e3 with SMTP id adf61e73a8af0-1cf2a0b0411mr6502634637.25.1725839790369;
        Sun, 08 Sep 2024 16:56:30 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718e58966efsm2486357b3a.34.2024.09.08.16.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 16:56:29 -0700 (PDT)
Message-ID: <a71de00f-6f66-420f-91fe-e3b918163f70@redhat.com>
Date: Mon, 9 Sep 2024 09:56:21 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/43] arm64: RME: Add SMC definitions for calling the
 RMM
From: Gavin Shan <gshan@redhat.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-6-steven.price@arm.com>
 <fc168fe2-2b19-4930-85cf-047260aeaef0@redhat.com>
In-Reply-To: <fc168fe2-2b19-4930-85cf-047260aeaef0@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/6/24 10:11 AM, Gavin Shan wrote:
> On 8/22/24 1:38 AM, Steven Price wrote:
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1
>>
>> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v3:
>>   * Update to match RMM spec v1.0-rel0-rc1.
>> Changes since v2:
>>   * Fix specification link.
>>   * Rename rec_entry->rec_enter to match spec.
>>   * Fix size of pmu_ovf_status to match spec.
>> ---
>>   arch/arm64/include/asm/rmi_smc.h | 253 +++++++++++++++++++++++++++++++
>>   1 file changed, 253 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>
> 
> [...]
> 
>> +
>> +#define RMI_FEATURE_REGISTER_0_S2SZ        GENMASK(7, 0)
>> +#define RMI_FEATURE_REGISTER_0_LPA2        BIT(8)
>> +#define RMI_FEATURE_REGISTER_0_SVE_EN        BIT(9)
>> +#define RMI_FEATURE_REGISTER_0_SVE_VL        GENMASK(13, 10)
>> +#define RMI_FEATURE_REGISTER_0_NUM_BPS        GENMASK(19, 14)
>> +#define RMI_FEATURE_REGISTER_0_NUM_WPS        GENMASK(25, 20)
>> +#define RMI_FEATURE_REGISTER_0_PMU_EN        BIT(26)
>> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS    GENMASK(31, 27)
>> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_256    BIT(32)
>> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_512    BIT(33)
>> +#define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS    GENMASK(37, 34)
>> +#define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER    GENMASK(41, 38)
>> +
> 
> Those definitions aren't consistent to tf-rmm at least. For example, the latest tf-rmm
> has bit-28 and bit-29 for RMI_FEATURE_REGISTER_0_HASH_SHA_{256, 512}. I didn't check the
> specification yet, but they need to be corrected in Linux host or tf-rmm.
> 
>    git@github.com:TF-RMM/tf-rmm.git
>    head: 258b7952640b Merge "fix(tools/clang-tidy): ignore header include check" into integration
> 
>    [gshan@gshan tf-rmm]$ git grep RMI_FEATURE_REGISTER_0_HASH_SHA.*_SHIFT
>    lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_256_SHIFT     UL(28)
>    lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_512_SHIFT     UL(29)
> 
> Due to the inconsistent definitions, I'm unable to start a guest with the following
> combination: linux-host/cca-host/v4, linux-guest/cca-guest/v5, kvmtool/cca/v2.
> 
>    # ./start_guest.sh
>    Info: # lkvm run -k Image -m 256 -c 2 --name guest-152
>    [  145.894085] config_realm_hash_algo: unsupported ALGO_SHA256 by rmm_feat_reg0=0x0000000034488e30
>    KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) hash_algo: Invalid argument
> 

Please ignore above comments. As Steven pointed out in another thread, the TF-RMM needs to
be something other than the latest upstream one. With the TF-RMM, I'm able to boot the guest
with cca/host-v4 and cca/guest-v5.

   git fetch https://git.trustedfirmware.org/TF-RMM/tf-rmm.git \
   refs/changes/85/30485/11

Thanks,
Gavin

