Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143888BFF
	for <kvmarm@lists.linux.dev>; Sun,  8 Jun 2025 23:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426225; cv=none; b=f2Hj/WxbgD1W4Oj1LDiTOM608LliS+/iJnDHfBtjO0jofStSpyH2W/Nx0qBCbApnsHwVkyUAHdG6I7H2fgtZg+d3pV7wmzMT2Ve4NsQs8nUFhextxMx/l/I1D7B3osjVXGExHkHXu9tQgXccHZpw6rnd8cTXLPkK3p/1EHc4w6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426225; c=relaxed/simple;
	bh=eognrAOK5phWj4syA8utC5cWw/hE0DYWnC/1UPPwauM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GuaXXTNLkSd3EI0sH91Kfhl9AUYuSWFYsBblzO1ng90axAoFx+H7WMO2C8U4W6dJ66bg/ZzvD3kV/IA5900IPMccEKZwwSoGwoebBWmqVLgF4itI6oyH12YJoAqNcv8a9z0sxAlFPKXYMbv10LhXdzwEedLmpmtP4RDBBL8Qlxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c578wH71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c578wH71"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZTYuUEgwsSSH/seLrjyp4437G/xo/ld4sW2rsZ41WE=;
	b=c578wH714mMst6NHg3Yzuw2HiA5ljPKh1kuvi5tGLeglQum1+FxhioCvwBEPOQx0Yscgwq
	/uvQbviAuBUCO8uIV/4FBORbu6z7VS5evpBeKJhSKual8tKoz1mBeO/PLJtsHroWubMtbD
	olmeyRoRCV6efz4SRQOx+gL0yPuaKmM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-psstzbreOW68ioHg8ZdTGA-1; Sun, 08 Jun 2025 19:43:38 -0400
X-MC-Unique: psstzbreOW68ioHg8ZdTGA-1
X-Mimecast-MFC-AGG-ID: psstzbreOW68ioHg8ZdTGA_1749426218
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7425efba1a3so3046982b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 16:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426218; x=1750031018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DZTYuUEgwsSSH/seLrjyp4437G/xo/ld4sW2rsZ41WE=;
        b=VhyfjaO6f5EsfDnh2x/EMFgNpI05dfDSSrgTOJ55MZlarnFqDEAt5i/KI4P9COnkaJ
         bqBDBWz0mlJm1waVjof1PqopFiHoDEbifdNwVS78xC/2b+74ALj7n11l3k4SMfH4ko2Z
         OcSG7yNn25c4ClCKttl5NzdfGQzQm2Gf4kyLylcB2NL6zOuktobO3KwiMbbqNIQrAy14
         viYEbbBv/Uc5tPUVVvyYADsqnROuUzqPgmVMrv54wJKEx59WVNennkFMesgUbvotqnIq
         zV8BReJrS/qaKnzgmZ7Q+cxC1rdDZGqIPdO085F2craPhj30r03CFlsJbgGEn2MjkMgf
         g/QA==
X-Forwarded-Encrypted: i=1; AJvYcCWq+5umZonTMj5SHhKtqJut6LmuhxgxAwSwiTlOOGtIo7CNPHnQWRMmhy6l/25OGYiq//wwDbI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvkTUXzAEK0NM4TH5AVjsupdsj0grzJavsLfMTufss05JSVzQJ
	DAmZJg92mMnG+jYGh0VPGn2osHUReOpdIYpT85MHYztBn4l4GpJIbZzxsdBGZa7avaYTn3DNqMW
	uivSFmFi/8C9Deci6HHk9zVUdui+FHE72Mwq/aLNQlT4Y49+yelOcIPlEqA==
X-Gm-Gg: ASbGncvOqDENcoDFBdOlirLn8SHOZbnfmYFAd1PAFSHeS+YQ7R6/1ArwNG7RrjExLND
	AY3qKdw0qnPbd7ofGIrbMzARZmdU/pHBloeT5WL4oIahZebMwhIrDMHwWgI63PcW2kCYsgimo9z
	6SZ2fRLFXQXULB+AJUP2WLT4yqE3uHIrdFKwJZUnKg24J1fykdN/I2chh/lm7rJEbqqmYE8vFN1
	wvQZGlJD/6vXhe9E3tKFSdbmXU87ji+mUKwQQNtQ5jqPC6lpMUi8eWo/uRfIXKz0ILg6bEgf8/i
	IFBb+g+n68qNR8RLYism225Fjt71y653LnWmcISCUYvWEDvjVts=
X-Received: by 2002:a05:6a00:94a0:b0:746:2217:5863 with SMTP id d2e1a72fcca58-74839af6c88mr7041917b3a.6.1749426217849;
        Sun, 08 Jun 2025 16:43:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMrZVN3nL20lU8KRAFANwYTY3wAoHW2KVfIcHNcKcpCW87hvtDrgtI8DfNiEq6ldydFzu9YQ==
X-Received: by 2002:a05:6a00:94a0:b0:746:2217:5863 with SMTP id d2e1a72fcca58-74839af6c88mr7041844b3a.6.1749426217481;
        Sun, 08 Jun 2025 16:43:37 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7b2aesm4695870b3a.61.2025.06.08.16.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:43:36 -0700 (PDT)
Message-ID: <ab9f3307-893e-461c-aa1f-54edc032e11b@redhat.com>
Date: Mon, 9 Jun 2025 09:43:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/18] KVM: selftests: Don't use hardcoded page sizes
 in guest_memfd test
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-18-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-18-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xt4tpfvecmskp6pF1GPbnsFVwnizXIMNGWiWGYfG0hs_1749426218
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Using hardcoded page size values could cause the test to fail on systems
> that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
> instead.
> 
> Also, build the guest_memfd selftest for arm64.
> 
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   tools/testing/selftests/kvm/Makefile.kvm       |  1 +
>   tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

