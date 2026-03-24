Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE4D248F6F
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 04:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774326036; cv=none; b=ffq/RUsK4Vg0dkmTr7OOCAFrvJUMmmHqt3/bhlYRoEZkStw0A6d0xLnRLo78YMKewwXOD50+ngn9xdpcTkP6e1yLRIDkI1A+LD3RXPZYDNaHhBsRn7PgDRq9NaLwurJhy9VSNtN8FtAVy4ALCTbQvmIIF4S1zBIvOqYKccsVM6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774326036; c=relaxed/simple;
	bh=OPg749OON7RfZRMaDgp+5thwDl0zwptoRTpHoxI7PgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOrAGR2E0jlZWrRuMEXZMpBauJV9eiDwdv9uWQXjqBrLhzd8qFzlIekcmROxphgYwJ53wzbkyxEZcKOQeOEI3lK2aGP6Wq8uM3r65RwSN2EA5IEcB1bScd74MdVYVN67fYig5oYJtFm8cCv4nk0XuaZIELnOaMp+x4+a+V9/c/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=heW0PLXk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heW0PLXk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774326032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7h3rGPOyGuFqglRPNrUoy4EwKeWamb75bpgun6g1Zg=;
	b=heW0PLXkdhY4CVtQ19XFksDYds6IJtiUHhg7/Jz4Ea2z6Gu6b8aURdeorQbAIInbEUy/ev
	vGFyMcD22EcV8as9194md9nMoxr2g/51Ok9VUMXuk463C7YYU5BtLwT7x0f0t9JQHsnMjc
	TuImafU3liDqrnraHh2r99j5xCaMeZw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-b5FUbg6OP9O-gYUv7fxjtQ-1; Tue, 24 Mar 2026 00:20:30 -0400
X-MC-Unique: b5FUbg6OP9O-gYUv7fxjtQ-1
X-Mimecast-MFC-AGG-ID: b5FUbg6OP9O-gYUv7fxjtQ_1774326029
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c6e7f45e2ddso3030315a12.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 21:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774326029; x=1774930829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7h3rGPOyGuFqglRPNrUoy4EwKeWamb75bpgun6g1Zg=;
        b=dDMS93Mgwe4i4lEMqeOefcrLJE4uCQn2Zr4Vdu/JxOBHWgxM9oquWpReg7sA4zEOEM
         tbqhYqhPiNI1mNITWtrKxDcr5BUGGJadp8PXOG9PlGUb0FWK6rY1rtCP8pmhI3MLy9Rj
         suj1juZHpcrHBwcylR5gFCP8ojcqwGaGOOcmELy084tn7P7pgoAZsNXxOKRZWUguaZHF
         F6GBKPaxw25bN7GX346i0lnFf+CAOARflp7EmIX25/QvTciPjA4Q4lD8s/nVDM700OmP
         AIbm9LOe31UoA6dJ1yMm5SU7LEwRcg6XLfSIN04qU12cDYPmZGie3NcK8cSss/fVD5/v
         jMQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTBdIqbBfZlbYWT+6U8JiItMSJolFMnB34Sf5oPTGvnNTRWYSmB3WhuXMfHU+Dh1wFrQvxwKo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/UbzwE7hE6zlkGJVPkgwp8If6nIQccVD7hu/J/776kRBvBRNF
	WI8zKxwj166BK+R1A11Cg4AAsJp4hoIzX3tBwawYCwUEm6N8T5NGtCgX9Aa42EpQO+uMFiXG/ft
	7ihr2dco5DCYmTT/qePWW6vu+5DwIZJJurEUXQI7Myb8qYBNMRtzLCZjntA==
X-Gm-Gg: ATEYQzyVTnhrzr4TGP0RDf8eNhBaOEv3TXCvvxJ7HVk9vg0fM7DpfeXqjSx5yktgjlI
	xtcfi/gKCmVclr9E0dljsYXJ6egxvKo4AeF9iIwnI0HYDsdNmZ0OnSE0EymnTKy1WVJiCoAeI1k
	yXWj6+f4e8g/ggYREmlUbfnHxjj/xlhjyV1GgTGSpte48lUa6wrhjAV/uqxPNbU7Rl+F1s1cxZ8
	4sfJpmA4g7Qpvcc24Ht+wiaBXqd8ePkkKThVhDBzwo713Pjh4K2U1U8yA2rg5FRBKgIlxPyBdbZ
	2jt28SGFCk8EG83cg6z4uHUTFuJytG1ZT4lcUYnIkuB4G4/tefz0ISi8D3oV/+e70fcY3JmPFGn
	9hqLrd3+gwXGzEjzNNORdWDi7y8+Y0AuCF1Mrotv5D//GjbQxR4P1SnBk94xDcVDu
X-Received: by 2002:a05:6a00:1143:b0:82a:687e:c048 with SMTP id d2e1a72fcca58-82a8c2ef7camr12586314b3a.30.1774326028955;
        Mon, 23 Mar 2026 21:20:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:1143:b0:82a:687e:c048 with SMTP id d2e1a72fcca58-82a8c2ef7camr12586295b3a.30.1774326028616;
        Mon, 23 Mar 2026 21:20:28 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03be2589sm10542710b3a.24.2026.03.23.21.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 21:20:27 -0700 (PDT)
Message-ID: <ad5694f7-0885-4cb6-a2e8-112df5a498c9@redhat.com>
Date: Tue, 24 Mar 2026 14:20:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 38/40] arm_mpam: Add workaround for T241-MPAM-6
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
 <20260313144617.3420416-39-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-39-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5e9WyOzxgf8p1Fj_c4ddHNpYILkfZx6QW-5RUWOlrHQ_1774326029
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> The registers MSMON_MBWU_L and MSMON_MBWU return the number of requests
> rather than the number of bytes transferred.
> 
> Bandwidth resource monitoring is performed at the last level cache, where
> each request arrive in 64Byte granularity. The current implementation
> returns the number of transactions received at the last level cache but
> does not provide the value in bytes. Scaling by 64 gives an accurate byte
> count to match the MPAM specification for the MSMON_MBWU and MSMON_MBWU_L
> registers. This patch fixes the issue by reporting the actual number of
> bytes instead of the number of transactions from __ris_msmon_read().
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> Don't apply workaround to MSMON_MBWU_LWD
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 ++
>   drivers/resctrl/mpam_devices.c              | 26 +++++++++++++++++++--
>   drivers/resctrl/mpam_internal.h             |  1 +
>   3 files changed, 27 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

