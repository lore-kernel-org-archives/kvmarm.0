Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFA4F4D1C
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782061; cv=none; b=KhGj/kMJMbiVsCKJEaqxylM9T8n2Q7QNW/c7A8/oL/fn+lFcO+Bm/wPPn7XlvVrLqqpgMinwJX2YP7eoTNwPdRQb27fSrS3m6mDBHlItOem8xNfskYmeYovyrLY8NhIuTK7XK7qm3dtq8kwQdI0GvqYdvARRygTNcTU0zz4PP78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782061; c=relaxed/simple;
	bh=0s/Gn6TxRqE+ma6MSeiSWHaaSkW4KWvpR2ed33nhSXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nUePN0wBg341w4RrjjKkH19MzsLIzYU4heJKpmK+NrMYPnkqDlqDrVZpDwG0CpQ37WEBENHNMMLafHxu/UNrMq79JbXr+KqME20CTOkiny1jVa5WA8eCJcQU6oYU4BtCAxLpM9tj23gFpo4VX258BkalooYWEX1SjEKse/swCNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I4USGVlq; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I4USGVlq"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e028ed54dso240088666b.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790782050; x=1791386850; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m8/ka+J/ZNQmE2G5JtUp2jlHYt7CIUXWsqK/1+vFYBc=;
        b=I4USGVlq0mwa57dJLQDJ6T1ZT6qFUxvgK6jcvA5/KvSuX7gEpG8NteJWLzAUfLuA+v
         sX8BTfpGhzZUR6m0hfRJ3GXGoIldryjTq8g4FaFWUU07LE5HoaIOTNB/Guy3X3uSLO/h
         mcQm0BXfnKQZjtJuPyF/Nl29Pdeu78wT6QANf3HKxUfmNI4Kau4mVhXf5O776TbWTUra
         14dRL17SZqHNJkUlEB6P9YmixiMfDEZD6wBXYUoA7sj7IieaaVp0tilgDlnBQN2l2DkE
         fy9Gq2i59lA2xw8DXv4+tbg2yQptWXSZa9azW/tDBVfO6cRFTClPgt3bNZbt9krym6li
         566g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782050; x=1791386850;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m8/ka+J/ZNQmE2G5JtUp2jlHYt7CIUXWsqK/1+vFYBc=;
        b=utB2PNAKf1CoWLeTodhDDzWGO9as12AldJOL+quGjELtaMFa/HbjcnmvyCdf8DPdhL
         +rQ5DaYVS00yrTL43pZSA/2zIViF5M8ukLsK5cH83xL8CvlqY5k+UWKV6s+6tpZJT4up
         p8ayuyfMNaOghC7Wpke5xV57XaByiTzWcBsURuFfL+2JXLj9bq/TfY+fPA4Z1LmNWHPK
         g2njGvLkS7QFTVOh1VNGHI09KgZVw5neO/cZj2NLapylNI9wgEXsQn2ml3yLadLvthMM
         E3YD/Zv4MPK92VBcWRyucE1LQ6CcMk2Wu/4herTJ53PHZLIITPd1wqyhx13HJDpvaURJ
         +MEA==
X-Forwarded-Encrypted: i=1; AKwUvBwlDnQ6xfHwmjUzhWVLSQ/Qo33wiOTIbVgttjDCTqcHA3c7Dn3XoIv1WHGLKR5+Hrp9NAmw7/s=@lists.linux.dev
X-Gm-Message-State: AFuF++mRogRGqtEVJJKed7W13GETi3EPLfax535GCSFZhP2EzH3lpaAi
	6M+FB+4T4JNZlOX6mJ9C/rD4GHdFo84wwNqW3hMLzM8lQmS2X23oJrcrFITF8f/hgzg=
X-Gm-Gg: AYBFou301shZlP/s7MbtEn6m3EaS4v2nuBkorUSjVWsoeGHjHmnfGDZLcDP4r7pz+rs
	2gh55YE/p9hY6/tlPF9XaMkaIS/BAeCPdzS/FFFe9LliFwpOhHjj9sNL8Q36/8WzARO4i90RZF9
	B5JWWb+2UNQwrD5EQsFyx82QiMzTHtAkZT0cpeT8nVfFzK62grlmGSeHqfJ4v+xNITTZPgtQDzn
	CflbRa/qPj9LjCpR/8Jv9VXDxitZVrvdTtB3LCWlReIMb86Gidsv8i+xsvdzrwyk2Fni3/NZv8d
	6an4xRGuhciNp0joUcea2gnrKUb0Swzaklu9btWbWsUrPMUMrFEwzgwR5eWY4Y+AYpYnm2Yhfhn
	L9PcXYx8mQrkuwS6wE1n/01p1uUYbuYBusqyAUImKBAZ/UDDOsGBVrloQg4wuV4C7UcYEoCHZVY
	elj0Xywdb4EZkDvG8t2KjPFpnYSeN9pMM8LwGhsTn5emSTsv8Xhicb0zV24i8lK8gdmEFajxoZT
	aU=
X-Received: by 2002:a17:907:e002:20b0:c2d:ca32:2176 with SMTP id a640c23a62f3a-c2e23be61f9mr114745266b.8.1790782049863;
        Wed, 30 Sep 2026 08:27:29 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31a3eb32sm28640766b.3.2026.09.30.08.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 08:27:29 -0700 (PDT)
Message-ID: <56d86280-fcea-4d2d-b6b9-b47449f3408d@linaro.org>
Date: Wed, 30 Sep 2026 16:27:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/22] KVM: arm64: Add vCPU device attr to partition
 the PMU
To: Colton Lewis <coltonlewis@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Zide Chen <zide.chen@intel.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Mingwei Zhang <mizhang@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-21-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260924172928.2110956-21-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 24/09/2026 18:29, Colton Lewis wrote:
> Add the KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION vCPU device attribute to
> enable a Partitioned PMU for a VM where PMUv3 and VHE are supported.
> 
> When partitioning is enabled (tracked via
> KVM_ARCH_FLAG_PARTITION_PMU_ENABLED), userspace must explicitly
> configure the number of guest event counters via
> KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS with a value strictly less than the
> maximum number of general-purpose counters implemented by the PMU (or
> 0 only when FEAT_HPMN0 is supported), leaving at least one
> general-purpose counter reserved for host profiling prior to calling
> KVM_ARM_VCPU_PMU_V3_INIT.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   Documentation/virt/kvm/devices/vcpu.rst | 42 ++++++++++++++-
>   arch/arm64/include/asm/kvm_host.h       |  1 +
>   arch/arm64/include/uapi/asm/kvm.h       |  2 +
>   arch/arm64/kvm/pmu.c                    | 71 ++++++++++++++++++++++++-
>   arch/arm64/kvm/sys_regs.c               |  5 +-
>   5 files changed, 118 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index deb5c51bc00c8..fb5921ed9dea2 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -57,6 +57,9 @@ Returns:
>                     hardware PMU, or interrupt number not set (non-GICv5
>                     guests, only)
>   	 -EBUSY   PMUv3 already initialized
> +	 -EINVAL  Partitioning enabled without explicitly configuring
> +		  fewer than max_counters via
> +		  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
>   	 =======  ======================================================
>   
>   Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
> @@ -162,7 +165,8 @@ the cpu field to the processor id.
>   	 -EFAULT  Error accessing the value pointed to by addr
>   	 -ENODEV  PMUv3 not supported or GIC not initialized
>   	 -EINVAL  No PMUv3 explicitly selected, or value of N out of
> -	 	  range
> +	 	  range (or N >= max_counters when partitioning is
> +		  enabled)

"No PMUv3 explicitly selected, or value of N > max_counters, or N > 
max_counters - 1 when partitioning is enabled".

That might be clearer, otherwise it seems like max_counters being 
relevant to "out of range" only applies to when partitioning is enabled, 
not that it's max_counters all the time but one is -1.

