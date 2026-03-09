Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6614A23B63E
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773038622; cv=none; b=slnD+TMCnSWjiUxJyEsjOLRmnU8c9r7pZPZ72Nynmu1kWKAkoyb7iK8JX7BFvz3d6gCviPS27zxT8jRV0WdJMYIVOgx+23GirIbnWyVP6GWzRfwic6gf76Es088gddvXa8ZznwTH2jqRAOo/SsR+r58tjC73C6i5TMwhl9JwGjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773038622; c=relaxed/simple;
	bh=oU0Bm7/iu4lAhhhD/58bCyH0Zl053YpXS3ZortaUj74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxfaFjGv6vuYEvEHtZDGq3AUQcfA/cedtczCe/AUNGc/yzP52FzkSAaqd8jLOzP4pCNMm5njc35odvbhv8kgerfiQHAcNVUBbeW31WO8cuzXnyBYOxfqvNPywvl60ULJ6vqGVw6h4lcdPpzOCPRS1TQ6taZCr+e7ke9jE2RHFaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPfWJ6fO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPfWJ6fO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773038620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/VoQtoxtMjinR0wQxRIglh5sEAwoToR0YD9sANGcxY=;
	b=aPfWJ6fOaLvfeGGYI7eJ0pGKXLerFZHnm4HzlAAQNtPbTvAasm95d55YpLjJt8CnmVZ0vp
	oZj4vKZq9M4MyrMH1HtNxAPugKK/fKjQqV0nCvzlGTLPkJqHNzJ3wj4OxeRQT+vqVCuTMB
	aT5d0R/MwbzgPNOYS28CgBxOjrAFsLE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-9x5tnB5cO2S8x2_TX653vg-1; Mon, 09 Mar 2026 02:43:39 -0400
X-MC-Unique: 9x5tnB5cO2S8x2_TX653vg-1
X-Mimecast-MFC-AGG-ID: 9x5tnB5cO2S8x2_TX653vg_1773038618
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c73887d0297so2300434a12.0
        for <kvmarm@lists.linux.dev>; Sun, 08 Mar 2026 23:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773038618; x=1773643418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g/VoQtoxtMjinR0wQxRIglh5sEAwoToR0YD9sANGcxY=;
        b=JByYAHopBUgnb1idQQBlYWqCA50hGHKn1SZNjHNNFDj1JC1w7nO/NJS4IyzQFQeA8+
         x+JjzBZj8KhOGJG2IBldBY3Sh5PWruzFFAB3aPFJOrw1WXlob7HNbpksdXEKTC6Xly2p
         oGSeXGxF7dWoYj9Q9XQPLZn1591/qtDGAlPF/YGKedvfWjcTAUo1hHM4mMsbhbmVZVym
         d9gIOUiRdlPdsNi7usqoDBtOKUSz55JR5D/Kc7R6ZNLSrK3PWuaORHqExZoEhN4A9FYr
         UoFolp9ezvEmoniVYkqcmOf4I4r70FBjlGTFTE7crVE+jAJH7wmHK87N9QDwRGyPOu8j
         nNxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEC+Y+1dkVqvT3XOBGuiN3orRFbvpypgrY5mtZwHSdak9CMKbIE+yK9QrRaEndO9dwxTVSRcc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxulmAIXvv6GMpDyVzHVGMWn4SK5Z7GxWvnDIx0RCCvAijUi9yV
	1pJlZbAeestJ8mZVkKVJacv386AaR7xTg/ey/xxrV4za3SUWyMx9b6I04G0NjXIlD35yxFDOSrK
	3LTqU+AF37B87OkkU6oWwDyl+EYoT1N39bzw6MGSaKsw3Q/+m5VZyepunPw==
X-Gm-Gg: ATEYQzyg0YB0wWEoZdpkWWkyes6axOFt8Key2wKEId3rCthTWkQClwye6ylZTiHqXRO
	WJzptv54I+eS2mSg2IxPcY0Xodt0vH17mEewItD87uVrkXn0V+lBqBaLBA9d7ZNZM1LiPixVCsc
	LxYnT5VdPm82JRS/GvbFloHF1+nxBrMP/yDOcejG2soR2gjnbkCU9fCYEdi7pqVCdrQ7ndMP4jJ
	VBF3Oo6oNE2ztmiLX/yYBQKermsto0PUkHf6XwuhfWLc2EtwtWPQBIUCi1tr87XCj3rQuk9CGjW
	f4SYMAUBY++O5UP2+/ukQhDL/Pw0o1ghGWR2t9XPEmNk1A43e6tA84Xfodo0aWt63W7wLRH0M4e
	1jkMq5srzFoMjnWNhQCEjwY2krtUGrb4JcMA6NXBe5GursuwVrENDaxbEQiwb2sIq
X-Received: by 2002:a05:6a00:3e14:b0:827:2995:3ba0 with SMTP id d2e1a72fcca58-829a2f67981mr8453014b3a.32.1773038618138;
        Sun, 08 Mar 2026 23:43:38 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e14:b0:827:2995:3ba0 with SMTP id d2e1a72fcca58-829a2f67981mr8452979b3a.32.1773038617730;
        Sun, 08 Mar 2026 23:43:37 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48d3871sm9235407b3a.60.2026.03.08.23.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2026 23:43:37 -0700 (PDT)
Message-ID: <57dbec80-4cfe-468e-b32d-7dc0f872ed67@redhat.com>
Date: Mon, 9 Mar 2026 16:43:19 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/41] arm64: mpam: Advertise the CPUs MPAM limits to
 the driver
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
 <20260224175720.2663924-8-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260224175720.2663924-8-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MlmJp-Trf6k8yf0CpN-yRnvl-gfNP-XGhj0_oEagt_w_1773038618
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 3:56 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Requestors need to populate the MPAM fields for any traffic they send on
> the interconnect. For the CPUs these values are taken from the
> corresponding MPAMy_ELx register. Each requestor may have a limit on the
> largest PARTID or PMG value that can be used. The MPAM driver has to
> determine the system-wide minimum supported PARTID and PMG values.
> 
> To do this, the driver needs to be told what each requestor's limit is.
> 
> CPUs are special, but this infrastructure is also needed for the SMMU and
> GIC ITS. Call the helper to tell the MPAM driver what the CPUs can do.
> 
> The return value can be ignored by the arch code as it runs well before the
> MPAM driver starts probing.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/kernel/mpam.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

