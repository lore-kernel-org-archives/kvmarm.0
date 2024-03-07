Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB141BF58
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709782636; cv=none; b=oSnG0z1TiSecdjhS7bzYqRuwUpHW0ar08uCMGqfJiVHrUeRHsxC3EmF7+f39EKeTiBRgJMnG9IJXj/YYQNcVUGIg0i60kwEarLR1/Zh0pcFWeNVaPGHPaKLASoaZ4AO0F1uaZkPRZMtacnZEPlN/mAx4dpBcMiZTrSmgeIOkG/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709782636; c=relaxed/simple;
	bh=MNm53SQI0kuLGqu7cnUf5aFHc1wwQir271s70tcHUXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpEs0TYzESE3kzFnwhPOHOR3daLKBLMzEEnuGkx7PakFG9e/pQqJXPU3iAGzeIQBPPjXOqzfnuVEHp+xh0BEAlyNyXKMX+Tt0Gi6lOpqHNphXrTIUJVfboxaoeiNh0siZVATJX346z1TWKKRSrcwkME+Wm5B1c1HnSox934rSKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q2ukqrx6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2ukqrx6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709782632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8y9kCMp4YZz001b3u026e4uRLCFX1x1C4NsHFxqltps=;
	b=Q2ukqrx6mgGVwmhXItb5gAsZ/1kDpbV84fp9vnjjnZHbeip8ZRH5RG9/iAOnIAoU+jTN9I
	NGu5/EHnNISRQ6HpcRi/qhBkVfQEh+1S5+4gAFWkqmQHf4/KcJSrBEFnPCC4u0Xh9ryrMI
	lTUjODKepy1ZUzDZFXqmGi6pmP+3/LQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-FuDk-k9kOCWM10zOI4lPPg-1; Wed, 06 Mar 2024 22:37:10 -0500
X-MC-Unique: FuDk-k9kOCWM10zOI4lPPg-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6dea8b7e74aso114922a34.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Mar 2024 19:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709782629; x=1710387429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8y9kCMp4YZz001b3u026e4uRLCFX1x1C4NsHFxqltps=;
        b=H6rgI/xBIaSes+ahJLG1mkee+7H6Cg6NfTEKxiI21nAuZXZ5SK41cZkni8Irzlcl41
         c1Onm/k0L8SxFmXjqwMl8G0qNjKxQ0QTGhXZCvT3bkHnSC89c8x+9Vn9EqzPMD1H6nOM
         S7oNLoYvO5LWsBUN0xhGvRDXdnN3AmVinQfJ5cjgNLn8aruQCVTlDBnu1kIitbIHsm/T
         7gqXw6XXkIop7R35NwFSBvzRJJOq83dx3IUTghhqO9FiKPix81lz5iAcB3siZ/TaSRKW
         3zsQKd31bMeC41eGR0GjsuwSbfeOiYKunMD8z1PU9LdA8HvptG0Y3jmE8oGeVdG7Newe
         PPsA==
X-Forwarded-Encrypted: i=1; AJvYcCWWyE+eH+b/0Mt1QOjDoYC+OPkdeojVQDUtPUBHcm5xAK+L6TWNdG4RG8uj7Kcz9nOiuwmJpyPea8VcY03vF5IvY7qAJDpJ
X-Gm-Message-State: AOJu0Yyvf2I3X/oYMAtLU08ScR3hdQmh77mK0FX5FFIH6wxAYWGet/9L
	Qcmz8g4t+P3sFEyTW3jNM627BJ2GIPnegCCemTQlofSa4PFpt2f2yeUzybOyUD81QYuOo9Qdo4x
	lMF0O/9YWmBijbBiy+WxDcQfDL/ouNm8QN3xTZMFpxvueM0CQrpdS/Q==
X-Received: by 2002:a05:6830:1649:b0:6e5:5e6:273f with SMTP id h9-20020a056830164900b006e505e6273fmr1193235otr.3.1709782629716;
        Wed, 06 Mar 2024 19:37:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmoW2Hh6h0Llz9Gx2I+5/CZotcA1DFd+WYA/lYgqW7f3nGDbhAFQDrbK4aJFPfBriXdWTlcg==
X-Received: by 2002:a05:6830:1649:b0:6e5:5e6:273f with SMTP id h9-20020a056830164900b006e505e6273fmr1193227otr.3.1709782629436;
        Wed, 06 Mar 2024 19:37:09 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k3-20020a63d843000000b005dcbb855530sm11831867pgj.76.2024.03.06.19.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 19:37:08 -0800 (PST)
Message-ID: <a3688d18-3dbf-4064-b75b-6e13875f11ea@redhat.com>
Date: Thu, 7 Mar 2024 11:37:05 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 03/18] arm64: efi: Don't create dummy
 test
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-23-andrew.jones@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-23-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
> QEMU command line options that have been pulled together by the
> scripts will work. Since booting with UEFI and the -kernel command
> line is supported by QEMU, then we don't need to create a dummy
> test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
> execute it to prove the command line is OK, since we would have
> failed much before all that if it wasn't. Just run QEMU "normally",
> i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
> line options, in order to check the full command line.

It should absolutely accelerate the speed of efi tests.

> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/efi/run | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 6872c337c945..e629abde5273 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -53,7 +53,14 @@ while (( "$#" )); do
>   done
>   
>   if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> -	EFI_CASE=dummy
> +	EFI_CASE_DIR="$EFI_TEST/dummy"
> +	mkdir -p "$EFI_CASE_DIR"
> +	$TEST_DIR/run \
> +		$EFI_CASE \
> +		-bios "$EFI_UEFI" \
> +		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +		"${qemu_args[@]}"
> +	exit
>   fi
>   
>   : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"

-- 
Shaoqin

