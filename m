Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDD5210A
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695009999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RyEnCFT5C38bhUURLkGzvUajSXRR1/fSXXPcrqWJ/i0=;
	b=Sx38KtqaNLgedsFfbIOY//4AFSkSAAWhG2kIPULbdOvkEWUHgkWHlWpNt/7EeGiDf3AY37
	iyV1P56pM4BW/c8wZgSAwQToP7oa+9fzqjZkJP8dq9aRlrZ37ZkD2Ea1iRbl5TgGAvbr1O
	U/N00cyNvYPRYFsSS16Tmjd+OdiyG30=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-gewx21zmPBWksQcM00iB3Q-1; Mon, 18 Sep 2023 00:06:38 -0400
X-MC-Unique: gewx21zmPBWksQcM00iB3Q-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-570096d89b1so2710397a12.3
        for <kvmarm@lists.linux.dev>; Sun, 17 Sep 2023 21:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695009997; x=1695614797;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RyEnCFT5C38bhUURLkGzvUajSXRR1/fSXXPcrqWJ/i0=;
        b=aArwcYeOjCXG3bljK40Ny/T/wujgWN4KC+YrvjqfamSmC+69cey3975RX01pQWeNIU
         ZWuMyXX3Cd9LR30JjyxngWN3Uewcm+UK+R62YRvsoU/eOK5mASCn1Iprc5sybBL0s8F4
         vblyGuqH5FuumotlYUi67572/VOFh8aKDLD2F4YMjMCyBM5h4XWfcpiSfNazMJBT9FVy
         Alrs3022/tt2IPcja9YKw24D+T7RpGkfySSsXjvYs9TLyB+tU6noolIPIraI1V/GEPy4
         DgAIrj8TooF5cIGqy7B2Jze7JYlE7nG7nYYqqluBOScwjBCYnjuW2GM2SBw2SYPi0tm1
         1FKA==
X-Gm-Message-State: AOJu0YwouM27AlXVx1IL+JCklLb4bMsHUFMBxoAng5itmjcdmkAi5bFM
	JUIBMEVrGpcVTikR7RaZhDVJlUQShmNuu8yYiI/MXW3Mrc/Eu5cCwNJa5vuT9iIa3FTmOugLMQl
	PUXQ8ryqGijLBUq9i
X-Received: by 2002:a17:902:ed13:b0:1c4:2639:fcac with SMTP id b19-20020a170902ed1300b001c42639fcacmr6826559pld.44.1695009997185;
        Sun, 17 Sep 2023 21:06:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF065/Z94SfXDjWgy8eNRhRV8ONjtcc1kg9eJW1xxYmQI4hKUxuHGFuBMDdEioAhl0IB04WA==
X-Received: by 2002:a17:902:ed13:b0:1c4:2639:fcac with SMTP id b19-20020a170902ed1300b001c42639fcacmr6826541pld.44.1695009996903;
        Sun, 17 Sep 2023 21:06:36 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id ju3-20020a170903428300b001bdb8c0b578sm5892366plb.192.2023.09.17.21.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 21:06:36 -0700 (PDT)
Message-ID: <4e5aaed1-bf7d-18a8-0f77-8f29bb2e43bc@redhat.com>
Date: Mon, 18 Sep 2023 14:06:28 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 12/35] ACPI: Use the acpi_device_is_present()
 helper in more places
To: James Morse <james.morse@arm.com>, linux-pm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: x86@kernel.org, Salil Mehta <salil.mehta@huawei.com>,
 Russell King <linux@armlinux.org.uk>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-13-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-13-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/23 02:38, James Morse wrote:
> acpi_device_is_present() checks the present or functional bits
> from the cached copy of _STA.
> 
> A few places open-code this check. Use the helper instead to
> improve readability.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/scan.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 691d4b7686ee..ed01e19514ef 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -304,7 +304,7 @@ static int acpi_scan_device_check(struct acpi_device *adev)
>   	int error;
>   
>   	acpi_bus_get_status(adev);
> -	if (adev->status.present || adev->status.functional) {
> +	if (acpi_device_is_present(adev)) {
>   		/*
>   		 * This function is only called for device objects for which
>   		 * matching scan handlers exist.  The only situation in which
> @@ -338,7 +338,7 @@ static int acpi_scan_bus_check(struct acpi_device *adev, void *not_used)
>   	int error;
>   
>   	acpi_bus_get_status(adev);
> -	if (!(adev->status.present || adev->status.functional)) {
> +	if (!acpi_device_is_present(adev)) {
>   		acpi_scan_device_not_present(adev);
>   		return 0;
>   	}

