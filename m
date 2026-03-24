Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44F366557
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323693; cv=none; b=t97GQydm2DyVTDB04+4RgjIl0jpLzIOY4S31Uc6aR4fhbBPEf3bBlKwRh9roP2cjJi8wtm+sWffQjvK23yh1Gi7nZm8rwchCqDiBI3d8lgEBMoW8D9v8sg2gA2lIlIwgKqPEi7S7XCZPPMz2TgR4m2rE3X2hnJhiNtalYH5ZCAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323693; c=relaxed/simple;
	bh=jMZhaLlFd0YDU3XA3qv775N0MXu7/T2FVRzNRe97FB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGZC1niOdtmBp97PaUoMGQ5hRjaPtqOxWG33TS1BLVb3YZjHKoiWau4CrUlYTd6p5LpSA47p8DsKTe3LGWY22hpNUOy2yXSy9XlZRiczkLn7PI5gYm6aIF+xkuEBOUna6rrQSBIYSsMNvYXA6FOLKUMc6LsxFE32H2s+tyx8YBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hwrPCndM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwrPCndM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BTotqZEROYbDyldT/C8jFT2PqJQkiiFw2H0d7yIV7KA=;
	b=hwrPCndMx2va9H2fjFLujREY6Gm/7hffbsbuS9agouOcjlzZe8j0Sty7HntLNYwa8ZzcWK
	Fn6JtYTpFPDufi7KbLIoA7S5mw+Z7oYCO+UQjMj09GLNpMmYG1PvdP27IfTPGvTw3ylJ64
	xEIvc3y25tixFoZJrBVrD4JVuJmoAVU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-XEtQ5nfcPnKeu_8OJ0jzBA-1; Mon, 23 Mar 2026 23:41:28 -0400
X-MC-Unique: XEtQ5nfcPnKeu_8OJ0jzBA-1
X-Mimecast-MFC-AGG-ID: XEtQ5nfcPnKeu_8OJ0jzBA_1774323688
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c629a3276e9so2775547a12.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323688; x=1774928488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BTotqZEROYbDyldT/C8jFT2PqJQkiiFw2H0d7yIV7KA=;
        b=QgGJKtjGJ4yUqr0kgeg3Zo1P/QGCIXSZouvxCrjeWL8Kz5YnBnO1z1khZN4tx2BMOW
         kpz2rIrxiVAsAWIcZonPvMMjZVEpPkDfjgqRYBuyEU5VhrnG3NgeWVQ26y0VJsN6RHEA
         Qkm16dpIu2D179TxPV+56uS7BtxHhI6X2NHMgsQx8OqR5wB93cB28Bs+4WtG+MmsYVeV
         dPJeHaXPuVZcRdKU4O/0QrKiDHNfO/D/xWvKTPbATVjpcaAPSOcTHQYX+iIz5kPHf6Fc
         M8eTspqSdm/fA5hwydUBiW/Ubea8Xd/v8t7eLJGm2bwUJIzHUqHUdvVaJCO7zxubEngO
         haHg==
X-Forwarded-Encrypted: i=1; AJvYcCWU3KX5zQ0SQ6YJyR+W4w2Je3MEwa18JEHqH6FkGg4J7Tsvl9jahgQfWnEh/FsMzcwZqVJUfUM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvZM+qjUWoEuviTU4xFVVZWfOuAATlbAHRhjDZOnvGJnkBS7GC
	JlxieQFBu8dw1bzKTDGR0JzQ8fcmATZ0ssvx9l0dHqw75/kQFX8QFle5UcR92TqqJVzKrsINa5Y
	m0BVqU7lNRFrwCiR9GcgCSnSj6aZTZn1l8YNB10dN+XfF1nrWXlKLwqY4gA==
X-Gm-Gg: ATEYQzxGWAjUlCFosfQ/MaFhPSS+1tD+XIum+cROCYnpOiorkq2FD7sid/JeJRxNore
	wVm7Gnu3r7BACMFjw+zcJkp+aHQdvQjHplt9x9N1YKesU6SU2iZKuvyM+CXel+O62MRRY8wsF8T
	FtNZzHycl0igDc+Ve+annG2UaszM/SGE08QNWdwbHA8U6wTTWMp2YuSrAyQHzIYF1O1hSWlZcU2
	3I1mryjqilITDsMggvN0Rxv62NwuuRL5Y/tE/qOCYAkmSlweEUQXi33sxMGqZ2/8VvPhHRIFXyh
	kTgsFurCZxp1EfxHf+GEizVxjFMvcFHrrdvRWQoHkJq3ki3NQ9YqhfwwOsHWbKNgg7tl/m7lgNY
	QdwnP3NEXKKG4E9bEfnJ3JYeRSf0iN5qymlzkgCQ0c3V746Ex9FrMFONu75vndKco
X-Received: by 2002:a05:6a20:9392:b0:39c:c3:4030 with SMTP id adf61e73a8af0-39c00c342ddmr6959318637.34.1774323687672;
        Mon, 23 Mar 2026 20:41:27 -0700 (PDT)
X-Received: by 2002:a05:6a20:9392:b0:39c:c3:4030 with SMTP id adf61e73a8af0-39c00c342ddmr6959271637.34.1774323687305;
        Mon, 23 Mar 2026 20:41:27 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74487b5b8csm9108581a12.31.2026.03.23.20.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:41:26 -0700 (PDT)
Message-ID: <711b91dc-8861-4948-97b8-47a5ec21affa@redhat.com>
Date: Tue, 24 Mar 2026 13:41:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 29/40] arm_mpam: resctrl: Allow resctrl to allocate
 monitors
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
 <20260313144617.3420416-30-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-30-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hjc1FaghNmUgicjcnE0_5F6mUrz_5D5QUfldf5B0avI_1774323688
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> When resctrl wants to read a domain's 'QOS_L3_OCCUP', it needs to allocate
> a monitor on the corresponding resource. Monitors are allocated by class
> instead of component.
> 
> Add helpers to allocate a CSU monitor. These helper return an out of range
> value for MBM counters.
> 
> Allocating a montitor context is expected to block until hardware resources
> become available. This only makes sense for QOS_L3_OCCUP as unallocated MBM
> counters are losing data.
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
> USE_RMID_IDX -> USE_PRE_ALLOCATED in comment
> Remove unnecessary arch_mon_ctx = NULL
> 
> Changes since v2:
> Add include of resctrl_types.h as dropped from earlier patch
> 
> Changes since v3:
> Don't mention ABMC in commit message
> 
> Changes since v5:
> Remove MBM free running sentence from commit message
> kmalloc -> kmalloc_obj
> ---
>   drivers/resctrl/mpam_internal.h | 14 ++++++-
>   drivers/resctrl/mpam_resctrl.c  | 67 +++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h        |  5 +++
>   3 files changed, 85 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

