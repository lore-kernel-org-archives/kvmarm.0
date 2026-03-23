Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A091D7E5C
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 22:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774306234; cv=none; b=Kun5wQ2QwACbmcSBsSDu2H7l3nu8VbgLME9il4Z/DCBK41a4O4Sn1pa0DER0HRI5XlNRBEfWZh3zr0lhuIYORpBNY6G1AwYgMKI1qf+Cu1/KdmcoAeGdT1xj+s8p5tpdwAmcO5vRrCl5wpuCqK+q6EfhOOxsMKmsXbQzkggpIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774306234; c=relaxed/simple;
	bh=jJTcPlZldYQhd3QLj4UfA6QWdhk3aY6HXbnNiefgv5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+E82MWV7E97qQ5kwyzeND7OcKylEltgAGkB+nTmuP6lOYOXXdLh6CFOQWvnVwsEj3nOA921Zmbxp0Vebn4xi/aOmTg7nFalbFLKOAIO6vyUD+Zd30pNrcAAjThofq4I2rSV0VyLvZAEpqTwJxP2WP1wVBAIlqJ/+fc5ytAla/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhDD4tbN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhDD4tbN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774306231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=szqtNIvPXQ9SbI/61Nb1afNT5qmeNook0e8si00UqxM=;
	b=JhDD4tbNW8Fz/I4iXBy2wRPlnqwidztCfqPBDch8ZwIkM/31YEH7Vat33vzo21hRq4FglV
	GA1CHFzC392la52Q/02zrqhYLp+dqF0mF9df6LSawYC9qRuCEz6T5JK0lPj4wIh03la0z0
	SiyInKyqlF14eG4JLxRLkMdXo8ejmBU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-_ofr60n1NXeZe9qa1uabGg-1; Mon, 23 Mar 2026 18:50:30 -0400
X-MC-Unique: _ofr60n1NXeZe9qa1uabGg-1
X-Mimecast-MFC-AGG-ID: _ofr60n1NXeZe9qa1uabGg_1774306229
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b051befbb8so41161875ad.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774306229; x=1774911029;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szqtNIvPXQ9SbI/61Nb1afNT5qmeNook0e8si00UqxM=;
        b=sn0+WvmmjM7Iz1XRon7uwjUbD45oXbzEXwTlUNa0KhuNcc7Dillz3SbjHhCTWPjHv6
         ESsdZjA2/Jf+KfPQfFHHZONUd3JVA5r520Tr8/m8OyT4hLgZn9mLLr/FZvTn5wgY0o43
         ORwRqethHSFum/hFkl3no1/1okyhGHa6RYv2jP9J6c+57+ZEqEQEH87qeLn0CzCmcKzV
         NEMfh2MsFgC6TDujQF8jg4TQZuyNWPFSi709ssGs1MkPOnxoGLPcIJAQ0vVmir78ra6A
         QYbogh+iBgR4p8BLR03nAVpPeN0Fq832pV9YZK1YU0y6TWsMrLJmCnr2Z729oQNwrNHT
         AvOw==
X-Forwarded-Encrypted: i=1; AJvYcCX76xeE1OlXrTdNkqvI93t4Gf3MrINreTp5yycFcaoUojzrjf2Hn6ch+MmmTFw99niN5tYSWJU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAdFQrUgQzxkBNlhQIptdisWPv/xChZrIG0KcTuALHINmOhe45
	Gauhpju3ToydTp7+dsfoANbaMndmFSlgb0nuMiqbcTbANk/ntmp74dObysFmTxau1o6jqbdYEm7
	Quu46u/1lLifxphAfIsK1uOH7JHbhb6yH4dXOxZis+tCjuRxx/u3Orklx4w==
X-Gm-Gg: ATEYQzzRzXzXGJudIuD0MzB+pu3U7pcz36FiTmOGk52GZMKSA39KotCFLWIc2OEgeGI
	cQLwCZNKyi7fj8XN6Y3lhnnQCSgJeXCL1GzWwJ/wTYYyz5Rsberlr2SV8iaa+oYMdztt1c11ZlQ
	vcYb5T0rVZzP14EAUnFgW9tNEmaTyozNVcZvHQdeHbb21ZBmJqcgsFlvZ+QU8pufITYxM7JXWU0
	Fy3wbVQzsZ5eDi2kJ78a6nE71XsobQa0zok/OXfU8wCfMygJpleV/SWAj9wyS7vdHwCkacfNEyM
	JkRgXFSq87hdejeFMVlmad1R6+5yHBElkcDQ618fak4VT/Ek/E5nZkVXfOpPX397Fbmx/zanY5+
	K7hI/xT61ECQ49idWAtkSdqTiymh+Ssqfpl40FNbNwuI7NnagGmpBPVaYJL/1Ue4Q
X-Received: by 2002:a17:90b:270a:b0:35b:e690:c5ad with SMTP id 98e67ed59e1d1-35be690c7c9mr5628527a91.25.1774306228821;
        Mon, 23 Mar 2026 15:50:28 -0700 (PDT)
X-Received: by 2002:a17:90b:270a:b0:35b:e690:c5ad with SMTP id 98e67ed59e1d1-35be690c7c9mr5628485a91.25.1774306228455;
        Mon, 23 Mar 2026 15:50:28 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c02bf1585sm62840a91.13.2026.03.23.15.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:50:27 -0700 (PDT)
Message-ID: <1385eb20-4b04-453b-ad4a-9bad110f30da@redhat.com>
Date: Tue, 24 Mar 2026 08:50:11 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/40] arm_mpam: resctrl: Add rmid index helpers
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
 <20260313144617.3420416-24-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-24-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZWk-dY83NYJIC4LEZKq3q4eqaTbBAGflV2YHPOP32DA_1774306229
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
> data structures by index. This allows x86 to map indexes to RMID, and MPAM
> to map them to partid-and-pmg.
> 
> Add the helpers to do this.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Suggested-by: James Morse <james.morse@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Use ~0U instead of ~0 in lhs of left shift
> 
> Changes since v2:
> Drop changes signed-off-by as reworked patch
> Use multiply and add rather than shift to avoid holes
> ---
>   drivers/resctrl/mpam_resctrl.c | 16 ++++++++++++++++
>   include/linux/arm_mpam.h       |  3 +++
>   2 files changed, 19 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


