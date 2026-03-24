Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AAB3B0AE2
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 06:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774332319; cv=none; b=fltG5zLZc7L8QuRLXt9fJJET1Cdn+h4WO3ae99D3M6Cf5uKmF/KuYRPl6yjNV1PLLs5O8ilg2TaXpH3mnTsaMzCbKP1HP36/xpl0GNZVTCnvksfXpufq2Gtt9CbtfKiQQKKYHKhxmlpImD8zcinU/TVdnPWj2StLzfFMteZbHUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774332319; c=relaxed/simple;
	bh=9kKEAqIsofsf9j9eZKJ2uLxM6sd+kjyOhrgvEs4OXX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E5+J6q4qlCH4co13k2ftj8n38qwVBwDtyhA2OJV0NdcpI97cQTTz0P8PoJgGnwh2EDTwATcffRkpDcD0C84fRYGvrCyCAv7eM/MybM6RFY+IQkIbhYTNocysfBGCHRg4jYtf8j8f8/fANS+dbSfr8Mih31uv7ePL+TkRFp/kLS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bg+I6ODz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bg+I6ODz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774332315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xw85OR1VT86W5/UYlwDEouH2+FNxd6th+BcXCbo6xiM=;
	b=Bg+I6ODzXzn2SKU0tt+vxyVTPCtTfLRPtPfa+CdGFnuQkotIaXWmfxsDxn4ZP7nxYwXbag
	o7ZThcAu3ns+8iQnpJC5GNQ8uCnR2AgFBs/a3OS9rsTDhKS7jIO2EXxyO3oRA7evIOdZ3Q
	tmpfTFXCOQ2gVXnZJh6gOW4VWrlKduM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-0qEL5COhOr6KbVcgSqdVsA-1; Tue, 24 Mar 2026 02:05:13 -0400
X-MC-Unique: 0qEL5COhOr6KbVcgSqdVsA-1
X-Mimecast-MFC-AGG-ID: 0qEL5COhOr6KbVcgSqdVsA_1774332313
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b061868724so24411135ad.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 23:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774332313; x=1774937113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xw85OR1VT86W5/UYlwDEouH2+FNxd6th+BcXCbo6xiM=;
        b=WlbTfnlLQUal82brzNf+XN1iIEXsEIApUb2DHoNw+KN6jds6IsNfBBzXezdXJBV61Y
         PoODrs5uVX3vUOMomw0V/JUvOei9byHxStsXesTFPbfC44uZuNK39IbAOSrzoSnJqceW
         We3R2IINs4oo5hCujtYEX7i7BrCyXOaEozCJRxMJfNEzVVipcDO2opIO/abUPDWbNNRb
         KYgzyWAgc/uF5EimpbPifEOHfL+iBxeSttk8FupHqs2qm9F4BvNYx72UoW//tGr3RVnd
         YbjgeU1uH9KigZh/UCOJY3RCUU5RPm4aVRaEqbIfF8v75nNNVRE5DyMX4KEN9wPo0fJT
         /80w==
X-Forwarded-Encrypted: i=1; AJvYcCUnt/SATJ3uHqnPb8xDV6uF0hKOKjkcjRAgJLVONZz6i34y6oFax0ubEAxlbmuRDMfRR3xLkUQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx53CKtE64HJ5Yx6KIs41d0c79Bs+WlMO2mvrpXZPzLo5bjzKhk
	pA6Cq126laL6Lldv63NbmdniMIx9J9c3sy23FLr0tvTn6OirjtQSp3NzQYqLCQjDhyhvbuOKkKq
	aDWm2AjuaS87DZyoeByN+sxdkcHXozqYQSAdUny2qsVjclB+9dkiwYrlpDQ==
X-Gm-Gg: ATEYQzyHKO50ZmnMqOWECx6uaIE4aFNtKa8yn8O22eMzaZiqi55qAhQvD8N4W2Ow+QB
	wDctb8cs0muw+6i4hNIPrS7GUVaVihhwfTmsSoK1/vxLTL7mbPQAmtqz9V4RQVL6MqAdyhWHmaE
	UKmKkaQNsNf+S5OU6VuvlyPVtFVXlVFyFfyHnRiXJbHwvufhI747kLVQs7LU4osbLeOgzIR3Faw
	7POo/vJIlTuSMjUcAWG0p1/mey0DFTNEYUrppvu04Uj+NeVJ8GZAjiRe4fHv0adrLmJQzutA96R
	puUqFkcUeUTLCNwAfk5JXktapGcMpcCZbGHHM6uUnKvaoJv3V5R3eq9zrYsgFyHJPbXPjRV+fqL
	nzai9o4AxHj38Q+S7rD0+9Y6L75euJjxZdiTN4f6UOlF3fv/ntiv9mKALvcbwkMeQ
X-Received: by 2002:a17:903:288:b0:2b0:4554:9c24 with SMTP id d9443c01a7336-2b082797405mr140735085ad.32.1774332312854;
        Mon, 23 Mar 2026 23:05:12 -0700 (PDT)
X-Received: by 2002:a17:903:288:b0:2b0:4554:9c24 with SMTP id d9443c01a7336-2b082797405mr140734575ad.32.1774332312435;
        Mon, 23 Mar 2026 23:05:12 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836556desm174549575ad.47.2026.03.23.23.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 23:05:11 -0700 (PDT)
Message-ID: <6373e449-6bbb-4fe3-b140-6cf452255558@redhat.com>
Date: Tue, 24 Mar 2026 16:04:54 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 40/40] arm64: mpam: Add initial MPAM documentation
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-41-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-41-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: emshs2AhEIRdcHVXwt081VCHsi6-RaW5sspD1BvcMKk_1774332313
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> MPAM (Memory Partitioning and Monitoring) is now exposed to user-space via
> resctrl. Add some documentation so the user knows what features to expect.
> 
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes by Ben:
> Some tidying, update for current heuristics
> 
> Changes from v4:
> Fix unusual indentation
> 
> Changes from v5:
> Drop cdp (under CONFIG_EXPERT) and mbwu (back with abmc)
> ---
>   Documentation/arch/arm64/index.rst |  1 +
>   Documentation/arch/arm64/mpam.rst  | 72 ++++++++++++++++++++++++++++++
>   2 files changed, 73 insertions(+)
>   create mode 100644 Documentation/arch/arm64/mpam.rst
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

