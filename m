Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AD42063E8
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 07:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738655099; cv=none; b=m7oxbX0cEhDlCP6w6ZDy+tWuie7NAPpSH+Mu4DIJyQDrWbQ7NKM+tWH8+iEghachXJmLDpSSX2dYYkbLD80hNGfXORp6NeQdxss7F6sozTqnaZ2PtvTKL/6J8tXAuI4+X/8uuzmQ0Uys1ACltent6t+WeICWqz3F4/Vl2s4bEWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738655099; c=relaxed/simple;
	bh=a14rw0LIy/PyBG4bDSExLlTaMzdC9tbCktY6lF1hLIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XV/GSCsPELGPKmFFGPFBOuaevnVQO0bvSorr9tp1s904B+pmUujLvmP4OtAoztDaT1KBT0AlbOGOuOJGqlGDRCbTt4t92e3lyJ8ZVq5ijTJskFv3KCeqVxlfh9/t2BBaAEW29TQ00G030/nRkM4K2XBEnBX0cg5BIt894QTwhVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I6swGSxH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6swGSxH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738655095;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2QtEPy+qAYhHF6Zresos1Bfs4czVUmivuu05zxY4QM=;
	b=I6swGSxHrd6sDZppCVIiw3PQBb/Gp63YOfgH0dU1t+4VNOOvgznomAUsLNAnzif5E47OKw
	z3PGNVSL95mxdJuwQJclc+zK0REAF9+HOdwnpwmIsC4dFn6rx57164CYfk0ZGyJUC/VN7m
	SmotPXRFJxXqRY87kuPGRZOEeLfrWOc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-kaMe4w04OIKwsT2MC3w0UQ-1; Tue, 04 Feb 2025 02:44:54 -0500
X-MC-Unique: kaMe4w04OIKwsT2MC3w0UQ-1
X-Mimecast-MFC-AGG-ID: kaMe4w04OIKwsT2MC3w0UQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38c24cd6823so2642266f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Feb 2025 23:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738655093; x=1739259893;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2QtEPy+qAYhHF6Zresos1Bfs4czVUmivuu05zxY4QM=;
        b=d/zHzlymrNiTKSZQ13y0LkBwrVzYFvV/ye8gYjkCTl2dyp4HW5We8OgcJ+uivCaq37
         cmM1IKSOhm3qRBTNJCb5ixBHopSsOL6Wu7JR3m7BsqWY17S9Hd+3iSw6vSezbQLvSxPc
         WzabfMdORRj/t7jLSbAewPWFg1x227QfK0ARhSgLtW/MAWR7XdwnXw3zSUKeN4Z4PqPB
         va28s1uNKxfQnVcwrMD/vdq8aAkgLISKvPpSS980DDBvY782iNKOTp1NokAaX2/Z7ySI
         Gf8PKYC/JgHQgaYOmFEYn/Hv6EElz3INogkrxGrBPM/MAXSwh9OCE9MtjKH35XyoKmEh
         pYSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyhsB79s0hKWtbGopHJwlqnJLY+wp/ufnBDVqjkxvm5ZgvOieQ78H7cX9FMRZFveloO+pPd/A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+gsuvKTXoDVN+/GS2GQiBAKjQQTaScUiGW9qvaEdOc2m9FLSo
	8HThR0cjBe4Xid28eCiESjdNCH0jqN5TR5vmXa7bAwEXi4ZLGcquO+18ZYZpqSSPqfejlu/w14c
	0BlBGmfb4xgC+EkuZ+sjPfrthlcavKcR22yS7lMjed96JblqzZRp0+Q==
X-Gm-Gg: ASbGncu7CHXkES0H60NZR5W7cIsUzV8kKkCY48KeYiuZ5gpwu921cZWQ4s2+0jRm0v+
	BjGDgNTvBIMoamF5LqJL0fGh/4QL3YYpezZordNBmA+GSptQfOzcB7F7j6YXjuS5WoYmCT/QHpV
	zI7uK+U8FDWvz2WmhMghW4bykGS+9MmwG6ADbRlBkYjzIJPJFijTfYEKPH8MPyfwSfEw7timOH8
	5qz1+nbOaPZFFv6BzNaMmKhnofO2P0F83Cu6aFHNeqFjG1USjgKoSz2x9QLE7InJupCWrUDTIpE
	1F4ApCTBgSKOrBg8Pow9SnQm7daPDa+ClqhE66D8KLEk20sTNDQn
X-Received: by 2002:a05:6000:1fa6:b0:385:df17:2148 with SMTP id ffacd0b85a97d-38da53da590mr1660239f8f.20.1738655093277;
        Mon, 03 Feb 2025 23:44:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECJI3XsUYM4TaIUzBOg44CtHjQ1FHzzLGnEbKrdjBkjypV2jsCCvk+eKb0HnE9hjdbm4Ni7w==
X-Received: by 2002:a05:6000:1fa6:b0:385:df17:2148 with SMTP id ffacd0b85a97d-38da53da590mr1660222f8f.20.1738655092955;
        Mon, 03 Feb 2025 23:44:52 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1b5492sm15063176f8f.73.2025.02.03.23.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 23:44:52 -0800 (PST)
Message-ID: <a5aa72eb-ea7a-4a13-8312-93ff3184045d@redhat.com>
Date: Tue, 4 Feb 2025 08:44:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Actually use counter 0 in
 test_event_counter_config()
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20250203181026.159721-1-oliver.upton@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250203181026.159721-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HPvWUR3WAMi7G4-DONoS58Uv1R68AZy-DGzTB0njzV0_1738655093
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,


On 2/3/25 7:10 PM, Oliver Upton wrote:
> test_event_counter_config() checks that there is at least one event
> counter but mistakenly uses counter 1 for part of the test.
>
> Most implementations have more than a single event counter which is
> probably why this went unnoticed. However, due to limitations of the
> underlying hardware, KVM's PMUv3 emulation on Apple silicon can only
> provide 1 event counter.
>
> Consistenly use counter 0 throughout the test, matching the precondition
> and allowing the test to pass on Apple parts.
>
> Cc: Eric Auger <eric.auger@redhat.com>
> Fixes: 4ce2a804 ("arm: pmu: Basic event counter Tests")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 9ff7a301..2dc0822b 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -396,13 +396,13 @@ static void test_event_counter_config(void)
>  	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
>  	 * select counter 0
>  	 */
> -	write_sysreg(1, PMSELR_EL0);
> +	write_sysreg(0, PMSELR_EL0);
>  	/* program this counter to count unsupported event */
>  	write_sysreg(0xEA, PMXEVTYPER_EL0);
>  	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
> -	report((read_regn_el0(pmevtyper, 1) & 0xFFF) == 0xEA,
> +	report((read_regn_el0(pmevtyper, 0) & 0xFFF) == 0xEA,
>  		"PMESELR/PMXEVTYPER/PMEVTYPERn");
> -	report((read_regn_el0(pmevcntr, 1) == 0xdeadbeef),
> +	report((read_regn_el0(pmevcntr, 0) == 0xdeadbeef),
>  		"PMESELR/PMXEVCNTR/PMEVCNTRn");
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thank you for noticing and fixing that

Eric
>  
>  	/* try to configure an unsupported event within the range [0x0, 0x3F] */
>
> base-commit: 1f08a91a41402b0e032ecce8ed1b5952cbfca0ea

