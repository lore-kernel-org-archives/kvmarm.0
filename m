Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C1279FD
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 00:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347533; cv=none; b=s7XvEsuq7MluMhYqLMxffDFDOckQyVZyJBPc1vQSRAqpCHiOC8h/HNzlMpPtu8V3Uh6DE5N78LIlJAK5RP7C7na8qb24aw9vLgtm5qXJRCpEJwRzF77gfd24jPyqlotRQvBbZkQ6pHNnR5Ae+PQIOxrVsii6AqrkWI/7D5qF8FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347533; c=relaxed/simple;
	bh=A9AMI5Ezhm9RDe/MPTYKXI8Tm5VhcV24JBDXVYsjs+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8wsfy7D0gpdwAz2Dci4z/REnZHV/AztMOPoStYN79TxoGHHMFPGNCFd3ruisKil/HzuXVVcrdBJrNoey356h365k5SYAccPXEyVf/DQs4786x3GXUBH7SBTgpgJYd/is8pj9foASw/hPFADMJbLi9Msr5Xyu9Ubf6PtOH+O37g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=humjoJwE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="humjoJwE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728347530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2t8/t87oydMOb+fbPCK5eA4VfKKGx5GRAmEejqA5qo=;
	b=humjoJwEim+qOlMIaLMncCIX3FX5ACxhoc8MZdyAAcUa+klvjVlCf0UxoPXsZQrsQy7ghu
	hkVZ6HC+1YCZ0l87uEU/X9L+Rf2CPJQNXFcg4vakNdKiPwjOUQWtBd/B96JHjlbDg+o8KO
	FqWvu2KRObhHu/BqCpBZbJ+fVSsoRbg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-AxmKK_HYPiWFALkwLX858g-1; Mon, 07 Oct 2024 20:32:09 -0400
X-MC-Unique: AxmKK_HYPiWFALkwLX858g-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20b096ef923so41059705ad.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 17:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347528; x=1728952328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2t8/t87oydMOb+fbPCK5eA4VfKKGx5GRAmEejqA5qo=;
        b=eWUHA2tAYWMQqTZ6WEkcuuNMwa41AGftmroaFAPDx94lOi7TBBQLuzJDA8lHFwuNSf
         /Rqd15VDN+op/s2wAQlYXhJvYg1GsPQxLItIiWEjuGE6WMWa3DaxRjiDiNEzIg3rQQbv
         2ew3ZXQm9vyMHa9M/vh4NOfaDtoMPhC27jed6VI49bLhqat3jtNaTgoOYl9y1JN55ZEF
         8hQB/W6H1Oc+cEqP0qkCPCqV/ZTOAw/QxSwKgSrpXwkQ28vp0QdTPzOcFR2hSHNfnBQx
         5Zsn6szKl6v9UlcIxVpsCFMVD9K37dEbKisVGu/sZKCcdyzOvZVQzscTPv51I1hshTrC
         XcfA==
X-Forwarded-Encrypted: i=1; AJvYcCXDZmoMkSwU+D3+8yE7L+SZ4sGQUSFX3W8MAjgLPuflUZ2TGw+NabT2WX5mkrm9PxcdJg010TU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVdSoW5sDO7qvapJL8AOeBb0or8B/iUJGwVLlP+wmGIaU7P9yR
	qUuCvbEN+EQBkvtze2iQDuC7vF0RZZieilbm3/PZqnDvkKK9tJsthiUmjRRDqoZO31JBiR3k9RF
	JA5nvGm3HfAcxb+QQRL/6jRchz4r8xidbMn5b3bLnTyFQXVsDWzoM/g==
X-Received: by 2002:a17:903:1c7:b0:20b:7633:6e5 with SMTP id d9443c01a7336-20bff045264mr190222725ad.50.1728347528634;
        Mon, 07 Oct 2024 17:32:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhKzITncWA4Jo33JtZVn5xzhu6oYqOWO2GtB36kaMCjLxz5smSPbxD5lo2WdfhzKIooRXhxw==
X-Received: by 2002:a17:903:1c7:b0:20b:7633:6e5 with SMTP id d9443c01a7336-20bff045264mr190222385ad.50.1728347528325;
        Mon, 07 Oct 2024 17:32:08 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139316e8sm45047925ad.181.2024.10.07.17.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:32:07 -0700 (PDT)
Message-ID: <545dbeb2-7ee9-4f38-8340-67682a917488@redhat.com>
Date: Tue, 8 Oct 2024 10:31:58 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/11] efi: arm64: Map Device with Prot Shared
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emulated by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Reworked to use arm64_is_iomem_private() to decide whether the memory
>     needs to be decrypted or not.
> ---
>   arch/arm64/kernel/efi.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

