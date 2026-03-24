Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75B386559
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323638; cv=none; b=Q4f88m8VAN1DkHkl8z7WnIHttKh8h1rK9DuGiIUCH9W4mOVUasIRjwKqC3XK+UIoB6zumQgCpxlIab1vE5po2m0AqqCcxMNlBdGvp1ZPYhcLMg8TkrWHKo/tF6b9upAojifB6SRLcykgPsPddyH4cPcJMQ5m1Pv8J8SwEpqFZEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323638; c=relaxed/simple;
	bh=GbWo3xlFo3+yW/y2PBN4nF0sITZI0vr2UyqlXDwEu3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDtt5p4xqX/D/ggZZKTIIDaG+Y104rTcG/ImnXDo+TB2oJH1aMjQrX4pWbsVltTe9k2ey2tuM8wzULayfEYfXd93hbcSDQaF6FtmnRw4Aj7fSqNcCOKILlMQ2cydvx/TgTaGvLR5dNhPOwOvZg6v/pRPvkTaEsYeSnEZYjDTwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1tjqR3U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1tjqR3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XblcNM6KU7hXW8KSNBudspXcLZs2xKbcalCmzhtiVUo=;
	b=b1tjqR3Ua/bpCSc9KphGdhIsNRJu7YirrqiBWalEdX3LNIRrA8irqkGITzifxGXgY98Jdr
	PqOOyY3rhJ9taaabcDKXFWSXtouajexgYQKqnrMTDwVAEs+XZaY+EY7gqA1iV09X8wk38i
	xzinQ35KhPH1inkovi+ug5cnwYrec0o=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-VScbRN4aMji8MJu_XCPKJQ-1; Mon, 23 Mar 2026 23:40:33 -0400
X-MC-Unique: VScbRN4aMji8MJu_XCPKJQ-1
X-Mimecast-MFC-AGG-ID: VScbRN4aMji8MJu_XCPKJQ_1774323633
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b07bd30b5eso54956195ad.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323632; x=1774928432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XblcNM6KU7hXW8KSNBudspXcLZs2xKbcalCmzhtiVUo=;
        b=XBfM1URJh1y0NqeBR7hJNdkcivX7PHL/5uEyXZ0i3lBpm6SEaNMQ/ZF9jjyG4l6nbe
         6lTGKKAT4+MchSWKwzpep/i+S6py2nrFPH38BDMfBvf4CPfXBrCtr9BLIza/llw7fDPe
         h6mWCDhqWzRy5h5WjU/sO0GmUqerMcuv/jOTkbBGJ2G6vB0+6LfPjEFYHfGlfrh/EcsW
         2VeROtKuUvLbFwS3ofw/eZhTRidWXI2qYJxeI14BZBfFGOEID6G9cKLTgxkPiuCbKMJ5
         ymE3gnkXzBJ608XGvx+LkZYC4A9BRigpmnMZh6EmQCWb4GI4Cq/2yb6evnlj3iajQ4+t
         d8xg==
X-Forwarded-Encrypted: i=1; AJvYcCWupm0PINZ0Y9odIgrflTGAtuBGj1JBTLykw/Us7yWjTXNedKJR++tQ4JERaWIugW9LRmWwXww=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeIUhsbuMSOUIidZMX31wl3MeRuhXijHF4pDEGYhgtyHIyEGX1
	Kg2/17aHwNTMrRAvM91zGVt76wPWHo087IedOzA105ItgqKjGcKJAqHAWPv2wVWcQeK9aailHgQ
	t+qtixy2RUqsi0iiXDlJXL1BjzqG10ECXxvnTokYqydhJ4CdFEAU5kf15LQ==
X-Gm-Gg: ATEYQzynRvl56T8LVkU7LaFYYgUnnIBLxL+AkHAzXXzW2l9TON8pxSWxxuisjMIyRHe
	4gWkDV8sc5BTXsDKDyrpRVyKInx2svsjqRTRKcokOiNql4/XxL/7DCBLUpZRoUEM48Bm2z2Che4
	0CHB+DR57KJwMcW1xWZhPENElQrNflaBfXEXBMI3gPZviqfqcIajSb8lF9dbn1J/NVsJvFZOK84
	tJq73oVViuvfgy9gSRTYC44i45lTw1CQbjTtLUXXrbxiPup9zofZDgJv77Fu8agAr08CIH1geSA
	lz9fo44xjYOS4uLT42mjHiEoBM4okLOTtU+osbHN854Y/pW2ZPsVbwZtgW0ITRb/yNCoXu5z0ZA
	c7EiSaKK8PXhXd7Sukf1gwOgIM64PlNchVN7RjjIla+xfyeSb6bqRYbHrvrSlvql6
X-Received: by 2002:a17:902:e847:b0:2b0:5306:5f20 with SMTP id d9443c01a7336-2b0a4e16ca1mr16086535ad.18.1774323632658;
        Mon, 23 Mar 2026 20:40:32 -0700 (PDT)
X-Received: by 2002:a17:902:e847:b0:2b0:5306:5f20 with SMTP id d9443c01a7336-2b0a4e16ca1mr16086135ad.18.1774323632220;
        Mon, 23 Mar 2026 20:40:32 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366c443sm162024795ad.56.2026.03.23.20.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:40:31 -0700 (PDT)
Message-ID: <2825ca38-44c5-4649-8a1c-40cf98905c44@redhat.com>
Date: Tue, 24 Mar 2026 13:40:17 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 27/40] arm_mpam: resctrl: Add monitor initialisation
 and domain boilerplate
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
 <20260313144617.3420416-28-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-28-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g_Fn4CVX2eUA8CRnONSehtP5j5WG0agE1kg8eJAL_FQ_1774323633
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> Add the boilerplate that tells resctrl about the mpam monitors that are
> available. resctrl expects all (non-telemetry) monitors to be on the L3 and
> so advertise them there and invent an L3 resctrl resource if required. The
> L3 cache itself has to exist as the cache ids are used as the domain
> ids.
> 
> Bring the resctrl monitor domains online and offline based on the cpus
> they contain.
> 
> Support for specific monitor types is left to later.
> 
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> New patch but mostly moved from the existing patches to
> separate the monitors from the controls and the boilerplate
> from the specific counters.
> Use l3->mon_capable in resctrl_arch_mon_capable() as
> resctrl_enable_mon_event() now returns a bool.
> 
> Changes since v5:
> Use r->mon_capable instead of resctrl_arch_mon_capable() as specific
> to the resource
> Comment line wrap
> Include offline_ctrl_domain cleanup from controls boilerplate patch
> Include any_mon_comp finding and
> Halve num_rmid when cdp_enabled
> Move mpam_resctrl_get_mon_domain_from_cpu() from boilerplate patch
> ---
>   drivers/resctrl/mpam_internal.h |  15 +++
>   drivers/resctrl/mpam_resctrl.c  | 231 ++++++++++++++++++++++++++++++--
>   2 files changed, 235 insertions(+), 11 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

