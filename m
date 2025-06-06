Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A966B1624DD
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 08:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749197767; cv=none; b=i2bMvSvG080vGyFMT96cXEOIdPgZHFCbpx68Cuxt6uifp9gHbQkP/EipgOU8KJD1E0yxJvUyaddsj3Zw0BpRvL53sr9jTs7uptQob1gNrJmpjA5qZBgcJHfZSHkRdUogOk8nOhuLToB+FLJ5olTO41vQgH7CjfK+sIk51ye6Rd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749197767; c=relaxed/simple;
	bh=FFp1aU2LrxnOlrpGpRG5JHgJo/n7WUh1yOPsh6NSGPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFzgx4KLySioc9XlQq6gvO2ehsKr7QJ9bAZQjj9Lwq8xW3+waW0imNGJoQRtfqW9QbhwzbcqPLsMlLIUqV+sVsFvZ07vAm7409tFujaloxVvnAdjkvNTn1j1OhOpgJ+wakQQwI0MjyGS5b+FDGbIDOv09ymHanfPXV3kZ2Kbatc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dziyKMtZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dziyKMtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749197763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KOWahLJx8LgCN5g4XRLg2n5g+DflRPZ/bKDmu+1DLGw=;
	b=dziyKMtZ93ndeUDCwRB6csZnJwsKKdIcUWZi+vYOsK1T4T2q7nkPup20ZTuKx9vPCzzUit
	ZHmRN9uQGcvML1mC0nG+Bc2Tj57u1YxSvF8CcSlQrQLaQEz9WlLwPSBirReuy8evjrVEMT
	SsnUjks3VjoHq24DMEHaH79dJB3Mm3A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-WxJKimt2MyOwv_XgHYuZ2w-1; Fri, 06 Jun 2025 04:16:02 -0400
X-MC-Unique: WxJKimt2MyOwv_XgHYuZ2w-1
X-Mimecast-MFC-AGG-ID: WxJKimt2MyOwv_XgHYuZ2w_1749197761
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso9897235e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 01:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749197761; x=1749802561;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KOWahLJx8LgCN5g4XRLg2n5g+DflRPZ/bKDmu+1DLGw=;
        b=o+/ieK2XP71sVx9VIPA8mmWvhfSLhLGWs5/aTLo43al3gcrMstF3W92xjqGUGJ8sAP
         VhTPa/YXA4icRy5tml0V0hmTqq8/IP5FpGELJ7dAQW89GNd56TiBhqk0jmlBgsuhS/nm
         U07NAK8l4iuwPEICmdux65xsHz8R0m+oK6+xFuN6214/jaOVPwR2PNFCP0CkoLYciQU3
         6o1FFDA670bZOKG9fyBaLkXnbjQkDau2ZfgbXfqwhiYZaYpi/CyGQIUGodQhG07QyV7I
         IGcXsltZQFRtFjcAMsMOY0FW0AqNYyp+IlbOTDxjI6zKanlAC14yGjIuJcmPyr5j646U
         hFtA==
X-Forwarded-Encrypted: i=1; AJvYcCW6+owam2pCEUuGNhqIxXnNg24Hv00SoAalNEFWFBUGFDDZZTHZ+kLc4Jdw4o+lkyp5Bb+QJBc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOWVpWDRyETP/u9ceYgcZhusZU8bt5c3eqmnE/1eQUrpbHYeiF
	40taZA5O97EiBDVgZI1NXfH9W9YLnA5M0WVW2yoxt7KAsMGl83tQxY7aebsKNtr3/kgtkkb3Ewz
	KdRFlpzt5UYs5VN3B11/K82sSYnQl0vy8R6bOQ3Tu61WnLQ/QupHBUBgxng==
X-Gm-Gg: ASbGncvEH1al7AuVoPFAVYVdZa1OptpcS7nQJ5/PUL9Q7DO6KYmqydHskpNM6oA/KHz
	UyesmGbZxR+4+gGrU1iaNQWlhS9Iup6Ice5cvawBLLVKADaobHwfScz0U7bGy75cdgtv6NbHF/N
	fEk2Nl9XxGNbOjeJxy006cNH31pjcV7GSsICA0JIMOGdT0zpeQ2AUnhQg/zNu0KPGUTVtKzogG8
	yI2kd1edcbGlyYVgYD+6PYQsukrJLxynQr94UkG4ouJVdynSF9+WT1Ith2zpby7U9uXIOIt7zu1
	3K7+qWF6OZrNwmgajJxGsGenQ26ybuXLvf2OSSLDY+cKaATE/wshJl9yLOMxgn0RVF2d7o0vNlq
	YLJTAWI8GvbOLtec+Sokn/aKdQeJ3JEvBthqi0XGYOA==
X-Received: by 2002:a05:600c:5306:b0:43d:fa5f:7d30 with SMTP id 5b1f17b1804b1-452015bb35amr25326955e9.16.1749197761121;
        Fri, 06 Jun 2025 01:16:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMHizucgFM/97RVmr0NXLsfd9+74bASSClWDaJL2o7ZMe7nJkQJ4gHbTI8CdoS9rkjpED4jg==
X-Received: by 2002:a05:600c:5306:b0:43d:fa5f:7d30 with SMTP id 5b1f17b1804b1-452015bb35amr25326295e9.16.1749197760706;
        Fri, 06 Jun 2025 01:16:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a53229d9e9sm1190527f8f.13.2025.06.06.01.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 01:15:59 -0700 (PDT)
Message-ID: <588a87bd-c54f-4c4a-98d3-25707d3ca404@redhat.com>
Date: Fri, 6 Jun 2025 10:15:57 +0200
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
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-18-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250605153800.557144-18-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6JTl22jiBLEtaPKbtfjf52JjWEEHvfMc7TcaqY9AI8M_1749197761
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 17:37, Fuad Tabba wrote:
> Using hardcoded page size values could cause the test to fail on systems
> that have larger pages, e.g., arm64 with 64kB pages. Use getpagesize()
> instead.
> 
> Also, build the guest_memfd selftest for arm64.
> 
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

