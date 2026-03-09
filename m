Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CFF31077A
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 06:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773038688; cv=none; b=Wl0hyzclLQMbA7DedVfacOUk+2j9mc4Ghc8wW3QDxaSXKmNbG0suEGR4MCipmoub30uOndB4oUp2yfSK3gahaQEIboNorTNFzHp4PjFb9YzKvQG5xoZyDj7pd4pq104j7F/5bPy97gh4BWn9OJ0IgQZPilasqnlIlJP9plE0mig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773038688; c=relaxed/simple;
	bh=m1GxzCYPJ7MlXMmB7qD2xXmMcNVIEdbrk/Y+tXCyqw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZ+xFLqLZFrFOqkDjsTQ5GqKJhZBZxV6hIFq34gk20t3TS3VBHZuJ6UyycHMjsfkhXW83oZstb5HDgzHKbv3gECOqrzuqxf4HUqyEz1lTE8MxFLV1JYKHimrmdEL5j6Cx7N/7sUP2gAG6FHBdqkwykMt4BXX9eqZNB8ZrTX5sOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkLM4e5J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkLM4e5J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773038684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FmyjTIiffZpRJPT+RQ+3fTrkf/WN2/enrX5xBacS+iI=;
	b=ZkLM4e5JDJLjYWy1ts0h2zutzP8R/tXDHt4vOjr9ZSXTsMCtC4xmKbWZMv4umZKnoXA1c6
	OTWPz/Iyz4BrdxOpA+jXNclrCnJaGvah+DGKlQjO1+PQd5beFEQ2xJl4e0RefHa+zHvoJk
	WXVqGJoBxjofGySfFsMgnIpUveZu3sI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-FrxM1WzUOeyKR5Bjy3wNTg-1; Mon, 09 Mar 2026 02:44:43 -0400
X-MC-Unique: FrxM1WzUOeyKR5Bjy3wNTg-1
X-Mimecast-MFC-AGG-ID: FrxM1WzUOeyKR5Bjy3wNTg_1773038682
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-359887aece0so8365931a91.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Mar 2026 23:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773038682; x=1773643482;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FmyjTIiffZpRJPT+RQ+3fTrkf/WN2/enrX5xBacS+iI=;
        b=s7foFWxqDvbFrEnjeHujRixu7H/Jeja4RiLUxjjL6oCjzt1y/MS9klnWPGpL4gsozk
         BBDYSE3xeMr13lGBdsROnX3+w8whowrpaSVNMy27mZvrHpgDDtn5YTmV+oih2KEuWazj
         6x++QX9h9iixPWIR7O/nk/MB73frJ3lT22zYpgcoJDO8BgT7JwQX4dq9zXMy05iEjswQ
         SFeUifs9zRbvb+ys5aY+5l0UWb1NGHI6AKqPxjuLNCA8QsSQAu/fm0P9P5YeW3SDD0M3
         s8opMYI86jZMvV0cbztJL8FK3sB4rfKkeAzWwoE4MfAhFtvedZKgekPSso4dC8quKp3K
         Nhlg==
X-Forwarded-Encrypted: i=1; AJvYcCUSUEqQP1YxliaEpJmykMW861422GKGJMerSvcIPq+XRWBJCNnFp5HTEaWbvLNbgZydSWlEbvE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/1EEzUWYlvdTTGY4RnBXw8N8aK5dkbXE5ek+AEz6c3YgKcgF0
	7Vk/MYrTwv6nUYUZmX+Dlr9V2NzxHoGSQJgg+Dfo5O0LUtn/FLUDecrXanQDi0tbydwFMtfkZ1W
	FFaoOukx+rjDtTXBnU8wo8Gzmok6+/2Gz13SVnxGQxoGj9robieGvahJAAw==
X-Gm-Gg: ATEYQzzBnXmRwQis4V8clOGvktf5G5Uh0/EIg3bgf7FHFfjwmA53lBE6ZmRsNglt2CK
	gZPKEsmIEYX3/nZPfw4DDuOqwedDHFfia0W8KUEa0JwxLnE6Oa3q3kggseSjvRC+B4UFvch2N5s
	c6Dt9157Y8tcM/sb1LujYPJBlipzmQXAD//oh1FoHSzLBmim4X9ZNClN32ilyOMp43xWDr2DmHq
	uNQhj4B8by/Rx8nbGHEiI4Lsdy4Y4jll9eILEC7b0/vzv3aLxf1iVNqGfhrL6fEyd5IW79PnahH
	l7ZKkMjeBIwzeqUd8V9/tn1p3v7QcXPs+51kOs1FcPGpmA4x5NTCuHLSZkbNAUZvYv9fy3OsF6W
	LeekzwU+knbSfguxAYToYBgtbGvilKCyEw2H08ktlmrr4/4xGc7kHQPk0Kk0/Zwc8
X-Received: by 2002:a17:90b:4c09:b0:359:8632:5e39 with SMTP id 98e67ed59e1d1-359be233b87mr8593327a91.5.1773038682491;
        Sun, 08 Mar 2026 23:44:42 -0700 (PDT)
X-Received: by 2002:a17:90b:4c09:b0:359:8632:5e39 with SMTP id 98e67ed59e1d1-359be233b87mr8593284a91.5.1773038682083;
        Sun, 08 Mar 2026 23:44:42 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2d50ebdsm12993555a91.5.2026.03.08.23.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2026 23:44:40 -0700 (PDT)
Message-ID: <c9a544ef-5c12-4ad5-8503-39c28375b419@redhat.com>
Date: Mon, 9 Mar 2026 16:44:23 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/41] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
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
 <20260224175720.2663924-11-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260224175720.2663924-11-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c7oVMRPWcfAXoNoRJkt6tPTZzzQqe__Q7cmoEiFfAC0_1773038682
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 3:56 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Care must be taken when modifying the PARTID and PMG of a task in any
> per-task structure as writing these values may race with the task being
> scheduled in, and reading the modified values.
> 
> Add helpers to set the task properties, and the CPU default value.  These
> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
> avoid causing torn values.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> CC: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Keep comment attached to mpam_get_regval()
> Add internal helper, __mpam_regval() (Jonathan)
> 
> Changes since v3:
> Remove extra CONFIG_ARM64_MPAM guarding
> Extend CONFIG_ARM64_MPAM guarding
> ---
>   arch/arm64/include/asm/mpam.h | 28 +++++++++++++++++++++++++++-
>   1 file changed, 27 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

