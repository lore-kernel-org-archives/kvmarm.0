Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC86A2AE93
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 02:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728355944; cv=none; b=QXa6e+HbJ3J8w35SRdd8VNChgdCWpk0oA+3R683xge8MVFN96U0kN+wDFimXNcCQVhXnTTpPG5dHwPvSZy7UV4dG1PftjUT/AxQoreyaJK8H6vUzbE3nF1vpF4pINKVJNA8DS6FPEo/toP66HRAL6qbDDpcYl2Si3wz0b0JLrfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728355944; c=relaxed/simple;
	bh=tSvTHzhJ7hY0Co3waacqVaZp8uierrT18ii5XkgbO2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HEik65IsDUS8PwhJGAWI8Tp3Q+zy2WFEu0ldxQkXD12Vq5DyNO5AX+uSZnN51LUW6GRnd2BTmrwOIQw2OW4Jkv8QSJw5eF9J1w/beYyKvJCD2WHt11xATdTJZRY2LkPMYODmymAE5egF++z4WRTQsAeqNFFk4HlEurmHxK60Il4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyE1Ff0N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyE1Ff0N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728355941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=411PCtmrgkUidrOIqeQapBevB2yXfvIcGC2vMMOYdOE=;
	b=EyE1Ff0NJWUYugIiBG2lbiNBtXrbP5WQk4mT5S929b/VynR25biw4kRqpNyXkuW2vFKizU
	zWLEcyCIEovzcvaRj5VXQSrP3K0ltH1BQm5CIVt9MR3G5BLH341Q8kKR31GkYwiNAIXUq0
	FIAJRHUfnq+dUd23ubpWnU5oms5uWTk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-xaYQxBoLPq2lhsRyaqbRyg-1; Mon, 07 Oct 2024 22:52:18 -0400
X-MC-Unique: xaYQxBoLPq2lhsRyaqbRyg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7ea00becea0so2858013a12.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 19:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728355937; x=1728960737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=411PCtmrgkUidrOIqeQapBevB2yXfvIcGC2vMMOYdOE=;
        b=I6z7oddBz7Km7B7D/3aORRftJyu47nYajr4FpV5uTKoM2g+J8762esLY5AXpwmk1sr
         S3A4fh9TOJW2aviVfuduZY9urucb0K6SRw3kUTilEOz+xZqOi1vEAjepO6Q0fEofCYc4
         o4TSR9IGgbE4feHEYFTaBdTS6cixJaracL8hVB8CZ/SXLATwn/iCO1jMKSFer8HcY9Qu
         x9wQCJJU90mDg5P95hK6P59ZweNyrDn9epobWb8vE8/c3R6gzxEDwmtmRIvNlYVcHRWf
         df0o1MXoXTLDpqtpUkVlwYM2/gYZ0KlpUWHuwd6VQB3hUXu7UAmq1PJjKy64Jla31GzI
         BOUg==
X-Forwarded-Encrypted: i=1; AJvYcCVGYo/ZLqxA63YjJAHRJMalYzjQEBN/yWbL89zCDC+wEpDO1oxHDJ8Dd2SDtMp9hpl5jI2h5m8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEuIM/jXU21cuOZigFRuSfZaKPZ8/68xk4nE+h67sRn9Esu82H
	ls+0WsCPoJJe6b7msj6PwoKqeLgwOaWZFxh8LFL6VeKRjzzQ800knFT7UBwvqaU/XMXAUQmRuJ4
	AzEXuaXkUpsJuF3XooAZ1aStxosw0bIgN4zVb52Pqpawazh2pV8V2mg==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d6dfabc386mr1247892637.35.1728355937670;
        Mon, 07 Oct 2024 19:52:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENsa/q7SoMe551s0e4cZsDtqunjGqFm6PflV4U0LuYkndGEcrIqyHC1aiUGs/dtevm0SUCUA==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:3d14:6921 with SMTP id adf61e73a8af0-1d6dfabc386mr1247865637.35.1728355937364;
        Mon, 07 Oct 2024 19:52:17 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cd2a1bsm5112671b3a.85.2024.10.07.19.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 19:52:16 -0700 (PDT)
Message-ID: <85192743-4bb0-41bb-8ac6-6965cb149307@redhat.com>
Date: Tue, 8 Oct 2024 12:52:08 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/11] arm64: mm: Avoid TLBI when marking pages as
 valid
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
 <20241004144307.66199-9-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-9-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>   arch/arm64/mm/pageattr.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

