Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897CB125AB
	for <kvmarm@lists.linux.dev>; Thu, 23 Nov 2023 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BC3KbxyY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700721802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Y6v5Xhwln7tu/9zxftOsUtL05MptTTj1UHVhZFfC54=;
	b=BC3KbxyY1cqWZHExLgz5VzrUmHGWFze0yQzZNNjt96zxXpMgdGteh1fzFufC++tZZI2v7d
	MZI2Zr8baoMJcwtrvTWetFhx8RZ37zeV84zS+IbUn1mlzHwNM9DS4iSkd1SGutJmJDl0hM
	vYy1yOpDvSJyvYFeUQ5aYBA5HINYyOY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-Ebdj9aHrNuaT6-aVSVHBaA-1; Thu, 23 Nov 2023 01:43:20 -0500
X-MC-Unique: Ebdj9aHrNuaT6-aVSVHBaA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-28554978db1so166978a91.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 22:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700721799; x=1701326599;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y6v5Xhwln7tu/9zxftOsUtL05MptTTj1UHVhZFfC54=;
        b=Bqfa87Gyk5U6OVB7wczvON+X6/8jRx4rnmHJ10PKya0fE5GLbjbuRXgWqvLFnQOeS9
         /sC6aGverdjZQQBuFLhMXKLh9eu16cN2xM37K7foPvPh7hBZ98XcG5J4UWmef1XvMDCX
         ht9chRFqXLZeOLag34X3fftQ33H6aktKSMTW48MlPEhup8g6IOAhTkEf9tp6PhaK4sDW
         dqbw4al2tF+2pO0WIMmHYrd+BgT+zZOEYZ5P/E1Ia6IEBB99W0FMOaeO8nqv1bSnHvJg
         X+P4H3Htsn0qzw8FAzxfhTOkV/bPcydDetwRO7MMhkPhOcWpgWmKDQRt60JQB0cb+ea2
         fV1w==
X-Gm-Message-State: AOJu0Yz6KGg5sr72NBRNMNH/qHl/XeoPa/3IuIxA3sjZIixF1nTl4MoQ
	FIuBg+A2axQQwAoVu2scJ7OZYAJlNhySQW+F4AhwQXqe0vH1KNDirLKAmPqcB0iK78KpKvHSOTe
	8z59A1zxS+7cXBWy/
X-Received: by 2002:a17:902:d486:b0:1cc:3c2c:fa1a with SMTP id c6-20020a170902d48600b001cc3c2cfa1amr5191040plg.4.1700721799479;
        Wed, 22 Nov 2023 22:43:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqJ7t5K0G/lG65L6yMQON3n741jzN2NtB/hlBiB4j/kh7OASHj0JQgIsOvheK+O1VEnunV1Q==
X-Received: by 2002:a17:902:d486:b0:1cc:3c2c:fa1a with SMTP id c6-20020a170902d48600b001cc3c2cfa1amr5191028plg.4.1700721799075;
        Wed, 22 Nov 2023 22:43:19 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709027d8400b001c9d968563csm538754plm.79.2023.11.22.22.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 22:43:18 -0800 (PST)
Message-ID: <d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redhat.com>
Date: Thu, 23 Nov 2023 14:43:15 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: selftests: aarch64: Remove unused functions from
 vpmu test
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231122221526.2750966-1-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231122221526.2750966-1-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Raghavendra,

Those functions might be useful for other pmu tests. Recently I just 
wrote a pmu_event_filter_test[1] and use the enable_counter().

There may have more pmu tests which can use the helper functions, so I 
think we can keep it now. And in my series[1], I have moved them into 
the lib/ as the helper function.

[1]https://lore.kernel.org/all/20231123063750.2176250-1-shahuang@redhat.com/

Thanks,
Shaoqin

On 11/23/23 06:15, Raghavendra Rao Ananta wrote:
> vpmu_counter_access's disable_counter() carries a bug that disables
> all the counters that are enabled, instead of just the requested one.
> Fortunately, it's not an issue as there are no callers of it. Hence,
> instead of fixing it, remove the definition entirely.
> 
> Remove enable_counter() as it's unused as well.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   .../selftests/kvm/aarch64/vpmu_counter_access.c  | 16 ----------------
>   1 file changed, 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 5ea78986e665f..e2f0b720cbfcf 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -94,22 +94,6 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
>   	isb();
>   }
>   
> -static inline void enable_counter(int idx)
> -{
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenset_el0);
> -	isb();
> -}
> -
> -static inline void disable_counter(int idx)
> -{
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> -	isb();
> -}
> -
>   static void pmu_disable_reset(void)
>   {
>   	uint64_t pmcr = read_sysreg(pmcr_el0);

