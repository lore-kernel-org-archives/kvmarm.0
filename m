Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CBBBA2D
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 23:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132027; cv=none; b=gKZEJdJbLIW377GPNhaPunB+QcMOY8nsynyLenuxXFBahiptylrmjN6adkF8XEhuGtGWsTZz2R36fUvPQG1jvFC9liXpA8b6P7E33vty19lRhuw95A+omX/79JCVE5/ijGv+G0ThUvMJR/j19gPjJrpbAdsow/h8bfr+h2UTYRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132027; c=relaxed/simple;
	bh=0vaMK1EzqAclihJeDZxRkFMmTm4waXR3LR9AN19QWDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uhx01bSl02PWTVt6HFTXHrGjRNrkZkSp6dvKNPzu21qF//2QjJTO0zfxNYYCZqC0xznIHN8TjOvE2O1giuiTVD3pJZgKgSXDNNqZ6Hyl6QEEd+EGLrUgRNaCI/L/LdP/IF6IC8JNKxhumxyr2M1sWIrrdQEiz8OCLvLVWQj0W58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjHKgok7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjHKgok7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741132025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6FYqCr6QwRqz7j744DqHTGMlLhF5qSIjaDfjqoangk=;
	b=cjHKgok7JlZpG41E+MpkZ9bDUgk6LWNKfLVxSOwjmVAwYBNsWMPg9SccTfqC3a9S0/AaD5
	XfkoiEcShr7DzBi0TNW506uOA2KXMBs7ub/lhybtMzbS+9Hw7x3cVfFpG5I4HCIrZLIYDw
	1KzbotA93jNKucVCt2mDz6dk6TV0q1g=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-qWrXoJV0OU6pbthpTqqR6w-1; Tue, 04 Mar 2025 18:46:42 -0500
X-MC-Unique: qWrXoJV0OU6pbthpTqqR6w-1
X-Mimecast-MFC-AGG-ID: qWrXoJV0OU6pbthpTqqR6w_1741132001
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22366901375so5959605ad.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 15:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741132001; x=1741736801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g6FYqCr6QwRqz7j744DqHTGMlLhF5qSIjaDfjqoangk=;
        b=Csm2C40xLdPs716n4CNJ53LoSO3aiE+Bd88+TKHvOlm+PeHUuuCM78qe38yBT4lIcH
         +dtsvPjswmWeV/rLSOHHzU7w3tW2Ic0uePBreTaZRSIGjWLsvAQLaAvj91qnvqPNxGBF
         KRV6GqeaMaLxX5mho107GwCri0jurqvnwlNYr5Wt7ZNcvPKHOpc1onptztJ1fdSuy72V
         TMUHLz3t+6I/wsHlfJUQ2npX2k0Mp3BHP3DwRMi75Y68lSo68MO3eIKR0Orr7/VUAVC3
         YrTyiLVP+y5WxD1fuNpyfSlD1a7bPUGhSX73ytULXvgyGlwEHdggn0RpfOU6jPEpckmj
         rqdw==
X-Forwarded-Encrypted: i=1; AJvYcCVVtmh9zN8TQmlpHMdedC8OHnOCLrdhCz5WI729/tkgtMUU5WHifHILXEmWacM+Q5ZCk/rb9Ys=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDzHnL1ud4WUQI1vS9I3g49jkauj7jQdpiLtYbiyXbLCwTWLgA
	DAYfnvD+xY2AgjclCxVbDk6xaPWIyn5EhBy7Ws4j3PjyNTfAwLWZOaRCSMWp4ncMyX9ILVsm+pk
	Zc5NE1iKmKMhrUTzDO1+akqCEj++imb9ocnHS54GeF/4saoBSo5TODg==
X-Gm-Gg: ASbGncv1EjQLdMZL4oO3H9H7gharAV+ApOSK7IOrzudnFiE2pwUg4DHpCEUDWugJU8n
	pYo2gP9gsrBbz5dJatHri0K7OBbQQh7WI/ymttDUWSYlBQ3J5pRlJK8pBf47Iw2roODx5REYgPP
	EwLG4ikxaK1fs/ev7+Co2OvnnIydokFr28t5cobVs0tRl4sSqoa0LaiScMk7815+4emoQX/HYru
	QjXPi27P3dQL6fn+eh4bcpvKot/BlQinkEiScifV9XHOZXcC5p2JOI9MhwNLQLPS5kYLlsH1rI8
	NeDh5LoKVEGJE8Y=
X-Received: by 2002:a05:6a00:139c:b0:730:9637:b2ff with SMTP id d2e1a72fcca58-73681ea12f8mr1622590b3a.7.1741132001098;
        Tue, 04 Mar 2025 15:46:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEi8JMyb0mWMUpD1PTtuv+YTTWcm/STeWKBdnRr6BiZi8G3Jvspyz2BgiTf4N+sfAjC+o/22Q==
X-Received: by 2002:a05:6a00:139c:b0:730:9637:b2ff with SMTP id d2e1a72fcca58-73681ea12f8mr1622559b3a.7.1741132000737;
        Tue, 04 Mar 2025 15:46:40 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7363f2e8a34sm6324254b3a.168.2025.03.04.15.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:46:40 -0800 (PST)
Message-ID: <f331382f-5747-4837-ae60-42e9cb37ecd4@redhat.com>
Date: Wed, 5 Mar 2025 09:46:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 36/45] arm64: RME: Set breakpoint parameters through
 SET_ONE_REG
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-37-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-37-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 16lFyojew5d-ZIfDyTb1j2iGco4qmTfiViVzom0Gl-c_1741132001
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Allow userspace to configure the number of breakpoints and watchpoints
> of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.
> 
> The KVM sys_reg handler checks the user value against the maximum value
> given by RMM (arm64_check_features() gets it from the
> read_sanitised_id_aa64dfr0_el1() reset handler).
> 
> Userspace discovers that it can write these fields by issuing a
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/guest.c    |  2 ++
>   arch/arm64/kvm/rme.c      |  3 +++
>   arch/arm64/kvm/sys_regs.c | 17 +++++++++++------
>   3 files changed, 16 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

