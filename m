Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B46A4F5DFE
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782000; cv=none; b=A4v/avWXiqJBIGRs7HAXY0y8cx6lJDpTdr5DY0XP/yb3ahMoF/c2v491ZuV6oTho2GWT7bLooEaFQEBAxYo1+1mTH0ei95TdkzYjDV/KXmzacxCoxiH6TtS4KMXYvEI1lXd5k3qhvzzpnPvZygQ2Hjzb0/Jctpbihi4PINwxO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782000; c=relaxed/simple;
	bh=CmJey6zW6gZQHUwSRtJfbdEySzFFefHFLUZjWb5UfHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3M6UQ2xLJ3W6xJHZnb9y4hz5iwu7hfba3PKdfekwv8RnfXHmUoorN5ygXwC7WLO76S+4UcGX3EqtDIvg7rnZTxwFxcLxODpV4TRXwwP6poMwPLtEEieZrIO4u2hLCJf3ZoOwP94ovdrKFjS5j8X66gBZk6kffR2RyMeQyNtZ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eQ+qAK9H; arc=none smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eQ+qAK9H"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac768bda6aso5814733a12.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1790781986; x=1791386786; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jTz7JFysavVzx+3a8DoDd2wDpfretAnN3j2Hpag3BAM=;
        b=eQ+qAK9HlwGJLuYrGoWYdZv+z656mj0EeF9KxW2FjGgc7QygdlTCmmlJRXvpJcu77E
         UwfnA6VfrC8SNxJn7b3orC/kXxCoLEcarTVbVzFkoEBGiSpvQ36lOujLyCzaC+d3/GSS
         mywptenvqOF6NvPEYcY99DdtGzfaIn9Gq1qeH6HyA3rqi6dbKQSLvNao4O/bH7ScHdH6
         2Sq8W2rsiU4ZWYesEVrx8zWneBgNRHrN+UdNVvIIKuqiJcStlxJEKGb9qaJbNSRF4XUW
         nGE5Oz7xS99WbGc6+A0eR+PgnyEbfaCLAOnNNhjvYvQvvSDfSelglQhGs+hCJMi+u5Hu
         KEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781986; x=1791386786;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jTz7JFysavVzx+3a8DoDd2wDpfretAnN3j2Hpag3BAM=;
        b=b0YE4BGXoqG3J6Jlgjs5+ToBxQRPKj36Ppiv25nZcMDu12bzS+kofTCslPuQwyIRuh
         fBgXpmTz+V9CzBNZhLqfAhEXEW9HdBq7lit290z8itw5/LKmcJ+yAXGLFZqsW5VEp0+y
         3YnOaguLh9OW9k0MWMGSMw7ouaW4XWQva2c5K+OMMprCyJ/bD9240Xbb4DB/wNW/C/Y2
         PTtWysY6J9ST/8ygJU65/Zc89xzlbQ8qpWsEL/5qZwrL6jS1EtjjA2GIlsOPo4/ItNzX
         Nq5WP5Ve2CNx5NmYw+K4UcFHk54bowncresmsBAeNW/kt/ANUKvxO1ZaS2cEgvMh7zYw
         EyVg==
X-Forwarded-Encrypted: i=1; AKwUvBxwz/OBFZyBPFDLI5hZc9f0NJf6Av6XU0deVGIPpSEtz+DXeIFCr6C41+tcHRLArKDhVrsVjNI=@lists.linux.dev
X-Gm-Message-State: AFq9FYJr13/lN1EwYNVvHlwUXE/yplJdtiElFAec9+sfob2q74gCxEhj
	5YcJ6NZN2RVx7++I+nX0hJ1NL6TX5oXY3Y30TeVf1s3axnuhI8MYw3qTLa9afY8SraI=
X-Gm-Gg: AYBFou2DSW5lm5ZfVEOrKEwrvbLxzaAWmNFz0yBkktYZLJIJoBaXHFCp8vQZNNpbflp
	LcFF0G4aQ+dtV/3iAoqMQ/bGQaPShdf8NQZZww0FhRMfGXe7uwnHy7uXiniakTQcSyW+DqSBqm9
	uYU8oxRVgcZuDH/ZOdEmb0MHFAluWau/AuLFD7kH90rcnFkWq9VScbsXmKde5tXNzObLAPc8num
	OdAvcvYb4wjKBMMybhYn8e0qBdKd+/Q1Uv8ctnXAStqrpTnjzdA41ZmsSqD/DiFINoRubtjDrBK
	1vNBROavtmygpinIFhJFryDqf3xUW8LouIJ/JBSTQiZ4PfSMeILem1kG0AIwG6oD3JWMXTp1a32
	BPEb6XiUfyj13E9vs6wsGSi13fZ4D7reTVjGkcLUPCEOdGZGAXoB8USTWtdLRu+Y3jFCEHcCLXT
	w9xc92Hm8NaXEF1f4pXFAT7p/jUqJoCYjI9mtxFJc3wJSDSzREletFnTnvI8VfY6/Vds/XYH9/B
	Dw=
X-Received: by 2002:a05:6402:46d0:b0:6aa:f187:26b8 with SMTP id 4fb4d7f45d1cf-6ae1994fe10mr1077601a12.37.1790781985959;
        Wed, 30 Sep 2026 08:26:25 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae1568e8b2sm954439a12.19.2026.09.30.08.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 08:26:25 -0700 (PDT)
Message-ID: <5750151d-cb99-4f9d-b469-12a7b7796985@linaro.org>
Date: Wed, 30 Sep 2026 16:26:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/22] ARM64 PMU Partitioning
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
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 24/09/2026 18:29, Colton Lewis wrote:
> This series creates a new PMU scheme on ARM, a partitioned PMU that
> allows reserving a subset of counters for more direct guest access,
> significantly reducing overhead. More details, including performance
> benchmarks, can be read in the v1 cover letter linked below.
> 
> There is no longer a kernel command line parameter
> (`arm_pmuv3.reserved_host_counters`); PMU partitioning is now completely
> controlled via the KVM API using `KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION`
> and `KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS` vCPU device attributes. When

As far as I know there isn't a straightforward way to get the number of 
hw counters from userspace. You have to either parse dmesg or attempt to 
open incrementally more counters in a group until it fails.

This makes doing things like "use all counters for guest" or "reserve 
two for the host" difficult. Maybe it's time to add a file to the PMU 
that userspace can use query this.

