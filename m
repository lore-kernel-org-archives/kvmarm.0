Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB93145B1D
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536586; cv=none; b=CQxLW9NVVLjLXWhNBVVoPnJzubTrmqRCsTwnZlO2emISsXGllkSqvNN/mvVJG3HfRCw7TntDkSJ9oyueGTu3pIJ2mJZMPfnRAQpInkixNhFA96QXZh7ccp/It8iqRPU7HSnlQO0TZVy49bw2QzjCvEW9yJR+aGooOrvsZ426NBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536586; c=relaxed/simple;
	bh=GFV6ThqjA7P1j+j9aPj41EwVbGy/FR2dC6pzSUUD6No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=de3tAQMYVdBm0NYMeRQyPUqDglk8IK78KSm3ddLKTzuXH4mJAzn/dHpUXOGgsfyJkX1iTIBtEGCtlxiTyPHQMjf8+9XTt+t6MccAqhAJPK/dmPw2f+lz3iN9Jo83BF80EfmxzhlF87m2vbQPSNz2WA3bQo4nOEDQwUBTjcaXS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6fo2xXI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6fo2xXI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734536583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mC6GNR2l7RLB+cS0CfyRSpwZEUR6W5v8iITbSAjRP9w=;
	b=L6fo2xXIMAjL2RjAad5c5is7DbelYqjYBLV1taQPaRVTRiYzww6rdefIHPUSQqWE37U3oV
	11WYHHPPlAuRl5YyKYXLaHat0IeBm6sc8WDkV5KejwUyEXHR9C+r4cUFHCLjSeWd+m5p1h
	IAz2Cz36M/lJsvTEts4aj36kWQ6eDxo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-tMH2W7k4NNSjdYI199LvAQ-1; Wed, 18 Dec 2024 10:43:02 -0500
X-MC-Unique: tMH2W7k4NNSjdYI199LvAQ-1
X-Mimecast-MFC-AGG-ID: tMH2W7k4NNSjdYI199LvAQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385f0829430so4493090f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536581; x=1735141381;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mC6GNR2l7RLB+cS0CfyRSpwZEUR6W5v8iITbSAjRP9w=;
        b=bBgukAxmqTs1pAHj/oNHg9uca3S9VzKZPnSMAPD16p5GjhYl4uovHwHBwG1/7mzF4w
         myn+jribbjhPv4CUh5fqQkqL4rm+A0jFymi/q7d6h/u0A/U946RQdddB4tQ+litbIlF3
         oJLvr+YrC1mhN5OQJyEYtZInpOpqEQZJ9ensOLESLtTxzn7Q3Ho+vf8hDURc43BRcrT7
         S5Rwj/9IxcgT1r1hims2Zh9Jm2MQs/MZWSu6Cff319yPFUUE7uda8s+loPckG0sqdp6q
         ZkYAOJPlivTZnhhr+bEljlKAvlvXeH9OX6xVWGgAkCHQ5NryQVlP5o+wOjCxKFOWQatt
         r/mA==
X-Forwarded-Encrypted: i=1; AJvYcCVR3I0QBI36WZIiInWfXYnqOMjsX63/FFlyhaqOUiqgG+YU5PXa2BcZl1zLToajlFFPsJU0BZs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz56fMhaIRpDZj4kS9trPt7lXu4u+Er3YIo0pChswjEeC9Efh9w
	oUXzPFY7tXFTv/iLMO69YOGgm9EFvoUqFb8WlE4WtRD49RALb5rUBxFDKLdaD8ivfDMbxW5AOtG
	iVC0eFcbhoTt8ceZ45/qXlUK61yJaMac3WxZE7Bjxgh8eUDxcBs1L0A==
X-Gm-Gg: ASbGncvqFzVShVl5bukCkdzSTiVm9cSr0yboKUunkW5mf7XTPf5kuTCudEpb9fWovUA
	HAtHVDaiJUFTL3iSWqYg90T/VyqNBYRRvMZvq4LZ0blwXZyhhdBKDP2uk8FWyVWVMv43JjsgCXU
	E5a2AboNYuqj0WHYhBi32m1ptdERzjmCh+948gbEUOiiXt9CU1rSlkP3c/6D2rRrd2Qf1alVumJ
	ZIPjyHxio8J4X81T6ERQfniEutMAJgADwlGbWrulE100Ly/rMsNWtKwFNZQq9HWs+QUt/A38EtR
	7gOn6dY4UEzpvSKjBZrsw0A=
X-Received: by 2002:a5d:6c65:0:b0:37d:4833:38f5 with SMTP id ffacd0b85a97d-38a19b12fafmr60396f8f.30.1734536581293;
        Wed, 18 Dec 2024 07:43:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG/rD142Fp1t76CSrw37ZJBcAB/yQkKROpo9q/NSr0NTTkPonWRbLpbezaH6E7Ufy3aQSVNYg==
X-Received: by 2002:a5d:6c65:0:b0:37d:4833:38f5 with SMTP id ffacd0b85a97d-38a19b12fafmr60378f8f.30.1734536580973;
        Wed, 18 Dec 2024 07:43:00 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c80163b8sm14111070f8f.35.2024.12.18.07.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:43:00 -0800 (PST)
Message-ID: <5203176c-2646-425b-b375-edb7931ef54f@redhat.com>
Date: Wed, 18 Dec 2024 16:42:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 15/46] arm64/sysreg: Add register fields for PFAR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-16-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-16-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FjRBfmQ0tmHFreK0cKW-fLVwpITpdDPrvdLc1-cNuls_1734536581
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Anshuman,

On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for PFAR_EL1 as per the definitions based on
> DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/tools/sysreg | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 18b814ff2c41..e33edb41721a 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3533,3 +3533,10 @@ Field	5	F
>  Field	4	P
>  Field	3:0	Align
>  EndSysreg
> +
> +Sysreg	PFAR_EL1	3	0	6	0	5
> +Field	63	NS
> +Field	62	NSE
> +Res0	61:56
> +Field	55:0	PA
Just wondering: part of the PA definition depends on FEAT_D128 or
FEAT_LPA and the reset field value is UNKNOWN if the feature is not
available. Shouldn't introduce separate fields directly?

Eric
> +EndSysreg

