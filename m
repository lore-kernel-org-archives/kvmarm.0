Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD5D296BA8
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 07:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768806120; cv=none; b=dMqcvYMRm1zAXlyHxEOgT287hQOeQvAk4RynmzfveNzmg1Dqd+2N8HczlaGet3ZzqNs0MR9Pyl8Zt1lzUHKVMspZm7x9YK9O/eRPeSCvQn+RUjftfmBvKHmfebrvnmeMDUAv6O6ZhpxEWd3e/TX794Ih5vZN+FscNlSXKfzhcLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768806120; c=relaxed/simple;
	bh=/fpSS+eW+Zkt7Np4DBoJ3jAvYqxEfaTyXYAtHPsWTqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VqtilY8PtRfv1F7n2n+qicHZBZt0Qd30eN4EmKPRQn8D7/Hv3iFVdkJ+x/fLKUz/qxnZvMcnx88VRBg1C8dTdlRPGQwFUOdjwLYeHx9iwDaVYnulDvxIJrRoJnw1mkLPcR9766/tZBOyZ6DSp7saXr73ijSmwQ9hXXVdjgg1bdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rb8cfs0v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rb8cfs0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768806117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vdo0qnYDrXLCXtFaJcl+GhOfaYV/uNMOUVAlOziaLwk=;
	b=Rb8cfs0vEFVZU601pFJHTM8hYhpsagscFoxg+BQ47aUkol4xI8kBrhUUH8uj8+JU7Bxa5z
	N8vZbsyyKDg5yje7wBcIMNJSljZ2B/P9bu8ygiC9Ehd9HZe2ranQgwiOu0P9kzLkEoVVBf
	J9RjwqFQYOCHAbVhbLFfECVJyX6CYPI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-ZV4Q1N8xN2G2lWgSEOysUA-1; Mon, 19 Jan 2026 02:01:55 -0500
X-MC-Unique: ZV4Q1N8xN2G2lWgSEOysUA-1
X-Mimecast-MFC-AGG-ID: ZV4Q1N8xN2G2lWgSEOysUA_1768806114
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0d43fcb2fso94176765ad.3
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 23:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768806114; x=1769410914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vdo0qnYDrXLCXtFaJcl+GhOfaYV/uNMOUVAlOziaLwk=;
        b=NiVS+g8s7ZHqET1TLBo6nqOElizDY8CoX23BkKNon8nHNgsfxyxHiKzLWdrhxY8wLO
         ApBnhgaSusDYrdLpE2VKUv3uYVi9ifyBZkADgSpIABxEMLQxE7kqk7wQLxU5bjcelzSt
         CE6sUG7fAGgxtBmzPA6G2IDJ0GdIy8vAtBo9ITnz6Sjc/Q1oa0UMImVceqXIqzyCQ2Tj
         PMqaBJdNp9FKdmxWk9BZhrCdf95+0z2KCQhXRlJFu3XKHQs4OK7C154AXCiDF0rKAUGL
         m17UY6Btj/4JUZ7l6JrxCKYSqG5+oIflirPTIxq2tcSxgKOVM+p/G0GCR6bfxxRBr+q9
         7nvA==
X-Forwarded-Encrypted: i=1; AJvYcCWvxIK0z0lLKLl2NZQ4cxux5k2qG+kumoqvH3ouFCcL4k3dlKxsBH4AW799y7Mebms4h4AAFZ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGkJfm/whG7xQZ1TxbvERLCqm0sfZQaoEZnxEiZGeVk2X2zAW6
	GPGWCFemC6xOScGhvgGlDdDDkjCVGdwcuh7qeJPWHuwe3VvEqzJ7i7QKM66Is7Acj4NSUwggdYR
	apeZ0LnaN6a/IDci6Jhxpu8rG6F+iBGELlyokSr1EKRvtvkhAJbIIU/nwKw==
X-Gm-Gg: AZuq6aJsg3vF8W8388KnKuav13JpVLLT3lhXdUXNSeNWrfqbKAshYp5vFY4UPkQ0mTl
	lPQ+WRL5zs6Px5RpR2f+KLMU8TCAmHZ5HsoszJysgK9Rax2zjW8sRkHL0Udm6C43bCn/aaAzJro
	oVVrSUeV2bzulJx2TJOLEPw8Md0zrwYcawY75z3X/kRkkncRkXrnSeRxpUT/5iw8MbXib0itMj3
	jMTRN/C1Rx3MA1bI23ROrT8lbf5ymTjxgK5+bwkymHi5r41OtfE3u4CswPLfVp0OSbnQBBxem9i
	ab4C0BZnUM+NkYIlj528TV2004V0/+1Ze5ZDiC7J2klXnf21AhatLnvhOPNOqmgVzbbDKJwwguv
	xvQU1EmoXHJo=
X-Received: by 2002:a17:903:2f82:b0:2a5:8c95:d823 with SMTP id d9443c01a7336-2a717529fcbmr87592455ad.10.1768806114235;
        Sun, 18 Jan 2026 23:01:54 -0800 (PST)
X-Received: by 2002:a17:903:2f82:b0:2a5:8c95:d823 with SMTP id d9443c01a7336-2a717529fcbmr87592265ad.10.1768806113791;
        Sun, 18 Jan 2026 23:01:53 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190ab9cbsm85652905ad.14.2026.01.18.23.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 23:01:53 -0800 (PST)
Message-ID: <57a015c3-9a4b-478b-8cb6-6c61f84c0b74@redhat.com>
Date: Mon, 19 Jan 2026 15:01:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/47] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
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
 <20260112165914.4086692-12-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-12-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RUJLsxa-qhnRmyEvXnEu_CzgIxAUl8bUc_cZf2DAJX4_1768806114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Care must be taken when modifying the PARTID and PMG of a task in any
> per-task structure as writing these values may race with the task being
> scheduled in, and reading the modified values.
> 
> Add helpers to set the task properties, and the CPU default value.  These
> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
> avoid causing torn values.
> 
> CC: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Keep comment attached to mpam_get_regval()
> Add internal helper, __mpam_regval() (Jonathan)
> ---
>   arch/arm64/include/asm/mpam.h | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 7b3d3abad162..c9b73f1af7ce 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -4,6 +4,7 @@
>   #ifndef __ASM__MPAM_H
>   #define __ASM__MPAM_H
>   
> +#include <linux/bitfield.h>
>   #include <linux/jump_label.h>
>   #include <linux/percpu.h>
>   #include <linux/sched.h>
> @@ -22,6 +23,22 @@ DECLARE_PER_CPU(u64, arm64_mpam_current);
>    */
>   extern u64 arm64_mpam_global_default;
>   
> +static inline u64 __mpam_regval(u16 partid_d, u16 partid_i, u8 pmg_d, u8 pmg_i)
> +{
> +	return FIELD_PREP(MPAM0_EL1_PARTID_D, partid_d) |
> +		FIELD_PREP(MPAM0_EL1_PARTID_I, partid_i) |
> +		FIELD_PREP(MPAM0_EL1_PMG_D, pmg_d) |
> +		FIELD_PREP(MPAM0_EL1_PMG_I, pmg_i);
> +}

Nitpick: Alignment issues in the lines for 2nd/3rd/4th FIELD_PREP().

	return FIELD_PREP(...) |
	       FIELD_PREP(...) |
                FIELD_PREP(...) |
                FIELD_PREP(...);

> +
> +static inline void mpam_set_cpu_defaults(int cpu, u16 partid_d, u16 partid_i,
> +					 u8 pmg_d, u8 pmg_i)
> +{
> +	u64 default_val = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
> +
> +	WRITE_ONCE(per_cpu(arm64_mpam_default, cpu), default_val);
> +}
> +

per_cpu(arm64_mpam_default) won't be reachable until CONFIG_ARM64_MPAM is set.
So I think both mpam_set_cpu_defaults() and __mpam_regval() need to be protected
by '#ifdef CONFIG_ARM64_MPAM ... #endif'.

>   /*
>    * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
>    * which may race with reads in mpam_thread_switch(). Ensure only one of the old
> @@ -36,6 +53,17 @@ static inline u64 mpam_get_regval(struct task_struct *tsk)
>   	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
>   }
>   
> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
> +					    u16 partid_d, u16 partid_i,
> +					    u8 pmg_d, u8 pmg_i)
> +{
> +#ifdef CONFIG_ARM64_MPAM
> +	u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
> +
> +	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
> +#endif
> +}
> +
>   static inline void mpam_thread_switch(struct task_struct *tsk)
>   {
>   	u64 oldregval;

Thanks,
Gavin

