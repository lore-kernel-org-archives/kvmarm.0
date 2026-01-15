Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889803BFE47
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 17:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499501; cv=none; b=U8TG3bEufNPbX6x+kCQxuElk33pZfjFJOdtk+7ifIcp+ET01XxIX/O1vNhkwYBWE5IASOWIkbHrgtXBqbPmvRp4r8rbqxP+KJ5VSg5tD8EH7FaqIUpBfKDVy21B3zL6BAH9lMfwVMeO9jOR28mOfrONU6jIZAqlrj+1A1bmaKBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499501; c=relaxed/simple;
	bh=rwhwtL/vZdSfci2C/j6AljUlfCkGvdxX8zWaQP0BXQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=muosyL/BpIT99KP37WYP3BpesOYKwmGbTwf7XOHOIlQXzK05ZITasfkBAlIqSTtLDp80Y1Ub+/B1E9gxn34+XdqJYZ5xIfXO0IJ7Ds7GNOIFWfS8kFT5C+ZeZM3ubR/1PhDIumILcayRPoP5jyxaj/T3KMvoMFp72oRtk3oiYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPzWWIKc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPzWWIKc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768499499;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiyawKDjYdDN3hhvAQEOzn6Z13gC9C2oLhMaZUIuXYQ=;
	b=FPzWWIKcumaEveFF9G2p0Hn/UIpEM3OmZMgt69GbktJXDeBc+gRDOvlXAW95/lBP8KPxiY
	/19dTA69X9LHp8KliBX4hoJhsOsVev6twB5hDUdcpEY3hYDrCO7H6aSq9HLNVWtdBCBsqe
	AIMLhzycAoLt5kmu8qKg3FDWRSBVGEc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-8NimCG6SOcC6b94_i6_9oA-1; Thu, 15 Jan 2026 12:51:38 -0500
X-MC-Unique: 8NimCG6SOcC6b94_i6_9oA-1
X-Mimecast-MFC-AGG-ID: 8NimCG6SOcC6b94_i6_9oA_1768499496
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-431054c09e3so1115522f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 09:51:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768499496; x=1769104296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiyawKDjYdDN3hhvAQEOzn6Z13gC9C2oLhMaZUIuXYQ=;
        b=mr1urOcIV7oEnh8wztnfOkAsZUKLFgL/7Q+c8FKOnZ4+BTn3Iu4tQris47sKaA0QmX
         oBqpQ+H7sCpZrdNqVyX1eSot5eXKjPtASJtoyML/sl6KG+AcZmeZ8SYPmrHd0x+MYGYJ
         UepWuSO391v8asNZTMnJJ9t7Sn53CTFW94Ekep2B7/J0IJt5qCdgHbXQAS/mVkafVTCO
         2wRYxaZUXYU9tTkveCZ6vrzHTkmz68+39e1GcaFtes9mYVC+0dblx0jWaQ6TZgHVP3jj
         MHViu+O1BA/joWfoefw/5CVjX6vb2dp1Yb27Yg1s8ufX1I4HJyxjMWzSy1u96dawHDSj
         yEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW32iyQU/KVGZtizGuQ9O4zB/OZhNSik8kclnJfR5Lgc9gMd3q6GMldPKapxk8ePfaeUFArNYI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3JnESSX5UEsjbjWqmXAJ/ANO15o13BGwq6MgLCoSrvdEx1J6Z
	A/QhLfxYvD+Fu8LF+9RmW+7gzOMRfQhGdmPuPiydd1lgrrZ7j0sT2oTpy1QXW1lEmLj1Tbia9V0
	osNYN57FLwhtnUFtO8IfMvA9SvDTzRiaKET0Q59xXPBWGSZmy6cXA311pzg==
X-Gm-Gg: AY/fxX7cyBmDqRHtKTg18RD7PElHLXH3QtjkJCZKdJTinuK0siu+i3wC0RC4+FBYFgb
	TyDFt2DZfg6tkZyLdOyDztkmg18A965785uWb7Gn1h6CDjXr56B9eyA1rXmiDeCtwpvIZHNxMGf
	lcRNnvRu+KP3M233VDzosZda0QnXZSI1qauxq7pXqq1Kz240Er2WePhKO6eCrjlYYKYVu0aQnFP
	B+1RscDQA1xqBECoqEI0Aka07UU8rHgvIMKg62MYN6XrfIh7V6HMZc0EOPR2RbtnEkh4J2VdJfg
	MvdNpo7BfoJ0y1R76KCrepsmi2QxKjnI/P3apylmKqShCUJOkMc8JNsEcgi0uElEMcbUTelK6jw
	41lUEdmb4xu2ko9CAlqr6feceN4tAWI0x5ksOFkWzUP9UFoec2vy3Azc9nQ==
X-Received: by 2002:a05:6000:1845:b0:432:c0e6:cfcd with SMTP id ffacd0b85a97d-4356998af3emr255084f8f.22.1768499495802;
        Thu, 15 Jan 2026 09:51:35 -0800 (PST)
X-Received: by 2002:a05:6000:1845:b0:432:c0e6:cfcd with SMTP id ffacd0b85a97d-4356998af3emr255043f8f.22.1768499495216;
        Thu, 15 Jan 2026 09:51:35 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569926ffcsm355884f8f.18.2026.01.15.09.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 09:51:34 -0800 (PST)
Message-ID: <2b38fed6-dcd5-4ae7-8e46-4abec54ed82f@redhat.com>
Date: Thu, 15 Jan 2026 18:51:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
To: Andrew Jones <andrew.jones@linux.dev>, Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, maz@kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: awA1I9wU69JKEtfcVMTmaZrvw1k9dhC5CBZOuzOikWY_1768499496
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/15/26 6:40 PM, Andrew Jones wrote:
> On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
>> Hi all,
>>
>> This series is for adding support to running the kvm-unit-tests at EL2.
>>
>> Changes since v4[1]:
>> 	- changed env var to support EL2=1,y,Y
>> 	- replaced ifdef in selftest with test_exception_prep()
>>
>> Thanks,
>> Joey
>>
>> [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
>>
> Hi Joey,
>
> So this series doesn't appear to regress current tests, but it also
> doesn't seem to completely work. I noticed these issues when running
> with EL2=1 (there could be more):
>
>  - timer test times out
>  - all debug-bp fail
>  - all watchpoint received tests fail for debug-wp
>  - micro-bench hits the assert in gicv3_lpi_alloc_tables()
>    lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?
I tend to agree with Drew. Do we want new tests to be merged if they are
known to be failing?

Thanks

Eric
>
> Thanks,
> drew
>

