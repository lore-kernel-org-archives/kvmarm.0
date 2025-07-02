Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8CB28640A
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 14:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465409; cv=none; b=g70wexs59ynxMPlWXeyDOpb3Sz4snt6JsUnBeA7Xy2Whb+c62nUiMgzw3iyzUD/NmW7tRy30G/HkSK9YxQXywQqdds7vvrsEcSNhe0BKD0Uq7zQL3QmEl44jYb//05azr9MN8+ja2lzG12HVcHNYadG1aMgYME0a/EUJACzOKtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465409; c=relaxed/simple;
	bh=UUBdzAZ3c9ouEkqzG/IpqaN+2UX9mqsjR40U3uwz+0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YbW92/2TV3ruQFSdBIXsNoPx7ZUIFkY9xF2L2KoaPFN66Pfuha52wqxmUfOx+J1DwkEjFFAdHLBKu7q181ifp9KGy/8L91lAn1l5E5uijCaR+m6nLid22Wl8j4v7z3pgPjJL/UtjFhGm/w/sf1Iea5kNWGCDvwDLeG3TDm+h1tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XId41UTg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XId41UTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751465406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TgZwYQY/6//7Y1IiL72sIvHhk7c1rsqVRlKePVxyg/g=;
	b=XId41UTgFG2m8aM2hiqC98De0w8e7iaGitmLuKdhhI5xeJifYi7cgG3jv8+KJAH5rDMnSh
	7zkhIynV0xYrcAe4DTgpQ/M8y5cgdxWM8n9VxO7QsFaWZNUqSnaR9QarnJF3642c/hSruG
	5bCEadorrkK0oWtTlOQ3R9GzT59I090=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-fdUWaLxBOc6fP-s-7LYqlw-1; Wed, 02 Jul 2025 10:10:03 -0400
X-MC-Unique: fdUWaLxBOc6fP-s-7LYqlw-1
X-Mimecast-MFC-AGG-ID: fdUWaLxBOc6fP-s-7LYqlw_1751465402
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f8192e2cso2787199f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Jul 2025 07:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751465402; x=1752070202;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TgZwYQY/6//7Y1IiL72sIvHhk7c1rsqVRlKePVxyg/g=;
        b=HKsEAwN2Wkvc7v/d+g4lIEm2kvXUun985r8bkT8zSpPY8hk9iQNB//ETG4E+X4PVfI
         rujdH5EEHnHsmo5GxhOmgjpHO0097hVJ/pZaDRKenXowNYgJZvxTdIDscHCN4AzuqwOc
         Fj8FRnXjFH3YFrK3byCr5uuWmPCXZ4yfwnpORyIyRSRoBw4DFaq2KwE2wuJyg2XzK2o2
         thujTrhm1vmtOjKHbnm3eF4nxvQvDEOfSInbgOrfJtMMgFhxPpBR2SP6R+KXljjYKctc
         9oSnbLc5bs3JUB1p+m63P2eY33V5MtDp3bOwSQQbJmPIL3GOVVIgN1ssvHTTfT0aNHwz
         TrGA==
X-Forwarded-Encrypted: i=1; AJvYcCW2i9+bj0WtM9NU4iHzd7mX5eLqqSp1h47UYY+6hxTIegxHWtst+Z3b7ScWSf9GU2skAHX9mg0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW022h2+G4kGpwmhCuMXxpd34hvrMqkLNqDYmvSJuRFeZ1+cs9
	BnfNfOrJh4a+B0wq9hZ9vEod1t4vBYVZQsNXwXa7iZrOmwadkGYzi8aW3Ip0dcUw618MiBKaAy3
	zB/VsI/u2xNSjCS5fgA1zXEAVevU4Ca9/NJ1sRO6pAWMwYwxhjQV5rJD23g==
X-Gm-Gg: ASbGnctWOQGsDYYDIeWvABVDtRnR64guA0BO9R+lMf3+YevO0nAgS5tb0bzah87sakO
	i4F6Uxptq5vlclTBkkFsHwJ2cKgdyvPauVBS61HP8JVdf55qncgt2r2XJ0sgyUvp7Js1/PgwS9C
	3StU8b9DzliSP3mNsxsOR2msnCHZZVQyPXBQfuAkz/mYkpDRtLYWp5qsyRIYwuRGc6wbZs6ZLkb
	oLmGYjKT/FnEH5xUlj2tLZYcsOB3i5IMq/HpwNqhNnUCmDpH1qTIWa7WbAR9n42kS2xsUbG0fO6
	iAUd6Nik5SQ5QzhAHVCRgysqtbm1XvtXnlrEWwo8sM8NzzFqaMJGYlTxaFE6fw==
X-Received: by 2002:a05:6000:18a5:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3b20048e6acmr2349174f8f.32.1751465402216;
        Wed, 02 Jul 2025 07:10:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTHkYd/ujfN4fgDDxoyAu+QvDaaEzPHy6fqG+fLvYE5NiiLRk5DOmUub4YoMfZz682a8//Nw==
X-Received: by 2002:a05:6000:18a5:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3b20048e6acmr2349116f8f.32.1751465401643;
        Wed, 02 Jul 2025 07:10:01 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-114-041.pools.arcor-ip.net. [47.64.114.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823c57d7sm240986715e9.40.2025.07.02.07.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 07:10:01 -0700 (PDT)
Message-ID: <627b4dd5-b08c-41b4-a3cb-99d522fc2063@redhat.com>
Date: Wed, 2 Jul 2025 16:09:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] scripts: Add 'test_args' test
 definition parameter
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 andrew.jones@linux.dev, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, pbonzini@redhat.com,
 eric.auger@redhat.com, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 david@redhat.com, linux-s390@vger.kernel.org
Cc: Shaoqin Huang <shahuang@redhat.com>
References: <20250625154354.27015-1-alexandru.elisei@arm.com>
 <20250625154354.27015-3-alexandru.elisei@arm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250625154354.27015-3-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y9itARVE6A1RKoL_ZoTb7ByKvA749Ccf5zVig4BAsII_1751465402
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/06/2025 17.43, Alexandru Elisei wrote:
> kvm-unit-tests, on arm and arm64, is getting ready to support running all
> the test automatically under kvmtool. Even though kvmtool has a different
> syntax for configuring and running a virtual machine, kvmtool and qemu have
> in common the test arguments that are passed to the main() function.
> 
> Add a new test definition parameter, 'test_args', that contains only the
> VMM-independent arguments that are passed to the main() function, with the
> intention for the parameter to be used by both qemu and kvmtool, when
> support for kvmtool is added.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arm/unittests.cfg     | 94 ++++++++++++++++++++++++++-----------------
>   docs/unittests.txt    | 17 ++++++--
>   powerpc/unittests.cfg | 19 +++++----
>   riscv/unittests.cfg   |  2 +-
>   s390x/unittests.cfg   | 13 +++---
>   scripts/common.bash   |  8 +++-
>   scripts/runtime.bash  | 18 ++++++---
>   x86/unittests.cfg     | 92 ++++++++++++++++++++++++++----------------
>   8 files changed, 164 insertions(+), 99 deletions(-)

FWIW,
Acked-by: Thomas Huth <thuth@redhat.com>

