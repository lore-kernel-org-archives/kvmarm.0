Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BED3A1CF3
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323748; cv=none; b=kGw1DWjmUWPbaNyWNG5Li7ug/hUtUJ3Sxa8rauIq2+hm6ycfQercDkawcNoYt+aJuTenN+GAUatyM72d9AP0aeNtavO0CqGF4tNCPgSfGnaXbYx3D5AA6ymcDroeaEnjpaqwnXsS117iVpOfAHjccfkPPrpBNySfvmSLrQaDAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323748; c=relaxed/simple;
	bh=8/USL8mWGPHghXDUqxrg0+CHaM95YmkwRKfFmCfxl80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aej1dlb9doQaIEax4lVKJIOorI81tQDjok+HKCwsUD4NB6NZg1lsygubi1hoARKdntmxNI+z48VmU2RbXDwHfS7FZ0Dxiuu6IkWvakpk83Nkj0jFHRJDA7R2BmAFFynB2DgmqNTBSqoLlHR7b1uQjs98mmo+k7JRkSxT+9a+pN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMclFvxL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMclFvxL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrY75ExbEGwLC6e6b4hm5qIxC9Qaxczyg7KXVZhCcHs=;
	b=VMclFvxL8GlFT4RJJBQoPoo3wXQI7izBAt2msEO2Wdk9IF8Z1wUkPm3p5nx5bcVmRogzqj
	zyfMeo2y/HszsRqnd7MhlMG9/N1cOBEPsU0W7HS0Y+t2RHO4NB3o3m2nqPVsTSLxeTMAvj
	6K4FNVeScRqFoueTMwPxmZDeK9pvKKw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-3v2a5Or0PjmG5w45sld47w-1; Mon, 23 Mar 2026 23:42:17 -0400
X-MC-Unique: 3v2a5Or0PjmG5w45sld47w-1
X-Mimecast-MFC-AGG-ID: 3v2a5Or0PjmG5w45sld47w_1774323737
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c74217894d9so1965082a12.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323737; x=1774928537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SrY75ExbEGwLC6e6b4hm5qIxC9Qaxczyg7KXVZhCcHs=;
        b=mJp74QNI7RVC5brtRR/HL8gNyG+OE0veelPDjVxJ5dbZM3CdZmSvqPo4XGK9d01N7m
         Leq+lVhb8K0hciIdKTKGZENJ4Ak0Q25Cd+5aPVrscezKQhCfR3YfV1wU/3d+348Y2LHw
         611511qjG52uKmoLXDiSc25gbkRhCIpT00raRIKmYMUoHsEzIywAmyAC9En0aXReRaOm
         o9u9epycLKq1VpyzCEEuge95Sk3gVH4H9fTgPwvsQd8tMmcS47wLLTzA6VIhKzDj8daT
         9N8H+dPLgDWvC4G3s9AxlbiGysuNM+Pvxy3PpW/nE8wzcNvfJo0iK2pWXesQDSbvpdkz
         49Cg==
X-Forwarded-Encrypted: i=1; AJvYcCUYF88MT6zMDMbv0wlrsgKJCNMGJcS8mYUYJactZaQxfMBfjgv1lqEjoI3LgOCRBSNQC7isVNI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrvgCG4Gdh/SqqJzdYau4d3Ik0kKEQ0pqH55v9b/FYc4QZnu3o
	zKqgSp0cZELb9HgUzeWcQos6mq+GhUVz+JBiO5ioXGhTtqm3QNNDMEfTS76ZMqR8AdliwCLNJpk
	v7YaIcpLAHzAIHkE4Piv8QTvEAmGThgzASrfh5VZKOUYe91A/fVvZqnJsXw==
X-Gm-Gg: ATEYQzxNxcUeTg8KrV/wLMuxA5ZN+rzREBz21vdbs7nAvm28GmpPeW4LMga9VSXrHcj
	fDR9AuOLX0jDdZVNGdr1YnmrwD1hlBb66ZurS/bnK+IMzPjDQdjLOYFlUkUwx4j88/3+WfBmEko
	6OGXDQpbXMgdRQ39dHNl9Mu3auAizg54uqWzen6mHadYEnHUvawDwzp2odNQp1zmSXBkBjRkPPU
	oE5eEv7/tDPrhMAdLuUfVKFsnHcSEa2N8lzhBQaLw69xZELkFsb5uz4ss11aU28gLP0H01cfutL
	iFhcf074r4c+N7CpbV99FYwFZxQW2D5zuHHoH0Ha3kbCzjtr9Sdg1jMu/KPNyk1JDqFG04wNlgA
	O1NkgcaLCew1VkFq+Tl1+TWYCMHWbE3enCg05Zk2ipMleb5gj4n2SOzBTg4mkTBg6
X-Received: by 2002:a05:6a00:9082:b0:822:682d:2c5f with SMTP id d2e1a72fcca58-82a8c351e8fmr11844799b3a.28.1774323736534;
        Mon, 23 Mar 2026 20:42:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:9082:b0:822:682d:2c5f with SMTP id d2e1a72fcca58-82a8c351e8fmr11844744b3a.28.1774323736109;
        Mon, 23 Mar 2026 20:42:16 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bc1ddasm11266861b3a.19.2026.03.23.20.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:42:15 -0700 (PDT)
Message-ID: <2821b930-3cee-4358-bcfa-1374c5cb2055@redhat.com>
Date: Tue, 24 Mar 2026 13:42:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 31/40] arm_mpam: resctrl: Update the rmid reallocation
 limit
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
 <20260313144617.3420416-32-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-32-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wA_2ALBvr5cQWyxXtVQkiP1XmBCgYUdLjxTkn05pF8A_1774323737
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl's limbo code needs to be told when the data left in a cache is
> small enough for the partid+pmg value to be re-allocated.
> 
> x86 uses the cache size divided by the number of rmid users the cache may
> have. Do the same, but for the smallest cache, and with the number of
> partid-and-pmg users.
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
> Changes since v2:
> Move waiting for cache info into it's own patch
> 
> Changes since v3:
> Move check class is csu higher (just kept to document intent)
> continue -> break
> 
> to squash update rmid limits
> use raw_smp_processor_id()
> ---
>   drivers/resctrl/mpam_resctrl.c | 39 ++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

