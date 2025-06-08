Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D58BFF
	for <kvmarm@lists.linux.dev>; Sun,  8 Jun 2025 23:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426253; cv=none; b=WVyHDvs/9meF6nIeeHlwF/A89KWx/mTeqEs9W8BEQr3n36+1JZYHT0H1/EWxDzYPCrZv/TzCALd8bMIxBEZ+V2zxxHaeXcfPzdBk/nvdVcVjxjAVPJ7QYLQEhyPWsM7H96X4wFmin+eYncAFK0kkr6FUuxRAjot0024GURc46rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426253; c=relaxed/simple;
	bh=KEewk9e5U1qq2kwEdiMoGkLuuuW/JkAzS/DTU1PoK8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjGHZ25h3C4HJhAhD8FbKGU319LvfEnVdgDld2L6mjOr7qvA6IsgzS8qLgDsq77B9495GXPyJ87MK6/7l2Jr2UpKyHI+l3/DRAb1mcgqlADQFSx3n8mTTphY15Tgck8DBL6mXuuMwXMnAcbCwFL1pQb62N8VhHFK9I8KDZFaITc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5tkuIEz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5tkuIEz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RulDiaiDU+rd4MVUsTg3W37W6/YZMu9uoDiqrxmqIRc=;
	b=G5tkuIEzmtNnCz00iMGrCMRde0S8jK5662AzubJaZOJHW/mZ8Gi9t/zGrnRAmpr+Rhaxy9
	5ETsnyvKQZfKP/M/pUFQJHJuZ7QkpyieGSh5HM6mGg7cDO7PXa0SQOKKexrwUCSAfK4dbE
	fZdMA/Bacpg1ZXVKzJeDFpKz0IabejI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-9v8tHoH1MOKb7XgxJOgWiA-1; Sun, 08 Jun 2025 19:44:06 -0400
X-MC-Unique: 9v8tHoH1MOKb7XgxJOgWiA-1
X-Mimecast-MFC-AGG-ID: 9v8tHoH1MOKb7XgxJOgWiA_1749426246
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b115383fcecso2071150a12.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 16:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426246; x=1750031046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RulDiaiDU+rd4MVUsTg3W37W6/YZMu9uoDiqrxmqIRc=;
        b=M69cZF68q5QEAB+RNECgXKEs7prjrC5pjrEfCjXXliQjQ4UyJeqzqkyvS6BAwfD3g7
         lVPwgA1gx8B7zbniyO+5wOX+IoBw0l14VPADfN7twr4XUott7TGqn0jW/IhQzU1fhnAP
         OvuqmTcLgPOqEP6F11IN4fT8bHW/5p+GKsVnmrKOc+8T45NTHQDwftsrSnP4LZSTxLaG
         lWw9uMdK6g30Gg7GiOF0nOY9jkSWqGiuKejUfQrgLBhATmvccTPxS5bfZc3gi3YfqHN7
         mpRXgoh8hjLQDLgdtPj0lUHZmSOs+vvfpCg03RYd1ufkaTGkGte5eFyU7zJ9qhTDjkje
         NI3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVgPaYuhX7rVxxnN99DoW5r+j/GKG+mgcCCugkDPMCo89XyqWoxSGxO32/hzbpiRHRbEQz5DHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkSoRJorSGF3uP7stKZOK5LiUNK/mKZh2ZLFjutRbOvOyrMQUx
	a+Jldp3idTIYwKIs/Da1IB+0LL47hzt/wQx0vJaa4dmnOmuK0BmQTUg9pWxOhNpvJyBaITUlaTl
	KOKYug6bKspcP43oVKsexgPHA+ylE+S1wMdzqe//9FwtnHzPyjg1lwbuhpw==
X-Gm-Gg: ASbGncv3CScT8FLMliQnEODXVEaucLxKMW9DqhWChrpe/H0L2p1njtRXPuvKgOxrBsR
	9Pi1VqFTXWSLmKe/023aGzAehde2zaCjE0yh56LEkI+EACzvpftR8noLQCT5ME8kavNtA1klZTr
	DZDGL0OkAMuCvT5wA2ib4VqNyoIpuQqtZ4GZHMtKQ1WDiqAerQdDfGZi1QJVGDwCQHEezalA7Mn
	6nrR6O9G9yihomArB5Tg8/QWfY7vgdqTUo8z9L6kDCSF03ad3z1Hhro7tYEWUDvZQkfSy71Fa2Q
	hdkR2DoBSj3dikUU+y/8d47hAIohrU1DYVn3dmMYcsXlSiPlktoFYjjFJR+Fkw==
X-Received: by 2002:a05:6a21:a344:b0:203:c461:dd36 with SMTP id adf61e73a8af0-21ee257b955mr17179950637.6.1749426245871;
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSuWxYIxACJhhIZOfyC0tVrvvkBmEX9Mrq9tGz97R7mDt20pYUiPHkPZlAQCJkoa3KcF5ACA==
X-Received: by 2002:a05:6a21:a344:b0:203:c461:dd36 with SMTP id adf61e73a8af0-21ee257b955mr17179903637.6.1749426245541;
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2f5f782283sm4196986a12.54.2025.06.08.16.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:44:05 -0700 (PDT)
Message-ID: <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
Date: Mon, 9 Jun 2025 09:43:43 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
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
 <20250605153800.557144-19-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-19-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OEqkX1Wuzlajb7RZY_iLRueUZFapzTQv08uV-mGLaQE_1749426246
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:38 AM, Fuad Tabba wrote:
> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
>   1 file changed, 180 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 341ba616cf55..1612d3adcd0d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,8 @@
>   

Reviewed-by: Gavin Shan <gshan@redhat.com>

