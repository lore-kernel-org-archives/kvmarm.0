Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26156763
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714562044; cv=none; b=RNxiVL6VOgGRViW5yWqc5/qTsCO6AyV9l1WwCpi41576l49JhoaaAzO3tAXPqv1fwjz3W2CY5xXV5MR64f01BCawm0WoC6oxzMXBVwi1AhN8hkLO2t14s4VbuQ11GjdmvwCLXCuLW1/PQYxXm+Yoq5611D7J29w9nRHCg5kTedY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714562044; c=relaxed/simple;
	bh=Gn2C+fSEj9oEgEcKRZTFnYTq392nKVc8ox1XVnAtZ4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LK9tOWqmuEaUWFYbImdpOWr4BmKt1KKJBhIZcsRK+ObYvbk2yYmxnsBq/JhHy4BvOvkhGz06fqxKbvWhNnHkoc+ifkp9Tu/emKvZdo3Hrs0gYwo7VQ/FOc7T0bGlhhXUN0J53+B1TpZgW6wrTmTuYx65/bQ3rrkYTtnnc2Z9clg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCrtPYnZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCrtPYnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714562040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=klJb2Hbg7SNB5TUedK1etVELNa99mZOeY3ik6uIdHp8=;
	b=cCrtPYnZiWRgYHzxmllroQOT2O32EuArsrHKPmdUEGCXfQlpKMHzFE8IAEkjFtvTuezduJ
	OJNaTsUUq4nUTXY8qAukcnVP/mBJoTgp3mdI5VcHit6yHsT2VFD4SMk0Lm9vl9nuxm72l7
	bx+NX13bLrjZvYqa/6DoRSjQcArOxyk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208--z-iqy4XNRC884VDzF7j_w-1; Wed, 01 May 2024 07:13:59 -0400
X-MC-Unique: -z-iqy4XNRC884VDzF7j_w-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5fff61c9444so6536218a12.2
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714562038; x=1715166838;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klJb2Hbg7SNB5TUedK1etVELNa99mZOeY3ik6uIdHp8=;
        b=ggtNlOwII5In/ATdOJ121dL9j48hHTyXHck1pApTdnDWyJIl9crKIPkzPQV54yBd5Z
         5H4iFcOTYHfn8ZVM/9SImMzYbwgHVsfK0u2MArJYlB+jr8mvVHOUEFnwxX+hpMXWtQ4p
         GgC2uTCjoU8E/39H3j0inTiU3p3nViSW6QwXr3Cr5shSJESyZ2ixpFQEe7LL92mmZO4T
         v6878CVVAsQ38kUUP62/q3T5oTYkLo+7CIusdio4kSx04F6gpwZHBQjMsXLA/u3gfMjD
         iOy5RsMMJDj08DsC/DtsLbRdziVTrVC73Ykb67oL272EM3+7z8MJX8Dgpn7V44g8O+wC
         lG+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYAwmXtVV7shwACiANrAgo5VEfO+bB58gQm162vWM+Dr4bBnPlnhwt/LvK4q9zR5QhoCPtHCiMv3fGNrBL+ahls7e7ZLHf
X-Gm-Message-State: AOJu0Yze8ceiDtwcrGpBrxYc/r/Yyo+K7+vGK44HNWzlM/RVpq6PbmI8
	iuwFurPRMhvZQnrS9zAgUdKPqntxM7u5YfCBjdn+zm9Zpnzgl0QGzzqca02LPib03aHzisqwLXK
	lml+8v4/M4mXsg1OwEzj8ZNynQF9mD2abKSQ0Pv+UoAkbaUl1j+W3qg==
X-Received: by 2002:a05:6a20:551d:b0:1ad:9413:d5c3 with SMTP id ko29-20020a056a20551d00b001ad9413d5c3mr1712263pzb.17.1714562037865;
        Wed, 01 May 2024 04:13:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHk8RZbujTlZAxMHP0HYG36OV8O8L5/EuxcrJRH9h3TeGMjvsyX78a8rPdkWjXbbD+MV6exNg==
X-Received: by 2002:a05:6a20:551d:b0:1ad:9413:d5c3 with SMTP id ko29-20020a056a20551d00b001ad9413d5c3mr1712231pzb.17.1714562037414;
        Wed, 01 May 2024 04:13:57 -0700 (PDT)
Received: from [192.168.68.50] ([43.252.112.88])
        by smtp.gmail.com with ESMTPSA id h9-20020a17090a050900b002a55198259fsm3245338pjh.0.2024.05.01.04.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 04:13:56 -0700 (PDT)
Message-ID: <114fcd7e-33e3-4741-936f-21b0576c59e4@redhat.com>
Date: Wed, 1 May 2024 21:13:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 17/19] arm64: Kconfig: Enable hotplug CPU on arm64 if
 ACPI_PROCESSOR is enabled.
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
 <20240430142434.10471-18-Jonathan.Cameron@huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240430142434.10471-18-Jonathan.Cameron@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/24 00:24, Jonathan Cameron wrote:
> In order to move arch_register_cpu() to be called via the same path
> for initially present CPUs described by ACPI and hotplugged CPUs
> ACPI_HOTPLUG_CPU needs to be enabled.
> 
> The protection against invalid IDs in acpi_map_cpu() is needed as
> at least one production BIOS is in the wild which reports entries
> in DSDT (with no _STA method, so assumed enabled and present)
> that don't match MADT.
> 
> Tested-by: Miguel Luis <miguel.luis@oracle.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> V9: No change.
> 
> ---
>   arch/arm64/Kconfig       |  1 +
>   arch/arm64/kernel/acpi.c | 22 ++++++++++++++++++++++
>   2 files changed, 23 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

