Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F1FBFC
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 03:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713758014; cv=none; b=mKuGqKAhs1RfBqIFI4EarthnaK7551C4BqMhsHjIyLV1l4U0fBC5E9LmoOYSn6Eu6iy68V8Uo9RIM3612UmIz/RcTc8fyTl4z7Oj0YjQKTaFh9b01ItOY4mwiwNIipnegB6OynXxL9XHGfwzFc4sXv1vJ1pYO0cCFQtQqVlBAGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713758014; c=relaxed/simple;
	bh=tD6kiqMKmO+1my/aa9P9n8z6J8qrVBho+qlOdcCPRLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEvMrMMMg/sP2P7ojUlyrWqNBgAvh+BGmqlKshgS8nrXy2nTomNMifRYkDt5F1a9+rYmrw6bljCw8bWGCeAX1gHpnxXdYXlj7iC6ALgq0zI9UEHXKHde91KSLRMQe0klPArMzAxGbi7lfjw/QRH3Bg0NQ4/2mfTaZZwOpxGdkf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBUSHHK3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBUSHHK3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713758012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0XyZSlHJbiwL8Fk8e6Ao9ghbhjrrj0okROdeEG3PeA=;
	b=PBUSHHK3VsI2+9iVcPt5KmKCoeNlDwvoaaY5aYXd6D2POy5aFigXua8bHUus5ACLL+xIrR
	dyZE/wCwawQNWvWgdmvpxHu+VNDLEUlPfjeILv1tVT5XenQm3qZpvpY9g10RSDtGjE+I3E
	X3oFCvDN0Yn81vADhf/jrPEn7n4xO7M=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-IFvHTlRxMgS0JREIgGSgKg-1; Sun, 21 Apr 2024 23:53:28 -0400
X-MC-Unique: IFvHTlRxMgS0JREIgGSgKg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c5f32f91d4so6035692b6e.2
        for <kvmarm@lists.linux.dev>; Sun, 21 Apr 2024 20:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713758007; x=1714362807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0XyZSlHJbiwL8Fk8e6Ao9ghbhjrrj0okROdeEG3PeA=;
        b=V2G+2MfXRiGLcqcvHPZbrMiocDQ+N/k/Q0+RlcdVd+VZPF/bGx3lkAJOZAgdJOvUUr
         2iqZIV8wlpcdp++edZcNgchPKTipCdjyIcCF6T7TvinAfR9WkiU4XjaUxxr8SHR0Et/p
         B8l4r/vdgOtAuJi8tZyk9+FL2TZOL95cThbGNkMhGEeItpkC8GaNEOua4MRB2/kWwlAK
         yh6fuz5wXwDArcGkGGk3dvgsgpx2+kV6U1btTgtSNEMnAkLLRA4cnivssR6W9r1X71vB
         kIVjS12d5yPWii0UeUF0hf8/Q7/RLx5/Me78QEOPLLcMIyHoIfvo2YZ+Jh4B/HcdXD3D
         9RIw==
X-Forwarded-Encrypted: i=1; AJvYcCWrkJgUdEvk+oEWjfjQpi5S44NFqdnGVGpGTAu7Ptk94VxsmeTjO5FpIxD2XKL/+5LcaXWIg3On5+8+3YUeUvFrNvweE667
X-Gm-Message-State: AOJu0YwkmfoPX9/sbP6U7PhUW+1F7dCQg0N8ZhCPpRuFNcBmNR2VVdPi
	b5znCfAWPO4/biqV5s9DmdwUjtt2XZ4sbYuR0gKnj57gXAracAKSswLpji13gYpJLwMF2JxsEuE
	a47z41Ku7HeSDHhmTCSpoyPqZixE46ShgIW/tlWkiWU3LFhOqwVDaEw==
X-Received: by 2002:a05:6808:124a:b0:3c7:51f:156c with SMTP id o10-20020a056808124a00b003c7051f156cmr12703898oiv.29.1713758007409;
        Sun, 21 Apr 2024 20:53:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkZ3BNLKQwXsjKmL+OZ/4pqOa0EAKdoGoRtaqIZBDJxdFy4L8f2LFmwwMaKdJQp7E0m+dRqg==
X-Received: by 2002:a05:6808:124a:b0:3c7:51f:156c with SMTP id o10-20020a056808124a00b003c7051f156cmr12703871oiv.29.1713758007141;
        Sun, 21 Apr 2024 20:53:27 -0700 (PDT)
Received: from [192.168.68.51] ([43.252.115.31])
        by smtp.gmail.com with ESMTPSA id lo8-20020a056a003d0800b006ed4823671csm7078329pfb.15.2024.04.21.20.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Apr 2024 20:53:26 -0700 (PDT)
Message-ID: <8c3efa79-53ef-40d1-a701-5c88447c95cb@redhat.com>
Date: Mon, 22 Apr 2024 13:53:16 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/18] cpu: Do not warn on arch_register_cpu()
 returning -EPROBE_DEFER
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-pm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 x86@kernel.org, Russell King <linux@armlinux.org.uk>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linuxarm@huawei.com, justin.he@arm.com, jianyong.wu@arm.com
References: <20240412143719.11398-1-Jonathan.Cameron@huawei.com>
 <20240412143719.11398-2-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240412143719.11398-2-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/13/24 00:37, Jonathan Cameron wrote:
> For arm64 the CPU registration cannot complete until the ACPI intepretter
> us up and running so in those cases the arch specific
   ^^

typo: s/us/is

> arch_register_cpu() will return -EPROBE_DEFER at this stage and the
> registration will be attempted later.
> 
> Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v5: New patch.
>      Note that for now no arch_register_cpu() calls return -EPROBE_DEFER
>      so it has no impact until the arm64 one is added later in this series.
> ---
>   drivers/base/cpu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

