Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DB5B641
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 12:48:27 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2bcb50e194dso14079551fa.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 05:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695300506; x=1695905306; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/A5vuenmlkhrtFrS+dNGrMMk0S0NguCO8nxbIZO8MA=;
        b=IKA31H0hJZlwb7VUm/OduUZDtiY1Y8y53TckC+MpcMQ2EQEwIHXCVn4PubyFVAuUKi
         +Y9v44UGRHY6988niTS8oCZtM/w8msFLdPWAxWdkaxG93NBUe+3ao9Cmj9ROC+mmxPll
         r1uSfY5SP6w7DtJNwlLN9RuD+wvrk7x54znkQjXi9Sgfd1P8Qj6U4Go0t0KUzmpMAR7z
         6rPZTZfLHnWy+rVinV+wdmGpjogOhr4yoLAXYGSd/YBuBnY1iwz9I3ffodS7xM5CJJnj
         VMNE3y5c9HKuBQZl0NvzGYeust5TPUOu9GvFyiBpCtv06I7+nCl4H5Z+kROhyOmCnxVr
         DAEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695300506; x=1695905306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/A5vuenmlkhrtFrS+dNGrMMk0S0NguCO8nxbIZO8MA=;
        b=SbdpoHPo1cFqsMw1OMcfYA2dGxxVP9we1kD47MFvi1a8hZ9iRvgfbyuTWBuPOm6XJY
         XQi9Lrzg/sWG6aNgfxJ+QIxkF1xAFIY4qD+Af4hzQj6DrWTqD+uKauoz3/Ll9UsEjgvE
         DB9pIyEltV1CyTS+X2SBTMW17sw98pwmddbgxeiwsFIiW9Nzk0nrJNyLEFn3OAKGbCrJ
         F8d+meYOJSebWW78QlX7AohXxhd1TRURXN1JNTDFUJuKJlNuqaAAgwiEiqXlYtOakcrb
         QKFqtsTaJ54ZHgxGZ0wcTDmjwaCT3WA+x5ZY5G5YCaBEbAuMmTAeW6Nk1AQRMmLNKU6S
         8Eyg==
X-Gm-Message-State: AOJu0YzSHLpV0uw5nAdXaSoBRl1T65LyAeYNFe1QS70w3kxHV8i/Haiv
	Ue+HMBS++d+RlgsDRijwV3hB2A==
X-Google-Smtp-Source: AGHT+IGKNz73zo4UkMPomouZfO94XUGgOfRKCBkbrngSPaYsObeYHl9nQc8Iy0vty3o7VjdL8fmYiA==
X-Received: by 2002:a2e:8892:0:b0:2c0:d06:9e65 with SMTP id k18-20020a2e8892000000b002c00d069e65mr4701307lji.8.1695300505959;
        Thu, 21 Sep 2023 05:48:25 -0700 (PDT)
Received: from [172.20.41.70] (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id bg1-20020a170906a04100b009adce1c97ccsm1011913ejb.53.2023.09.21.05.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:48:25 -0700 (PDT)
Message-ID: <eef75622-0e4a-3605-5ec3-5d21c06d5c41@linaro.org>
Date: Thu, 21 Sep 2023 14:48:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 2/8] KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT
 ioctl handler
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
 <20230920195036.1169791-3-oliver.upton@linux.dev>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230920195036.1169791-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/9/23 21:50, Oliver Upton wrote:
> Test that the system supports PMUv3 before ever getting to
> kvm_reset_vcpu().
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/arm.c   | 3 +++
>   arch/arm64/kvm/reset.c | 5 -----
>   2 files changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

