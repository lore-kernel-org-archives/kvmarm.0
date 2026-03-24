Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A8B23E33D
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 04:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774325995; cv=none; b=o16WbD0bcyLQYbUrCAGzTOqUjEAkmrZA4zmYFzRq0Oc/WFYlpeeGAyB19lnbMCmyRe+sGSnR1k3iIvR3lyXc60RU/tJfG38sMbCHmRYgmEXw5KRWODL1rh349sE3f4BTZ/Ly/u4zexxWN0ELIb81WynZjuu3yRt7z84pOeeWOHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774325995; c=relaxed/simple;
	bh=9+uz7CzlNFoa9gXf4VBkH0zGszG5dtCkLuUwv7W9JPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ljc9u/Nsm9Elz8HwV27K+yCWsRQOkNk63zI+02/VzYuJQnwApb5qj6JpIVSz+cQYneWpPP8FI+5Y8fOcE09/C6sTr4aUFS+CkFhoTmT5jYxur/PJcW5J5u5oudWBpZ5hXknzCKRHcZPHggFq8bCyOrJzl0NfgXIKs6oG49ZqQRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMZCDOpk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMZCDOpk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774325993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R08g5rCsq9whHw36ZZYWUOiHQj5R1FuEsuKvwJiGAyE=;
	b=UMZCDOpk6TdBBRZANk2z4F3kSDnysis/c2kbLUw5OKyiiaBZ+zpYZkvVWqbiUFbci56ys2
	8mTHcrOiIBr9lJEIPAiKNY45dIrNKFdJ7bRpydxmgEskJAuc8MfgocdKrFZWtZL0sAF+4h
	qfXjNDcMWZLkW7NX9BRR/eaEf/TIGqU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-BRctMCdzNbmOtveCRhq0Xg-1; Tue, 24 Mar 2026 00:19:50 -0400
X-MC-Unique: BRctMCdzNbmOtveCRhq0Xg-1
X-Mimecast-MFC-AGG-ID: BRctMCdzNbmOtveCRhq0Xg_1774325989
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b0554888cfso11859475ad.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 21:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774325989; x=1774930789;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R08g5rCsq9whHw36ZZYWUOiHQj5R1FuEsuKvwJiGAyE=;
        b=cpO1jS3Bs/vcc0r4whXPHTyhxM0//0eV4ozyEpzIYj+o1v45h7C9hRMuOR+wdgGtU4
         FhdNEQbR7SKpcL9eJivlXDjMgR4/3YRvbAUIQyLnMPn8hMH8TmEs7YzRuEhcd83h9V3r
         tGsmG/QppoN07KIrwitjGncp//Py6F0Iu5rLp7o0OOvtA9/MhPQcWU3WDARWgOAOdP2R
         Kq2EOX6KmMzZkh2aKZH76B59+5vmU/hdISXFT344z8IqIqEg7ElOpEDz2l/bQpg6d3BV
         7ir4mF6EREaVF08Ot/xrV+PHCUEhqnCqmDxyamv9MHM6bmjFyRdJGA5fnus8IfYcdYxu
         l/dA==
X-Forwarded-Encrypted: i=1; AJvYcCXunAhFjX4kjfq19SwnTZCDdJuaJK/k8xsuFGmuTIbwriXRDQ8EEo3QbRGWBMH2/7Uk5Omf7xs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2NbKj5APkdwni1jtQn5yInbXE7wS5zXY4NVLGP2Rf1OzTBuQF
	eqzd5qrbiEKY/mYmrbQ6sxiAnf8bATR6sRxl2BOS8IaNYvJ314H+ZTfUjAWbq+5kWOb+mf1X3L4
	DjHBDYMLDku99RAkKFQK+35i9TTCz/v2B80233TALDB/MEiMVIow7El4s8Q==
X-Gm-Gg: ATEYQzyGrsk5rJ+hhuGFjs49+IUYok0gvUy4nT5bvY3aYytzK6ZHyinyEA+rGlc3Ok+
	8oPxWCc+5aOvULYMhN6A1POrFrN5peYeZBXu/hSKONFBgPx9qc939so6zevB9hm8aTCkiE0F5Q9
	akn6kTWQ6L2kV9Pp14M/8eDBP4q71Tlr9P7IoIYWPYyRDumZvGaLbAuwqh3os5jdiSVNJhTgNoN
	DfTxuFeT4m9YZzveyfuQ60xjXMO8y6r9VgnwGuZyfOzOsXxntUouTAYcaU6GDZkBgtdgOidFTSP
	8Uh8TiLmE1TB7VcEOv4z12hMQ9CTNVrEAIA31sJgxGZ0K7fdNp5J9qGXw3TOYuKA7xjw2nwMyLU
	g9pE7z7us3krXGUD0RPoSKaqIobcY50aT9UlexGE5bSfjsiwQQVB8+gGjmk/zS04b
X-Received: by 2002:a17:903:94e:b0:2ae:826f:2c50 with SMTP id d9443c01a7336-2b0826e2f0emr124388425ad.12.1774325989067;
        Mon, 23 Mar 2026 21:19:49 -0700 (PDT)
X-Received: by 2002:a17:903:94e:b0:2ae:826f:2c50 with SMTP id d9443c01a7336-2b0826e2f0emr124388145ad.12.1774325988661;
        Mon, 23 Mar 2026 21:19:48 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516ae1sm121045485ad.13.2026.03.23.21.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 21:19:47 -0700 (PDT)
Message-ID: <48fdab87-7caa-4e84-803f-3fbad3dd306b@redhat.com>
Date: Tue, 24 Mar 2026 14:19:31 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 37/40] arm_mpam: Add workaround for T241-MPAM-4
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
 <20260313144617.3420416-38-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-38-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SH52g-jDMpGxQyNFW0sounQrXTpzJg3rnMCTBVAzvfo_1774325989
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> In the T241 implementation of memory-bandwidth partitioning, in the absence
> of contention for bandwidth, the minimum bandwidth setting can affect the
> amount of achieved bandwidth. Specifically, the achieved bandwidth in the
> absence of contention can settle to any value between the values of
> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
> zero (below 0.78125%), once a core enters a throttled state, it will never
> leave that state.
> 
> The first issue is not a concern if the MPAM software allows to program
> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
> 
> In the scenario where the resctrl doesn't support the MBW_MIN interface via
> sysfs, to achieve bandwidth closer to MBW_MAX in the absence of contention,
> software should configure a relatively narrow gap between MBW_MIN and
> MBW_MAX. The recommendation is to use a 5% gap to mitigate the problem.
> 
> Clear the feature MBW_MIN feature from the class to ensure we don't
> accidentally change behaviour when resctrl adds support for a MBW_MIN
> interface.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> [ morse: Added as second quirk, adapted to use the new intermediate values
> in mpam_extend_config() ]
> 
> Changes since rfc:
> MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
> Handling when reset_mbw_min is set
> 
> Changes since v3:
> Move the 5% gap policy back here
> Clear mbw_min feature in class
> 
> Changes since v5:
> Calculate min from max when resetting
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  2 +
>   drivers/resctrl/mpam_devices.c              | 55 +++++++++++++++++++--
>   drivers/resctrl/mpam_internal.h             |  1 +
>   3 files changed, 55 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


