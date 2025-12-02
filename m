Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D87305E2F
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764666679; cv=none; b=jt6R6iAqvtBP08t/7nkESFQ34Iz6pmFF1y0l2Oz1apAgToQz0EP0QPUomXUwldD1UVp1KWEwgygSWh3QjJvuKcg2kxoIrBckkGyNXWvQxxeqztFHSvPWOZTO3lk1G9CZl1Cvgj4IparXsDvg4iu4DxIkKMjjD8oWYm+V4GT8nNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764666679; c=relaxed/simple;
	bh=uEfWvdp/iNY3eVhyQwnpTZp1TCHiSYDNB1SzG6GyEXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7L/+AiwuVOTxVJjWMPIQjxLtqBmQlUWz4ddZ7a7u6vLfhui3iciJC+s8JSZsoD9nghfZAp8bZNLttzfG2b/g9oPdhd2Ip0pA6HDpn9/OtHxLlqEXEpaLq2skkoeho2DuBCvVbn2k/U/GXQbsB67/13qjT6+tKoFW8I3jvX8lhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J15yPhDE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J15yPhDE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764666675;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+N3hLgGvGZH88LHMoSGzIAzbnAcNoGeilZxl6S9qyw=;
	b=J15yPhDE8Xqvuxk6S+Owep//EXayx0rduo4TqU4d4jd0+WocY6vZP8Oj1pmdKuK0r2XBFj
	hHne3TqwUhtwUS60GQ1umiHaWKVTpHAt7rl/+PTeRSL1rsXMvg6NFsKuK1l5hiaCte7c4m
	7psyhLD+5XW0PKsxJP4yPVWyr9bMFbc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-eDHSzp59NqC6bt0Z38EFww-1; Tue, 02 Dec 2025 04:11:14 -0500
X-MC-Unique: eDHSzp59NqC6bt0Z38EFww-1
X-Mimecast-MFC-AGG-ID: eDHSzp59NqC6bt0Z38EFww_1764666673
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8823f71756dso62585576d6.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:11:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764666673; x=1765271473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+N3hLgGvGZH88LHMoSGzIAzbnAcNoGeilZxl6S9qyw=;
        b=c5gZcfgcKADx1FwGUAqxr9H+Fz9xOTxyoNWkkLQOrgfR0JKADLjcqLjDNLI/bTR1ut
         bxoUubVtRIejdHiyrcC6dz5HJCwNN4gg7Ft8UUcHXzssxebLWtt/BMsOrWyBcHbZLlwE
         VUsCYqFNGVI7OGP7hFi/yIJt1LpoiM1MAGmJS0yrpQgUjQ4IvrLKxmthR9DNgZlkpz8c
         ecD35hNX/qJtHS4Y/zuEJCIu9uVzYsRsTkE2siByor3eHjv5IDTDjWcscedxCiKogz4C
         RMdPr0t5Wc7zDfUQX3j3orTJKVyO73jcCdLc6+UuQ3ReRPk8Uxon0cdvpTanlC0E/JaX
         qLWA==
X-Forwarded-Encrypted: i=1; AJvYcCWu5dmCW5XQNPx9yIpA5kg0QQX7VUPo9HkPeN9UhWy6ThiXCUWH+7fWlxed1/fw3yFFp418rE8=@lists.linux.dev
X-Gm-Message-State: AOJu0YypEdbmSkYJKGWVS7qlIwsSZrC8jnnKEHMzsZm+FfxsjtVrnZCr
	lX6MGNfgav0LxHez3AbeghHVqhxHwiH9i7C7R5BXX3DpRZMYD+MUhceYodNwweShzAfsswGTi0q
	mKy+NST251Wyzpxa1ACgV1UcVXPBjmKz6WqR7KciO4YXP7fb1swohlFfDsw==
X-Gm-Gg: ASbGnctu3NbO4c7YzM/kXe7FS0EzbEn8ErJ8vKFcmZr9bUcat65GI6XdZWIK2Fhv5je
	cNXCtfl5fng+eEZ0FdhyByRQ0sgwcea6ULirXzuHz360Mw88f/5L8zQMQHFy936tUqsF2iq+qLT
	hJov1kK506SRzEGTRhht95Wp4Hf/J7E9CJpcNE8ibnCgHpYYduixoXdJd5VDJqq8Ox9yE1bt5sW
	rUtTj6DLOxpx4qVe4Bz/nEU9RnSvVFHNXimIh9AALKrDM9MXWas/V95tbAorIhZ7C0xZy0DPPsG
	a3hmuapgUptOdQoROkM17yAWPsgnHe9M+uzSp9fGR4WXLXb/e2h0KfKwJJAb6GFS0lDgnpjPHAV
	9xPH2cb90qXtTYAOOHqZAyKsW08RNHXS8g0HMAL1PTqIXCwGJLirgRr+eog==
X-Received: by 2002:a05:6214:3905:b0:87d:e456:4786 with SMTP id 6a1803df08f44-8863aff2e7cmr464855046d6.45.1764666673326;
        Tue, 02 Dec 2025 01:11:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgomIk+Tt7VTAgUyOjLDgRSqbCIrSqPRdj1txKlLHoPERXK/vVkPh/c6XqIxIl+6h2XLJjMQ==
X-Received: by 2002:a05:6214:3905:b0:87d:e456:4786 with SMTP id 6a1803df08f44-8863aff2e7cmr464854726d6.45.1764666672896;
        Tue, 02 Dec 2025 01:11:12 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524af138sm102423366d6.3.2025.12.02.01.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 01:11:12 -0800 (PST)
Message-ID: <7c8e87c2-6b73-4713-a58d-09c6a2038ffd@redhat.com>
Date: Tue, 2 Dec 2025 10:11:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 06/10] arm64: micro-bench: use smc when
 at EL2
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-7-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-7-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9KdnaD9u5idc-Nm2QQe0vGcD3JeWX41L2DKZW1SkNC4_1764666673
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> At EL2, hvc would target the current EL, use smc so that it targets EL3.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index f47c5fc1..32029c5a 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -282,6 +282,11 @@ static bool mmio_read_user_prep(void)
>  	return true;
>  }
>  
> +static void smc_exec(void)
> +{
> +       asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
> +}
> +
>  static void mmio_read_user_exec(void)
>  {
>  	readl(userspace_emulated_addr);
> @@ -300,6 +305,8 @@ static void eoi_exec(void)
>  	write_eoir(spurious_id);
>  }
>  
> +static bool exec_select(void);
> +
>  struct exit_test {
>  	const char *name;
>  	bool (*prep)(void);
> @@ -310,7 +317,7 @@ struct exit_test {
>  };
>  
>  static struct exit_test tests[] = {
> -	{"hvc",			NULL,			hvc_exec,		NULL,		65536,		true},
> +	{"hyp_call",		exec_select,		hvc_exec,		NULL,		65536,		true},
>  	{"mmio_read_user",	mmio_read_user_prep,	mmio_read_user_exec,	NULL,		65536,		true},
>  	{"mmio_read_vgic",	NULL,			mmio_read_vgic_exec,	NULL,		65536,		true},
>  	{"eoi",			NULL,			eoi_exec,		NULL,		65536,		true},
> @@ -320,6 +327,15 @@ static struct exit_test tests[] = {
>  	{"timer_10ms",		timer_prep,		timer_exec,		timer_post,	256,		true},
>  };
>  
> +static bool exec_select(void)
> +{
> +       if (current_level() == CurrentEL_EL2)
> +               tests[0].exec = &smc_exec;
> +       else
> +               tests[0].exec = &hvc_exec;
> +        return true;
> +}
> +
>  struct ns_time {
>  	uint64_t ns;
>  	uint64_t ns_frac;

