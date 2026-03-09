Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692B02749E6
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 06:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773038580; cv=none; b=Xc7C4472mIgGwKZ81CnaVbp84I9MHaXArDQ33hLuAZF4VFir4UPhZ63vbIig3x6uNdvGnKN/eoOnc7NsR+VLhlN2DnthDoEH1x+dMpBqLpfPzZRxPrVCx8Y/NFKpuPig8QPTcAjS01oqCRDTgpccZfMqQhuwSS3HzNRG4Bl0GOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773038580; c=relaxed/simple;
	bh=Glk260ZjXi9sbAFj/3Lolll4je+D8PsPOHio77eAtBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dQ1a1HFxYcCSM291lIwbGe752/IpEweCatoWxzRfnpGOiMnrUOSTlOHMWzQn+gy2hbXbwz2RY4T9yGVILq0h4uAtOaU9NRVEqvjeqzNhtEWHnFtw2ZneSt5rosceiQmGwPQ1XvjWQhSLo3Ty8Nhc+kml2kpJ21MX22Gxmnuf0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEnczJZm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEnczJZm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773038577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHOnhMTOgxuYQIm/RtVPW9fCDLVlAoRkKypHVQyrpc8=;
	b=dEnczJZmoFdiRZcdtE2lUaAsGEQeyr3p0eUxvDeFs7LeP98oM0Qae1FLsWN0a++kXZWkTd
	kth1jsdMJaFGnVQQX1rB47kki5SfV2YSLKl3b8jkSPeiINrUvxCys0/Hu3OGjCyyyB1xM0
	gylk+Mm8vId4Q/yV2BiMIFkq16nWopQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-I0GqvzR0N8uTAQCsK6psAw-1; Mon, 09 Mar 2026 02:42:56 -0400
X-MC-Unique: I0GqvzR0N8uTAQCsK6psAw-1
X-Mimecast-MFC-AGG-ID: I0GqvzR0N8uTAQCsK6psAw_1773038575
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8297d261a67so1615017b3a.0
        for <kvmarm@lists.linux.dev>; Sun, 08 Mar 2026 23:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773038575; x=1773643375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xHOnhMTOgxuYQIm/RtVPW9fCDLVlAoRkKypHVQyrpc8=;
        b=Q6PbOeG55ydV/Q9sKlCZuxVOHtbdfMNnezm1qDb1lhbFQogtdaTKi2z6Wr4ly5Myvv
         8mDgtSLf/gfkS4vutpOtGF2dp+7bjOZJnE6e+h3+lMLT0ckaF7EXlqC7omXkz5BaRLiV
         pw0efBVmpxKZlHsgUXGRiHaKwsmjR6ze7rOgcP5IqkoW0Wt8s8i17aZ2sRmslOayOWkn
         B1mL1x2lgj8JqYTeJLa4XbD84vw+r8r66Y3Zc5gPURfeGkARW2zX9D+DouAOWsYx9K25
         GwL8FlL5YUFsF6D+zrUGcQFffL9sSGMXyvsXfetoz43ANSojUn7vd204elnGYYB7sjCP
         +84w==
X-Forwarded-Encrypted: i=1; AJvYcCXjYXeAihb/lgHlZZzWYv8UtUqXRSV/npFzJOX9Oc2i/8IYaPUHSym7ZanzIr2eHC6Woisi5cw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsWiTQEDmJoIDpA94OR5QysTDxqjTE6WFi5vIDCzJGH4JkObrZ
	jg3mN+GMILb0+qABIKd1OWIlnX8lQnqWOoz+yAxuW5ghMK+KMuMuuvPzb+xYU1a1vVIML5TYj7S
	d7Mbs5j3sJppvn0hLpUHy5eH8PvXKrlLU8SsoXsKunNXTw77myxo+vFUcEg==
X-Gm-Gg: ATEYQzz1epJtDqyniYwZFZxEhngmwyvdZTVhpSEOf5Xv0o6w1LtuSmGGPURhPviHBzj
	xOm2Gnm7QshUPh5zyxzVnQ7St4S40DENW//YkM6sP632qFUc10oSdMQBF5JaCYlPD+AHZQEioL9
	ufPkOUHm4NEm5k2YDjK0g8bLvZhqlPW/fKmrK6/gk8O+829TmhFgzbs6h7LPkMGLOpKkTXF0rAQ
	uUwES+rBI9nfZb2+Vp+IurCMKtNHm6aYBMsjdn+BkUZvdcNUTwi/PlxSw3ME+LQrJnNmVpCSa5r
	wBkZIqCoZIIFt8pT3UwcB1edjPqf+DzdsokmwernJaggi8ig7eEpmg6uZZFjQiQ9qatQoWv9pKh
	O7XPk1YjN78o05fg9ruX2wntnkiFJyNtAi1odxNEHy2266UZsE3jFHUD2bbSs0d83
X-Received: by 2002:a05:6a00:7586:b0:829:9f46:280d with SMTP id d2e1a72fcca58-829a2d81dd0mr7344337b3a.1.1773038575178;
        Sun, 08 Mar 2026 23:42:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:7586:b0:829:9f46:280d with SMTP id d2e1a72fcca58-829a2d81dd0mr7344309b3a.1.1773038574824;
        Sun, 08 Mar 2026 23:42:54 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48de551sm9217887b3a.57.2026.03.08.23.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2026 23:42:53 -0700 (PDT)
Message-ID: <43723d39-0ac8-4a79-81fe-1edacbec293d@redhat.com>
Date: Mon, 9 Mar 2026 16:42:35 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/41] arm64: mpam: Drop the CONFIG_EXPERT restriction
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
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-7-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260224175720.2663924-7-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9_yw9hA5LjXbXrP-2yl3KrYMG5AakjhHkT4yMdSSNbM_1773038575
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 3:56 AM, Ben Horgan wrote:
> In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.
> 
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/Kconfig      | 2 +-
>   drivers/resctrl/Kconfig | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

