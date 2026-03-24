Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D2739EF0C
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323712; cv=none; b=qhJLkRCfP5uMb5bN7igmgcscuw4TkyEr5W0ID+vgdWCtpOrlF47mpVJDuZ5ljeAMT14ratMyV/MIru7Etwv2Cr91wSyEJ1rhK2HEGdUFfNvfW2qqzjCRYGA9pYtyNqpkUPTz/FLKgNJjx2fLJ0S/Zbk2ZsE5OeekH7rgkX+Zk3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323712; c=relaxed/simple;
	bh=W/iUkryvG3ueViuRMSEVaFw1WJyUIdLkdTezJQ1QMJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLmac/5a++4IqUTIRnyXeqzRR55Q+n9cJ53TJue/HZFKCcti2ERXxTvB+KgiWbSIkNlN5SEz5tq3EbUawrW66bHXBUL2lmotX4Ev/8VkuZ2Lshq+vrb1FO8PCDNYs+shsg+o0Lg7IEiaNybX+YUyHy48iLoZFCKw4+Ur9526eYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxtOY5Ca; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxtOY5Ca"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rUeLGoeTwPTz7/suB9ZfTfJ1UEygTswX0AuYIezqldY=;
	b=fxtOY5CahERjaV8uVFfcKsrj3FoOZzBIZ3yQof/aj8EksMU0oDf/MstGvQ67VAlXm/+AXM
	1FawIJCc4FiFuqw5n4Z7Ny3LcViv5r7wDN0VJtBl3RJwQ/fFsq6iy+5vFdQGbk8qL6zUn0
	WWFIWUF6y2DFtNz7k1s084KwwpPquoo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-s8n5QyfmNByL6YV6DfTzVA-1; Mon, 23 Mar 2026 23:41:48 -0400
X-MC-Unique: s8n5QyfmNByL6YV6DfTzVA-1
X-Mimecast-MFC-AGG-ID: s8n5QyfmNByL6YV6DfTzVA_1774323707
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c7381a9a932so2207783a12.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323707; x=1774928507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rUeLGoeTwPTz7/suB9ZfTfJ1UEygTswX0AuYIezqldY=;
        b=l4sneB1WI5tKsEGxjLSsp10tJ+jJbUoWurjzJKZBPCxeYVFa/CGVwKlPUc0bDMNa59
         ekiHxCGeBVyUXJXlw4bXJ6mkbRsvnxc2ziDzL+ErlxN3cBU06BKRIgunui/eIvxtjz1g
         GsZl72LKH/Is0KfWDAnXaQTLXnetBbvYPHJGaOr/xyuSCgFKGElM1zFD7cFPkOIZf4iJ
         sRZ5lUmacEh1vfwZZ+8cXyRLvGZ04MVtWj+SN9fFDYNAFmAdEqDHEcc2PYisghTubAbz
         KKMomoE9O9aH2T2axqM77z03ReWRi3AJKkE4z9lEMuF7/T8nLsiqRKgU9cmuYtxtVqXL
         bR+A==
X-Forwarded-Encrypted: i=1; AJvYcCU+GEn9kzyqZ82T1Ql8v4xDJN43r+kyIFg8fz5UN1AYDKxoxcDtwrl4r6sC09nyl8PZSoVKNmg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdTyJiBgX6JglsjrGHWeBFo3ZpslY2gZYjrwbZgZ566m64fKl5
	EYM5Ypa4W7LT0v2ewY9/ylorzmzJnVXdHyefXJ5A6Oo97KlTwhGvbuSuP3ANlVU4vEax04fdPcl
	76eGbx+r/hhYHdpMF7o+HXYPcem77gqatWhoy5Iq3p0hhNvVJN8fmBhvq/g==
X-Gm-Gg: ATEYQzxkSUmNZ+a8LaLjbcy1X1+yzTDd8dO2FNKoQvayKcvFUovNMIrA6eG8G1KdWQp
	p79agfT2liizd+TJ4lTw3djT9GJMX3Nj+2w9nNguMSDbEv1qk1k8h1ePkS8tRnTSsJjwRNtWtR8
	BreUlhxq8UMDAP+/UucAFAA7NSEOXW24J0cu8IkxVJYvqCMKHnfQbTg/PvSJYmSjHTjXvAWgwp5
	R2DXY+eYNRExE4LHg8S76pYHbtDfHMBm3ewXVqQL/bQUKiifjlFjSSSNbLIu8G97HEv8Oh4XyoM
	adwIDjMh8RnUmSuzTHDXGHGZ1hKPFegn6tvjwyaDEFxLoccVdtYX5jH4wWdRaL6+JoP1xcxZhB1
	84/hbm4oHf0B4VGPCOm/BtS5UmUtAPTysHlMr8vAQ3EsoICWSaZoue8pFRwfqbic3
X-Received: by 2002:a05:6a21:4ed2:10b0:39b:f292:d7c0 with SMTP id adf61e73a8af0-39bf292e04dmr5956818637.58.1774323707470;
        Mon, 23 Mar 2026 20:41:47 -0700 (PDT)
X-Received: by 2002:a05:6a21:4ed2:10b0:39b:f292:d7c0 with SMTP id adf61e73a8af0-39bf292e04dmr5956795637.58.1774323707126;
        Mon, 23 Mar 2026 20:41:47 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74487b5b8csm9108581a12.31.2026.03.23.20.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:41:46 -0700 (PDT)
Message-ID: <1ab278d0-59b4-4fcf-b72f-ddcdb4fc96b4@redhat.com>
Date: Tue, 24 Mar 2026 13:41:32 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/40] arm_mpam: resctrl: Add resctrl_arch_rmid_read()
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
 <20260313144617.3420416-31-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-31-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VloHm2ATapolq92OS1gEkHyIMxNHZLxUfnd0g5hVzC4_1774323707
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl uses resctrl_arch_rmid_read() to read counters. CDP emulation means
> the counter may need reading in three different ways.
> 
> The helpers behind the resctrl_arch_ functions will be re-used for the ABMC
> equivalent functions.
> 
> Add the rounding helper for checking monitor values while we're here.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> cfg initialisation style
> code flow at end of read_mon_cdp_safe()
> 
> Changes since v2:
> Whitespace changes
> 
> Changes since v3:
> Update function signatures
> Remove abmc check
> 
> Changes since v5:
> don't read mbwu
> remove reset code as only needed for mbwu
> ---
>   drivers/resctrl/mpam_resctrl.c | 82 ++++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h       |  5 +++
>   2 files changed, 87 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

