Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFF136C
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 04:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695010441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+naNdgA3bFvfUIv4tJXTTMUwzR4YQ9euXBZfFED9oXc=;
	b=MPknRFWjt+gO2KIhppkRjReWPLmE7eoVG9QkQqEgHU0Q/SMVTHXHWOYXLLZZBtPn7AXpVd
	x1M5nTfClD78jLZ8s93PCFf2NpboRtTzPiRIT/lAnvyLvbTY7odf3F4FMPXuhOC5CZdUzi
	bVnJZzJt+BomntwYiJNbOsZ2WcQzvOk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-liPU71o1MH22jmrQ_PJ29Q-1; Mon, 18 Sep 2023 00:13:59 -0400
X-MC-Unique: liPU71o1MH22jmrQ_PJ29Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-274d83f0f5fso1314221a91.1
        for <kvmarm@lists.linux.dev>; Sun, 17 Sep 2023 21:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695010438; x=1695615238;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+naNdgA3bFvfUIv4tJXTTMUwzR4YQ9euXBZfFED9oXc=;
        b=gY+o1XGuH5VSkuSznaaRnVRiUME60w90VaNfbmwiJh1uGpfMguyUFpZyjk62llIgI1
         WFs1g5RPusGb8cW1e/kgFk76xcyc+7ljIGuNsChM9+ldW+eP2GLFhHGsNjPY1lYqQ3rm
         jnuRNqQerxlySjZ8jvUqouRvQUqVo1uP+Mrz6N9IW4n5A75KoTeELRq+X0HmLlFuvyAp
         vX2fugz8kt2Q6NiuaCxgO1wY7xLrcsxHChWvLoZyFKsfy0eXmQ5GQfmI9Ldtuf+oVMRE
         wnGGJaQsFX1UlNRLvcMFYEKYmVWsnLSJjIsr215hmTKdu0lCMn7oZwIo2dIMfgHbJCcj
         OMLw==
X-Gm-Message-State: AOJu0Yxy7vmVtrM03obsOX72dyxmmeLKhDRZcMU0bkGDS8DcxDF8S69g
	416+Uh7XcGhYQtocFI5FmPjdh+pvXF/qYv+s4iiwuThs4weMQ1y98YRPjCsMeMWYc9t8xiD81ZR
	LtiOKu3rfZn7X+4Ww
X-Received: by 2002:a17:90b:a4a:b0:268:d05c:2d7e with SMTP id gw10-20020a17090b0a4a00b00268d05c2d7emr7199798pjb.14.1695010438620;
        Sun, 17 Sep 2023 21:13:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1foMotPOeb/U6/yukF28+ks3ZQRkPSCrKuGwYeHbXeH4thsw0w9Gpz7n9powcJl9wMU41Zg==
X-Received: by 2002:a17:90b:a4a:b0:268:d05c:2d7e with SMTP id gw10-20020a17090b0a4a00b00268d05c2d7emr7199783pjb.14.1695010438337;
        Sun, 17 Sep 2023 21:13:58 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id s8-20020a17090a074800b00262eb0d141esm6923176pje.28.2023.09.17.21.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 21:13:57 -0700 (PDT)
Message-ID: <e364c6e3-4900-404e-54e9-a634eca4384a@redhat.com>
Date: Mon, 18 Sep 2023 14:13:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 13/35] ACPI: Rename acpi_scan_device_not_present()
 to be about enumeration
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
 <20230913163823.7880-14-james.morse@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230913163823.7880-14-james.morse@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/14/23 02:38, James Morse wrote:
> acpi_scan_device_not_present() is called when a device in the
> hierarchy is not available for enumeration. Historically enumeration
> was only based on whether the device was present.
> 
> To add support for only enumerating devices that are both present
> and enabled, this helper should be renamed. It was only ever about
> enumeration, rename it acpi_scan_device_not_enumerated().
> 
> No change in behaviour is intended.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>   drivers/acpi/scan.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index ed01e19514ef..17ab875a7d4e 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -289,10 +289,10 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
>   	return 0;
>   }
>   
> -static int acpi_scan_device_not_present(struct acpi_device *adev)
> +static int acpi_scan_device_not_enumerated(struct acpi_device *adev)
>   {
>   	if (!acpi_device_enumerated(adev)) {
> -		dev_warn(&adev->dev, "Still not present\n");
> +		dev_warn(&adev->dev, "Still not enumerated\n");
>   		return -EALREADY;
>   	}
>   	acpi_bus_trim(adev);
> @@ -327,7 +327,7 @@ static int acpi_scan_device_check(struct acpi_device *adev)
>   			error = -ENODEV;
>   		}
>   	} else {
> -		error = acpi_scan_device_not_present(adev);
> +		error = acpi_scan_device_not_enumerated(adev);
>   	}
>   	return error;
>   }
> @@ -339,7 +339,7 @@ static int acpi_scan_bus_check(struct acpi_device *adev, void *not_used)
>   
>   	acpi_bus_get_status(adev);
>   	if (!acpi_device_is_present(adev)) {
> -		acpi_scan_device_not_present(adev);
> +		acpi_scan_device_not_enumerated(adev);
>   		return 0;
>   	}
>   	if (handler && handler->hotplug.scan_dependent)

Thanks,
Gavin

