Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30705D8E8
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 20:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HcHaiTeW"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35930447ae9so484535ab.2
        for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 12:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1700683725; x=1701288525; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vwn5XjAFVwzSFE87KSWGBC++RkG6QZotk9BZhXt0jBU=;
        b=HcHaiTeW6AGtvStumchh5Ayf++vOIxKv5jcmy0l+y64ZRwShiVUjvLbQH0biZyrx8F
         07AMpw05yIpofYNUnp+C7lNOx0e0IhkGujP8Mnsk+UHUYRkCk77KjUs6wSDMU5YmgZqi
         Cp/ENMPg/upBJNRJAwM+qrhgZVZMCQ6q41NKB9/TXBUKeX81EZ94KquPN4ptmbHdRZpr
         MZ3PCBolx+HjJKmygdJQgRw1p+E9bqYJOdmNNf+ZoIpzidDduaRALQ4HtxOoWsyXb7n/
         F66XV460WaUTLptcH3HcZakTwbol0989MuQo+mGRzS4wGoWCtIWYACveoEeUlm5hgyHz
         O42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700683725; x=1701288525;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vwn5XjAFVwzSFE87KSWGBC++RkG6QZotk9BZhXt0jBU=;
        b=TcMG3XjT32Eo/r/8bJKaut6dkzO4OjJI7C1F5SjbCdtHuKVmHKs+gQjn2m4GM+DoMt
         g045YxuNRS8z1jZBYaLO1ru0gDk7Y0f8Hmd+4Iu1K55zBUldS2Emvaw0nJHciAtEONd1
         l0vbU3L3hxNYBiuwD6NZWzDJHBx7oc/EU2kKs0atkq/WHWkWUoDt+3HdWUqCuM7nW+0K
         tFxIaR0XVBIi5ICVu20G3OzO8Bbfd0pCqeYR3YN1o6iRSK5+qM3QR7KKtTdnAdFs0LwK
         ygXa5B10ZaqHG1OflI+i4j5ZGEXnKzSmy/9wV/mGBgRYRRPW7bUp0HbjXmgAMvSxesmn
         6eAg==
X-Gm-Message-State: AOJu0YxNn3RX9EWsrE44sdEffxelHFXjJCr+h7j+AW3w2jZvyeQrgyib
	IhtF6SKuGS1cinsKikD3oYE9vA==
X-Google-Smtp-Source: AGHT+IF2qTlIhwVKEGQ0JFu0xT0lbRPaHgpkk1nP2LZCxYCZLDSL39dT1xuRlbmj8kzVW+/OEqRihw==
X-Received: by 2002:a05:6e02:1345:b0:359:8ddf:5319 with SMTP id k5-20020a056e02134500b003598ddf5319mr3302057ilr.26.1700683725117;
        Wed, 22 Nov 2023 12:08:45 -0800 (PST)
Received: from ?IPV6:2605:a601:adae:4500:3d43:c8e2:1496:e620? ([2605:a601:adae:4500:3d43:c8e2:1496:e620])
        by smtp.gmail.com with ESMTPSA id e7-20020a926907000000b0035acf801fe5sm100939ilc.64.2023.11.22.12.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 12:08:44 -0800 (PST)
Message-ID: <11b0d7cf-b136-454b-a624-d9247bcd2e31@sifive.com>
Date: Wed, 22 Nov 2023 14:08:43 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] riscv: convert to use arch_cpu_is_hotpluggable()
Content-Language: en-US
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com, James Morse <james.morse@arm.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org,
 linux-csky@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
References: <ZVyz/Ve5pPu8AWoA@shell.armlinux.org.uk>
 <E1r5R4L-00Ct0d-To@rmk-PC.armlinux.org.uk>
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <E1r5R4L-00Ct0d-To@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023-11-21 7:45 AM, Russell King (Oracle) wrote:
> Convert riscv to use the arch_cpu_is_hotpluggable() helper rather than
> arch_register_cpu().
> 
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  arch/riscv/kernel/setup.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Tested-by: Samuel Holland <samuel.holland@sifive.com> # On HiFive Unmatched

