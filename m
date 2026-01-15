Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AE275B0F
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 02:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768443309; cv=none; b=fZkVg+jYRA8fOVyqUCNfTehjhgfvZh+3fbqnqPO2gdVqQTuV9bWR81h1KyF7yiLrbyWKqGc8yCRP7BS/sQU71lM6MBVFzNDHexnEHD2Su7hucqO7MRrRDPAZRtuEO3NMclMZWSxpUs+eiMrFMX8ZaTQxzOQD2IRwueRJZAHDKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768443309; c=relaxed/simple;
	bh=eBbieCwBHiWcFUG7hDjEHdyb43nn4ge2y9+D2+InXxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qg44JX9s6NNJdfHoNl/NokBU1zJCt++reKVfOBg0bekmBR8wX1B10FOMDJa7CmoAjM4nXQmOjSj5J2UKNsa9sbBnPWtHrb5x1Fa/iVxmr44jkzhvFc4RlbOakjJj89E9ABNpzseqamcj3ceIt4NlxH5VSKzSlLwNNRzhXTT7LZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZWeLGuu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZWeLGuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768443307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVLNaYRdyTd3Y3bYKBBodLvCmiY6IvN6c8AunBjxbBE=;
	b=ZZWeLGuutR5Djx+mEGsmhULaes/xVqCjfadpJAb08rJ1+wUK2TVI50PSTPA2kDRBk08rad
	iEEys6n8SUoaaH1hzdt9rZCLCDHlG5wf48a0LhcdhR8nkSTizEwMD4dO2dFItqqNPfTMTl
	4MWqHmYp1//xgDtm2gwETtSk70UulvY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-QEA8LszhPW6dxuV7Yw3HYQ-1; Wed, 14 Jan 2026 21:15:04 -0500
X-MC-Unique: QEA8LszhPW6dxuV7Yw3HYQ-1
X-Mimecast-MFC-AGG-ID: QEA8LszhPW6dxuV7Yw3HYQ_1768443303
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c337cde7e40so204713a12.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 18:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768443303; x=1769048103;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVLNaYRdyTd3Y3bYKBBodLvCmiY6IvN6c8AunBjxbBE=;
        b=V+pIjfjFlPc+hoKJ/hMX2VyUWqo4fwjQfHB0tiOrwEzmNvlqv2otzHsP621vEt/79h
         yLCZ8QJ3D9LC4jrEf0asjTim8kn69dKEuRQqINk/ocz8+gC48pKvN201vHwzJB/Qag++
         +Oj+tFeBjW1qNLlKkUI2bxVYPzuVbMcEKqoy9M09X0DzP/8cbF5IgtwELDy1NKBvPoMc
         JWNolQUuCNAEHMzjYytrG+tdShwLcTamtUzJIQQ38tMQ7KmqRHkTeMfWOlSon07AJ+xk
         +OfOm5c4O6AAl1WhRvaUVlCO1rtqAjEFJzw61jTKgFaaqcqcmLi0LOZQP90eia/7I3q3
         J8uw==
X-Forwarded-Encrypted: i=1; AJvYcCVdvD4i68vZw9BGHd2we4KerUNwBfnScAyyGPIMD0fOwIAjCX663x7pbJpu4FSp5PtZx4vxCwQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXKtJjskQ1uGRHGP1+RLgrR0Cz/Za/Vp8LFwU+rM5gVMQd4mFl
	P1JVmtEi0l7alXo/dJnEqLF6R8MuOwYsqXaykMhoeUZpA6AXiAizuTkMmhGq+zUb5gGJvHgJjgM
	TSd99lRuRzY6eQmlG8F8dPWQFd0jEHJX8qifTsGjoCvyG947oa+Q7cUE6RQ==
X-Gm-Gg: AY/fxX5dnJc+iuLV3k3L83TDU2ALiTGS5iDwNyU0/5MXMgcg4VcA/nYlhYp5KXEBGbQ
	4LRSW7P1KZai7nlLxtTSqJ93EJdtVYXTyJpwBgmHkBNo9sJqJcG6aig8KlpVjw7u8nclcbZmAZ/
	BpxlWZIt0SmLmTOIKsuIJD9zgtSUpcDQh70nYlZ21xGg0m9j4abogDfQdy3Shqh5swkMvsu1gR2
	j1zEsXQk8o2/Lu1sJdy1eUSi5VvSggLRI+w05mkxYZfPFLqc2fD1jxtYE2fizkbMllcyyVBvcGY
	IMip92qdsNe7SJvjxmyxIqO5Z2QjuRr5TYLQ5wZvn3Ou+Fjt3Nv+zLBL1ABKorBMNVQ8E9/PRHt
	vFhEw4VTeO2w=
X-Received: by 2002:a05:6a20:7f96:b0:361:2c56:fca8 with SMTP id adf61e73a8af0-38bed1ca1c6mr4829226637.50.1768443302903;
        Wed, 14 Jan 2026 18:15:02 -0800 (PST)
X-Received: by 2002:a05:6a20:7f96:b0:361:2c56:fca8 with SMTP id adf61e73a8af0-38bed1ca1c6mr4829208637.50.1768443302510;
        Wed, 14 Jan 2026 18:15:02 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cbfc2f481sm23240011a12.10.2026.01.14.18.14.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 18:15:01 -0800 (PST)
Message-ID: <cf2cc08b-9170-4ef2-9f99-e2d901b40c61@redhat.com>
Date: Thu, 15 Jan 2026 10:14:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/47] arm_mpam: Use non-atomic bitops when modifying
 feature bitmap
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
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-3-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-3-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eTurNy1P3Mcj6MG9EjMdSiT-xmQpINSEX6PAYGfxZM8_1768443303
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> In the test__props_mismatch() kunit test we rely on the struct mpam_props
> being packed to ensure memcmp doesn't consider packing. Making it packed
> reduces the alignment of the features bitmap and so breaks a requirement
> for the use of atomics. As we don't rely on the set/clear of these bits
> being atomic, just make them non-atomic.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Add comment (Jonathan)
> ---
>   drivers/resctrl/mpam_internal.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

