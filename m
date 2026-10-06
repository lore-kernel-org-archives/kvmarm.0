Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE422E719B
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256739; cv=none; b=Yp29/k5qIp/RgdCbI3upJr/G59WC6RQ4v7RBqjGgMKVQ03ndYa8+o95nWLKtritFGe+y7ibQqayDx9a3H6jmz/QA41ybKlW/rVUj950/+sQXMG59FDxWArTiJEX7Awfi9Dk5kj+Bqwmdc/6fPccuZeKZA+KGWIFWcBwrCOQIVaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256739; c=relaxed/simple;
	bh=ZVbjw66CG6A5xcmMat7LXv1MIDZBEKIeNvSdl57psXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qUlh1+K8yQNKYyQqIm7tcU1Sm/8vFpym6v+OrU3E4p3zLOlUcDsV/DhoVqUoQErhFL1VngnCGTeGH6HzJdl53Iuf8DY0+seBm6l17/JZrGdeQoaHMceaCf/dbgSZSng0m+aRhihTbOMJFzAZnTFCWKLzgF7KJDcLXlQMX45NVww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g31P7nmG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g31P7nmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791256737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jMiWdjITXmdV/ikrHHf6jmvGBH/AsJXpXasV0+qQL8=;
	b=g31P7nmG9tQVo/PIBSzRGJ0oZMkvucMrdV7XyCGIhtzDXAebd7pnVIv+otsAN7WNylOdUq
	oNCYZ4nreEC5HOhi+CMTLKGoO01fxVlRmDOnfrZxPCNx2uXSCCOK/kaFHbC82mdeY4FhYe
	49QXUbtUtyKaFgzOc0xASbIbUWrz1fE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-kZTqdId4NMusNmmkxCKsFA-1; Mon, 05 Oct 2026 23:18:54 -0400
X-MC-Unique: kZTqdId4NMusNmmkxCKsFA-1
X-Mimecast-MFC-AGG-ID: kZTqdId4NMusNmmkxCKsFA_1791256733
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2df8484f12cso25260635ad.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791256733; x=1791861533;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1jMiWdjITXmdV/ikrHHf6jmvGBH/AsJXpXasV0+qQL8=;
        b=VsZbFezpYvnKIndAtZE63ShAomDfRoUfcnSHl2ZJrPD83d/Bx0OCjFUjyCvzUiVhtN
         RZdlC7+p59yuIeses9S3ZTCfPhUzyMPz4BYy+1lzgucc2wgUOwKVicZdC9eP1fTb5Pvd
         s1nDT+LxGgju/TShlzXJBL/h+cuMrctyyIXZ9Hs0Xcy0xNkNkd01xKTOmwa02i1pmnZR
         7h/ee9w0Q5xYhOTz56fg8icU27g+VDv2rMz+7MM5dAzFgA1u99lvxf/i+SRMd+m/Volf
         Vq5wrh3HuiiyqtbfVxgePFy+pNkPIMAoPritI/7KQHAHuj6qZ/hjeR6wrhUp5Sn/bG8K
         pFaw==
X-Forwarded-Encrypted: i=1; AKwUvByRLwNxR9wpNyeN5FRL3QJmbmMQpNusm2Ce/8fADgPZDaHW06UB7Y+WQoOzndpgE8F2EspGwj0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIwbB7nT9ZA1fK6ehip8uZGFCTicoAmmoKxJbUleMqefSApaAOP
	EckxNSx+rma6A0kw0UAj1nemTtyHomIYG1zWmIkDF+k/lOTyFj/qgNljbbbsN5T4Beg84wzPvPP
	MkFrKqQafpIARH1FY1UagAkAZac1X2urk70ZsBfkf2xjOBRfA6xk8uQDYhw==
X-Gm-Gg: AYBFou2Orfgi+lqe1QAjtg51Osoaz2DI8m7z6+n26E0kvuRZlT3mBroE7RjCg6As6wP
	ttQaiCHvFBJrWhKW5qW9NeH/RCg3AiLNHRdn9a+3k0FczIyI739IvbxCt41lK9v6f6h2CsOR8xh
	qbBVvFsLJ5lUasjgXAkBSQ8RX+m6XZy7ZLy+fR35fg7pwhCGjAxSK01pJFRcLnkZm2RFc7+QdFu
	7Sy8TG/6T4CvdRhI1p6Rc4/Lp5oTWAnY5V1spk1urvNUm+da8JgoZvIXuLWTvfZNpBb3mHb700D
	35Cgu3e+PlVvAr6TbOJOcwEntS+dSrMhpzZupaMHdFIK3CFkeSBnmbWTbYOfaOp/VwoRcOCrJPZ
	sM7k+fopcTwc/xJDET5VwXDXs+mm4g0rBugg32ie3Kg==
X-Received: by 2002:a17:902:c952:b0:2e2:dc54:3148 with SMTP id d9443c01a7336-2e5dcdbe031mr1348345ad.66.1791256733315;
        Mon, 05 Oct 2026 20:18:53 -0700 (PDT)
X-Received: by 2002:a17:902:c952:b0:2e2:dc54:3148 with SMTP id d9443c01a7336-2e5dcdbe031mr1348145ad.66.1791256732898;
        Mon, 05 Oct 2026 20:18:52 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ecf461sm15865645ad.53.2026.10.05.20.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:18:51 -0700 (PDT)
Message-ID: <e556089c-18bf-44c2-8b94-3c558b0398db@redhat.com>
Date: Tue, 6 Oct 2026 13:18:42 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 17/23] KVM: arm64: CCA: Add bare minimal S2 operations
 for Realm
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-18-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-18-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pn1egGONIr36rwnMv-tEEucTpYi_b1EyRd4hsGCneQ4_1791256733
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> Add bare minimal MMU operation hooks for Realms. The mem_abort handling
> is chosen as the default KVM variant. However this cannot be reached for
> Realms yet and we would need real RMI command support to make it fully
> functional. Similarly, unmapping stage2 requires RMI command support.
> Until then reuse follow protected pKVM hook and ignore unmapping.
> This will be addressed in the later series.
> 
> RMM takes care of the TLB flushing as required, when the Stage2 is
> modified. So host doesn't need to do anything explicitly. RMM doesn't
> support access flags for the stage2, even for the shared IPA.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v21:
>   - Reuse no_age_gfn for Realms. Also use no_stage2_unmap_range for
>     now, until we get proper RMI backed driver.
> ---
>   arch/arm64/kvm/mmu.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

