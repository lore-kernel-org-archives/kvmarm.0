Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488723182D
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 04:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774240665; cv=none; b=FzE/+9pg6qM4s3kUghqxRz06+hW1fJZoeXK3ClDpshKepqfImW9dQKxNEdP6mf/MKMhVrQqcZ1LZudzRg4oikJ3whQmeCSWrBiq2eFnbreYLwz/2QTFpq6tKSV2xExS+dEPqFQkLMx4XZuh314IJSNkFk9Xv1O346i12jMmOBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774240665; c=relaxed/simple;
	bh=/UDXzJUS8dpjDnhJHhQdc7XkITO19BtfWg/emBUvjrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuB/wceHNf+Ww8OrSYQnPn1Rwg7yj4QGltDVtcn2OdFHbzsuzTyv2PVwUq05gF2prJTFpGePt98C5bHJmi5EvosIgdKd1zmSmEc0tC607NqIxh6I55jUfCA/IEyNH4Zug/4PQks72UFQ5gYGHsHrBEd1OJczU32FTKkh0A2BIp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fROIddAd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fROIddAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774240663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPVOVXRS5gJ3PFDSRQQsaieeJxLwdueewdmFDIlgVy4=;
	b=fROIddAdBrQ18dl5r/qCGxXHYOk0Gp5dHNiLafUd26OCfyex/UgwwMEgiITw4LFTymP15Z
	AeGUf3rIPAjNoWNFNg1TB3o4bLTvdj0c352hKcgPKXEyHTcrMTCoRmpLaMBwGKyLFnJx3j
	zlALUW5BFW1S4Gp8PWnCtRAlY1Y2D8A=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-4c45VTmNMSaihbdejgINOA-1; Mon, 23 Mar 2026 00:37:42 -0400
X-MC-Unique: 4c45VTmNMSaihbdejgINOA-1
X-Mimecast-MFC-AGG-ID: 4c45VTmNMSaihbdejgINOA_1774240661
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35ba4bf54beso3376012a91.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 21:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774240661; x=1774845461;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPVOVXRS5gJ3PFDSRQQsaieeJxLwdueewdmFDIlgVy4=;
        b=EuPf2Bkf5HGPK1S6hNBg0Cmf0lF/iI/oxkG1qPywYbBi9jMyOuk9koZRIAqLow07Kw
         qCjOsbvtxCmG61W0JH57S8t7FDgKO4BeLRU6SOPR+nPhryv3yvx5PObMkJi2ZgUSqoTj
         pJpJObx3+8m9FocipSeu/9wWjI7x83I7ivafX5q7zYNCQciCLWT7W3U9CJfG8CAR5rrI
         /o/kz1gmHYOJdvJNoISaRrphfk2K3DLhoePfHf9vgeX69ckWN4dm14X8II2cvreJJJii
         NkR9jx6Jqd6kkFUSfZMbSFUkbp9B7MTNkjK64h/T3t3mb3Xe/7u9Y8iIF4kSFCpROmbS
         mmzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoPgf9nzGnPOh4ySfPDDa7Wi5bsJ0v+sD/8U9mauUORSrDUFtkeczoZAvVhkXeWAcflpkeUzc=@lists.linux.dev
X-Gm-Message-State: AOJu0YySjszpFDdRr4RrUQl8kmzbdk8bu+jAEmSwhxDxZ8C5btUwNfID
	oVx9AyAoRbRWTB+tYpUy8iPgh4I+DD7EXlJHHOgYeueDS4zlSIWVM4CH9gxWCaVbo8DAKJXZFWj
	+p2B5iSw2rzFooNq9YTxfnFpmBVqYoM7BPVTdsi2Djw+XD14elC3eUPzo7w==
X-Gm-Gg: ATEYQzwOW1B3oucGEWdUIe+jr/A0uQUNIw/WDBVM+ALOCHJVqFYz90rbJXaG87NYrpd
	DfOIMZ2r1E57sSLrVOyS2Z8GQQT28cIN+JeTZfW/GGxCt5Dv3LC2/4f8D7JopLlrB0fXnYIIpAD
	npSybwc5BTC9P/3nt+R8gXo/Quq8vXmuMyVNIk+EJiLMF7d5O3Upu/xFHHHZFpFTDe6x4BtliIp
	xy4/d8H3QsUq9VE7ZGOF6uKlnzuz3uGGzN7reaSyBm9Rw7LZzZ0Porn2E/o81Vm1I7PkLoZ1Tty
	FwJ+KLuAbSFn/35DBacjRwRmXksEoJu+G+pqPXLNVXNZG82/he2SWK9gz1JRiAakmnx4EbtMvos
	v7KoC9bvM97GGKAiY0sdp9qqeUUzO77ttCRJ+Vwq4QOb3XwmL/ZZbLop+KUNs7rOx
X-Received: by 2002:a17:90b:288d:b0:359:97d3:5c5b with SMTP id 98e67ed59e1d1-35bd2c6efd0mr8849934a91.20.1774240659482;
        Sun, 22 Mar 2026 21:37:39 -0700 (PDT)
X-Received: by 2002:a17:90b:288d:b0:359:97d3:5c5b with SMTP id 98e67ed59e1d1-35bd2c6efd0mr8849913a91.20.1774240659008;
        Sun, 22 Mar 2026 21:37:39 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd36b169esm3220585a91.12.2026.03.22.21.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 21:37:37 -0700 (PDT)
Message-ID: <ea006d67-34c0-44e3-8a7a-7934fb4da63c@redhat.com>
Date: Mon, 23 Mar 2026 14:37:20 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/40] arm_mpam: Ensure in_reset_state is false after
 applying configuration
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
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-2-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-2-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -yRuI2u7LD1NroUrZDsQwhRZSiuMluJWBOpVTbnD3lw_1774240661
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: Zeng Heng <zengheng4@huawei.com>
> 
> The per-RIS flag, in_reset_state, indicates whether or not the MSC
> registers are in reset state, and allows avoiding resetting when they are
> already in reset state. However, when mpam_apply_config() updates the
> configuration it doesn't update the in_reset_state flag and so even after
> the configuration update in_reset_state can be true and mpam_reset_ris()
> will skip the actual register restoration on subsequent resets.
> 
> Once resctrl has a MPAM backend it will use resctrl_arch_reset_all_ctrls()
> to reset the MSC configuration on unmount and, if the in_reset_state flag
> is bogusly true, fail to reset the MSC configuration. The resulting
> non-reset MSC configuration can lead to persistent performance restrictions
> even after resctrl is unmounted.
> 
> Fix by clearing in_reset_state to false immediately after successful
> configuration application, ensuring that the next reset operation
> properly restores MSC register defaults.
> 
> Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> Acked-by: Ben Horgan <ben.horgan@arm.com>
> [Horgan: rewrite commit message to not be specific to resctrl unmount]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Subject was originally:
> arm_mpam: Fix MPAM reset on resctrl unmount by clearing in_reset_state
> ---
>   drivers/resctrl/mpam_devices.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


