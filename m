Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9DA3822A5
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 22:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774306428; cv=none; b=CjatqhoCyor7wryGF1+eKlka36Ia1gSMsceufCW5GgV9J9dLfeGhBTC2dcV+mfs5zP1YZKp/Wk6OzxV/QEpIKp/wGY2YiW3pLk1FAbxdw5FQrTQrKeifQclXUZGhSJsIszBhmAGKfk+qu20AgeJ+J51N1KgQXWp8hLg531wgnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774306428; c=relaxed/simple;
	bh=p1aI7eIN6SCgxe2B7sK+4JcUK+QCwhE895EL9IeW3SY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=km9r3T282eqDieq+d8Bxqe83mPpYQ2ZFCAprXKxnstMurJ0kbbxHr5rljyIDpmwrMf73Kf1Wnnc8oXRdsBXfwXzvkyKxkGB4iOXaIPEGfaNHEPEJZK3QeZTKRfBzlg7D9WQvmnAO7zCw4iUctsEkJta68wrMT390q+pNxsTSTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZLZPmYl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZLZPmYl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774306426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OosJNlMHUO2ANcXKlCppT3JjFj+gSM8UPwVPtyNawFc=;
	b=VZLZPmYlskxlCPqLilILH12VzlRLvcWbW2OmwZWfKiQtYZYETP3QxScaVzBHNP+47asI3C
	j7iUeG78IT2acPOKb/+TNBRslDj8ppRUbsyx7TI1bhNssPvwn0nWw0WNzwTqxKLNKgJD8r
	kuBqsyoI6SYQK1MqqOfXvqCK95RSIdo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-aUeO3vvDPRSkBDLrXBa-ig-1; Mon, 23 Mar 2026 18:53:44 -0400
X-MC-Unique: aUeO3vvDPRSkBDLrXBa-ig-1
X-Mimecast-MFC-AGG-ID: aUeO3vvDPRSkBDLrXBa-ig_1774306424
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82a84f21bf2so15528266b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774306424; x=1774911224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OosJNlMHUO2ANcXKlCppT3JjFj+gSM8UPwVPtyNawFc=;
        b=SYYlEjGrgSVWRDqMVwRIKiivu2tjRy5RRmhtWPAddGgwuKZ01Ojka1mBfEaPd6YvRi
         f4/cLV3lwhP6ZO01Delx01of77y1XNtoHlphUAjDdMJEZZMMGs+6aHsB07JBWh0Z+xbJ
         cRFIKGCUG1obyMyNlrXvSfxgnQ6LJaVqo3df9l6uUXD1Q7+bLVDHNu8nJH7TNshHyIMX
         RgC14AVOIyzB/qcgQxIm7tFYLgJR0IeJnKuOA8Jc2HZ6hDj22sIkGpA+JWStTTY3sxZE
         9KVFTpqroL4ParAF5rZeOXaDa89BI+qfYQ6BhM/8vKHcZkMZTI+L93iU/dIS8v3dbLNH
         flow==
X-Forwarded-Encrypted: i=1; AJvYcCVxmsd/QKKq84dzN8GdQhq8yl0fGT4pJbKih/It/gcgMIfhRfEx9AnUQUiNp+IA2trQGKBFofg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrzFWvYIgvlviLUC4gvkt69YAjHf1irUUbJu+zQnPTAWUpasZf
	aSdXFyh6w6q383lwTtv0ciAPVfc5GmQtcaY73oebh95qAnmO7edX7BCxbCbObhObXcXFt4Nibtd
	H9ugnnHSAn0+Wv947ibB9BtgUX0g9WnoLqAnn+Cay/3553sqt3cvEKcsfug==
X-Gm-Gg: ATEYQzzE6Gr0PQQDAotSN/gNUe3lX8OOoAc0ePD3/uAzre81ENNQzWzDlQN/cAq0wNx
	J8jEdxv28jN+wqon9/2ePgBwz8e+9ThIasiRWmXDvKsjb7QZzsQwjKXaZzlDCNFiBFjyq6Iy8TZ
	RO7VJFdkWd7xmWmU/PaZ1r13g8sEEtv0m37QThcCLu4pi3wCKvY+mxPGEiVYBYeVfriTFNsKvP7
	UWiaSbxaY+Ccg8Cz2isepgP2/QNXASCLrcFfDisK1pgr50mNzQTgaW4gEh4M0IuF8ivm1/kRQL1
	3ggpJ2Tjww1KgFJE/58D1hvbL7a5xsIkXSM3DnVaMR/VReZosZe3lazp3SFW9XK5ur9Zsp3dPP1
	P2QHg4RDe9FaC6kHt70pny+xsWEXezu9FBYxwtjHSmVuGPE0v3jdTed4bjf74FJpW
X-Received: by 2002:a05:6a00:99c:b0:827:3ed6:9122 with SMTP id d2e1a72fcca58-82a8c36f76dmr13334456b3a.59.1774306423692;
        Mon, 23 Mar 2026 15:53:43 -0700 (PDT)
X-Received: by 2002:a05:6a00:99c:b0:827:3ed6:9122 with SMTP id d2e1a72fcca58-82a8c36f76dmr13334427b3a.59.1774306423314;
        Mon, 23 Mar 2026 15:53:43 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbebb2sm11341704b3a.14.2026.03.23.15.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:53:42 -0700 (PDT)
Message-ID: <f433b310-9bac-404a-9260-e01698e5c621@redhat.com>
Date: Tue, 24 Mar 2026 08:53:26 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/40] arm_mpam: resctrl: Wait for cacheinfo to be
 ready
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
 <20260313144617.3420416-25-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-25-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3g9wtWKAL70bVJ-g-ZjLQeEqm9vbbaDxIsArOpOnNm4_1774306424
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> In order to calculate the rmid realloc threshold the size of the cache
> needs to be known. Cache domains will also be named after the cache id. So
> that this information can be extracted from cacheinfo we need to wait for
> it to be ready. The cacheinfo information is populated in device_initcall()
> so we wait for that.
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
> [horgan: split out from another patch]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> This is moved into it's own patch to allow all uses of cacheinfo to be
> valid when they are introduced.
> ---
>   drivers/resctrl/mpam_resctrl.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>



