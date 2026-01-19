Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589C28689A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805436; cv=none; b=VAvjC0tIoTE82cgd2Thktaurrj07kB9jpMxIkHeYNVK9CKq5HhWxoxmlL7tFMlRl6deVYBEhLX9/IkT/1q3OoX/AQrrqgThUyPTcGvQwDkrtgQcKr2NrJvYH3ykdyNhOqVp9YbXPwx/SMxqyBnFhVV7iTotaVeqQvc2ldALr8TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805436; c=relaxed/simple;
	bh=Jh0m/yszHtEL5bTqPtdLSaj+gK2Hg5A3eZDsiwV4vW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lT3POElitlZZuX/N2+soKzFYgCztaXf9ONCqtdl6AzVcmMVSK6ovjW4bDm12xTX/YAYaRJOrXv9jt68m5gY1HQLG3lrXFr5QCI8vWqMdprGb/XcxwSKWZjVYPaG2FjNN209dqkMnohYRW0NHE0SzJ8YHA2t9++3VHbNuCxpLMHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7spNtPC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7spNtPC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768805434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZXssrWO4VNoRsonbFVHKtNwsTR5/H1t40KyaHBjVhQ=;
	b=S7spNtPCACNVtD17r3spC/2f/oeHLEeFOjLx/9Ioq1G57FcTYoqSMTBeqNDIYCHLRavwIe
	aA7EhUcTW/zR8CEHcpIRQecEQGaoggCueQfjwN4tdpbdUQNrNYUeQAodpk/Zy2lPg4SFFD
	7449uUef0gTwQX1QKn8ShqhHHrlP/UA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-mtWmNXycMS6tfozQK5Jyrw-1; Mon, 19 Jan 2026 01:50:30 -0500
X-MC-Unique: mtWmNXycMS6tfozQK5Jyrw-1
X-Mimecast-MFC-AGG-ID: mtWmNXycMS6tfozQK5Jyrw_1768805429
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f1f79d6afso44657035ad.0
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 22:50:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768805429; x=1769410229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uZXssrWO4VNoRsonbFVHKtNwsTR5/H1t40KyaHBjVhQ=;
        b=OQnrYpmyaBqmRzKGsS19EOvgPELgJPcNm3BKSeojCOFfbyhG7H2sj3gxpBUNuChFQr
         vVwwN41XK+eXrmdBjRKDlzstnlEImc6gLmB/Mdly8k9md0JaO9n1cLc5C+7im9vvdnor
         /7NB9HqzeqWN3aR6iIiy9ofTHRN1r/Y6h2E/SrzwdOnqHRUAPMzCmbsoJH51UeX9/U2G
         WZ+Hsp7HiduMgSRMtzdO8qEcefINdjHM4mBBvzhztIAxY5cQTmtQf2sNzdLRWkB7kER4
         UVbXTxoNMCSUcxI4nt9AxncGW/oxvlPg5RjhEO9CpTTkwSE7O6Pl8KIxvDxZihAebyXj
         6ikg==
X-Forwarded-Encrypted: i=1; AJvYcCVyNMPa7LKuwY2L6XAolazh4uz2zzjVuk5uLDOBiqJMyEaeGVgom5NzpaDXV3UPmnZmVyKMr7I=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdtoN5Dh/Yjwou+bD0mkp77aFK511k1UKQQqyBb1zO+8rLheFp
	EcAoyl6UHTsYw2sfyAgxqmSdICzHjIQ5jXYGng7M6v0CHT7u+FEgUaUkI72fGyDVYODJuNU8Kqj
	2EbJOfINnUsm8m8I0A3Yu5OhTPigT1bp+98O1zcVWsZgIcyPBNE5nuxlRnQ==
X-Gm-Gg: AZuq6aKLHQqwUHS29paTfX0za+tc3GJ+BehqR11lv8Oor6OLUiOp2iKbs7RRRBH8WKV
	M977jIfHi45k5OaUe4xGsCzfe3A9s7Ukc+ase9Rk3zk5fwACaKC0LzfRx5rU9sUZEYcgtFwh6t/
	oEizrGN5A9vBnSygxRFPzJLboFpuEQDNnGP7iPMsAsXovr+gf7v5M8OfGN6CVCVQYPgSuZ1G8+s
	VSgJoTkSQP9e1s7txXM3S2KWbfNhOIadJExee8JcTnjtyZ3aUf5olAB5k/kfn7vEtO5XETM51UK
	scDFp5MCpDUzlPPby3Bu7ZB+iPv0q+vaOSLnkAVLbaZ2BNF9m2og7NeZPmYlz4YwE6lzF3IDKI5
	xAvkElEHSxEk=
X-Received: by 2002:a17:902:fc86:b0:295:9db1:ff3a with SMTP id d9443c01a7336-2a7188fc362mr96351315ad.28.1768805429482;
        Sun, 18 Jan 2026 22:50:29 -0800 (PST)
X-Received: by 2002:a17:902:fc86:b0:295:9db1:ff3a with SMTP id d9443c01a7336-2a7188fc362mr96351035ad.28.1768805429090;
        Sun, 18 Jan 2026 22:50:29 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dbed7sm85660715ad.63.2026.01.18.22.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 22:50:28 -0800 (PST)
Message-ID: <5c79d642-cd95-4c6b-9eeb-bd055719ca91@redhat.com>
Date: Mon, 19 Jan 2026 14:50:16 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] arm64: mpam: Add cpu_pm notifier to restore MPAM
 sysregs
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
 <20260112165914.4086692-10-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-10-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5f3i46wIAhitvz1uyHRjPnnr9Lag-sVSkZvOe6MsVt4_1768805429
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> The MPAM system registers will be lost if the CPU is reset during PSCI's
> CPU_SUSPEND.
> 
> Add a PM notifier to restore them.
> 
> mpam_thread_switch(current) can't be used as this won't make any changes if
> the in-memory copy says the register already has the correct value. In
> reality the system register is UNKNOWN out of reset.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/kernel/mpam.c | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
> 

One question below...

> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> index e6feff2324ac..dbe0a2d05abb 100644
> --- a/arch/arm64/kernel/mpam.c
> +++ b/arch/arm64/kernel/mpam.c
> @@ -4,6 +4,7 @@
>   #include <asm/mpam.h>
>   
>   #include <linux/arm_mpam.h>
> +#include <linux/cpu_pm.h>
>   #include <linux/jump_label.h>
>   #include <linux/percpu.h>
>   
> @@ -13,12 +14,41 @@ DEFINE_PER_CPU(u64, arm64_mpam_current);
>   
>   u64 arm64_mpam_global_default;
>   
> +static int mpam_pm_notifier(struct notifier_block *self,
> +			    unsigned long cmd, void *v)
> +{
> +	u64 regval;
> +	int cpu = smp_processor_id();
> +
> +	switch (cmd) {
> +	case CPU_PM_EXIT:
> +		/*
> +		 * Don't use mpam_thread_switch() as the system register
> +		 * value has changed under our feet.
> +		 */
> +		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
> +		write_sysreg_s(regval, SYS_MPAM1_EL1);
> +		isb();
> +
> +		write_sysreg_s(regval, SYS_MPAM0_EL1);
> +
> +		return NOTIFY_OK;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +}
> +
> +static struct notifier_block mpam_pm_nb = {
> +	.notifier_call = mpam_pm_notifier,
> +};
> +
>   static int __init arm64_mpam_register_cpus(void)
>   {
>   	u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
>   	u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
>   	u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
>   
> +	cpu_pm_register_notifier(&mpam_pm_nb);

Need we ensure MPAM capability exists in the hardware before the notifier is registerred?
Otherwise, mpam_pm_notifier() can accesses SYS_MPAM0_EL1 and SYS_MPAM1_EL1 system registers
which may not supported by the hardware.

>   	return mpam_register_requestor(partid_max, pmg_max);
>   }
>   /* Must occur before mpam_msc_driver_init() from subsys_initcall() */

Thanks,
Gavin

