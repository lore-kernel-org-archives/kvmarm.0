Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2E83382DC
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 06:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774247876; cv=none; b=QGE8POXwgbsx7qgIMbeebMI/AvtP3169aqzIzdCOu7o3EXMvSSOUR6ALON0NnMU+w9+7EmXPOp303tnk80Flyoiiqx9Xmt3pjeBepT3QJUmNHZFytyKYeeA3Bot+hZVPI7tzxtJXD11S6kY57F1NGpHSAa5Af3tRW75RZLWtSBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774247876; c=relaxed/simple;
	bh=qOagRt1/NRe7HbDeaKAzQ9u/KhNjsAjWbYHZvrS0+AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PSPrXiQZ7wBb/89RlMJblGtL3lK082HuQqYsGoel3zEGXQQyKTnFP2TLAAxpi3HRgtcYHvlCEEeshjjhRx5mZJoF0kzaoUJd2nNchEcOF5OOgLj2EcJU4Bjbs+R7QxomsJ+miBPL8sVh6uRx51dc4SuDiM4MgrsGWkKf2m9NQbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UB2IdYLc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UB2IdYLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774247872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISK/exyUdJ23yO78+Gn42xzI5rMH8hkY//83Yc4RV2Q=;
	b=UB2IdYLcd4yOyAhX4gKG3HLhsMAaNZWK/ctv05+d94vqUEX7boBoxi5NSG+u8eEWOD4jTO
	f43H6Z7zY5di8iifGNn0xCTmlcKknlAiYGlAjCJ2W6cR6JvyfF4UcnsLLFu8QbVDLc3qyx
	F+ybfIxCXY9G02jGiyF3rqtWoly7CpM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-AdCbBlvRNE6ndx0VjzczVA-1; Mon, 23 Mar 2026 02:37:50 -0400
X-MC-Unique: AdCbBlvRNE6ndx0VjzczVA-1
X-Mimecast-MFC-AGG-ID: AdCbBlvRNE6ndx0VjzczVA_1774247869
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3594620fe97so28955990a91.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 23:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774247869; x=1774852669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISK/exyUdJ23yO78+Gn42xzI5rMH8hkY//83Yc4RV2Q=;
        b=GkeHSxW3CCAft3JLToTW8I07hNAJaFtBvgtYqFK6xXCR53IPmvO1wogKlX38oKoVlP
         Na6kC6cg1wdZgYKD7sBgLRRK3zWV3mvcM+iXzz5n02J3En8j+Guj5+NxD8rKIOSgFK/O
         YobqP41a7cCwJkqao+hH1bT/c/eVNeUYO+KZdddesHXaeaGo77CcB5yXBZoab/e7yPk3
         SJOH/axTQ7a2IYPwxkYO45PrmiEwo7MJWwnUu66k+SZS30o99VkC/8DsvNvqVJWLC2z5
         offdHHgRGerN6PErLsTNgPeqqrtAFE3QY/1oQ+kYezRtMXWgAZDVGEVrc+P7OaC9/dTp
         LNiw==
X-Forwarded-Encrypted: i=1; AJvYcCVTbK/Z3kROktEIKU7f+zNy6qwza1jNoVRcNS24KOEd7GW9kgqyD85CQW7OQuaiQqJ8Twpv6bA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmHJN6dMVHToQL89aiIUhp/I6sLukh2H8zlmOXnLIu0uj8mbjS
	yq3fgEad+qe9h3P2TYqa/qrn9X/yxSgsrPIOcOpT9GfwaEJ/mQ4YgmAaM7axqoW0xQR1vE7q1W4
	nCBMQxg3S5vPYDvfNgwjD2TCVVxEWh8b5a9e3pFtlSoL8UtdcIIInUb4yOQ==
X-Gm-Gg: ATEYQzyl58OG6mOmtXbowR4uIelFYOieEhjFJQlssje0MYhRhAg+K4GjAPiJzzrVzLB
	oyTlIA+S0nD54p5L9zWnC8IG5rzpvSM4YNxbBlj858bVSoi2VPzHuSuyUr10qxshw32N/MgipkO
	XixiCiJeixWEZGKCJVEZz3Ou6dqunFf+cnVSmjcCzeBUCQSKfQNfYe4AEjb1Gk0MJFn7mwFErZf
	gTTzUmlLWWPrSjRc8ws2OOvLQk/KT5t01Lelmen9TvU7IjcLENcYNxq5oyDEax2zgq2r715NE3W
	PtaKscfhQnROYca0ruJi8GddIGeLkbaUOgFadxd9Xd/tQPv4G1k77Y/lDb4bGKR3kgk8SOC1UsR
	ov47ath/3vNblkyslaNGpHK7INe5Ycu1yZraoLEoAA3dehZ2+9xvbbB+FvWWVOM0g
X-Received: by 2002:a17:90a:d406:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-35bd2d1f007mr9090128a91.23.1774247869502;
        Sun, 22 Mar 2026 23:37:49 -0700 (PDT)
X-Received: by 2002:a17:90a:d406:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-35bd2d1f007mr9090083a91.23.1774247868996;
        Sun, 22 Mar 2026 23:37:48 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc60ec3aasm10906457a91.10.2026.03.22.23.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:37:48 -0700 (PDT)
Message-ID: <9f5fa983-155e-411a-b543-e7626d6f04b1@redhat.com>
Date: Mon, 23 Mar 2026 16:37:34 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/40] arm_mpam: resctrl: Pick the caches we will use
 as resctrl resources
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
 <20260313144617.3420416-16-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-16-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: skEKreJK-nKzzNGnEnVFCa6RuQxVR_2OexHQRXv2O90_1774247869
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Systems with MPAM support may have a variety of control types at any point
> of their system layout. We can only expose certain types of control, and
> only if they exist at particular locations.
> 
> Start with the well-known caches. These have to be depth 2 or 3 and support
> MPAM's cache portion bitmap controls, with a number of portions fewer than
> resctrl's limit.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Jonathan:
> Remove brackets
> Compress debug message
> Use temp var, r
> 
> Changes since v2:
> Return -EINVAL in mpam_resctrl_control_init() for unknown rid
> 
> Changes since v4:
> Set alloc_capable after other settings (Reinette)
> 
> Changes since v5:
> Missing 'have' in comment
> Set cdp_capable to true for L2 and L3
> ---
>   drivers/resctrl/mpam_resctrl.c | 91 +++++++++++++++++++++++++++++++++-
>   1 file changed, 89 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


