Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DA2BF011
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751637445; cv=none; b=ODMU7ht1+4uUOR7BYenM9d6Bo9fj1GGrCq7FPJOEPzqNeJHBZFFCS/rXsF3L2SYfxCDxGmiLfyfs6rpsA5muMAWV43+UX+nNbtkVZ326suxhugZezljBOlDuGDJ/r7G12dof0gU0IpHgk+xnopy5vk6cCZxCNRucFYWh40DndUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751637445; c=relaxed/simple;
	bh=mrVbBKc2xAL4q4PLsE+rbmw2en3poJcGcuEooY7kLpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X/wGlZ3DiZUeLoExH5KVwoPQTutP1tim71css9/j2nvrU4hT0OyOetSKSx70go8JIafKyzYk2XlMGziWVQnk5HDds+FR1O5L/Twz5BsJNks8XyXYty2KmloYqGNRX7rVvl/GkvwLxbh5hXqUFvZvcOEXqJ4TrTmSrZ2iBJl6tXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xwdd3Q4g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xwdd3Q4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751637443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ya7olpWaKo7EvJdDI1FNJDoi/Pi3mNyOZPA0TG9VvQU=;
	b=Xwdd3Q4gRvMroq7b/7o1Xjd0CfVYJLG0TcEcifnYiGCJpZKTeM34+ZO0wLHePsxqUeB89+
	Xm73ziZ5L2kpd5PBVKUI4W022a0+lBhirUbCDNTvmsA1RDgE9AzRbnIyYSVVrMycU1dtPF
	TO4U3zpff0TG1KiYBhk/yeHjhwrNnMA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-KfrDu51ZNFS158BRxoE2Rg-1; Fri, 04 Jul 2025 09:57:22 -0400
X-MC-Unique: KfrDu51ZNFS158BRxoE2Rg-1
X-Mimecast-MFC-AGG-ID: KfrDu51ZNFS158BRxoE2Rg_1751637441
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso580735f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Jul 2025 06:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751637441; x=1752242241;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ya7olpWaKo7EvJdDI1FNJDoi/Pi3mNyOZPA0TG9VvQU=;
        b=FQRGO7fR60V3ZY1Bg2M6w6+U9FskyOBcbVTnT0mDxJLv3ac2AwNyjWVs4VPZ8xiN1M
         CO/tux8BJBjIUAmeYB/94U5DzdfNImEDpHz/ix+Dyug61clKOHabwsBF9YHfw/+yR6jH
         tOB0g9QXjryeWdH3V+KE8f0rrBpYLFrp8sfl9zdUC6asm24Jv3cJtcYqodggORgXtiS2
         3aP45oV0i+PUrUiRxdRFTBQKc/eiTz3ax/BH04JgN00hlWhCeuquDqFzo5210W7qi8Df
         Fp3T9jkXs+nFLW/51Ws5wxU2eIbFelQZ+Pgxy/XE4ExJAU3GrzkIVfx1AYmJJugGgv10
         /rcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWmasl0LLwJGq8+pCYyTczqkmOPIU2lorEmSR9lvdQQVXvNYmUOFcMYrHN039pBNRTAZ9V6k4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiVIAV7AMpbFQttVoDZ0xXdbsIz4DH/i1BrA3fmybIcxupFO73
	5b/cfkq3Eq9qnQ2qDIyxp0Ui5YBaU2YCwa+3YjLkFgszuNHjmMF8Fmq372bSgQZQRmVH6D0zSZz
	mW5YLodB7zcN99J9h3q5PQNjXMMUNlYj8GvF7Dm1OhhrckFTJG2AUVkRWLA==
X-Gm-Gg: ASbGncutmNBA4PdNjKo/mtslQ2Pia+kxmm1/3c3rhzCX6VHCqWPtAnRCaF1+m9enINF
	lNMJAl8QS5wI3P21hMPtRoh9sdvaoQWBbKfGsWhjbFO6R5Sq2hRdmapBCyJMtutS0pNr+cA6fBF
	jcWH2mpyIgeeNhQYMv5+p+gWVGQFxLXk6OK+emPNN33mcqNbFsi7d081mDt8s1Uzb/M7U4sdiUV
	InKbR6zdC6OnGEqM2hzsmjvSqQoZ90k3LJRd/SwXfoRXI41JYZ38NP3F5piqUPflvRWbxbijcUp
	s28fsg3Yrr07XeovJzT0w8Q4pkVCFVwiwRlGQ+oFSPQrvjuwhUBgIGi1fUVLly2MsQhG/LMbqVS
	LMIFc1fhKX4TFyODA6KhufFiQcCvHcLQnJlORA2RK1pqIDSo=
X-Received: by 2002:a05:6000:400b:b0:3ab:27f9:e4f with SMTP id ffacd0b85a97d-3b497031623mr2343022f8f.35.1751637440578;
        Fri, 04 Jul 2025 06:57:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ6/2pQFMrT6QRPXJE31trAIEXkKng/iYOe8KKbT5kWjkE1JQQmcpiHONJbWK/qwqZ2Sobdg==
X-Received: by 2002:a05:6000:400b:b0:3ab:27f9:e4f with SMTP id ffacd0b85a97d-3b497031623mr2342968f8f.35.1751637440058;
        Fri, 04 Jul 2025 06:57:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:5500:988:23f9:faa0:7232? (p200300d82f2c5500098823f9faa07232.dip0.t-ipconnect.de. [2003:d8:2f2c:5500:988:23f9:faa0:7232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47285dda7sm2614728f8f.99.2025.07.04.06.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 06:57:19 -0700 (PDT)
Message-ID: <126f839c-f0e5-42a4-a172-2cefd59e5750@redhat.com>
Date: Fri, 4 Jul 2025 15:57:17 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/6] KVM: arm64: Rename the device variable to
 s2_force_noncacheable
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org,
 ddutile@redhat.com, seanjc@google.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
 acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
 danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
 dnigam@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com,
 coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
 linux-mm@kvack.org, tabba@google.com, qperret@google.com,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-2-ankita@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250621042111.3992-2-ankita@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mSl3_ms2cfGfMtOGkOaip2kW26JMI6rJewlnmQ6fw1M_1751637441
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.06.25 06:21, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> For cache maintenance on a region, ARM KVM relies on that
> region to be mapped to the Kernal virtual address as CMOs
> operate on VA.
> 
> Currently the device variable is effectively trying to setup
> the S2 mapping as non cacheable for memory regions that are
> not mapped in the Kernel VA. This could be either device or
> Normal_NC depending on the VM_ALLOW_ANY_UNCACHED flag in the
> VMA.
> 
> Thus "device" could be better renamed to s2_force_noncacheable
> which implies that it is ensuring that region be mapped as
> non-cacheable.
> 
> CC: Catalin Marinas <catalin.marinas@arm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

