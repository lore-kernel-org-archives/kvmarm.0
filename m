Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE6E524DC
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714558737; cv=none; b=gmsQ/BTFTPa28SuOd8bZnGZkwCISsxNeExQaldnSH5offl18NxAjKcHtjOVbpP7vkTQ5Ji81Qc4IAMqbP5y9veUvMG6y/ZZZ7AOp6HzkTv237naanAE8/uMEZp+rozKan2VEdzucIGewvJ5HA6+Lwj36DA+maynY7PmryjDSLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714558737; c=relaxed/simple;
	bh=Ev3McdlDAs4BYS6y+XNElwdCdUSfrG/SuHrK3FK3B+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pGYPVomb6Rl0WuWEy3u9CfANPldtmsGyuNZJkwZ6CRA7RPEpEWdyqG2t/W8r1IbsvQgtT4zodggRYRypiJwBp9/Lo8kUYaK6H47AjkJdH+Cw5ErLmnccJNNmIlEJt2N0XEFP2jAQ4Izx/iTljCQJ4aMjaS5Mm8NQGMstQlawCts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqppKfNX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqppKfNX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714558734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DxKl3udzzGpg1eT3+MxaYs7RsOyw5KvkU4S7GKrDV/g=;
	b=HqppKfNXGTfgv0SYVLu6TlG/eqZ4d3IpPdCIufevQdNB1SgjdWJ4rR6VZJuaBhb1lte94D
	Pk/yQ/9NhxNQ68P7GgRmtCcTx1VoT76tJFQSBgXjKR59/INjQ52yTTgM3wCTc5Z9YAAmO/
	hJOg12kAaux9BJ5UlzU9Ob2Iy/N0Loc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-wVRkeQZfMLmbBP7OSBugyw-1; Wed, 01 May 2024 06:18:52 -0400
X-MC-Unique: wVRkeQZfMLmbBP7OSBugyw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36c32dff50aso60016785ab.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 03:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714558732; x=1715163532;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DxKl3udzzGpg1eT3+MxaYs7RsOyw5KvkU4S7GKrDV/g=;
        b=HmeMy68/ETbCsKUBpVYjAOBmc4wvvFPGAbU8tK0zfyffo3g2EgMCtNG+LleJWsuTz8
         4PjiZTC6lMu0osFTFybtlvzRfzSXJL5Ig26DlmlpbGdG450c+iySE9SxKDMx3oC/pRDL
         8+4nksuAgnd9miigjKk6uwAezCp9Ab4iHEfEYBo9ZsQO4br4noo4GK2ato/pNop+K5sd
         QUpjaRFpWYgi7BACSh0YSLx/sgv9OXeIe5sfgqdLMyU+YzIaPZBiy/2bui21dhIRAKAS
         Igs2RVR4OVmSiVKVc0i2pOSZ2V/QjmkEIgFcnVTS3w3+TWdi7J9BDDUq/QrBZmwVeNJq
         jSLg==
X-Forwarded-Encrypted: i=1; AJvYcCXRUndD/jszdguCEtrP7Cxv5DHp7ik0JAqpvxQ9LKuC+umbu2bY0gPnIJLeEFn72SSywZQ1YZo8y2g2F19JuOgzNplnZUyM
X-Gm-Message-State: AOJu0Yzxz2IiZF1fMEkHmXDQk4tytr1sJgjDVnLIi00BVwTqpi1fSaDS
	ohuxEiH70gWpzG8LZgl2CdcY8T7KKecyj+iw1X9yhXS2KLo3uBjq0+WKQtVKFYSMbTq64k5dwA2
	6Y98lWV7x9MxthW9wyHITeZLLdbsedrk2Xz0an5qCT6R8prbvb1WrIQ==
X-Received: by 2002:a92:cda8:0:b0:36c:5092:e6a1 with SMTP id g8-20020a92cda8000000b0036c5092e6a1mr2567019ild.29.1714558732220;
        Wed, 01 May 2024 03:18:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXwbnm2St0QGkNYvo0Kzya2DtdxpDRe1dq5klNVqI1ZMi8KwgV+DlV3hJf4iiekAiT2koB1Q==
X-Received: by 2002:a92:cda8:0:b0:36c:5092:e6a1 with SMTP id g8-20020a92cda8000000b0036c5092e6a1mr2566984ild.29.1714558731861;
        Wed, 01 May 2024 03:18:51 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id x71-20020a63864a000000b00606dd49d3b8sm12183225pgd.57.2024.05.01.03.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 03:18:51 -0700 (PDT)
Message-ID: <08c6ff11-ab3d-4a4f-95ea-735134fca8cb@redhat.com>
Date: Wed, 1 May 2024 20:18:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/19] ACPI: processor: Return an error if
 acpi_processor_get_info() fails in processor_add()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, x86@kernel.org, Russell King
 <linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Hanjun Guo <guohanjun@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linuxarm@huawei.com,
 justin.he@arm.com, jianyong.wu@arm.com
References: <20240430142434.10471-1-Jonathan.Cameron@huawei.com>
 <20240430142434.10471-5-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240430142434.10471-5-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/24 00:24, Jonathan Cameron wrote:
> Rafael observed [1] that returning 0 from processor_add() will result in
> acpi_default_enumeration() being called which will attempt to create a
> platform device, but that makes little sense when the processor is known
> to be not available.  So just return the error code from acpi_processor_get_info()
> instead.
> 
> Link: https://lore.kernel.org/all/CAJZ5v0iKU8ra9jR+EmgxbuNm=Uwx2m1-8vn_RAZ+aCiUVLe3Pw@mail.gmail.com/ [1]
> Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v9: New patch following through from Gavin pointing out a memory leak later
>      in the series.
> ---
>   drivers/acpi/acpi_processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

