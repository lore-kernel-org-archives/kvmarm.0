Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B474E171A0
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 04:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQrNILGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701317838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1gushqAiHQ23GEZEOV13TzTKkCoZS1NFR10zi092Pg=;
	b=HQrNILGPB6YpSwawfGQx7+M8wnGm7voNK17SsFghGJ6WR8v5T3YdxBkS4ETYBtBVcB2H0z
	M+1KFBOLU4XAnxFsfoV6YAvWF+KHIs5UJsLpG0fL1JG+mHAVeD9cVrmPmQZKa8sRfs+vrP
	UnUYpGKsBSb+vGY2OF4BBVOKHhfimkA=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-LtYctMrQMHCbZIREno-LLg-1; Wed, 29 Nov 2023 23:17:16 -0500
X-MC-Unique: LtYctMrQMHCbZIREno-LLg-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3b894358aa6so133898b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 20:17:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317836; x=1701922636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1gushqAiHQ23GEZEOV13TzTKkCoZS1NFR10zi092Pg=;
        b=UGwJh+ulRVbitpzdir63KBdflsiH/VGXaOR9vluOILly7VwFrPFT9LAu3CeR7F9KCR
         rG31p+5MBSa3bs99b6mAldaRtnzq6VbBXcEYwo8uXB59qoAaMFnuffY5llC2Wn8Vnclf
         cr8heYA6xV1GPku+XasX2wOngHjW3tWeNWcQGEBLQzWDLovcFOl1tNfoD6SFhacedM4W
         uT0JKMHBQJ0xlGjz8szewcBH47OgnSnAonbvlBnuooMCypykBG/3928OVRTDSCQGaHAD
         0Dapula1uzq5R00s0t7DQXjCE692ex+47UjBdC4v2GfnH5Ww+G2tkqfzYL97xvNoeXzE
         xL4g==
X-Gm-Message-State: AOJu0YynOLa8X/mLLuUXcNWllLw2Y7oYoGvSAc0M+T1DyIOPwPYDNTtH
	ICA3Vv5zJE6T30ijkMH0NKwuv9wedrxr+j3elPKXYHYg5uFhMwzTxWd3Co+qLMMDXzsQrArr7rq
	UmmGoFZOHcYjURtUN
X-Received: by 2002:a05:6808:2121:b0:3b8:5fb1:3574 with SMTP id r33-20020a056808212100b003b85fb13574mr19231984oiw.0.1701317836044;
        Wed, 29 Nov 2023 20:17:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFF/I4dHP0NTHDLJ07kE1nSAYz/sN38Hqo2/+sQEmk3lhRLo6bjADuJwRleLPyVTHCunNfFzg==
X-Received: by 2002:a05:6808:2121:b0:3b8:5fb1:3574 with SMTP id r33-20020a056808212100b003b85fb13574mr19231964oiw.0.1701317835768;
        Wed, 29 Nov 2023 20:17:15 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e8-20020aa798c8000000b006cd7d189aa9sm204205pfm.131.2023.11.29.20.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 20:17:15 -0800 (PST)
Message-ID: <926b91b3-4355-ac68-36f3-6352b1ac7285@redhat.com>
Date: Thu, 30 Nov 2023 12:17:12 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
To: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
 Colton Lewis <coltonlewis@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-3-shahuang@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231130032940.2729006-3-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/30/23 11:29, Shaoqin Huang wrote:
> When running the migration tests on EFI, the migration will always fail
> since the efi/run use the vvfat format to run test, but the vvfat format
> does not support live migration. So those migration tests will always
> fail.
> 
> Instead of waiting for fail everytime when run migration tests on EFI,
> skip those tests if running on EFI.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   scripts/runtime.bash | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c73fb024..64d223e8 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -156,6 +156,10 @@ function run()
>   
>       cmdline=$(get_cmdline $kernel)
>       if find_word "migration" "$groups"; then
> +        if [ "{CONFIG_EFI}" == "y" ]; then

I'm stupid. Should be ${CONFIG_EFI} here.

> +            print_result "SKIP" $testname "" "migration tests are not supported with efi"
> +            return 2
> +        fi
>           cmdline="MIGRATION=yes $cmdline"
>       fi
>       if find_word "panic" "$groups"; then

-- 
Shaoqin

