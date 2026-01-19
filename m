Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F4B287502
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 06:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805519; cv=none; b=BPwW/fDihvvkCA4YQBNryoPBxq1QL0VpSyZmgYIE0gyY+39sdfvGW+nyq8M7mZbIoUYWaN6YNCqu5QqVEX2/vUeBUGzUEHmjX24qzUL25fEgsufuCV6mE5H9EG9hOBH0floJR0j6+25sQWOr/PiKxDGPaHtk6jSW+VsHhoi679k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805519; c=relaxed/simple;
	bh=bZeiXB6BUbz44xz0lHFtw6M8KXMjgafHcrVUG1lNH5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sYOhmnYTCJD6FULuhZ1mtuyY+ApDH6CWIxP3NWuQhKrtmZkd2dznyMzvSdvfLijXsmWCSapy0MeVmC/n3aby1GcAQMc6xtwwqQWDeyHoCduFSaohr/CyjLdX6w+D2E66dWNfc1cLC9s3SNnzAiQ7cVOn1XP/CEVEaI6FxY7z2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXHvfz3g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXHvfz3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768805516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bzEtYCi84yQH9JO79xyxedMMdape4n0UR2LMXPDOp28=;
	b=fXHvfz3gmt20gGmhp0CbBehCQxjIF7glJKni5aeMpXdTpckuI1zGjDcpdGErapS390QxS+
	xm/KzhST8Ow8vXBu/Flwmf/RfpooxCsbw+Xy9gg3avZoSLCDicxjVJYsW7bXUjeL2wlUFA
	39FTtRcq3BGV0ob9kIDPaIBe1P6SthE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-4BTC8GYGMQysF_pbcnbAAA-1; Mon, 19 Jan 2026 01:51:54 -0500
X-MC-Unique: 4BTC8GYGMQysF_pbcnbAAA-1
X-Mimecast-MFC-AGG-ID: 4BTC8GYGMQysF_pbcnbAAA_1768805514
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c5e56644646so2643151a12.0
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 22:51:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768805514; x=1769410314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzEtYCi84yQH9JO79xyxedMMdape4n0UR2LMXPDOp28=;
        b=VkSiejGjjIDEeqOCUt3lUjmpwuldsIQg43xC/Rn0Iyij4wvQBza30uAPtywc/vIvD0
         DPS7o6CUibluWbvNtV6dDlRl5hLWJpcbKVgHRG5uj8P1tu/HjPJJOCNGwfqKSCSxeT8d
         Wic+apXkKTnV30m8PMBSwgvbB5r6w8TxlNMn2R+2rrOCRfu5sSRvl9dtMC2JbdxT5exG
         320CXVJLHtN9TNGv0QUnWIEHCNCtDq3+9wWGwnPbcLzHOQ38lBCO0ABA16fKktr1VgpN
         j8r1n0esDhZuH9gXUbH+O3/lgdrniNvuh5ApbeMZZVUxALGsoqUtjEjSCFRm7wCoeTPy
         k1vg==
X-Forwarded-Encrypted: i=1; AJvYcCVjm8wUP3RoRXdvBzngfTLKvO7ivTmlgNic7KtD44HvBvNY5A8X5MAwTgiIkNCSasi8QFknpac=@lists.linux.dev
X-Gm-Message-State: AOJu0YwrfWdInA2azkqqKUctSfm2vCS6XuVw26HfyHrnwE5eMkMQq6bk
	aeP+Lue8VQJBV3E7Ak4aUw+PsSHucfXo29iK/rAx2NdCRJBOQqPMhrQ5aRbW0fdNLdWhpO4smZo
	mDtqHm6y59aPrMdlMj2vYDG92AfVfkXujTQuAoP73EZauZgWpbrU6ERSTZw==
X-Gm-Gg: AZuq6aLTGwWkbmbIM9Mub/ler0GHPf7/DHpGGSnH4ll4wvWkSPZn3Fiw9BSlmRfx6lS
	clt/xQatWSEKl6UK7kc/+ZgvJjHwnr3AqezQNNrsUJ4Kjp4VHWYvh7UkTzUHtbhqw4yVoQASyih
	SaOinD9Qh6gCNmWnr6iXxME2SBstn4ojwNB1UIRIxmvtCAJebzA0XQ6HBywbe16UWzsbRwLebP5
	O3K+YuaIvduz65FAYUan/cbj0JCpzurTk97MzgbsJXRJ4Xx7Kny1aY6bI3M1KMDS/4Z80Q44X53
	Ej7TcL/clFqQIQR4OlyYPkULc75oEHyfqDOHAR/oTU2QPrtMvw4E2+XGI7aP731hc9l+/6x7EI3
	GCQ5P9FethC8=
X-Received: by 2002:a17:902:e547:b0:299:daf0:e044 with SMTP id d9443c01a7336-2a7177daef5mr121119765ad.18.1768805513814;
        Sun, 18 Jan 2026 22:51:53 -0800 (PST)
X-Received: by 2002:a17:902:e547:b0:299:daf0:e044 with SMTP id d9443c01a7336-2a7177daef5mr121119555ad.18.1768805513371;
        Sun, 18 Jan 2026 22:51:53 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190d14cfsm85114355ad.38.2026.01.18.22.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 22:51:52 -0800 (PST)
Message-ID: <08172e9b-37d6-4e90-a5a9-b8a083a5a3c6@redhat.com>
Date: Mon, 19 Jan 2026 14:51:40 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/47] arm64: mpam: Initialise and context switch the
 MPAMSM_EL1 register
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
 <20260112165914.4086692-11-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-11-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V-NnM9wlOgbT3VlmnGL-tgEmhzwohm5f3Ze7rEB7Lv0_1768805514
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> The MPAMSM_EL1 sets the MPAM labels, PMG and PARTID, for loads and stores
> generated by a shared SMCU. Disable the traps so the kernel can use it and
> set it to the same configuration as the per-EL cpu MPAM configuration.
> 
> If an SMCU is not shared with other cpus then it is implementation
> defined whether the configuration from MPAMSM_EL1 is used or that from
> the appropriate MPAMy_ELx. As we set the same, PMG_D and PARTID_D,
> configuration for MPAM0_EL1, MPAM1_EL1 and MPAMSM_EL1 the resulting
> configuration is the same regardless.
> 
> The range of valid configurations for the PARTID and PMG in MPAMSM_EL1 is
> not currently specified in Arm Architectural Reference Manual but the
> architect has confirmed that it is intended to be the same as that for the
> cpu configuration in the MPAMy_ELx registers.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Mention PMG_D and PARTID_D specifically int he commit message
> Add paragraph in commit message on range of MPAMSM_EL1 fields
> ---
>   arch/arm64/include/asm/el2_setup.h | 3 ++-
>   arch/arm64/include/asm/mpam.h      | 2 ++
>   arch/arm64/kernel/cpufeature.c     | 2 ++
>   arch/arm64/kernel/mpam.c           | 3 +++
>   4 files changed, 9 insertions(+), 1 deletion(-)
> 

One nitpick below...

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index cacd20df1786..d37984c09799 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -504,7 +504,8 @@
>   	check_override id_aa64pfr0, ID_AA64PFR0_EL1_MPAM_SHIFT, .Linit_mpam_\@, .Lskip_mpam_\@, x1, x2
>   
>   .Linit_mpam_\@:
> -	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
> +	mov	x0, #MPAM2_EL2_EnMPAMSM_MASK
> +	msr_s	SYS_MPAM2_EL2, x0		// use the default partition,
>   						// and disable lower traps
>   	mrs_s	x0, SYS_MPAMIDR_EL1
>   	tbz	x0, #MPAMIDR_EL1_HAS_HCR_SHIFT, .Lskip_mpam_\@  // skip if no MPAMHCR reg
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 14011e5970ce..7b3d3abad162 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -53,6 +53,8 @@ static inline void mpam_thread_switch(struct task_struct *tsk)
>   		return;
>   
>   	write_sysreg_s(regval, SYS_MPAM1_EL1);
> +	if (system_supports_sme())
> +		write_sysreg_s(regval & (MPAMSM_EL1_PARTID_D | MPAMSM_EL1_PMG_D), SYS_MPAMSM_EL1);
>   	isb();
>   
>   	/* Synchronising the EL0 write is left until the ERET to EL0 */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 0cdfb3728f43..2ede543b3eeb 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2491,6 +2491,8 @@ cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>   		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>   
>   	write_sysreg_s(regval, SYS_MPAM1_EL1);
> +	if (system_supports_sme())
> +		write_sysreg_s(regval & (MPAMSM_EL1_PARTID_D | MPAMSM_EL1_PMG_D), SYS_MPAMSM_EL1);
>   	isb();
>   
>   	/* Synchronising the EL0 write is left until the ERET to EL0 */
> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> index dbe0a2d05abb..6ce4a36469ce 100644
> --- a/arch/arm64/kernel/mpam.c
> +++ b/arch/arm64/kernel/mpam.c
> @@ -28,6 +28,9 @@ static int mpam_pm_notifier(struct notifier_block *self,
>   		 */
>   		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>   		write_sysreg_s(regval, SYS_MPAM1_EL1);
> +		if (system_supports_sme())
> +			write_sysreg_s(regval & (MPAMSM_EL1_PARTID_D | MPAMSM_EL1_PMG_D),
> +				       SYS_MPAMSM_EL1);

{ } is missed here.

>   		isb();
>   
>   		write_sysreg_s(regval, SYS_MPAM0_EL1);

Thanks,
Gavin

