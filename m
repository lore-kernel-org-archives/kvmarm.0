Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF28C1F12FF
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 06:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069682; cv=none; b=ZIkyhRgSIZKP5hDL+S4dczXSPteMG+ma8FJFfJjJo87/PAZMJpbLwBrukPcDocBL206jVLO6/UvmKUYYuGF63O85cSMdug8d08p0ZbptiqAXiT49jyxGPfX9cbWb7II8yttY77y9ens8FvbixDIDDGaxLJOSCu0jtZHx3uzWNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069682; c=relaxed/simple;
	bh=sANxphPEpJhSoJRv2v+wz0k0ncvT/idn6pMCGmv7Dyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUkV8IROsgU+22TWQq7IlfvNPncVlBfL38NmLge8igOmu7MdOMLWVHNEOjp5SDSwz7PnWFVWJO/RoV9HVLcYu1mKIbbvYkQRtVOg+A+JoVAaRLD8+7ngyPF8fo0g0S8fNPKv8EoW8Jstce1JvlTKbQu7z1DDYWMcDDcWQ1Ry1yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EogGRYdL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EogGRYdL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741069679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iAefvd9tbj7LNYMHtdDRot9Yl7dRO2WNDbwoA2ZpIZQ=;
	b=EogGRYdL3R8QdP8PDF9Qm/ly4gKxoo5uvwzGZrLnGS3lVSmoH6uPfdU05qh4JBEegaqDjA
	g6hRs8/b0KCNyYwC4XRhnLYwx34z+HWOmTWdayZ2p7HqFYvqd4njpn8Pcf1facS9Zz45WC
	ypcDz6FQbaBSDWcqZ1vkX+EHqOOIkWI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-aB6VXoozOv-jGBwp4wvlzA-1; Tue, 04 Mar 2025 01:27:58 -0500
X-MC-Unique: aB6VXoozOv-jGBwp4wvlzA-1
X-Mimecast-MFC-AGG-ID: aB6VXoozOv-jGBwp4wvlzA_1741069678
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22379af38e0so52466455ad.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 22:27:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741069677; x=1741674477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAefvd9tbj7LNYMHtdDRot9Yl7dRO2WNDbwoA2ZpIZQ=;
        b=MSwB6VPhEYrw+mfHFcDyrOOYpRYjChtHqtXnIpe12GLOWB7JazbuxLJkN4Rr746gON
         vEUFiakziht+rq0AlpS2aWqLHBlwATB9Exg3Pcs0MIDUF+lSnpHWFCyXa6O1uQeQgRxM
         eQDCbvP9An2IL+3pVRLzJNZ3+8qGihCRZh1cIXub7kSRoPms0teaAPApPVwtZkYufW9p
         GFul5bz7i7LwMPsL4ALaNk9TcF/9/KcQo2co1t7so+OM2ZxyYm81y2gzuHSHL6+h6//+
         2gE+C5BFA59daxzjYR7yclrsa9Vr/96tOGLwYkJXT1fAel2O4oTsS1Hr2WECIemCLDR5
         375g==
X-Forwarded-Encrypted: i=1; AJvYcCU4K6/zObQXFrYfgGQhhg3yOkR078X3Hjiem5sSKhr+pATSw766TLNW3lfD/WmDZjooa0cLiFk=@lists.linux.dev
X-Gm-Message-State: AOJu0YztB7w/fxpxg6HKqv/4fihShsEwnyq0CrLu0k1WO/xY3TOPGenK
	aQlRp9VMY0wpiv14hfET4wMB3InSbGUrdI7vvx+/buTXzsXHjRLCZX7hVwQw0kVjmz6I+cv1Dhr
	A0VcwGJgjtgWD8DMFRw0/rO/nADtjjpQkYKth2geFOLJWkUa477WOcQ==
X-Gm-Gg: ASbGncsils2LfSTrSLWHB5Q2Dzr0i9VOpXiBQsfWCsNFsZXYOuPrF5izvKDgqY/4nib
	mv3cVER/VI2B1teKgx1oMTiXvpvv5e1ODZZYZ8PSANWULjtAvLG4Otn6OgCbct+eUX0Xi+zrVv3
	VaZcV7tP+sU2n4fN3uSwTGYU6wMvFrgp9J6pEENI1zMxd84h9YwOIoaH0XvUYu6n7tAxkw12ojA
	+423txQ4Lbx+WcGV006uHmxgclBr1H2XLXu1zM9M0lFWBEesfH5AuxRECvJbs4cm2XMUMGKwO6+
	AwoLjhP5nBwIqlvCUA==
X-Received: by 2002:a05:6a00:230c:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-73672704d81mr1945053b3a.14.1741069677592;
        Mon, 03 Mar 2025 22:27:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMjQLRj3AUSUbMsClYXUXqxqJWhk5KrbeXBQgXSoViyrHJ8djjcdkYHY0nBVtVH5e57rXWYg==
X-Received: by 2002:a05:6a00:230c:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-73672704d81mr1945005b3a.14.1741069677191;
        Mon, 03 Mar 2025 22:27:57 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363986010asm5850843b3a.52.2025.03.03.22.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:27:56 -0800 (PST)
Message-ID: <780f593c-81cd-495c-8ca6-38ecd64ddb35@redhat.com>
Date: Tue, 4 Mar 2025 16:27:48 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 31/45] arm64: rme: Prevent Device mappings for Realms
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
 <20250213161426.102987-32-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-32-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qThCR-vnZXDOAF6s458YSMCwL9I4FJNfA-mgOKnNJyQ_1741069678
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> Physical device assignment is not yet supported by the RMM, so it
> doesn't make much sense to allow device mappings within the realm.
> Prevent them when the guest is a realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v6:
>   * Fix the check in user_mem_abort() to prevent all pages that are not
>     guest_memfd() from being mapped into the protected half of the IPA.
> Changes from v5:
>   * Also prevent accesses in user_mem_abort()
> ---
>   arch/arm64/kvm/mmu.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

