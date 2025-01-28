Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705CA768FC
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738043238; cv=none; b=X4S87ajME7hEZ2sBlrK/8Nbtp0was4ig7xHCcG1M/c7qjCiZU0mb/atdAk24w1JsGdZxpS14F6VoA7Vuf57EPahPctdrGp3La8pg88AS62Gu2hL0e5ypSFL21BH+uk/BYi53G/ce5v4rEyE9ZZUGU5qB5GVl80OzkJkr+MlxYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738043238; c=relaxed/simple;
	bh=bSqOpBh9c+WYhpQcPwZJnbX4nNxmGrR1DPwd0RwuTs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bws4KvFYO4+1CSioZD5VFpoebBuvbuSN9D4DJkx5k3+F8U15G2/x8VKra1KDdbG9+UBKhF2Y7/S88MnMwCIHPRCqLU30wGwogQ5P4CtBIwndOpyt2myJbeW2QsnhZxE0QtfyujwASd7BjW5Dfpzgcyq0Opv5KyqD3UBxKvSnbjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h1pp2J5o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1pp2J5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738043235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZfRypJrBXY8TUZ/BgiawVGat4WmGQVQwJaXYpw4b6P4=;
	b=h1pp2J5oV2LbLUQ7u8/l/cLg3V7VyVHldNy1UOoiBvQw4rUWk+QfAnDCoozwnZTmM3neUJ
	Q1o1F2U0QySw6yOEqbY2o5NbhlC0e771yUUJuQaXSLD2yT95tfFvIa8bJy0XND+N0pyiMY
	1vseXGZDeyw80Zogrgmc61yJvqHJpdM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-Q_Kmrm2rMZuOBj-R129blQ-1; Tue, 28 Jan 2025 00:47:13 -0500
X-MC-Unique: Q_Kmrm2rMZuOBj-R129blQ-1
X-Mimecast-MFC-AGG-ID: Q_Kmrm2rMZuOBj-R129blQ
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-21650d4612eso143316155ad.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 21:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738043232; x=1738648032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfRypJrBXY8TUZ/BgiawVGat4WmGQVQwJaXYpw4b6P4=;
        b=mvvPtz+IMmrq2FsGdmoIC97IIREFkGW5Z2NOJRawmO4WbBdzNu3XYLa+zRb+H1lvY4
         YbbE+KlZ3seY9/JbMX3YLQtGiJPoHzJrg6mZ2QyTeeWlk9Yvv1517kGKm4OjFRQualfj
         Hlmdp8bEknj+aPklOF75piQWuNQby7yD89gk3U9U/GlyVRQOrZnAvex7nQ0cPHINDV4e
         nhd9r+ivGv4oZy3XvRWJwU8Aa7Rj7uEPKS7rDAWN4MqvjDrSBkwhSGRhZ+AhwjFYJ3JP
         8WRyCImOuIqOt8SMeGj8F73qMpnUeblbhjYV7LivpAmF30x58dioP5KEHltMDAX0DsOo
         w56A==
X-Forwarded-Encrypted: i=1; AJvYcCU78dZzuihSoDpzXNOOFaYf1ShT8Lh8CCEnCAuix2r4gvZ7iNGJuef63FeI5Pl/QdsXMpNpx+I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4XbQuxCL/43zSfSTI+4BUyb28UppHQsnhXAbzKlDkd6WWhmon
	0Yba6YSXzzW4Ihw5kudCIVlQnxVI/1ZrMH9Rf+jiLuP0alcxtjy9UQ0W3yuaSFV8a+OT4ijmXWd
	qEFQZ81Vn2Mo5nW07KkGzvM7ZrP07tYw5D+loZdRvQNoesvGz/RNysw==
X-Gm-Gg: ASbGncuOOXeNpnsoz8JufAIVWRq9/8UlWzF2lvqMmn75gY5Rgmx93vGioLO0w1gKdT5
	9AaXB8ijuJZY7XkpS6f1qWi12TRoy1pFcsaTate+wCopD5mobLuJAn1UqvxWZzxoS1qXkqDwvEI
	bYqfm3T4F+qTQRMfbfUUvwBBd2o8rEY2+XHbc3kV2U0INcaAxHpslen4/PVJrmf8laeh4pvsFlC
	4vF82cX1uGZBBGi5iUCdf6qblF9mOowUW3XGauH2HGbOph+XMmqXK51oEzYJiF2iqF2pYNAxxEH
	mdV42A==
X-Received: by 2002:a05:6a20:1591:b0:1e6:5323:58c5 with SMTP id adf61e73a8af0-1eb214a06f0mr63365307637.12.1738043232169;
        Mon, 27 Jan 2025 21:47:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj7WcMyL/2PjgoUCXeF8pDrIwXJ8iDNSOsLtS1l4yE0zK1FCS82DOSLWaxPfSPcfKWvA2L5w==
X-Received: by 2002:a05:6a20:1591:b0:1e6:5323:58c5 with SMTP id adf61e73a8af0-1eb214a06f0mr63365273637.12.1738043231858;
        Mon, 27 Jan 2025 21:47:11 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a69eb81sm8276685b3a.26.2025.01.27.21.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 21:47:10 -0800 (PST)
Message-ID: <1032c158-c5a6-4845-affa-f444e0071e5a@redhat.com>
Date: Tue, 28 Jan 2025 15:47:02 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-7-steven.price@arm.com> <yq5amsgsrzva.fsf@kernel.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <yq5amsgsrzva.fsf@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BPYXAuq25rI6Zcpzkn4KNaj37JNYKSZOblU77DIopGI_1738043232
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 3:44 PM, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +static int rmi_check_version(void)
>> +{
>> +	struct arm_smccc_res res;
>> +	int version_major, version_minor;
>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +						     RMI_ABI_MINOR_VERSION);
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +		return -ENXIO;
>> +
>> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +	if (res.a0 != RMI_SUCCESS) {
>> +		kvm_err("Unsupported RMI ABI (v%d.%d) we want v%d.%d\n",
>> +			version_major, version_minor,
>> +			RMI_ABI_MAJOR_VERSION,
>> +			RMI_ABI_MINOR_VERSION);
>> +		return -ENXIO;
>> +	}
>> +
>> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +	return 0;
>> +}
>> +
> 
> Should we include both high and low version numbers in the kvm_err
> message on error? ie,
> 
> 	high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> 	high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> 

I think so since a range of supported versions are returned in the failing case.

Besides, 'unsigned short' is more suitable for the local variable version_{major, minor}
since both are 16-bits in width. 'unsigned short' explicitly indicates their
width.

Thanks,
Gavin

