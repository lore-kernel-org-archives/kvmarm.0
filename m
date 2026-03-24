Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4424113D
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 04:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774326096; cv=none; b=rYlavkHC0jqDCmUSLocJ76Uf0YWQDAdtFQ01e3m2HBlNe5GeRK/oi5jYGyuWBWNzgwhD/7uqaXMayHNt4/yeO1nQT+8+eiht88EVWQCMTQW5kbe8ijV5s/gRTkyE5N8NAgDTrtcr1PXDVJJkPnALnuxZ4ZcYAOMeN8wsZbhx1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774326096; c=relaxed/simple;
	bh=Q9J8EZ7KakpOEdBx6xv3rMsDRoJWbyFh7BbfJZNgiME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DST7kRHUww1Ga49sj3GfMNkIurHRmJT9HjJ83vwFbLpJy9hQCy9Zh0im9IYBbmpfI4cIvHTpvoOPyD7rDCYy7YRSEa0sLPJko/pY7fiL/peFdzzicq0LKf3skJc6h3s5wKvy8vaLV54DdaubEro2/6iXotsw7hnKugOgtE3YHJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4T0eo3r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4T0eo3r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774326094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=as1oD5ZP7ir6ec+9vRMPKCBQFoPmXvB2fXhjUdsVMTM=;
	b=Y4T0eo3r2O1PO9biZccfs+rLF6boTotXzzpHT5s47b9pWI2ghibmlNRilSWr5MtQBtSUB1
	DsPvnFI+wA9KkNgmiYRoRt0D3y2Hd/Rj+0z/5hLX2a2mzAihjuG7RH3E0nAbS/zUVpoX5R
	YHmcrlcbKH0T8xkcp6/2MjuNDKkM/k0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-rZFs4ssmNB-e22CnjVYLvQ-1; Tue, 24 Mar 2026 00:21:30 -0400
X-MC-Unique: rZFs4ssmNB-e22CnjVYLvQ-1
X-Mimecast-MFC-AGG-ID: rZFs4ssmNB-e22CnjVYLvQ_1774326090
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2adef9d486bso34813175ad.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 21:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774326090; x=1774930890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as1oD5ZP7ir6ec+9vRMPKCBQFoPmXvB2fXhjUdsVMTM=;
        b=lvmYUHlnTjmPuJE2pDZqAp6yRG09zgN2Ahp2Z7Dr5TciT6JgGxRS2lmeJFo4MYBBVZ
         Uy4hYegM+aURcxSKeukff3GYxLdOkgy9q9zXbA6OWcQppwgqt0lBp9y86V6vin5TD+Sj
         DZAfyrnTTeSbCoh7q0M+01VLDJWOy+t+MwRFpXuOv+/r+DYjtg1ekTEeiUO5mqeefO6+
         KmTFVc2PwHv2hICVUY4Lv1zsPFYPzxpE9SjTYpIhbq1mftqGJh+I72Vh3rcon8i3B8sd
         C2Xs7PwYFZ3HfwE6Dkm0NXSY1uv2szctwPThFMmreh3jWGPJRM/jdYF2ccSUmLmZkPl1
         +PQw==
X-Forwarded-Encrypted: i=1; AJvYcCWyhL5VBFGggVIZigvq6mF5GP+0qt8ksDlQbxhz3fkvkJFd0IS00V1e8ieklA4XEkGF1X84DMs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTQd0Ug12S2OCZCGd5Z42YRLejXOD5ApgXoBkkkzlZX8AyowmK
	1uP0rs/0BknpPAXqSPCumrx9d40jttAZY4fiv3F1BbqW8KNQJdvenLmXOhwszdR+6W+DoDT7+jR
	CBPDxsZl5ruvTu7KRm3gIsZK5uOX6ieq7SxUblRLLPU8el3qdkcIIESRbUA==
X-Gm-Gg: ATEYQzxGc6klq0ul4afznPZOE5x/KVzoPS0d9+5Wt6VvUBEBnmW713/tDOV+TPjVIxp
	09fNSYqHE8XSjmwg6PmwW2p8oPH9sCAM77zbaGqsAnSKsc0Ig5tYl2Xu9OmyhUvHqgG+D3miWTm
	5QNwAjmg61QYJzCC13uNnnuJUgifOFyvJVPQbZLDvjRXYgL9sVCRGd14JVCjP/K7SLtxtIly2l3
	Hucrn1owH5YKLwOIy9Bj+U9bWvKWw6okGtVVjABekPFPrQDGXTVUh40jV4BPUpwVDev9FMVO7BL
	ehqDJ/isOwCIHlDriTb/Hlqg/mxUjgC9ha2eKCK2Uzjr7r1fN+daN7B6mE5pxc61aBaM0rhVKEV
	Ahc+YQSxCZmbcweDbG3QkXyctS75FtM5fJ4vCdYOztzS2j/vlB1s4UULOvZFH5AZs
X-Received: by 2002:a17:903:1a67:b0:2b0:694d:f5db with SMTP id d9443c01a7336-2b0828238d5mr130410665ad.52.1774326089749;
        Mon, 23 Mar 2026 21:21:29 -0700 (PDT)
X-Received: by 2002:a17:903:1a67:b0:2b0:694d:f5db with SMTP id d9443c01a7336-2b0828238d5mr130410275ad.52.1774326089350;
        Mon, 23 Mar 2026 21:21:29 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366c74dsm171510225ad.62.2026.03.23.21.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 21:21:28 -0700 (PDT)
Message-ID: <d82f9434-ec90-4872-b779-2b20aa8e700d@redhat.com>
Date: Tue, 24 Mar 2026 14:21:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 39/40] arm_mpam: Quirk CMN-650's CSU NRDY behaviour
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
 <20260313144617.3420416-40-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-40-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v6y-w3RLkOKiQDUdKZnhhIxbhcQBFee8__P6ATZa278_1774326090
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> CMN-650 is afflicted with an erratum where the CSU NRDY bit never clears.
> This tells us the monitor never finishes scanning the cache. The erratum
> document says to wait the maximum time, then ignore the field.
> 
> Add a flag to indicate whether this is the final attempt to read the
> counter, and when this quirk is applied, ignore the NRDY field.
> 
> This means accesses to this counter will always retry, even if the counter
> was previously programmed to the same values.
> 
> The counter value is not expected to be stable, it drifts up and down with
> each allocation and eviction. The CSU register provides the value for a
> point in time.
> 
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v3:
> parentheses in macro
> ---
>   Documentation/arch/arm64/silicon-errata.rst |  3 +++
>   drivers/resctrl/mpam_devices.c              | 12 ++++++++++++
>   drivers/resctrl/mpam_internal.h             |  6 ++++++
>   3 files changed, 21 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

