Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC72303A18
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 06:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768459840; cv=none; b=agvD3gyUrXwbQcm47EawRgS5tjPvZXxbrQIbKqPy5D4zMk8s5th8M6Ub4Sh9IrFBQ3IV0tqjrQcbXWjo4eu/9rkJNJAYDUHcWYrMRu882hr94PRp9yNO8Q/Od2hTDvmkAwnFkWlklGQ7saSyrBsUv2hD0IPhu3E0SDoiBf74gb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768459840; c=relaxed/simple;
	bh=2xAHyJzr1S+OomHJLZRts8wsA3qOhJR+K9n71GjBoxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VIAykj8NApOH9RHApVmE3AHR0K/wIVtvPkAf0xm5Da/q4LrtJPzs2Zvt+1rsirVKkD5MHWcZCSd/vYiF09i5Oni7dwnpswXsJL8NiI9g6J7uO6YQs9BJzuFUtJ9m1nWokCQ+2nQ4Omrr5rfgyahYJO8XckvOPCwY9DweqzMXgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YjxyLnkY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YjxyLnkY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768459835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RKkwEaXWrytD3qRHA2b2ej40WFnskIIeWa4NljUliss=;
	b=YjxyLnkYk+AnEFygsjPWxvbSrVPfVqTcjL9kwh2lhQeyy5vxcJcxq5gwYVHHO4A6D30l8G
	zq4T0QjdFMFG0u3yY/oHvN4ZWyY4AXnivOoYVSoVg80dK4u4wmgAvCHgPRvjCyhnPzOO5P
	h5zDEPcj4LDjtseEz5IQTSBNXtOITTc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-71G2hlDXOiOrCKdz6dr9yQ-1; Thu, 15 Jan 2026 01:50:33 -0500
X-MC-Unique: 71G2hlDXOiOrCKdz6dr9yQ-1
X-Mimecast-MFC-AGG-ID: 71G2hlDXOiOrCKdz6dr9yQ_1768459832
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a13cd9a784so5018575ad.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 22:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768459832; x=1769064632;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKkwEaXWrytD3qRHA2b2ej40WFnskIIeWa4NljUliss=;
        b=K7HEsdQTEhViLb/Sjm3hnNmr24f5pXqYfgG0h0mBTMk/q2fuA1TqAjhiGuUtrHa78f
         bZodCGEa8jaYqD3shN4Vl/asMUbSDnSutZUt3spec74uxH6oGZHWn9ebAaPPHKg+7anM
         lMZ5zQjUvRSQB2w66+vvdf84onCLowy84GQutA4hWZ1W13+9dREvQm0d0OtvIj8tOEVS
         YI/ZUiNNGGvjt+cjTPAFgeJPdsLsdID7+UJVdYGYvvh7x6uF8scUQvs1ON01fWkTzf3x
         lU7u9p0J2JV2L4NV0XOIpp/1Z8IqnjU70g+UVA3yDV9b/bLPJFo8MiB+hYz1sPzYf18K
         CP5w==
X-Forwarded-Encrypted: i=1; AJvYcCVSIF7kRo4S3KWxCxbFgTcdTcZJy4NXLCVYyaBpFAY6g12hGA3g7fQt6fNXQw5ggEu+UNVqVN8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0txwe7XzKi/sTqOwS/GrK9rXU9jlwhX78pzEVaIzyKPPTNVY/
	tE054mBiWT28it19/w2pd/dXBCIscBIpliLgqyGyZKKm45/w2O0b1TswpUUPCU5CZ1K2IQZthLk
	ienziUA4cgXD2xGZoeUQjHy9XeU2cfdyFiRz33L9jk2w6MyhePwgZalhm8w==
X-Gm-Gg: AY/fxX49/ddwk9EmyPP0xNXYjrAf9rJVoegocWnBF4U7cwHcgIVtG7fo99cKsJyFYPo
	lbzRE4CF7b0ZejBqddHJUgFQ0f8DMBa4hoh74pMUVHiOWy9U450LKwIjig5QbOvOk3S3pfOTQQE
	fBiv7SgPtek/jwmINWAcyEbhAfSSl//c3kpbIsqiX8tL+pi1TOp/G8p8//DjolwwT6q4f4wK/Su
	DC+lEAShzjS9Nr+ZPLSVPaIAqYW2WF4e9Xxgq5fgHnf/JJsFkXeIvXZ0UTKW8UaSyU6J9aV5kZr
	IF0SujMhJwkQLEeTvi6Ew80VbeV8lTUwOnnJZjX6mGyUs1QkN0NKr46SvebWYqFaiEFYdB9smmO
	ABihmR7dN/2k=
X-Received: by 2002:a17:903:22d2:b0:295:5132:1a99 with SMTP id d9443c01a7336-2a599e57882mr56049915ad.44.1768459832537;
        Wed, 14 Jan 2026 22:50:32 -0800 (PST)
X-Received: by 2002:a17:903:22d2:b0:295:5132:1a99 with SMTP id d9443c01a7336-2a599e57882mr56049775ad.44.1768459832168;
        Wed, 14 Jan 2026 22:50:32 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd2906sm242216175ad.87.2026.01.14.22.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 22:50:31 -0800 (PST)
Message-ID: <1d6c1473-7267-47be-930f-a5d3fb525b94@redhat.com>
Date: Thu, 15 Jan 2026 14:50:08 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/47] arm64: mpam: Re-initialise MPAM regs when CPU
 comes online
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
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-8-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-8-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6dxUXTkUE6N9djNxy6x_s4KwNfUpwhBNd8oWSsAUvIU_1768459832
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Now that the MPAM system registers are expected to have values that change,
> reprogram them based on the previous value when a CPU is brought online.
> 
> Previously MPAM's 'default PARTID' of 0 was always used for MPAM in
> kernel-space as this is the PARTID that hardware guarantees to
> reset. Because there are a limited number of PARTID, this value is exposed
> to user-space, meaning resctrl changes to the resctrl default group would
> also affect kernel threads.  Instead, use the task's PARTID value for
> kernel work on behalf of user-space too. The default of 0 is kept for both
> user-space and kernel-space when MPAM is not enabled.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> CONFIG_MPAM -> CONFIG_ARM64_MPAM
> Check mpam_enabled
> Comment about relying on ERET for synchronisation
> Update commit message
> ---
>   arch/arm64/kernel/cpufeature.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


