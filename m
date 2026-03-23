Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEBB348883
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 06:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774248739; cv=none; b=twnjQ0cFHCp2MHMP0G+JD2L1FFvNaMYiu2rrj9pOHJ+qKdEWatXbZ0v2X8Ni2oYcYbwhGyO2dhFk20NvggUODn4CIrZrIyvbmhOIybMNpUfO6Ki/3LhebplQc+nkEvs58rMglNTmmqjNly16tU5AdKQW246d+O+6CBRcSOvj0aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774248739; c=relaxed/simple;
	bh=Ho3xMrajWw9hSp68d8ltLv/+KIt5O6ifbl/4YdZnT48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nZKPVyiC8dO48WWstuQI8tV3FJL4QNa0FFnhIEbOFiKh87ur/DYXiPvM/WdnhgIKAbLVFik13NaiHy9i9dBD8iO6QwlpJ7cDwFG53wQc4vHW/sLv7J3wpEN+WNrji/VbeYzFelz5IA8tOIP212jb0IyGKpP5nJpTmoYZOSFRgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/nJVevj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/nJVevj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774248736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NKbSNz1bnQPVRgBTucbuG+mAtDWNAO0AjF15TWaqka0=;
	b=V/nJVevjj0DjRhK5QX2jhgyM3dwptn26kG3yo2eeALJKzdaaknNAHEepA0RaZ95qqO9C2x
	A5uBRHFknoOX1FZo2IIP7TjHKcdOLO7Nqj1zCbT5Edh8kuDHKa9CH/FMBia05Ba+4xUv5I
	8xPhoicGPRgVDEN+qs1r9QzcfByo8gE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-YW_eUfziMCGSqKVCgho50A-1; Mon, 23 Mar 2026 02:52:15 -0400
X-MC-Unique: YW_eUfziMCGSqKVCgho50A-1
X-Mimecast-MFC-AGG-ID: YW_eUfziMCGSqKVCgho50A_1774248734
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82c4664f75fso490133b3a.3
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 23:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774248734; x=1774853534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKbSNz1bnQPVRgBTucbuG+mAtDWNAO0AjF15TWaqka0=;
        b=kgtGiBP6PxfOxrzAWuG4cizqync8zK26iT7x65iwaQDIdSh6jyNCud7tKUfo6yu+Tx
         pEgMDIJyigKBsGggHc+FIe7S5z1xUNkzvC6PU9+aJMarVWeUtzNhFV5WT4Ixt01iEkpT
         8eetkf86b92GWBMr5rA1xpr6xcdtjQay5qP+vdCYMoO6PaFRMh1UUxhZ7n+6/rFM9yYZ
         Z7Qhjbf34agYWPj2xkbG7g7YQEDSULggJTFdRLbDpqSSNxJsUjNrgQoCPFd7If3d9Jc3
         Iao/y+Bo9vfhYStOTWJwk/dH59It+/DBQUdfWVm4G4tQykY8jwJlfyuatBLqmziOLI7/
         REkg==
X-Forwarded-Encrypted: i=1; AJvYcCXaX/lYTn6vPUCQP5y7X/DF+86rqU3S1xKv3tmF+j3+/TpBwO52i7Ct/gr9M//Q56C5filrX9M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3DDk+qUCQqotSouy2EYIrmtK/Dt+mjUpbs+ycpeDavO0lqPOB
	koMa8ZRTbs4IbNa/oWQUmyf0WyXXCer+X5FgYqjASCYQDsStBbDfq6ERmvQ1FQv/dXcnjC2EZ42
	cM4rGFCNwR/RPjY0SA/jxmdPkLAFGQod7NJgqQJ9E3GGqLcR/KCSLsd3RCw==
X-Gm-Gg: ATEYQzyfYCfePAu59cO2JhK+ITyb4nBlE6K+feo6DDoKSdsNP9u5dCFgKQlHKoIjmp1
	zOzdlQuOkwQeun1Av9mT9Wpk/uc1zwtRsLDZwZehuujIU+72W1rtg7WCrLuMZHwzEXRuV6wMGmS
	c7esCVwJtaBKST85HVcjrcTY6BoYFk+a0sJQFrdrntRTDTBDjPUS9QGH4RJnFjUwVJMQq7Fumet
	qgOiA5xHO6n01Pi/K7qpEdMnDYrlL/fu8BrhqFczFyZB4okVGyhlMcpLqu9qmxA0BcFX+CjOjVY
	lwVAcitDq/+QFLfLlVNv7T4cv8RPiHg9sufVSlOyhV3EEhlBtrbX4GlbHzqTdvAbIITGfNZsl2L
	i3GpQ46GJcAOEYJzNa/JamapFxHdyA9vORp0aDC1wTymWVQNz5Mg2pAgudVyMfBxc
X-Received: by 2002:a05:6a00:23d6:b0:82a:14aa:795f with SMTP id d2e1a72fcca58-82a8c35da6amr9132170b3a.35.1774248733789;
        Sun, 22 Mar 2026 23:52:13 -0700 (PDT)
X-Received: by 2002:a05:6a00:23d6:b0:82a:14aa:795f with SMTP id d2e1a72fcca58-82a8c35da6amr9132130b3a.35.1774248733349;
        Sun, 22 Mar 2026 23:52:13 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbebbfsm9997455b3a.18.2026.03.22.23.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:52:12 -0700 (PDT)
Message-ID: <98e46fa1-8e33-4288-9894-e1756da113e2@redhat.com>
Date: Mon, 23 Mar 2026 16:51:56 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/40] arm_mpam: resctrl: Implement helpers to update
 configuration
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
 <20260313144617.3420416-19-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-19-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9PiPn7icciTFQK-wdxXRCHBIfnOgguls0Ru4stiQrkQ_1774248734
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl has two helpers for updating the configuration.
> resctrl_arch_update_one() updates a single value, and is used by the
> software-controller to apply feedback to the bandwidth controls, it has to
> be called on one of the CPUs in the resctrl:domain.
> 
> resctrl_arch_update_domains() copies multiple staged configurations, it can
> be called from anywhere.
> 
> Both helpers should update any changes to the underlying hardware.
> 
> Implement resctrl_arch_update_domains() to use
> resctrl_arch_update_one(). Neither need to be called on a specific CPU as
> the mpam driver will send IPIs as needed.
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
> list_for_each_entry -> list_for_each_entry_rcu
> return 0
> Restrict scope of local variables
> 
> Changes since v2:
> whitespace fix
> ---
>   drivers/resctrl/mpam_resctrl.c | 70 ++++++++++++++++++++++++++++++++++
>   1 file changed, 70 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

