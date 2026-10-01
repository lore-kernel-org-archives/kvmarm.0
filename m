Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC582499F32
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860235; cv=none; b=G1PwZrId+Biqm7YP6LeKStpDoi76p6Lizhyp9UjstGg76BQrOBeZpfaGSwtF+NrxIzgSPysFX79TFiVcaSRdlGIS4nbzYZafEEp33/EE4xDcqbAEE1hNge40mwCQZPFy20DsMf/DPsk/GTPHhK9UoW0zYdz8THUW6hVMI2A680M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860235; c=relaxed/simple;
	bh=LTZ6Km6/CpuoVK8bg9yT3WNGLHdPkHSXQmJ98kg34ZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0wWEbccSaX2AUTXvuF6jOpGC6zCxrpe7ORBhGPqfrcEJ2cv/RkGideWPVmYYTaEYVz2Olje3iavbrYPkNYw4gtETu9hnDwgYvtIIjSIJJ63uRLQoLxUDohoAVmi5ULaebWL67jxSDxtql7OiMCe3EE/iijKuZV563K7tMYNRl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X7g9fxCm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X7g9fxCm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790860232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DDJyio79knKj0re/byLa1b13NjMEeAfKBhItlxqNUIQ=;
	b=X7g9fxCmycN9dDwdR5nPCfb7lp+/QBFSFekcTr+XJv4bQDRja2hHMUdMUok6UAQP2TuhEr
	BcIOKSaHyGGgW+sj8r1E25iIOVNNo1ab3S0VWL0iwxXDEV4tWAIuFJfvfesnsxNyHifJJc
	enzs25RlCsuLQd9bWNwxj6tfWjc05PU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-ZuB7Tdf8MJWngs7Qdq4AnQ-1; Thu, 01 Oct 2026 09:10:31 -0400
X-MC-Unique: ZuB7Tdf8MJWngs7Qdq4AnQ-1
X-Mimecast-MFC-AGG-ID: ZuB7Tdf8MJWngs7Qdq4AnQ_1790860230
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so7019222a91.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 06:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790860230; x=1791465030;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DDJyio79knKj0re/byLa1b13NjMEeAfKBhItlxqNUIQ=;
        b=gzpMi6S93SGnfBi738/LJqvqsUKnI7F4aEnpZUD1qYxtf7yPbN+bVHKb9d2GOq0iBK
         VKDEoLi+QwvG5Thrn6FcRbRcdkfOH/Wz7rghF4i8OkP3BkkgXLPSUJCCXCRVK66ypGdS
         DxpvYLXn0skGXpJ8BFheZQfjHTsvGM5J4KBKBwAgDCqVlU7ync0S/eN9XN1MkGA+Kb5q
         NFjGpLojRvv7T0dSnJu6WTvncm3LW3NZrfaYO0s89pYlQwrcuB/BGxoMy79HOYjS9Vhi
         KI3IjOqVXlTJQ7Scwkshehsosg1O+gH8Kfs0/LbZ5mjQ1IPrjb74yCyRRpRC9XDeN0jE
         xvUQ==
X-Forwarded-Encrypted: i=1; AKwUvByJAWkXFhMUVIPC5uGkHVjcbiHmHhT8TqeW3NtbrZPlQX82M1lIGcWG6/cwYmtnBxHcPp8TQrg=@lists.linux.dev
X-Gm-Message-State: AFq9FYLhdQoqCNGurvCjOy6fXslc2FQCtOX44Mro4VCDTVChSnMiroMh
	07hhYXkp4QmXRnakR/V4uioJFT2vJspGIbtuFginiHTuc2nQ+NwqND3Qm2KRrhCYXhv8bKU/xIs
	ic70ijZQHWDdEni0mNcsgvfOnJjSTn/t/YQuxFJGzG502tYCd6B1o0/kUpA==
X-Gm-Gg: AYBFou3NHF/XzWCc1tn5PjoCG3jyXx9Sv5z/ibDVmzVf8dBlfRaG0lwyvyBHYpGx5cT
	/izyXW5gHn/JxrC6Cx5wLMIBKVwiTuEhmJr5Zqo4+Efpg4MUgGs+IgY2Qaz5S9lu8l5sG6wRTZM
	YxUU9qNVo6ztLXGGxvXNChoutWqnwxz+Ra3k9bsBQh9fndJ1HjhEB9FGWh1VRJ575cgKNmjS/Jp
	Kp3gEAM+be6PRLRLcn0agiYkMwfAGJuM2hEbZxt+wSRXiO/B3SPIUtLhr3wT1vVXHOWTVcqv+Na
	/u5bvciqAdg+L49cc3Q1XGf88LtB+aLDlBC4oxVTE3jX9PHmaxE2ThEIjSlS79DJPy+o4Qv4GPs
	8VZ6cpIiVd3C5ptBqhz3GxQgO3nvEs7+h3X1PSro3xg==
X-Received: by 2002:a17:90b:4d09:b0:39e:6c69:f472 with SMTP id 98e67ed59e1d1-3a4d18c0f59mr4364884a91.49.1790860229920;
        Thu, 01 Oct 2026 06:10:29 -0700 (PDT)
X-Received: by 2002:a17:90b:4d09:b0:39e:6c69:f472 with SMTP id 98e67ed59e1d1-3a4d18c0f59mr4364841a91.49.1790860229444;
        Thu, 01 Oct 2026 06:10:29 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f6fb6438sm1829850a91.0.2026.10.01.06.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 06:10:27 -0700 (PDT)
Message-ID: <79509ef8-6b7b-4499-b2bf-f400b1c197bf@redhat.com>
Date: Thu, 1 Oct 2026 23:10:19 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 9/9] firmware: arm_rmm: hotplug: Skip memory added to
 ZONE_MOVABLE
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 David Hildenbrand <david@kernel.org>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-10-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261001084555.1456543-10-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 23M6GBsgTy2q0VEB6EliM-PWt4TBukBcoYbFTntmhq4_1790860230
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/26 6:45 PM, Suzuki K Poulose wrote:
> If the hotadded memory is in ZONE_MOVABLE, we could allow that to proceed
> without the RMM having fine grained tracking, as we won't allocate pages
> from there for guest-memfd or kernel allocation
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v20:
>   - Use is_zone_movable_page() and only check the start_pfn
> ---
>   drivers/firmware/arm_rmm/rmi.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

