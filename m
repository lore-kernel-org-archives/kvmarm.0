Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448991C173C
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070858; cv=none; b=TaizWEXkPRee77/S02Ny8dcY77RJBAau9jmYZbJFh6B7MZMUscfnvvJQRLCCNPKEvHh5GOZNqeckTcIVM1hQpKFZ6f5CJYjLq71yQi1jicliRt61/BjWBzNtkx8dpBAci0G7b0SAV1j3ymSCnNj+2IIW+vF4QggLz/roxr7SV3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070858; c=relaxed/simple;
	bh=bh50DBjTplxiLTSZLJtA78HDHGJdoYyqa23SgjBMZaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzfGHSOTjGcme9MiDtuHSoVXmSY6ydroDmVkLvunMEx8bibJe3PjKgcO0h28DUXSCOz44Geax0AcV9EOrHvu9+ytKfkpmb/ff0blVJNVujQ/Lm9EtYUVOrxvlL9WDH2KWbRCHapP1lU+orZHP3OwUZA6SjuHqrUiuneisoFtBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g1nldZIP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1nldZIP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBzfpKZnt5CxAomKzEA1Dj2dpRWqVssdq1NJBzT2e30=;
	b=g1nldZIPuoOCTXcHfX71pL5QYQTEEOQIDxV8bzSKCr7m0qoPY0wFTYAwn1D9RANQfrZ37C
	enZ6Z/riKoBHvwwVSVpPR4rv7c7EHLh5svTPyNUAMF0rIdZeNNejMXRAgffOsB02vQ/Vdh
	ukLkAwmZ3zTHrcBqnfeeOAKSHSwJJb0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-2w8aDxhQM6qlev4JUvaxyw-1; Wed, 30 Apr 2025 23:40:55 -0400
X-MC-Unique: 2w8aDxhQM6qlev4JUvaxyw-1
X-Mimecast-MFC-AGG-ID: 2w8aDxhQM6qlev4JUvaxyw_1746070854
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-739525d4d7bso469254b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070854; x=1746675654;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBzfpKZnt5CxAomKzEA1Dj2dpRWqVssdq1NJBzT2e30=;
        b=ND+/sD+Q9kpFMem/jbrnVfClCDKRq+H/47wfqgIwm5HWfL0Hv38Tpxw9dB8ZNw4cLS
         vTHp9M07BoRyIe3yM/ucsg6gq7duZXxV12M3dvaFIItx6yT4dgjYgs8SwhzKt/i2pQcu
         MF1cxiD28mq9Q6ult1O3ErtQDMN5DEn5RCM4a5MKDHTwMqWS/ESDCo6otwJVDDrpOLTp
         T0avdaEcrHmpeUNcdbUvpjU459TqfXuNIr/4v9BPPlhufcnFWxXVTC2tN6bex6N1yz/F
         Qovrsez8PFF+9iv7pJrY2MiJMDkxrf2lzlA4Z8v1U6iQ/MOCKUgijZgfBILzh+ZKaRkX
         NW3g==
X-Forwarded-Encrypted: i=1; AJvYcCUCof//ED11PP8bmO56BRitEHWd3NIlUdgdlzt4c9w8KEg4e4F/q2IKW9vYdWbJFDiOgbQDNBo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw84AJ00dtfvwpCcwXUZeY9GbkRtZnbjqyTZAJqPzndn69lGdvh
	zwsFWLW9iXpvSrhCvZaU5wFCyFuexKUhOJKnq+vIOvdgsTjHiFUHNQO03/5PHWOOi7l29hRaQBU
	l83UPMi0sqwubyN/l/rj0bI/hbBDZ/1otjv/XFErRq60v7Dy+DSQ+kA==
X-Gm-Gg: ASbGncsv1cBPk6OFgPbBtLfeQJsEKjHT8DV2OOh/i1ly38lj9lMGTzRInwRlbhztJ2O
	SXxOzZ1z/F9gq0OgCGcsBnJRob73JWk8bC40I8+bzv21SFELe8cSyOvubGDZfHUQFLGLnh2Bfd+
	WyjwNFEi5gyrcj7Lpb6AC3F3ejUYWPOQFvYoYYq0Yt4TXplVo2ChpkrRA4sRDtcM6P+8OjeTxUH
	5UufQ42Z1zNDMG35wl+gGrjdoSxsMmhUeb1nRzMCOxwdtjBO6nNh1p7u02qo7+Ni5ua7k16giwx
	a5tLXMlswvmg
X-Received: by 2002:a05:6a21:1788:b0:201:4061:bd94 with SMTP id adf61e73a8af0-20ba74f9efemr2316696637.19.1746070854026;
        Wed, 30 Apr 2025 20:40:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcdCIV/XU+3thu81d9MiACXjb+DjhRRhcxhdfe4+xkJBBdN6cJ+Wf09/OtaoBNYxBmSezekg==
X-Received: by 2002:a05:6a21:1788:b0:201:4061:bd94 with SMTP id adf61e73a8af0-20ba74f9efemr2316662637.19.1746070853706;
        Wed, 30 Apr 2025 20:40:53 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a2e75fsm2624953b3a.98.2025.04.30.20.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:40:53 -0700 (PDT)
Message-ID: <0be0479c-13d8-4fc9-9128-a3d414392a5b@redhat.com>
Date: Thu, 1 May 2025 13:40:45 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-35-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-35-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4E54UjdFDEe6PbysHETzmEkau7CNP6Af6kisrx0DUCc_1746070854
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

