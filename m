Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9025F7A5
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323786; cv=none; b=hV9jK9VUvs18FNUVJc6yqI7PCYovKxuuxHzSTWoArWhYDhdWUBaHtR6U/X+CU8Pf1pZN3beIagmsuWBcNN8q9cqgYnBVlr/zNoH5DCnP2tkcs+OpsIWSSh4bi1AwGxYujccSjxSGsfcccJK8KfDwIGaXBpKwUQq2V1DNSk8dfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323786; c=relaxed/simple;
	bh=tYxPUmrkSqy+h9zx39+4UE8iSXzxJ2KKz/e/bnLjXkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tZFAd8GVTcDbbYRXDhkINLKOEax2Ls+gy6JDPIIVSp4XZA/tzLbDYxzA/+hSiQNjC5bwHhqtvJYyamYTNhRiDAng+mulcI/elj5gd9nkUU8tM2hthhP5dNSvMtb3ymLuPkCG7a9DywoCOUYenLlSbmFqsbbS+PejcimpfrdBDGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOp3Grk2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOp3Grk2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SY61T0BWUy1OFaShdZnORkkoebo47/qKa/D/wut4yWA=;
	b=FOp3Grk2EwHJQP+994N5dWU3AawicNBSGQ0VpTG14IcvgPHSDUuAsdUJRI6j+fYPIWqIy9
	iPsapl3iY6Z/DeknEoV9bWmloWmeyL/tEgvQkSN0xwWRcYKgimHz4r5Kg6EHc4KIkN7o95
	bAT+goqtl1ktEXmUZHdbFSxfzvEFdE8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-56zomUmuOKmJRL43pDhtPA-1; Mon, 23 Mar 2026 23:43:03 -0400
X-MC-Unique: 56zomUmuOKmJRL43pDhtPA-1
X-Mimecast-MFC-AGG-ID: 56zomUmuOKmJRL43pDhtPA_1774323782
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a1e725a8fso25421794a91.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323782; x=1774928582;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SY61T0BWUy1OFaShdZnORkkoebo47/qKa/D/wut4yWA=;
        b=B+9uxBqufOPhTbt/SSgyeOJ3hp47xgRwqJw7+d+qnREdPa/YtcrGQ/c3uKLjk6YgRC
         QueA6pgOzfCXMcofwNbnnnbfjMSASu/7oTjkcYc85FtLtJ0xrR9UB5fH05oEG3NvWDO2
         YzjBYo/FO0rnFpS+WNaRbJgFyUpxfpdvJrUGS7XkHNbBASgVdHGC3Q3sLPJhoUBWBYTF
         qd0LC9ZGeJoy+00MAqtcPVr78MaOnP6+hAFJOjKXZEpMacD/GDsyeF3it7HL18rx7gDP
         2wpe1+bdtkZTrnJo2X3hnJODWCb2mbIWhcJ3yYs6kJldWKUbOJhNNWgkRqwAxMVRmyoa
         2yvg==
X-Forwarded-Encrypted: i=1; AJvYcCVqAYUX752kL2DlUVswjW/miBI4FDhUgVguL2yg3KngH8l2IJKdnGd0scJu36a9GEdSolFVN/I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIPrlWsJ69FmN1+qx93VXCi+tTnXzVY6SoJuL+iQiKC8lsCE8N
	+6C2WXHMzbz2GzQ4AWH4zFUlsymsbH9XOnCG5OAlF/CkQbUPxKAjVTbIoTM6IoEnJ4R9AeZ9wQJ
	Djc4KCOp2a7sn4R2dzWPl96n6ip0YjhYTeXWuymVleb0VT3ueom+nX2Z2zA==
X-Gm-Gg: ATEYQzwauj0h+E5AqksR4jHDc58c/9e3cXUkatSoB6LVGVWXt0UebgR70ab9aiff9xx
	IbW6TUFO8NRrHORMl9BMvOF9jmjvdbCURM3ChoER4d1tfsWztAYXwu0eZEAyN8sy2Dxpo5wmLi7
	5OhXkelB2cHVbwW7odIiqphvLYLv2DtPfVIiXfE6ux9aVbCzi+PJ45Jcn+6jw1mkhBF8xWhtT5E
	z6Nkk2v3ie66mI6mknS01XzGZQcosY8FKqIRxcc+XmNEgc5VQWk3pzl0R6XQnU0wnaA1YDlFpkV
	3BfilJ60mZ32doiKZuEm1mdI5FHzAb9tKvez+d/oc9jzA15Ey8UZBDdvIAMu9kTlnfuQSWvi9K9
	ffIA+4M+slA5zBtBbUhW7czqsCHWtmh/KomPM4Bl6tNReOqqDs3xWKaBs0BfyEJOu
X-Received: by 2002:a17:90b:3946:b0:354:bfb7:db0c with SMTP id 98e67ed59e1d1-35bd2d349efmr12535739a91.22.1774323782499;
        Mon, 23 Mar 2026 20:43:02 -0700 (PDT)
X-Received: by 2002:a17:90b:3946:b0:354:bfb7:db0c with SMTP id 98e67ed59e1d1-35bd2d349efmr12535706a91.22.1774323782097;
        Mon, 23 Mar 2026 20:43:02 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03044d04sm751468a91.0.2026.03.23.20.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:43:01 -0700 (PDT)
Message-ID: <a09e6800-bbdd-4798-a419-df656e18668e@redhat.com>
Date: Tue, 24 Mar 2026 13:42:45 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 33/40] arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
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
 <20260313144617.3420416-34-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-34-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kDLDLwbB0ccOoIVe43EXM30rzQKjZBjQyIetDrh80Ac_1774323782
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Enough MPAM support is present to enable ARCH_HAS_CPU_RESCTRL.  Let it
> rip^Wlink!
> 
> ARCH_HAS_CPU_RESCTRL indicates resctrl can be enabled. It is enabled by the
> arch code simply because it has 'arch' in its name.
> 
> This removes ARM_CPU_RESCTRL as a mimic of X86_CPU_RESCTRL.  While here,
> move the ACPI dependency to the driver's Kconfig file.
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
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/Kconfig               | 2 +-
>   arch/arm64/include/asm/resctrl.h | 2 ++
>   drivers/resctrl/Kconfig          | 7 +++++++
>   drivers/resctrl/Makefile         | 2 +-
>   4 files changed, 11 insertions(+), 2 deletions(-)
>   create mode 100644 arch/arm64/include/asm/resctrl.h
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

