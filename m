Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF20E1922C0
	for <kvmarm@lists.linux.dev>; Sun,  8 Jun 2025 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426165; cv=none; b=b8xtv9ZnzAG3YNgK6JCGiynatKWOqiddZ5KAqN8ttZYJxpX+GSKob4uGLIPIgjGQ6mZF6MZL/rMay61X7lz1LYaQ3w/JySk9HBZ2Qp8TgJv9k8QoFNYPJo9azq5nT35lbX0zAdeOEeyv9OUD3nSokKEzz4AaXz6rkn57viYNlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426165; c=relaxed/simple;
	bh=3BrPqick3GI480dewMt6lfWOE6CKi6PdWbeMGGqvCn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6N/0R5O9Gfo+RP5GY6sHa3u1HYGEwfnKvZjXhQ9XMsa7lZjEmy7Ydi4R/zH6N1hCv4KnZXGRIEamCmmyRXcV8ylcHJJrrjAzqCivbJOmpd1qcvhaSci6UjtjahMakvzgeHAqH4h8uXMDM1q0TgKXwVnPI2wa+NyEuzfZ2PqsPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEAdgQ0Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEAdgQ0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BrhPYURkD84ucWukiI2OFvciF9PKhh9wNSV3UCxvffw=;
	b=XEAdgQ0Yd7sLbdcoPj59BFQOyjwPtdJibsFCaYF4X2/VGmGMc6AqEVme0+eVB6LxvFFndR
	jxROxGMxY1gn7o4zjJCZ7+nPBJYieHKJRZFswfPjRTRhoAuvhldeMiAic86pKWCd+2qEd0
	rHhipB4eUwTbha9bkR6N91pIAvGXiX8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-CHJPpQybNuumemqh2xDNqQ-1; Sun, 08 Jun 2025 19:42:41 -0400
X-MC-Unique: CHJPpQybNuumemqh2xDNqQ-1
X-Mimecast-MFC-AGG-ID: CHJPpQybNuumemqh2xDNqQ_1749426160
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-23536f7c2d7so58261965ad.2
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 16:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426160; x=1750030960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrhPYURkD84ucWukiI2OFvciF9PKhh9wNSV3UCxvffw=;
        b=hHBJplBLGdeLpZ2YEYKTaPKyR1zm7NUhNBcjZBnWr72CoIQsFKoJCithFsGeuKaDRW
         G+knbL178OjBnFqae33wMcoH/6Bw1UELPuLs2EHX+RUfn4wkEdvBaVlkvLq240yTHTXw
         qWIpe4+2F1k55AeMVxw5tw7Eu6Hn4I/mrOGVCiubsmm/kEaWTnLJ4C9hjS9w+7kfXntm
         ECD7osSB7+o16qFdDQ1pvifh87xc2WiUIKRTBtGe4zTr3bsuqPQoEd0TllC3PHUvNLMY
         q1GI7+3myr7jM4wxpnHz1K8mQ5H4cNpt+S1jO0oz2umAkrQqFH4lPDingCEhPWY066lT
         RIfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvw6al8EISvE8O3pzoMcYD1PYRG0CemfqaUZZ2puvicwK2osDfZ9BSDmAwBq9huOqD/+frn/M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGUW4fHUKpcCJZeSYD7C5EogjtEjJTq/xY/qtx1KM5hozUuk1C
	pB3ItFk21GSFO0Xo+eJFyxyqqjukKmLP3fygVqjD1B7yUbT+EZFkxYU2PjNieSWuT5LdymNQcPj
	TyeXGlz+ch+yEtn1zhIIDR6aynES4d5DcNmlMuoi5Ug/MOozEe4QCilDpLw==
X-Gm-Gg: ASbGncvnamkQnpDxP8t9MayGfjoTOTO0HKAc/VMZUg/Ee2uZ6+AWkhuyOFUepe+Of51
	gnZp6EbOKJIJtqViCNg7Y4J6rHLcBpiyguj9KfWgKV/mMJrNXZedjq32TZmBNSUtPNdTDfM26fp
	7Ze6jBRJCmxxYCq+N+UFvvOfgGqAJpHsVLDWgVOqyWdzF6UKIDkvP5NqSpr53AaPoU4M8maxx9q
	46ZDcdGi7WErTH20DUvhoiHFPfhc9PvVeG1ShGSuAvKY8fMRU394vDzdtaLCTCEtJ05PptgP0BI
	V0rXnKlR82mPVjOA9D59l3sI4uUao4xSlwJMSWNMAhx7FsjFKjY=
X-Received: by 2002:a17:902:d483:b0:235:e1d6:4e29 with SMTP id d9443c01a7336-23601dc0136mr171113735ad.36.1749426160456;
        Sun, 08 Jun 2025 16:42:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhhqD14zLILdtjSL+nHgtl9T+hPRFKWMZ0ZPJay0gEN8OyStVlbzILHd0cwkG13OOqkgTWcw==
X-Received: by 2002:a17:902:d483:b0:235:e1d6:4e29 with SMTP id d9443c01a7336-23601dc0136mr171113545ad.36.1749426160106;
        Sun, 08 Jun 2025 16:42:40 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236032fceb2sm43669945ad.96.2025.06.08.16.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:42:39 -0700 (PDT)
Message-ID: <e37faba3-b0f6-4cb0-bafc-f99573fd4adc@redhat.com>
Date: Mon, 9 Jun 2025 09:42:17 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
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
 <20250605153800.557144-9-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-9-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uvT8ghZOcgYrcTTAhd5e4hsG5UUyJgw0tORe7xIRu8c_1749426160
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory from host userspace.
> 
> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> flag at creation time.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 13 +++++++
>   include/uapi/linux/kvm.h |  1 +
>   virt/kvm/Kconfig         |  4 +++
>   virt/kvm/guest_memfd.c   | 76 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 94 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

