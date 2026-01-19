Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC49B289367
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 06:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805826; cv=none; b=WH/1Bw/W0vKddErIBWhPkVvsdB40TeuYGlqQr7J0K1k067u9bKwySqQN0g4sCUBQn8jhd1KUSwpUHGCvIEP2idF1IhifNPlHrIM83R/l8ejuS2P86EKmU4UK+wCjrZgb6enzDutPUFMlxG5T13thYI5LFWZjrDIMP6anw+1bZag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805826; c=relaxed/simple;
	bh=aQWBRFtJtLPkK/LkUfhkL/td9DQqg4tFR5gfqj4QI40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gzWLrK7RIhntVUWKNXgGOIdFgx6R/yJMO1N+VGiymGi1yswxHEhhFdKPajY5MyPNaDMVspquf7I98tGl6etWW2qKAkqpA6nyYVm+ShvdJL8AHtLcqyU8V3jld3Sa208VeVetuM5uNvlb5gKA6y3JOai5/rMpkgJg3x1G8QZ5olI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0jHJPkG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0jHJPkG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768805823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7wcPigaqRC6JM0r5LtbYtiW9wo9Ugj074EGL3sYK8Q=;
	b=U0jHJPkG6+xWPdDhp1u4EfyIg0Bm33ocu3hgUK2V9uVfQ/YrXlHZvu+/yEViI4/8naohAx
	pa4fZnB0W051F+4O5xVBCUW1sRDPJCs0hspvlHffydqvF/fekVftvRL+/A75tPdihJCisi
	xZYUi+OXlYEcBIpuS4KKKE+lDIgNrDM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-p7Zs32O5N0iwNbCVvEog8Q-1; Mon, 19 Jan 2026 01:57:02 -0500
X-MC-Unique: p7Zs32O5N0iwNbCVvEog8Q-1
X-Mimecast-MFC-AGG-ID: p7Zs32O5N0iwNbCVvEog8Q_1768805821
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c56848e6f53so2203600a12.0
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 22:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768805821; x=1769410621;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U7wcPigaqRC6JM0r5LtbYtiW9wo9Ugj074EGL3sYK8Q=;
        b=dP6i3exLGt7q4Ur0+Zo0gD2rMudm2VwuqHjavxae5xOW8QgBxv0spiZvv6SB6IqC4a
         9yTp/KKVVUu090G+0Ohd3exTuB/v2VfMPRCBOallm/KCPtMll1y9SJeMGfSjUpJqXoHq
         EknDJEh1mjuIRKKijABdoYz2QOoefkMONFhLv0PGsn4zR8lLiQH1hOSBNu5zZ9v2oVTJ
         gRDucuGK03zpnP+PTV1DueyhkHJSEWNYM7d+PIhkmAyraTJUzJU9s5iWFC79zo/JCYNo
         5JmcMmMIirPiksXV9aoBsisV4sVUfBb3qy+jZBeLef5uMRYs1n6zChPIY7wkP4ONHDNh
         j0oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHvRxgT2XAJE6w4FHscNWJrrEQHtQlFZEv5F+GYWg41j0I75iiSl0dV47VeEkYY5/6cwUsWj0=@lists.linux.dev
X-Gm-Message-State: AOJu0YymgUsJ8+jpX974V/Lh5DzgwEAoFOzasq0vqdsiS8grx5w5YyCy
	JqblUuY3To0ujmwcYgHVHitVb8vwd5pmPodsEHVTaRZo2tMDhrD7Cp24WFXO8+z5q+nsVXgkUG1
	WFJW1j61CH1+0BEUq9fXTIDqmXjMZafeIouhqsRMD5zKNWIsUjc7vQhb2AQ==
X-Gm-Gg: AY/fxX5ONsdbZxzd4mW1BRkRP5PL0NjabRxgCmibbmHKKYTLuTv0oHZ/Is+2+chzAA9
	jjabHnNIVATgTpsyzq6p2NcF8ZSwawGKpotf48GHiFUpoA50FEZWINKq+slyMdHRkc9svSDRUa1
	vNpFAepV5SqQmdYU+RBjjSAn/E96GVENjSSP1DdOTI0BiMN8NblqRWbMXVtCxOVaTnsafnLWmbR
	Tft7p/R9ZaxE2ptXpzpTmj5SSVCaX4oBx7+2Fs8LoyUE5l2JufZfUtTncccGd0Z9hHxjot8JKD1
	fnH5i5zV1FZOM4CDPw2eaXspi/gtyavtCWfAuZoXtrDKwzKcE8rc82OtGgZ1KQ8dkGoqTbej9y+
	YCUc47N9peXw=
X-Received: by 2002:a05:6a00:600b:b0:81f:41c8:765a with SMTP id d2e1a72fcca58-81f9f68fbdfmr10063420b3a.4.1768805821382;
        Sun, 18 Jan 2026 22:57:01 -0800 (PST)
X-Received: by 2002:a05:6a00:600b:b0:81f:41c8:765a with SMTP id d2e1a72fcca58-81f9f68fbdfmr10063416b3a.4.1768805821075;
        Sun, 18 Jan 2026 22:57:01 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa108c4dbsm8361835b3a.5.2026.01.18.22.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 22:57:00 -0800 (PST)
Message-ID: <232cbeeb-1a8c-4b09-9e72-50fc544864b1@redhat.com>
Date: Mon, 19 Jan 2026 14:56:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/47] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
To: Catalin Marinas <catalin.marinas@arm.com>, Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-12-ben.horgan@arm.com> <aWk8aZafbtXx5bPu@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <aWk8aZafbtXx5bPu@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wk7q2eJ_TRexJ0eQAcSRGBmj2UxkKIjeKmxffj0BGDE_1768805821
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/26 3:13 AM, Catalin Marinas wrote:
> On Mon, Jan 12, 2026 at 04:58:38PM +0000, Ben Horgan wrote:
>> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>> +					    u16 partid_d, u16 partid_i,
>> +					    u8 pmg_d, u8 pmg_i)
>> +{
>> +#ifdef CONFIG_ARM64_MPAM
>> +	u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>> +#endif
>> +}
> 
> Isn't this function, together with mpam_thread_switch(), in an enclosing
> #ifdef already?
> 

I think Catalin is correct that this ifdef inside mpam_set_task_partid_pmg()
can be dropped.

>> +
>>   static inline void mpam_thread_switch(struct task_struct *tsk)
>>   {
>>   	u64 oldregval;
>> -- 
>> 2.43.0
>>

Thanks,
Gavin

