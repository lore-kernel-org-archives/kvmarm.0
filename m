Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A291F94D
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 02:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728355894; cv=none; b=AnywMiVdKES6NatO4ykIwz3WfwQC0YlU6sF/rK/9CBb8aTdPjwZOpuETgJxDw/9AOxhq5ptRBEane3UFVGB4ks4X8AjwpqK8AXsRK04DOBUPjxBbl9f4Dzu8FEuSOx8Xrh93D4hmeXuj/qua8AIF9VDpuOQ/jUdHH3VWbKXz6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728355894; c=relaxed/simple;
	bh=fLMDCQsubowFDRbzB3GNMUKP1kvwbKmtntwMRelY1Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYsYudko/4NZaRe5XADvrxMu5hCD8Xub9mzO5SxiSrZD13veF4WM3rXMgPAtPsXTIg+oIjots6KDrP98pRzoLHNdEB67+huwf6p1hubDeYCsCjz1ADOF7cvXjFv9aTfFb+YoxcB8/ziqvvH09IRXKWKmVlO1qUBR32ZUU7BFXC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8R8Kn7x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8R8Kn7x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728355891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4sFhYYgaf5zWGjjw37V+FmIhrEBzr4NtQ/62b1VBOU=;
	b=R8R8Kn7x6EhOW6Hb0s80a82qjl59Gj09uAMIIiOQ/uxyoMLheWrYs1it3dJHjO9aW58WT3
	U0pNqnO2F26ypbcEWMz6lagVEUVbDoA5PTx+nw3TX9ACefjrP0n3K/thrfP17K+etjL6gv
	z441CipZ2jF3Rqd4V1VH2K9ppTHhv30=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-U95LrfkXNPuGPejyl_Tbcw-1; Mon, 07 Oct 2024 22:51:30 -0400
X-MC-Unique: U95LrfkXNPuGPejyl_Tbcw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2e08526d9beso6829236a91.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 19:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728355889; x=1728960689;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4sFhYYgaf5zWGjjw37V+FmIhrEBzr4NtQ/62b1VBOU=;
        b=mgMu2k6in+aM7OqQgTN9oYnnqNQ02BKPSznj4JnGrPyD/+wV/phcLC441zsaHgQmrX
         TeAnO0c1E4uSW/pTb70BwYMXG6T+xTkryWEcvssh16p4GK6ro2vKcW00VbVx1UCKT/A/
         mfPq5OO1rraurd1A+xBrUEE1d5yEDj7N/+R8ZYHUmByI+sD3C0gM5izfGN6ZUUyDA9pR
         g08ubYKVRSLdT3qqlkq5qhqCqXaiPwso1Q9CR81Rk2dH4ERR0l2wT4UgV36+3Uj9Z4RK
         EIq0cXG7DtkhWBA5/Er5xnAm3aVUJ3y7BafHcZPyXrwNT4+DxAQQkJ2nt7UyxQzYLUZ4
         RtiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuneC/VWz3Ok/zaTAmxKXCmCgQwB+rqRp5TfNTp3OLEssyJod9oq3rPO8wda5UUm1V62/9dP4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMqPo14RyBNnxhEJw6ln0fZ2/5PYtGH/xOn0OHkB1528zOQLoZ
	VvDD7VtjFDpqv+TjSZyRKEJp6kESPdggC8amia+OZsFZh5GExck8yfmAlCBu23P49nwXXLCxGpM
	kY+2deQMejFPiIMjKpXBoc/8tI2VjL5clAU+yoxLQEAwp6DTfGu3AZQ==
X-Received: by 2002:a17:90a:3d81:b0:2d8:8d60:a198 with SMTP id 98e67ed59e1d1-2e1e6366bd6mr19154110a91.37.1728355888981;
        Mon, 07 Oct 2024 19:51:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1a155oDsYUskhbrb04GQtySwR7IiTCMTLOrXqEs3PGt+CLIahMwaNAu0NiGjx/qhM6odUKA==
X-Received: by 2002:a17:90a:3d81:b0:2d8:8d60:a198 with SMTP id 98e67ed59e1d1-2e1e6366bd6mr19154081a91.37.1728355888658;
        Mon, 07 Oct 2024 19:51:28 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20b0f9c7csm6264516a91.38.2024.10.07.19.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 19:51:28 -0700 (PDT)
Message-ID: <01f08a52-3b96-4384-b9cf-aa74ea1d5faf@redhat.com>
Date: Tue, 8 Oct 2024 12:51:20 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/11] arm64: Enforce bounce buffers for realm DMA
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-8-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-8-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> Within a realm guest it's not possible for a device emulated by the VMM
> to access arbitrary guest memory. So force the use of bounce buffers to
> ensure that the memory the emulated devices are accessing is in memory
> which is explicitly shared with the host.
> 
> This adds a call to swiotlb_update_mem_attributes() which calls
> set_memory_decrypted() to ensure the bounce buffer memory is shared with
> the host. For non-realm guests or hosts this is a no-op.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Simplify mem_init() by using a 'flags' variable.
> ---
>   arch/arm64/kernel/rsi.c |  1 +
>   arch/arm64/mm/init.c    | 10 +++++++++-
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

