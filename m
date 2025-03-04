Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90FE149C7D
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 05:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741067284; cv=none; b=DJzHqjcOE+I7vSrI5SZGO4IHKHyijxuFpteyBd1R5dWI8+zxU51jvrKCZQCqKh7sRrribGBHwYIkJZOEUhhQYcrMrBotF+XIHJ6MhDIjc82t5TgbJYKqgVd83DKIWGSieniIWyBYYc2wa5yfeTL81im4Bz0q1l0rkmgKrJsSy/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741067284; c=relaxed/simple;
	bh=uIUop+r/l6xH3Ly39qJ0Hh+UtGOGfUCQ1Gk41ZgJy6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWB7UYsHygq/f8c2eNtI/AWJ9TYGIzjhv7HzmFRPXE8r1ZdGGofT4lfycms0kBa/hu7ckcKm6OSQhPUM0HzEZ5e1e+hZN2xIfXVuENahZVeAo/FubMjXacu4FZDDGkaDV+jDQerOOaUhdr4T7X1mqLXL8gT2hN6wC6HF8PBP3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDYZOCKS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDYZOCKS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741067281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALe8gaqPx0ivwZMUhNjC7kbkgwdK+iS+cXrLOMiOcsg=;
	b=cDYZOCKSbxHn4yVmmzNX4T1//MQ5xNEZvrJzW90+cf/xSm2FDmRY2QpwhTNhsxjFZqyQkl
	L/0KOZNWERGgROCSkRYyWgtY07SXmrTeqdFJsvBzZGoN6FH6zL4oVO5fm+cLOY9BO3or31
	bHB5CiXiVg0ux4H0lOQS2UWKusD6jK4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-PM3cNRo8O3ul65roKFGw1w-1; Tue, 04 Mar 2025 00:48:00 -0500
X-MC-Unique: PM3cNRo8O3ul65roKFGw1w-1
X-Mimecast-MFC-AGG-ID: PM3cNRo8O3ul65roKFGw1w_1741067279
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2233b764fc8so94101355ad.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 21:48:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741067279; x=1741672079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALe8gaqPx0ivwZMUhNjC7kbkgwdK+iS+cXrLOMiOcsg=;
        b=OgOJU9gmqtJ5XPOhhdygtAmdNga1vRloAjnizQ7Y8u+guwHZ3osHIWeRfrii/+Bfha
         lQBjQavK6IZoJZ98rTmMmGA5g0uB0g17O0PKgYPVp5axWG+EJXwCs6meNfEkE6NgB5fr
         +pzz8QWg9qWDeqGgn0h/h/NQ2wV+5w3tyl2Y8qK8eJ0qXsRvmPUn3xf6W4xopMF7bd3w
         0fbQv+3QF+7Mqtl+jk3h8FHU6ekfrmcsfwO8lKJfGnj/cfSjyJ83mJZFISwtnPtUFClT
         U2txq9elxlcunllS633brVkJnwsM7KFUdh4o67AxQbfNwL8kjx9H2EkrFdoX7/KNFqrq
         2vNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuAZq2v7Av6+2ck9XdxPR9M8ZNiyJ1vKRdKOk32JCeTTn4qavhGk5GRyRruzjyQQPR63iH/IA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPhU2xYAou3JSVT48aXEiQV4Zvm8MkqotfJ1wZAD23jPVLJn5N
	6ivAD7TivOsS1DaCQ7X6ZS3WiIKtR5kqb6mOY2NwxoAeDIVV8PFVy4SgyrhoRVjuFHpsc2wrobu
	NWtZ+i7hMXBW7EIsEVVcuPUjItYlb/JlBIS+LSD6NB/IMtB1749Mfyg==
X-Gm-Gg: ASbGncuI2IAVhPyzfRMjDs4eyDuBc/hwKmXE/o3mfebEViLQjSmV1h4p7HfA7hVbbc6
	/K1XLf9pzZcIjU2jzJf4U2i4KIhdP37iTUi5bsVLX6wfJLvJs7IT/uzQHZ2f62p9UnprVNO/CdC
	wIfV1Z85dDhq/Iszt03PPSy6T6XgUbrSbGxwn0t1y2FEocUPOaP3tAGh+EkMKUxZ2jypkAVOGSq
	/3n2AO9hzW8ee+x8OJc3Iau28m9P5oYnHquCtQRG9s25gM3OMrykpma6s/D0ULXNpsDOVCJ4pLC
	qQ8bBCe4Mw8cX6EnvQ==
X-Received: by 2002:a17:903:1988:b0:220:eade:d77e with SMTP id d9443c01a7336-22369255615mr277878095ad.40.1741067279405;
        Mon, 03 Mar 2025 21:47:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx0Lhe2HGT1KmpDnS5ZyyAdNkSfy6p9uQW7gR79fCGqriIN6Hj8entskHLAJfXfbmV6sWD4Q==
X-Received: by 2002:a17:903:1988:b0:220:eade:d77e with SMTP id d9443c01a7336-22369255615mr277877915ad.40.1741067279165;
        Mon, 03 Mar 2025 21:47:59 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fae0esm87110695ad.93.2025.03.03.21.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:47:58 -0800 (PST)
Message-ID: <2505ead3-64a6-4135-a96c-85c5dfef26d0@redhat.com>
Date: Tue, 4 Mar 2025 15:47:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 27/45] arm64: rme: allow userspace to inject aborts
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-28-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-28-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hq-W_pN2Qgqiw5RLEfHxHm-GbPmnlJOPfguoaeNAfjY_1741067279
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Extend KVM_SET_VCPU_EVENTS to support realms, where KVM cannot set the
> system registers, and the RMM must perform it on next REC entry.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   Documentation/virt/kvm/api.rst |  2 ++
>   arch/arm64/kvm/guest.c         | 24 ++++++++++++++++++++++++
>   2 files changed, 26 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

