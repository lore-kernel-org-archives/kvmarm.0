Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB63E1F3FCB
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 06:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068194; cv=none; b=D1izG+dkCTBcGam3srbz/3M1m3G8nO0LVIIxMn9BkXK4v6lInmgvYE/NaPkYNuoVMVl7ySsfCJ9PwzOLcijTHPCDSPfqY12prH/RNTXfiz0PU8SXJLcv2utNXbOnwJTItdggcPpJ4S2TaEE9GmALMAyvFu+NTBI2w7ykgS29vBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068194; c=relaxed/simple;
	bh=yzDD33Es1OjfbExLpccU0Xk3cqZvakHg4nxFLrMGGCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHo1SPaSaVdeWi6MTrsbITk3pDfDLmPcsFrRht21P0Ij4ONmhwTdTRCg5uX06rUX7wHWIVKNDFQXTc930v19JV2e49bmFU82WVQ5+1QQZ3NdTLGGQaoMY2DmZYwIjo7VzmXYLrw6f9Uz7yAOOzA6KbLHryxXYkMTS/62A4vJwtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjilDK6r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjilDK6r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYQ+hp2BxThyEpl72nHuJbwMjHhQjin3JtMynxdNsGU=;
	b=fjilDK6rpNLhV/RWYpt0iRngQQ8/EnALK5FMUhLQp9tSHl4EAFVCwQDjfwZUV3wVgwDvf3
	Ow9o7Haypd9hQoyyjy0En5Hs7hlPI28EJrFjUSpYl5lkh78lAyrcLy9pKZrlin0zWc5Ia+
	yz4OloLN2wD51mqu9LJANUSlDFN9ZAM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-zYHUKzmcM0a88Qx2dH7blQ-1; Tue, 04 Mar 2025 01:02:55 -0500
X-MC-Unique: zYHUKzmcM0a88Qx2dH7blQ-1
X-Mimecast-MFC-AGG-ID: zYHUKzmcM0a88Qx2dH7blQ_1741068174
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22331df540aso158401655ad.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 22:02:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741068174; x=1741672974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYQ+hp2BxThyEpl72nHuJbwMjHhQjin3JtMynxdNsGU=;
        b=uVgMXVn0f2Yula+grBzlW1VyHqu8J5Bp5jnzfTI6vcgo6QLFnk95zRXdS14+wiXif1
         aZf/2tBsr6zv4lt7iGzF8XxIf0b4MJFiD70bsN9ex3gbe56NJkLzI3KvDhJPBxBmrdZ9
         aTTBV65/OevCaBx8ClqT/vASdT26z60jKSfBccC+UtVT5xM8+1bZM2nWtfeXblJGL209
         tsqM5wey3z5Rp8FkjuW+mK5qeKnkRL79Qa6Z3EFFM6Jq6FKFhzqhjXUfUyEnEAqnu0gE
         ZK7pyxtsBCZtQfCb1Q5EPPrcALUlxD0lH/VHcxynx+hAJblJrLHhQZ9PVlBLf/WMkj2W
         9U4w==
X-Forwarded-Encrypted: i=1; AJvYcCXjFcJOEo4FwklXyfTrsKXDjfeWfpg4HEHJFsGuKwZCk25Yjho0SJkihQ/CERD0poJBOnG4U+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX9h1kxaEqpyTx3KT8oLtiaOlPq5JyAAtsQUuqW1BDUpkXb8l1
	50y/OrXS523W+8byVcF6Dr/yHRG0yXRqe5bj1zBCI6jgZtw9XRRTvdBu9LDek6EaQx5F4Fnw8Si
	z3g9kzPI98i4ebeOxRbroE2GDPl2M9ro8hy8dWI74hoSAYhNKfa+NHQ==
X-Gm-Gg: ASbGncvhoLf0DBAFwjUiS+YOAm69zctclRfEy1dmHKbn3G8c9tCtpJI6Y3LeWUOmUx2
	o9UVfs4okNXuEwggjXbKXe2h7gFadxymj3qfnfQVX+53jLNhffDqiahrao7wrdC72FTfTUY1iV7
	oGMzFJgycbWircVPHVQO/oKUFzriLVtSlXhE2DJ3jyxLGS0PK64XiekMWe/fOXGCQxjZe52aa/J
	QJRrFAx4Tux85FbGLnzs6znr8msTltFO7XL3VC2eYrli0H9IIVl3WL+KFFMbkYcNFU0fMU/HhvQ
	slp0yTeT89Kwmehhcg==
X-Received: by 2002:a17:902:e84a:b0:220:c143:90a0 with SMTP id d9443c01a7336-223690e0257mr268865445ad.24.1741068174605;
        Mon, 03 Mar 2025 22:02:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF17jp+SvVB8oKouybsWd/JrJXK2VcB5np1hjZzRt0dKWL0IvRPywYjYwGiuuPFEXE57B3yZw==
X-Received: by 2002:a17:902:e84a:b0:220:c143:90a0 with SMTP id d9443c01a7336-223690e0257mr268864905ad.24.1741068174278;
        Mon, 03 Mar 2025 22:02:54 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2234fdb5b02sm87962675ad.0.2025.03.03.22.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:02:53 -0800 (PST)
Message-ID: <5587ca83-bb19-42ae-8297-676588502e5e@redhat.com>
Date: Tue, 4 Mar 2025 16:02:45 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 29/45] arm64: rme: Allow checking SVE on VM instance
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-30-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-30-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z1KPgfEtKfFRrDRdazx5Fty-QRZoG1H2sJocBoBdAoY_1741068174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Given we have different types of VMs supported, check the
> support for SVE for the given instance of the VM to accurately
> report the status.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 2 ++
>   arch/arm64/kvm/arm.c             | 5 ++++-
>   arch/arm64/kvm/rme.c             | 5 +++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

