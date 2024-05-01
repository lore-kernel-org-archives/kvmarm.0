Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6F7F496
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563146; cv=none; b=AHisCrPsoJsh5vhvk0p06IktyCHYvtAa0wGKH9bVeHBt5a88wpkHGo9JVG/nAt54vV40sz1EQjVPt1slRX6p940qDvxxzb+0RCaNf07UprlF0y/2RgrG18qgwUFlR7dkwsDBznTFvc+OPVkc8BnyHIS+ThtsD1bAkwlctcCFl+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563146; c=relaxed/simple;
	bh=6F3ISMAbsRLy7q+h/9yXAkPtqY1kgaNN+BV2pg4j5gI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fz9B5UgqnJQ1YJKHtZniuWaI61nKhIUEs6haFoWhZG0wz6azg7TDaPvS02WjDBMBxZBbS32adok9KMFE67eMETfLyrJKcnrAI4TIfjpgi5avLEIIqwJhINABEXEw1dA5NqGPj6v8t+3Iib9hTUQI4LJsx+AC3HqPF4lEAB1XMv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWywUgFn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWywUgFn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714563144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvY4677tvfuT/jSAqPXkUvL4xI6+hoEBXpkjqJe2TxE=;
	b=cWywUgFnaMWzucCI+WuNksrUiBpQgOchwtVcmVd9r6eKSl0x6EvZo9s7p2zP6gJaDr7oC/
	bSD7otPcLOP+lf/HQZZlSjSIHE0I7f/QsrmMq3Zjx1j2W69HfWvb7vB3f2anmnFutQsqEL
	kPqVtDs+4thC0XVUK7QzSOV2IRNN0Gg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-JdTXfFp1NqW8fVY4pWgJKQ-1; Wed, 01 May 2024 07:32:21 -0400
X-MC-Unique: JdTXfFp1NqW8fVY4pWgJKQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ec5ce555f6so13467005ad.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563140; x=1715167940;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvY4677tvfuT/jSAqPXkUvL4xI6+hoEBXpkjqJe2TxE=;
        b=pMsRk7xEH3b9QgeFp1N8knXJLcC/wcKQfVc+xPWrmHTdD1bqLwPBWwr05laTdOtUGQ
         49W2g0l26ml/fXvw4gZGnCarFZKC1wEN+bm73iZhhG2hsAJiRcrVtU7TT9BuczghphKf
         57hfWvL7KFJtSW5AzW8RNJ3bWZLSTHQUS4sSOp+k5ROtuIUP+GYJjgWMrrSY6dbLo9il
         3mhWo+GU9Uv+32xL4UX2YItWH8XeiHEEmizmdMPin35/BKfr3m9UfZHQfFYp5NdiAF5I
         EPpRH4gg40Y7Gjun0z1SCulgDy9hQj/kUpvP7EAKuSFpJDqGrLd0hHTiDqM0egsDmCQ0
         ZGUg==
X-Forwarded-Encrypted: i=1; AJvYcCVIQkGTBWGh+grU8cXFhs4DsNo0aMQg+NilW3Y2Ih0Ef7ICl9yunNZ2QXUkIfImjmQHsPuTKDXgVdGceEVp75T/c+wlI8FV
X-Gm-Message-State: AOJu0YwIC2yBoiqVXh6w8t97oAx6DhI2ndgJ/KIyAgZG4FdkQxI85g8g
	HXH4xfUbtl8EwJUM8Q8Nn0yYI4nWKaHqYC4ZAGwdyF3DyGGiX/jCdxfhoRVZvhqx8L4gN34RGCZ
	ZzjQVzLJWuGGLuyXxhLANmOzVQaCLAUTxaSeC5blyP2z09eWq1LA0pw==
X-Received: by 2002:a17:903:22cb:b0:1dd:6ce3:7442 with SMTP id y11-20020a17090322cb00b001dd6ce37442mr2025078plg.39.1714563139905;
        Wed, 01 May 2024 04:32:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn/GVXiGegFVOAaktJ4SFkKCrfxZSExdPxCeZLOx/YtG8arQj1wuv7wQDNju0KSdPBov9xtA==
X-Received: by 2002:a17:903:22cb:b0:1dd:6ce3:7442 with SMTP id y11-20020a17090322cb00b001dd6ce37442mr2025049plg.39.1714563139450;
        Wed, 01 May 2024 04:32:19 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903024e00b001e4753f7715sm23973521plh.12.2024.05.01.04.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 04:32:19 -0700 (PDT)
Message-ID: <0f635267-d296-467a-a337-34192c35164b@redhat.com>
Date: Wed, 1 May 2024 21:32:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 18/19] arm64: document virtual CPU hotplug's
 expectations
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
 <20240430142434.10471-19-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240430142434.10471-19-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/24 00:24, Jonathan Cameron wrote:
> From: James Morse <james.morse@arm.com>
> 
> Add a description of physical and virtual CPU hotplug, explain the
> differences and elaborate on what is required in ACPI for a working
> virtual hotplug system.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Tested-by: Miguel Luis <miguel.luis@oracle.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v9: No change
> ---
>   Documentation/arch/arm64/cpu-hotplug.rst | 79 ++++++++++++++++++++++++
>   Documentation/arch/arm64/index.rst       |  1 +
>   2 files changed, 80 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

