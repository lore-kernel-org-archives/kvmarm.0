Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7728F1A270
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 02:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462302; cv=none; b=L2xNC1u83uwbJv6oEX9nzxPdcje2AFmOhKQimBt1icP2PFTV4so9XsPp2hOJMWuO5AqJMPpwWzLLjIR0ZLsI6LAQ0sELphFNBUck2XXEzPuxde1CLLyzj1xgD8lcdVzvm4dFs5MJxyseYob/0mY11Z4eBTh+ogPCVXIIGj3fmkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462302; c=relaxed/simple;
	bh=f/Xz711tH686KIYj8B5uhbPaXR1gbd0LuSh4loqolqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h91+El+ENSVVnrq9k+L/18WAEc5CmcRnNO5Sd/Agvglg401OaRDBN8R0z75trqLzohjPEE4h+FTm1A+sHnVuAwrIvckpKjqFviRM+GJNYjzmAbhW411CFBV7hVtdnlY8idTaUmZRlA3qHJp4WPAxvaQLEhNMtlR+PXVptwM3qsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H23Jm5uj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H23Jm5uj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz0tT2FTFLvNvj61SDsLmOkHBQ46Tt26HSOtiuLa6z4=;
	b=H23Jm5ujEOUzkBudxrp/itOgH1M+i88osJbZm2lxJohj3o6J/KhDvBnjnzGFHccaSNkWbG
	VuXAzj4vSLyrDwatvxiga2U3Pnt7PgwBjh2MAs0UO3NTK9UAWaR/4o03sgmQYR8UfHwd4G
	ym4CnycWjGb+crvgSBdAO8iLe6jnnVQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-L5fyfOFYMUuQ358y9DHD7w-1; Sat, 01 Feb 2025 21:11:36 -0500
X-MC-Unique: L5fyfOFYMUuQ358y9DHD7w-1
X-Mimecast-MFC-AGG-ID: L5fyfOFYMUuQ358y9DHD7w
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2164861e1feso62933515ad.1
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 18:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462295; x=1739067095;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jz0tT2FTFLvNvj61SDsLmOkHBQ46Tt26HSOtiuLa6z4=;
        b=mcdOl07I0Cd79yAH4H57RWlsffq+n/AaazFd37ie3n4a15GrkKElC4j6wMNR+I8v13
         w/WCJU5npk5QovzHpdy0x/oxA5XO7h3/uGZD1KwbgXYXNlcyQ/K/pVdLUolHBb7KwhqG
         Nksbc+oX67+WS7BXbCH/OQXBlxUwKjdTc95jpSJ3XMcJpXyubbjekS7y+bVQ8Dv3AkEv
         DJbL1qUdYajUGsgKsF1kcAmQ50PCwKis7hKkCs7uXMTyp3Bsx6UHki/OclnKFndFM/3K
         d0Q5Lds905ln0EEkokvDCEz9nPIdp3K/KW+EHqAX22CdrIZl9SmlkA4Q3gAp1eclOg5G
         BqoA==
X-Forwarded-Encrypted: i=1; AJvYcCXvon0NcaKhxNlVpPyJXiRLGASkGEPhbBFs8rzBLzSVGn6hx2W30vkngCLtu9gwHXyQSxbOoxk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXGQAWWGjAhdYvOCcVpkRMvx90rFHiCF2JxUKS1e8iZi1V5pZK
	31yLMpkKp9sYVeAFDgFzYHWJzJeqXchn9lXXzdJVYnlt1FnSXflKLOg5ZJgxcDBixTbz39Zo3aW
	FnwvFhByJDA+8w5kH4GlOeR3IiSml1sayqu7t+Ueel9FucR+PpvPhow==
X-Gm-Gg: ASbGncuCnMqNlHRz18+Pf8rvEdUvUTwFjvUsvWHSQqbZY9siyybBMhZrp2DSLYiA36u
	1qtnItOFIEcH2Uw9AGJ2+BG3G4Treb/CeJf9ivqMZegDQJ1S3Fib4smPEXcvgbDJB+BIUW2jP7/
	k4/ty6HzLlDCptjQkxG0v0xMCIPWJHq241cc0zemty4liBepyCe+4usRqfI7838KoW9gNiwsrpi
	IU0wZHj+VbvWBu0BZFHWigc8cSuONLQuzGtVvxcFcUeVwrDqQwe6nNmoyUJGDxdsbMLZiEj++xy
	z5rr6w==
X-Received: by 2002:a17:902:ec90:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21dd7db9401mr253960125ad.37.1738462295043;
        Sat, 01 Feb 2025 18:11:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEznBpra764QOyQOK6CFRr1iAthLIwu66BAhbI5avSF//jD31IMMeDXBhhitA9mMZwWv411Bw==
X-Received: by 2002:a17:902:ec90:b0:21c:15b3:e3a8 with SMTP id d9443c01a7336-21dd7db9401mr253959935ad.37.1738462294746;
        Sat, 01 Feb 2025 18:11:34 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21ee2bae0a5sm24864345ad.19.2025.02.01.18.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:11:34 -0800 (PST)
Message-ID: <8606c5b1-075e-43c8-a58e-bfd5b90f3dcb@redhat.com>
Date: Sun, 2 Feb 2025 12:11:26 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/43] KVM: arm64: WARN on injected undef exceptions
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
 <20241212155610.76522-25-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-25-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G7P7FXGCZ_Pzso7hDFcwix1aY1Y-HwWrHUpl7NZXwxw_1738462295
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/inject_fault.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index 611867b81ac2..705463058ce0 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -226,6 +226,8 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
>    */
>   void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>   {
> +	if (vcpu_is_rec(vcpu))
> +		WARN(1, "Cannot inject undefined exception into REC. Continuing with unknown behaviour");

May be more compact with:

	WARN(vcpu_is_rec(vcpu), "Unexpected undefined exception injection to REC");

>   	if (vcpu_el1_is_32bit(vcpu))
>   		inject_undef32(vcpu);
>   	else

Thanks,
Gavin

