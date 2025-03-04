Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3441F3B8C
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066807; cv=none; b=mA2B67FlLfJSu0GbE93VqW2+U9A1CuxaNMU2hFfMC1DxLm0PRsZsMSHWYaumM78XRtiJwPXyl8xcsvvYftskz6laEf0x7zNcXOklgWp3lPawVs0nulc7xwyWZfm1YgkopCZf0aqrhdcHby2tumuqI2LSMZaB8uBJwZTNhdUw0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066807; c=relaxed/simple;
	bh=m1IRZ6JWrGXWz0hUht2VZ4u/oJafs19LSlUBPTVVrj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u8E0iYHn5rOimGzXlYvqyHVWbu3JSELCAqgSdETf1HZLvSar1plmz0ltwVxvcE2SfpwJ5svEhnnZuPGvnOtXKlybJy13x966HLCuak2p0OPvSLHLlxg+NwkcGrYOSB4x/7hTMYw7l3yZcNtppAXJs/azj7kIHYpS+bWXcWmzd7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K/haH+6C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/haH+6C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnsiIq7MCp7MkWvaBWDURZ2QmGy76WgJakR0X9oQlAA=;
	b=K/haH+6C2ENfas9qAoDsoj2q/UOB3vy06k1DByPERwkoi1Jk9/+6HzICsyYTq1KmvAAtTi
	1XDJwOnj+jUlx7NTiWE7b30uzGFQ1Wb7FI4cGA94IA7Kyu6whE15NlcpwLz0mlBYNykqcC
	+qXuLhkUQ4ex16o1UdtHW85TQGs9gY4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-SbUJ8rReOZet7ik03rnnLw-1; Tue, 04 Mar 2025 00:40:01 -0500
X-MC-Unique: SbUJ8rReOZet7ik03rnnLw-1
X-Mimecast-MFC-AGG-ID: SbUJ8rReOZet7ik03rnnLw_1741066800
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2feda472a7bso4815343a91.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066800; x=1741671600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnsiIq7MCp7MkWvaBWDURZ2QmGy76WgJakR0X9oQlAA=;
        b=Y7bJx+KDC3PBg7aYolnq1ChN8Qvq/7g2Kys55pyaB3OdFy8fAGFEsY9OpKU5nLEvpG
         4MocKUPFdVj7N2FwjanfU/onhS2ldybssOraFv6d0BHt/O1tXr4OoWJKaU3/sVgwReLy
         QzRQOCrRhHy7g1xFj+a1xtYaJeBWwkZEW5c6SaAayprGp7/9Nb3ijbm8We1zkR93hm7q
         jinlZVRNId5VkwtUBCxVfBrMtwdDrkg3fh1UYsJu57yviV49bHHUK4c25tN/9vq8MzYY
         JddxVXO5SlNWcchKLWWVGkh8Nztb8ca2eQecdsdt/a/xeMheACvDpcexRSEmw2KTp97V
         xOQw==
X-Forwarded-Encrypted: i=1; AJvYcCX+6i2eK8EgofFNurNip0yPAtV9c3f5TQdICyoeet0d5prG5Yg+VxcDMBQFCm28XjFTbns8siA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCcxUcEhpqH83c3ZIHrXbaUcbsyfF3ZbZNbVr1knKN2qBES8dM
	XCtvO0IfcQSjukyZcyVT38JqVS0s3kgLO219tWD+xsGYe5a/8L9SSVLNupY0Qgdua0YjaGa+dt1
	x1Mc3ysCRhCV+Y51QtbvbHbEgfvzKXnkQNXe8DHA/aqT+C0mvkk+IlQ==
X-Gm-Gg: ASbGnculJUGXXbfgIGtaIRpZ08SE/L8o2onFDvpccgefeo5DDtdWcdgeXjdl1sB3EDH
	wkxNgvzVXmZWJRnrbmagVoyi389pXBzPE6Kq+7za0wz/Z1npy/TLeUc9uv3mn99Zmy9EpxI5XeT
	fRqw1Ck9boUI0KpFBoCILP0nd/9c6cz3R/pfRuGE23mL0MTrkJtgRfYzspeKZeEQOhToEY2tHfB
	ozhGZaEoSUuO4I2+a9psVomXCy1plyrQAQkNZHLkEOs8GSSiCiNlLIGsItwLS0BRil8rRb7lIne
	llbA1R4XQ1CgKcQIRQ==
X-Received: by 2002:a05:6a00:1e0f:b0:736:41ec:aaad with SMTP id d2e1a72fcca58-73641ecaf3cmr9917211b3a.14.1741066800344;
        Mon, 03 Mar 2025 21:40:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLv+2IvaT9lpwd7y3NyeB6C4SRMHYy3586SBjSpdbcGPeX0DUdvbJ57X14h7Gm8kD4TRZ84g==
X-Received: by 2002:a05:6a00:1e0f:b0:736:41ec:aaad with SMTP id d2e1a72fcca58-73641ecaf3cmr9917181b3a.14.1741066799979;
        Mon, 03 Mar 2025 21:39:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7365bb4090csm2607097b3a.35.2025.03.03.21.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:39:59 -0800 (PST)
Message-ID: <bf568862-5435-4c88-9364-0190f30a3d9a@redhat.com>
Date: Tue, 4 Mar 2025 15:39:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 25/45] KVM: arm64: WARN on injected undef exceptions
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-26-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-26-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RLqVa7M-Rv1w7O4pUmyw0Unl1nbDwAgtyK1-BDRXJ-4_1741066800
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * if (x) WARN(1, ...) makes no sense, just WARN(x, ...)!
> ---
>   arch/arm64/kvm/inject_fault.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

