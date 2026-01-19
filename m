Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49C027281D
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 06:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804685; cv=none; b=PH+pgxVtsp/Ip7R27vnjhd2TuVLrQaoEVUfSZB2YE4PXJJGkY1dRlUWnVzQoQtTGax/kW333YRWEKxvdjoFoJh1Yo0Fff+nNU6JjV24byfQODFxin7OrrSezol7PgfGrm8Al/Vp1d0eZjjXUTpclrKTrsRjppHVptSH1Bian2BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804685; c=relaxed/simple;
	bh=TyFxSflmLxqB/iQSrDRCIRaF+25Qt3SPcxCIR5iuEL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFaES3CIy5yCUEFrZktlyQP0tCh4FzO7hOOhgBraojbB0ZygwweWAwSLiv2ho6Twa0lVkPqSJuzyAhu9rdPiZK51UqTAGMFSHoFljUpFDx89riv1w8Jbwlrdd4JbFroVAKchGYyqN1o/9ZTZYoKnk2N9b8ebUDJpPgPcRV9KMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DZBVJpyr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZBVJpyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768804682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2P9q1+y/S92Xtrelm9Z9KwaSNPwiPTRRSimXjtAutXA=;
	b=DZBVJpyriutpbS9xu1JAXYiNFd1D1249fN0ySDR2tGCDjaT0OQCOZGyGacYBKQA0249Ixq
	JfQIwYehudZ6s/wW2lZt13fTGXtQZmwaIRgr7xKjkN0MsMhBO9atr/S3zR/OsWvAcUB15v
	eHfJLwSR12VgC8q1RgVPbQevPhZpkZA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-v9MMrlQoPdSWjaok1-KfXw-1; Mon, 19 Jan 2026 01:38:01 -0500
X-MC-Unique: v9MMrlQoPdSWjaok1-KfXw-1
X-Mimecast-MFC-AGG-ID: v9MMrlQoPdSWjaok1-KfXw_1768804680
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a73dab2e2cso7007155ad.1
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 22:38:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768804680; x=1769409480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2P9q1+y/S92Xtrelm9Z9KwaSNPwiPTRRSimXjtAutXA=;
        b=OhAqqtMSEKP41ejTDiOxptUhkqZf7hJoJ53Qc5fWRpPqlsdpWGiomoUCEepE6nOSZz
         tOPKCcMwyyVQuxsrn3wIYPLRkGvSSQmpeJqUWI0NYZ5jKjRV0a3NwnHIYdO3qr0uB0e5
         IK4bHZQpQEKXigSphtE1xyYhL1rYKrb12zfjUtyTX9guJf3OcypQ8eFqpYbUwTUQjtal
         JS8G/xZczRNPQ1KviVZabhI1VKIFoJeFclWE8cvjzYO68yeG7snlB9ITzRlgmyKOywRG
         WSSqE3XP4pGTrQMCrELUfqPlTPocKsB5/i5NTvEVihVckKfd49bsrhM5i3n/f43k6L9Y
         KGDA==
X-Forwarded-Encrypted: i=1; AJvYcCXcxajS4JzI7EGCUGDp+21/IrZhkJ/BZGQiGk/y/DG+oC59XiBSgx1ntq93vkWNytoPqjQC0/I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+wQZtQwmBD68FYoP3uSSlDPcXkxs6TsWc6FgScBWyqoi8JpbD
	n7a4t+Mmq2Ukq0cwIZtP8dlVzbtmxnCBP5UHlqGKhS59esb7CH1nWcFZWpCEa7JfhiPFIgo1rwq
	zkqmtz++K7XnQSgjuZo3WfI4T9ery48iAc3y36eF+2gTqdXBWxH4Md6oF7Q==
X-Gm-Gg: AZuq6aL6KzBMdHzdhDvJvfvTs4drIE3q8h4ZEwmM3GHovq43zs12GuOGHyIlzI0NQop
	wfU2fdsyhIv1HTEC8iScdqC/kW6JRKLai1xkcrrLCD6h7GEXtA5b748qbdur5B5jzazkR0COsi7
	jtKhSSv6BnxnO6fXEb8pqJSSeuXLPfoVicz89rinf5kRFQRnn/rIQynpqpeIcNHjMw4IGIZFz+F
	4tW9kj6vFGomDpaJoBi+CmCVonWUerW3ELFyCp2/YvLRZ52i5MB6zDIDWxlh52219M1yy81BdoP
	Cnqw1wvm1unvbZtDm0CeIWo2RWaLO3YsC//xqkkALjLP5t+5uOVrI4OYMT/+CD1MAPW9DxhMyhk
	niSlS3CBovr0=
X-Received: by 2002:a17:902:ebc8:b0:2a0:9238:881d with SMTP id d9443c01a7336-2a700a1c29fmr135715775ad.15.1768804680372;
        Sun, 18 Jan 2026 22:38:00 -0800 (PST)
X-Received: by 2002:a17:902:ebc8:b0:2a0:9238:881d with SMTP id d9443c01a7336-2a700a1c29fmr135715515ad.15.1768804679983;
        Sun, 18 Jan 2026 22:37:59 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35273277f68sm4098077a91.0.2026.01.18.22.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 22:37:59 -0800 (PST)
Message-ID: <7c224083-595b-432f-9147-1e8067df634c@redhat.com>
Date: Mon, 19 Jan 2026 14:37:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/47] arm64: mpam: Advertise the CPUs MPAM limits to
 the driver
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
 <20260112165914.4086692-9-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-9-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UYigcMa1F8mFmQZ3JrcqwI2yrG8dMFPkuujleLKvwcc_1768804680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Requestors need to populate the MPAM fields for any traffic they send on
> the interconnect. For the CPUs these values are taken from the
> corresponding MPAMy_ELx register. Each requestor may have a limit on the
> largest PARTID or PMG value that can be used. The MPAM driver has to
> determine the system-wide minimum supported PARTID and PMG values.
> 
> To do this, the driver needs to be told what each requestor's limit is.
> 
> CPUs are special, but this infrastructure is also needed for the SMMU and
> GIC ITS. Call the helper to tell the MPAM driver what the CPUs can do.
> 
> The return value can be ignored by the arch code as it runs well before the
> MPAM driver starts probing.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/kernel/mpam.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> index 9866d2ca0faa..e6feff2324ac 100644
> --- a/arch/arm64/kernel/mpam.c
> +++ b/arch/arm64/kernel/mpam.c
> @@ -3,6 +3,7 @@
>   
>   #include <asm/mpam.h>
>   
> +#include <linux/arm_mpam.h>
>   #include <linux/jump_label.h>
>   #include <linux/percpu.h>
>   
> @@ -11,3 +12,14 @@ DEFINE_PER_CPU(u64, arm64_mpam_default);
>   DEFINE_PER_CPU(u64, arm64_mpam_current);
>   
>   u64 arm64_mpam_global_default;
> +
> +static int __init arm64_mpam_register_cpus(void)
> +{
> +	u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
> +	u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
> +	u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
> +
> +	return mpam_register_requestor(partid_max, pmg_max);

mpam_register_requestor() is exposed until CONFIG_ARM64_MPAM_DRIVER is set.
CONFIG_ARM64_MPAM_DRIVER and CONFIG_ARM64_MPAM can be different until PATCH[39/47]
is applied. So we need PATCH[39/47] to be applied prior to this patch so that
mpam_register_requestor() is always existing and exposed.

> +}
> +/* Must occur before mpam_msc_driver_init() from subsys_initcall() */
> +arch_initcall(arm64_mpam_register_cpus)

Thanks,
Gavin

