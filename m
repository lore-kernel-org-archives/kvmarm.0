Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3472A168B1
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 03:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123058; cv=none; b=b/54UDXglIl5Pwo5XpocvvJ1rppqSPRghMXDGZ3gZApVbKED8NiAVxeVAT8LqiPMLEs1r1IQz8M1bFz0Ny6AA+8E7XHDoKkXzqeqrG8u/c0SLU76A9VNpVximuQzGru7knrG86XTs4w7t2RoIf6aXZ8T0rEhui8tdnSRAF1VeyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123058; c=relaxed/simple;
	bh=w1SayiDT6fHbjeRtPtYcD6dD/o7ljGA0MzGpca4ixSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RDkCgI4nBt9iKphsHKrjl+zm67pwYVhXVOgnCRtTa/fpXTOHUkJ9Np+H+bRFvCWO2mFUTxtMdh4TTwqRRuszwkF4r0QGdCBlJEP8RCvpgmR8iKHmIxz4+vYEcb5fG0dcAs7a1iZ2dbPf9AeRZGy7aPJbkTXeSsezd+oJ7tfdiVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glfDfJHa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glfDfJHa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738123055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zB7bwFdWnORe6bKwIQ/6vJQvYuugxQ4y04Yn/yJKnPc=;
	b=glfDfJHajjkpoKDbP3N33S3bXnJA7RdqnC1+DmMqevCoZGr6Wb2eZ/iwYppMR6D+URFx+Y
	gVTtyPluhFS3EyBMMhcs8XZ1zJJeBfDi/zLZRJedtt+PUho7NbbAdvNIT6MlvZXA5oo6wa
	uPVFW2N6QiIDeoS7vNGjvyPTclXhItk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-C4g4qMGXP2W0BJQMhqEDMg-1; Tue, 28 Jan 2025 22:57:33 -0500
X-MC-Unique: C4g4qMGXP2W0BJQMhqEDMg-1
X-Mimecast-MFC-AGG-ID: C4g4qMGXP2W0BJQMhqEDMg
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21655569152so129203935ad.2
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 19:57:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738123052; x=1738727852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zB7bwFdWnORe6bKwIQ/6vJQvYuugxQ4y04Yn/yJKnPc=;
        b=v0WXAmKQtPW4hYjLYUx/S7HUbji2AuliiZzCo2IOoxYSdsStaV7D5oPp50gDcvHqk6
         NjbM+Mj5PltYC9RgbBphRhulZGD6l5VGFjhClOaJEk7JGcCgRmIB5xLkmVvOeX4mfTDK
         YnreLuQZQ/rOPwidDtKYAraEmp/s9BjnwpxWEpvFwNRzAqoCE1MTMgPSAptW7Y0Q1xcQ
         7ZcQosIroDYKovG9LSS+Z1QoPSNVOREW9KnwPcghw5nAb4FKot71eZ48GuJ8VxHkseol
         bgSeq+AHnLJ+oEWGnVLI4DzT0UvzlksyByYmQX1oLaFQgf6C4MTbBy3kAVnLXLKjyfqz
         1knw==
X-Forwarded-Encrypted: i=1; AJvYcCUSaFz4enXYIhFqPvblHT6PpSaDRVhlPJLt6UWj6B1ZQsbZg+MZiys8CTyvgezhUWttMKDnTBU=@lists.linux.dev
X-Gm-Message-State: AOJu0YySjLn0eb9gXlVZZZCTXm168ep4IBQI/CnTVZ9aXmoB/IqRr6pE
	d8RqJ26d/xwBihINmIwDGcJwYf/jln0I8L7relbVaNF96SQnEtsQ83C83mA8dBhMJamq7UmAoHf
	ul+SIaVntoE9sv23ZmB5rSJDih1gKgMlCUAnT/bwUIomuCjg13f3PjQ==
X-Gm-Gg: ASbGncvFY+o29H+ciWtoj3hYj3JpYkSiamf49BgJvp9DNcVOY+eocP2VvbQjitabsci
	nj7T/axg9ItYUiOCVRSRju7QpCCnsc30FKKLOiX3lR5a7pbDW3ZueWiPl6kzY68fF/+AUC49oPa
	GAK3m7bv7vl2Nwy/pIM+InquIUo21yHBRnTu8tslTmsorPc0MlzlUkTvgXIW0YZ+yNoE+xe90RO
	I+ObHbiEvo9UHlzUZW9KhMbtIMUthyRFxR1hymaObJ2Nw/7olT9KNAKk10yVoC2qfCnA6ANI1b7
	8bQtpQ==
X-Received: by 2002:a17:902:ce8f:b0:215:9d29:9724 with SMTP id d9443c01a7336-21dd7ddfdc9mr26688225ad.38.1738123052540;
        Tue, 28 Jan 2025 19:57:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdY9KvQ422zqadztWkjkXDL2LuY//Pm08gZwRPHxwWf8KuGeFvCcuuj/IQ8VEC/M+7z5zZXw==
X-Received: by 2002:a17:902:ce8f:b0:215:9d29:9724 with SMTP id d9443c01a7336-21dd7ddfdc9mr26687925ad.38.1738123052171;
        Tue, 28 Jan 2025 19:57:32 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9cac3sm89760675ad.38.2025.01.28.19.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 19:57:31 -0800 (PST)
Message-ID: <7271b3ff-8665-4a98-b3dd-77417f85d5e3@redhat.com>
Date: Wed, 29 Jan 2025 13:57:23 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-7-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-7-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dUAy-eHhRlCLf-8tvI6L1hhTB_fPBNtf5KD3tdTVGi8_1738123052
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Reword "unsupported" message from "host supports" to "we want" to
>     clarify that 'we' are the 'host'.
> Changes since v2:
>   * Drop return value from kvm_init_rme(), it was always 0.
>   * Rely on the RMM return value to identify whether the RSI ABI is
>     compatible.
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  3 +-
>   arch/arm64/kvm/arm.c                 |  6 +++
>   arch/arm64/kvm/rme.c                 | 50 +++++++++++++++++++++++++
>   7 files changed, 137 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 

[...]

> +
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +

kvm->arch.is_realm won't be true when kvm_rme_is_available is false. It's set
in kvm_arch_init_vm() of PATCH[10]. So it's safe to be simplified as below if
the changes to kvm_arch_init_vm() is slightly modified, more details can be
found from the comments to PATCH[10]

With the changes, we don't have to check kvm_rme_is_available every time.

static inline bool kvm_is_realm(struct kvm *kvm)
{
	return (kvm && kvm->arch.is_realm);
}

Thanks,
Gavin

