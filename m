Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450F3382F06
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 22:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305390; cv=none; b=AQCUCa9z9IvEb4w5JDAkCxMUqpoPZS1mZNhRpDEKeXmtK8hz+OmX/m0pGuDsx8fmrwX40kvZAAG9pgIgsClK7sCeLapM3L7wELNXSQbjKQRwtHH+a/FBq07TZ33jvkTjN8UZNlYXuLsTNn87vkV6GB9Qe3IXJ1s7sed3fmgx3X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305390; c=relaxed/simple;
	bh=6nPVvppBMpXb8pi91FflCLpRagVoKE11caW+wuP1jG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fvu2DOgfANQBE22Jck3QamH7VLGSIE3ah0lGiE6yL/96O70rZTemjU4xhfLH0THw+AUpfChzSZhuTA4dIEZQqRoG/8/gMv2CNFYN4iiHoFJUcqcYPOIIJ44Sl1BkfYbFdp5n8cXTF0WxrllDKX7D+HYGcHkREwe2uNoQaNs0EhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyiJJV+a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyiJJV+a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774305388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDPVpBhxfGUvSSN0XoYbTldidy0ABB4XqU6mDSv+4+w=;
	b=hyiJJV+aWolWWFwMNwZ6mBJg8GxwDRyZAesdMjz1jIQHNzT4EIYWp5Cs6LjNqgwdh8A7Ut
	Nj3s4a+9O/Ju82PCFWMwjEFAeC63w5dCu7TlthdWZMsgHqzYWZsgi9octuU+4iMGH99La2
	VVxFHMqdzNGn1dj4uWuVUDtxrD5rwZs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-vVgtwsn4NdWMjb6XpIzPRg-1; Mon, 23 Mar 2026 18:36:27 -0400
X-MC-Unique: vVgtwsn4NdWMjb6XpIzPRg-1
X-Mimecast-MFC-AGG-ID: vVgtwsn4NdWMjb6XpIzPRg_1774305386
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358f058973fso1032735a91.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305386; x=1774910186;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sDPVpBhxfGUvSSN0XoYbTldidy0ABB4XqU6mDSv+4+w=;
        b=iMXH2L6Afmx2oxqodSZYancAjLs1hd13AQ7JY4xJSjLw2mOQ12Jrc9gMYuxUuIeGWo
         2DzIaaGkGOmHWerW4IkgK1bJudiqslivx87BCghRGPukcjLQjidQhEjUdfJ8QVNso3Kx
         FfilEqD8NwiB/xxXHym+VKRfnh9TSc2hb2uZy1gPTFYS6Cl5CPsbG+AmVW5mO1sZFO3j
         aGB+Fh603COZkRnGlivY9A34cHHbDRSoFmhsd5cfbQ6nC22DRe1JjNO4h814bEugh5zb
         m+DIT3Sr2CNWkjs2RZNB2OVrUXp7Du0jOeiXrww+H3Zsnj0gL6GPCLLTgpTxF97CVMRE
         u2JA==
X-Forwarded-Encrypted: i=1; AJvYcCUDx/RM2BCwvTpH6tgVuxmQtJM7GKE1oJuxXzCZ49QgBXipeegZ5+73hzKh7t73/RLnRs5TaKk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ6tjt43tT5Q1xXPdqc3f7lWuS+bP/u6+wNygJrdzEyudeHraI
	EnxUziP55TYFqnqlW2Zb4X+VLOYlsRPnpI0s9tDgVdsCSzmqO3io1kQ2ksrI4uBexRMxKahCBbY
	sQaDUV/a1o5cH8aH6Lpi0KKnvyWWWtWSRKG6H1+PJvSm5qgHiNu3yi0F5OQ==
X-Gm-Gg: ATEYQzxsanQ+CUHo5yGh2wP/bV33TaBUX/FNBEgBCskeA6hBKaTi34rOUdVAstCWx01
	JWg6R22q3ihNS2zWvi+wtY440Pi4KcDW4m0dpP51fY1x2JEcfw1jZRs8POLVfrJLBVnem3BcjqB
	eZks0V6kslB9nUwzi9tAZZ8uYvVtVp+e7O38L0kjSs+TgPQmlfuEQ9Tlrvx1rTp69ew1ATigBDK
	+lNQN+i0UuY2DS+ZPrLXGPzKtqeUI+tu/Hi9eoDzltdxrQ4PVQV4j0xceGSkWm6LwtTvxoqU4Fg
	WoGJLekInVwVkwalXGHRAMXmZ5yDReWYfuAbw0n9+U8CT/p9AXTCbaFNUT6V186PgXLIOV8VU7H
	0IAczG2I0LgtgmHdevVxVavG/zUHDZZvx13k+/EnBGmrcFkkoOsh4LFl3ISHHU516
X-Received: by 2002:a17:90b:3f44:b0:35b:90e7:c453 with SMTP id 98e67ed59e1d1-35bd2bbe40bmr10223066a91.6.1774305385948;
        Mon, 23 Mar 2026 15:36:25 -0700 (PDT)
X-Received: by 2002:a17:90b:3f44:b0:35b:90e7:c453 with SMTP id 98e67ed59e1d1-35bd2bbe40bmr10223032a91.6.1774305385578;
        Mon, 23 Mar 2026 15:36:25 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c017a161fsm139948a91.2.2026.03.23.15.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:36:23 -0700 (PDT)
Message-ID: <078a7efe-4f5b-43b4-8252-4de36769a94a@redhat.com>
Date: Tue, 24 Mar 2026 08:36:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/40] arm_mpam: resctrl: Hide CDP emulation behind
 CONFIG_EXPERT
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
 <20260313144617.3420416-22-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-22-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vVQYjiQLW1B6w5zClJ8VIrblLa1-m0U84wJOXYATgkE_1774305386
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> When CDP is not enabled, the 'rmid_entry's in the limbo list,
> rmid_busy_llc, map directly to a (PARTID,PMG) pair and when CDP is enabled
> the mapping is to two different pairs. As the limbo list is reused between
> mounts and CDP disabled on unmount this can lead to stale mapping and the
> limbo handler will then make monitor reads with potentially out of range
> PARTID. This may then cause an MPAM error interrupt and the driver will
> disable MPAM.
> 
> No problems are expected if you just mount the resctrl file system
> once with CDP enabled and never unmount it. Hide CDP emulation behind
> CONFIG_EXPERT to protect the unwary.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Adding this ugliness in the hope of avoiding patch churn and extra
> reviewer work. I am looking into the resctrl changes needed to fix this.
> ---
>   drivers/resctrl/mpam_resctrl.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

