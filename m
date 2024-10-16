Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8E45008
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729122125; cv=none; b=OVGIhLW7D0KaO9t1+5tQJX4KZY/kyCYTrz2mnlAOJfn9xe7YC9Evf7n0EBBqI/rW9/kXkAO2yludxIfIm7k5aYK1D6c5yF3HiLbUs95BOjhu9G0j/bXxPkV0hXm4Sja8aSSW+TY/R2aVorUfwHA21m4BehG5V3ZGI9PLKvz72Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729122125; c=relaxed/simple;
	bh=rWKjOkR7Mks5fDQm/Nq+6D1JvyZHbtU2n25t/tkhCNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQivshVkxNfRN7TyASB60yiZHNQD3hRQjFEmPKjwv+kMBqLnorrax4tEE5L2m1K1w/JVR8F9EK7X1y6pEY4msVLXDJPUtIhDTJ6hZVOmy7dhBEvAQXt4nNfkQW5SszvoUrlFY+EjSaJY9Ie/5CszGQJovbFbNDi+GYUf/uE+AU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFHw6hCf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFHw6hCf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729122122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b+qy3ED65+36lx7o5nKz0lPcYUx2+wo9HVsaJhxsCX0=;
	b=QFHw6hCfvyChFrtoj+DJv52pKX3fKjR2cJpxAbN1FJvV8ZMwUaUkhDLv5jdQCW4KsePFar
	h3YPEo4n8/RO3GeDilh0kzd1k5P8hhJ/ECmQouaoPduMY8HImyyq+FYugF/bNp9sGe+tmj
	dc3TqoKnMa3aOWOu2QodfEDpR7VprCo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-KjAOi_XBOM6nno7CFSy98g-1; Wed, 16 Oct 2024 19:42:01 -0400
X-MC-Unique: KjAOi_XBOM6nno7CFSy98g-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71e4ece7221so1164678b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 16:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729122120; x=1729726920;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+qy3ED65+36lx7o5nKz0lPcYUx2+wo9HVsaJhxsCX0=;
        b=dXFSjTs3fp31dcuo0KSsY6FCgkbBM085JY9lnNQxJHhTB5BRB3uAtSiSgyGsYSbym4
         75lShtHD4Lee8Xm4/e4Ha81/VECJJecTDRYXt3TKye49UYyJxFZGw6q0VEr8o1q+xcsR
         T/QPmaeUQBd8FhOxgDYxNA8Ip2FtEUcYpjEyp8qMIONWVXJ/w/RR0xt9NHL+N5mlrf26
         yj/VSrS6WY2R/wF95hcdxmsdzVBeI0UFZYmTQ/8kMb0h+g4vF3yZlrTKbOhlknEu7rDw
         lfF7uskqPrwDmrjF+oFQfInhlXWobLBB/zDZ3/Gvi5fLqEB1Tdtl3N8Yp7+PeHM0p5pV
         jq+g==
X-Forwarded-Encrypted: i=1; AJvYcCUZHVYcjlkiUSq2+JqfVxisS0K6fTETZBR48/k2ETTKP7+ujda7IRW5tRH3WTNuhTXBmGTTTec=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYxFpzs1hPVLjR0/06iyXhA9Fqx5/2pTMo6QcpMnUQnoOSf0iw
	BTl8kw0x1lZsjRIq/trtWn1MJNcBVLkegpZj0GPygItdTzQ2RXI75H50Dep6oHrKxOEH0wa9u2C
	y5xCU6SRmNd5UpH4M8xK0VL44CZFWadnSFWwC/7KuGQPHNdw7WhxLEg==
X-Received: by 2002:a05:6a21:70cb:b0:1d7:1288:8338 with SMTP id adf61e73a8af0-1d91c67ed78mr1794367637.8.1729122120477;
        Wed, 16 Oct 2024 16:42:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+tyN+csLyQUnT9uKINp+hL+NqU4o7g/V+geCi6P+KQTMn6I9oukq4ftiXvXhp0EaqydKsyg==
X-Received: by 2002:a05:6a21:70cb:b0:1d7:1288:8338 with SMTP id adf61e73a8af0-1d91c67ed78mr1794347637.8.1729122120121;
        Wed, 16 Oct 2024 16:42:00 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e773b2e54sm3639412b3a.71.2024.10.16.16.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 16:41:59 -0700 (PDT)
Message-ID: <4186940e-100e-4a4a-90ac-d19eeb0eaa47@redhat.com>
Date: Thu, 17 Oct 2024 09:41:53 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] arm64: head.S: Initialise MPAM EL2 registers and
 disable traps
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-3-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-3-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
> This register resets to an unknown value, setting it to the default
> parititons/pmg before we enable the MMU is the best thing to do.
> 
> Kexec/kdump will depend on this if the previous kernel left the CPU
> configured with a restrictive configuration.
> 
> If linux is booted at the highest implemented exception level el2_setup
> will clear the enable bit, disabling MPAM.
> 
> This code can't be enabled until a subsequent patch adds the Kconfig
> and cpufeature boiler plate.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/el2_setup.h | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

