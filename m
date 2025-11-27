Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5DF315D5B
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764239705; cv=none; b=mhU+iP+DxRDcYNITRLoRcH5ugTwN4hdLfPKsWUfOKbZH10CuRo21FrCVb6bASgszTJ5X4piPsEE0KuiG1q0i0xAEo6hgyBKnPPw6sVDj2qO0vCldt/Zln1W113Vhp869KJEacWKiiyA4B3fWnnPzQpC6z5dpiM8z0iXw8XuuQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764239705; c=relaxed/simple;
	bh=DpiI8GgMDHD1LVQiscwaq9jAgParWgWZMDwjFqItjQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYxjBKkw3aCMXCQHsa1ylQE5094BewMQFU8y0+QS8rQoXbiQn4c9n09Aa8m4wa1h2KRJmM0nwBu4nSXp2F8PccfQHZTzu5inRs5mDI+XaIB/pWo8xvKaTWJ5fp2qTQajiLv7LkpQzeMmEZmCNC1D9Z307Aoragts+rP9/atIQV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxGZefJg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxGZefJg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764239702;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tiBBX2HMY2n/AxbltWad/ANX3RKH0tf+SEsscaE7SL0=;
	b=TxGZefJg0l9wxcHwI+W7ioFed2CQXLvf6ReDSu3dflMQAlz87bETyDZ/uwJ9pbeOnarEdg
	ZCrii1UeTNKno/Oqn/Wq6Fy8cOFozboup6CyR4YN1B1uFY10HJt1KOruQpP5/03JnhLGSe
	L0Um/gc/dHlkBN7NMu0VPT9CE3lGh28=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-eFWQ2w_YMuaaIc9R19-4Xg-1; Thu, 27 Nov 2025 05:35:00 -0500
X-MC-Unique: eFWQ2w_YMuaaIc9R19-4Xg-1
X-Mimecast-MFC-AGG-ID: eFWQ2w_YMuaaIc9R19-4Xg_1764239700
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8823a371984so9853496d6.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 02:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764239700; x=1764844500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiBBX2HMY2n/AxbltWad/ANX3RKH0tf+SEsscaE7SL0=;
        b=ZtfIwQF40z41HgJ/j1aGX7kYDs23qCKiaIlulp2ACAdTkx7u+ccLSuDZoFlQpZ7C2K
         xnH5KLumv/zbw7WgWXpmBX4pNA0VECWV1HWh0osdFo4I8zWaql3QJWHN4y7rdnrxXL8N
         r2WjhCliFscrOnUEB0u6U0CCyY/YdZ+B7gjZE4NUse16pvifoLBEL691E2jBS0DGKr9u
         yYqr1TL68d8kM69YrtVafPr77dchJmb0F1R5csnGEZxMkS6x2Iaiwu7Q9F5e1clR4TPC
         mYj9hGUxeD5qZ1KJadzE/0fw8vMOx2wQ40gi819mkymkLqC5ZIYqUrC4CN/8F4VU9f9X
         kKeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUaPqgPZNXDffn2fc4r8TGyDHAkUyiqIfEq7EzxHr8R9paSpoNAu0AAaLTwLX8ahM+iGJIEE8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3oJY2MO36xnklWlNSLE+BiV1q9nys5FV4Rkyn+JSqa2M5TPdV
	BoTwBcdx6v4VBdlS9CiFSqBlj6fdtq7buHlhVoTe4dWXtPjpSGpAB3/2tMrJEXwXLhYZIEG+mk/
	v0bFHar/wi9vGWem++jse6/uptTht68qiuvkdBCE66NaEZtcCk8L6DwKlTGMZHDdUhw==
X-Gm-Gg: ASbGncv/uyIAKr6qZL2X9y6ZO0rlO2rbpa7rFHjNKLcvNeGsSj1Tz+lZZ8xTvj5Y8BU
	9gDB/l8JyY5TId0B9CbQJrqeW5khwq0cEO2fYcef1Ap7utONFc684rytV54TXxJH67HoIGudZP9
	OfzsuE3guSTShuGUSKWk7WJVzWea/8OH0LriYZfqXW42CczNxHtgADhnXSOYdfynIQOeA096qvF
	8qJXVimssgyUOUkn9uUWLOpmqOJM5lAf2ziKUAtjFvBWk0aCRgypJjU6t/kTPv5+vGt7cm2gyRV
	EH+BVNOomn+OgMzIXZt/3Rlc9fH0SSWuB31gLzWiEy9+uVqGcld34jm4Za+a+NXS+Djbwoo2p3S
	j5lUzqyTh2hxk7XiRMWEgyRiP4flN8XAMXUxqDbtNQ2bf2yXVoS42fUrBYw==
X-Received: by 2002:ad4:4eeb:0:b0:880:447d:407c with SMTP id 6a1803df08f44-8847c4d5850mr321245636d6.9.1764239699726;
        Thu, 27 Nov 2025 02:34:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IENQI5eX5Oevifu0hA7wSdkD485RV3dcludhFKndd5LnRSAV5DrFbgSaQBSwuSBHJCvcKCXCg==
X-Received: by 2002:ad4:4eeb:0:b0:880:447d:407c with SMTP id 6a1803df08f44-8847c4d5850mr321245286d6.9.1764239699383;
        Thu, 27 Nov 2025 02:34:59 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b4ac25sm6980896d6.28.2025.11.27.02.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 02:34:58 -0800 (PST)
Message-ID: <6e735f02-dbd6-4807-95b3-4043049d4557@redhat.com>
Date: Thu, 27 Nov 2025 11:34:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment
 variable
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-11-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-11-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bbutHuG-o690B0yBrgdPUKwfc94Lx2PruV28Cf5JSrk_1764239700
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> This variable when set to 1 will cause QEMU/kvmtool to start at EL2.

Misses the Sob.

Besides Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 858333fc..2a9c0de0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" = "1" ]; then
> +		M+=",virtualization=on"
> +	fi
> +
>  	if ! $qemu $M -device '?' | grep -q virtconsole; then
>  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
>  		exit 2
> @@ -116,6 +120,9 @@ function arch_run_kvmtool()
>  	fi
>  
>  	command="$(timeout_cmd) $kvmtool run"
> +	if [ "$EL2" = "1" ]; then
> +		command+=" --nested"
> +	fi
>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else

