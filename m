Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F7296BB8
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791258600; cv=none; b=gOt1ROIxElrIoDFGwqQpTqrO5GNnYgjLf/0qCqdutcNKNupnirt2qkuNlqOCx3qNpsA7YPWj3QLhChoB1RRYr5Cpa6+MwiqGg8DxBcOZdP8BYprptPDKYzHyj1uiGwS8snonF5chwIV5U5ItI2BKjkLgBCwT+47NcHlqZpKQHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791258600; c=relaxed/simple;
	bh=9NW5It6o5eoUftkY9ls5gsc+2gvCsipwEhZuTUOLJ2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2RfjZdjew1nFmXVFqvdAfgWxFgstl2DDRWljFuJzoHO0HfrU2BEGnrY7TRjwqMYwHTFlVc15qU6qe1oc9hHzAIVxhliwKe1EmQbd0wEYSYGJF5zZbsMcbzKjuaF6l6CmnPS+QVQSAsYDDCz+DascuMTeh9OeEPmHxPJiBy4B/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tm4eK9Pb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tm4eK9Pb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791258597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ikmq0G2vWuzS8RQjLvE7O0ZgTT2QCtc6oU8WM5b+mQo=;
	b=Tm4eK9Pb9oYZ31yTXRCORBHvebJ17iCY73uP6bX8iUJvVMVfPaFsyOfmANvOkEvMvwzZ6e
	qUA8+bPMm9fNSZn7eiozKfWbNz8EFqH8DLat5OlrGZedfH2wJx3TLrLI2QrWmXV34WavCM
	Kxgy1y3KCCmmgWET5+KJ4lKF3ccD/no=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-3bM39J8FMT612pmPWtpoSQ-1; Mon, 05 Oct 2026 23:49:54 -0400
X-MC-Unique: 3bM39J8FMT612pmPWtpoSQ-1
X-Mimecast-MFC-AGG-ID: 3bM39J8FMT612pmPWtpoSQ_1791258593
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a7ab1ca9f4so2129372a91.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791258593; x=1791863393;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ikmq0G2vWuzS8RQjLvE7O0ZgTT2QCtc6oU8WM5b+mQo=;
        b=OEihpcIMjYrUoT9X34MVMxqOJugucItruh9lm2dp97PSDuvR7gnBRTg66r9iCHGjVF
         WrgRveJcil62s6q3dkmxVy4B39kfgQE9Gvt/ZCmCMmkMT+cERBW0dmf3IIA7AmaNQIkt
         z+vQXgFZT4dQkn5OnaBAXzQV1iZ/iEdqctuM0Jery5hBeWWPGWmeHyBG8y3vIN6veJ9N
         kU6XdmYDPgPyKnqU1zpEA7h2bs6WikdkYljZJ2VPaX9iZG0+i9zPEl9qDeDCe2dOJBMO
         9k2bUcvU5HL5C7SHnkrIAciZHkON0yevezmIs5e2IDfwX+LwwzDrk7TtsI64E/w6IWDz
         1ozw==
X-Forwarded-Encrypted: i=1; AKwUvByrOB5q58IYwoCZXzqY7pq91dbB6DBJEB0weLeWTwkULyrV6+EyRMaLQuvhYnFCRzjafSbToMM=@lists.linux.dev
X-Gm-Message-State: AFq9FYLkcB1z8zIQuQc1r9mkkFoU1TycgqvjS1dkr9pF1QZYOFYSk9EB
	wOg9W5OpIuxSy60QAnlSvgBcB9bMpwj7qgqbAsYRjANgzfZ749VlaBY84vuCpbHuFtcxsFSW8XO
	mg4E6qIAOc9W7bjCA+jr2+y03RqSYPm93ioCbE1SEacsrUP5igBGN6Xq4rA==
X-Gm-Gg: AYBFou0xr/FhVPCYEscah08BJsuIBorTlaczgEquukDwydD49AiAJh0JrCA9bfx+G5W
	zZjF8tP6nqztK5fEXSytyX7YyC2yxxcKGkWPa52jG/cTMVjytjmRF/0C1txzAB8Mcfr15YZleXX
	sSMRsf4HibVCiWwKaMAZfy4rQUY/4ccbB4uu6APTJedZBUGGpnNsL7Jdy/hOxPnG2LjWkvuqZCi
	J+b+THvb/eohybKoap/YJxhbL3tOITyil2a8vMEfKYO3Cky/MXzIbwEcX4bnIQSU7LN6lsnQhzc
	ELkdo89LvYtOHvueQi3xSbIVmtiTrRXpPJKnL/5QSxX2yLBpfWTNJosqTGQHwAOpqtN8vWw9HmB
	WiMgghB2nnxWCOurrfv0aNBP0JgweNt0lfGRoxefmZQ==
X-Received: by 2002:a17:90b:2e45:b0:3a8:1745:6c01 with SMTP id 98e67ed59e1d1-3a873697b75mr93384a91.35.1791258593275;
        Mon, 05 Oct 2026 20:49:53 -0700 (PDT)
X-Received: by 2002:a17:90b:2e45:b0:3a8:1745:6c01 with SMTP id 98e67ed59e1d1-3a873697b75mr93373a91.35.1791258592828;
        Mon, 05 Oct 2026 20:49:52 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853889667sm2507543a91.1.2026.10.05.20.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:49:52 -0700 (PDT)
Message-ID: <2e83d025-2edb-43bb-a9fe-cdc09ac2320a@redhat.com>
Date: Tue, 6 Oct 2026 13:49:42 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 20/23] KVM: arm64: CCA: WARN on injected undef
 exceptions
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-21-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-21-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3kzotVVxTMPzNPXPG1krcwAQu7qZPCjt4Mn87AE1H7s_1791258593
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/inject_fault.c | 1 +
>   1 file changed, 1 insertion(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

