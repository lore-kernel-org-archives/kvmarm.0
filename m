Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95931E838
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 06:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774248109; cv=none; b=WZ/+W2Ev3IToINbOSyAO5VQ5tgVc49sxlxzG7WFqhuVsAeHKGwcpOWjSH18EHwLGEOqIW69s5t5/NLPZD+j1QpjKZl60Sx/zTnWSxt9fqjgkqHmAle+v6zodJYWuVH3sp+EnqV4ssDkzzzx6aIbPnHEpDRcR/gWYbRwkFX1xuJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774248109; c=relaxed/simple;
	bh=N4I55PcNCoIx8VXv2XV2AUTQjGDUKfRvEJAgWq5nVjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzxnyKjXx20EbTsrQgbmjdzKbZlJ0vnn2lJ+yjljk56cLSiCVkQzAtxQe7/cYKG0fGs8YgvdWpYC6+CTuhl64Zrb6GTbWBtQ7niAleMPY6lTYg6DE4Q+abwOo1oXAf8Y8DfMTTfd5C69GzTD990C9h28XxKWfzr8yZMTFU67Png=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rn3+j6f7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rn3+j6f7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774248107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/VzDoLUhO1gb7oNNZE+I+ReWQ1Pd7mAscGwxQPtNBNo=;
	b=Rn3+j6f7IUMq46kafqK6jUyNhmmDN05Ihgx+/IcoV1o29P3NjaLpbBYciCJBXQFFt7X+L9
	emaE4C+f51usUGehziszIIKVNghneRPiQYm5yJerXfgV7IMogU3nPKMQfJeVOAwsN4tkCf
	t1cGcHOxZBKQlqP4oV5Eu745wlw549Y=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-HGf23G0tP1-wNRFOaW1o5w-1; Mon, 23 Mar 2026 02:41:45 -0400
X-MC-Unique: HGf23G0tP1-wNRFOaW1o5w-1
X-Mimecast-MFC-AGG-ID: HGf23G0tP1-wNRFOaW1o5w_1774248104
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b04293b16cso136926695ad.3
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 23:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774248104; x=1774852904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/VzDoLUhO1gb7oNNZE+I+ReWQ1Pd7mAscGwxQPtNBNo=;
        b=dlRWB6qAoPjZb08joRIhpcbSHMgSUTlSPqG86d8tSR/XW/RZpBMKlmFtOQ8VEu/iYy
         Jf7JdT6ai20R1EEAxl2QLw+2xPh1JZFg4Wf5zat7JUGmqv8jw+iEljGD/FDr5zhg04gh
         TE2aJvPsOyFnbdQKvtvWr3yFqW22Mg1h1bX1jbUTQ8WSUhnBvwPYJZulXPlzu3nGv+qo
         LBkmZdawAw08I4GHoK02GXVDY+YjZDhs2S4bOCAPDYuVwIqVV3TxKkkm2+iVnU0Dk1Tq
         5EBRJe0/bMn8HDenya9qDLqmtaQeGEpUTFdhayQ3jNGQzSFpn7LuiCYwu19/ltptGw0g
         Ikiw==
X-Forwarded-Encrypted: i=1; AJvYcCVwyefXVQ2Vr5g05a3Ujgu8Q5x2bNhumo/A89vY83qraM355UsjzzkxDn2Q8Z3X+moKLvpUBUo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZVKCG7Vddf9LCO5yWOtgawdjcWQ+g46A/T0oR64AMpPkvgQFF
	n5TrUjUKQnVQ8tFQy/VUAPCjmHgfLC6RWQXbgiNo0CBpl9vvwIoHZ83bVsmRgAwrXRjoawDKgLm
	KQjDBBe8ql4TkeIyIvLX4PFPfniJfsfEpkEaZEgmObN7vIJQUjgjXWOW1og==
X-Gm-Gg: ATEYQzz3El0al+uWWsXiL26rO1UNWiSQ2gcxi2QJeVWfuqEPtoqW6MhB5lj6Emk8MrC
	lK8DM8ekZt34pOLvbBnzVDH0xgXmuW79tAo/GqA772CwwAK8Xp4Hk2QRj5Qj/j/aD3gGqzeggtY
	CNQO7JYV5B1pwy9M9Vo07gSl0TLwIJ483SQSmlnKZ5pEiDOJ891rSnOWSCBSSMRrPbTqf6qMhHZ
	2/2uKPcw2NupUYsIhQU3pSopq42PTVr2FoKzApE0EL82E2sNm9KZojfrnqVSMrBGHyjefTAj5qz
	AYpLthoZmvv2fXDQJmx95ttXGTSimitAOeC7ADZJ2vMFfIAX12I1sW3XT5rUsEnR98Yyct2ftzU
	AVfyZArflH8aBymRPaNgWvvCP+gJaydqmZo22NUGY+MiSxIZol8rTq9IdAF6AV3/6
X-Received: by 2002:a17:902:d2c1:b0:2b0:603e:e147 with SMTP id d9443c01a7336-2b0827313b4mr111046355ad.22.1774248104417;
        Sun, 22 Mar 2026 23:41:44 -0700 (PDT)
X-Received: by 2002:a17:902:d2c1:b0:2b0:603e:e147 with SMTP id d9443c01a7336-2b0827313b4mr111045975ad.22.1774248104047;
        Sun, 22 Mar 2026 23:41:44 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0835298acsm101110265ad.22.2026.03.22.23.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:41:43 -0700 (PDT)
Message-ID: <310ac0e6-6999-4969-b03b-a10564fc2901@redhat.com>
Date: Mon, 23 Mar 2026 16:41:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/40] arm_mpam: resctrl: Implement
 resctrl_arch_reset_all_ctrls()
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
 <20260313144617.3420416-17-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-17-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cFtnWnMzJDEtwJXmlyCDTKtu2WtZBGQIPpEk824LMvU_1774248104
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> We already have a helper for resetting an mpam class and component.  Hook
> it up to resctrl_arch_reset_all_ctrls() and the domain offline path.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Don't expose unlocked reset
> 
> Changes since v3:
> Don't use or expose mpam_reset_component_locked()
> ---
>   drivers/resctrl/mpam_devices.c  |  2 +-
>   drivers/resctrl/mpam_internal.h |  3 +++
>   drivers/resctrl/mpam_resctrl.c  | 13 +++++++++++++
>   3 files changed, 17 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

