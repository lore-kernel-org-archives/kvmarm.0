Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF402BE02A
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 04:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774241119; cv=none; b=JW5xL5syup9TTAioG3LeLD5mK52Da9WOxmidtYAklbV/Fwj9J1+R31iY6Ns2viyb9x1XCeXlFCgXSsECAQZtP1CTUm9hYT0TSyw3JhRGHvzvT/c8U97pHiLI1WjdZ8dCg+lcICogCNXytrFHQyJedJTzmSJqpgG7s+P4drZl4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774241119; c=relaxed/simple;
	bh=TlyCAWysWztqJphkgOF0JdYCt4KjGxEf6BKnZUwtClo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l5Csacw3BdHkcStpOrRUTwqhLl5XtlpO4GKG0o5nDwdg5ZiglIbmSLZEYbhjBAtshMbhPwTHT+BjU2SaNBzZ6+XgjyP1BdiIcK3fl+xUi7KQCpEnfiEyc49lXbx2MIqj+5CHbrR8S9Pl1MVSBEtfVGFAk4x+G5liIiJrzHHjkH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h4j8EBJ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4j8EBJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774241116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKHlNzVZ8flcJLfDOJhZcXKBIi7eEiUriVf/nusyPOU=;
	b=h4j8EBJ2Q0jjsMF1OWm8xLJOlcfQCKPYsEV0SwZMYNmakNZEJnjkWsii6KVjSCfD+oG7JV
	GcgvUGaDSDim/nooV6zeB95P02jvAUKEJppxyUXEKttA5QbB3d/KkqvIEog7Mf2zGY+sgl
	UPX+/v12Dmdc5VkaXBRXs5Jojvqvrm0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-jN4TmvCbMN2ibL1WIUEAgg-1; Mon, 23 Mar 2026 00:45:13 -0400
X-MC-Unique: jN4TmvCbMN2ibL1WIUEAgg-1
X-Mimecast-MFC-AGG-ID: jN4TmvCbMN2ibL1WIUEAgg_1774241112
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aed1beaa73so49104945ad.2
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 21:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774241112; x=1774845912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tKHlNzVZ8flcJLfDOJhZcXKBIi7eEiUriVf/nusyPOU=;
        b=eWmq0eSds1yKydKFtFgkL7Aus8UeI91VSuT6LTkwj3c8wFNUj9eKU0jZXSEdAMBDqk
         SZQg0iPZ0gnHaSBW9a7D17yHfoOk0e4GiTY96RSxIhToeaWyzstz4n91YkIcjrlvyJ9a
         Y51t/1aqu1w0keUnfhL2ObYD/2JkiV0b3MMcCcGNpEB8kM7V7qQX6bSrT9zK1PLklouN
         JkuLTjd6lQ+fuyGRqBpguF2OG6pOv/KwupARitKHhXyUSFs/bUz5rsyxWI8gkaw3/zym
         yAZhsDivu9u+wvrgO3lhvc+Z/01enLjEDdHpixqLf2Ffkp7FTD/b7XiubYpN3JwmGGGR
         wr2A==
X-Forwarded-Encrypted: i=1; AJvYcCURV1DVkS/KpS5lfVdGk5SB3+QM8V5Po+bwiK4NIdGlENQnTdRPIoL6Unu12SHNVVlosDPX4HU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzD+B6b0oIPDPHCy0cfOqoP2wyfzOCmGsbnHNuHcRlGS6mtely
	F5bTMa8rserqywmRWHmqTmCdAhyt3JK2/R2c6HAbA807UQkFi5cssPu1yf5kh3PD5CwkU7Mn47w
	kttGYTUhkThsQyUdpV/5xKV0L65gwwz7bHul1MVnh528VCVAeY+Ob6gSIUg==
X-Gm-Gg: ATEYQzzBLvMhxg7JWIzpNa/HloQeoK1MmYPiQGB9paCCfTGao+RFDf1OQb1B1AvqjNS
	SHZo5ovwwb+CtjKEO2gpB9rkJQfd1Qmtmtcqb2qpJUQTKi5YnUuDrNu37cO5D1H1xVS0Pc8sz6d
	vPxNs4VGbBGar1p7Tawd6v2LwzMg3Tv1NiAoUSjDImLR54UpwRb3Au5Ky/UYvXG0ja8T+nwYVOC
	HwT9z50TFt/QK6kF61lx1Lx+ajAH3MyHrJlJQsuj2/+9rFljiCsn1bhDF5A/SU3KJJOkzYJaZy9
	vkDI3Xi14OfN781c8bthG1W0lNXv52AXAylyuXBmggkO5V4YkL2Qh+UGPhAWXDsFZBC8MKgHLsq
	OCxmbLrHB4OzV9Ib9ywbQV9BDaq4U2DUOpCOI+muhv270Jtc9gqsoTd+6YKoMINwL
X-Received: by 2002:a17:903:244f:b0:2ae:6192:8d78 with SMTP id d9443c01a7336-2b0826c7097mr103436005ad.1.1774241112003;
        Sun, 22 Mar 2026 21:45:12 -0700 (PDT)
X-Received: by 2002:a17:903:244f:b0:2ae:6192:8d78 with SMTP id d9443c01a7336-2b0826c7097mr103435595ad.1.1774241111581;
        Sun, 22 Mar 2026 21:45:11 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08369e41csm96333595ad.74.2026.03.22.21.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 21:45:11 -0700 (PDT)
Message-ID: <35f92bc8-1eb1-43a0-bed2-aaac87a61c19@redhat.com>
Date: Mon, 23 Mar 2026 14:44:58 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/40] arm_mpam: Reset when feature configuration bit
 unset
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
 <20260313144617.3420416-3-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-3-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ClNu0GcLVEzPhiJ6vyNSddR-nNl7IThNLLZ9n13Y4eU_1774241112
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> To indicate that the configuration, of the controls used by resctrl, in a
> RIS need resetting to driver defaults the reset flags in mpam_config are
> set. However, these flags are only ever set temporarily at RIS scope in
> mpam_reset_ris() and hence mpam_cpu_online() will never reset these
> controls to default. As the hardware reset is unknown this leads to unknown
> configuration when the control values haven't been configured away from the
> defaults.
> 
> Use the policy that an unset feature configuration bit means reset. In this
> way the mpam_config in the component can encode that it should be in reset
> state and mpam_reprogram_msc() will reset controls as needed.
> 
> Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> This goes back to the initial feature configuration policy that James
> used in the MPAM base driver rfc but I unfortunately
> suggested him to change it.
> ---
>   drivers/resctrl/mpam_devices.c | 40 ++++++++++------------------------
>   1 file changed, 12 insertions(+), 28 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

