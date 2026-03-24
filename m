Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C813A1A2F
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323765; cv=none; b=I+jdRSgFgM1E6JSoLAqm7OVBwYqnRQMdBCVuo3ZtpnJvT3UG4GHROWzujy1j1XJu7vtjckJMe1yntUY4MbJhmHmDtbCkHbXtz79O76Hr+6MzcDxR95gxCiKtzxCfLX3hnqShpVo3xuj/ilCx2Tfh2BoyThyg/B2n1BMwfKKh2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323765; c=relaxed/simple;
	bh=ytx71aLgOpEN3OU1EImfPkvxmPyCQzLlBWGLfnk2Glk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QFQaLqbl5P0Uh05SpReq4xTgbxCQfZ57lG4JwjP9dhXMqR5sMUWK3wN6OyMdBkQN2ZmjZGjydHk+Cho1NRJ0IaiGpJ0MI8bhAB6Yr2zHYZMmYg+a4a5sIBIf2+l0WWVaGkGHnu8CNl0tNy+xZCPnO1xRrLd7C5Kx1jT3gX5IKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDxz0Fr9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDxz0Fr9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M9oHoK+qgr+hzDA71sg+T7mBzxA/nxf+7FTfYBCJoWQ=;
	b=gDxz0Fr9pDXxJm6xmmE4GqhJIINbvUsKfZ4mbqZi80tn4KZDcj5CLY+GrgWqOrzogcpE10
	G3pX9PhNJQTPnFYY9IipKXFDQXgrFS20KWjSXOwvqOrXeySgUug90vs3tf5sBBgbtneKoQ
	gg/QOMxJfIj6NsvBThRaocngQuHycaM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-PXhlgi49M22RP3nOf0RQtA-1; Mon, 23 Mar 2026 23:42:41 -0400
X-MC-Unique: PXhlgi49M22RP3nOf0RQtA-1
X-Mimecast-MFC-AGG-ID: PXhlgi49M22RP3nOf0RQtA_1774323761
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b056b2f0cfso10942035ad.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323761; x=1774928561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M9oHoK+qgr+hzDA71sg+T7mBzxA/nxf+7FTfYBCJoWQ=;
        b=cejbOCfqe3NvTSNpfjUvXMGmFt/VDTpoiLa263P5V4NNi1E0DcUkjjolw4mHBLT7Iw
         OvIcbMjEdbyQ8s2QWob4p7ndSOyJLOtpYBQByv5krducYTuJs6tPLLEHp17Ji/RaMtLt
         9yjwn3wzGa8XQnaRkU8nq+w30PM/hl49QZO3Sf0Qe9jNFYFEki3ojwIIXUmpKxkoNA/t
         lf/6XBw5fH41f5WrgO1VxAhmpjIGNejHTDQSICWRVm6IIyCprtPcWUg9n0tsUbfXi/TD
         /IBb0R6UHrRPCE8RaimXLFneDF2VUfOpy4+1HQBBV4mPHNpMI/Jg9rt32HfcVsPE59xL
         8IlQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4NcFHbpJ3GMu2EpFRynW809LEEUwduqIbTcQu1DZGEZaZbGI0cZUT7JgIH1KgWG6T3joSWro=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGjCtPrZ2B7knyRpYbNLwxJ/a195WVJ9lFfF+2mnRBKrpeDDwp
	HtDb9XRiu7U6jqAEC0PZI7QahMlplurOUWR6rNCEVqC7XTEn/CS6JZQLNHVTVtK+l76aDrBRRLn
	cL3xHPhQjipfTgDpuGkODlKxqfNWELH4HQebV6UVYnpyLuU+bwfK9v71D/A==
X-Gm-Gg: ATEYQzwguVCzSfx3/ip/ryQDXfckAY8Qq2FM4WUEkP73U4Fvb9BQQC7aO/z2hygjMC8
	B3tYEUVuNJ1GUG+JCBtZZiOb2QWbGJPX6p5z4jxuTsCTgujd2DmHYRWhV/tBEm8rfs0urCSle4Q
	SoQ2Dqeesa/eW7zgHngs3BmxaJflJGJCOwjfjHMtPjlcLmajAMAuOGju191F0yGnPENXXplwvtD
	15Wn5hYByvfPWin3aBuB04thAiKL2BRZvh6rocO8j5qkbU6ymeprjR3NdjPURdL8wFBXFIaZ1gP
	ev4s38tJiidAswoQxo6NQKJQKO2F9USmkSuCFFP9IcqX3VjcAT6BkxzkvbXg2OwKrvAWudtW6IQ
	sUiBlkoBvIiQxBTNvOZzjUFoZYndbuWniwCnQCJ5p/wsMIbIQkk+8ii4omdg2DB69
X-Received: by 2002:a17:902:f685:b0:2b0:4a1c:b847 with SMTP id d9443c01a7336-2b0827d55dcmr137215365ad.52.1774323760653;
        Mon, 23 Mar 2026 20:42:40 -0700 (PDT)
X-Received: by 2002:a17:902:f685:b0:2b0:4a1c:b847 with SMTP id d9443c01a7336-2b0827d55dcmr137215045ad.52.1774323760248;
        Mon, 23 Mar 2026 20:42:40 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08369617dsm161821885ad.71.2026.03.23.20.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:42:39 -0700 (PDT)
Message-ID: <be4c52da-b345-43d2-b251-f0760ed4417d@redhat.com>
Date: Tue, 24 Mar 2026 13:42:23 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 32/40] arm_mpam: resctrl: Add empty definitions for
 assorted resctrl functions
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
 <20260313144617.3420416-33-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-33-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oPss8v_YbMcezGmx4uA4IqMSh_xOn5GlYQhyRQiPRAc_1774323761
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> A few resctrl features and hooks need to be provided, but aren't needed or
> supported on MPAM platforms.
> 
> resctrl has individual hooks to separately enable and disable the
> closid/partid and rmid/pmg context switching code. For MPAM this is all the
> same thing, as the value in struct task_struct is used to cache the value
> that should be written to hardware. arm64's context switching code is
> enabled once MPAM is usable, but doesn't touch the hardware unless the
> value has changed.
> 
> For now event configuration is not supported, and can be turned off by
> returning 'false' from resctrl_arch_is_evt_configurable().
> 
> The new io_alloc feature is not supported either, always return false from
> the enable helper to indicate and fail the enable.
> 
> Add this, and empty definitions for the other hooks.
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
> Changes since v3:
> Add resctrl_arch_pre_mount() {}
> resctrl_arch_reset_rmid_all() signature update
> add stubs for abmc
> keep empty definitions together
> 
> Changes since v5:
> Add resctrl_arch_reset_rmid() since mbwu will always use abmc
> ---
>   drivers/resctrl/mpam_resctrl.c | 65 ++++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h       |  9 +++++
>   2 files changed, 74 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

